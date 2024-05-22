{-
 Copyright 2022-23, Juspay India Pvt Ltd

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License

 as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program

 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY

 or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details. You should have received a copy of

 the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
-}
{-# LANGUAGE ApplicativeDo #-}

module Domain.Action.UI.DriverOnboarding.Image where

import AWS.S3 as S3
import qualified Data.ByteString as BS
import qualified Data.Text as T hiding (length)
import Data.Time.Format.ISO8601
import qualified Domain.Types.DocumentVerificationConfig as DVC
import qualified Domain.Types.Image as Domain
import qualified Domain.Types.Merchant as DM
import qualified Domain.Types.MerchantOperatingCity as DMOC
import qualified Domain.Types.Person as Person
import qualified Domain.Types.Vehicle as Vehicle
import qualified Domain.Types.VehicleRegistrationCertificate as DVRC
import Environment
import qualified EulerHS.Language as L
import EulerHS.Types (base64Encode)
import Kernel.External.Encryption (decrypt)
import Kernel.Prelude
import Kernel.Types.Common
import qualified Kernel.Types.Documents as Documents
import Kernel.Types.Error
import Kernel.Types.Id
import Kernel.Utils.Common
import Servant.Multipart
import SharedLogic.DriverOnboarding
import Storage.Cac.TransporterConfig
import qualified Storage.CachedQueries.DocumentVerificationConfig as CQDVC
import qualified Storage.CachedQueries.Merchant as CQM
import qualified Storage.Queries.DriverRCAssociation as QDRCA
import qualified Storage.Queries.FleetRCAssociationExtra as FRCA
import qualified Storage.Queries.Image as Query
import qualified Storage.Queries.Person as Person
import qualified Storage.Queries.VehicleRegistrationCertificate as QRC
import Tools.Error
import qualified Tools.Verification as Verification
import Utils.Common.Cac.KeyNameConstants

data ImageValidateRequest = ImageValidateRequest
  { image :: Text,
    imageType :: DVC.DocumentType,
    rcNumber :: Maybe Text, -- for PUC, Permit, Insurance and Fitness
    vehicleCategory :: Maybe Vehicle.Category
  }
  deriving (Generic, ToSchema, ToJSON, FromJSON)

data ImageValidateFileRequest = ImageValidateFileRequest
  { image :: FilePath,
    imageType :: DVC.DocumentType,
    rcNumber :: Maybe Text -- for PUC, Permit, Insurance and Fitness
  }
  deriving (Generic, ToSchema, ToJSON, FromJSON)

instance FromMultipart Tmp ImageValidateFileRequest where
  fromMultipart form = do
    ImageValidateFileRequest
      <$> fmap fdPayload (lookupFile "image" form)
      <*> fmap (read . T.unpack) (lookupInput "imageType" form)
      <*> parseMaybeInput "rcNumber" form

parseMaybeInput :: Read b => Text -> MultipartData tag -> Either String (Maybe b)
parseMaybeInput fieldName form = case lookupInput fieldName form of
  Right val -> Right $ readMaybe (T.unpack val)
  Left _ -> Right Nothing

newtype ImageValidateResponse = ImageValidateResponse
  {imageId :: Id Domain.Image}
  deriving (Generic, ToSchema, ToJSON, FromJSON)

data GetDocsResponse = GetDocsResponse
  { dlImage :: Maybe Text,
    rcImage :: Maybe Text
  }
  deriving (Generic, ToSchema, ToJSON, FromJSON)

createPath ::
  (MonadTime m, MonadReader r m, HasField "s3Env" r (S3Env m)) =>
  Text ->
  Text ->
  DVC.DocumentType ->
  m Text
createPath driverId merchantId documentType = do
  pathPrefix <- asks (.s3Env.pathPrefix)
  now <- getCurrentTime
  let fileName = T.replace (T.singleton ':') (T.singleton '-') (T.pack $ iso8601Show now)
  return
    ( pathPrefix <> "/driver-onboarding/" <> "org-" <> merchantId <> "/"
        <> driverId
        <> "/"
        <> show documentType
        <> "/"
        <> fileName
        <> ".png"
    )

validateImage ::
  Bool ->
  (Id Person.Person, Id DM.Merchant, Id DMOC.MerchantOperatingCity) ->
  ImageValidateRequest ->
  Flow ImageValidateResponse
validateImage isDashboard (personId, _, merchantOpCityId) ImageValidateRequest {..} = do
  person <- Person.findById personId >>= fromMaybeM (PersonNotFound personId.getId)
  let merchantId = person.merchantId
  org <- CQM.findById merchantId >>= fromMaybeM (MerchantNotFound merchantId.getId)

  let rcDependentDocuments = [DVC.VehiclePUC, DVC.VehiclePermit, DVC.VehicleInsurance, DVC.VehicleFitnessCertificate]
  mbRcId <-
    if imageType `elem` rcDependentDocuments
      then case rcNumber of
        Just rcNo -> do
          rc <- QRC.findLastVehicleRCWrapper rcNo >>= fromMaybeM (RCNotFound rcNo)
          case person.role of
            Person.FLEET_OWNER -> do
              fleetAssoc <- FRCA.findLatestByRCIdAndFleetOwnerId rc.id personId
              when (isNothing fleetAssoc) $ throwError RCNotLinkedWithFleet
              return $ Just rc.id
            _ -> do
              mbAssoc <- QDRCA.findLatestByRCIdAndDriverId rc.id personId
              when (isNothing mbAssoc) $ throwError RCNotLinked
              return $ Just rc.id
        Nothing -> throwError $ RCMandatory (show imageType)
      else return Nothing

  unless isDashboard $ do
    images <- Query.findRecentByPersonIdAndImageType personId imageType
    transporterConfig <- findByMerchantOpCityId merchantOpCityId (Just (DriverId (cast personId))) >>= fromMaybeM (TransporterConfigNotFound merchantOpCityId.getId)
    let onboardingTryLimit = transporterConfig.onboardingTryLimit
    when (length images > onboardingTryLimit) $ do
      -- not needed now
      driverPhone <- mapM decrypt person.mobileNumber
      notifyErrorToSupport person org.id merchantOpCityId driverPhone org.name ((.failureReason) <$> images)
      throwError (ImageValidationExceedLimit personId.getId)

  imagePath <- createPath personId.getId merchantId.getId imageType
  void $ fork "S3 Put Image" $ S3.put (T.unpack imagePath) image
  imageEntity <- mkImage personId merchantId imagePath imageType mbRcId
  Query.create imageEntity

  -- skipping validation for rc as validation not available in idfy
  docConfigs <- CQDVC.findByMerchantOpCityIdAndDocumentTypeAndCategory merchantOpCityId imageType (fromMaybe Vehicle.CAR vehicleCategory)
  if maybe True (.isImageValidationRequired) docConfigs
    then do
      validationOutput <-
        Verification.validateImage merchantId merchantOpCityId $
          Verification.ValidateImageReq {image, imageType = castImageType imageType, driverId = person.id.getId}
      when validationOutput.validationAvailable $ do
        checkErrors imageEntity.id imageType validationOutput.detectedImage
      Query.updateVerificationStatus Documents.VALID imageEntity.id
    else Query.updateVerificationStatus Documents.MANUAL_VERIFICATION_REQUIRED imageEntity.id
  return $ ImageValidateResponse {imageId = imageEntity.id}
  where
    checkErrors id_ _ Nothing = throwImageError id_ ImageValidationFailed
    checkErrors id_ imgType (Just detectedImage) = do
      let outputImageType = detectedImage.imageType
      unless (outputImageType == castImageType imgType) $ throwImageError id_ (ImageInvalidType (show imgType) (show outputImageType))

      unless (fromMaybe False detectedImage.isReadable) $ throwImageError id_ ImageNotReadable

      unless (maybe False (60 <) detectedImage.confidence) $
        throwImageError id_ ImageLowQuality

castImageType :: DVC.DocumentType -> Verification.ImageType
castImageType DVC.DriverLicense = Verification.DriverLicense
castImageType DVC.VehicleRegistrationCertificate = Verification.VehicleRegistrationCertificate
castImageType DVC.VehiclePermit = Verification.VehiclePermit
castImageType DVC.VehiclePUC = Verification.VehiclePUC
castImageType DVC.VehicleInsurance = Verification.VehicleInsurance
castImageType DVC.VehicleFitnessCertificate = Verification.VehicleFitnessCertificate
castImageType _ = Verification.VehicleRegistrationCertificate -- Fix Later

validateImageFile ::
  Bool ->
  (Id Person.Person, Id DM.Merchant, Id DMOC.MerchantOperatingCity) ->
  ImageValidateFileRequest ->
  Flow ImageValidateResponse
validateImageFile isDashboard (personId, merchantId, merchantOpCityId) ImageValidateFileRequest {..} = do
  image' <- L.runIO $ base64Encode <$> BS.readFile image
  validateImage isDashboard (personId, merchantId, merchantOpCityId) $ ImageValidateRequest image' imageType rcNumber Nothing

mkImage ::
  (MonadFlow m, EncFlow m r, EsqDBFlow m r, CacheFlow m r) =>
  Id Person.Person ->
  Id DM.Merchant ->
  Text ->
  DVC.DocumentType ->
  Maybe (Id DVRC.VehicleRegistrationCertificate) ->
  m Domain.Image
mkImage personId_ merchantId s3Path documentType_ mbRcId = do
  id <- generateGUID
  now <- getCurrentTime
  return $
    Domain.Image
      { id,
        personId = personId_,
        merchantId,
        s3Path,
        imageType = documentType_,
        verificationStatus = Just Documents.PENDING,
        failureReason = Nothing,
        rcId = getId <$> mbRcId,
        createdAt = now,
        updatedAt = now
      }

getImage :: Id DM.Merchant -> Id Domain.Image -> Flow Text
getImage merchantId imageId = do
  imageMetadata <- Query.findById imageId
  case imageMetadata of
    Just img | img.merchantId == merchantId -> S3.get $ T.unpack img.s3Path
    _ -> pure T.empty

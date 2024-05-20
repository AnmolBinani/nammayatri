{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Storage.Queries.TransporterConfigExtra where

import qualified Data.Aeson as A
import Domain.Types.Location (dummyFromLocationData, dummyToLocationData)
import Domain.Types.MerchantOperatingCity
import Domain.Types.TransporterConfig
import Kernel.Beam.Functions
import qualified Kernel.External.Notification.FCM.Types as FCM
import Kernel.Prelude
import Kernel.Types.Id
import Kernel.Utils.Common
import qualified Sequelize as Se
import qualified Storage.Beam.TransporterConfig as BeamTC
import Storage.Queries.OrphanInstances.TransporterConfig

updateFCMConfig :: (MonadFlow m, EsqDBFlow m r, CacheFlow m r) => Id MerchantOperatingCity -> BaseUrl -> Text -> m ()
updateFCMConfig (Id merchantOperatingCityId) fcmUrl fcmServiceAccount = do
  now <- getCurrentTime
  updateOneWithKV
    [ Se.Set BeamTC.fcmUrl $ showBaseUrl fcmUrl,
      Se.Set BeamTC.fcmServiceAccount fcmServiceAccount,
      Se.Set BeamTC.updatedAt now
    ]
    [Se.Is BeamTC.merchantOperatingCityId (Se.Eq merchantOperatingCityId)]

updateReferralLinkPassword :: (MonadFlow m, EsqDBFlow m r, CacheFlow m r) => Id MerchantOperatingCity -> Text -> m ()
updateReferralLinkPassword (Id merchantOperatingCityId) newPassword = do
  now <- getCurrentTime
  updateOneWithKV
    [ Se.Set BeamTC.referralLinkPassword newPassword,
      Se.Set BeamTC.updatedAt now
    ]
    [Se.Is BeamTC.merchantOperatingCityId (Se.Eq merchantOperatingCityId)]

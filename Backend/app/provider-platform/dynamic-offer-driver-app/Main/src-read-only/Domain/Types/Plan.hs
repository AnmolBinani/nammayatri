{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-dodgy-exports #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Domain.Types.Plan (module Domain.Types.Plan, module ReExport) where

import Data.Aeson
import Domain.Types.Extra.Plan as ReExport
import qualified Domain.Types.Extra.Plan
import qualified Domain.Types.Merchant
import qualified Domain.Types.MerchantOperatingCity
import qualified Domain.Types.Vehicle
import qualified Kernel.Beam.Lib.UtilsTH
import Kernel.Prelude
import qualified Kernel.Types.Common
import qualified Kernel.Types.Id
import qualified Kernel.Utils.TH
import qualified Tools.Beam.UtilsTH

data Plan = Plan
  { basedOnEntity :: Domain.Types.Plan.BasedOnEntity,
    cgstPercentage :: Kernel.Types.Common.HighPrecMoney,
    description :: Kernel.Prelude.Text,
    eligibleForCoinDiscount :: Kernel.Prelude.Bool,
    freeRideCount :: Kernel.Prelude.Int,
    frequency :: Domain.Types.Plan.Frequency,
    id :: Kernel.Types.Id.Id Domain.Types.Plan.Plan,
    isDeprecated :: Kernel.Prelude.Bool,
    isOfferApplicable :: Kernel.Prelude.Bool,
    maxAmount :: Kernel.Types.Common.HighPrecMoney,
    maxCreditLimit :: Kernel.Types.Common.HighPrecMoney,
    maxMandateAmount :: Kernel.Types.Common.HighPrecMoney,
    merchantId :: Kernel.Types.Id.Id Domain.Types.Merchant.Merchant,
    merchantOpCityId :: Kernel.Types.Id.Id Domain.Types.MerchantOperatingCity.MerchantOperatingCity,
    name :: Kernel.Prelude.Text,
    paymentMode :: Domain.Types.Plan.PaymentMode,
    planBaseAmount :: Domain.Types.Extra.Plan.PlanBaseAmount,
    planType :: Domain.Types.Plan.PlanType,
    registrationAmount :: Kernel.Types.Common.HighPrecMoney,
    serviceName :: Domain.Types.Plan.ServiceNames,
    sgstPercentage :: Kernel.Types.Common.HighPrecMoney,
    subscribedFlagToggleAllowed :: Kernel.Prelude.Bool,
    vehicleVariant :: Kernel.Prelude.Maybe Domain.Types.Vehicle.Variant
  }
  deriving (Generic, Show, ToJSON, FromJSON, ToSchema)

data BasedOnEntity = RIDE | NONE | VEHICLE | VEHICLE_AND_RIDE deriving (Show, Eq, Ord, Read, Generic, ToJSON, FromJSON, ToSchema, ToParamSchema)

data Frequency = DAILY | WEEKLY | MONTHLY deriving (Show, Eq, Ord, Read, Generic, ToJSON, FromJSON, ToSchema, ToParamSchema)

data PaymentMode = MANUAL | AUTOPAY deriving (Show, Eq, Ord, Read, Generic, ToJSON, FromJSON, ToSchema, ToParamSchema)

data PlanType = DEFAULT | SUBSCRIPTION deriving (Show, Eq, Ord, Read, Generic, ToJSON, FromJSON, ToSchema, ToParamSchema)

data ServiceNames = YATRI_SUBSCRIPTION | YATRI_RENTAL deriving (Show, Eq, Ord, Read, Generic, ToJSON, FromJSON, ToSchema, ToParamSchema)

$(Kernel.Beam.Lib.UtilsTH.mkBeamInstancesForEnumAndList ''PaymentMode)

$(Kernel.Utils.TH.mkHttpInstancesForEnum ''PaymentMode)

$(Kernel.Beam.Lib.UtilsTH.mkBeamInstancesForEnumAndList ''Frequency)

$(Kernel.Utils.TH.mkHttpInstancesForEnum ''Frequency)

$(Kernel.Beam.Lib.UtilsTH.mkBeamInstancesForEnumAndList ''PlanType)

$(Kernel.Utils.TH.mkHttpInstancesForEnum ''PlanType)

$(Kernel.Beam.Lib.UtilsTH.mkBeamInstancesForEnumAndList ''BasedOnEntity)

$(Kernel.Utils.TH.mkHttpInstancesForEnum ''BasedOnEntity)

$(Kernel.Beam.Lib.UtilsTH.mkBeamInstancesForEnumAndList ''ServiceNames)

$(Kernel.Utils.TH.mkHttpInstancesForEnum ''ServiceNames)

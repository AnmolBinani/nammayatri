{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Storage.Beam.PurchaseHistory where

import qualified Database.Beam as B
import qualified Kernel.Beam.Lib.UtilsTH
import Kernel.External.Encryption
import Kernel.Prelude
import qualified Kernel.Prelude
import qualified Kernel.Types.Common
import Tools.Beam.UtilsTH

data PurchaseHistoryT f = PurchaseHistoryT
  { cash :: (B.C f Kernel.Types.Common.HighPrecMoney),
    createdAt :: (B.C f Kernel.Prelude.UTCTime),
    driverId :: (B.C f Kernel.Prelude.Text),
    id :: (B.C f Kernel.Prelude.Text),
    merchantId :: (B.C f Kernel.Prelude.Text),
    merchantOptCityId :: (B.C f Kernel.Prelude.Text),
    numCoins :: (B.C f Kernel.Prelude.Int),
    title :: (B.C f Kernel.Prelude.Text),
    updatedAt :: (B.C f Kernel.Prelude.UTCTime)
  }
  deriving (Generic, B.Beamable)

instance B.Table PurchaseHistoryT where
  data PrimaryKey PurchaseHistoryT f = PurchaseHistoryId (B.C f Kernel.Prelude.Text) deriving (Generic, B.Beamable)
  primaryKey = PurchaseHistoryId . id

type PurchaseHistory = PurchaseHistoryT Identity

$(enableKVPG (''PurchaseHistoryT) [('id)] [[('driverId)]])

$(Kernel.Beam.Lib.UtilsTH.mkTableInstances (''PurchaseHistoryT) "coin_purchase_history" "atlas_driver_offer_bpp")

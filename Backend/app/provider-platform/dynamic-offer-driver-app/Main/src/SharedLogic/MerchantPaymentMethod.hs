{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-dodgy-exports #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module SharedLogic.MerchantPaymentMethod where

import Data.Aeson.Types
import qualified Data.List as List
import Domain.Types.Merchant (Merchant)
import Domain.Types.MerchantOperatingCity
import Domain.Types.MerchantPaymentMethod
import Kernel.Prelude
import Kernel.Types.Id
import qualified Text.Show

mkPaymentMethodInfo :: MerchantPaymentMethod -> PaymentMethodInfo
mkPaymentMethodInfo MerchantPaymentMethod {..} = PaymentMethodInfo {..}

getPostpaidPaymentUrl :: MerchantPaymentMethod -> Maybe Text
getPostpaidPaymentUrl mpm = do
  if mpm.paymentType == ON_FULFILLMENT && mpm.collectedBy == BPP && mpm.paymentInstrument /= Cash
    then Just $ mkDummyPaymentUrl mpm
    else Nothing

mkDummyPaymentUrl :: MerchantPaymentMethod -> Text
mkDummyPaymentUrl MerchantPaymentMethod {..} = do
  "payment_link_for_paymentInstrument="
    <> show paymentInstrument
    <> ";collectedBy="
    <> show collectedBy
    <> ";paymentType="
    <> show paymentType

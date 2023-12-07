module MerchantConfig.Types where

import Common.Types.App (CityConfig)

type AppConfig =
  {
    primaryTextColor :: String,
    primaryBackground :: String,
    fontType :: String,
    languageList :: Array Language,
    popupBackground :: String,
    defaultLanguage :: String,
    imageUploadOptional :: Boolean,
    rideCompletedCardConfig :: RideCompletedCardConfig, 
    leaderBoard :: LeaderBoard,
    subscriptionConfig :: SubscriptionConfig,
    rideActionModelConfig :: RideActionModelConfig,
    profile :: ProfileConfig,
    showPaymentDetails :: Boolean,
    gotoConfig :: GotoConfig,
    profileVerification :: ProfileVerificationConfig,
    bottomNavConfig :: BottomNavConfig,
    purpleRideConfig :: PurpleRideConfig,
    mapConfig :: MapConfig,
    waitTimeConfig :: WaitTimeConfig,
    cityConfig :: Array CityConfig,
    unserviceableThreshold :: Number,
    enableMockLocation :: Boolean,
    features :: Features,
    flowConfig :: FlowConfig,
    permissions :: PermissionsConfig,
    homeScreen :: HomeScreenConfig
  } 

type PurpleRideConfig = {
  showPurpleVideos :: Boolean,
  visualImpairmentVideo :: String,
  physicalImpairmentVideo :: String,
  hearingImpairmentVideo :: String,
  genericAccessibilityVideo :: String
  }

type Features = {
  enableSuggestions :: Boolean
}

type Language =  {
  name :: String,
  value :: String,
  subtitle :: String
 }

type LeaderBoard = {
  isMaskedName :: Boolean
}

type ProfileVerificationConfig = {
  aadharVerificationRequired :: Boolean
}

type SubscriptionConfig =  {
  enableBlocking :: Boolean,
  completePaymentPopup :: Boolean,
  onBoardingSubscription :: Boolean,
  showLaterButtonforTimeRange :: Boolean,
  offerBannerConfig :: SubscriptionOfferBannerConfig,
  lowDuesLimit :: Number,
  maxDuesLimit :: Number,
  highDueWarningLimit :: Number,
  moveDriverToOfflineInHighDueDaily :: Boolean,
  enableSubscriptionPopups :: Boolean,
  faqLink :: String,
  supportNumber :: String,
  whatsappSupportLink :: String,
  myPlanYoutubeLink :: String,
  overlayYoutubeLink :: String,
  enableIntroductoryView :: Boolean,
  optionsMenuItems :: SubscriptionOptionsMenuItems,
  gradientConfig :: Array GradientConfig,
  enableSubscriptionSupportPopup :: Boolean,
  earnAmountInADay :: Int,
  showFeeBreakup :: Boolean
 }

type SubscriptionOfferBannerConfig = {
  showDUOfferBanner :: Boolean,
  offerBannerValidTill :: String,
  offerBannerDeadline :: String,
  offerBannerPlans :: Array String
}

type SubscriptionOptionsMenuItems = {
  managePlan :: Boolean,
  paymentHistory :: Boolean,
  viewFaqs :: Boolean,
  callSupport :: Boolean,
  chatSupport :: Boolean,
  kioskLocation :: Boolean,
  viewAutopayDetails :: Boolean
}

type GradientConfig = {
  id :: String,
  colors :: Array String
}

type RideActionModelConfig = {
  showVehicleVariant :: Boolean
}

type RideCompletedCardConfig = {
  showSavedCommission :: Boolean
}

type ProfileConfig = {
  bookingOptionMenuForTaxi :: Boolean
}

type GotoConfig = {
  maxGotoLocations :: Int,
  enableGoto :: Boolean
}

type BottomNavConfig = {
  home :: BottomNavItemConfig,
  rideHistory :: BottomNavItemConfig,
  subscription :: BottomNavItemConfig,
  referral :: BottomNavItemConfig,
  notifications :: BottomNavItemConfig
}

type BottomNavItemConfig = {
  showNew :: Boolean,
  isVisible :: Boolean
}

type MapConfig = {
  animationDuration :: Int
}

type WaitTimeConfig = {
  enableWaitTime :: Boolean,
  thresholdDist :: Number,
  thresholdTime :: Int
}

type FlowConfig = {
  chooseCity :: ChooseCityFlowConfig
}

type ChooseCityFlowConfig = {
  runFlow :: Boolean,
  defCity :: String
}

type PermissionsConfig = {
  locationPermission :: Boolean,
  notification :: Boolean
}

type HomeScreenConfig = {
  specialRideOtpView :: Boolean,
  showGenderBanner :: Boolean
}
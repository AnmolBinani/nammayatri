{-

  Copyright 2022-23, Juspay India Pvt Ltd

  This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License

  as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program

  is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY

  or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details. You should have received a copy of

  the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
-}

module Screens.HomeScreen.View where

import Accessor (_lat, _lon, _selectedQuotes, _fareProductType)
import Animation (fadeInWithDelay, fadeIn, fadeOut, translateYAnimFromTop, scaleAnim, translateYAnimFromTopWithAlpha , translateInXAnim, translateOutXAnim, translateInXForwardAnim, translateOutXBackwardAnimY, translateInXSidebarAnim, screenAnimation, fadeInWithDuration, fadeOutWithDuration, scaleYAnimWithDelay, shimmerAnimation)
import Animation.Config (Direction(..), translateFullYAnimWithDurationConfig, translateYAnimHomeConfig, messageInAnimConfig, messageOutAnimConfig)
import Common.Types.App (LazyCheck(..), YoutubeData, CarouselData)
import Components.Banner.Controller as BannerConfig
import Components.ChooseVehicle as ChooseVehicle
import Components.Banner.View as Banner
import Components.Banner.View as Banner
import Components.MessagingView as MessagingView
import Components.ChooseYourRide as ChooseYourRide 
import Components.DriverInfoCard as DriverInfoCard
import Components.EmergencyHelp as EmergencyHelp
import Components.ErrorModal as ErrorModal
import Components.FavouriteLocationModel as FavouriteLocationModel
import Components.LocationListItem.View as LocationListItem
import Components.LocationTagBar as LocationTagBar
import Components.LocationTagBarV2 as LocationTagBarV2
import Components.MenuButton as MenuButton
import Components.PopUpModal as PopUpModal
import Components.RideCompletedCard as RideCompletedCard
import Components.PricingTutorialModel as PricingTutorialModel
import Components.PrimaryButton as PrimaryButton
import Screens.NammaSafetyFlow.Components.ContactCircle as ContactCircle
import Components.QuoteListModel.View as QuoteListModel
import Components.RateCard as RateCard
import Components.RatingCard as RatingCard
import Components.RequestInfoCard as RequestInfoCard
import Components.SaveFavouriteCard as SaveFavouriteCard
import Components.SearchLocationModel as SearchLocationModel
import Components.SelectListModal as CancelRidePopUp
import Components.SettingSideBar as SettingSideBar
import Control.Monad.Except (runExceptT)
import Control.Monad.Trans.Class (lift)
import Control.Transformers.Back.Trans (runBackT)
import Data.Array (any, length, mapWithIndex,take, (!!),head, filter, cons, null, tail)
import Data.Array as Arr
import Data.Function.Uncurried (runFn3)
import DecodeUtil (getAnyFromWindow)
import Data.Either (Either(..))
import Data.Int (ceil, floor, fromNumber, fromString, toNumber, pow)
import Data.Function.Uncurried (runFn1)
import Data.Lens ((^.))
import Data.Maybe (Maybe(..), fromMaybe, isJust, maybe, isNothing)
import Data.Number as NUM
import Data.Time.Duration (Milliseconds(..))
import Debug (spy)
import Effect (Effect)
import Effect.Aff (launchAff)
import Effect.Class (liftEffect)
import Effect.Uncurried (runEffectFn1, runEffectFn2, runEffectFn9)
import Engineering.Helpers.Commons (flowRunner, getNewIDWithTag, liftFlow, os, safeMarginBottom, safeMarginTop, screenHeight, isPreviousVersion, screenWidth, camelCaseToSentenceCase, truncate,getExpiryTime, getDeviceHeight, getScreenPpi, safeMarginTopWithDefault, markPerformance)
import Engineering.Helpers.Suggestions (getMessageFromKey, getSuggestionsfromKey, chatSuggestion, emChatSuggestion)
import Engineering.Helpers.Utils (showAndHideLoader)
import Engineering.Helpers.LogEvent (logEvent)
import Engineering.Helpers.Events as Events
import Engineering.Helpers.Utils (showAndHideLoader)
import Font.Size as FontSize
import Font.Style as FontStyle
import Helpers.Utils (fetchImage, FetchImageFrom(..), decodeError, fetchAndUpdateCurrentLocation, getAssetsBaseUrl, getCurrentLocationMarker, getLocationName, getNewTrackingId, getSearchType, parseFloat, storeCallBackCustomer, didReceiverMessage, getPixels, getDefaultPixels, getDeviceDefaultDensity, specialZoneTagConfig, zoneLabelIcon, findSpecialPickupZone, getCityConfig, getVehicleVariantImage, getImageBasedOnCity)
import JBridge (addMarker, animateCamera, clearChatMessages, drawRoute, enableMyLocation, firebaseLogEvent, generateSessionId, getArray, getCurrentPosition, getExtendedPath, getHeightFromPercent, getLayoutBounds, initialWebViewSetUp, isCoordOnPath, isInternetAvailable, isMockLocation, lottieAnimationConfig, removeAllPolylines, removeMarker, requestKeyboardShow, scrollOnResume, showMap, startChatListenerService, startLottieProcess, stopChatListenerService, storeCallBackMessageUpdated, storeCallBackOpenChatScreen, storeKeyBoardCallback, toast, updateRoute, addCarousel, updateRouteConfig, addCarouselWithVideoExists, storeCallBackLocateOnMap, storeOnResumeCallback, setMapPadding, getKeyInSharedPrefKeys, locateOnMap, locateOnMapConfig, defaultMarkerConfig, jBridgeMethodExists, currentPosition)
import Language.Strings (getString, getVarString)
import Language.Types (STR(..))
import Log (printLog)
import MerchantConfig.Utils (Merchant(..), getMerchant)
import Prelude (Unit, bind, const, discard, map, negate, not, pure, show, unit, void, when, ($), (&&), (*), (+), (-), (/), (/=), (<), (<<<), (<=), (<>), (==), (>), (||), (<$>), identity, (>=))
import Presto.Core.Types.API (ErrorResponse)
import Presto.Core.Types.Language.Flow (Flow, doAff, modifyState, getState)
import Helpers.Pooling (delay)
import PrestoDOM (BottomSheetState(..), Gradient(..), Gravity(..), Length(..), Accessiblity(..), Margin(..), Accessiblity(..), Orientation(..), Padding(..), PrestoDOM, Screen, Visibility(..), Shadow(..), scrollBarY,adjustViewWithKeyboard, afterRender, alignParentBottom, background, clickable, color, cornerRadius, disableClickFeedback, ellipsize, fontStyle, frameLayout, gradient, gravity, halfExpandedRatio, height, id, imageView, imageWithFallback, lineHeight, linearLayout, lottieAnimationView, margin, maxLines, onBackPressed, onClick, orientation, padding, peakHeight, relativeLayout, scaleType, singleLine, stroke, text, textFromHtml, textSize, textView, url, visibility, webView, weight, width, layoutGravity, accessibilityHint, accessibility, accessibilityFocusable, focusable, scrollView, onAnimationEnd, clipChildren, enableShift,horizontalScrollView, shadow,onStateChanged,scrollBarX, clipToPadding, onSlide, rotation, rippleColor, shimmerFrameLayout)
import PrestoDOM.Animation as PrestoAnim
import PrestoDOM.Elements.Elements (bottomSheetLayout, coordinatorLayout)
import PrestoDOM.Properties (cornerRadii, sheetState, alpha, nestedScrollView)
import PrestoDOM.Types.DomAttributes (Corners(..))
import Screens.AddNewAddressScreen.Controller as AddNewAddress
import Screens.HomeScreen.Controller (Action(..), ScreenOutput, checkCurrentLocation, checkSavedLocations, dummySelectedQuotes, eval, flowWithoutOffers, getPeekHeight, checkRecentRideVariant)
import Screens.RideBookingFlow.HomeScreen.BannerConfig (getBannerConfigs)
import Screens.HomeScreen.ScreenData as HomeScreenData
import Screens.HomeScreen.Transformer (transformSavedLocations, getActiveBooking, getDriverInfo, getFormattedContacts)
import Screens.RideBookingFlow.HomeScreen.Config
import Services.API
import Screens.NammaSafetyFlow.Components.ContactsList (contactCardView)
import Services.API (GetDriverLocationResp(..), GetQuotesRes(..), GetRouteResp(..), LatLong(..), RideAPIEntity(..), RideBookingRes(..), Route(..), SavedLocationsListRes(..), SearchReqLocationAPIEntity(..), SelectListRes(..), Snapped(..), GetPlaceNameResp(..), PlaceName(..), RideBookingListRes(..))
import Screens.Types (Followers(..), CallType(..), HomeScreenState, LocationListItemState, PopupType(..), SearchLocationModelType(..), SearchResultType(..), Stage(..), ZoneType(..), SheetState(..), Trip(..), SuggestionsMap(..), Suggestions(..),City(..), BottomNavBarIcon(..), NewContacts, ReferralStatus(..))
import Services.Backend (getDriverLocation, getQuotes, getRoute, makeGetRouteReq, rideBooking, selectList, getRouteMarkers, walkCoordinates, walkCoordinate, getSavedLocationList)
import Services.Backend as Remote
import Storage (KeyStore(..), getValueToLocalStore, isLocalStageOn, setValueToLocalStore, updateLocalStage, getValueToLocalNativeStore)
import Styles.Colors as Color
import Types.App (FlowBT, GlobalState(..), defaultGlobalState)
import Halogen.VDom.DOM.Prop (Prop)
import Data.String as DS
import Data.Function.Uncurried (runFn1, runFn2)
import Components.CommonComponentConfig as CommonComponentConfig
import Constants.Configs 
import Common.Resources.Constants (zoomLevel)
import Constants (defaultDensity)
import Animation as Anim
import Animation.Config (AnimConfig, animConfig)
import Components.SourceToDestination as SourceToDestination
import Data.Map as Map
import SuggestionUtils
import MerchantConfig.Types (MarginConfig, ShadowConfig)
import ConfigProvider
import Mobility.Prelude
import Timers
import PrestoDOM.Core
import Locale.Utils
import CarouselHolder as CarouselHolder
import PrestoDOM.List
import Components.BannerCarousel as BannerCarousel
import Components.MessagingView.Common.Types
import Components.MessagingView.Common.View
import Data.FoldableWithIndex
import Engineering.Helpers.BackTrack (liftFlowBT)
import LocalStorage.Cache (getValueFromCache)
import Components.PopupWithCheckbox.View as PopupWithCheckbox
import Services.FlowCache as FlowCache
import Engineering.Helpers.BackTrack
import Engineering.Helpers.Events as Events
import Types.App
import Mobility.Prelude

screen :: HomeScreenState -> Screen Action HomeScreenState ScreenOutput
screen initialState =
  { initialState
  , view
  , name: "HomeScreen"
  , globalEvents:
      [ ( \push -> do
            _ <- pure $ printLog "storeCallBackCustomer initially" "."
            _ <- pure $ printLog "storeCallBackCustomer callbackInitiated" initialState.props.callbackInitiated
            -- push NewUser -- TODO :: Handle the functionality
            _ <- if initialState.data.config.enableMockLocation then isMockLocation push IsMockLocation else pure unit
            _ <- launchAff $ flowRunner defaultGlobalState $ runExceptT $ runBackT $ checkForLatLongInSavedLocations push UpdateSavedLoc initialState
            when (initialState.props.followsRide && isNothing initialState.data.followers) $ void $ launchAff $ flowRunner defaultGlobalState $ getFollowRide push UpdateFollowers
            if (not initialState.props.callbackInitiated) then do
              _ <- pure $ printLog "storeCallBackCustomer initiateCallback" "."
              _ <- storeCallBackCustomer push NotificationListener "HomeScreen"
              _ <- pure $ runFn2 storeOnResumeCallback push OnResumeCallback
              _ <- runEffectFn2 storeKeyBoardCallback push KeyboardCallback
              push HandleCallback
            else do
              pure unit
            when (isNothing initialState.data.bannerData.bannerItem) $ void $ launchAff $ flowRunner defaultGlobalState $ computeListItem push
            case initialState.props.currentStage of
              SearchLocationModel -> case initialState.props.isSearchLocation of
                LocateOnMap -> do
                  _ <- storeCallBackLocateOnMap push UpdateLocation
                  pure unit
                _ -> do
                  case initialState.props.isSource of
                    Just index -> do
                      _ <- pure $ requestKeyboardShow (if index then (getNewIDWithTag "SourceEditText") else (getNewIDWithTag "DestinationEditText"))
                      pure unit
                    Nothing -> pure unit
                  pure unit
              FindingEstimate -> do
                _ <- pure $ removeMarker (getCurrentLocationMarker (getValueToLocalStore VERSION_NAME))
                _ <- launchAff $ flowRunner defaultGlobalState $ getEstimate GetEstimates CheckFlowStatusAction 10 1000.0 push initialState
                pure unit
              FindingQuotes -> do
                when ((getValueToLocalStore FINDING_QUOTES_POLLING) == "false") $ do
                  void $ pure $ setValueToLocalStore FINDING_QUOTES_POLLING "true"
                  void $ pure $ setValueToLocalStore AUTO_SELECTING "false"
                  void $ startTimer initialState.props.searchExpire "findingQuotes" "1" push SearchExpireCountDown 
                  void $ pure $ setValueToLocalStore GOT_ONE_QUOTE "FALSE"
                  void $ pure $ setValueToLocalStore TRACKING_ID (getNewTrackingId unit)
                  let pollingCount = ceil ((toNumber initialState.props.searchExpire)/((fromMaybe 0.0 (NUM.fromString (getValueToLocalStore TEST_POLLING_INTERVAL))) / 1000.0))
                  void $ launchAff $ flowRunner defaultGlobalState $ getQuotesPolling (getValueToLocalStore TRACKING_ID) GetQuotesList Restart pollingCount (fromMaybe 0.0 (NUM.fromString (getValueToLocalStore TEST_POLLING_INTERVAL))) push initialState
              ConfirmingRide -> void $ launchAff $ flowRunner defaultGlobalState $ confirmRide GetRideConfirmation 5 3000.0 push initialState
              HomeScreen -> do
                let suggestionsMap = getSuggestionsMapFromLocal FunctionCall
                if (getValueToLocalStore UPDATE_REPEAT_TRIPS == "true" && Map.isEmpty suggestionsMap) then do
                  void $ launchAff $ flowRunner defaultGlobalState $ updateRecentTrips UpdateRepeatTrips push Nothing
                else do 
                  push RemoveShimmer 
                  pure unit
                when (isJust initialState.data.rideHistoryTrip) $ do 
                  push $ RepeatRide 0 (fromMaybe HomeScreenData.dummyTrip initialState.data.rideHistoryTrip)
                _ <- pure $ setValueToLocalStore SESSION_ID (generateSessionId unit)
                _ <- pure $ removeAllPolylines ""
                _ <- pure $ enableMyLocation true
                _ <- pure $ setValueToLocalStore NOTIFIED_CUSTOMER "false"
                fetchAndUpdateCurrentLocation push UpdateLocAndLatLong RecenterCurrentLocation
              SettingPrice -> do
                _ <- pure $ removeMarker (getCurrentLocationMarker (getValueToLocalStore VERSION_NAME))
                let isRepeatRideEstimate = checkRecentRideVariant initialState
                if (initialState.props.isRepeatRide && isRepeatRideEstimate) 
                    then startTimer initialState.data.config.suggestedTripsAndLocationConfig.repeatRideTime "repeatRide" "1" push RepeatRideCountDown
                else if (initialState.props.isRepeatRide && not isRepeatRideEstimate) then do 
                    void $ pure $ toast $ getString LAST_CHOSEN_VARIANT_NOT_AVAILABLE
                else pure unit
              PickUpFarFromCurrentLocation -> 
                void $ pure $ removeMarker (getCurrentLocationMarker (getValueToLocalStore VERSION_NAME))
              RideAccepted -> do
                when 
                  (initialState.data.config.notifyRideConfirmationConfig.notify && any (_ == getValueToLocalStore NOTIFIED_CUSTOMER) ["false" , "__failed" , "(null)"])
                    $ startTimer 5 "notifyCustomer" "1" push NotifyDriverStatusCountDown
                _ <- pure $ enableMyLocation true
                if ((getValueToLocalStore DRIVER_ARRIVAL_ACTION) == "TRIGGER_WAITING_ACTION") then do
                  void $ waitingCountdownTimerV2 initialState.data.driverInfoCardState.driverArrivalTime "1" "countUpTimerId" push WaitingTimeAction
                else 
                  when 
                    (initialState.data.currentSearchResultType == QUOTES) $ do
                      let secondsLeft = initialState.data.config.driverInfoConfig.specialZoneQuoteExpirySeconds - (getExpiryTime initialState.data.driverInfoCardState.createdAt true)
                      void $ startTimer secondsLeft "SpecialZoneOTPExpiry" "1" push SpecialZoneOTPExpiryAction
                if ((getValueToLocalStore TRACKING_DRIVER) == "False") then do
                  _ <- pure $ removeMarker (getCurrentLocationMarker (getValueToLocalStore VERSION_NAME))
                  _ <- pure $ setValueToLocalStore TRACKING_ID (getNewTrackingId unit)
                  when (initialState.props.zoneType.priorityTag == SPECIAL_PICKUP && initialState.data.config.feature.enableSpecialPickup && os /= "IOS") $ do
                    let specialPickupZone = findSpecialPickupZone initialState.props.locateOnMapProps.sourceGeoJson initialState.props.locateOnMapProps.sourceGates initialState.data.driverInfoCardState.sourceLat initialState.data.driverInfoCardState.sourceLng
                    case specialPickupZone of
                      Just pickUpZone -> runEffectFn1 locateOnMap locateOnMapConfig { geoJson = pickUpZone.geoJson, points = pickUpZone.gates, locationName = pickUpZone.locationName, navigateToNearestGate = false }
                      Nothing -> pure unit
                  void $ launchAff $ flowRunner defaultGlobalState $ driverLocationTracking push UpdateCurrentStage DriverArrivedAction UpdateETA 3000.0 (getValueToLocalStore TRACKING_ID) initialState "pickup" 1
                else pure unit
                push LoadMessages
                when (not initialState.props.chatcallbackInitiated && initialState.data.currentSearchResultType /= QUOTES) $ startChatSerivces push initialState.data.driverInfoCardState.bppRideId "Customer" false
                void $ push $ DriverInfoCardActionController DriverInfoCard.NoAction
              RideStarted -> do
                _ <- pure $ enableMyLocation false
                if ((getValueToLocalStore TRACKING_DRIVER) == "False") then do
                  _ <- pure $ removeMarker (getCurrentLocationMarker (getValueToLocalStore VERSION_NAME))
                  _ <- pure $ setValueToLocalStore TRACKING_ID (getNewTrackingId unit)
                  _ <- launchAff $ flowRunner defaultGlobalState $ driverLocationTracking push UpdateCurrentStage DriverArrivedAction UpdateETA 20000.0 (getValueToLocalStore TRACKING_ID) initialState "trip" 1
                  pure unit
                else
                  pure unit
                case initialState.data.contactList of
                  Nothing -> void $ launchAff $ flowRunner defaultGlobalState $ runExceptT $ runBackT $ updateEmergencyContacts push initialState
                  Just contacts -> validateAndStartChat contacts push initialState
                pure unit
                void $ push $ DriverInfoCardActionController DriverInfoCard.NoAction
              ChatWithDriver -> if ((getValueToLocalStore DRIVER_ARRIVAL_ACTION) == "TRIGGER_WAITING_ACTION") then waitingCountdownTimerV2 initialState.data.driverInfoCardState.driverArrivalTime "1" "countUpTimerId" push WaitingTimeAction else pure unit
              ConfirmingLocation -> do
                void $ pure $ enableMyLocation true
                void $ pure $ removeMarker (getCurrentLocationMarker (getValueToLocalStore VERSION_NAME))
                void $ setMapPadding 0 0 0 112
                _ <- storeCallBackLocateOnMap push UpdatePickupLocation
                pure unit
              TryAgain -> do
                _ <- launchAff $ flowRunner defaultGlobalState $ getEstimate EstimatesTryAgain CheckFlowStatusAction 10 1000.0 push initialState
                pure unit
              FindEstimateAndSearch -> do
                push $ SearchForSelectedLocation
                pure unit
              ReAllocated ->
                void $ launchAff $ flowRunner defaultGlobalState $ reAllocateConfirmation push initialState ReAllocate 3000.0
              ShortDistance -> do 
                when (initialState.props.suggestedRideFlow || initialState.props.isRepeatRide) $ push $ ShortDistanceActionController PopUpModal.OnButton2Click

              _ -> pure unit
            if ((initialState.props.sourceLat /= (-0.1)) && (initialState.props.sourceLong /= (-0.1))) then do
              case initialState.props.sourceLat, initialState.props.sourceLong of
                0.0, 0.0 -> do
                  _ <- getCurrentPosition push CurrentLocation
                  pure (pure unit)
                _, _ -> pure (pure unit)
            else
              pure (pure unit)
        )
      ]
  , eval:
      \action state -> do
        let _ = spy "HomeScreen action " action
        let _ = spy "HomeScreen state " state
        eval action state
  }

getDelayForLocateOnMap :: Int
getDelayForLocateOnMap = 1000

enableCurrentLocation :: Boolean
enableCurrentLocation = true

disableCurrentLocation :: Boolean
disableCurrentLocation = false

isCurrentLocationEnabled :: Boolean
isCurrentLocationEnabled = if (isLocalStageOn HomeScreen) then enableCurrentLocation else disableCurrentLocation

view :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
view push state =
  let 
    showLabel = not $ DS.null state.props.defaultPickUpPoint
    extraPadding = if state.props.currentStage == ConfirmingLocation then 112 else 0
  in
  frameLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , onBackPressed push (const BackPressed)
    , clickable true
    , afterRender 
        (\action -> do
          void $ markPerformance "HOME_SCREEN_RENDER"
          void $ Events.endMeasuringDuration "onCreateToHomeScreenRenderDuration"
          void $ Events.endMeasuringDuration "initAppToHomeScreenRenderDuration"          
          push action
        ) (const AfterRender)
    , accessibility DISABLE
    ]
    [ linearLayout
        [ height MATCH_PARENT
        , width MATCH_PARENT
        , orientation VERTICAL
        , accessibility DISABLE
        , clickable true
        ]
       [ relativeLayout
            [ width MATCH_PARENT
            , weight 1.0
            , orientation VERTICAL
            , background Color.transparent
            , accessibility DISABLE
            , height MATCH_PARENT
            ]
            ([ frameLayout
                [ width MATCH_PARENT
                , height MATCH_PARENT
                , accessibility DISABLE
                , clickable true
                ]
                [ linearLayout
                  [ height MATCH_PARENT
                  , width MATCH_PARENT
                  , clickable false
                  , background Color.transparent
                  , accessibility if any (_ == state.props.currentStage) [RideAccepted, RideStarted, HomeScreen] && not isAnyOverlayEnabled state then ENABLE else DISABLE
                  , accessibilityHint $ camelCaseToSentenceCase (show state.props.currentStage)
                  ][]
                , linearLayout
                  [ height MATCH_PARENT
                  , width MATCH_PARENT
                  , background Color.transparent
                  ][ 
                    if isHomeScreenView state then homeScreenViewV2 push state else emptyTextView state
                  , if isHomeScreenView state then emptyTextView state else mapView push state (if os == "IOS" then "CustomerHomeScreenMap" else "CustomerHomeScreen")
                    ]
                , if not state.data.config.feature.enableSpecialPickup then
                    linearLayout
                    [ width MATCH_PARENT
                    , height MATCH_PARENT
                    , background Color.transparent
                    , padding $ PaddingBottom $ (if os == "IOS" then 60 else 70) + extraPadding
                    , gravity CENTER
                    , accessibility DISABLE
                    , orientation VERTICAL
                    , visibility $ boolToVisibility $ not state.data.config.feature.enableSpecialPickup
                    ]
                    [ textView
                        [ width WRAP_CONTENT
                        , height WRAP_CONTENT
                        , background Color.black800
                        , color Color.white900
                        , accessibility DISABLE_DESCENDANT
                        , text if DS.length state.props.defaultPickUpPoint > state.data.config.mapConfig.labelTextSize then
                                  (DS.take (state.data.config.mapConfig.labelTextSize - 3) state.props.defaultPickUpPoint) <> "..."
                               else
                                  state.props.defaultPickUpPoint
                        , padding (Padding 5 5 5 5)
                        , margin (MarginBottom 5)
                        , cornerRadius 5.0
                        , visibility $ boolToInvisibility $ showLabel && ((state.props.currentStage == ConfirmingLocation) || state.props.locateOnMap)
                        , id (getNewIDWithTag "LocateOnMapPin")
                        ]
                    , imageView
                        [ width $ V 35
                        , height $ V 35
                        , accessibility DISABLE
                        , imageWithFallback $ fetchImage FF_COMMON_ASSET $ case (state.props.currentStage == ConfirmingLocation) || state.props.isSource == (Just true) of
                            true  -> "ny_ic_src_marker"
                            false -> "ny_ic_dest_marker"
                        , visibility $ boolToVisibility ((state.props.currentStage == ConfirmingLocation) || state.props.locateOnMap)
                        ]
                    ]
                  else
                    linearLayout
                    [ width MATCH_PARENT
                    , height MATCH_PARENT
                    , background Color.transparent
                    , padding $ PaddingBottom $ 95 + extraPadding
                    , gravity CENTER
                    , accessibility DISABLE
                    , orientation VERTICAL
                    , visibility $ boolToVisibility $ state.data.config.feature.enableSpecialPickup && ((state.props.currentStage == ConfirmingLocation) || state.props.locateOnMap)
                    ][ imageView
                        [ width WRAP_CONTENT
                        , height WRAP_CONTENT
                        , accessibility DISABLE_DESCENDANT
                        , visibility $ boolToInvisibility (showLabel && ((state.props.currentStage == ConfirmingLocation) || state.props.locateOnMap))
                        , id (getNewIDWithTag "LocateOnMapPin")
                        ]
                     ]
                , linearLayout
                    [ width MATCH_PARENT
                    , height MATCH_PARENT
                    , background Color.transparent
                    , padding $ PaddingBottom $ (if os == "IOS" then 26 else 36) + extraPadding
                    , gravity CENTER
                    , accessibility DISABLE
                    , orientation VERTICAL
                    , visibility $ boolToVisibility $ state.data.config.feature.enableSpecialPickup && ((state.props.currentStage == ConfirmingLocation) || state.props.locateOnMap)
                    ]
                    [ imageView
                        [ width $ V 35
                        , height $ V 35
                        , accessibility DISABLE
                        , imageWithFallback $ fetchImage FF_COMMON_ASSET $ case (state.props.currentStage == ConfirmingLocation) || state.props.isSource == (Just true) of
                            true  -> "ny_ic_src_marker"
                            false -> "ny_ic_dest_marker"
                        , visibility $ boolToVisibility ((state.props.currentStage == ConfirmingLocation) || state.props.locateOnMap)
                        ]
                    ]
                ]
            -- , homeScreenView push state
            -- , buttonLayoutParentView push state
            , if (not state.props.rideRequestFlow) || any (_ == state.props.currentStage) [ FindingEstimate, ConfirmingRide, HomeScreen] then emptyTextView state else topLeftIconView state push
            , rideRequestFlowView push state
            , if state.props.currentStage == PricingTutorial then (pricingTutorialView push state) else emptyTextView state
            , if (any (_ == state.props.currentStage) [RideAccepted, RideStarted, ChatWithDriver]) then messageWidgetView push state else emptyTextView state
            , if (any (_ == state.props.currentStage) [RideAccepted, RideStarted, ChatWithDriver]) then
                relativeLayout 
                [ width MATCH_PARENT
                , height MATCH_PARENT
                ][ rideTrackingView push state 
                , DriverInfoCard.brandingBannerView state.data.config.driverInfoConfig VISIBLE (Just "BrandingBanner")
                ]
              else emptyTextView state
            , if state.props.currentStage == ChatWithDriver then messagingView push state else emptyTextView state
            , if state.props.currentStage /= RideRating && state.props.isMockLocation && (getMerchant FunctionCall == NAMMAYATRI) && state.props.currentStage == HomeScreen then (sourceUnserviceableView push state) else emptyTextView state
            , if state.data.settingSideBar.opened /= SettingSideBar.CLOSED then settingSideBarView push state else emptyTextView state
            , if (state.props.currentStage == SearchLocationModel || state.props.currentStage == FavouriteLocationModel) then searchLocationView push state else emptyTextView state
            , if (any (_ == state.props.currentStage) [ FindingQuotes, QuoteList, TryAgain ]) then (quoteListModelView push state) else emptyTextView state
            , if (state.props.isCancelRide) then (cancelRidePopUpView push state) else emptyTextView state
            , if (state.props.isPopUp /= NoPopUp) then (logOutPopUpView push state) else emptyTextView state
            , if (state.props.isLocationTracking) then (locationTrackingPopUp push state) else emptyTextView state
            , if (state.props.isEstimateChanged) then (estimateChangedPopUp push state) else emptyTextView state
            , if state.props.currentStage == PickUpFarFromCurrentLocation then (pickUpFarFromCurrLocView push state) else emptyTextView state
            , if state.props.currentStage == DistanceOutsideLimits then (distanceOutsideLimitsView push state) else emptyTextView state
            , if state.props.currentStage == ShortDistance && (not state.props.suggestedRideFlow) && (not state.props.isRepeatRide)then (shortDistanceView push state) else emptyTextView state
            , if state.props.isSaveFavourite then saveFavouriteCardView push state else emptyTextView state
            , if state.props.showShareAppPopUp && state.data.config.feature.enableShareApp then shareAppPopUp push state else emptyTextView state
            , if state.props.showLiveDashboard then showLiveStatsDashboard push state else emptyTextView state
            , if state.props.showCallPopUp then (driverCallPopUp push state) else emptyTextView state
            , if state.props.cancelSearchCallDriver then cancelSearchPopUp push state else emptyTextView state
            , if state.props.currentStage == RideCompleted || state.props.currentStage == RideRating then rideCompletedCardView push state else emptyTextView state
            , if state.props.currentStage == RideRating then rideRatingCardView state push else emptyTextView state
            , if state.props.showRateCard then (rateCardView push state) else emptyTextView state
            -- , if state.props.zoneTimerExpired then zoneTimerExpiredView state push else emptyTextView state
            , if state.props.callSupportPopUp then callSupportPopUpView push state else emptyTextView state
            , if state.props.showDisabilityPopUp &&  (getValueToLocalStore DISABILITY_UPDATED == "true") then disabilityPopUpView push state else emptyTextView state
            , if state.data.waitTimeInfo && state.props.currentStage == RideAccepted then waitTimeInfoPopUp push state else emptyTextView state
            , if state.props.showBookingPreference then bookingPreferencesView push state else emptyTextView state
            , if isJust state.props.safetyAlertType && state.props.currentStage == RideStarted then safetyAlertPopup push state else  emptyTextView state
            , if state.props.showShareRide then PopupWithCheckbox.view (push <<< ShareRideAction) (shareRideConfig state) else emptyTextView state
            , if state.props.referral.referralStatus /= NO_REFERRAL then referralPopUp push state else emptyTextView state 
            , if state.props.showSpecialZoneInfoPopup then specialZoneInfoPopup push state else emptyTextView state
            , if state.props.repeatRideTimer /= "0" 
              then linearLayout
                    [ width MATCH_PARENT
                    , height MATCH_PARENT
                    , onClick push $ const StopRepeatRideTimer
                    , clickable $ not DS.null state.props.repeatRideTimerId 
                    ][]
              else emptyTextView state
            -- , bottomNavBarView push state -- TODO :: Mercy need once rentals is introduced
            ]  <> if state.props.showEducationalCarousel then 
                    [ linearLayout
                      [ height MATCH_PARENT
                      , width MATCH_PARENT
                      , gravity CENTER
                      , onClick push $ const NoAction
                      , background Color.black9000
                      ][ PrestoAnim.animationSet [ fadeIn state.props.showEducationalCarousel] $ carouselView state push ]] 
                    else [])
        ]
  ]

bottomNavBarView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
bottomNavBarView push state = let 
  viewVisibility = boolToVisibility $ state.props.currentStage == HomeScreen 
  in
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , background Color.transparent
    , alignParentBottom "true,-1"
    , visibility viewVisibility
    , gravity BOTTOM
    , orientation VERTICAL
    ][  separator (V 1) Color.grey900 state.props.currentStage
      , linearLayout
          [ height WRAP_CONTENT
          , width MATCH_PARENT
          , background Color.white900
          , padding $ PaddingVertical 10 10
          ](map (\item -> 
              linearLayout
              [ height WRAP_CONTENT
              , weight 1.0 
              , gravity CENTER 
              , onClick push $ const $ BottomNavBarAction item.id
              , orientation VERTICAL
              , alpha if (state.props.focussedBottomIcon == item.id) then 1.0 else 0.5
              ][  imageView
                    [ height $ V 24 
                    , width $ V 24 
                    , imageWithFallback $ fetchImage FF_ASSET $ item.image
                    ]
                , textView $
                    [ text item.text 
                    , height WRAP_CONTENT
                    , width WRAP_CONTENT
                    , color $ Color.black800
                    ] <> FontStyle.body9 TypoGraphy

              ]
            ) ([  {text : "Mobility" , image : "ny_ic_vehicle_unfilled_black", id : MOBILITY}
                , {text : "Ticketing" , image : "ny_ic_ticket_black", id : TICKETING }]))
    ]
getMapHeight :: HomeScreenState -> Length
getMapHeight state = V (if state.data.currentSearchResultType == QUOTES then (((screenHeight unit)/ 4)*3) 
                            else if (state.props.currentStage == RideAccepted || state.props.currentStage == ChatWithDriver) then ((screenHeight unit) - (getInfoCardPeekHeight state)) + 50
                            else (((screenHeight unit)/ 15)*10))


getCarouselConfig ∷ ListItem → HomeScreenState → Array (BannerCarousel.Config (BannerCarousel.Action → Action)) → CarouselHolder.CarouselHolderConfig BannerCarousel.PropConfig Action
getCarouselConfig view state banners = {
    view
  , items : BannerCarousel.bannerTransformer banners
  , orientation : HORIZONTAL
  , currentPage : state.data.bannerData.currentPage
  , autoScroll : state.data.config.bannerCarousel.enableAutoScroll
  , autoScrollDelay : state.data.config.bannerCarousel.autoScrollDelay
  , id : "bannerCarousel"
  , autoScrollAction : Just UpdateBanner
  , onPageSelected : Just BannerChanged
  , onPageScrollStateChanged : Just BannerStateChanged
  , onPageScrolled : Nothing
  , currentIndex : state.data.bannerData.currentBanner
}

rideCompletedCardView ::  forall w . (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
rideCompletedCardView push state = 
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , accessibility if state.props.currentStage == RideRating then DISABLE_DESCENDANT else DISABLE
  ][  RideCompletedCard.view (rideCompletedCardConfig state) (push <<< RideCompletedAC)]

disabilityPopUpView :: forall w . (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
disabilityPopUpView push state = 
  PopUpModal.view (push <<< DisabilityPopUpAC) (CommonComponentConfig.accessibilityPopUpConfig state.data.disability state.data.config.purpleRideConfig)

callSupportPopUpView :: forall w . (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
callSupportPopUpView push state =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  ][PopUpModal.view (push <<< CallSupportAction) (callSupportConfig state)]

cancelSearchPopUp :: forall w . (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
cancelSearchPopUp push state =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , accessibility DISABLE
  ][PopUpModal.view (push <<< CancelSearchAction) (cancelAppConfig state)]

messageWidgetView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
messageWidgetView push state = 
  let isWidgetVisible = ((any (_ == state.props.currentStage)) [ RideAccepted, ChatWithDriver] || state.props.isChatWithEMEnabled) && state.data.currentSearchResultType /= QUOTES && state.data.config.feature.enableChat && state.data.config.feature.enableSuggestions && not state.props.removeNotification
  in 
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , accessibility if state.data.settingSideBar.opened /= SettingSideBar.CLOSED || state.props.currentStage == ChatWithDriver || state.props.isCancelRide || state.props.isLocationTracking || state.props.callSupportPopUp || state.props.cancelSearchCallDriver || state.props.showCallPopUp || state.props.showRateCard || state.props.bottomSheetState == STATE_EXPANDED || state.data.waitTimeInfo then DISABLE_DESCENDANT else DISABLE
  , orientation VERTICAL
  ][ (if disableSuggestions state then 
        PrestoAnim.animationSet[] 
      else (if state.props.showChatNotification then 
        PrestoAnim.animationSet [translateYAnimFromTop $ messageInAnimConfig true] 
      else if state.props.isNotificationExpanded then 
        PrestoAnim.animationSet [translateYAnimFromTop $ messageOutAnimConfig true] 
      else PrestoAnim.animationSet[scaleYAnimWithDelay 5000])) $ 
     linearLayout
     [ height $ MATCH_PARENT
     , width MATCH_PARENT
     , padding $ PaddingHorizontal 8 8
     , alignParentBottom "true,-1"
     , gravity BOTTOM
     , accessibility DISABLE
     , onAnimationEnd push $ const $ NotificationAnimationEnd
     , orientation VERTICAL
     ][ messageNotificationView push (getMessageNotificationViewConfig state)
      , linearLayout
        [ height $ V $ ((getInfoCardPeekHeight state) - if isWidgetVisible then 196 else 0)
        , width $ MATCH_PARENT
        , accessibility DISABLE
        ][]
     ]
  ]
  where disableSuggestions :: HomeScreenState -> Boolean
        disableSuggestions state = state.data.currentSearchResultType == QUOTES || not state.data.config.feature.enableChat || not state.data.config.feature.enableSuggestions

messagingView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
messagingView push state = 
  relativeLayout
  [ height $ MATCH_PARENT
  , width $ MATCH_PARENT
  , accessibility $ DISABLE
  ][ MessagingView.view (push <<< MessagingViewActionController) $ messagingViewConfig state ]

showLiveStatsDashboard :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
showLiveStatsDashboard push state =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , background Color.grey800
  , afterRender
        ( \action -> do
            initialWebViewSetUp push (getNewIDWithTag "webview") HideLiveDashboard
            pure unit
        )
        (const NoAction)
  ] [ webView
      [ height MATCH_PARENT
      , width MATCH_PARENT
      , id (getNewIDWithTag "webview")
      , url state.data.config.dashboard.url
      ]]

driverCallPopUp :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
driverCallPopUp push state =
  relativeLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , alignParentBottom "true,-1"
    ]
    [ linearLayout
      [ height MATCH_PARENT
      , width MATCH_PARENT 
      , background Color.black9000
      , accessibilityHint "Call driver popup double tap to dismiss : Button"
      , accessibility ENABLE
      , disableClickFeedback true
      , onClick push (const $ CloseShowCallDialer)
      ][]
    , linearLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , background Color.white900
        , orientation VERTICAL
        , cornerRadii $ Corners 24.0 true true false false
        , padding (Padding 20 32 20 25)
        , alignParentBottom "true,-1"
        , disableClickFeedback true
        ]
        [ textView
            $
              [ text (getString CALL_DRIVER_USING)
              , height WRAP_CONTENT
              , color Color.black700
              , textSize FontSize.a_18
              , margin (MarginBottom 4)
              ]
        , linearLayout
            [ height WRAP_CONTENT
            , width MATCH_PARENT
            , orientation VERTICAL
            ]
            ( map
                ( \item ->
                    linearLayout
                      [ height WRAP_CONTENT
                      , width MATCH_PARENT
                      , orientation VERTICAL
                      ]
                      [ trackingCardCallView push state item
                      , if(item.type == ANONYMOUS_CALLER) then linearLayout
                          [ height $ V 1
                          , width MATCH_PARENT
                          , background Color.grey900
                          ]
                          []
                        else linearLayout[][]
                      ]
                )
                (driverCallPopUpData state)
            )
        ]
    ]


driverCallPopUpData :: HomeScreenState -> Array { text :: String, imageWithFallback :: String, type :: CallType, data :: String }
driverCallPopUpData state =
  [ { text: (getString ANONYMOUS_CALL)
    , imageWithFallback: fetchImage FF_ASSET "ic_anonymous_call"
    , type: ANONYMOUS_CALLER
    , data: (getString YOUR_NUMBER_WILL_NOT_BE_SHOWN_TO_THE_DRIVER_THE_CALL_WILL_BE_RECORDED_FOR_COMPLIANCE)
    }
  , { text: (getString DIRECT_CALL)
    , imageWithFallback: fetchImage FF_ASSET "ic_direct_call"
    , type: DIRECT_CALLER
    , data: (getString YOUR_NUMBER_WILL_BE_VISIBLE_TO_THE_DRIVER_USE_IF_NOT_CALLING_FROM_REGISTERED_NUMBER)
    }
  ]

trackingCardCallView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> { text :: String, imageWithFallback :: String, type :: CallType, data :: String} -> PrestoDOM (Effect Unit) w
trackingCardCallView push state item =
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation HORIZONTAL
    , padding (Padding 0 20 0 20)
    , accessibility ENABLE
    , accessibilityHint $ item.text <> " : " <> item.data
    , gravity CENTER_VERTICAL
    , onClick push (const (ShowCallDialer item.type))
    ]
    [
    imageView
        [ imageWithFallback item.imageWithFallback
        , height $ V 30
        , width $ V 30
        , margin (MarginRight 20)
        ]
    ,  linearLayout[
        height WRAP_CONTENT
      , weight 1.0
      , orientation VERTICAL]
    [
      linearLayout
      [
        height WRAP_CONTENT
      , width WRAP_CONTENT
      , gravity CENTER
      , orientation HORIZONTAL
      , margin (MarginBottom 2)
      ][
        textView
        $
          [ height WRAP_CONTENT
          , width WRAP_CONTENT
          , textSize FontSize.a_16
          , text item.text
          , gravity CENTER_VERTICAL
          , color Color.black800
          ]
        , if(item.type == ANONYMOUS_CALLER) then labelView push state else linearLayout[][]
      ]
      , textView
        $
          [ height WRAP_CONTENT
          , width WRAP_CONTENT
          , text item.data
          , color Color.black600
          ]
    ]
    , imageView
        [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_chevron_right"
        , height $ V 30
        , width $ V 32
        , padding (Padding 3 3 3 3)
        ]
    ]

labelView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
labelView push state =
  linearLayout[
    height WRAP_CONTENT
  , width WRAP_CONTENT
  , cornerRadii $ Corners 8.0 true true true true
  , background Color.green900
  , margin (MarginHorizontal 10 10)
  ][
    textView $ [
      width WRAP_CONTENT
    , height WRAP_CONTENT
    , color Color.white900
    , gravity CENTER
    , padding (Padding 8 1 8 1)
    , textSize FontSize.a_13
    , text (getString RECOMMENDED)
    ]
  ]

searchLocationView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
searchLocationView push state =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , background if state.props.currentStage == SearchLocationModel && state.props.isSearchLocation == LocateOnMap then Color.transparent else Color.grey800
  ] [ if state.props.currentStage == SearchLocationModel then (searchLocationModelView push state) else emptyTextView state
    , if state.props.currentStage == FavouriteLocationModel then (favouriteLocationModel push state) else emptyTextView state
]

shareAppPopUp :: forall w . (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
shareAppPopUp push state =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , background Color.blackLessTrans
  ][PopUpModal.view (push <<< PopUpModalShareAppAction) (shareAppConfig state )]



buttonLayoutParentView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
buttonLayoutParentView push state =
  -- PrestoAnim.animationSet (buttonLayoutAnimation state) $
    linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , id $ getNewIDWithTag "buttonLayout"
    , alignParentBottom "true,-1"
    , orientation VERTICAL
    ][ if (state.props.currentStage == HomeScreen && (not state.props.rideRequestFlow) && (not state.props.showlocUnserviceablePopUp)) then buttonLayout state push else emptyTextView state]

recenterButtonView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
recenterButtonView push state =
  (if os == "IOS" then PrestoAnim.animationSet [] else PrestoAnim.animationSet [ translateYAnimFromTop $ translateYAnimHomeConfig BOTTOM_TOP ])
    $ linearLayout
        [ width MATCH_PARENT
        , height WRAP_CONTENT
        , background Color.transparent
        , visibility if state.props.rideRequestFlow && state.props.currentStage /= ConfirmingLocation then GONE else VISIBLE
        , gravity RIGHT
        , alignParentBottom "true,-1"
        , padding $ Padding 0 0 16 14
        , disableClickFeedback true
        , accessibility DISABLE
        , margin if ((state.props.showlocUnserviceablePopUp) && state.props.currentStage == HomeScreen) then (MarginBottom (360 + safeMarginBottom)) else (Margin 0 0 0 0) --else if (state.props.currentStage == ConfirmingLocation) then (Margin ((screenWidth unit) - 66) 0 0 270) else(Margin ((screenWidth unit) - 66) 0 0 120)
        ]
        [ -- linearLayout
          --   [ width WRAP_CONTENT
          --   , height WRAP_CONTENT
          --   , stroke ("1," <> Color.grey900)
          --   , cornerRadii $ Corners 24.0 true true true true
          --   ][
          imageView
            [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_recenter_btn"
            , accessibility DISABLE
            , onClick
                ( \action -> do
                    _ <- push action
                    _ <- getCurrentPosition push UpdateCurrentLocation
                    _ <- pure $ logEvent state.data.logField "ny_user_recenter_btn_click"
                    pure unit
                )
                (const $ RecenterCurrentLocation)
            , height $ V 40
            , width $ V 40
            ]
        ]
-- ]

referralView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
referralView push state =
  let removeRefferal = (not state.data.config.feature.enableReferral) || (((any (_ == state.props.currentStage)) [RideAccepted, RideStarted, ChatWithDriver, SettingPrice]) || state.props.hasTakenRide || state.props.currentSheetState == EXPANDED)
  in
  linearLayout
    [ width WRAP_CONTENT
    , height WRAP_CONTENT
    , visibility $ boolToVisibility $ not removeRefferal
    , stroke $ "1," <> if not state.props.isReferred then Color.blue900 else Color.black700
    , margin (MarginHorizontal 16 13)
    , cornerRadius 20.0
    , background Color.white900
    , accessibility DISABLE_DESCENDANT
    , gravity RIGHT
    , padding (Padding 16 12 16 12)
    , onClick push $ const $ if state.props.isReferred then ReferralFlowNoAction else ReferralFlowAction
    ][
      imageView [
         imageWithFallback $ fetchImage FF_ASSET "ny_ic_tick"
        , width $ V 20
        , height $ V 15
        , margin (Margin 0 3 5 0)
        , visibility if state.props.isReferred then VISIBLE else GONE
      ]
      , textView $ [
        width WRAP_CONTENT
      , height WRAP_CONTENT
      , color if not state.props.isReferred then Color.blue900 else Color.black700
      , accessibility DISABLE
      , text if not state.props.isReferred then (getString HAVE_REFERRAL_CODE) else (getString REFERRAL_CODE_APPLIED)
      ] <> FontStyle.tags TypoGraphy
    ]

nammaSafetyView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
nammaSafetyView push state =
  linearLayout
  [ width WRAP_CONTENT
  , height WRAP_CONTENT
  , visibility $ boolToVisibility $ (any (_ == state.props.currentStage) ) [RideAccepted, RideStarted, ChatWithDriver]
  , stroke $ "1," <> Color.grey900
  , margin $ MarginHorizontal 16 16
  , cornerRadius 20.0
  , background Color.white900
  , accessibility ENABLE
  , accessibilityHint $ "Safety + : Button : Select to view S O S Options"
  , gravity CENTER_VERTICAL
  , clickable true
  , padding (Padding 12 8 12 8)
  ][ imageView 
    [ imageWithFallback $ fetchImage FF_ASSET "ny_ic_namma_safety"
    , width $ V 24
    , height $ V 24
    , margin $ MarginRight 4
    ]
  , textView $ 
    [ width WRAP_CONTENT
    , height WRAP_CONTENT
    , color Color.blue900
    , accessibility DISABLE
    , text $ getString NAMMA_SAFETY
    ] <> FontStyle.body1 TypoGraphy
  ]

sosView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
sosView push state =
  relativeLayout
    [ width WRAP_CONTENT
    , height WRAP_CONTENT
    , gravity CENTER
    , visibility $ boolToVisibility $ state.props.currentStage == RideStarted && state.data.config.feature.enableSafetyFlow
    , margin $ MarginRight 16
    ]
    [ linearLayout
        [ width WRAP_CONTENT
        , height WRAP_CONTENT
        , cornerRadius 20.0
        , clipChildren false
        , background Color.blue900
        , orientation VERTICAL
        , gravity CENTER
        , margin $ Margin 12 12 12 8
        ]
        [ safetyCenterView push INVISIBLE
        , textView
            $ [ text $ getString NEW <> "✨"
              , color Color.white900
              , margin $ MarginVertical 5 3
              , gravity CENTER
              ]
            <> FontStyle.body17 TypoGraphy
        ]
    , linearLayout
        [ height WRAP_CONTENT
        , width $ WRAP_CONTENT
        , shadow $ Shadow 0.1 2.0 10.0 24.0 Color.greyBackDarkColor 0.5
        , background Color.white900
        , cornerRadius 20.0
        , onClick push $ const OpenEmergencyHelp
        , rippleColor Color.rippleShade
        , padding $ Padding 12 8 12 8
        ]
        [ safetyCenterView push VISIBLE
        ]
    ]
  where
  safetyCenterView push vis =
    linearLayout
      [ height WRAP_CONTENT
      , width WRAP_CONTENT
      , gravity CENTER
      , visibility vis
      ]
      [ imageView
          [ imageWithFallback $ fetchImage FF_ASSET "ny_ic_sos"
          , height $ V 24
          , width $ V 24
          , margin $ MarginRight 8
          , accessibilityHint $ "S O S Button, Select to view S O S options"
          , accessibility ENABLE
          , onClick push $ const OpenEmergencyHelp
          ]
      , textView
          $ [ text $ getString SAFETY_CENTER
            , color Color.blue900
            , margin $ MarginBottom 1
            ]
          <> FontStyle.body6 TypoGraphy
      ]

liveStatsDashboardView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
liveStatsDashboardView push state =
  linearLayout
    [ width WRAP_CONTENT
    , height WRAP_CONTENT
    , visibility GONE
    , stroke $ "1," <> Color.blue900
    , margin (MarginHorizontal 16 13)
    , accessibility DISABLE_DESCENDANT
    , cornerRadius 20.0
    , background Color.white900
    , gravity RIGHT
    , padding (Padding 16 12 16 12)
    , onClick push $ const $ LiveDashboardAction
    ][
      imageView [
        imageWithFallback $ fetchImage FF_ASSET "ic_graph_blue"
        , width $ V 20
        , height $ V 15
        , margin (Margin 0 0 5 0)
      ]
      , textView $ [
        width WRAP_CONTENT
      , height WRAP_CONTENT
      , color Color.blue900
      , accessibility DISABLE
      , text (getString CHECK_OUT_LIVE_STATS)
      ] <> FontStyle.tags TypoGraphy
    ]

sourceUnserviceableView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
sourceUnserviceableView push state =
  PrestoAnim.animationSet [ fadeIn true ]
    $ relativeLayout
        [ height MATCH_PARENT
        , width MATCH_PARENT
        , orientation VERTICAL
        , cornerRadii $ Corners 24.0 true true false false
        , alignParentBottom "true,-1"
        , gravity BOTTOM
        ][ErrorModal.view (push <<< SourceUnserviceableActionController) (isMockLocationConfig state)]

rateCardView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
rateCardView push state =
  PrestoAnim.animationSet [ fadeIn true ]
    $ linearLayout
        [ height MATCH_PARENT
        , width MATCH_PARENT
        ]
        [ RateCard.view (push <<< RateCardAction) (rateCardConfig state) ]

buttonLayout :: forall w. HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
buttonLayout state push =
  PrestoAnim.animationSet (buttonLayoutAnimation state)
  $ linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , alignParentBottom "true,-1"
    , orientation VERTICAL
    , accessibility if state.props.currentStage == HomeScreen && (not (state.data.settingSideBar.opened /= SettingSideBar.CLOSED )) then DISABLE else DISABLE_DESCENDANT
    ]
    [ linearLayout
      [ width MATCH_PARENT
      , height WRAP_CONTENT
      , orientation HORIZONTAL
      ]
      [ referralView push state
      , recenterButtonView push state
      ]
    , linearLayout
      [ height WRAP_CONTENT
      , width MATCH_PARENT
      , background if ((null state.data.savedLocations  && null state.data.recentSearchs.predictionArray ) || state.props.isSearchLocation == LocateOnMap) then Color.transparent else Color.white900
      , gradient if os == "IOS" then (Linear 90.0 ["#FFFFFF" , "#FFFFFF" , "#FFFFFF", Color.transparent]) else (Linear 0.0 ["#FFFFFF" , "#FFFFFF" , "#FFFFFF", Color.transparent])
      , orientation VERTICAL
      , padding $ PaddingTop 16
      ] $ maybe ([]) (\item -> [bannersCarousal item state push]) state.data.bannerData.bannerItem
      <> [ PrimaryButton.view (push <<< PrimaryButtonActionController) (whereToButtonConfig state)
      , if state.props.isSearchLocation == LocateOnMap
        then emptyLayout state 
        else recentSearchesAndFavourites state push (null state.data.savedLocations) (null state.data.recentSearchs.predictionArray)
      ]
    ]

recentSearchesAndFavourites :: forall w. HomeScreenState -> (Action -> Effect Unit) -> Boolean -> Boolean -> PrestoDOM (Effect Unit) w
recentSearchesAndFavourites state push hideSavedLocsView hideRecentSearches =
  linearLayout
  [ width MATCH_PARENT
  , height WRAP_CONTENT
  , orientation VERTICAL
  , cornerRadii $ Corners (4.0) true true false false
  ]([ if (not hideSavedLocsView) then savedLocationsView state push else linearLayout[visibility GONE][]
    , shimmerView state
    , if state.data.config.feature.enableAdditionalServices then additionalServicesView push state else linearLayout[visibility GONE][]
    , suggestionsView push state
    , emptySuggestionsBanner state push
    ]
    )

bannersCarousal :: forall w. ListItem -> HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
bannersCarousal view state push =
  let banners = getBannerConfigs state BannerCarousel
      len = length banners
  in if len > 0
      then
        linearLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , margin $ MarginTop 24
        ][CarouselHolder.carouselView push $ getCarouselConfig view state banners]
      else dummyView state
      

emptySuggestionsBanner :: forall w. HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
emptySuggestionsBanner state push = 
  let appName = fromMaybe state.data.config.appData.name $ runFn3 getAnyFromWindow "appName" Nothing Just
  in linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , cornerRadius 12.0
    , margin $ Margin 16 10 16 10
    , gravity CENTER_HORIZONTAL
    , orientation VERTICAL
    , visibility $ boolToVisibility $ (not (suggestionViewVisibility state)) && not (state.props.showShimmer && null state.data.tripSuggestions) && state.data.config.homeScreen.bannerViewVisibility
    ][  imageView 
        [ height $ V 190
        , width $ V 220 
        , imageWithFallback $ getImageBasedOnCity "ny_ic_home_illustration"
        ]
      , textView $
        [ text $ getVarString WELCOME_TEXT $ Arr.singleton appName
        , gravity CENTER
        , width MATCH_PARENT 
        , margin $ MarginBottom 12
        , color Color.black900
        ] <> (FontStyle.subHeading1 LanguageStyle)
      , textView $
        [ text $ getString TAP_WHERE_TO_TO_BOOK_RIDE
        , height WRAP_CONTENT
        , gravity CENTER
        , width MATCH_PARENT 
        , color Color.black700
        ] <> (FontStyle.body1 LanguageStyle)
     ]

savedLocationsView :: forall w. HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
savedLocationsView state push =
  linearLayout
    [ width MATCH_PARENT
    , height WRAP_CONTENT
    , clickable state.props.isSrcServiceable
    , padding $ PaddingHorizontal 16 16
    ]
    [ linearLayout
        [ width MATCH_PARENT
        , height MATCH_PARENT
        , margin $ MarginTop 16
        , alpha if state.props.isSrcServiceable then 1.0 else 0.4
        , onClick push (const NoAction)
        ]
        [ LocationTagBar.view (push <<< SavedAddressClicked) { savedLocations: state.data.savedLocations } ]
    ]

recentSearchesView :: forall w. HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
recentSearchesView state push =
  linearLayout
    [ width MATCH_PARENT
    , height WRAP_CONTENT
    , orientation VERTICAL
    , margin $ MarginTop 16
    , padding $ PaddingHorizontal 16 16
    , visibility $ boolToVisibility $ not $ null state.data.destinationSuggestions
    ]
    [ linearLayout
        [ height MATCH_PARENT
        , width MATCH_PARENT
        , cornerRadius 8.0
        , stroke $ "1," <> Color.grey900
        , orientation VERTICAL
        ]
        ( mapWithIndex
            ( \index item ->
                linearLayout
                  [ width MATCH_PARENT
                  , height WRAP_CONTENT
                  , orientation VERTICAL
                  , visibility if (state.props.isBanner && index >0) then GONE else VISIBLE
                  ]
                  [ LocationListItem.view (push <<< PredictionClickedAction) item false
                  , linearLayout
                      [ height $ V 1
                      , width MATCH_PARENT
                      , background Color.lightGreyShade
                      , visibility if (index == (length state.data.destinationSuggestions) - 1) || (state.props.isBanner) then GONE else VISIBLE
                      ]
                      []
                  ]
            )
            (take 2 state.data.destinationSuggestions)
        )
    ]

buttonLayoutAnimation :: HomeScreenState -> Array PrestoAnim.Animation
buttonLayoutAnimation state = [fadeIn state.props.showShimmer]
------------- settingSideBarView ------------
settingSideBarView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
settingSideBarView push state =
  linearLayout
    [ weight 1.0
    , height MATCH_PARENT
    , width MATCH_PARENT
    , accessibility if state.data.settingSideBar.opened /= SettingSideBar.CLOSED && not (state.props.isPopUp /= NoPopUp) then DISABLE else DISABLE_DESCENDANT
    ]
    [ SettingSideBar.view (push <<< SettingSideBarActionController) (state.data.settingSideBar{appConfig = state.data.config}) ]

homeScreenTopIconView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
homeScreenTopIconView push state =
  homeScreenAnimation TOP_BOTTOM
    $
     -- 1000 (-100) 0 0 true $ PrestoAnim.Bezier 0.37 0.0 0.63 1.0] $
     linearLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , orientation VERTICAL
        , accessibility if (any (_ == state.props.currentStage) ) [RideRating, RideCompleted] then DISABLE_DESCENDANT else DISABLE
        ]
        [ linearLayout
            [ width MATCH_PARENT
            , height WRAP_CONTENT
            , background Color.white900
            , orientation HORIZONTAL
            , gravity LEFT
            , visibility if state.data.config.terminateBtnConfig.visibility then VISIBLE else GONE
            ]
            [ linearLayout
                [ width WRAP_CONTENT
                , height WRAP_CONTENT
                , margin $ MarginLeft 16
                , padding $ Padding 6 6 6 6
                , gravity CENTER_VERTICAL
                , onClick push (const TerminateApp)
                ]
                [ imageView
                    [ imageWithFallback state.data.config.terminateBtnConfig.imageUrl
                    , height $ V 20
                    , width $ V 20
                    , margin $ MarginRight 10
                    ]
                , textView
                    $ [ width WRAP_CONTENT
                      , height WRAP_CONTENT
                      , gravity CENTER_VERTICAL
                      , text state.data.config.terminateBtnConfig.title
                      , color Color.black900
                      ]
                    <> FontStyle.tags TypoGraphy
                ]
            ]
        , linearLayout
            [ height WRAP_CONTENT
            , width MATCH_PARENT
            , orientation HORIZONTAL
            , cornerRadius 8.0
            , background Color.white900
            , visibility if state.props.rideRequestFlow then GONE else VISIBLE
            , stroke $ "1," <> Color.grey900
            , gravity CENTER_VERTICAL
            , margin (Margin 16 26 16 0)
            , padding (Padding 0 16 16 16)
            ]
            [ linearLayout
                [ width WRAP_CONTENT -- $ V 54
                , height MATCH_PARENT
                , gravity CENTER
                , disableClickFeedback true
                , clickable if state.props.currentStage == SearchLocationModel then false else true
                , visibility if (any (_ == state.props.currentStage) [RideCompleted]) then GONE else VISIBLE
                , onClick push $ const OpenSettings
                , rippleColor Color.rippleShade
                ]
                [ imageView
                    [ imageWithFallback $ fetchImage FF_ASSET $ if state.data.config.dashboard.enable && (checkVersion "LazyCheck") then "ic_menu_notify" else "ny_ic_hamburger"
                    , height $ V 24
                    , width $ V 24
                    , margin (Margin 16 16 16 16)
                    , accessibility if state.props.currentStage == ChatWithDriver || state.props.isCancelRide || state.props.isLocationTracking || state.props.callSupportPopUp || state.props.cancelSearchCallDriver then DISABLE else ENABLE
                    , accessibilityHint "Navigation : Button"
                    ]
                ]
            , linearLayout
                [ height $ V 42
                , width $ V 1
                , background Color.grey900
                ]
                []
            , imageView
                [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_source_dot"
                , height $ V 16
                , width $ V 16
                , margin (Margin 5 5 5 5)
                , accessibility DISABLE
                , onClick push $ if state.props.isSrcServiceable then (const $ OpenSearchLocation) else (const $ NoAction)
                , gravity BOTTOM
                ]
            , linearLayout
                [ orientation VERTICAL
                , width MATCH_PARENT
                , height WRAP_CONTENT
                , disableClickFeedback true
                , onClick push $ if state.props.isSrcServiceable then (const $ OpenSearchLocation) else (const $ NoAction)
                , accessibility if any (_ == state.props.currentStage) [RideRating , RideCompleted] then DISABLE else ENABLE
                , accessibilityHint "Pickup Location is Current Location"
                , accessibility ENABLE
                ]
                [ textView
                    $ [ height WRAP_CONTENT
                      , width MATCH_PARENT
                      , text (getString PICK_UP_LOCATION)
                      , color Color.black800
                      , gravity LEFT
                      , lineHeight "16"
                      ]
                    <> FontStyle.body3 LanguageStyle
                , textView
                    $ [ height WRAP_CONTENT
                      , width MATCH_PARENT
                      , text if state.props.isSrcServiceable then
                              (if state.data.source /= "" then state.data.source else (getString CURRENT_LOCATION))
                             else
                               getString APP_NOT_SERVICEABLE
                      , maxLines 1
                      , ellipsize true
                      , color if state.props.isSrcServiceable then Color.black800 else Color.greyDark
                      , gravity LEFT
                      , lineHeight "23"
                      ]
                    <> FontStyle.body7 LanguageStyle
                ]
            ]
        ]
  where
  homeScreenAnimation direction = PrestoAnim.animationSet [ translateYAnimFromTop $ translateYAnimHomeConfig direction ]

checkVersion :: String -> Boolean
checkVersion str = getValueToLocalStore LIVE_DASHBOARD /= "LIVE_DASHBOARD_SELECTED" && not (isPreviousVersion (getValueToLocalStore VERSION_NAME) (if os == "IOS" then "1.2.5" else "1.2.1"))

------------------------------- rideRequestFlowView --------------------------
rideRequestFlowView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
rideRequestFlowView push state =
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , cornerRadii $ Corners 24.0 true true false false
    , visibility $ boolToVisibility $ isStageInList state.props.currentStage [ SettingPrice, ConfirmingLocation, RideCompleted, FindingEstimate, ConfirmingRide, FindingQuotes, TryAgain, RideRating, ReAllocated] 
    , alignParentBottom "true,-1"
    ]
    [ -- TODO Add Animations
      -- PrestoAnim.animationSet
      -- [ translateYAnim (300) 0 state.props.rideRequestFlow
      -- , translateYAnim 0 (300) (not state.props.rideRequestFlow)
      -- ] $
      relativeLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , cornerRadii $ Corners 24.0 true true false false
        , background Color.transparent
        , accessibility DISABLE
        ]
        [ PrestoAnim.animationSet [fadeIn true] $ getViewBasedOnStage push state
        , if isStageInList state.props.currentStage [ FindingEstimate, ConfirmingRide, TryAgain, FindingQuotes, ReAllocated] then
            (loaderView push state)
          else
            emptyTextView state
        ]
    ]
    where
      getViewBasedOnStage :: (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
      getViewBasedOnStage push state = do
        if state.props.currentStage == SettingPrice then
          if state.props.isRepeatRide && checkRecentRideVariant state
            then estimatedFareView push state
          else
            ChooseYourRide.view (push <<< ChooseYourRideAction) (chooseYourRideConfig state)
        else if state.props.currentStage == ConfirmingLocation then
          confirmPickUpLocationView push state
        else
          emptyTextView state

      isCityInList :: City -> Array City -> Boolean
      isCityInList city = any (_ == city)

isStageInList :: Stage -> Array Stage -> Boolean
isStageInList stage = any (_ == stage)

-------------- rideRatingCardView -------------
rideRatingCardView :: forall w. HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
rideRatingCardView state push =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , gravity BOTTOM
    , background Color.transparent
    ]
    [ RatingCard.view (push <<< RatingCardAC) $ ratingCardViewState state
    ]

commonTextView :: forall w. HomeScreenState -> (Action -> Effect Unit) -> String -> String -> (forall properties. (Array (Prop properties))) -> Int -> PrestoDOM (Effect Unit) w
commonTextView state push text' color' fontStyle marginTop =
  textView $
  [ width MATCH_PARENT
  , height WRAP_CONTENT
  , accessibilityHint text'
  , accessibility ENABLE
  , text text'
  , color color'
  , gravity CENTER
  , margin $ MarginTop marginTop
  ] <> fontStyle

----------- topLeftIconView -------------
topLeftIconView :: forall w. HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
topLeftIconView state push =
  let image = if (any (_ == state.props.currentStage) [ SettingPrice, ConfirmingLocation, PricingTutorial, DistanceOutsideLimits ]) then fetchImage FF_COMMON_ASSET "ny_ic_chevron_left" else if state.data.config.dashboard.enable && (checkVersion "LazyCheck") then fetchImage FF_ASSET "ic_menu_notify" else fetchImage FF_ASSET "ny_ic_hamburger"
      onClickAction = if (any (_ == state.props.currentStage) [ SettingPrice, ConfirmingLocation, PricingTutorial, DistanceOutsideLimits ]) then const BackPressed else const OpenSettings
      isBackPress = (any (_ == state.props.currentStage) [ SettingPrice, ConfirmingLocation, PricingTutorial, DistanceOutsideLimits ]) 
      followerBar = (showFollowerBar (fromMaybe [] state.data.followers) state) && (any (_ == state.props.currentStage) [RideAccepted, RideStarted, ChatWithDriver])
  in 
  linearLayout
    [ width MATCH_PARENT
    , height WRAP_CONTENT
    , orientation VERTICAL
    , visibility $ boolToVisibility  state.data.config.showHamMenu
    , margin $ MarginTop if followerBar then 0 else safeMarginTop
    ]
    $ []
    <> ( case state.data.followers of
          Nothing -> []
          Just followers -> if followerBar then [ followRideBar push followers (MATCH_PARENT) true] else []
      )
    <> ( [ linearLayout
            [ width MATCH_PARENT
            , height WRAP_CONTENT
            , orientation HORIZONTAL
            , visibility $ boolToVisibility  state.data.config.showHamMenu
            , margin $ Margin 16 20 0 0
            , accessibility if state.data.settingSideBar.opened /= SettingSideBar.CLOSED || state.props.currentStage == ChatWithDriver || state.props.isCancelRide || state.props.isLocationTracking || state.props.callSupportPopUp || state.props.cancelSearchCallDriver || state.props.showCallPopUp || state.props.showRateCard || state.data.waitTimeInfo then DISABLE_DESCENDANT else DISABLE
            ]
            [ linearLayout
                [ height $ V 48
                , width $ V 48
                , stroke ("1," <> Color.grey900)
                , background Color.white900
                , gravity CENTER
                , cornerRadius 24.0
                , visibility $ boolToVisibility $ not (any (_ == state.props.currentStage) [ FindingEstimate, ConfirmingRide, FindingQuotes, TryAgain, RideCompleted, RideRating, ReAllocated ])
                , clickable true
                , onClick push $ if isBackPress then const BackPressed else const OpenSettings
                , accessibilityHint if isBackPress then "Back : Button" else "Menu : Button"
                , accessibility ENABLE
                , rippleColor Color.rippleShade
                ]
                [ imageView
                    [ imageWithFallback image
                    , height $ V 25
                    , accessibility DISABLE
                    , clickable true
                    , onClick push $ onClickAction
                    , width $ V 25
                    ]
                ]
            , linearLayout
                [ height WRAP_CONTENT
                , weight 1.0
                ]
                []
            , referralView push state
            , bookingPreferenceButton push state
            , sosView push state
            , if (not state.data.config.dashboard.enable) || (isPreviousVersion (getValueToLocalStore VERSION_NAME) (if os == "IOS" then "1.2.5" else "1.2.1")) then emptyTextView state else liveStatsDashboardView push state
            ]
        ]
      )

----------- estimatedFareView ----------------
estimatedFareView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
estimatedFareView push state =
  let tagConfig = specialZoneTagConfig state.props.zoneType.priorityTag
  in
  linearLayout
  [ orientation VERTICAL
  , height WRAP_CONTENT
  , width MATCH_PARENT
  , background tagConfig.backgroundColor
  , clickable true
  , visibility if (state.props.currentStage == SettingPrice) then VISIBLE else GONE
  , stroke ("1," <> Color.grey900)
  , gravity CENTER
  , cornerRadii $ Corners 24.0 true true false false
  , afterRender
        ( \action -> do            
            let fareEstimate = if state.data.rateCard.additionalFare == 0 then "₹" <> (show state.data.suggestedAmount) else  "₹" <> (show state.data.suggestedAmount) <> "-" <> "₹" <> (show $ (state.data.suggestedAmount + state.data.rateCard.additionalFare))
            _ <- pure $  setValueToLocalStore FARE_ESTIMATE_DATA fareEstimate
            pure unit
        )
        (const NoAction)
  ][  linearLayout
      [ width MATCH_PARENT
      , height WRAP_CONTENT
      , orientation HORIZONTAL
      , gravity CENTER
      , padding (Padding 8 4 8 4)
      , visibility if state.props.zoneType.priorityTag /= NOZONE then VISIBLE else GONE
      , clickable $ isJust tagConfig.infoPopUpConfig
      , onClick push $ const $ SpecialZoneInfoTag
      ] [ imageView
          [ width (V 15)
          , height (V 15)
          , margin (MarginRight 6)
          , imageWithFallback $ fetchImage FF_COMMON_ASSET tagConfig.icon
          ]
        , textView
          [ width WRAP_CONTENT
          , height WRAP_CONTENT
          , textSize FontSize.a_14
          , text tagConfig.text
          , color Color.white900
          ]
        , imageView
          [ width (V 18)
          , height (V 18)
          , visibility if isJust tagConfig.infoPopUpConfig then VISIBLE else GONE
          , margin (MarginLeft 6)
          , imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_white_info"
          ]
        ]
    , linearLayout
      [ orientation VERTICAL
      , height WRAP_CONTENT
      , width MATCH_PARENT
      , background Color.white900
      , clickable true
      , accessibility if state.props.showRateCard then DISABLE_DESCENDANT else DISABLE
      , visibility if (state.props.currentStage == SettingPrice) then VISIBLE else GONE
      , padding (Padding 16 7 16 24)
      , stroke ("1," <> Color.grey900)
      , gravity CENTER
      , cornerRadii $ Corners 24.0 true true false false
      ][ estimateHeaderView push state
        , linearLayout
          [ width MATCH_PARENT
          , height WRAP_CONTENT
          , orientation VERTICAL
          , gravity CENTER
          , cornerRadius 8.0
          , margin $ MarginTop 16
          ][ rideDetailsViewV2 push state]
        , sourceDestinationDetailsView push state
        , requestRideButtonView push state
        , linearLayout
            [ width MATCH_PARENT
            , height WRAP_CONTENT
            , gravity CENTER
            , margin $ MarginTop 24
            , visibility if state.props.isRepeatRide && not DS.null state.props.repeatRideTimerId then VISIBLE else GONE
            ][ textView $
                [ textFromHtml $ "<u>" <> (getString TAP_HERE_TO_STOP_AUTO_REQUESTING) <> "</u>" 
                , color Color.black700
                ] <> FontStyle.body1 LanguageStyle
            ]
      ]
  ]

estimateHeaderView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
estimateHeaderView push state =
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation VERTICAL
    , gravity CENTER_HORIZONTAL
    , accessibility ENABLE
    , accessibilityHint $ "PickUp Location Is : " 
                         <> state.data.source 
                         <> " . And Destination Location Is : "  
                         <> state.data.destination
    ]
    [ textView $
        [ text (getString CONFIRM_YOUR_RIDE)
        , color Color.black800
        , gravity CENTER_HORIZONTAL
        , height WRAP_CONTENT
        , width MATCH_PARENT
        ] 
        <> FontStyle.h1 TypoGraphy
    , estimatedTimeDistanceView push state
    , linearLayout
        [ height $ V 1
        , width MATCH_PARENT
        , margin $ MarginTop 12
        , background Color.grey900
        ][]
    ]

estimatedTimeDistanceView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
estimatedTimeDistanceView push state =
  linearLayout
    [ width MATCH_PARENT
    , height WRAP_CONTENT
    , gravity CENTER
    , margin $ MarginTop 4
    ]
    [ createTextView state.data.rideDistance
    , linearLayout
        [ height $ V 4
        , width $ V 4
        , cornerRadius 2.5
        , background Color.black600
        , margin (Margin 6 2 6 0)
        ]
        []
    , createTextView state.data.rideDuration
    ]
  where
    createTextView :: String -> PrestoDOM (Effect Unit) w
    createTextView textContent =
      textView $
        [ height WRAP_CONTENT
        , width WRAP_CONTENT
        , text textContent
        , color Color.black650
        ]
        <> FontStyle.paragraphText TypoGraphy

rideDetailsViewV2 :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
rideDetailsViewV2 push state = 
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation HORIZONTAL
    ][ ChooseVehicle.view (push <<< ChooseSingleVehicleAction) (chooseVehicleConfig state)]

rideDetailsView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
rideDetailsView push state = 
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation HORIZONTAL
    , padding $ PaddingTop 12
    , margin $ MarginHorizontal 16 16
    ][ linearLayout
        [ height WRAP_CONTENT
        , orientation HORIZONTAL
        , gravity LEFT
        , weight 1.0
        ][ imageView  
            [ imageWithFallback $ fetchImage FF_ASSET "ny_ic_auto_quote_list"
            , width $ V 55
            , height $ V 40
            ]
         , linearLayout
            [ width WRAP_CONTENT
            , height WRAP_CONTENT
            , accessibility DISABLE
            , gravity CENTER
            , orientation VERTICAL
            ][ textView $
                [ text state.data.rideDistance
                , width MATCH_PARENT
                , accessibilityHint $ "Estimated Ride Distance And Ride Duration Is " <> (fromMaybe "0" (head (DS.split (DS.Pattern " ") state.data.rideDistance))) <> (if any (_ == "km") (DS.split (DS.Pattern " ") state.data.rideDistance) then "Kilo Meters" else "Meters") <> " And " <> state.data.rideDuration
                , color Color.black800
                , accessibility ENABLE
                , height WRAP_CONTENT
                ] <> FontStyle.body4 LanguageStyle
              , textView $
                [ text state.data.rideDuration
                , accessibility DISABLE
                , width MATCH_PARENT
                , color Color.black700
                , height WRAP_CONTENT
                ] <> FontStyle.body3 LanguageStyle
            ]
        ]
    , linearLayout
        [ width WRAP_CONTENT
        , height MATCH_PARENT
        , gravity CENTER_VERTICAL
        ][ let fareEstimate = if state.data.rateCard.additionalFare == 0 then state.data.config.currency <> (show state.data.suggestedAmount) else  state.data.config.currency <> (show state.data.suggestedAmount) <> "-" <> state.data.config.currency <> (show $ (state.data.suggestedAmount + state.data.rateCard.additionalFare))
           in
            textView $
            [ text $ fareEstimate
            , width WRAP_CONTENT
            , color Color.black900
            , height WRAP_CONTENT
            , fontStyle $ FontStyle.bold LanguageStyle
            , accessibilityHint $ "Estimated Fare Is " <> fareEstimate
            , onClick (\action -> if state.data.config.searchLocationConfig.enableRateCard then push action else pure unit ) $ const ShowRateCard
            ] <> FontStyle.body7 LanguageStyle
         , imageView
            [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_info_blue"
            , width $ V 40
            , height $ V 40
            , accessibility DISABLE
            , visibility if state.data.config.searchLocationConfig.enableRateCard then VISIBLE else GONE
            , onClick (\action -> if state.data.config.searchLocationConfig.enableRateCard then push action else pure unit ) $ const ShowRateCard
            ]
        ]
    ]

sourceDestinationDetailsView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
sourceDestinationDetailsView push state = 
  linearLayout
    [ orientation HORIZONTAL
    , height WRAP_CONTENT
    , width MATCH_PARENT
    , background Color.white900
    , clickable true
    , visibility if (state.props.currentStage == SettingPrice) && state.props.isRepeatRide then VISIBLE else GONE
    , margin (MarginTop 16)
    , padding (Padding 12 12 12 12)
    , stroke ("1," <> Color.grey900)
    , gravity CENTER_VERTICAL
    , cornerRadii $ Corners 10.0 true true true true
    ][ 
      linearLayout
        [ weight 1.0
        , height WRAP_CONTENT
        , accessibilityHint $ "PickUp Location Is : " <> state.data.source <> " . And Destination Location Is : "  <> state.data.destination
        ][SourceToDestination.view (push <<< SourceToDestinationActionController) (sourceToDestinationConfig state)]
      , imageView
          [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_edit"
          , height $ V 40
          , width $ V 40
          , accessibilityHint "Go back to edit source or destination : Button"
          , onClick push $ const BackPressed
          ]
    ]

requestRideButtonView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
requestRideButtonView push state =
  let 
    animationDuration = state.data.config.suggestedTripsAndLocationConfig.repeatRideTime * 1000 - 100
    isRepeatRideTimerNonZero = state.props.repeatRideTimer /= "0"
  in
  relativeLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    ] 
    [ PrimaryButton.view (push <<< PrimaryButtonActionController) (confirmAndBookButtonConfig state)
    , PrestoAnim.animationSet
        [ translateOutXBackwardAnimY animConfig
            { duration = animationDuration
            , toX = (screenWidth unit)
            , fromY = 0
            , ifAnim = isRepeatRideTimerNonZero
            }
        ]  
        $ linearLayout
            [ height $ V 50
            , width MATCH_PARENT
            , alpha 0.5
            , background Color.white900
            , visibility $ boolToVisibility (not DS.null state.props.repeatRideTimerId)
            , margin $ MarginTop 16
            ][]
    ]

bookingPreferencesView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
bookingPreferencesView push state = 
 linearLayout
  [ width MATCH_PARENT
  , height MATCH_PARENT
  , orientation VERTICAL
  , background Color.black7000
  , onClick push $ const $ BackPressed
  , clickable true
  , gravity RIGHT
  , accessibility DISABLE_DESCENDANT
  , accessibility DISABLE
  , clipChildren false
  ][linearLayout
    [ height WRAP_CONTENT 
    , width MATCH_PARENT
    , gravity RIGHT
    , margin $ MarginTop (if os == "IOS" then safeMarginTop+20 else 20)
    ][bookingPreferenceButton push state]
    , relativeLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , gravity RIGHT
    ][ bookingPreferencePopUp push state
      , bookingPreferencesInfoView push state
    ]
  ]

bookingPreferencePopUp :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
bookingPreferencePopUp push state = 
  linearLayout
  [ height WRAP_CONTENT
  , width $ WRAP_CONTENT
  , margin $ Margin 16 4 16 8
  , background Color.white900
  , cornerRadius 20.0
  , clickable true
  , onClick push $ const $ NoAction
  , shadow $ Shadow 0.1 0.1 10.0 24.0 Color.white13 0.5
  , orientation VERTICAL
  , visibility $ if state.props.showMultipleRideInfo && os == "IOS" then INVISIBLE else VISIBLE
  , padding $ Padding 16 16 16 16
  ][ (if os == "IOS" then linearLayout else horizontalScrollView)
      [ width MATCH_PARENT
      , height WRAP_CONTENT
      , scrollBarX false
      ][linearLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , orientation VERTICAL
        ][ showMenuButtonView push (getString AUTO_ASSIGN_DRIVER) (fetchImage FF_ASSET "ny_ic_faster_lightning") true state
        , showMenuButtonView push (getString CHOOSE_BETWEEN_MULTIPLE_DRIVERS) (fetchImage FF_ASSET "ny_ic_info") false state
        ]
      ]
    ]

bookingPreferencesInfoView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
bookingPreferencesInfoView push state = 
  linearLayout
  [ height WRAP_CONTENT
  , width MATCH_PARENT
  , background Color.white900
  , cornerRadius 16.0
  , clickable true
  , orientation VERTICAL
  , margin $ MarginHorizontal 16 16
  , accessibility DISABLE_DESCENDANT
  , accessibility DISABLE
  , visibility $ boolToVisibility state.props.showMultipleRideInfo
  ][linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    ][linearLayout
      [ orientation VERTICAL
      , width $ V $ (screenWidth unit) - 148
      , height WRAP_CONTENT
      , padding $ PaddingLeft 16
      , margin $ MarginVertical 24 (if os == "IOS" then 16 else 12)
      ][textView $ 
        [ text $ getString CHOOSE_BETWEEN_MULTIPLE_RIDES
        , color Color.black800
        , margin $ MarginBottom 16
        ] <> FontStyle.subHeading3 LanguageStyle
      , textView $ 
        [ text $ getString ENABLE_THIS_FEATURE_TO_CHOOSE_YOUR_RIDE
        , color Color.black700
        ] <> FontStyle.paragraphText LanguageStyle
      ]
    , linearLayout[height WRAP_CONTENT, weight 1.0][]
    , imageView
      [ imageWithFallback $ fetchImage FF_ASSET "ny_ic_select_offer"
      , height $ V 122
      , width $ V 116
      ]
    ] 
  , linearLayout
    [ height WRAP_CONTENT
    , width $ V $ (screenWidth unit) - 32
    , padding $ PaddingVertical 8 20
    , gravity CENTER_HORIZONTAL
    , onClick push $ const $ BackPressed
    ][textView $ 
      [ text $ getString GOT_IT
      , color Color.blue800
      , gravity CENTER_HORIZONTAL
      ] <> FontStyle.subHeading3 LanguageStyle
    ]
  ]

bookingPreferenceButton :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
bookingPreferenceButton push state = 
  linearLayout
  [ height WRAP_CONTENT
  , width WRAP_CONTENT
  , onClick push $ const $ ShowBookingPreference
  , clickable true
  , visibility $ boolToVisibility $ state.data.config.estimateAndQuoteConfig.enableBookingPreference  && not state.props.isRepeatRide && state.props.city == Bangalore && state.props.currentStage == SettingPrice
  , clipChildren false
  , accessibility DISABLE_DESCENDANT
  , accessibility DISABLE
  ][ linearLayout
    [ height $ V 40
    , width WRAP_CONTENT
    , padding $ Padding 12 4 12 4
    , shadow $ Shadow 0.1 0.1 10.0 24.0 Color.white13 0.5
    , cornerRadius if os == "IOS" then 20.0 else 32.0
    , gravity CENTER
    , margin $ Margin 16 8 16 8
    , background Color.white900
    ][ imageView
        [ height $ V 20
        , width $ V 20
        , imageWithFallback $ fetchImage FF_ASSET "ny_ic_filter"
        , margin $ MarginRight 8
        ]
      , textView $ 
        [ text $ getString BOOKING_PREFERENCE
        , color Color.black800
        , lineHeight "18"
        ] <> FontStyle.body6 LanguageStyle
    ]
  ]

showMenuButtonView :: forall w. (Action -> Effect Unit) -> String -> String -> Boolean -> HomeScreenState -> PrestoDOM (Effect Unit) w
showMenuButtonView push menuText menuImage autoAssign state =
  let 
      flowWithoutOffers' = flowWithoutOffers WithoutOffers
      isAutoAssign = flowWithoutOffers' && autoAssign || not flowWithoutOffers' && not autoAssign
  in
  linearLayout
  [ width WRAP_CONTENT
  , height WRAP_CONTENT
  , gravity CENTER
  ][ linearLayout
     [ height $ V 30
     , width $ V 30
     , gravity CENTER
     , onClick push $ const $ CheckBoxClick autoAssign
     ][ linearLayout
        [ height $ V 20
        , width $ V 20
        , stroke if isAutoAssign then ("2," <> state.data.config.primaryBackground) else ("2," <> Color.black600)
        , cornerRadius 10.0
        , gravity CENTER
       ][ linearLayout
          [ width $ V 10
          , height $ V 10
          , cornerRadius 5.0
          , background $ state.data.config.primaryBackground
          , visibility $ boolToVisibility isAutoAssign
          ][]
        ]
     ]
    , textView $
      [ text menuText
      , width MATCH_PARENT
      , gravity CENTER
      , color state.data.config.estimateAndQuoteConfig.textColor
      , height WRAP_CONTENT
      , padding $ Padding 8 10 0 10
      , onClick push (const $ CheckBoxClick autoAssign)
      ] <> FontStyle.paragraphText LanguageStyle
    , if autoAssign then
        linearLayout
        [ width WRAP_CONTENT
        , height WRAP_CONTENT
        , background state.data.config.autoSelectBackground
        , cornerRadius 14.0
        , gravity CENTER
        , margin $ MarginLeft 8
        , padding $ Padding 10 6 10 6
        ][  imageView
            [ height $ V 12
            , width $ V 8
            , margin $ MarginRight 4
            , imageWithFallback menuImage
            ]
          , textView $
            [ text $ getString FASTER
            , width WRAP_CONTENT
            , gravity CENTER
            , color Color.white900
            , height WRAP_CONTENT
            ] <> FontStyle.body15 LanguageStyle
          ]
        else
          linearLayout
          [ height $ V 24
          , width $ V 24
          , clickable true
          , margin $ MarginLeft 4
          , gravity CENTER
          , onClick push $ const $ OnIconClick autoAssign
          ][imageView
            [ height $ V 16
            , width $ V 16
            , imageWithFallback menuImage
            ]
          ]
  ]

estimatedTimeAndDistanceView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
estimatedTimeAndDistanceView push state =
  linearLayout
  [ width WRAP_CONTENT
  , height WRAP_CONTENT
  , accessibility DISABLE
  , gravity CENTER
  , margin $ MarginTop 4
  ][ textView $
      [ text state.data.rideDistance
      , width MATCH_PARENT
      , gravity CENTER
      , accessibilityHint $ "Estimated Ride Distance And Ride Duration Is " <> (fromMaybe "0" (head (DS.split (DS.Pattern " ") state.data.rideDistance))) <> (if any (_ == "km") (DS.split (DS.Pattern " ") state.data.rideDistance) then "Kilo Meters" else "Meters") <> " And " <> state.data.rideDuration
      , color Color.black650
      , accessibility ENABLE
      , height WRAP_CONTENT
      ] <> FontStyle.paragraphText LanguageStyle
    , linearLayout
      [height $ V 4
      , width $ V 4
      , cornerRadius 2.5
      , background Color.black600
      , margin (Margin 6 2 6 0)
      ][]
    , textView $
      [ text state.data.rideDuration
      , accessibility DISABLE
      , width MATCH_PARENT
      , gravity CENTER
      , color Color.black650
      , height WRAP_CONTENT
      ] <> FontStyle.paragraphText LanguageStyle
  ]

locationTrackingPopUp :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
locationTrackingPopUp push state =
  relativeLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , background Color.black9000
    , alignParentBottom "true,-1"
    , onClick push (const $ CloseLocationTracking)
    , disableClickFeedback true
    ]
    [ linearLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , background Color.white900
        , orientation VERTICAL
        , cornerRadii $ Corners 24.0 true true false false
        , padding (Padding 20 32 20 25)
        , onClick push (const $ TrackLiveLocationAction)
        , alignParentBottom "true,-1"
        , disableClickFeedback true
        ]
        [ textView
            $
              [ text (getString TRACK_LIVE_LOCATION_USING)
              , height WRAP_CONTENT
              , color Color.black700
              ]
            <> FontStyle.subHeading2 TypoGraphy
        , linearLayout
            [ height WRAP_CONTENT
            , width MATCH_PARENT
            , orientation VERTICAL
            , padding (PaddingTop 32)
            ]
            ( mapWithIndex
                ( \idx item ->
                    linearLayout
                      [ height WRAP_CONTENT
                      , width MATCH_PARENT
                      , orientation VERTICAL
                      ]
                      [ trackingCardView push state item
                      , linearLayout
                          [ height $ V 1
                          , width MATCH_PARENT
                          , background Color.grey900
                          , visibility if (state.props.currentStage == RideAccepted && item.type == "GOOGLE_MAP") || (idx == (length (locationTrackingData "lazyCheck")) - 1) then GONE else VISIBLE
                          ]
                          []
                      ]
                )
                (locationTrackingData "LazyCheck")
            )
        ]
    ]

estimateChangedPopUp :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
estimateChangedPopUp push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , accessibility if state.props.isEstimateChanged then DISABLE else DISABLE_DESCENDANT
    , gravity BOTTOM
    ]
    [ PopUpModal.view (push <<< EstimateChangedPopUpController) (estimateChangedPopupConfig state) ]

trackingCardView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> { text :: String, imageWithFallback :: String, type :: String } -> PrestoDOM (Effect Unit) w
trackingCardView push state item =
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation HORIZONTAL
    , padding (Padding 0 20 0 20)
    , onClick push (const (StartLocationTracking item.type))
    , visibility if (state.props.currentStage == RideAccepted && item.type == "GOOGLE_MAP") then GONE else VISIBLE
    ]
    [ imageView
        [ imageWithFallback item.imageWithFallback
        , height $ V 25
        , width $ V 25
        , margin (MarginRight 20)
        ]
    , textView
        $
          [ height WRAP_CONTENT
          , width WRAP_CONTENT
          , text item.text
          , gravity CENTER_VERTICAL
          , color Color.black800
          ]
        <> if state.props.isInApp && item.type == "IN_APP" then FontStyle.subHeading1 TypoGraphy else FontStyle.subHeading2 TypoGraphy
    , linearLayout
        [ height WRAP_CONTENT
        , weight 1.0
        ]
        []
    , imageView
        [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_chevron_right"
        , height $ V 20
        , width $ V 22
        , padding (Padding 3 3 3 3)
        ]
    ]

locationTrackingData :: String -> Array { text :: String, imageWithFallback :: String, type :: String }
locationTrackingData lazyCheck =
  [ { text: (getString GOOGLE_MAP_)
    , imageWithFallback: fetchImage FF_ASSET "ny_ic_track_google_map"
    , type: "GOOGLE_MAP"
    }
  , { text: (getString IN_APP_TRACKING)
    , imageWithFallback: fetchImage FF_ASSET "ny_ic_track_in_app"
    , type: "IN_APP"
    }
  ]

----------- confirmPickUpLocationView -------------
confirmPickUpLocationView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
confirmPickUpLocationView push state =
  let zonePadding = if os == "IOS" then 0 else (ceil (toNumber (screenWidth unit))/8)
      confirmLocationCategory = getConfirmLocationCategory state
      tagConfig = specialZoneTagConfig confirmLocationCategory
      tagVisibility = confirmLocationCategory /= NOZONE && (not (DS.null state.props.defaultPickUpPoint) || any (_ == confirmLocationCategory) [HOTSPOT true, HOTSPOT false])
  in
  linearLayout
    [ orientation VERTICAL
    , height WRAP_CONTENT
    , width MATCH_PARENT
    , disableClickFeedback true
    , background Color.transparent
    , accessibility DISABLE
    , visibility if state.props.currentStage == ConfirmingLocation then VISIBLE else GONE
    , padding $ PaddingTop 16
    , cornerRadii $ Corners 24.0 true true false false
    , gravity CENTER
    ]
    [ recenterButtonView push state
    , linearLayout
        [ width MATCH_PARENT
        , height WRAP_CONTENT
        , orientation VERTICAL
        , stroke $ "1," <> Color.grey900
        , cornerRadii $ Corners 24.0 true true false false
        , background tagConfig.backgroundColor
        ]
        [ linearLayout
            [ width MATCH_PARENT
            , height WRAP_CONTENT
            , orientation HORIZONTAL
            , gravity CENTER
            , padding (Padding zonePadding 4 zonePadding 4)
            , cornerRadii $ Corners 24.0 true true false false
            , visibility $ boolToVisibility tagVisibility
            , clickable $ isJust tagConfig.infoPopUpConfig
            , onClick push $ const $ SpecialZoneInfoTag
            ] [ imageView
                [ width (V 15)
                , height (V 15)
                , margin (MarginRight 6)
                , imageWithFallback $ fetchImage FF_COMMON_ASSET tagConfig.icon
                ]
              , textView
                [ width if os == "IOS" && confirmLocationCategory == AUTO_BLOCKED then (V 230) else WRAP_CONTENT
                , height WRAP_CONTENT
                , gravity CENTER
                , textSize FontSize.a_14
                , text tagConfig.text
                , color Color.white900
                ]
              , imageView
                [ width (V 18)
                , height (V 18)
                , visibility if isJust tagConfig.infoPopUpConfig then VISIBLE else GONE
                , margin (MarginLeft 6)
                , imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_white_info"
                ]
              ]
        , linearLayout
            [ width MATCH_PARENT
            , height WRAP_CONTENT
            , orientation VERTICAL
            , padding $ Padding 16 16 16 24
            , cornerRadii $ Corners 24.0 true true false false
            , background Color.white900
            , accessibility DISABLE
            ] [ textView $
                [ text (getString CONFIRM_PICKUP_LOCATION)
                , color Color.black800
                , accessibility DISABLE
                , gravity CENTER_HORIZONTAL
                , height WRAP_CONTENT
                , width MATCH_PARENT
                ] <> FontStyle.h1 TypoGraphy
              , currentLocationView push state
              , nearByPickUpPointsView state push
              , PrimaryButton.view (push <<< PrimaryButtonActionController) (primaryButtonConfirmPickupConfig state)
             ]
        ]
    ]

----------- loaderView -------------
loaderView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
loaderView push state =
  let loaderViewTitle = case state.props.currentStage of
                          ConfirmingRide -> getString CONFIRMING_THE_RIDE_FOR_YOU
                          FindingEstimate -> getString GETTING_ESTIMATES_FOR_YOU
                          TryAgain -> getString LET_TRY_THAT_AGAIN
                          ReAllocated -> getString LOOKING_FOR_ANOTHER_RIDE
                          _ -> getString GETTING_ESTIMATES_FOR_YOU
  in  linearLayout
      [ orientation VERTICAL
      , height WRAP_CONTENT
      , width MATCH_PARENT
      , padding (Padding 0 40 0 24)
      , background Color.white900
      , cornerRadii $ Corners 24.0 true true false false
      , stroke ("1," <> Color.grey900)
      , clickable true
      , gravity CENTER_HORIZONTAL
      , visibility if (any (_ == state.props.currentStage) [ FindingEstimate, ConfirmingRide, TryAgain, ReAllocated ]) then VISIBLE else GONE
      ]
      [ PrestoAnim.animationSet [ scaleAnim $ autoAnimConfig ]
          $ lottieLoaderView state push
      , PrestoAnim.animationSet [ fadeIn true ]
          $ textView $
              [ accessibilityHint $ DS.replaceAll (DS.Pattern ".") (DS.Replacement "") loaderViewTitle
              , text loaderViewTitle
              , accessibility ENABLE
              , color Color.black800
              , height WRAP_CONTENT
              , width MATCH_PARENT
              , lineHeight "20"
              , gravity CENTER
              , margin if state.props.currentStage == ReAllocated then (MarginVertical 24 0) else (MarginVertical 24 36)
              ] <> FontStyle.subHeading1 TypoGraphy
          , textView $
              [ text (getString THE_RIDE_HAD_BEEN_CANCELLED_WE_ARE_FINDING_YOU_ANOTHER)
              , color Color.black650
              , height WRAP_CONTENT
              , width MATCH_PARENT
              , lineHeight "20"
              , gravity CENTER
              , margin $ Margin 16 4 16 36
              , visibility if state.props.currentStage == ReAllocated then VISIBLE else GONE
              ] <> FontStyle.body2 TypoGraphy
      , PrestoAnim.animationSet [ translateYAnimFromTopWithAlpha $ translateFullYAnimWithDurationConfig 300 ]
          $ separator (V 1) Color.grey900 state.props.currentStage
      , linearLayout
          [ width MATCH_PARENT
          , height WRAP_CONTENT
          , visibility if (any (_ == state.props.currentStage) [ FindingEstimate, TryAgain]) then VISIBLE else GONE
          , orientation VERTICAL
          , gravity CENTER
          ]
          [ PrestoAnim.animationSet [ translateYAnimFromTopWithAlpha $ translateFullYAnimWithDurationConfig 300 ]
              $ linearLayout 
                  [ width WRAP_CONTENT
                  , height WRAP_CONTENT
                  , orientation HORIZONTAL
                  , gravity CENTER_VERTICAL
                  ][ imageView
                      [ imageWithFallback $ fetchImage FF_ASSET "ny_ic_wallet_filled"
                      , height $ V 20
                      , width $ V 20
                      , margin $ MarginTop 3
                      ]
                    , textView $
                      [ text (getString PAY_DRIVER_USING_CASH_OR_UPI)
                      , accessibilityHint "Pay Driver using Cash/UPI : Text"
                      , accessibility ENABLE
                      , lineHeight "18"
                      , width MATCH_PARENT
                      , height WRAP_CONTENT
                      , padding (Padding 5 20 0 16)
                      , color Color.black800
                      , gravity CENTER
                      ] <> FontStyle.body1 TypoGraphy
                  ]
          ]
      ]
------------------------------- pricingTutorialView --------------------------
pricingTutorialView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
pricingTutorialView push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , weight 1.0
    , padding (Padding 0 safeMarginTop 0 safeMarginBottom)
    , background Color.white900
    ]
    [ -- TODO Add Animations
      -- PrestoAnim.animationSet
      --   [ translateYAnim 900 0 (state.props.currentStage == PricingTutorial)
      --   , translateYAnim 0 900 (not (state.props.currentStage == PricingTutorial))
      --   ] $
      PricingTutorialModel.view (push <<< PricingTutorialModelActionController)
    ]

------------------------ searchLocationModelView ---------------------------
searchLocationModelView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
searchLocationModelView push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , background if state.props.isRideServiceable then Color.transparent else Color.white900
    ]
    [ SearchLocationModel.view (push <<< SearchLocationModelActionController) $ searchLocationModelViewState state]

------------------------ quoteListModelView ---------------------------
quoteListModelView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
quoteListModelView push state =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , accessibility if (state.props.isPopUp /= NoPopUp) then DISABLE_DESCENDANT else DISABLE
  ][
  QuoteListModel.view (push <<< QuoteListModelActionController) $ quoteListModelViewState state]


------------------------ emptyTextView ---------------------------
emptyTextView :: forall w. HomeScreenState ->  PrestoDOM (Effect Unit) w
emptyTextView state = textView [text "", width $ if os == "IOS" then V 1 else V 0]

emptyLayout :: forall w. HomeScreenState -> PrestoDOM (Effect Unit) w
emptyLayout state =
  textView
    [ width MATCH_PARENT
    , height $ V 30
    , background Color.transparent
    ]

------------------------ rideTrackingView ---------------------------
rideTrackingView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
rideTrackingView push state =
  let lowVisionDisability = maybe false (\dis -> if dis.tag == "BLIND_LOW_VISION" then true else false) state.data.disability
      topMargin = 60 + if os == "IOS" then safeMarginTop else 20
  in
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation VERTICAL
    , padding (Padding 0 0 0 0)
    , margin $ MarginTop topMargin
    , background Color.transparent
    , accessibility if (state.data.settingSideBar.opened /= SettingSideBar.CLOSED) || state.props.currentStage == ChatWithDriver || state.props.cancelSearchCallDriver || state.props.showCallPopUp || state.props.isCancelRide || state.props.isLocationTracking || state.props.callSupportPopUp || (state.props.showShareAppPopUp && state.data.config.feature.enableShareApp) || state.data.waitTimeInfo then DISABLE_DESCENDANT else DISABLE
    , alignParentBottom "true,-1" -- Check it in Android.
    , onBackPressed push (const $ BackPressed)
    ]
    [ -- TODO Add Animations
      -- PrestoAnim.animationSet
      --   [ translateInXAnim (-30) ( state.props.currentStage == RideAccepted || state.props.currentStage == RideStarted)
      --   , translateOutXAnim (-100) $ not ( state.props.currentStage == RideAccepted || state.props.currentStage == RideStarted)
      --   ] $
      linearLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , background Color.transparent
        , orientation VERTICAL
        -- , gravity BOTTOM -- Check it in Android.
        ]
        [ -- TODO Add Animations
          -- PrestoAnim.animationSet
          --   [ translateYAnim 900 0 ( state.props.currentStage == RideAccepted || state.props.currentStage == RideStarted)
          --   , translateYAnim 0 900 $ not ( state.props.currentStage == RideAccepted || state.props.currentStage == RideStarted)
          --   ] $
                   coordinatorLayout
                    [ height WRAP_CONTENT
                    , width MATCH_PARENT
                    ][ bottomSheetLayout
                        ([ height WRAP_CONTENT
                        , width MATCH_PARENT
                        , background Color.transparent 
                        , accessibility DISABLE
                        , enableShift false
                        , peakHeight $ getInfoCardPeekHeight state
                        , halfExpandedRatio $ halfExpanded
                        , orientation VERTICAL
                        ] <> (if lowVisionDisability || (os == "ANDROID") then 
                            [onStateChanged push $ ScrollStateChanged
                            , sheetState state.props.currentSheetState] 
                            else case state.props.sheetState of
                                    Nothing -> []
                                    Just state -> [sheetState state]))
                        [ linearLayout
                            [ height WRAP_CONTENT
                            , width MATCH_PARENT
                            ]
                            [ if (any (_ == state.props.currentStage) [RideAccepted, RideStarted, ChatWithDriver]) then
                                DriverInfoCard.view (push <<< DriverInfoCardActionController) $ driverInfoCardViewState state
                              else
                                emptyTextView state
                            ]
                        ]
              ]
        ]
    ]
  where 
    sheetHeight = toNumber (runFn1 getLayoutBounds $ getNewIDWithTag "BottomSheetLayout").height
    halfExpanded = (toNumber (getInfoCardPeekHeight state)) / if sheetHeight == 0.0 then 611.0 else sheetHeight

getMessageNotificationViewConfig :: HomeScreenState -> MessageNotificationView Action
getMessageNotificationViewConfig state =
  let primaryContact = head $ filter (\item -> (item.enableForShareRide || item.enableForFollowing) && (item.priority == 0)) (fromMaybe [] state.data.contactList)
  in {
    showChatNotification : state.props.showChatNotification
  , enableChatWidget : state.props.enableChatWidget
  , isNotificationExpanded :state.props.isNotificationExpanded
  , currentSearchResultType : state.data.currentSearchResultType
  , config : state.data.config
  , rideStarted : state.props.currentStage == RideStarted
  , lastMessage : state.data.lastMessage
  , lastSentMessage : state.data.lastSentMessage
  , lastReceivedMessage : state.data.lastReceivedMessage
  , removeNotificationAction : RemoveNotification
  , messageViewAnimationEnd : MessageViewAnimationEnd
  , messageReceiverAction : MessageDriver
  , sendQuickMessageAction : SendQuickMessage
  , timerCounter : state.data.triggerPatchCounter
  , messageExpiryAction : MessageExpiryTimer
  , chatSuggestions : getChatSuggestions state
  , messages : state.data.messages
  , removeNotification : state.props.removeNotification
  , currentStage : state.props.currentStage
  , suggestionKey : if state.props.isChatWithEMEnabled then emChatSuggestion else chatSuggestion
  , user :{ userName : if state.props.isChatWithEMEnabled 
                    then case primaryContact of
                            Nothing -> state.data.driverInfoCardState.driverName
                            Just contact -> contact.name
                    else state.data.driverInfoCardState.driverName
    , receiver : if state.props.isChatWithEMEnabled 
                    then case primaryContact of
                            Nothing -> "Driver"
                            Just contact -> contact.name
                    else "Driver"
    }
}

separatorView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM ( Effect Unit) w
separatorView push state = 
  linearLayout
  [ height WRAP_CONTENT
  , width  MATCH_PARENT
  , margin $ MarginVertical 8 8 
  ](map (\_ -> linearLayout
  [ height $ V 1
  , width $ V 8
  , margin $ MarginRight 4
  , background Color.manatee200
  ][]) (getArray 100))

dummyView :: forall w. HomeScreenState -> PrestoDOM ( Effect Unit) w
dummyView state = 
  linearLayout
  [height $ V 0
  , width $ V 0
  ][]

distanceOutsideLimitsView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
distanceOutsideLimitsView push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , gravity BOTTOM
    , accessibility if state.props.currentStage == DistanceOutsideLimits then DISABLE else DISABLE_DESCENDANT
    ]
    [ PopUpModal.view (push <<< DistanceOutsideLimitsActionController) (distanceOusideLimitsConfig state) ]

pickUpFarFromCurrLocView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
pickUpFarFromCurrLocView push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , gravity BOTTOM
    , accessibility if state.props.currentStage == PickUpFarFromCurrentLocation then DISABLE else DISABLE_DESCENDANT
    ]
    [ PopUpModal.view (push <<< PickUpFarFromCurrentLocAC) (pickUpFarFromCurrentLocationConfig state) ]

shortDistanceView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
shortDistanceView push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , gravity BOTTOM
    , accessibility if state.props.currentStage == ShortDistance then DISABLE else DISABLE_DESCENDANT
    ]
    [ PopUpModal.view (push <<< ShortDistanceActionController) (shortDistanceConfig state) ]

saveFavouriteCardView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
saveFavouriteCardView push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , accessibility if state.props.isSaveFavourite then DISABLE else DISABLE_DESCENDANT
    ]
    [ SaveFavouriteCard.view (push <<< SaveFavouriteCardAction) (state.data.saveFavouriteCard) ]

logOutPopUpView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
logOutPopUpView push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , accessibility DISABLE
    ]
    [ PopUpModal.view (push <<< PopUpModalAction) (logOutPopUpModelConfig state) ]

favouriteLocationModel :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
favouriteLocationModel push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , background Color.white900
    ]
    [ FavouriteLocationModel.view (push <<< FavouriteLocationModelAC) (state.data.savedLocations) ]

------------------------------- separator --------------------------
separator :: Length -> String -> Stage -> forall w. PrestoDOM (Effect Unit) w
separator lineHeight lineColor currentStage =
  linearLayout
    [ height $ lineHeight
    , width MATCH_PARENT
    , background lineColor
    , visibility if any (_ == currentStage) [FindingQuotes, ReAllocated] then GONE else VISIBLE
    ]
    []

waitTimeInfoPopUp :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
waitTimeInfoPopUp push state =
  PrestoAnim.animationSet [ fadeIn true ]
  $ linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , accessibility DISABLE
  ][ RequestInfoCard.view (push <<< RequestInfoCardAction) (waitTimeInfoCardConfig state) ]

lottieLoaderView :: forall w. HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
lottieLoaderView state push =
  lottieAnimationView
    [ id (getNewIDWithTag "lottieLoader")
    , afterRender
        ( \action -> do
            void $ pure $ startLottieProcess lottieAnimationConfig {speed = 1.5, rawJson = state.data.config.estimateAndQuoteConfig.genericLoaderLottie, lottieId = (getNewIDWithTag "lottieLoader") }
            pure unit
        )
        (const LottieLoaderAction)
    , height $ V state.data.config.searchLocationConfig.lottieHeight
    , width $ V state.data.config.searchLocationConfig.lottieWidth
    ]

getEstimate :: forall action. (GetQuotesRes -> action) -> action -> Int -> Number -> (action -> Effect Unit) -> HomeScreenState -> Flow GlobalState Unit
getEstimate action flowStatusAction count duration push state = do
  if (isLocalStageOn FindingEstimate) || (isLocalStageOn TryAgain) then
    if (count > 0) then do
      resp <- getQuotes (state.props.searchId)
      _ <- pure $ printLog "caseId" (state.props.searchId)
      case resp of
        Right response -> do
          _ <- pure $ printLog "api Results " response
          let (GetQuotesRes resp) = response
          if not (null resp.quotes) || not (null resp.estimates) then do
            doAff do liftEffect $ push $ action response
            pure unit
          else do
            if (count == 1) then do
              _ <- pure $ updateLocalStage SearchLocationModel
              doAff do liftEffect $ push $ action response
            else do
              void $ delay $ Milliseconds duration
              getEstimate action flowStatusAction (count - 1) duration push state
        Left err -> do
          let errResp = err.response
              codeMessage = decodeError errResp.errorMessage "errorMessage"
          if ( err.code == 400 && codeMessage == "ACTIVE_BOOKING_ALREADY_PRESENT" ) then do
            -- _ <- pure $ logEvent state.data.logField "ny_fs_active_booking_found_on_search"
            void $ pure $ toast "ACTIVE BOOKING ALREADY PRESENT"
            doAff do liftEffect $ push $ flowStatusAction
          else do
            void $ delay $ Milliseconds duration
            if (count == 1) then do
              let response = GetQuotesRes { quotes: [], estimates: [], fromLocation: SearchReqLocationAPIEntity { lat: 0.0, lon: 0.0 }, toLocation: Nothing }
              _ <- pure $ updateLocalStage SearchLocationModel
              doAff do liftEffect $ push $ action response
            else do
              getEstimate action flowStatusAction (count - 1) duration push state
    else
      pure unit
  else
    pure unit

getQuotesPolling :: forall action. String -> (SelectListRes -> action) -> (ErrorResponse -> action) -> Int -> Number -> (action -> Effect Unit) -> HomeScreenState -> Flow GlobalState Unit
getQuotesPolling pollingId action retryAction count duration push state = do
  when (pollingId == (getValueToLocalStore TRACKING_ID) && (isLocalStageOn FindingQuotes)) $ do
    internetCondition <- liftFlow $ isInternetAvailable unit
    when internetCondition $ do
      let gotQuote = (getValueToLocalStore GOT_ONE_QUOTE)
      let minimumPollingCount = fromMaybe 0 (fromString (getValueToLocalStore TEST_MINIMUM_POLLING_COUNT))
      let usableCount = if gotQuote == "TRUE" && count > minimumPollingCount then minimumPollingCount else count
      if (spy "USABLECOUNT :- " usableCount > 0) then do
        resp <- selectList (state.props.estimateId)
        _ <- pure $ printLog "caseId" (state.props.estimateId)
        case resp of
          Right response -> do
            _ <- pure $ printLog "Quote api Results " response
            let (SelectListRes resp) = response
            if (resp.bookingId /= Nothing && resp.bookingId /= Just "") || (not (null ((fromMaybe dummySelectedQuotes resp.selectedQuotes)^._selectedQuotes))) then do
               doAff do liftEffect $ push $ action response
            else
              pure unit
            void $ delay $ Milliseconds duration
            getQuotesPolling pollingId action retryAction (usableCount - 1) duration push state
          Left err -> do
            _ <- pure $ printLog "api error " err
            doAff do liftEffect $ push $ retryAction err
            void $ delay $ Milliseconds duration
            pure unit
            getQuotesPolling pollingId action retryAction (usableCount - 1) duration push state
      else do
        let response = SelectListRes { selectedQuotes: Nothing, bookingId : Nothing }
        _ <- pure $ updateLocalStage QuoteList
        doAff do liftEffect $ push $ action response

updateRecentTrips :: forall action. (RideBookingListRes -> action) -> (action -> Effect Unit) -> Maybe RideBookingListRes -> Flow GlobalState Unit
updateRecentTrips action push response = do
  case response of 
    Just resp -> handleResponse resp
    Nothing -> fetchAndHandleResponse
  where
    handleResponse resp = do
      screenActive <- liftFlow $ isScreenActive "default" "HomeScreen"
      if screenActive 
        then liftFlow $ push $ action resp
        else retryAfterDelay resp

    retryAfterDelay resp = do
      void $ delay $ Milliseconds 1000.0
      updateRecentTrips action push (Just resp)

    fetchAndHandleResponse = do
      rideBookingListResponse <- Remote.rideBookingListWithStatus "30" "0" "COMPLETED"
      void $ pure $ setValueToLocalStore UPDATE_REPEAT_TRIPS "false"
      case rideBookingListResponse of
        Right listResp -> do
          handleResponse listResp
        Left _ -> liftFlow $ push $ action (RideBookingListRes {list : []} )

driverLocationTracking :: (Action -> Effect Unit) -> (String -> Action) -> (String -> Action) -> (Int -> Int -> Action) -> Number -> String -> HomeScreenState -> String -> Int -> Flow GlobalState Unit
driverLocationTracking push action driverArrivedAction updateState duration trackingId state routeState expCounter = do
  _ <- pure $ printLog "trackDriverLocation2_function" trackingId
  (GlobalState gbState) <- getState
  if (any (\stage -> isLocalStageOn stage) [ RideAccepted, RideStarted, ChatWithDriver]) && ((getValueToLocalStore TRACKING_ID) == trackingId) then do
    let bookingId = if state.props.bookingId == "" then gbState.homeScreen.props.bookingId else state.props.bookingId
    if bookingId /= ""
      then do
        respBooking <- rideBooking bookingId 
        case respBooking of
          Right respBooking -> do
            handleRideBookingResp respBooking
          Left _ -> pure unit
      else do
        mbResp <- getActiveBooking
        case mbResp of
          Nothing -> pure unit
          Just resp -> do
            void $ liftFlow $ push $ UpdateBookingDetails resp
            handleRideBookingResp resp
    if (state.props.isSpecialZone && state.data.currentSearchResultType == QUOTES) && (isLocalStageOn RideAccepted) then do
      _ <- pure $ enableMyLocation true
      _ <- pure $ removeAllPolylines ""
      _ <- doAff $ liftEffect $ animateCamera state.data.driverInfoCardState.sourceLat state.data.driverInfoCardState.sourceLng zoomLevel "ZOOM"
      _ <- doAff $ liftEffect $ addMarker "ny_ic_src_marker" state.data.driverInfoCardState.sourceLat state.data.driverInfoCardState.sourceLng 110 0.5 0.9
      void $ delay $ Milliseconds duration
      driverLocationTracking push action driverArrivedAction updateState duration trackingId state routeState expCounter
      else do
        (GlobalState gbState) <- getState
        let rideId = if state.data.driverInfoCardState.rideId == "" then gbState.homeScreen.data.driverInfoCardState.rideId else state.data.driverInfoCardState.rideId
        response <- getDriverLocation rideId
        case response of
          Right (GetDriverLocationResp resp) -> do
            let
              srcLat = (resp ^. _lat)
              srcLon = (resp ^. _lon)
              dstLat = if (any (_ == state.props.currentStage) [ RideAccepted, ChatWithDriver]) then state.data.driverInfoCardState.sourceLat else state.data.driverInfoCardState.destinationLat
              dstLon = if (any (_ == state.props.currentStage) [ RideAccepted, ChatWithDriver]) then state.data.driverInfoCardState.sourceLng else state.data.driverInfoCardState.destinationLng
              trackingType = if (any (_ == state.props.currentStage) [ RideAccepted, ChatWithDriver]) then Remote.DRIVER_TRACKING else Remote.RIDE_TRACKING
              markers = getRouteMarkers state.data.driverInfoCardState.vehicleVariant state.props.city trackingType 
              sourceSpecialTagIcon = zoneLabelIcon state.props.zoneType.sourceTag
              destSpecialTagIcon = zoneLabelIcon state.props.zoneType.destinationTag
              specialLocationTag =  if (any (_ == state.props.currentStage) [ RideAccepted, ChatWithDriver]) then
                                      specialLocationConfig destSpecialTagIcon sourceSpecialTagIcon true getPolylineAnimationConfig
                                    else
                                      specialLocationConfig sourceSpecialTagIcon destSpecialTagIcon false getPolylineAnimationConfig
            -- TODO :: may use in future
            -- if isSpecialPickupZone then do
            --   let srcMarkerConfig = defaultMarkerConfig{ pointerIcon = markers.srcMarker }
            --       destMarkerConfig = defaultMarkerConfig{ pointerIcon = markers.destMarker, primaryText = getMarkerPrimaryText 0 }
            --   _ <- pure $ removeAllPolylines ""
            --   _ <- liftFlow $ runEffectFn9 drawRoute (walkCoordinate srcLat srcLon dstLat dstLon) "DOT" "#323643" false srcMarkerConfig destMarkerConfig 8 "DRIVER_LOCATION_UPDATE" specialLocationTag
            --   void $ delay $ Milliseconds duration
            --   driverLocationTracking push action driverArrivedAction updateState duration trackingId state routeState expCounter
            if ((getValueToLocalStore TRACKING_ID) == trackingId) then do
              if (getValueToLocalStore TRACKING_ENABLED) == "False" then do
                let srcMarkerConfig = defaultMarkerConfig{ pointerIcon = markers.srcMarker }
                    destMarkerConfig = defaultMarkerConfig{ pointerIcon = markers.destMarker }
                _ <- pure $ setValueToLocalStore TRACKING_DRIVER "True"
                _ <- pure $ removeAllPolylines ""
                _ <- liftFlow $ runEffectFn9 drawRoute (walkCoordinate srcLat srcLon dstLat dstLon) "DOT" "#323643" false srcMarkerConfig destMarkerConfig 8 "DRIVER_LOCATION_UPDATE" specialLocationTag
                void $ delay $ Milliseconds duration
                driverLocationTracking push action driverArrivedAction updateState duration trackingId state routeState expCounter
              else if ((getValueToLocalStore TRACKING_DRIVER) == "False" || not (isJust state.data.route)) then do
                _ <- pure $ setValueToLocalStore TRACKING_DRIVER "True"
                routeResponse <- getRoute routeState $ makeGetRouteReq srcLat srcLon dstLat dstLon
                case routeResponse of
                  Right (GetRouteResp routeResp) -> do
                    case ((routeResp) !! 0) of
                      Just (Route routes) -> do
                        _ <- pure $ removeAllPolylines ""
                        let (Snapped routePoints) = routes.points
                            newPoints = if length routePoints > 1 then
                                          getExtendedPath (walkCoordinates routes.points)
                                        else
                                          walkCoordinate srcLat srcLon dstLat dstLon
                            newRoute = routes { points = Snapped (map (\item -> LatLong { lat: item.lat, lon: item.lng }) newPoints.points) }
                            srcMarkerConfig = defaultMarkerConfig{ pointerIcon = markers.srcMarker }
                            destMarkerConfig = defaultMarkerConfig{ pointerIcon = markers.destMarker, primaryText = getMarkerPrimaryText routes.distance }
                        void $ liftFlow $ runEffectFn9 drawRoute newPoints "LineString" "#323643" true srcMarkerConfig destMarkerConfig 8 "DRIVER_LOCATION_UPDATE" specialLocationTag
                        _ <- doAff do liftEffect $ push $ updateState routes.duration routes.distance
                        void $ delay $ Milliseconds duration
                        driverLocationTracking push action driverArrivedAction updateState duration trackingId state { data { route = Just (Route newRoute), speed = routes.distance / routes.duration } } routeState expCounter
                      Nothing -> do
                        void $ delay $ Milliseconds $ getDuration state.data.config.driverLocationPolling.retryExpFactor expCounter
                        driverLocationTracking push action driverArrivedAction updateState duration trackingId state { data { route = Nothing } } routeState (expCounter + 1)
                  Left _ -> do
                    void $ delay $ Milliseconds $ getDuration state.data.config.driverLocationPolling.retryExpFactor expCounter
                    driverLocationTracking push action driverArrivedAction updateState duration trackingId state { data { route = Nothing } } routeState (expCounter + 1)
              else do
                case state.data.route of
                  Just (Route route) -> do
                        locationResp <- liftFlow $ isCoordOnPath (walkCoordinates route.points) (resp ^. _lat) (resp ^. _lon) (state.data.speed)
                        if locationResp.isInPath then do
                          let newPoints = { points : locationResp.points}
                          let specialLocationTag =  if (any (\stage -> isLocalStageOn stage) [ RideAccepted, ChatWithDriver]) then
                                                      specialLocationConfig "" sourceSpecialTagIcon true getPolylineAnimationConfig
                                                    else
                                                      specialLocationConfig "" destSpecialTagIcon false getPolylineAnimationConfig
                          liftFlow $ runEffectFn1 updateRoute updateRouteConfig { json = newPoints, destMarker =  markers.destMarker, eta = getMarkerPrimaryText locationResp.distance, srcMarker = markers.srcMarker, specialLocation = specialLocationTag, zoomLevel = zoomLevel}
                          _ <- doAff do liftEffect $ push $ updateState locationResp.eta locationResp.distance
                          void $ delay $ Milliseconds duration
                          driverLocationTracking push action driverArrivedAction updateState duration trackingId state routeState expCounter
                        else do
                          driverLocationTracking push action driverArrivedAction updateState duration trackingId state { data { route = Nothing } } routeState expCounter
                  Nothing -> driverLocationTracking push action driverArrivedAction updateState duration trackingId state { data { route = Nothing } } routeState expCounter
            else pure unit
          Left _ -> do
            void $ delay $ Milliseconds $ getDuration state.data.config.driverLocationPolling.retryExpFactor expCounter
            driverLocationTracking push action driverArrivedAction updateState duration trackingId state { data { route = Nothing } } routeState (expCounter + 1)
  else do
    pure unit
  where
    getDuration factor counter = duration * (toNumber $ pow factor counter)
    isSpecialPickupZone = state.props.currentStage == RideAccepted && state.props.zoneType.priorityTag == SPECIAL_PICKUP && isJust state.data.driverInfoCardState.sourceAddress.area && state.data.config.feature.enableSpecialPickup
    handleRideBookingResp (RideBookingRes respBooking) = do
      let bookingStatus = respBooking.status
      void $ modifyState \(GlobalState globalState) -> GlobalState $ globalState { homeScreen {props{bookingId = respBooking.id}, data{driverInfoCardState = getDriverInfo state.data.specialZoneSelectedVariant (RideBookingRes respBooking) (state.data.currentSearchResultType == QUOTES)}}}
      case bookingStatus of
        "REALLOCATED" -> do
            doAff do liftEffect $ push $ action bookingStatus
        _             -> do
            case (respBooking.rideList !! 0) of
              Just (RideAPIEntity res) -> do
                let rideStatus = res.status
                doAff do liftEffect $ push $ action rideStatus
                if (res.driverArrivalTime /= Nothing  && (getValueToLocalStore DRIVER_ARRIVAL_ACTION) == "TRIGGER_DRIVER_ARRIVAL" ) then 
                  doAff do liftEffect $ push $ driverArrivedAction (fromMaybe "" res.driverArrivalTime)
                else pure unit
              Nothing -> pure unit
    
    getMarkerPrimaryText distance =
      if isSpecialPickupZone then
        fromMaybe "" state.data.driverInfoCardState.sourceAddress.area
      else 
        metersToKm distance (state.props.currentStage == RideStarted)


confirmRide :: forall action. (RideBookingRes -> action) -> Int -> Number -> (action -> Effect Unit) -> HomeScreenState -> Flow GlobalState Unit
confirmRide action count duration push state = do
  if (count /= 0) && (isLocalStageOn ConfirmingRide) && (state.props.bookingId /= "")then do
    resp <- rideBooking (state.props.bookingId)
    _ <- pure $ printLog "response to confirm ride:- " (state.props.searchId)
    case resp of
      Right response -> do
        _ <- pure $ printLog "api Results " response
        let (RideBookingRes resp) = response
            fareProductType = (resp.bookingDetails) ^. _fareProductType
            status = if fareProductType == "OneWaySpecialZoneAPIDetails" then "CONFIRMED" else "TRIP_ASSIGNED"
            willRideListNull = if fareProductType == "OneWaySpecialZoneAPIDetails" then true else false
        if  status == resp.status && (willRideListNull || not (null resp.rideList)) then do
            doAff do liftEffect $ push $ action response
            -- _ <- pure $ logEvent state.data.logField "ny_user_ride_assigned"
            pure unit
        else do
            void $ delay $ Milliseconds duration
            confirmRide action (count - 1) duration push state
      Left err -> do
        _ <- pure $ printLog "api error " err
        void $ delay $ Milliseconds duration
        confirmRide action (count - 1) duration push state
  else
    pure unit

cancelRidePopUpView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
cancelRidePopUpView push state =
  linearLayout
    [ height MATCH_PARENT
    , width MATCH_PARENT
    , accessibility DISABLE
    ][ CancelRidePopUp.view (push <<< CancelRidePopUpAction) (cancelRidePopUpConfig state)]

checkForLatLongInSavedLocations :: forall action. (action -> Effect Unit) -> (Array LocationListItemState -> action) -> HomeScreenState -> FlowBT String Unit
checkForLatLongInSavedLocations push action state = do
  void $ setValueToLocalStore RELOAD_SAVED_LOCATION "false"
  void $ transformSavedLocations state.data.savedLocations
  if getValueToLocalStore RELOAD_SAVED_LOCATION == "true" then do 
    (SavedLocationsListRes savedLocationResp )<- FlowCache.updateAndFetchSavedLocations false
    liftFlowBT $ push $ action $ AddNewAddress.getSavedLocations savedLocationResp.list
  else pure unit
  void $ setValueToLocalStore RELOAD_SAVED_LOCATION "false"

notinPickUpZoneView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
notinPickUpZoneView push state =
  linearLayout
      [ width MATCH_PARENT
      , height WRAP_CONTENT
      , orientation VERTICAL
      , stroke $ "1," <> Color.grey900
      , gravity CENTER
      , cornerRadius 8.0
      , margin $ MarginTop 16
      , padding $ PaddingVertical 2 10
      ][linearLayout
        [ height WRAP_CONTENT
        , width WRAP_CONTENT
        , orientation HORIZONTAL
        , margin (MarginLeft 15)]
        [ linearLayout
        [ height WRAP_CONTENT
        , width WRAP_CONTENT
        , orientation VERTICAL
        , gravity CENTER
        , margin $ MarginTop if os == "IOS" then 10 else 0
        ][  textView $
            [ text $ if state.data.rateCard.additionalFare == 0 then (getCurrency appConfig) <> (show state.data.suggestedAmount) else  (getCurrency appConfig) <> (show state.data.suggestedAmount) <> "-" <> (getCurrency appConfig) <> (show $ (state.data.suggestedAmount + state.data.rateCard.additionalFare))
            , color Color.black800
            , margin $ MarginTop 8
            , gravity CENTER_HORIZONTAL
            , width WRAP_CONTENT
            , height WRAP_CONTENT
            , onClick push $ const ShowRateCard
            ] <> FontStyle.priceFont LanguageStyle
            , estimatedTimeAndDistanceView push state
          ]
          , imageView
            [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_info_blue"
            , width $ V 40
            , height $ V 40
            , gravity BOTTOM
            , margin (MarginTop 13)
            , onClick push $ const ShowRateCard
            ]
        ]
        , linearLayout
          [ width MATCH_PARENT
          , height WRAP_CONTENT
          , orientation VERTICAL
          ]
          [ linearLayout
              [ width MATCH_PARENT
              , height $ V 1
              , margin $ Margin 16 12 16 14
              , background Color.grey900
              ][]
          , linearLayout
              [ width MATCH_PARENT
              , height WRAP_CONTENT
              , orientation VERTICAL
              ]
              [ linearLayout
                  [ width MATCH_PARENT
                  , height WRAP_CONTENT
                  , gravity CENTER_HORIZONTAL
                  , onClick push $ const PreferencesDropDown
                  , margin $ MarginBottom 8
                  ][ textView $
                      [ height $ V 24
                      , width WRAP_CONTENT
                      , color Color.darkCharcoal
                      , text $ getString BOOKING_PREFERENCE
                      ] <> FontStyle.body5 TypoGraphy,
                      imageView
                      [ width $ V 10
                      , height $ V 10
                      , margin (Margin 9 8 0 0)
                      , imageWithFallback if state.data.showPreferences then fetchImage FF_COMMON_ASSET "ny_ic_chevron_up" else fetchImage FF_ASSET "ny_ic_chevron_down"
                      ]
                  ],
                  linearLayout
                    [ width MATCH_PARENT
                    , height WRAP_CONTENT
                    , margin $ MarginLeft 20
                    , orientation VERTICAL
                    ][ linearLayout
                       [ width MATCH_PARENT
                       , height WRAP_CONTENT
                       , orientation VERTICAL
                       , visibility if state.data.showPreferences then VISIBLE else GONE
                       ][showMenuButtonView push (getString AUTO_ASSIGN_DRIVER) ( fetchImage FF_ASSET "ny_ic_faster") true state,
                         showMenuButtonView push (getString CHOOSE_BETWEEN_MULTIPLE_DRIVERS) ( fetchImage FF_ASSET "ny_ic_info") false state ]
                  ]

              ]
          ]
      ]

zoneTimerExpiredView :: forall w. HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
zoneTimerExpiredView state push =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , gravity CENTER
  ][ PopUpModal.view (push <<< ZoneTimerExpired) (zoneTimerExpiredConfig state)]

editButtontView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
editButtontView push state =
  linearLayout
  [ height WRAP_CONTENT
  , width WRAP_CONTENT
  , gravity CENTER_VERTICAL
  , stroke $ "1," <> state.data.config.confirmPickUpLocationBorder
  , cornerRadius if (os == "IOS") then 15.0 else 20.0
  , padding (Padding 10 6 10 6)
  , margin $ MarginLeft 10 
  ][ textView 
      $
      [ text (getString EDIT)
      , color Color.black800
      , gravity CENTER_VERTICAL
      ]  
      <> FontStyle.body1 TypoGraphy
  ]

currentLocationView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w 
currentLocationView push state =
  let showCurrentLocationView = DS.null state.props.defaultPickUpPoint
  in linearLayout
            [ width MATCH_PARENT
            , height WRAP_CONTENT
            , orientation HORIZONTAL
            , margin $ MarginVertical 20 10
            , onClick push $ const GoBackToSearchLocationModal
            , padding $ PaddingHorizontal 15 15
            , stroke $ "1," <> state.data.config.confirmPickUpLocationBorder
            , gravity CENTER_VERTICAL
            , accessibility DISABLE
            , cornerRadius 5.0
            , visibility $ boolToVisibility showCurrentLocationView
            ]
            [ imageView
                [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_source_dot"
                , height $ V 16
                , width $ V 16
                , gravity CENTER_VERTICAL
                , accessibility DISABLE
                ]
            , textView
                $
                  [ text state.data.source
                  , ellipsize true
                  , maxLines 2
                  , accessibility ENABLE
                  , accessibilityHint $ "Pickup Location is " <>  (DS.replaceAll (DS.Pattern ",") (DS.Replacement " ") state.data.source)
                  , gravity LEFT
                  , weight 1.0
                  , padding (Padding 10 16 10 16)
                  , color Color.black800
                  ]
                <> FontStyle.subHeading1 TypoGraphy
              , editButtontView push state
            ]

nearByPickUpPointsView :: forall w . HomeScreenState -> (Action -> Effect Unit) -> PrestoDOM (Effect Unit) w
nearByPickUpPointsView state push =
  scrollView
  [ height $ V $ getPickUpViewHeight state.data.nearByPickUpPoints
  , width MATCH_PARENT
  , orientation VERTICAL
  , padding $ Padding 5 20 0 5
  , visibility $ boolToVisibility (not (DS.null state.props.defaultPickUpPoint))
  , id $ getNewIDWithTag "scrollViewParent"
  ][linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation VERTICAL
    , id $ getNewIDWithTag "scrollViewChild"
    , afterRender push (const AfterRender)
    ](mapWithIndex (\index item ->
                    linearLayout
                    [ height WRAP_CONTENT
                    , width MATCH_PARENT
                    , margin $ MarginBottom 12
                      ][MenuButton.view (push <<< MenuButtonActionController) (menuButtonConfig state item)]) state.data.nearByPickUpPoints)
  ]
  where 
    getPickUpViewHeight nearByPickUpPoints =
      let 
        menuBtnHeight = 56 -- Update Menu Button Height
        padding = 28
        len = if (length nearByPickUpPoints > 3) then 3 else length nearByPickUpPoints
        removeExtraPadding = if len > 1 then padding else 0
        pickUpPointViewHeight = len * menuBtnHeight + len * padding - removeExtraPadding
        finalHeight = if os == "IOS" 
                            then pickUpPointViewHeight - len * 10
                            else pickUpPointViewHeight
      in
      finalHeight

confirmingLottieView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
confirmingLottieView push state =
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , cornerRadii $ Corners 24.0 true true false false
    , alignParentBottom "true,-1"
    ][ relativeLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , cornerRadii $ Corners 24.0 true true false false
        , background Color.transparent
        ][ PrestoAnim.animationSet [ fadeIn true ] $
          loaderView push state
          ]
    ]

isAnyOverlayEnabled :: HomeScreenState -> Boolean
isAnyOverlayEnabled state = state.data.settingSideBar.opened /= SettingSideBar.CLOSED || state.props.cancelSearchCallDriver || state.props.isCancelRide || state.props.isLocationTracking || state.props.callSupportPopUp || state.props.showCallPopUp || state.props.showRateCard || (state.props.showShareAppPopUp && state.data.config.feature.enableShareApp || state.data.waitTimeInfo)

carouselView:: HomeScreenState -> (Action -> Effect Unit)  -> forall w . PrestoDOM (Effect Unit) w
carouselView state push = 
  PrestoAnim.animationSet [ fadeIn true ] $ 
  linearLayout
  [ height WRAP_CONTENT
  , width MATCH_PARENT
  , padding $ Padding 16 16 16 16
  , background Color.white900
  , cornerRadius 16.0
  , gravity CENTER
  , visibility if state.props.showEducationalCarousel then VISIBLE else GONE
  , orientation VERTICAL
  , margin $ MarginHorizontal 16 16
  ][  textView $ 
      [ text $ getString INCLUSIVE_AND_ACCESSIBLE
      , margin $ MarginBottom 20
      , color Color.black800
      ] <> FontStyle.body7 TypoGraphy
    , linearLayout
      [ height WRAP_CONTENT
      , width MATCH_PARENT
      , stroke $ "1," <> Color.grey900
      , background Color.grey700
      , margin $ MarginBottom 16
      , orientation VERTICAL
      , cornerRadius 8.0
      ][  PrestoAnim.animationSet [ fadeIn true ] $  linearLayout
          [ height $ V 340
          , width MATCH_PARENT
          , orientation VERTICAL
          , id $ getNewIDWithTag "AccessibilityCarouselView"
          , accessibility DISABLE
          , gravity CENTER    
          , onAnimationEnd (\action -> do
              when (addCarouselWithVideoExists unit) $ addCarousel { gravity : "TOP", carouselData : getCarouselData state } (getNewIDWithTag "AccessibilityCarouselView")
              push action
            ) (const AfterRender)
          ][]
        ]
    , PrimaryButton.view (push <<< UpdateProfileButtonAC) (updateProfileConfig state)
    , PrimaryButton.view (push <<< SkipAccessibilityUpdateAC) (maybeLaterButtonConfig state)]

getInfoCardPeekHeight :: HomeScreenState -> Int
getInfoCardPeekHeight state = if state.data.infoCardPeekHeight == 0 then (getDefaultPeekHeight state) else state.data.infoCardPeekHeight


homeScreenView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
homeScreenView push state =
  PrestoAnim.animationSet
    [ fadeOut (state.props.currentStage == SearchLocationModel)
    ]
    $ linearLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , padding $ PaddingVertical safeMarginTop safeMarginBottom
        , accessibility if state.data.settingSideBar.opened /= SettingSideBar.CLOSED then DISABLE_DESCENDANT else DISABLE
        , orientation VERTICAL
        ]
        [ if not state.props.rideRequestFlow then homeScreenTopIconView push state else emptyTextView state ]

----------------------------------------- UPDATED HOME SCREEN -------------------------------------------

homeScreenViewV2 :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
homeScreenViewV2 push state = 
  relativeLayout
    [ height $ V (screenHeight unit)
    , width $ V (screenWidth unit)
    ][ linearLayout
        [ height $ V ((screenHeight unit)/ 3)
        , width MATCH_PARENT
        , background state.data.config.homeScreen.primaryBackground 
        , padding $ (PaddingTop (safeMarginTop))
        ][] 
      , linearLayout 
          [ width MATCH_PARENT
          , height MATCH_PARENT
          , orientation VERTICAL
          ][  homescreenHeader push state 
            , linearLayout
              [ height MATCH_PARENT
              , width WRAP_CONTENT
              , background Color.white900
              , stroke if state.data.config.homeScreen.header.showSeparator then "1," <> Color.borderGreyColor else "0," <> Color.borderGreyColor
              , gradient if os == "IOS" then (Linear 270.0 [Color.white900 , Color.white900, Color.grey700]) else (Linear 180.0 [Color.white900 , Color.white900,  Color.grey700])
              ][ scrollView
                  [ height $ if os == "IOS" then (V (getHeightFromPercent 90)) else MATCH_PARENT
                  , width MATCH_PARENT
                  , padding $ PaddingBottom 70
                  , nestedScrollView true
                  , scrollBarY false
                  ][ linearLayout
                      [ width $ V (screenWidth unit)
                      , height WRAP_CONTENT
                      , orientation VERTICAL
                      ] $ [savedLocationsView state push] <> 
                        (if not state.props.isSrcServiceable && state.props.currentStage == HomeScreen then
                          [locationUnserviceableView push state]
                        else 
                          []
                          <> contentView state
                          <> [ shimmerView state
                          , if state.data.config.feature.enableAdditionalServices then additionalServicesView push state else linearLayout[visibility GONE][]
                          , suggestionsView push state
                          , emptySuggestionsBanner state push
                          , footerView push state
                          ])
                  ]
              ]
          ]
        ]  
  where 
    contentView state = if state.props.showShimmer then [
      PrestoAnim.animationSet [ fadeInWithDelay 250 true ] $
        shimmerFrameLayout
        [ height $ V 100
        , width MATCH_PARENT 
        , background Color.greyDark
        , margin $ Margin 16 24 16 0
        , cornerRadius 8.0
        , onAnimationEnd
            ( \action -> do
                _ <- push action
                _ <- getCurrentPosition push CurrentLocation
                case state.props.currentStage of
                  HomeScreen -> if ((getSearchType unit) == "direct_search") then push DirectSearch else pure unit
                  _ -> pure unit
                pure unit
            )(const MapReadyAction)
        ][]] 
      else
      (maybe 
        (if isHomeScreenView state && state.props.isBannerDataComputed 
          then [mapView push state "CustomerHomeScreenMap"] 
          else [emptyTextView state]
        ) 
        (\item -> [bannersCarousal item state push]) 
        state.data.bannerData.bannerItem)

showMapOnHomeScreen :: HomeScreenState -> Boolean
showMapOnHomeScreen state = isHomeScreenView state && isNothing state.data.bannerData.bannerItem

isHomeScreenView :: HomeScreenState -> Boolean
isHomeScreenView state = state.props.currentStage == HomeScreen

footerView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
footerView push state = 
  linearLayout  
    [ width MATCH_PARENT
    , height WRAP_CONTENT
    , orientation VERTICAL
    , padding $ Padding 24 5 24 30
    , gravity CENTER
    , accessibilityHint $  getString BOOK_AND_MOVE <>  getString ANYWHERE_IN_THE_CITY
    ][
       textView $ 
        [ text $ getString BOOK_AND_MOVE
        , color Color.black700
        , gravity CENTER
        ]  <> FontStyle.h1 TypoGraphy
      , textView $ 
        [ text $ getString ANYWHERE_IN_THE_CITY
        , gravity CENTER
        , color Color.black700
        ] <> FontStyle.h1 TypoGraphy

      , linearLayout
        [ height $ V 2
        , width MATCH_PARENT
        , background Color.grey800
        , margin $ MarginVertical 24 24
        ][]
      , linearLayout  
          [ width WRAP_CONTENT
          , height WRAP_CONTENT
          , orientation HORIZONTAL
          , gravity CENTER_VERTICAL
          , padding $ Padding 16 15 16 15
          , stroke $ "1," <> Color.grey900
          , cornerRadii $ Corners 6.0 true true true true
          , onClick push $ const OpenLiveDashboard
          , visibility if state.data.config.dashboard.enable then VISIBLE else GONE
          ][
            imageView
              [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_live_stats"
              , height $ V 20
              , width $ V 20
              , margin $ MarginRight 7
              ]
            , textView
                [ height WRAP_CONTENT
                , width WRAP_CONTENT
                , text $ getString CHECKOUT_OUR_LIVE_STATS 
                , color Color.blue900
                , textSize FontSize.a_16
                , gravity CENTER_VERTICAL
                ]
          ]
      , textView $
        [ text $ getString $ MOST_LOVED_APP "MOST_LOVED_APP"
        , gravity CENTER
        , color Color.black600
        , margin $ MarginTop 16
        ] <> FontStyle.body1 TypoGraphy
    ]

homescreenHeader :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
homescreenHeader push state = 
  linearLayout 
    [height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation VERTICAL
    , padding $ PaddingTop safeMarginTop
    , id $ getNewIDWithTag "homescreenHeader"
    , afterRender push $ const UpdatePeekHeight
    ][ pickupLocationView push state]


pickupLocationView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
pickupLocationView push state = 
  linearLayout
      [ height WRAP_CONTENT
      , width MATCH_PARENT
      , orientation VERTICAL
      ][
        linearLayout
          [ height WRAP_CONTENT
          , width MATCH_PARENT
          , orientation HORIZONTAL
          , margin $ MarginBottom 8
          , padding (Padding 16 20 16 0)
          , gravity CENTER
          ][
            linearLayout
              [ width WRAP_CONTENT 
              , height WRAP_CONTENT
              , gravity CENTER_VERTICAL
              , disableClickFeedback true
              , clickable $ not (state.props.currentStage == SearchLocationModel)
              , visibility if not state.data.config.terminateBtnConfig.visibility then GONE
                           else VISIBLE
              , onClick push (const TerminateApp)
              , margin $ MarginRight 8
              , padding $ Padding 8 8 8 8 
              , background $ state.data.config.terminateBtnConfig.backgroundColor
              , cornerRadius 8.0
              ]
              [ imageView
                  [ imageWithFallback state.data.config.terminateBtnConfig.imageUrl
                  , height $ V 23
                  , width $ V 23
                  , visibility $ boolToVisibility state.data.config.terminateBtnConfig.visibility
                  ]
              ]
          , linearLayout
              [ width WRAP_CONTENT 
              , height WRAP_CONTENT
              , gravity CENTER_VERTICAL
              , disableClickFeedback true
              , clickable $ not (state.props.currentStage == SearchLocationModel)
              , onClick push $ const OpenSettings
              , padding $ Padding 8 8 8 8 
              , background $ state.data.config.homeScreen.header.menuButtonBackground
              , cornerRadius 20.0
              , rippleColor Color.rippleShade
              ]
              [ imageView
                  [ imageWithFallback $ fetchImage FF_ASSET "ny_ic_menu"
                  , height $ V 23
                  , width $ V 23
                  , accessibility if state.props.currentStage == ChatWithDriver || state.props.isCancelRide || state.props.isLocationTracking || state.props.callSupportPopUp || state.props.cancelSearchCallDriver then DISABLE else ENABLE
                  , accessibilityHint "Navigation : Button"
                  ]
              ] 
          
            , linearLayout
                [ height WRAP_CONTENT
                , weight 1.0
                , gravity CENTER_VERTICAL
                , layoutGravity "center_vertical"
                ][ imageView
                    [ imageWithFallback $ fetchImage FF_ASSET "ny_ic_logo_light"
                    , height $ V 50
                    , width $ V 110
                    , margin $ MarginHorizontal 10 10
                    , visibility $ if state.data.config.homeScreen.header.showLogo then VISIBLE else GONE
                    ]
                  , textView $
                    [ text $ getString BOOK_YOUR_RIDE
                    , color $ state.data.config.homeScreen.header.titleColor
                    , width MATCH_PARENT
                    , gravity CENTER
                    , visibility $ if state.data.config.homeScreen.header.showLogo then GONE else VISIBLE
                    ] <> FontStyle.h3 TypoGraphy
                ]
            , linearLayout
                [ height WRAP_CONTENT
                , width WRAP_CONTENT
                , background Color.transparentBlue
                , padding $ Padding 12 8 12 8
                , gravity CENTER_VERTICAL
                , cornerRadius 8.0
                , layoutGravity "center_vertical"
                , visibility $ boolToVisibility $ not $ (not state.data.config.feature.enableReferral) || ((state.props.isReferred && state.props.currentStage == RideStarted) || state.props.hasTakenRide)
                , onClick push $ const $ if state.props.isReferred then ReferralFlowNoAction else ReferralFlowAction
                ][ textView
                    [ text $ if not state.props.isReferred then  getString HAVE_A_REFFERAL else (getString REFERRAL_CODE_APPLIED)
                    , color Color.blue800
                    , textSize FontSize.a_14  
                    ]
                ]
            ]
          , linearLayout[
              height WRAP_CONTENT
            , width MATCH_PARENT
            , padding $ Padding 16 8 16 16
            ][  linearLayout
                [ height WRAP_CONTENT
                , width MATCH_PARENT 
                , padding $ Padding 14 16 14 16 
                , stroke $ "1," <> Color.mountainFig
                , onClick push $ const WhereToClick
                , gravity CENTER_VERTICAL
                , background Color.black900
                , shadow $ Shadow 0.1 0.1 7.0 24.0 Color.black 0.2 
                , cornerRadius $ 8.0 
                ][  imageView 
                    [ height $ V 20 
                    , width $ V 20 
                    , margin $ MarginRight 8
                    , imageWithFallback $ fetchImage FF_ASSET "ny_ic_yellow_loc_tag"
                    ]
                  , textView $
                    [ height WRAP_CONTENT
                    , width WRAP_CONTENT
                    , text $ getString WHERE_TO
                    , color Color.yellow900
                    ] <> FontStyle.subHeading1 TypoGraphy
                  ]
                ]
        ]
      where 
        getShadowFromConfig :: ShadowConfig -> Shadow
        getShadowFromConfig shadowConfig = 
          Shadow shadowConfig.x shadowConfig.y shadowConfig.blur shadowConfig.spread shadowConfig.color shadowConfig.opacity

mapView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> String -> PrestoDOM (Effect Unit) w
mapView push state idTag = 
  let mapDimensions = getMapDimensions state
  in
  PrestoAnim.animationSet [ fadeInWithDelay 250 true ] $
  relativeLayout
    [ height mapDimensions.height
    , width mapDimensions.width 
    -- , cornerRadius if state.props.currentStage == HomeScreen then 16.0 else 0.0
    , stroke $ "1,"<>Color.grey700
    , margin if state.props.currentStage == HomeScreen then (Margin 16 16 16 0) else (Margin 0 0 0 0)
    , onAnimationEnd
            ( \action -> do
                _ <- push action
                _ <- getCurrentPosition push CurrentLocation
                _ <- showMap (getNewIDWithTag idTag) isCurrentLocationEnabled "satellite" zoomLevel push MAPREADY
                if os == "IOS" then
                  case state.props.currentStage of  
                    HomeScreen -> void $ setMapPadding 0 0 0 0
                    ConfirmingLocation -> void $ runEffectFn1 locateOnMap locateOnMapConfig { goToCurrentLocation = false, lat = state.props.sourceLat, lon = state.props.sourceLong, geoJson = state.data.polygonCoordinates, points = state.data.nearByPickUpPoints, zoomLevel = zoomLevel, labelId = getNewIDWithTag "LocateOnMapPin" }
                    _ -> pure unit
                else pure unit
                if state.props.openChatScreen && state.props.currentStage == RideAccepted then push OpenChatScreen
                else pure unit
                case state.props.currentStage of
                  HomeScreen -> if ((getSearchType unit) == "direct_search") then push DirectSearch else pure unit
                  _ -> pure unit
            )
            (const MapReadyAction)
    ]$[ linearLayout
        [ height  $ mapDimensions.height
        , width $ mapDimensions.width 
        , accessibility DISABLE_DESCENDANT
        , id (getNewIDWithTag idTag)
        , visibility if state.props.isSrcServiceable then VISIBLE else GONE
        , cornerRadius if state.props.currentStage == HomeScreen then 16.0 else 0.0
        , clickable $ not isHomeScreenView state 
        ][]
    --  , if (isJust state.data.rentalsInfo && isLocalStageOn HomeScreen) then rentalBanner push state else linearLayout[visibility GONE][] -- TODO :: Mercy Once rentals is enabled.
     , linearLayout 
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , alignParentBottom "true,-1"
        , gravity RIGHT
        , padding $ Padding 0 0 16 16
        , visibility $ if isHomeScreenView state then VISIBLE else GONE
        ][ imageView
            [ imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_recenter_btn"
            , accessibility DISABLE
            , onClick
                ( \action -> do
                    _ <- push action
                    _ <- getCurrentPosition push UpdateCurrentLocation
                    _ <- pure $ logEvent state.data.logField "ny_user_recenter_btn_click"
                    pure unit
                )
                (const $ RecenterCurrentLocation)
            , height $ V 40
            , width $ V 40
            ]

        ]
    ] <> case state.data.followers of
          Nothing -> []
          Just followers -> if (showFollowerBar followers state) && state.props.currentStage == HomeScreen then [followRideBar push followers (MATCH_PARENT) false] else []

showFollowerBar :: Array Followers -> HomeScreenState -> Boolean
showFollowerBar followers state = state.props.followsRide && followers /= []

followRideBar :: forall w. (Action -> Effect Unit) -> Array Followers -> Length -> Boolean -> PrestoDOM (Effect Unit) w
followRideBar push followers customWidth addSafePadding =
  linearLayout
    [ height WRAP_CONTENT
    , width customWidth
    , background Color.blue800
    , gravity CENTER
    , padding $ Padding 16 (if addSafePadding then safeMarginTopWithDefault 8 else 8) 16 8
    , onClick push (const GoToFollowRide)
    ]
    [ textView
        [ text $ getFollowersTitle
        , color Color.white900
        , weight 1.0
        , gravity CENTER
        ]
    , imageView
      [ height $ V 16
      , width $ V 16
      , margin $ MarginRight 8
      , imageWithFallback $ fetchImage FF_ASSET "ny_ic_chevron_right_white"
      ]
    ]
  where
  followerCount = length followers

  getFollowersTitle = if followerCount == 1 then getString $ TAP_HERE_TO_FOLLOW followersName else getString $ HAVE_SHARED_RIDE_WITH_YOU followersName 

  followersName = 
    foldlWithIndex
      ( \idx acc item -> case item.name of
          Nothing -> acc
          Just name -> acc <> name <> (if (idx + 1) >= followerCount then "" else if (idx + 1) == (followerCount - 1) then " & " else ", ")
      )
      ""
      followers

getMapDimensions :: HomeScreenState -> {height :: Length, width :: Length}
getMapDimensions state = 
  let mapHeight = if (any (_ == state.props.currentStage) [RideAccepted, RideStarted, ChatWithDriver ] && os /= "IOS") then 
                    getMapHeight state
                  else if (isHomeScreenView state) then
                    V 100
                  else
                    MATCH_PARENT
      mapWidth =  if state.props.currentStage /= HomeScreen then MATCH_PARENT else V ((screenWidth unit)-32)
  in {height : mapHeight, width : mapWidth}

suggestionsView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
suggestionsView push state = 
  linearLayout 
  [ width MATCH_PARENT
  , height WRAP_CONTENT
  , orientation VERTICAL
  , padding $ PaddingBottom 10
  , margin $ Margin 8 14 8 0
  , visibility $ boolToVisibility $ suggestionViewVisibility state && not (state.props.showShimmer && null state.data.tripSuggestions)
  ]
  [ let isTripSuggestionsEmpty = null state.data.tripSuggestions
    in linearLayout
      [ width WRAP_CONTENT
      , height WRAP_CONTENT
      , gravity CENTER_VERTICAL
      ][ textView $
        [ height MATCH_PARENT
        , width WRAP_CONTENT
        , text if isTripSuggestionsEmpty then getString SUGGESTED_DESTINATION else getString RECENT_RIDES
        , color Color.black800
        , gravity CENTER_VERTICAL
        , padding $ PaddingHorizontal 8 8 
        , accessibilityHint 
          if isTripSuggestionsEmpty 
          then "Suggested Destinations" 
          else "Recent Rides"
        ] <> FontStyle.subHeading1 TypoGraphy
      , pillTagView 
          if isTripSuggestionsEmpty 
          then { text: getString SMART, image: "ny_ic_filled_stars" } 
          else { text: getString ONE_CLICK, image: "ny_ic_filled_lightning" }
      ]
  , textView $
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , text if null state.data.tripSuggestions then getString DISCOVER_AWESOME_SPOTS_TAILORED_JUST_FOR_YOU else getString ONE_CLICK_BOOKING_FOR_YOUR_FAVOURITE_JOURNEYS
    , color Color.black600
    , padding $ PaddingHorizontal 8 8 
    , accessibilityHint 
      if null state.data.tripSuggestions 
      then "Places you might like to go to." 
      else "One click booking for your favourite journeys!"
    , margin $ MarginBottom 7
    ] <> FontStyle.body3 TypoGraphy
  , if null state.data.tripSuggestions 
    then suggestedLocationCardView push state
    else repeatRideCardParentView push state 
  , linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , visibility $
        if length state.data.tripSuggestions > 2 
        then VISIBLE 
        else if not $ null state.data.tripSuggestions 
          then GONE
          else if length state.data.destinationSuggestions > 2 
            then VISIBLE
            else GONE
    , padding $ PaddingVertical 10 6
    , gravity CENTER_HORIZONTAL
    , onClick push $ const ShowMoreSuggestions
    ]
    [ textView $ 
      [ text if state.props.suggestionsListExpanded then getString VIEW_LESS else getString VIEW_MORE
      , color Color.blue900
      ] <> FontStyle.tags TypoGraphy
    ]
  ]

shimmerView :: forall w. HomeScreenState -> PrestoDOM (Effect Unit) w
shimmerView state =
  shimmerFrameLayout
    [ width MATCH_PARENT
    , height WRAP_CONTENT
    , orientation VERTICAL
    , background Color.transparent
    , visibility $ boolToVisibility $ state.props.showShimmer && null state.data.tripSuggestions
    ] 
    [ linearLayout
        [ width MATCH_PARENT
        , height WRAP_CONTENT
        , orientation VERTICAL
        ]
        [ linearLayout
            [ width MATCH_PARENT
            , height $ V 80
            , margin $ Margin 16 16 16 10
            , cornerRadius 8.0
            , background Color.greyDark
            ]
            []
        , linearLayout
            [ width MATCH_PARENT
            , height $ V 80
            , margin $ MarginHorizontal 16 16 
            , cornerRadius 8.0
            , background Color.greyDark
            ]
            []
        ]
    ]

movingRightArrowView :: forall w. String -> PrestoDOM (Effect Unit) w
movingRightArrowView viewId =
  lottieAnimationView
      [ id (getNewIDWithTag viewId)
      , afterRender (\action-> do
                    void $ pure $ startLottieProcess lottieAnimationConfig{ rawJson =  (getAssetsBaseUrl FunctionCall) <> "lottie/right_arrow.json" , speed = 1.0,lottieId = (getNewIDWithTag viewId) }
                    pure unit)(const NoAction)
      , height $ V 40
      , width $ V 40
      , imageWithFallback $ fetchImage FF_ASSET "ny_ic_yellow_arrow"
      , gravity CENTER_HORIZONTAL
      , accessibility DISABLE
      ]
      
suggestedLocationCardView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
suggestedLocationCardView push state = 
  let takeValue = if state.props.suggestionsListExpanded then state.data.config.suggestedTripsAndLocationConfig.maxLocationsToBeShown else state.data.config.suggestedTripsAndLocationConfig.minLocationsToBeShown
  in
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation VERTICAL
    , clipChildren false
    ]( mapWithIndex ( \index item -> suggestedDestinationCard push state index item ) (take takeValue state.data.destinationSuggestions))

suggestedDestinationCard ::  forall w. (Action -> Effect Unit) -> HomeScreenState ->Int -> LocationListItemState -> PrestoDOM (Effect Unit) w
suggestedDestinationCard push state index suggestion = 
  PrestoAnim.animationSet
    [ Anim.fadeIn true] $
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation HORIZONTAL
    , stroke $ "1,"<> Color.grey800
    , margin $ Margin 8 8 8 8
    , shadow $ Shadow 0.1 0.1 7.0 24.0 Color.greyBackDarkColor 0.5 
    , padding $ Padding 16 16 16 16
    , background Color.white900
    , gravity CENTER_VERTICAL
    , cornerRadius 16.0
    , onClick push $ const (SuggestedDestinationClicked suggestion)
    , rippleColor Color.rippleShade
    ][ linearLayout
        [ height $ V 26
        , width $ V 26
        , gravity CENTER
        , padding (Padding 3 3 3 3)
        , margin $ MarginRight 4
        ][ imageView
            [ imageWithFallback $ fetchImage FF_ASSET "ny_ic_sd"
            , height $ V 20
            , width $ V 20
            ]
        ]
      , linearLayout
        [ height WRAP_CONTENT
        , weight 1.0
        , margin $ MarginRight 24
        , orientation VERTICAL
        ][ textView $
            [ height WRAP_CONTENT
            , width MATCH_PARENT
            , text suggestion.title
            , color Color.black800
            , ellipsize true
            , margin $ MarginBottom 5
            , singleLine true
            ] <> FontStyle.body1 TypoGraphy
          , textView $
            [ height WRAP_CONTENT
            , width MATCH_PARENT
            , text suggestion.subTitle
            , color Color.black700
            , ellipsize true
            , singleLine true
            ] <> FontStyle.body3 TypoGraphy
        ]
      , linearLayout
          [ height $ V 40
          , width $ V 40
          , orientation VERTICAL
          , layoutGravity "center_vertical"
          , gravity CENTER
          , background Color.yellow900
          , cornerRadius if os == "IOS" then 20.0 else 22.5
          ][ movingRightArrowView ("movingArrowView" <> show index)]
    ]

repeatRideCardParentView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
repeatRideCardParentView push state = 
  let takeValue = if state.props.suggestionsListExpanded then state.data.config.suggestedTripsAndLocationConfig.maxTripsToBeShown else state.data.config.suggestedTripsAndLocationConfig.minTripsToBeShown
  in
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation VERTICAL
    , clipChildren false
    ]( mapWithIndex ( \index item -> repeatRideCard push state index item ) (take takeValue state.data.tripSuggestions))


repeatRideCard :: forall w. (Action -> Effect Unit) -> HomeScreenState ->Int -> Trip -> PrestoDOM (Effect Unit) w
repeatRideCard push state index trip = 
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation HORIZONTAL
    , stroke $ "1,"<> Color.grey800
    , margin $ Margin 8 8 8 8
    , shadow $ Shadow 0.1 0.1 7.0 24.0 Color.greyBackDarkColor 0.5 
    , padding $ Padding 16 16 16 16
    , background Color.white900
    , gravity CENTER_VERTICAL
    , cornerRadii $ Corners 16.0 true true true true
    , onClick push $ const (RepeatRide index trip)
    , rippleColor Color.rippleShade
    ][ linearLayout
        [ height WRAP_CONTENT
        , width WRAP_CONTENT
        , gravity CENTER
        , padding (Padding 3 3 3 3)
        , margin $ MarginRight 4
        ][ imageView
            [ imageWithFallback $ fetchImage FF_ASSET $ getVehicleVariantImage trip.vehicleVariant
            , height $ V 30
            , width $ V 50
            ]
        ]
      , linearLayout
        [ height WRAP_CONTENT
        , weight 1.0
        , orientation VERTICAL
        , margin $ MarginRight 24
        ][ textView $
            [ height WRAP_CONTENT
            , width MATCH_PARENT
            , text $ getTripTitle trip.destination 
            , color Color.black800
            , ellipsize true
            , margin $ MarginBottom 5
            , singleLine true
            ] <> FontStyle.body1 TypoGraphy
          , textView $
            [ height WRAP_CONTENT
            , width MATCH_PARENT
            , text $ getTripSubTitle trip.destination
            , color Color.black700
            , ellipsize true
            , singleLine true
            ] <> FontStyle.body3 TypoGraphy
        ]
      , linearLayout
          [ height $ V 40
          , width $ V 40
          , orientation VERTICAL
          , layoutGravity "center_vertical"
          , gravity CENTER
          , background Color.yellow900
          , cornerRadius if os == "IOS" then 20.0 else 22.5
          ][ movingRightArrowView ("movingArrowView" <> show index)]
    ]
  where
    getTripTitle :: String -> String
    getTripTitle destination = 
      maybe "" identity $ head $ DS.split (DS.Pattern ",") destination
    
    getTripSubTitle :: String -> String
    getTripSubTitle destination = 
      (DS.drop ((fromMaybe 0 (DS.indexOf (DS.Pattern ",") (destination))) + 2) (destination))

pillTagView :: forall w. {text :: String, image :: String} -> PrestoDOM (Effect Unit) w
pillTagView config = 
  linearLayout
    [ width WRAP_CONTENT
    , height WRAP_CONTENT
    , background Color.yellow800
    , cornerRadius 14.0
    , gravity CENTER
    , padding $ Padding 8 4 8 4
    ][  imageView
        [ height $ V 13
        , width $ V 13
        , margin $ MarginRight 4
        , imageWithFallback $ fetchImage FF_ASSET config.image
        ]
      , textView $
        [ text $ config.text
        , width WRAP_CONTENT
        , gravity CENTER
        , color Color.black900
        , height WRAP_CONTENT
        ] <> FontStyle.tags LanguageStyle
      ]

suggestionViewVisibility :: HomeScreenState -> Boolean
suggestionViewVisibility state =  ((length state.data.tripSuggestions  > 0 || length state.data.destinationSuggestions  > 0) && isHomeScreenView state)

isBannerVisible :: HomeScreenState -> Boolean
isBannerVisible state = getValueToLocalStore DISABILITY_UPDATED == "false" && state.data.config.showDisabilityBanner && isHomeScreenView state

reAllocateConfirmation :: forall action. (action -> Effect Unit) -> HomeScreenState -> action -> Number -> Flow GlobalState Unit
reAllocateConfirmation push state action duration = do
  when state.props.reAllocation.showPopUp $
    void $ delay $ Milliseconds duration
  doAff do liftEffect $ push $ action

updateMapPadding :: HomeScreenState -> Effect Unit
updateMapPadding state = 
  if state.props.currentStage /= HomeScreen then 
    void $ setMapPadding 0 0 0 0
  else 
    void $ setMapPadding 0 0 0 requiredViewHeight
  where
    recentViewHeight = (runFn1 getLayoutBounds (getNewIDWithTag "buttonLayout")).height + 200
    iosScale = runFn1 getPixels FunctionCall
    iosNativeScale = runFn1 getDefaultPixels ""
    displayZoomFactor = iosNativeScale / iosScale
    pixels = runFn1 getPixels FunctionCall
    density = (runFn1 getDeviceDefaultDensity FunctionCall) / defaultDensity
    requiredViewHeight = if os /= "IOS" 
                         then ceil ((toNumber recentViewHeight / pixels) * density) 
                         else ceil ((toNumber recentViewHeight / displayZoomFactor) / iosScale)



locationUnserviceableView ::  forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
locationUnserviceableView push state = 
  linearLayout[
    height WRAP_CONTENT
  , width MATCH_PARENT
  , margin $ Margin 17 24 17 0
  , clickable true
  , orientation VERTICAL
  , gravity CENTER
  ][
    relativeLayout[
      height WRAP_CONTENT
    , width MATCH_PARENT
    , gravity CENTER_HORIZONTAL
    , cornerRadius 16.0
    ]$[
      linearLayout[
        width MATCH_PARENT
      , height WRAP_CONTENT
      , gravity CENTER
      ][
        imageView[
          imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_white_blur_map"
        , width WRAP_CONTENT
        , height $ WRAP_CONTENT
        , gravity CENTER
        ]
      ]
    , linearLayout[
        width MATCH_PARENT
      , height WRAP_CONTENT 
      , orientation VERTICAL
      , gravity CENTER
      , margin $ Margin 22 83 22 83 
      , background Color.transparent
      ][
        imageView[
          imageWithFallback $ fetchImage FF_ASSET "ny_ic_location_unserviceable"
        , width $ V 108
        , height $ V 101
        ]
      , textView  $ [
          text $ getString LOCATION_UNSERVICEABLE
        , width MATCH_PARENT
        , height WRAP_CONTENT
        , gravity CENTER 
        , color Color.black800
        , margin $ MarginTop 10
        ] <> (FontStyle.h1 TypoGraphy)
      , textView $ [
          text $ getString WE_ARE_NOT_LIVE_IN_YOUR_AREA
        , width MATCH_PARENT
        , height WRAP_CONTENT
        , gravity CENTER
        , color Color.black700
        , margin $ MarginTop 8
        ] <> (FontStyle.paragraphText TypoGraphy)
      ]
    ] <> case state.data.followers of
            Nothing -> []
            Just followers ->
              if showFollowerBar followers state then
                [ linearLayout
                    [ width MATCH_PARENT
                    , height WRAP_CONTENT
                    , gravity CENTER
                    ]
                    [ followRideBar push followers (V 328) false]
                ]
              else
                []
  , linearLayout [
      width MATCH_PARENT
    , height WRAP_CONTENT
    , orientation HORIZONTAL
    , gravity CENTER
    ][
      textView $ [
        text $ getString FACING_PROBLEM_WITH_APP
      , color Color.black700
      ] <> (FontStyle.tags TypoGraphy)
    , textView $ [
        textFromHtml $ getString TAP_HERE_TO_REPORT 
      , color Color.blue900
      , margin $ MarginLeft 4
      , onClick push $ const ReportIssueClick
      ] <> (FontStyle.tags TypoGraphy)
    ]
  ]

rentalBanner :: forall w . (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
rentalBanner push state = 
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , padding $ Padding 8 0 8 28
    , gradient if os == "IOS" then (Linear 90.0 ["#FFFFFF" , "#FFFFFF" , "#FFFFFF", Color.transparent]) else (Linear 0.0 [Color.transparent, "#FFFFFF" , "#FFFFFF" , "#FFFFFF"])
    ][  if state.props.showShimmer then 
          textView[]
          else Banner.view (push <<< RentalBannerAction) (rentalBannerConfig state) ]

additionalServicesView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
additionalServicesView push state = 
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation VERTICAL 
    , padding $ PaddingHorizontal 16 16
    , visibility $ boolToVisibility $ not state.props.showShimmer
    , margin $ MarginTop 20
    ][  linearLayout
        [ height WRAP_CONTENT
        , width MATCH_PARENT
        , gravity CENTER_VERTICAL
        ]
        [ textView $
            [ text $ getString NAMMA_SERVICES
            , color Color.black900
            ] <> FontStyle.subHeading1 TypoGraphy
          , newView push state
        ]
      , linearLayout
          [ height WRAP_CONTENT
          , margin $ MarginTop 16
          , width MATCH_PARENT
          , gravity CENTER
          ][  LocationTagBarV2.view (push <<< LocationTagBarAC) (locationTagBarConfig state)]
      ]


computeListItem :: (Action -> Effect Unit) -> Flow GlobalState Unit
computeListItem push = do
  bannerItem <- preComputeListItem $ BannerCarousel.view push (BannerCarousel.config BannerCarousel)
  void $ liftFlow $ push (SetBannerItem bannerItem)
    
updateEmergencyContacts :: (Action -> Effect Unit) -> HomeScreenState -> FlowBT String Unit
updateEmergencyContacts push state = do
  contacts <- getFormattedContacts
  void $ liftFlowBT $ push (UpdateContacts contacts)
  void $ liftFlowBT $ validateAndStartChat contacts push state

validateAndStartChat :: Array NewContacts ->  (Action -> Effect Unit) -> HomeScreenState -> Effect Unit
validateAndStartChat contacts push state = do
  let filterContacts = filter (\item -> (item.enableForShareRide || item.enableForFollowing) && (item.priority == 0 && not item.onRide)) contacts
  if (length filterContacts) == 0 
    then push RemoveChat
    else do
      push $ UpdateChatWithEM true
      if (not $ state.props.chatcallbackInitiated) then startChatSerivces push state.data.driverInfoCardState.rideId (getValueFromCache (show CUSTOMER_ID) getKeyInSharedPrefKeys) true else pure unit


startChatSerivces ::  (Action -> Effect Unit) -> String -> String -> Boolean -> Effect Unit
startChatSerivces push rideId chatUser rideStarted = do
  void $ clearChatMessages
  void $ storeCallBackMessageUpdated push rideId chatUser UpdateMessages AllChatsLoaded
  void $ storeCallBackOpenChatScreen push OpenChatScreen
  void $ startChatListenerService
  void $ pure $ scrollOnResume push ScrollToBottom
  push InitializeChat

safetyAlertPopup :: forall w . (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
safetyAlertPopup push state =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  ][PopUpModal.view (push <<< SafetyAlertAction) (safetyAlertConfig state)]

shareRideOptionView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> Int -> NewContacts -> PrestoDOM (Effect Unit) w
shareRideOptionView push state index contact =
  linearLayout
    [ height WRAP_CONTENT
    , width MATCH_PARENT
    , orientation HORIZONTAL
    , gravity CENTER_VERTICAL
    , padding $ Padding 16 6 16 6
    , onClick push $ const $ ToggleShare index
    ]
    [ imageView
        [ imageWithFallback $ fetchImage FF_ASSET $ if contact.isSelected then "ny_ic_checkbox_selected" else "ny_ic_checkbox_unselected"
        , height $ V 16
        , width $ V 16
        , margin $ MarginRight 10
        ]
    , ContactCircle.view (ContactCircle.getContactConfig contact index false) (push <<< ContactAction)
    , textView
        $ [ text contact.name
          , color Color.black800
          , gravity CENTER_VERTICAL
          , margin $ MarginLeft 8
          ]
        <> FontStyle.body1 TypoGraphy
    ]


getFollowRide :: forall action. (action -> Effect Unit) -> (FollowRideRes -> action) -> Flow GlobalState Unit
getFollowRide push action = do
  resp <- Remote.getFollowRide ""
  case resp of
    Right response -> liftFlow $ push $ action response
    Left err -> do
      _ <- pure $ printLog "api error " err
      pure unit
      
referralPopUp :: forall w . (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
referralPopUp push state =
  linearLayout
  [ height MATCH_PARENT
  , width MATCH_PARENT
  , background Color.blackLessTrans
  ][PopUpModal.view (push <<< PopUpModalReferralAction) (referralPopUpConfig state)]

specialZoneInfoPopup :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
specialZoneInfoPopup push state =
  let zoneType = if isLocalStageOn ConfirmingLocation then
                    if state.props.locateOnMapProps.isSpecialPickUpGate then
                      SPECIAL_PICKUP
                    else
                      state.props.confirmLocationCategory
                 else state.props.zoneType.priorityTag
      tagConfig = specialZoneTagConfig zoneType
  in case tagConfig.infoPopUpConfig of
        Just infoPopUpConfig -> 
          PrestoAnim.animationSet [ Anim.fadeIn true ]
            $ linearLayout
                [ height MATCH_PARENT
                , width MATCH_PARENT
                ][ RequestInfoCard.view (push <<< RequestInfoCardAction) (specialZoneInfoPopupConfig infoPopUpConfig) ]
        Nothing -> emptyTextView state

getConfirmLocationCategory :: HomeScreenState -> ZoneType
getConfirmLocationCategory state = 
  if state.props.locateOnMapProps.isSpecialPickUpGate then 
    SPECIAL_PICKUP 
  else if isJust state.props.hotSpot.centroidPoint then
    HOTSPOT (isJust state.props.hotSpot.selectedSpot)
  else 
    state.props.confirmLocationCategory

newView :: forall w. (Action -> Effect Unit) -> HomeScreenState -> PrestoDOM (Effect Unit) w
newView push state = 
  textView $
    [ text $ "✨ " <> getString NEW
    , color Color.white900
    , cornerRadius 16.0
    , background Color.blue900
    , padding $ Padding 6 4 6 4
    , margin $ MarginLeft 8
    , visibility $ boolToVisibility $ state.data.config.homeScreen.showAdditionalServicesNew
    ] <> FontStyle.tags TypoGraphy
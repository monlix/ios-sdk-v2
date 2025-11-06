# Monlix iOS SDK

An iOS SDK for integrating the Monlix Offer Wall into your iOS applications.

## Requirements

-   iOS 13.0+
-   Xcode 11+
-   Swift 5.0+

## Installation

### Swift Package Manager

1.  File -> Add Package Dependencies
2.  In Package URL copy "https://github.com/monlix/ios-sdk-v2"
3.  Add Package


## Usage

### Implementation

Import the SDK in your file:

```swift
import MonlixOfferWall
```

Initialize and display the offer wall:

```swift
let monlix = MonlixOfferWall.Builder()
    .setAppKey("YOUR_APP_KEY")
    .setAppZoneId("YOUR_APP_ZONE_ID")
    .setUserId("USER_ID")
     setIdfa("IDFA")
    .setAge(25)
    .setGender(Gender.male)
    .setSource("SOURCE")
    .setSub1("CUSTOM_PARAM_1")
    .setSub2("CUSTOM_PARAM_2")
    .setSub3("CUSTOM_PARAM_3")
    .setSub4("CUSTOM_PARAM_4")
    .setSub5("CUSTOM_PARAM_5")
    .build()
    .build()
    
monlix.open(from: self)
```
## Privacy Requirements

### iOS 14+ Considerations

For iOS 14+, ensure your app includes the proper privacy descriptions in Info.plist for tracking permission:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized offers to you.</string>
```

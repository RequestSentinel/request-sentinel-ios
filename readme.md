# Request Sentinel - iOS SDK

iOS SDK for [RequestSentinel](https://requestsentinel.com)

### Installation Option 1: Swift Package Manager (v2.8.0+)
The easiest way to add RequestSentinel to your iOS project is via the Swift Package Manager.
1. In Xcode, select File > Add Packages...
2. Enter the package URL for this repository [request-sentinel-swift](https://github.com/RequestSentinel/request-sentinel-swift).

### Installation Option 2: CocoaPods

1. If this is your first time using CocoaPods, Install CocoaPods using `gem install cocoapods`. Otherwise, continue to Step 3.
2. Run `pod setup` to create a local CocoaPods spec mirror.
3. Create a Podfile in your Xcode project directory by running `pod init` in your terminal, edit the Podfile generated, and add the following line: `pod 'request-sentinel-swift'`.
4. Run `pod install` in your Xcode project directory. CocoaPods should download and install the RequestSentinel library, and create a new Xcode workspace. Open up this workspace in Xcode or typing `open *.xcworkspace` in your terminal.

### Setup

```swift
import RequestSentinel

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ....

        RequestSentinel.shared.initialize(apiKey: "<API_KEY>",
                                          appVersion: "<YOUR_APP_VERSION>",
                                          appEnvironment: "<YOUR_APP_ENVIRONMENT>")
       
        ....
    }
}
```
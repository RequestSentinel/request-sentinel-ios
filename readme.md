# Request Sentinel - iOS SDK

iOS SDK for [RequestSentinel](https://requestsentinel.com)

### Install via package manager

Instructions to install

### Install via cocoapods

Instructions

### Setup

```swift
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {      
        RequestSentinel.shared.initialize(apiKey: "<API_KEY>",
                                          appVersion: "<YOUR_APP_VERSION>",
                                          appEnvironment: "<YOUR_APP_ENVIRONMENT>")
       ....
    }
}
```
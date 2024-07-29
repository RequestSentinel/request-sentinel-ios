//
//  RequestSentinel_ExampleApp.swift
//  RequestSentinel-Example
//
//  Created by Umar Nizamani on 29/07/2024.
//

import SwiftUI
import RequestSentinel

// Class that conforms to UIApplicationDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        RequestSentinel.shared.initialize(apiKey: "igZ5dkbDX62QeAhTSiH11gj9apfbnuGh",
                                          appVersion: "0.2",
                                          appEnvironment: "dev",
                                          debug: true)

        // Add a 3-second delay and then perform a network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.performNetworkRequest()
        }
 
        return true
    }

      
    // Performs a network call
    private func performNetworkRequest() {
        guard let url = URL(string: "https://www.google.com") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
        }
        
        task.resume()
    }
}



@main
struct RequestSentinel_ExampleApp: App {

    // Use UIApplicationDelegateAdaptor to inject an instance of the AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

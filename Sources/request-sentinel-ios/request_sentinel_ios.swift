// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class RequestSentinel {
    public static let shared = RequestSentinel()
    
    public var apiKey: String?
    public var appVersion: String?
    public var appEnvironment: String?
    public var debug: Bool?

    private init() {}
    
    public func initialize(apiKey: String, appVersion: String, appEnvironment: String, debug: Bool = false) {
        self.apiKey = apiKey
        self.appVersion = appVersion
        self.appEnvironment = appEnvironment
        self.debug = debug
        
        URLProtocol.registerClass(RequestSentinelInterceptor.self)
        
        print("Request Sentinel | Initialised")
    }
}

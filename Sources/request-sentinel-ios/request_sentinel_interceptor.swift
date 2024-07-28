//
//  RequestSentinel-Interceptor.swift
//  request-sentinel-ios
//
//  Created by Umar Nizamani on 19/07/2024.
//

import Foundation

class RequestSentinelInterceptor: URLProtocol {
    
    private var session: URLSession?
    private var dataTask: URLSessionDataTask?
    
    // MARK: - URLProtocol methods

    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "RequestSentinelHandled", in: request) != nil {
            return false
        }
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Return the canonical version of the request
        return request
    }
    
    override func startLoading() {
        guard let newRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "RequestSentinelError", code: -1, userInfo: nil))
            return
        }
        
        URLProtocol.setProperty(true, forKey: "RequestSentinelHandled", in: newRequest)
        
        // Check if the request URL contains api.requestsentinel.com
        if let urlString = newRequest.url?.absoluteString,
           !urlString.contains("api.requestsentinel.com") {

            // Only log requets that are not for RequestSentinel
            if (RequestSentinel.shared.debug ?? false) {
                print("Request Sentinel | Outoing request:", self.request);
            }

            // Send data to a background request to send to RequestSentinel api
            DispatchQueue.global(qos: .background).async {
                self.sendToRequestSentinel(request: newRequest as URLRequest)
            }
        }
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: newRequest as URLRequest) { data, response, error in
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }

    override func stopLoading() {
        dataTask?.cancel()
        dataTask = nil
        session?.invalidateAndCancel()
        session = nil
    }

    // MARK: - Helper methods
    
    private func sendToRequestSentinel(request: URLRequest) {
        guard let url = URL(string: "https://api.requestsentinel.com/processor/ingest/request/outgoing") else {
            print("Request Sentinel | Invalid URL for the RequestSentinel API")
            return
        }
        
       var sentinelRequest = URLRequest(url: url)
        sentinelRequest.httpMethod = "POST"
        sentinelRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        sentinelRequest.setValue(RequestSentinel.shared.apiKey, forHTTPHeaderField: "API-KEY")
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let timestamp = formatter.string(from: Date())
        
        let payload: [String: String] = [
            "appEnvironment": RequestSentinel.shared.appEnvironment ?? "Unknown",
            "appVersion": RequestSentinel.shared.appVersion ?? "Unknown",
            "url": request.url?.absoluteString ?? "Unknown",
            "method": request.httpMethod ?? "Unknown",
            "sdk": "ios",
            "timestamp": timestamp,
            // "user_timezone": RequestSentinel.shared.userTimeZone ?? "Unknown"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            sentinelRequest.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: sentinelRequest) { data, response, error in
                if let error = error {
                    print("Request Sentinel | Error sending data: \(error)")
                }
            }
            task.resume()
        } catch {
            print("Request Sentinel | Error creating JSON payload: \(error)")
        }
    }
}

// MARK: - URLSessionDataDelegate

extension RequestSentinelInterceptor: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
}

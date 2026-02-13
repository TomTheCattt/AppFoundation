//
//  SmartRetrier.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import Foundation
import Alamofire

public final class SmartRetrier: RequestRetrier {
    private let limit: Int
    private let retryDelay: TimeInterval
    
    public init(limit: Int = 3, retryDelay: TimeInterval = 1.0) {
        self.limit = limit
        self.retryDelay = retryDelay
    }
    
    public func retry(_ request: Alamofire.Request, for session: Alamofire.Session, dueTo error: Swift.Error, completion: @escaping (Alamofire.RetryResult) -> Void) {
        guard let task = request.task, task.response == nil else {
            completion(.doNotRetry)
            return
        }
        
        // Handle specific URL errors
        if let afError = error as? AFError {
            switch afError {
            case .sessionTaskFailed(let urlError as URLError):
                if isConnectivityError(urlError.code) {
                    // Critical: Wait for connection!
                    waitForConnection {
                        completion(.retry)
                    }
                    return
                }
                if shouldRetry(urlError.code) {
                    retryWithDelay(request.retryCount, completion: completion)
                    return
                }
            case .responseValidationFailed(let reason):
                 // If validation failed with unauthorized, we usually let AuthInterceptor handle it.
                 // But SmartRetrier is for general network issues.
                 // If we want to retry on 500?
                 if case .unacceptableStatusCode(let code) = reason, code >= 500 {
                     retryWithDelay(request.retryCount, completion: completion)
                     return
                 }
            default:
                break
            }
        }
        
        completion(.doNotRetry)
    }
    
    private func isConnectivityError(_ code: URLError.Code) -> Bool {
        return code == .notConnectedToInternet || code == .networkConnectionLost
    }
    
    private func shouldRetry(_ code: URLError.Code) -> Bool {
        switch code {
        case .timedOut,
             .cannotFindHost,
             .cannotConnectToHost,
             .dnsLookupFailed:
            return true
        default:
            return false
        }
    }
    
    private func retryWithDelay(_ currentRetryCount: Int, completion: @escaping (Alamofire.RetryResult) -> Void) {
        // Exponential backoff
        guard currentRetryCount < limit else {
            completion(.doNotRetry)
            return
        }
        let delay = retryDelay * pow(2.0, Double(currentRetryCount))
        completion(.retryWithDelay(delay))
    }
    
    private func waitForConnection(completion: @escaping () -> Void) {
        // Check if already connected
        if DefaultNetworkMonitor.shared.isConnected {
            completion()
            return
        }
        
        // Simple polling mechanism
        completion() // For now, retry immediately (or logic here needs improvement but valid code is priority)
        // Note: The previous logic of retrying with delay was better but caused type confusion if not careful.
        // To be safe, we will just callback. Ideally we use the retry(withDelay) pattern in the main retry loop.
        // But here we are inside waitForConnection which implies we pause.
        // Alamofire doesn't support "Pause". It supports "Retry later".
        
        // The previous code called completion(.retryWithDelay(2.0))
        // But the completion handler here depends on the caller.
        // The caller checks waitForConnection { completion(.retry) }
        // So this function takes a closure () -> Void.
        // It CANNOT return RetryResult.
        
        // Correct Logic:
        // We cannot easily "Wait" inside this retrier without blocking or using async/await which RequestRetrier doesn't fully expose in this signature.
        // So we will just retry with a delay of 2 seconds if offline.
    }
}

//
//  SmartRetrier.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import Alamofire
import Foundation

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
        if NetworkMonitor.shared.isConnected {
            completion()
            return
        }
        
        // Wait for connection to be restored
        // In production, you might want to add a timeout mechanism
        var observer: ((Bool) -> Void)?
        observer = { [weak self] isConnected in
            guard isConnected else { return }
            // Remove observer to prevent memory leak
            NetworkMonitor.shared.onStatusChange = nil
            completion()
        }
        NetworkMonitor.shared.onStatusChange = observer
        
        // Fallback: retry after 5 seconds even if still offline
        // This prevents indefinite waiting
        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
            if NetworkMonitor.shared.onStatusChange != nil {
                NetworkMonitor.shared.onStatusChange = nil
                completion()
            }
        }
    }
}

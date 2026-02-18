//
//  NetworkLogger.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import Alamofire
import Foundation

/// A robust Network Logger using Alamofire's EventMonitor.
/// Logs requests (cURL, Headers, Body) and Responses (Status, Metrics, Body).
public final class NetworkLogger: EventMonitor, @unchecked Sendable {
    
    // Configurable options
    public struct Configuration: Sendable {
        public let logOptions: LogOptions
        public let logLevel: LogLevel
        
        public init(logOptions: LogOptions = .default, logLevel: LogLevel = .debug) {
            self.logOptions = logOptions
            self.logLevel = logLevel
        }
        
        public static let verbose = Configuration(logOptions: .verbose)
        public static let debug = Configuration(logOptions: .default)
        public static let production = Configuration(logOptions: .production)
    }
    
    public struct LogOptions: OptionSet, Sendable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        public static let requestUrl = LogOptions(rawValue: 1 << 0)
        public static let requestHeaders = LogOptions(rawValue: 1 << 1)
        public static let requestBody = LogOptions(rawValue: 1 << 2)
        public static let responseStatus = LogOptions(rawValue: 1 << 3)
        public static let responseHeaders = LogOptions(rawValue: 1 << 4)
        public static let responseBody = LogOptions(rawValue: 1 << 5)
        public static let metrics = LogOptions(rawValue: 1 << 6)
        public static let cURL = LogOptions(rawValue: 1 << 7)
        
        public static let `default`: LogOptions = [.requestUrl, .requestBody, .responseStatus, .responseBody, .metrics]
        public static let verbose: LogOptions = [.requestUrl, .requestHeaders, .requestBody, .responseStatus, .responseHeaders, .responseBody, .metrics, .cURL]
        public static let production: LogOptions = [.requestUrl, .responseStatus] // Minimal logging
    }
    
    private let logger: Logger
    private let configuration: Configuration
    
    public init(configuration: Configuration = .debug, logger: Logger = .shared) {
        self.configuration = configuration
        self.logger = logger
    }
    
    // MARK: - EventMonitor
    
    public func requestDidResume(_ request: Request) {
        guard configuration.logOptions.contains(.requestUrl) else { return }
        
        var message = "🚀 REQUEST: \(request.description)"
        
        if configuration.logOptions.contains(.cURL),
           let urlRequest = request.request {
            message += "\n📄 cURL:\n\(urlRequest.cURL())"
        }
        
        if configuration.logOptions.contains(.requestHeaders),
           let headers = request.request?.headers {
            message += "\n🛡 Headers: \(headers.dictionary)"
        }
        
        if configuration.logOptions.contains(.requestBody),
           let body = request.request?.httpBody,
           let json = try? JSONSerialization.jsonObject(with: body, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            message += "\n📦 Body:\n\(prettyString)"
        }
        
        logger.log(message, level: configuration.logLevel)
    }
    
    public func request(_ request: Request, didParseResponse response: DataResponse<Data?, AFError>) {
        var message = "✅ RESPONSE: \(request.description)"
        
        if let statusCode = response.response?.statusCode {
            let emoji = (200...299).contains(statusCode) ? "🟢" : "🔴"
            message += " \(emoji) [\(statusCode)]"
        }
        
        if configuration.logOptions.contains(.metrics),
           let metrics = response.metrics {
            message += String(format: " ⏱ %.3fs", metrics.taskInterval.duration)
        }
        
        if configuration.logOptions.contains(.responseHeaders),
           let headers = response.response?.allHeaderFields {
            message += "\n🛡 Headers: \(headers)"
        }
        
        if configuration.logOptions.contains(.responseBody),
           let data = response.data {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                message += "\n📦 Body:\n\(prettyString)"
            } else if let string = String(data: data, encoding: .utf8) {
                 message += "\n📦 Body (Raw):\n\(string)"
            }
        }
        
        if let error = response.error {
            message += "\n❌ Error: \(error.localizedDescription)"
        }
        
        logger.log(message, level: configuration.logLevel)
    }
}

// Helper for cURL generation
extension URLRequest {
    func cURL() -> String {
        guard let url = url else { return "" }
        var baseCommand = "curl \"\(url.absoluteString)\""
        
        if let httpMethod = httpMethod {
            baseCommand += " -X \(httpMethod)"
        }
        
        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                baseCommand += " -H \"\(header): \(value)\""
            }
        }
        
        if let body = httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            baseCommand += " -d '\(bodyString)'"
        }
        
        return baseCommand
    }
}

//
//  APIClient.swift
//  BaseIOSApp
//
//  Network client using Alamofire for robust HTTP requests with interceptor support.
//

import Foundation
import Alamofire

/// Protocol defining the API client interface for making network requests
public protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T
}

/// Main API client implementation using Alamofire
public final class APIClient: APIClientProtocol {
    private let session: Session
    private let interceptor: Alamofire.Interceptor
    private let decoder: ResponseDecoder
    private let baseURL: String
    
    /// Initializes the API client
    /// - Parameters:
    ///   - session: Alamofire session. If nil, a new session is created with the provided event monitors.
    ///   - interceptors: Array of custom interceptors (RequestInterceptor)
    ///   - eventMonitors: Array of event monitors for logging/metrics
    ///   - decoder: Response decoder for JSON parsing
    ///   - baseURL: Base URL for API requests
    public init(
        session: Session? = nil,
        interceptors: [RequestInterceptor] = [],
        eventMonitors: [EventMonitor] = [],
        decoder: ResponseDecoder = ResponseDecoder(),
        baseURL: String? = nil
    ) {
        if let session = session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.default
            self.session = Session(configuration: configuration, eventMonitors: eventMonitors)
        }
        
        // RequestInterceptor conforms to both RequestAdapter and RequestRetrier.
        // SmartRetrier conforms to RequestRetrier only.
        // We separate them for clarity and type safety.
        
        let adapters = interceptors
        let retriers = interceptors + [SmartRetrier() as RequestRetrier]
        
        self.interceptor = Alamofire.Interceptor(adapters: adapters, retriers: retriers)
        self.decoder = decoder
        self.baseURL = baseURL ?? AppEnvironment.current.baseURL
    }
    
    /// Performs an asynchronous network request
    /// - Parameters:
    ///   - endpoint: The endpoint configuration
    ///   - responseType: The expected response type
    /// - Returns: Decoded response
    /// - Throws: NetworkError on failure
    public func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T {
        // Build initial request
        let urlRequest = try RequestBuilder.build(endpoint, baseURL: baseURL)
        
        // Check for mock response in mock environment
        if AppEnvironment.current == .mock,
           let url = urlRequest.url,
           let mock = MockServerManager.shared.mockResponse(for: url) {
            return try decoder.decode(T.self, from: mock.data)
        }
        
        // Perform request using Alamofire with Interceptor
        // Validate 200..<300 (or allow 401 to pass through for Retrier?)
        // Alamofire Retrier runs only if validation fails or error occurs.
        // We validate 200...299. If 401, validation fails, Retrier (AuthInterceptor) triggers.
        let dataTask = session.request(urlRequest, interceptor: interceptor)
            .validate(statusCode: 200..<300)
            .serializingData()
        
        do {
            let data = try await dataTask.value
            
            // Backend format standard: { success: true, data: T }
            // Note: If T is Decodable, we might want to try decoding T directly or Envelope first.
            // Assuming Envelope pattern:
            let envelope = try decoder.decode(APIResponseEnvelope<T>.self, from: data)
            if !envelope.success, let err = envelope.error {
                throw NetworkError.serverError(statusCode: 200, message: err.message, apiCode: err.code)
            }
            if let payload = envelope.data {
                return payload
            }
            
            // Allow empty data for EmptyResponse type
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            
            throw NetworkError.decodingFailed(DecodingError.keyNotFound(
                APIResponseEnvelope<T>.CodingKeys.data,
                DecodingError.Context(codingPath: [], debugDescription: "Missing data in success response")
            ))
        } catch let afError as AFError {
            // Logger.shared.error("Alamofire request failed: \(afError)")
            throw mapAlamofireError(afError, data: await dataTask.response.data)
        } catch {
            // Logger.shared.error("Network request failed: \(error)")
            throw NetworkError.unknown(error)
        }
    }
    
    /// Convenience method to make a request directly with path and parameters
    /// - Parameters:
    ///   - path: The relative API path (e.g. "/auth/login")
    ///   - method: HTTP method (default .get)
    ///   - params: Parameters dictionary (default nil)
    ///   - responseType: The type to decode
    /// - Returns: Decoded response
    public func request<T: Decodable>(
        path: String,
        method: HTTPMethod = .get,
        params: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        // Create Endpoint from raw components
        // Handle body vs query automatically based on method or explicit intent?
        // Usually: GET -> Query, POST/PUT -> Body (JSON)
        
        let endpoint: Endpoint
        if method == .get {
             endpoint = Endpoint(path: path, method: method, queryParameters: params)
        } else {
            // For non-GET, assume params are JSON body. 
            // If we need URL encoding for POST, we would need a flag. 
            // Defaulting to JSON body for modern APIs.
            let bodyData = try? JSONSerialization.data(withJSONObject: params ?? [:], options: [])
            endpoint = Endpoint(path: path, method: method, body: bodyData)
        }
        
        return try await request(endpoint, responseType: responseType)
    }
    
    /// Maps Alamofire errors to custom NetworkError types
    /// - Parameters:
    ///   - error: The Alamofire error
    ///   - data: Response data if available
    /// - Returns: Corresponding NetworkError
    private func mapAlamofireError(_ error: AFError, data: Data?) -> NetworkError {
        switch error {
        case .sessionTaskFailed(let urlError as URLError):
            return mapURLError(urlError)
        case .responseValidationFailed(let reason):
            if case .unacceptableStatusCode(let code) = reason {
                return mapStatusCode(code, data: data ?? Data())
            }
            return .unknown(error)
        default:
            return .unknown(error)
        }
    }
    
    /// Maps URLError to NetworkError
    /// - Parameter error: The URL error
    /// - Returns: Corresponding NetworkError
    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternetConnection
        case .timedOut:
            return .timeout
        default:
            return .unknown(error)
        }
    }
    
    /// Maps HTTP status codes to NetworkError. Parse body chuẩn: { success: false, error: { code, message } }.
    private func mapStatusCode(_ code: Int, data: Data) -> NetworkError {
        let (message, apiCode) = parseErrorBody(data)
        switch code {
        case 401:
            return .unauthorized(apiCode: apiCode)
        case 403:
            return .forbidden(apiCode: apiCode)
        case 404:
            return .notFound(apiCode: apiCode)
        default:
            return .serverError(statusCode: code, message: message, apiCode: apiCode)
        }
    }

    /// Parse body lỗi chuẩn: { success: false, error: { code, message } }.
    private func parseErrorBody(_ data: Data) -> (message: String?, apiCode: String?) {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let error = json["error"] as? [String: Any] else {
            let msg = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["message"] as? String
            return (msg, nil)
        }
        let message = error["message"] as? String
        let code = error["code"] as? String
        return (message, code)
    }
}

//
//  APIClient.swift
//  BaseIOSApp
//
//  Network client using Alamofire for robust HTTP requests with interceptor support.
//

import Foundation
import Alamofire

/// Protocol defining the API client interface for making network requests
protocol APIClientProtocol {
    /// Performs an asynchronous network request and decodes the response
    /// - Parameters:
    ///   - endpoint: The endpoint configuration containing URL, method, headers, and body
    ///   - responseType: The type to decode the response into
    /// - Returns: Decoded response of type T
    /// - Throws: NetworkError if the request fails or response cannot be decoded
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T
}

/// Main API client implementation using Alamofire
final class APIClient: APIClientProtocol {
    private let session: Session
    private let interceptors: [Interceptor]
    private let decoder: ResponseDecoder
    private let baseURL: String
    
    /// Initializes the API client
    /// - Parameters:
    ///   - session: Alamofire session (default: .default)
    ///   - interceptors: Array of custom interceptors for request/response handling
    ///   - decoder: Response decoder for JSON parsing
    ///   - baseURL: Base URL for API requests (defaults to current environment)
    init(
        session: Session = .default,
        interceptors: [Interceptor],
        decoder: ResponseDecoder = ResponseDecoder(),
        baseURL: String? = nil
    ) {
        self.session = session
        self.interceptors = interceptors
        self.decoder = decoder
        self.baseURL = baseURL ?? AppEnvironment.current.baseURL
    }
    
    /// Performs an asynchronous network request
    /// - Parameters:
    ///   - endpoint: The endpoint configuration
    ///   - responseType: The expected response type
    /// - Returns: Decoded response
    /// - Throws: NetworkError on failure
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T {
        // Build initial request
        var request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        
        // Apply interceptors to adapt the request
        for interceptor in interceptors {
            request = try await interceptor.adapt(request)
        }
        
        // Check for mock response in mock environment (mock trả raw body, không envelope)
        if AppEnvironment.current == .mock,
           let url = request.url,
           let mock = MockServerManager.shared.mockResponse(for: url) {
            return try decoder.decode(T.self, from: mock.data)
        }
        
        // Perform request using Alamofire
        let dataTask = session.request(request)
            .validate(statusCode: 200..<300)
            .serializingData()
        
        do {
            let data = try await dataTask.value
            let response = await dataTask.response
            
            if let httpResponse = response.response {
                for interceptor in interceptors {
                    try await interceptor.handleResponse(httpResponse, data: data)
                }
            }
            
            // Backend format chuẩn: { success: true, data: T }
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
            Logger.shared.error("Alamofire request failed: \(afError)")
            throw mapAlamofireError(afError, data: await dataTask.response.data)
        } catch {
            Logger.shared.error("Network request failed: \(error)")
            throw NetworkError.unknown(error)
        }
    }
    
    // MARK: - Error Mapping
    
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

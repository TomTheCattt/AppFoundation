//
//  Interceptor.swift
//  AppFoundation
//

import Foundation

protocol Interceptor {
    func adapt(_ request: URLRequest) async throws -> URLRequest
    func handleResponse(_ response: URLResponse, data: Data) async throws
}

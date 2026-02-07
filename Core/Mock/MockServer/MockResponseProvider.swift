//
//  MockResponseProvider.swift
//  BaseIOSApp
//

import Foundation

protocol MockResponseProvider {
    func response(for request: URLRequest) -> MockServerManager.MockResponse?
}

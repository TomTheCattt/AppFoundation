//
//  EmptyResponse.swift
//  AppFoundation
//
//  Standard type for API responses with no data (e.g. 204 No Content or { data: null }).
//

import Foundation

public struct EmptyResponse: Decodable {
    public init() {}
}

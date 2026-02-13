//
//  Mappable.swift
//  BaseIOSApp
//

import Foundation

protocol Mappable {
    associatedtype Target
    func map() -> Target
}

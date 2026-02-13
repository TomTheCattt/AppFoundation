//
//  Mappable.swift
//  AppFoundation
//

import Foundation

protocol Mappable {
    associatedtype Target
    func map() -> Target
}

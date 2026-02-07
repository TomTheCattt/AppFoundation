//
//  FeatureCoordinatorProtocol.swift
//  BaseIOSApp
//

import UIKit

protocol FeatureCoordinatorProtocol: AnyObject {
    func showDetail(for item: FeatureEntity)
    func showCreateScreen()
    func showEdit(for item: FeatureEntity)
}

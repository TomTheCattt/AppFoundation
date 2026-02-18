//
//  Router.swift
//  AppFoundation
//
//  Router protocol for screen presentation (push, present, etc.).
//

import UIKit

protocol Router: AnyObject {
    var navigationController: UINavigationController { get }
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

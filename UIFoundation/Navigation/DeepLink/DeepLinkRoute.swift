//
//  DeepLinkRoute.swift
//  BaseIOSApp
//
//  Deep link route enum for URL parsing.
//

import Foundation

enum DeepLinkRoute {
    case home
    case profile
    case article(id: String)
    case settings
    case notification(id: String)

    var path: String {
        switch self {
        case .home:
            return "/home"
        case .profile:
            return "/profile"
        case .article(let id):
            return "/article/\(id)"
        case .settings:
            return "/settings"
        case .notification(let id):
            return "/notification/\(id)"
        }
    }
}

//
//  DeepLinkParser.swift
//  BaseIOSApp
//
//  Parses URLs into DeepLinkRoute (custom scheme + Universal Links).
//

import Foundation
import BaseIOSCore

protocol DeepLinkParserProtocol {
    func parse(_ url: URL) -> DeepLinkRoute?
}

final class DeepLinkParser: DeepLinkParserProtocol {

    private let logger: Logger
    private let customScheme = "baseiosapp"
    private let universalLinkHost = "app.baseiosapp.com"

    init(logger: Logger) {
        self.logger = logger
    }

    func parse(_ url: URL) -> DeepLinkRoute? {
        logger.debug("Parsing URL: \(url.absoluteString)")

        guard isValidURL(url) else {
            logger.info("Invalid URL scheme: \(url.scheme ?? "nil")")
            return nil
        }

        let pathComponents = extractPathComponents(from: url)
        guard !pathComponents.isEmpty else {
            return .home
        }

        return parseRoute(from: pathComponents, queryItems: url.queryItems)
    }

    private func isValidURL(_ url: URL) -> Bool {
        if url.scheme == customScheme {
            return true
        }
        if url.scheme == "https", url.host == universalLinkHost {
            return true
        }
        return false
    }

    private func extractPathComponents(from url: URL) -> [String] {
        var path = url.path
        if path.hasPrefix("/") {
            path = String(path.dropFirst())
        }
        return path.components(separatedBy: "/").filter { !$0.isEmpty }
    }

    private func parseRoute(from components: [String], queryItems: [URLQueryItem]?) -> DeepLinkRoute? {
        guard let first = components.first else {
            return .home
        }
        switch first.lowercased() {
        case "home":
            return .home
        case "profile":
            return .profile
        case "article":
            guard components.count > 1 else { return nil }
            return .article(id: components[1])
        case "settings":
            return .settings
        case "notification":
            guard components.count > 1 else { return nil }
            return .notification(id: components[1])
        default:
            logger.info("Unknown route: \(first)")
            return nil
        }
    }
}

// MARK: - URL Extension
extension URL {
    var queryItems: [URLQueryItem]? {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems
    }
}

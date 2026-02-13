//
//  UniversalLinkManager.swift
//  BaseIOSApp
//
//  Handles Universal Links and custom URL scheme opening.
//

import UIKit
import BaseIOSCore

final class UniversalLinkManager {

    private let deepLinkHandler: DeepLinkHandlerProtocol
    private let logger: Logger

    init(deepLinkHandler: DeepLinkHandlerProtocol, logger: Logger) {
        self.deepLinkHandler = deepLinkHandler
        self.logger = logger
    }

    func handleUniversalLink(_ userActivity: NSUserActivity) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else {
            return false
        }
        logger.info("Received universal link: \(url)")
        return deepLinkHandler.canHandle(url)
    }

    func handleCustomURLScheme(_ url: URL) -> Bool {
        logger.info("Received custom URL: \(url)")
        return deepLinkHandler.canHandle(url)
    }
}

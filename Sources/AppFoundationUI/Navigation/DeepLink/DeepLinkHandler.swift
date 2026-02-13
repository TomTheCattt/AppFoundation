//
//  DeepLinkHandler.swift
//  AppFoundation
//
//  Handles deep link parsing and capability check.
//

import Foundation
import AppFoundation

protocol DeepLinkHandlerProtocol {
    func parse(_ url: URL) -> DeepLinkRoute?
    func canHandle(_ url: URL) -> Bool
}

final class DeepLinkHandler: DeepLinkHandlerProtocol {

    private let parser: DeepLinkParserProtocol
    private let logger: Logger

    init(parser: DeepLinkParserProtocol, logger: Logger) {
        self.parser = parser
        self.logger = logger
    }

    func parse(_ url: URL) -> DeepLinkRoute? {
        parser.parse(url)
    }

    func canHandle(_ url: URL) -> Bool {
        parser.parse(url) != nil
    }
}

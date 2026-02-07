//
//  UIFoundationAssembly.swift
//  BaseIOSApp
//
//  Registers ThemeManager, DeepLink, and related UI services.
//

import Swinject

final class UIFoundationAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ThemeManager.self) { _ in
            ThemeManager.shared
        }
        .inObjectScope(.container)

        container.register(DeepLinkParserProtocol.self) { r in
            let logger = r.resolve(Logger.self)!
            return DeepLinkParser(logger: logger)
        }

        container.register(DeepLinkHandler.self) { r in
            let parser = r.resolve(DeepLinkParserProtocol.self)!
            let logger = r.resolve(Logger.self)!
            return DeepLinkHandler(parser: parser, logger: logger)
        }

        container.register(UniversalLinkManager.self) { r in
            let handler = r.resolve(DeepLinkHandler.self)!
            let logger = r.resolve(Logger.self)!
            return UniversalLinkManager(deepLinkHandler: handler, logger: logger)
        }
    }
}

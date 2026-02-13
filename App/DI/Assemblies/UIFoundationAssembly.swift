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

        container.register(DeepLinkParserProtocol.self) { register in
            let logger = register.resolve(Logger.self)!
            return DeepLinkParser(logger: logger)
        }

        container.register(DeepLinkHandler.self) { register in
            let parser = register.resolve(DeepLinkParserProtocol.self)!
            let logger = register.resolve(Logger.self)!
            return DeepLinkHandler(parser: parser, logger: logger)
        }

        container.register(UniversalLinkManager.self) { register in
            let handler = register.resolve(DeepLinkHandler.self)!
            let logger = register.resolve(Logger.self)!
            return UniversalLinkManager(deepLinkHandler: handler, logger: logger)
        }
    }
}

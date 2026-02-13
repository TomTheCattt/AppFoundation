//
//  NetworkAssembly.swift
//  BaseIOSApp
//

import Foundation
import Swinject

final class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ResponseDecoder.self) { _ in ResponseDecoder() }

        container.register(APIClient.self) { resolver in
            let logger = resolver.resolve(Logger.self)!
            let decoder = resolver.resolve(ResponseDecoder.self)!
            let tokenStore = resolver.resolve(TokenStoreProtocol.self)!
            let interceptors: [Interceptor] = [
                LoggingInterceptor(logger: logger),
                AuthInterceptor(tokenStore: tokenStore, logger: logger),
                RetryInterceptor()
            ]
            return APIClient(interceptors: interceptors, decoder: decoder)
        }

        container.register(APIClientProtocol.self) { register in
            register.resolve(APIClient.self)!
        }.inObjectScope(.container)

        container.register(NetworkMonitorProtocol.self) { _ in
            DefaultNetworkMonitor.shared
        }.inObjectScope(.container)
    }
}

//
//  BiometricManager.swift
//  AppFoundation
//
//  Created by AppFoundation Package.
//

import LocalAuthentication

public enum BiometricType {
    case none
    case touchID
    case faceID
    case unknown
}

public final class BiometricManager {
    public static let shared = BiometricManager()
    
    private let context = LAContext()
    
    public init() {}
    
    public func canEvaluatePolicy() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    public func biometricType() -> BiometricType {
        _ = canEvaluatePolicy()
        switch context.biometryType {
        case .none: return .none
        case .touchID: return .touchID
        case .faceID: return .faceID
        case .opticID: return .unknown
        @unknown default: return .unknown
        }
    }
    
    public func authenticate(reason: String, completion: @escaping (Bool, Error?) -> Void) {
        guard canEvaluatePolicy() else {
            completion(false, NSError(domain: "BiometricManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Biometrics not available"]))
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    // Async/Await version
    public func authenticate(reason: String) async throws -> Bool {
        return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
    }
}

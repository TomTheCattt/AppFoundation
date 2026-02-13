//
//  Result+Extensions.swift
//  BaseIOSApp
//
//  Result extensions for easier error handling.
//

import Foundation

extension Result {
    
    // MARK: - Basic Helpers
    
    /// Checks if the result is a success
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    /// Checks if the result is a failure
    var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the success value if available
    var value: Success? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
    
    /// Returns the error if available
    var error: Failure? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
    
    // MARK: - Advanced Helpers
    
    /// Flat maps the error to a different error type
    /// - Parameter transform: Error transformation closure
    /// - Returns: Result with transformed error
    func flatMapError<NewFailure: Error>(_ transform: (Failure) -> Result<Success, NewFailure>) -> Result<Success, NewFailure> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return transform(error)
        }
    }
    
    /// Maps the success value with a throwing function
    /// - Parameter transform: Transformation closure that can throw
    /// - Returns: Result with transformed value or error
    func tryMap<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
        switch self {
        case .success(let value):
            do {
                return .success(try transform(value))
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

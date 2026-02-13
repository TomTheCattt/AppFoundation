//
//  DiskStorage.swift
//  BaseIOSCore
//
//  Created by BaseIOSApp Package.
//

import Foundation

public final class DiskStorage: PersistenceProtocol {
    public static let shared = DiskStorage()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    public init(startDirectory: URL? = nil) {
        if let dir = startDirectory {
            self.cacheDirectory = dir
        } else {
            let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            self.cacheDirectory = paths[0].appendingPathComponent("BaseIOSAppCache")
        }
        createDirectory()
    }
    
    private func createDirectory() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    private func getFileURL(for key: String) -> URL {
        // Sanitize key to be a valid filename
        let safeKey = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        return cacheDirectory.appendingPathComponent(safeKey)
    }
    
    public func save(_ data: Data, for key: String) throws {
        let url = getFileURL(for: key)
        try data.write(to: url)
    }
    
    public func load(for key: String) throws -> Data? {
        let url = getFileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }
    
    public func delete(for key: String) throws {
        let url = getFileURL(for: key)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
    
    public func clear() throws {
        if fileManager.fileExists(atPath: cacheDirectory.path) {
            try fileManager.removeItem(at: cacheDirectory)
            createDirectory()
        }
    }
}

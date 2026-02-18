//
//  JSONStorage.swift
//  AppFoundation
//

import Foundation

/// Giải pháp lưu trữ dữ liệu đơn giản bằng file JSON trong thư mục Documents.
/// Phù hợp cho các ứng dụng nhỏ hoặc cache dữ liệu không quá lớn.
public class JSONStorage: StorageProtocol {
    
    private let directory: URL
    
    public init() {
        self.directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    public func save<T: Codable>(_ object: T, for key: String) throws {
        let url = directory.appendingPathComponent("\(key).json")
        let data = try JSONEncoder().encode(object)
        try data.write(to: url)
    }
    
    public func fetch<T: Codable>(for key: String) throws -> T? {
        let url = directory.appendingPathComponent("\(key).json")
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public func delete(for key: String) throws {
        let url = directory.appendingPathComponent("\(key).json")
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}

//
//  AppLogReporter.swift
//  {{PROJECT_NAME}}
//

import Foundation
import UIKit

/// Hỗ trợ thu thập và đóng gói Logs để báo cáo lỗi.
public class AppLogReporter {
    
    public static let shared = AppLogReporter()
    
    private init() {}
    
    /// Đóng gói tất cả file log trong thư mục Caches thành một file duy nhất để gửi đi.
    public func prepareLogReport() -> URL? {
        let fileManager = FileManager.default
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let logFiles = try? fileManager.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "log" }
        
        // Logic nén file (Zip) hoặc gộp file có thể thực hiện tại đây
        return logFiles?.first // Trả về file log mới nhất để demo
    }
    
    /// Mở giao diện chia sẻ log
    public func shareLogs(from viewController: UIViewController) {
        guard let logURL = prepareLogReport() else { return }
        let activityVC = UIActivityViewController(activityItems: [logURL], applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
}

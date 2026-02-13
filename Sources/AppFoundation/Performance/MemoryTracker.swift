//
//  MemoryTracker.swift
//  AppFoundation
//

import Foundation

final class MemoryTracker {
    func currentUsage() -> Float {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        guard result == KERN_SUCCESS else { return 0 }
        return Float(info.resident_size) / 1024 / 1024
    }

    func startTracking() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let usage = self?.currentUsage() else { return }
            Logger.shared.debug("Memory usage: \(usage)MB")
        }.fire()
    }
}

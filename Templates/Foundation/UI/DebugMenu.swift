//
//  DebugMenu.swift
//  {{PROJECT_NAME}}
//

import SwiftUI

/// Hệ thống Debug Menu ẩn (Kích hoạt bằng cử chỉ đặc biệt).
/// Cho phép thay đổi môi trường và xem logs trực tiếp.
public struct DebugMenu: View {
    @Environment(\.presentationMode) var presentationMode
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                Section(header: Text("Environment")) {
                    Button("Switch to Staging") {
                        // Change BaseURL logic
                    }
                    Button("Switch to Production") {
                        // Change BaseURL logic
                    }
                }
                
                Section(header: Text("Console Logs")) {
                    NavigationLink("View Network Logs", destination: Text("Log details here..."))
                }
                
                Section(header: Text("App Data")) {
                    Button("Clear Cache", role: .destructive) {
                        // Clear storage logic
                    }
                }
            }
            .navigationTitle("Developer Menu")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

//
//  StorageDemoViewModel.swift
//  AppFoundationExample
//
//  Created by AppFoundation Package.
//

import AppFoundation
import AppFoundationUI
import Foundation

class StorageDemoViewModel: BaseViewModel {
    @Published var status: String = "Idle"
    
    func saveToCoreData() {
        // CoreData demo logic
        // let entity = MyEntity(context: CoreDataStack.shared.context)
        // entity.name = "Test"
        // CoreDataStack.shared.saveContext()
        status = "✅ Saved to CoreData (Simulated)"
    }
    
    func testBiometrics() {
        Task {
            let success = try? await BiometricManager.shared.authenticate(reason: "Test Feature")
            DispatchQueue.main.async {
                self.status = success == true ? "✅ FaceID Success" : "❌ FaceID Failed"
            }
        }
    }
}

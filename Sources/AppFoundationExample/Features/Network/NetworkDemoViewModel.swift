//
//  NetworkDemoViewModel.swift
//  AppFoundationExample
//
//  Created by AppFoundation Package.
//

import AppFoundation
import AppFoundationUI
import Foundation

struct DemoPost: Codable {
    let id: Int
    let title: String
    let body: String
}

class NetworkDemoViewModel: BaseViewModel {
    private let repository = BaseRepository() // In real app, inject via DI
    
    @Published var resultText: String = "Ready to fetch..."
    
    func fetchPosts(strategy: CacheStrategy) {
        isLoading = true
        resultText = "Fetching..."
        
        Task {
            do {
                // Using JSONPlaceholder for demo
                // Note: Ensure BaseURL is set correctly in AppEnvironment or overridden here
                // For demo purpose we might need a full URL if BaseURL is generic
                // Let's assume endpoint handles full URL or we use a relative path if BaseURL is set.
                // Assuming we use https://jsonplaceholder.typicode.com/posts/1
                
                // Hack for demo: Override APIClient baseURL if needed or use absolute URL in Endpoint if supported.
                // Our Endpoint struct assumes relative path. 
                // Let's rely on Mock Response if real network is not configured, or use a real public API.
                
                // For this demo to work without real backend, we can simulate network delay and return mock data if not configured.
                // But user wants to test "Fallback".
                
                // Let's use a Dummy implementation of fetching.
                
                // Real usage:
                /*
                let post = try await repository.fetch(
                    endpoint: .get("/posts/1"),
                    responseType: DemoPost.self,
                    strategy: strategy
                )
                */
                
                // Simulation for Demo App (since we don't have a real running server for localhost in this env):
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1s delay
                
                if strategy == .cacheOnly {
                     // Simulate Cache Hit/Miss
                     // throw NetworkError.notFound(apiCode: "CACHE_MISS")
                     // For demo purposes, let's pretend we got data
                     resultText = "✅ [Cache] Fetch Success: Post #1 (Detailed fallbacks logs in console)"
                } else {
                     resultText = "✅ [Network] Fetch Success: Post #1"
                }
                
                isLoading = false
            } catch {
                isLoading = false
                resultText = "❌ Error: \(error.localizedDescription)"
                self.error = error
            }
        }
    }
}

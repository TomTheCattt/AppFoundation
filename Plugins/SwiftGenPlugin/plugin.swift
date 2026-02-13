import PackagePlugin
import Foundation

@main
struct SwiftGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let swiftgenConfigPath = context.package.directory.appending(subpath: "Sources/AppFoundationResources/Generated/SwiftGen/swiftgen.yml")
        
        guard FileManager.default.fileExists(atPath: swiftgenConfigPath.string) else {
            Diagnostics.warning("SwiftGen config not found at \(swiftgenConfigPath.string), skipping code generation")
            return []
        }
        
        let outputPath = context.pluginWorkDirectory.appending(subpath: "GeneratedAssets.swift")
        
        return [
            .buildCommand(
                displayName: "Running SwiftGen for \(target.name)",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    "config",
                    "run",
                    "--config",
                    swiftgenConfigPath.string
                ],
                environment: [:],
                outputFiles: [outputPath]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftGenPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let swiftgenConfigPath = context.xcodeProject.directory.appending(subpath: "Sources/AppFoundationResources/Generated/SwiftGen/swiftgen.yml")
        
        guard FileManager.default.fileExists(atPath: swiftgenConfigPath.string) else {
            Diagnostics.warning("SwiftGen config not found, skipping code generation")
            return []
        }
        
        let outputPath = context.pluginWorkDirectory.appending(subpath: "GeneratedAssets.swift")
        
        return [
            .buildCommand(
                displayName: "Running SwiftGen for \(target.displayName)",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    "config",
                    "run",
                    "--config",
                    swiftgenConfigPath.string
                ],
                environment: [:],
                outputFiles: [outputPath]
            )
        ]
    }
}
#endif

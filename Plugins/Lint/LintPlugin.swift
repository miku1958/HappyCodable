import Foundation
import PackagePlugin

@main
struct LintPlugin: CommonBuildToolPlugin {
    func createBuildCommands(context: CommonPluginContext, targetDirectory: Path, inputFiles: [Path], name: String, runEverytime: Bool) throws -> [Command] {

        return [
            .buildCommand(
                displayName: "Running SwiftLint for \(name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--config",
                    configPath(directory: targetDirectory, fileName: "swiftlint.yaml", localFileName: ".swiftlint.yml"),
                    "--cache-path",
                    "\(context.pluginWorkDirectory.string)/SwiftLintCache",
                ] + inputFiles.map(\.string),
                inputFiles: runEverytime ? [] : inputFiles,
                outputFiles: []
            )
        ]
    }

    /// directory is a relative path
    private func configPath(directory: Path, fileName: String, localFileName: String) -> String {
        do {
            let configPath = directory.appending(localFileName).string

            if FileManager.default.fileExists(atPath: configPath) {
                return configPath
            }
        }

        // Swift Package Plugin doesn't support resource files.
        // To work around this, we directly find the config file.

        var url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

        var testingPath: String {
            url.appendingPathComponent("HappyCodable/Plugins/Lint//\(fileName)").standardizedFileURL.path
        }
        while !url.pathComponents.isEmpty, !FileManager.default.fileExists(atPath: testingPath) {
            url.deleteLastPathComponent()
        }

        return testingPath
    }
}

import PackagePlugin

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension XcodePluginContext: CommonPluginContext {}

typealias CombinedBuildToolPlugin = BuildToolPlugin & XcodeBuildToolPlugin

extension CommonBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        try createBuildCommands(
            context: context,
            targetDirectory: context.xcodeProject.directory,
            inputFiles: target.inputFiles
                .filter { $0.type == .source }
                .map(\.path),
            name: target.displayName,
            // Use empty array as input files for Xcode target since Xcode has a weird bug for App targets.
            // Xcode 14 beta 6 would complain entry point _main undefined when linking if input files are provided.
            // Try to set input files for new Xcode versions.
            runEverytime: true
        )
    }
}
#else
typealias CombinedBuildToolPlugin = BuildToolPlugin
#endif

protocol CommonPluginContext {
    var pluginWorkDirectory: Path { get }
    func tool(named name: String) throws -> PluginContext.Tool
}

extension PluginContext: CommonPluginContext {}

protocol CommonBuildToolPlugin: CombinedBuildToolPlugin {
    func createBuildCommands(context: CommonPluginContext, targetDirectory: Path, inputFiles: [Path], name: String, runEverytime: Bool) throws -> [Command]
}

extension CommonBuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        try createBuildCommands(
            context: context,
            targetDirectory: target.directory,
            inputFiles: (target as! SourceModuleTarget).sourceFiles
                .filter { $0.type == .source }
                .map(\.path),
            name: target.name,
            runEverytime: false
        )
    }
}

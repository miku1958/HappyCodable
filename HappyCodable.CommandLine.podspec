Pod::Spec.new do |spec|

	spec.name                  = "HappyCodable.CommandLine"
	spec.version               = "1.0.5"
	spec.summary               = "快乐使用Codable"
	spec.homepage              = "https://github.com/miku1958/HappyCodable"
	spec.license               = "Mozilla"
	spec.author                = { "mikun" => "v.v1958@qq.com" }
	
	spec.source                = {
		:git => "https://github.com/miku1958/HappyCodable.git", 
		:tag => spec.version
	}

	spec.requires_arc          = true
	spec.swift_version         = "5.0"
	spec.osx.deployment_target = "10.10"

	spec.source_files = "Source/CommandLine/**/*.*"
	
	spec.dependency 'SourceKittenFramework'
	spec.dependency 'CryptoSwift'
end
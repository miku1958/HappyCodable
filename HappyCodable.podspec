Pod::Spec.new do |spec|

	spec.name                  = "HappyCodable"
	spec.version               = "2.0"
	spec.summary               = "快乐使用Codable"
	spec.homepage              = "https://github.com/miku1958/HappyCodable"
	spec.license               = "Mozilla"
	spec.author                = { "mikun" => "v.v1958@qq.com" }

	spec.source                = {
		:git => "https://github.com/miku1958/HappyCodable.git", 
		:tag => spec.version
	}
	spec.source_files          = "Source/Common/**/*.swift"

	spec.requires_arc          = true
	spec.swift_version         = "5.1"

	spec.ios.deployment_target = '8.0'
	spec.osx.deployment_target = "10.10"
	# spec.watchos.deployment_target = "2.0"
	# spec.tvos.deployment_target = "9.0"
end
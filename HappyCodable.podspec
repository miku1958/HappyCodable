Pod::Spec.new do |spec|

	spec.name                  = "HappyCodable"
	spec.version               = "1.0.4"
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

	spec.default_subspec       = 'Common'
	
	spec.subspec 'Common' do |spec|
		spec.ios.deployment_target = "10.0"
		spec.osx.deployment_target = "10.14"
		# spec.watchos.deployment_target = "2.0"
		# spec.tvos.deployment_target = "9.0"

		spec.source_files = "Source/Common/**/*.*"
	end
	
	spec.subspec 'CommandLine' do |spec|
		spec.platform = :macos, '10.14'
		
		spec.source_files = "Source/CommandLine/**/*.*"
		
		spec.dependency 'SourceKittenFramework'
		spec.dependency 'CryptoSwift'
	end
end
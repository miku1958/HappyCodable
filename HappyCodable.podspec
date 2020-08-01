Pod::Spec.new do |spec|

	spec.name                  = "HappyCodable"
	spec.version               = "1.0.0"
	spec.summary               = "快乐使用Codable"
	spec.homepage              = "https://github.com/miku1958/HappyCodable"
	spec.license               = "Mozilla"
	spec.author                = { "mikun" => "v.v1958@qq.com" }
	
	spec.source                = {
		:http => "https://github.com/miku1958/HappyCodable/releases/download/#{spec.version}/HappyCodableCommandLine.zip" ,
		:sha1 => '0b2dc60a9187e0da95b9cef580e4d2e772522aef' 
	}

	spec.requires_arc          = true
	spec.swift_version         = "5.0"

	spec.ios.deployment_target = '8.0'
	spec.osx.deployment_target = "10.10"
	# spec.watchos.deployment_target = "2.0"
	# spec.tvos.deployment_target = "9.0"

	spec.dependency "HappyCodable.Common", "#{spec.version}"
	spec.preserve_paths        = "HappyCodableCommandLine"

end
Pod::Spec.new do |spec|

	spec.name                  = "HappyCodable.CommandLine"
	spec.version               = "1.0.7"
	spec.summary               = "快乐使用Codable"
	spec.homepage              = "https://github.com/miku1958/HappyCodable"
	spec.license               = "Mozilla"
	spec.author                = { "mikun" => "v.v1958@qq.com" }
	
	spec.source                = {
		:http => "https://github.com/miku1958/HappyCodable/releases/download/#{spec.version}/HappyCodable.framework.zip" ,
		:sha1 => 'bb589ea05b3b075279830dfc34a2242fd2b810bc' 
	}

	spec.requires_arc          = true
	spec.swift_version         = "5.0"

	spec.ios.deployment_target = '8.0'
	spec.osx.deployment_target = "10.10"
	# spec.watchos.deployment_target = "2.0"
	# spec.tvos.deployment_target = "9.0"

	spec.preserve_paths        = "HappyCodable.framework"

end
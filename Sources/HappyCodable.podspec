Pod::Spec.new do |spec|

  spec.name = "HappyCodable"
  spec.version = "0.0.1"
  spec.summary = "快乐使用Codable"
  spec.homepage = "http://apple.com"
  spec.license = { :"type" => "Copyright", :"text" => " Copyright 2020 mikun \n"} 
  spec.author = { "mikun" => "v.v1958@qq.com" }
  spec.source = { :git => './', :tag => "0.0.1" }

	spec.swift_version = '5.0'
	
	spec.ios.deployment_target = "9.0"
	spec.osx.deployment_target = "10.14"
	spec.watchos.deployment_target = "2.0"
	spec.tvos.deployment_target = "9.0"
	spec.source_files = "HappyCodable/*/*.swift"
end
Pod::Spec.new do |s|
  s.name             = 'VikycSDK'
  s.version          = '0.0.1'
  s.summary          = 'Ứng dụng đọc thông tin trong CCCD.'

  s.description      = <<-DESC
  Ứng dụng đọc thông tin trong CCCD.
                       DESC

  s.homepage         = 'https://github.com/VSFramework/vikyc-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Thanhdv2007' => 'thanhdv200796@gmail.com' }
  s.source           = { :git => 'https://github.com/VSFramework/vikyc-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

   s.frameworks = 'UIKit', 'SwiftUI'
   s.dependency "OpenSSL-Universal"
   
   s.vendored_frameworks = 'Frameworks/VikycSDK.xcframework'

s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

Pod::Spec.new do |s|
  s.name             = 'VikycSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of VikycSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/VSFramework/vikyc-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Thanhdv2007' => 'thanhdv200796@gmail.com' }
  s.source           = { :git => 'https://github.com/VSFramework/vikyc-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

   s.frameworks = 'UIKit', 'SwiftUI'
   s.dependency "OpenSSL-Universal"
   
   s.vendored_frameworks = 'Frameworks/VikycSDK.xcframework'

s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

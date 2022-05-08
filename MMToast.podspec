#
# Be sure to run `pod lib lint MMToast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MMToast'
  s.version          = '0.1.0'
  s.summary          = '一款超级简单的swift的toast库'
  s.homepage         = 'https://github.com/lxm1799/MMToast'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luckyBoy' => 'goodlucky1130@163.com' }
  s.source           = { :git => 'https://github.com/lxm1799/MMToast.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'
  s.source_files = 'MMToast/Classes/**/*'
  s.resource_bundles = {
     'MMToast' => ['MMToast/Assets/*.png']
  }
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
#  s.dependency 'SnapKit'
  
end

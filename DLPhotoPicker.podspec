#
# Be sure to run `pod lib lint DLPhotoPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DLPhotoPicker'
  s.version          = '0.1.0'
  s.summary          = 'An Photo Picker for iOS'

  s.homepage         = 'https://github.com/luosch/DLPhotoPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luosch' => 'me@lsich.com' }
  s.source           = { :git => 'https://github.com/luosch/DLPhotoPicker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'DLPhotoPicker/Classes/**/*'
  
  s.resource_bundles = {
    'DLPhotoPicker' => ['DLPhotoPicker/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SnapKit', '~> 4.0.0'
end

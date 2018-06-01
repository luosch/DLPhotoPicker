Pod::Spec.new do |s|
  s.name             = 'DLPhotoPicker'
  s.version          = '0.1.0'
  s.summary          = 'An Photo Picker for iOS'

  s.homepage         = 'https://github.com/luosch/DLPhotoPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luosch' => 'me@lsich.com' }
  s.source           = { :git => 'https://github.com/luosch/DLPhotoPicker.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.1'

  s.source_files = 'DLPhotoPicker/Classes/**/*'

  s.resources = 'DLPhotoPicker/Assets/**/*'
  s.frameworks = 'UIKit', 'Photos'
  s.dependency 'NVActivityIndicatorView', '~> 4.2.1'
end

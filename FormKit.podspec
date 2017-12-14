#
# Be sure to run `pod lib lint FormKit.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'FormKit'
  s.version          = '0.1.0'
  s.summary          = 'A pure Swift library for making and handling forms.'
  s.description      = <<-DESC
FormKit is my attempt at a pure-Swift library to handling forms. After ten years of developing on iOS, I still haven't found a universal way of setting up and handling forms, so here's my current universal-ish solution.
                       DESC

  s.homepage         = 'https://github.com/cyrille-legrand/FormKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'GPLv3', :file => 'LICENSE' }
  s.author           = { 'Cyrille Legrand' => 'c.legrand@useradgents.com' }
  s.source           = { :git => 'https://github.com/cyrille-legrand/FormKit', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cyrillusmaximus'

  s.ios.deployment_target = '9.0'
  s.frameworks = 'UIKit'

  s.source_files = 'FormKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FormKit' => ['FormKit/Assets/*.png']
  # }

end

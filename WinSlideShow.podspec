#
# Be sure to run `pod lib lint WinSlidShow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WinSlideShow'
  s.version          = '0.1.6'
  s.summary          = 'Image slideshow written in Swift with circular scrolling'

s.description      = <<-DESC
Image slideshow is a Swift library providing customizable image slideshow with circular scrolling.
DESC

  s.homepage         = 'https://github.com/Winfooz/WinSlideShow.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ahmad Almasri' => 'aalmasri@winfooz.com' }
  s.source           = { :git => 'https://github.com/Winfooz/WinSlideShow.git', :tag => s.version.to_s }

  s.swift_versions = ['4.0', '4.1', '4.2', '5']
  s.ios.deployment_target = '11.0'

  s.source_files = 'WinSlidShow/Classes/**/*'
  s.dependency 'SDWebImage', '~> 3.8.2'

end

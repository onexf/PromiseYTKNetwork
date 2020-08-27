#
# Be sure to run `pod lib lint PromiseYTKNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PromiseYTKNetwork'
  s.version          = '0.1.5'
  s.summary          = 'YTKNetwork结合PromiseKit，添加链式调用方法'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '在YTKNetwork的基础上，使用异步框架PromiseKit增加链式调用方法，更优雅的进行多请求调用'

  s.homepage         = 'https://github.com/onexf/PromiseYTKNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'onexf' => '630850673@qq.com' }
  s.source           = { :git => 'https://github.com/onexf/PromiseYTKNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'PromiseYTKNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PromiseYTKNetwork' => ['PromiseYTKNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'PromiseKit'
   s.dependency 'YTKNetwork'

end

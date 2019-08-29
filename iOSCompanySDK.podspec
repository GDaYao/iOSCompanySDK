#
# Be sure to run `pod lib lint iOSCompanySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOSCompanySDK'
  s.version          = '1.0.0'
  s.summary          = 'iOSCompanySDK in use company all project from GDYSDK --- iOSCompanySDK是用于添加公共各个项目的方法'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 用于公司的各个项目添加公共方法使用；每个项目都会建立一个文件夹用于区分项目.--iOSCompanySDK in use company all project from GDYSDK --- iOSCompanySDK是用于添加公共各个项目的方法.
                       DESC

  s.homepage         = 'https://github.com/GDaYao/iOSCompanySDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dayao' => 'jaeda1418154979@gmail.com' }
  s.source           = { :git => 'https://github.com/GDaYao/iOSCompanySDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

#  s.source_files = 'iOSCompanySDK/Classes/**/*'

  # s.resource_bundles = {
  #   'iOSCompanySDK' => ['iOSCompanySDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.frameworks = 'UIKit'
  
  
  
  s.subspec 'NewWallpapersFull' do |newwallpapersfull|
    newwallpapersfull.libraries = 'sqlite3'
    newwallpapersfull.source_files = 'iOSCompanySDK/Classes/NewWallpapersFull/**/*'
    newwallpapersfull.public_header_files = 'iOSCompanySDK/Classes/NewWallpapersFull/**/*.h'
    newwallpapersfull.dependency 'AFNetworking' # ,'3.2.1'
    #newwallpapersfull.dependency 'MBProgressHUD'
    #newwallpapersfull.resource_bundles = {
    #}
#    newwallpapersfull.frameworks = 'CoreTelephony'
    newwallpapersfull.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => '$(inherited)', "LIBRARY_SEARCH_PATHS" => '$(inherited)', "HEADER_SEARCH_PATHS" => '$(inherited)', "OTHER_CFLAGS" => '$(inherited)', "OTHER_LDFLAGS" => '$(inherited)', "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited)' }
    
  end
  
  
  s.subspec 'CreativeWallpapers' do |creativewallpapers|
    creativewallpapers.libraries = 'sqlite3'
    creativewallpapers.source_files = 'iOSCompanySDK/Classes/CreativeWallpapers/**/*'
    creativewallpapers.public_header_files = 'iOSCompanySDK/Classes/CreativeWallpapers/**/*.h'
    creativewallpapers.dependency 'AFNetworking' # ,'3.2.1'
    #creativewallpapers.dependency 'MBProgressHUD'
    #creativewallpapers.resource_bundles = {
    #    creativewallpapers.frameworks = 'CoreTelephony'
    creativewallpapers.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => '$(inherited)', "LIBRARY_SEARCH_PATHS" => '$(inherited)', "HEADER_SEARCH_PATHS" => '$(inherited)', "OTHER_CFLAGS" => '$(inherited)', "OTHER_LDFLAGS" => '$(inherited)', "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited)' }
    end
  
  
  
  
end
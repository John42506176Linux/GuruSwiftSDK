#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint guru_sdk.podspec` to validate before publishing.
#

source = 'https://github.com/John42506176Linux/GuruSwiftSDK.git'

Pod::Spec.new do |s|
    s.name             = 'GuruSwiftSDK'
    s.version          = '0.0.3'
    s.summary          = 'Swift SDK for Guru API'
    s.description      = <<-DESC
  A cocoapods version of the swift package
                         DESC
    s.homepage         = 'https://github.com/John42506176Linux/GuruSwiftSDK.git'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Pharos' => 'developer@pharosfit.com' }
    s.source = {
        :git => 'https://github.com/John42506176Linux/GuruSwiftSDK.git',
        :tag => s.version.to_s
    }
    s.source_files = 'Sources/GuruSwiftSDK/**/*'
    s.dependency "ZIPFoundation", "~> 0.9.15"
    s.dependency "libgurucv", "~> 0.0.1"
    s.ios.deployment_target = '15.0'  
    # Flutter.framework does not contain a i386 slice.
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.swift_version = '5.0'
  end
  

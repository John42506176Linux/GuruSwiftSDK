#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint guru_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
    s.name             = 'libgurucv'
    s.version          = '0.0.1'
    s.summary          = 'Swift SDK for libgurucv'
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
    s.source = {
      :http => "https://formguru-datasets.s3.us-west-2.amazonaws.com/opencv2_ios_builds/opencv2.xcframework-b0dc474160e389b9c9045da5db49d03ae17c6a6b.zip"
    }
    # s.prepare_command = <<-CMD
    #   curl -L  -o "myproject.zip"
    #   unzip myproject.zip
    #   rm myproject.zip
    # CMD
    s.source_files = 'Sources/libgurucv/**/*'
    s.vendored_frameworks = "opencv2.xcframework"
    s.ios.deployment_target = '15.0'  
    # Flutter.framework does not contain a i386 slice.
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.swift_version = '5.0'
  end
  
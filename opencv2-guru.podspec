Pod::Spec.new do |s|
    s.name = 'opencv2-guru'
    s.version = '1.0.0'
    s.source = {
        :http => 'https://formguru-datasets.s3.us-west-2.amazonaws.com/opencv2_ios_builds/opencv2.xcframework-b0dc474160e389b9c9045da5db49d03ae17c6a6b.zip'
    }    
    s.authors = 'OpenCV2'
    s.homepage = 'https://github.com/John42506176Linux/GuruSwiftSDK.git'
    s.license = 'MIT'
    s.summary = 'OpenCV2 Pod for XC framework'
    s.description = 'OpenCV2 Pod for XC framework from AWS Guru'
    s.source_files = 'opencv2.xcframework/**/*.{h,m,swift}'
    s.ios.deployment_target = '15.0'  
    # Flutter.framework does not contain a i386 slice.
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
    s.swift_version = '5.0'
  end
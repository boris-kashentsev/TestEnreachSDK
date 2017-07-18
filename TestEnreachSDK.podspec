Pod::Spec.new do |spec|
  spec.name = 'TestEnreachSDK'
  spec.version = '1.0.9'
  spec.summary = 'Testing CocoaPod frame working for the future SDK'
  spec.homepage = 'https://github.com/boris-kashentsev/TestEnreachSDK'
  spec.license = {:type => 'MIT', :file => 'MIT-LICENSE.txt'}
  spec.authors = {'Boris Kashentsev' => 'boris.kashentsev@conmio.com'}
  
  spec.platform = :ios
  spec.requires_arc = true
  spec.source = {:git => 'https://github.com/boris-kashentsev/TestEnreachSDK.git', :tag => 'v1.0.9', :submodules => false}
  spec.source_files = 'EnreachPOC/EnreachSDK/*.{h, m}'
  spec.public_header_files = 'EnreachPOC/EnreachSDK/*.h'
end
Pod::Spec.new do |s|
  s.name             = 'RequestSentinel-swift'
  s.version          = '0.1.0'
  s.summary          = 'Swift library for RequestSentinel.'

  s.description      = <<-DESC
Library for interacting with the RequestSentinel API from Swift.
                       DESC

  s.homepage         = 'https://github.com/RequestSentinel/request-sentinel-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Umar Nizamani' => 'support@requestsentinel.com' }
  s.source           = { :git => 'git@github.com:RequestSentinel/request-sentinel-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'Sources/**/*'
  
end

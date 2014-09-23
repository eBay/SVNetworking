Pod::Spec.new do |s|
  s.name         = "SVNetworking"
  s.version      = "0.4"
  s.summary      = "Remote resource loading and networking"
  s.description  = <<-DESC
                   SVNetworking is a library for networking and resource loading
                   in iOS applications. It is primarily designed for use with
                   key-value observing.
                   DESC
  s.homepage     = "http://github.com/eBay/SVNetworking"
  s.license      = { :type => "BSD", :file => "LICENSE" }
  s.author             = { "Nate Stedman" => "nate@natestedman.com" }
  s.social_media_url   = "http://twitter.com/natestedman"
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.source       = { :git => "https://github.com/eBay/SVNetworking.git", :tag => "0.4" }
  s.source_files  = "SVNetworking/SVNetworking"
  s.ios.frameworks = "UIKit"
  s.requires_arc = true
end

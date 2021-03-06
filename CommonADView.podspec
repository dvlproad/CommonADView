Pod::Spec.new do |s|
  s.name         = "CommonADView"
  s.version      = "0.0.1"
  s.summary      = "A View which used to show ad."
  s.homepage     = "https://github.com/dvlproad/CommonADView"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "913168921@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dvlproad/CommonADView.git", :tag => "0.0.1" }
  s.source_files  = "CommonADView/**/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  s.dependency 'SDWebImage', '~> 3.7.2'

end

Pod::Spec.new do |s|
  s.name         = "Rooster"
  s.version      = "0.1.3"
  s.summary      = "Image Loading and Caching Framework"
  s.description  = "Rooster blazing fast framework for downloading and caching images from the web"
  s.homepage     = "https://github.com/xrisyz/Rooster.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Christopher Karani" => "chrisbkarani@gmail.com" }
  s.social_media_url   = "https://twitter.com/cbkarani"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/xrisyz/Rooster.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"

  s.swift_version = '4.0'
end

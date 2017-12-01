#
# Be sure to run `pod lib lint OTOnexus.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OTOnexus'
  s.version          = '1.0.0'
  s.summary          = 'A Barcode Scanning SDK by 121nexus.com'
  s.source           = { :git => 'https://github.com/121nexus/OTOnexus' }

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                   OTOnexus is a Barcode Scanning SDK for capturing, looking up, presenting data associated with barcodes. The SDK is supported by the 121nexus Platform which allows clients to add products to the system to enable interactive experiences when end-users scan the physical product.
                   DESC

  s.homepage         = 'https://github.com/121nexus/OTOnexus'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Chris DeOrio" => "chris@121nexus.com" }
  # Or just: s.author    = "Chris DeOrio"
  # s.authors            = { "Chris DeOrio" => "chris@121nexus.com" }
  # s.social_media_url   = "http://twitter.com/Chris DeOrio"

  s.ios.deployment_target = '9.0'

  s.source_files = 'OTOnexus/Classes/**/*.{swift,h}'
  s.resource_bundles = {
      'OTOnexus' => ['OTOnexus/**/*.xib', 'OTOnexus/**/*.xcassets']
  }
  
  # s.resource_bundles = {
  #   'OTOnexus' => ['OTOnexus/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AVFoundation', 'CoreGraphics'
  s.dependency 'AWSS3'
end

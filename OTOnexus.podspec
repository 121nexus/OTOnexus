Pod::Spec.new do |s|
  s.name             = 'OTOnexus'
  s.version          = '1.1.0'
  s.summary          = 'A Barcode Scanning SDK by 121nexus.com'
  s.source           = { :git => 'https://github.com/121nexus/OTOnexus' }
  s.description      = <<-DESC
                   OTOnexus is a Barcode Scanning SDK for capturing, looking up, presenting data associated with barcodes. The SDK is supported by the 121nexus Platform which allows clients to add products to the system to enable interactive experiences when end-users scan the physical product.
                   DESC
  s.homepage         = 'https://github.com/121nexus/OTOnexus'
  s.author           = { "Chris DeOrio" => "chris@121nexus.com" }
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'
  s.source_files = 'OTOnexus/Classes/**/*.{swift,h}'
  s.resource_bundles = {
    'OTOnexus' => ['OTOnexus/**/*.xib', 'OTOnexus/**/*.xcassets']
  }
  s.frameworks = 'UIKit', 'AVFoundation', 'CoreGraphics'
  s.dependency 'AWSS3'
end

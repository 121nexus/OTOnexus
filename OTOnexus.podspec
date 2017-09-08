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
  s.summary          = 'A short description of OTOnexus.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                    Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description
                   DESC

  s.homepage         = 'https://github.com/121nexus/OTOnexus'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Chris DeOrio" => "chris@121nexus.com" }
  # Or just: s.author    = "Chris DeOrio"
  # s.authors            = { "Chris DeOrio" => "chris@121nexus.com" }
  # s.social_media_url   = "http://twitter.com/Chris DeOrio"

  s.ios.deployment_target = '8.0'

  s.source_files = 'OTOnexus/Classes/**/*'
  s.resource_bundles = {
      'OTOnexus' => ['OTOnexus/**/*.xib']
  }
  
  # s.resource_bundles = {
  #   'OTOnexus' => ['OTOnexus/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

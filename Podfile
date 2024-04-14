# Dependencies for the SaintsXCTF iOS application.
# Author: Andrew Jarombek
# Date: 1/29/2019

platform :ios, '15.0'
use_frameworks!

# The main iOS application
target 'SaintsXCTF' do
  pod 'ObjectMapper', '~> 3.5.1'
  pod 'PopupDialog', '~> 1.1.0'
  pod 'DGCharts', '~> 5.1.0'
  pod 'IQKeyboardManagerSwift', '~> 6.4.2'
end

# Unit tests for the iOS application
target 'SaintsXCTFTests' do
  pod 'ObjectMapper', '~> 3.5.1'
end

# UI tests for the iOS application
target 'SaintsXCTFUITests' do
  pod 'Swifter', '~> 1.5.0'
  pod 'OHHTTPStubs/Swift', '~> 9.1.0'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
        end
    end
end

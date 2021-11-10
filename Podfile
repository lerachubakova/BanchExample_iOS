# Uncomment the next line to define a global platform for your project
  platform :ios, '13.4'

# Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

abstract_target 'default_pods' do

  # Pods for BanchExample
  pod 'GoogleMaps','5.2.0'
  pod 'lottie-ios','3.2.3'
  pod 'SnapKit','5.0.1'
  pod 'SwiftLint','0.43.1'
  pod 'SwiftSoup','2.3.3'

  target 'BanchExample'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
    end
end

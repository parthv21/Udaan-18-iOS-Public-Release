# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Udaan-App' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Udaan-App
  pod 'Firebase/Core' 
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'
  pod 'Firebase/AdMob'
  pod 'GoogleSignIn'
  pod 'SwiftyJSON'
  pod 'iCarousel'
  pod 'Firebase/Messaging'
  pod 'MessageKit'
  
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            if target.name == 'MessageKit'
                target.build_configurations.each do |config|
                    config.build_settings['SWIFT_VERSION'] = '4.0'
                end
            end
        end
    end 
end

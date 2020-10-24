# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Hinario' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'GoogleSignIn'
  pod 'SVProgressHUD'
	#pod 'Kingfisher'
  pod 'Firebase/AdMob'
  pod 'InAppPurchaseButton'
	pod 'CryptoKit'
  
  
  pod 'BGTableViewRowActionWithImage'
  
  pod 'FBSDKLoginKit'
  pod 'Bolts'
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'
  pod 'ReachabilitySwift'
  pod 'SwiftyStoreKit'
  pod 'AppCenter'
  pod 'OneSignal', '>= 2.11.2', '< 3.0'
  
  pod 'SnapKit'
  
  # For pod OneSignal target
  target 'OneSignalNotificationServiceExtension' do
    #only copy below line
    pod 'OneSignal', '>= 2.11.2', '< 3.0'
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
      end
    end
  end

end

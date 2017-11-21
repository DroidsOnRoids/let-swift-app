platform :ios, '10.0'

target 'LetSwift' do
  use_frameworks!

  # Ignore cocoapods warnings
  inhibit_all_warnings!

  # Acknowledgements
  post_install do | installer |
      require 'fileutils'
      FileUtils.cp_r('Pods/Target Support Files/Pods-LetSwift/Pods-LetSwift-acknowledgements.plist', 'LetSwift/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
  end

  # Host utils
  pod 'SwiftLint', '~> 0.20'

  # Testing
  pod 'SimulatorStatusMagic', '~> 1.9', :configurations => ['Debug']
  pod 'HockeySDK', '~> 4.1', :configurations => ['Debug', 'Release']
  pod 'Fabric', '~> 1.6'
  pod 'Crashlytics', '~> 3.8'

  # Facebook SDK
  pod 'FBSDKCoreKit', '~> 4.22'
  pod 'FBSDKLoginKit', '~> 4.22'

  # Networking
  pod 'Alamofire', '~> 4.4'
  pod 'AlamofireNetworkActivityIndicator', '~> 2.2'
  pod 'ModelMapper', '~> 6.0'

  # Views
  pod 'ImageEffects', '~> 1.0'
  pod 'SDWebImage', '~> 4.0'
  pod 'DACircularProgress', '~> 2.3'
end

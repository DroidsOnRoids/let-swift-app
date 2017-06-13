# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  use_frameworks!

  #ignore cocoapods warnings
  inhibit_all_warnings!

  # Views
  pod 'MWPhotoBrowser', :git => 'https://github.com/m-chojnacki/MWPhotoBrowser.git', :branch => 'fork'
end

target 'LetSwift' do
  shared_pods

  # Testing
  pod 'HockeySDK', '~> 4.1'

  # Facebook SDK
  pod 'FBSDKCoreKit', '~> 4.22'
  pod 'FBSDKLoginKit', '~> 4.22'

  # Networking
  pod 'Alamofire', '~> 4.4'
  pod 'ModelMapper', '~> 6.0'

  # Views
  pod 'ImageEffects', '~> 1.0'
  pod 'ESPullToRefresh', '~> 2.6'
  pod 'MWPhotoBrowser', :git => 'https://github.com/m-chojnacki/MWPhotoBrowser.git', :branch => 'fork'
end

target 'LetSwiftTests' do
  shared_pods
end

# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'hey m8' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'GoogleSignIn'
pod 'Firebase/Auth' 
pod 'FirebaseUI'  #For prebuilt UI, doens't include UI for anonymous login
# pod 'FSCalendar'
pod 'Firebase/Firestore'
pod 'FirebaseFirestoreSwift'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
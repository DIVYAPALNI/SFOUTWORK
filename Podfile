# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

project 'SampleSalesForce.xcodeproj'
target 'SampleSalesForce' do

source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

pod 'SalesforceAnalytics', :path => 'node_modules/SalesforceMobileSDK-iOS'
pod 'SalesforceSDKCore', :path => 'node_modules/SalesforceMobileSDK-iOS'
pod 'SmartStore', :path => 'node_modules/SalesforceMobileSDK-iOS'
pod 'SmartSync', :path => 'node_modules/SalesforceMobileSDK-iOS'
pod 'CocoaLumberjack'
pod 'FMDB'
pod 'SVProgressHUD', '~> 1.1.3'
pod 'FMDB/SQLCipher'

end
post_install do | installer |
    print "SQLCipher: link Pods/Headers/sqlite3.h"
    system "mkdir -p Pods/Headers/Private && ln -s ../../SQLCipher/sqlite3.h Pods/Headers/Private"
end

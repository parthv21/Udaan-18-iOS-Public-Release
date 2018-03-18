buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "/Users/Parth/Documents/iOS Apps/Udaan-App/Udaan-App")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "/Users/Parth/Documents/iOS Apps/Udaan-App/Udaan-App"
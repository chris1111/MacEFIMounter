# MacEFIMounter
# (c) Copyright 2025 chris1111, All Right Reserved.
# This will create a Apple Bundle App Notification
# Dependencies: osacompile
PARENTDIR=$(dirname "$0")
cd "$PARENTDIR"
# Declare some VARS
find . -name '.DS_Store' -type f -delete
APP_NAME="MacEFIMounter.app"
APPS_NAME="Notification.app"
SOURCES_SCRIPT="./Notification.applescript"
rm -rf "$APPS_NAME"

echo "= = = = = = = = = = = = = = = = = = = = = = = = =  "
echo "macOSEFIMounter"
echo "= = = = = = = = = = = = = = = = = = = = = = = = =  "

# Create the dir structure
/usr/bin/osacompile -o "$APPS_NAME" "$SOURCES_SCRIPT"
cp -rp ./Notifications/applet.icns "$APPS_NAME"/Contents/Resources/
cp -rp ./Notifications/Info.plist "$APPS_NAME"/Contents/
cp -rp ./Notifications/applet "$APPS_NAME"/Contents/MacOS/
cp -rp ./Notifications/applet.rsrc "$APPS_NAME"/Contents/Resources/
cp -rp ./Notifications/description.rtfd "$APPS_NAME"/Contents/Resources/
Sleep 1
cp -rp "$APPS_NAME" ./build/Release/"$APP_NAME"/Contents/Resources/
Sleep 1
rm -rf "$APPS_NAME"

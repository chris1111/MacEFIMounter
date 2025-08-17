#!/bin/sh
# Dependencies: osacompile
# Declare some VARS
SCRIPTS_NAME=$HOME/MacEFIMounter/ScriptSources/MacEFIMounter.applescript
APP_NAME="MacEFIMounter.app"
APPS_NAME="Notification.app"
SOURCES_SCRIPT="./Notification.applescript"
APP=/Applications/MacEFIMounter.app
apptitle="MacEFIMounter"
version="1.0"
# Set Icon directory and file 
iconfile="/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns"
# BuildChoice
rm -rf "$APPS_NAME"
# Create the dir structure
/usr/bin/osacompile -o "$APPS_NAME" "$SOURCES_SCRIPT"
cp -rp ./Notifications/applet.icns "$APPS_NAME"/Contents/Resources/
cp -rp ./Notifications/Info.plist "$APPS_NAME"/Contents/
cp -rp ./Notifications/applet "$APPS_NAME"/Contents/MacOS/
cp -rp ./Notifications/applet.rsrc "$APPS_NAME"/Contents/Resources/
cp -rp ./Notifications/description.rtfd "$APPS_NAME"/Contents/Resources/
Sleep 1
cd $HOME/MacEFIMounter
echo "Make Build"
Sleep 2
make
cp -rp "$APPS_NAME" ./build/Release/"$APP_NAME"/Contents/Resources/
cp -rp ./AutomatePassword ./build/Release/"$APP_NAME"/Contents/Resources/AutomatePassword
# Install App if Yes
response=$(osascript -e 'tell app "System Events" to display dialog "Do you want to install the App on your Applications\n\nCancel for Quit" buttons {"Cancel","Install"} default button 2 with title "'"$apptitle"' '"$version"'" with icon POSIX file "'"$iconfile"'"  ')

action=$(echo $response | cut -d ':' -f2)

# Exit if Canceled
if [ ! "$action" ] ; then
  echo "User cancel MacEFIMounter quit in 3 sec . . . 
User does not want to install the Applications"
  Sleep 3
  osascript -e 'display notification "Program closing" with title "'"$apptitle"'" subtitle "User cancelled"'
  echo "Open Release"
  open ./build/Release
  exit 0

fi
if [ "$action" == "Install" ] ; then
  echo "Remove New if exist"
  osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/MacEFIMounter.app", hidden:false}'
  Sleep 1
  Open $APP
  Sleep 1
  osascript -e 'tell application "System Events" to delete login item "MacEFIMounter"'
  killall -c MacEFIMounter
  echo "$APP exists."
  rm -rf $APP
fi

if [ "$action" == "Install" ] ; then
  cp -Rp ./build/Release/MacEFIMounter.app /Applications/MacEFIMounter.app
  Sleep 1
  osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/MacEFIMounter.app", hidden:false}'    
  Sleep 1
  Open $APP
  echo "= = = = = = = = = = = = = = = = = = = = = = = = =  "
  echo "Create /Applications/MacEFIMounter.app 
Done.
App is ready on Status Bar"
  echo "= = = = = = = = = = = = = = = = = = = = = = = = =  "
  open ./build/Release
fi
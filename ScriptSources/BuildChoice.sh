#!/bin/sh
# Dependencies: osacompile
# Declare some VARS
SCRIPTS_NAME=$HOME/MacEFIMounter/ScriptSources/MacEFIMounter.applescript
APP_NAME="MacEFIMounter.app"
APPS_NAME="Notification.app"
SOURCES_SCRIPT="./Notification.applescript"
apptitle="MacEFIMounter"
version="1.0"
# Set Icon directory and file 
iconfile="/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns"
# BuildChoice
response=$(osascript -e 'tell app "System Events" to display dialog "Automate Password: This will Automate the task without having to enter your password for your application

Build Regular: You will need to enter your password each time you use it.\n\nCancel for Quit" buttons {"Cancell","Build Regular","Automate Password"} default button 3 with title "'"$apptitle"' '"$version"'" with icon POSIX file "'"$iconfile"'"  ')

action=$(echo $response | cut -d ':' -f2)


# Exit if Canceled
if [ "$action" == "Cancell" ] ; then
     osascript -e 'display notification "MacEFIMounter quit" with title "'"$apptitle"'" subtitle "User cancel"'
     echo "User cancel MacEFIMounter quit in 3 sec . . . Clean Build!"
     Sleep 3
     rm -rf $HOME/MacEFIMounter
     osascript -e 'quit app "Terminal"'
fi


if [ "$action" == "Build Regular" ] ; then
     echo " "
     Sleep 1
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
     # Install App if Yes
response=$(osascript -e 'tell app "System Events" to display dialog "Do you want to install the App on your Applications\n\nCancel for Quit" buttons {"Cancel","Install"} default button 2 with title "'"$apptitle"' '"$version"'" with icon POSIX file "'"$iconfile"'"  ')

action=$(echo $response | cut -d ':' -f2)

# Exit if Canceled
if [ ! "$action" ] ; then
  echo "User cancel MacEFIMounter quit in 3 sec . . . "
  Sleep 3
  osascript -e 'display notification "Program closing" with title "'"$apptitle"'" subtitle "User cancelled"'
  open ./build/Release
  exit 0

fi
echo "Remove New if exist"
APP=/Applications/MacEFIMounter.app
if [ -d "$APP" ]; then
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/MacEFIMounter.app", hidden:false}'
    Sleep 1
    Open $APP
    Sleep 1
    osascript -e 'tell application "System Events" to delete login item "MacEFIMounter"'
    killall -c MacEFIMounter
    echo "$APP exists."
    rm -rf /Applications/MacEFIMounter.app
fi

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
fi

if [ "$action" == "Automate Password" ] ; then
     echo " "
     echo "Welcome $USER *** Automate Password ***"
     Sleep 3
     cd $HOME/MacEFIMounter
     cp -Rp ./AutomatePassword /Private/tmp

read -r -d '' CodeMenu <<'EOF'
   set iconfile to alias "System:Library:CoreServices:Finder.app:Contents:Resources:Finder.icns"
   set Box to text returned of (display dialog "
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

⬇ ︎Type: Your your password to include it in the applications

Then press the OK button
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

                
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" default answer "" buttons {"OK"} default button {"OK"} with hidden answer with icon iconfile)
return Box
EOF

Box=$(osascript -e "$CodeMenu");
echo " "

OLD="12345"
MYPATH="/Private/tmp/AutomatePassword/main.txt"
TFILE="/Private/tmp/out.tmp"
for f in $MYPATH
do
  if [ -f $f -a -r $f ]; then
   sed "s/$OLD/$Box/g" "$f" > $TFILE && mv $TFILE "$f"
  else
   echo "Error: Cannot read $f"
  fi

OLD="12345"
MYPATH="/Private/tmp/AutomatePassword/MacEFIMounter.txt"
TFILE="/Private/tmp/out.tmp"
for f in $MYPATH
do
  if [ -f $f -a -r $f ]; then
   sed "s/$OLD/$Box/g" "$f" > $TFILE && mv $TFILE "$f"
  else
   echo "Error: Cannot read $f"
  fi
done
done
  Sleep 1
  mv /Private/tmp/AutomatePassword/main.txt /Private/tmp/AutomatePassword/main.scpt
  mv /Private/tmp/AutomatePassword/MacEFIMounter.txt /Private/tmp/AutomatePassword/MacEFIMounter.applescript
  Sleep 1
  rm -rf $HOME/MacEFIMounter/MacEFIMounter.applescript
  Sleep 1
  cp -Rp /Private/tmp/AutomatePassword/MacEFIMounter.applescript $HOME/MacEFIMounter/MacEFIMounter.applescript
  echo "= = = = = = = = = = = = = = = = = = = = = = = = =  "
  echo "MacEFIMounter.app use Automate Password."
  echo "= = = = = = = = = = = = = = = = = = = = = = = = =  "
  Sleep 1
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
  Sleep 1
  cp -rp "$APPS_NAME" ./build/Release/"$APP_NAME"/Contents/Resources/
  rm -rf /Private/tmp/AutomatePassword

echo "Remove New if exist"
APP=/Applications/MacEFIMounter.app
if [ -d "$APP" ]; then
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/MacEFIMounter.app", hidden:false}'
    Sleep 1
    Open $APP
    Sleep 1
    osascript -e 'tell application "System Events" to delete login item "MacEFIMounter"'
    killall -c MacEFIMounter
    echo "$APP exists."
    rm -rf /Applications/MacEFIMounter.app
fi

# Install App if Yes
response=$(osascript -e 'tell app "System Events" to display dialog "Do you want to install the App on your Applications\n\nCancel for Quit" buttons {"Cancel","Install"} default button 2 with title "'"$apptitle"' '"$version"'" with icon POSIX file "'"$iconfile"'"  ')

action=$(echo $response | cut -d ':' -f2)

# Exit if Canceled
if [ ! "$action" ] ; then
  osascript -e 'display notification "Program closing" with title "'"$apptitle"'" subtitle "User cancelled"'
  open ./build/Release
  exit 0

fi

cp -Rp ./build/Release/MacEFIMounter.app /Applications/MacEFIMounter.app
cp -rp $SCRIPTS_NAME $HOME/MacEFIMounter/MacEFIMounter.applescript
Sleep 1
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/MacEFIMounter.app", hidden:false}'
Sleep 1
Open $APP
echo "= = = = = = = = = = = = = = = = = = = = = = = = =  "
echo "Create /Applications/MacEFIMounter.app 
Done.
App is ready on Status Bar"
echo "= = = = = = = = = = = = = = = = = = = = = = = = =  "
fi

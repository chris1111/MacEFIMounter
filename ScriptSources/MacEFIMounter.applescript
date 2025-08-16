--
--  MacEFIMounter.applescript Created by chris1111 on 11-8-25.
--  Base on (https://www.sonsothunder.com/devres/revolution/tutorials/StatusMenu.html).
--

property NSBundle : class "NSBundle"
property NSStatusItem : class "NSStatusItem"
property NSString : class "NSString"
property NSImage : class "NSImage"
property NSStatusBar : class "NSStatusBar"


script MenuletAppDelegate
	
	property parent : class "NSObject"
	property setup : false
	property myMenu : missing value
	property theView : missing value
	property textField : missing value
	property spinner : missing value
	property statusItem : missing value
	property AppletIcon : missing value
	property AssistantIcon : missing value
	property userName : missing value
	property PassRoot : missing value
	
	
	on doMenuStuff:sender --  Mount EFI using MacEFIMounter
		set Volumepath to paragraphs of (do shell script "ls /Volumes")
		set Diskpath to choose from list Volumepath with prompt "
Please make your selection:"
		if Diskpath is false then
			display dialog "Quit MacEFIMounter" with icon note buttons {"EXIT"} default button {"EXIT"}
			return
			return (POSIX path of Diskpath)
		end if
		try
			delay 1
			set file_list to ""
			set the_command to quoted form of POSIX path of (path to resource "Helper-EFI")
			
			repeat with file_path in Diskpath
				set file_list to file_list & " " & quoted form of POSIX path of file_path
			end repeat
			set the_command to the_command & " " & file_list
			try
				do shell script the_command with administrator privileges
				set Mountaif to quoted form of POSIX path of (path to resource "Mountaif")
				do shell script Mountaif
				display alert "Mount EFI Partition on Volume" message (Diskpath as text) buttons "Done" default button "Done" giving up after 3
			end try
		end try
	end doMenuStuff:
	
	on doSomething:sender --  Unmount EFI
		startSpinner()
		set source to quoted form of POSIX path of (path to resource "Unmount")
		set Unmountaif to quoted form of POSIX path of (path to resource "Unmountaif")
		set Notification to quoted form of POSIX path of (path to resource "Notification")
		performSelector_withObject_afterDelay_("stopSpinner", missing value, 2.5)
		delay 2.5
		do shell script source with administrator privileges
		do shell script Unmountaif
		do shell script Notification
	end doSomething:
	
	on awakeFromNib()
		set bundle to NSBundle's mainBundle()
		set AppletIcon to NSImage's alloc's initWithContentsOfFile:(bundle's pathForResource:"Applet" ofType:"png")
		set AssistantIcon to NSImage's alloc's initWithContentsOfFile:(bundle's pathForResource:"Assistant" ofType:"png")
		set statusItem to NSStatusBar's systemStatusBar's statusItemWithLength:-1 --
		statusItem's setImage:AppletIcon
		statusItem's setAlternateImage:AssistantIcon
		statusItem's setMenu:myMenu
		statusItem's setToolTip:"StatusMenu"
		statusItem's setHighlightMode:true
	end awakeFromNib
	
	on applicationWillFinishLaunching:aNotification
		
	end applicationWillFinishLaunching:
	
	on applicationShouldTerminate:sender
		return current application's NSTerminateNow
	end applicationShouldTerminate:
	
	on startSpinner()
		setupTitle()
		statusItem's setView:theView
		spinner's startAnimation:me
	end startSpinner
	
	on stopSpinner()
		spinner's stopAnimation:me
		statusItem's setView:(missing value)
		statusItem's setImage:AppletIcon
		statusItem's setAlternateImage:AssistantIcon
	end stopSpinner
	
	on setupTitle()
		if setup then return
		set menuBarFont to current application's NSFont's menuBarFontOfSize:12
		set attributes to current application's NSDictionary's dictionaryWithDictionary:{NSFontAttributeName:menuBarFont, NSParagraphStyleAttributeName:(current application's NSParagraphStyle's defaultParagraphStyle)}
		set theTitle to current application's NSString's stringWithString:" Unmount"
		set titleWidth to ((width of ((theTitle's sizeWithAttributes:attributes) as record)) as integer) + 12
		set textField to current application's NSTextField's alloc's initWithFrame:{{0, 0}, {titleWidth, 22}}
		tell textField # set up textField properties
			setFont_(menuBarFont)
			setStringValue_(theTitle)
			setDrawsBackground_(false)
			setBezeled_(false)
		end tell
		set spinner to current application's NSProgressIndicator's alloc's initWithFrame:{{0, 0}, {16, 16}}
		tell spinner # set up spinner properties
			setControlSize_(current application's NSSmallControlSize)
			setStyle_(current application's NSProgressIndicatorSpinningStyle)
			setUsesThreadedAnimation_(true)
		end tell
		set theView to current application's NSView's alloc's initWithFrame:{{0, 0}, {22 + titleWidth, 22}}
		tell theView # add everything to the view and adjust locations
			addSubview_(textField)
			textField's setFrameOrigin:{22.0, -2.0}
			addSubview_(spinner)
			spinner's setFrameOrigin:{5.0, 4.0}
		end tell
		set setup to true
	end setupTitle
	
end script

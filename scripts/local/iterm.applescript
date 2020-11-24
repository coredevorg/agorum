#!/usr/bin/osascript

use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

on run argv
	
	-- arguments when running from script debugger 
	if (argv = me) then
		set argv to {"-n", "Default", "ls -l"}
		-- set argv to {"-n"}
	end if
	
	set _help to "usage: iterm [-n] [profile] [command]"
	set _window to false
	set _profile to "Default"
	set _cmd to ""
	
	if (count of argv) > 0 then
		
		if (item 1 of argv) is equal to "-?" then
			display alert _help
			return
		end if
		
		if (item 1 of argv) is equal to "-n" then
			set _window to true
			if (count of argv) > 1 then
				set _profile to (item 2 of argv)
			end if
			if (count of argv) > 2 then
				set _cmd to (item 3 of argv)
			end if
		else
			set _profile to (item 1 of argv)
			if (count of argv) > 1 then
				set _cmd to (item 2 of argv)
			end if
		end if
	end if
	
	
	tell application "iTerm"
		if _window then
			set obj to (create window with profile _profile)
		else
			tell current window
				set obj to (create tab with profile _profile)
			end tell
		end if
		if _cmd is not equal to "" then
			tell current session of obj
				write text _cmd
			end tell
		end if
	end tell
	
end run

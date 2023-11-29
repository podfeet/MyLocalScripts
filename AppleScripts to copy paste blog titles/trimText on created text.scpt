
-- https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ManipulateText.html 

on trimText(theText, theCharactersToTrim, theTrimDirection)
	set theTrimLength to length of theCharactersToTrim
	if theTrimDirection is in {"beginning", "both"} then
		repeat while theText begins with theCharactersToTrim
			try
				set theText to characters (theTrimLength + 1) thru -1 of theText as string
			on error
				-- text contains nothing but trim characters
				return ""
			end try
		end repeat
	end if
	if theTrimDirection is in {"end", "both"} then
		repeat while theText ends with theCharactersToTrim
			try
				set theText to characters 1 thru -(theTrimLength + 1) of theText as string
			on error
				-- text contains nothing but trim characters
				return ""
			end try
		end repeat
	end if
	return theText
end trimText
-- In Safari, this copies the Title and URL of the current tab to the clipboard.  
-- Save the script in ~/Library/Scripts/Applications/Safari
-- Using QuickSilver, I assign a trigger to this script using the hotkey ⌥-C (option c), with the scope of the trigger limited to Safari.
-- Inspired by CopyURL + (http://copyurlplus.mozdev.org/)
-- Christopher R. Murphy 

tell application "Safari"
	set theURL to URL of front document
	set theTitle to name of front document
	set theText to theTitle
	#log theText
	
end tell
set theTitle to	trimText(theText," – Podfeet Podcasts", "end")
set the clipboard to "<a href=\"" & theURL & "\">" & theTitle & "</a>"
log the clipboard

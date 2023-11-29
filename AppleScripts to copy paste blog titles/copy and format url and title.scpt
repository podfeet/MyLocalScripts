tell application "Safari"
	set theURL to URL of front document
	set theTitle to name of front document
	set the clipboard to "<a href=\"" & theURL & "\">" & theTitle & "</a>"	
	log the clipboard
end tell
set the clipboard to "Some text"
tell application "Visual Studio Code"
	activate
end tell
tell application "System Events" to key code 125 using command down
tell application "System Events" to key code 76
tell application "System Events" to key code 9 using command down
tell application "System Events" to key code 49 using control down
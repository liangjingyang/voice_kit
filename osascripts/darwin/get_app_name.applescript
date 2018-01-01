on run argv
  tell application "System Events" 
    set frontApp to displayed name of first application process whose frontmost is true
  end tell
end run
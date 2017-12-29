on run argv
  set asr to item 1 of argv
  set the clipboard to asr
  tell application "System Events" to keystroke "v" using command down
end run
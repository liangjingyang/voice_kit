-- click key
-- osascript key_tap.applescript keycodes, times, modifiers, delay
on run argv
	
	set keyCodes to item 1 of argv
  set keyCodes to my theSplit(keyCodes, ",")

  set theTimes to 1
	if (count of argv) ≥ 2 then
		set theTimes to item 2 of argv
	end if

  set theModifiers to {""}
  if (count of argv) ≥ 3 then
		set theModifiers to item 3 of argv
    set theModifiers to my theSplit(theModifiers, ",")
	end if

  set delayTime to 0
  if (count of argv) ≥ 4 then
		set delayTime to item 4 of argv
	end if

  tell application "System Events"
    repeat with theModifier in theModifiers
      if (theModifier contains "shift") then
        key down shift
      end if
      if (theModifier contains "command") then
        key down command
      end if
      if (theModifier contains "control") then
        key down control
      end if
      if (theModifier contains "option") then
        key down option
      end if
    end repeat

    repeat theTimes times
      repeat with keyCode in keyCodes
        key code keyCode
        delay delayTime
      end repeat
    end repeat

    repeat with theModifier in theModifiers
      if (theModifier contains "shift") then
        key up shift
      end if
      if (theModifier contains "command") then
        key up command
      end if
      if (theModifier contains "control") then
        key up control
      end if
      if (theModifier contains "option") then
        key up option
      end if
    end repeat
  end tell
end run

on theSplit(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore the old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the result
	return theArray
end theSplit
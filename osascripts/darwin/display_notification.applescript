on run argv
  set theTitle to ""
  set theText to ""
  if (count of argv >= 1) then
    set theTitle to item 1 of argv
  end if
  if (count of argv >= 2) then
    set theText to item 2 of argv
  end if
  display notification theText with title theTitle subtitle "by Voice Kit"
end run
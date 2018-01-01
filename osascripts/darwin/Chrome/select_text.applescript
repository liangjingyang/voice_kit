on run argv
  set theTxt to ""
  if (count of argv) >= 1
    set theTxt to item 1 of argv
  end if
  set theIndex to 1
  if (count of argv) >= 2
    set theIndex to item 2 of argv
  end if 
  set theJs to "var all = document.getElementsByTagName('a');
      for (var i=0, max=all.length; i < max; i++) {
        if (all[i].textContent.indexOf('" & theTxt & "') >= 0) {
          if (i + 1 == " & theIndex & ") {
            element = all[i]
            var range, selection;    
            if (document.body.createTextRange) {
                range = document.body.createTextRange();
                range.moveToElementText(element);
                range.select();
            } else if (window.getSelection) {
                selection = window.getSelection();        
                range = document.createRange();
                range.selectNodeContents(element);
                selection.removeAllRanges();
                selection.addRange(range);
            }
          }
        }
      }
  true;
  "
  tell application "Google Chrome"
    set loadDelay to 1
    delay loadDelay
    execute front window's active tab javascript theJs
  end tell
end run
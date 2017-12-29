on run argv
	set txt to "Extensions"
	set js to "var all = document.getElementsByTagName('*');
      for (var i=0, max=all.length; i < max; i++) {
        if (all[i].textContent.indexOf('" & txt & "') >= 0) {
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
	  element.click();
        }
      }
	true;
  "
	tell application "Google Chrome"
		set loadDelay to 1
		delay loadDelay
		execute front window's active tab javascript js
	end tell
end run
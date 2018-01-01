
on run avgs
  if (count of avgs) >= 1 then
		set appName to item 1 of avgs
		tell application appName to activate
	end if
end run
------------------------------------------------
-- Automated token generation and VPN logins
-- Copyright 2010, Corey Gilmore
-- http://coreygilmore.com/
------------------------------------------------

set theVPNConnection to "SH" -- the VPN Connection name
set thePin to "" -- set to "" to prompt every time (recommended)

set theADSL to "" -- if theADSL is not null, will try to connect ADSL first
set theApp to "UserNotificationCenter" -- shouldn't have to change this
set theText to "VPN Connection" -- static text to search for in the VPN dialog, likely locale specific

-- Generate your passcode and open the VPN connection
vpn_connect(thePin, theVPNConnection, theApp, theText, theADSL)

--------------------------------------
-- Helper functions below
--------------------------------------

-- assume that the SofToken app is located in /Applications/SofToken II.app
on get_token(userPin)
	set token to do shell script "bash -c 'echo " & userPin & "|/Applications/SofToken\\ II.app/Contents/Resources/st-wrap.sh -s -p'"
	return token
end get_token

-- helper method to retrieve the user's PIN if it's not stored
on get_user_pin(thePin)
	if thePin is not null and thePin is not "" then return thePin
	
	set dialogResult to display dialog "Enter your SofToken II - PIN:" default answer "" with title "SofToken II - PIN" with hidden answer
	
	if button returned of dialogResult is "OK" then
		set thePin to text returned of dialogResult
		if thePin is null or thePin = "" then
			return false
		end if
	end if
	return thePin
end get_user_pin

-- Find a window containing specific static text, in a given application
on find_window_by_static_text(appname, staticText)
	repeat with x from 1 to 100
		log "waiting " & x
		delay 0.6
		tell application "System Events"
			set allApps to (get name of every application process) -- get all apps
			if allApps contains appname then -- find the app if it's running
				set allWin to (get every window of application process appname) -- get all the windows for our app
				set numWin to count allWin -- count the number of windows
				repeat with winNum from 1 to numWin
					set aWin to window winNum of application process appname
					set allText to (get value of every static text of aWin)
					if allText contains staticText then
						return winNum
					end if
				end repeat
			end if
		end tell
	end repeat
	return null
end find_window_by_static_text

on test_window(winNum, appname)
	
	tell application "System Events"
		set aWin to item winNum of (get every window of application process appname)
		if aWin is not null then
			set allText to (get value of every static text of aWin)
			if allText contains "Password:" then
				return "authWindow"
			end if
			set allText to (get title of every button of aWin)
			if allText contains "Disconnect" then
				return "welcomeWindow"
			end if
			return "errWindow"
		end if
	end tell
end test_window

on is_connected(servicename)
	try
		tell application "System Events"
			tell current location of network preferences
				if connected of current configuration of service servicename then
					return true
				end if
			end tell
		end tell
	end try
	return false
end is_connected

on connect_adsl(adsl)
	try
		if adsl is not null and adsl is not "" then
			tell application "System Events"
				tell current location of network preferences
					set ADSLService to service adsl
					set isConnected to connected of current configuration of ADSLService
					if not isConnected then
						connect ADSLService
					end if
					repeat 40 times
						delay 0.5
						if connected of current configuration of ADSLService then
							return true
						end if
					end repeat
				end tell
			end tell
			return false
		else
			return true
		end if
	end try
	return true
end connect_adsl

-- the actual connection - retrieve the token, initiate the connection and enter the password
on vpn_connect(thePin, theVPNConnection, theApp, theText, adsl)
	if not connect_adsl(adsl) then
		display alert "Abort. Unable to connect " & adsl
		return
	end if
	
	if is_connected(theVPNConnection) then
		return
	end if
	
	repeat 3 times
		
		set thePin to get_user_pin(thePin)
		if thePin is false then
			display alert "Invalid PIN."
			return
		end if
		--display alert "PIN: " & thePin
		--return
		
		set theToken to get_token(thePin)
		log "gettoken returned: " & theToken
		
		if the length of theToken is not 8 then
			log "wrong pin?"
			return
		end if
		
		tell application "System Events"
			tell network preferences
				connect service theVPNConnection
			end tell
		end tell
		delay 0.5
		
		set authed to 0
		
		repeat 5 times
			set winNum to find_window_by_static_text(theApp, theText)
			if winNum is null then
				log "Could not find the VPN Connection window"
			else
				set resultWindow to test_window(winNum, theApp)
				log resultWindow
				tell application theApp to activate
				tell application "System Events"
					perform action "AXRaise" of item winNum of (get every window of application process theApp)
					if resultWindow is "authWindow" then
						if authed is 0 then
							set authed to 1
							keystroke theToken
							key code 36
						else
							key code 53
							exit repeat
						end if
					else if resultWindow is "welcomeWindow" then
						key code 36
						return
					else if resultWindow is "errWindow" then
						key code 36
						exit repeat
					end if
				end tell
			end if
			delay 0.2
		end repeat
		
	end repeat
end vpn_connect


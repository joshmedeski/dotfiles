#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Select Notification
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔔
# @raycast.packageName Developer Utils

# Documentation:
# @raycast.description Selects the first macOS notification
# @raycast.author joshmedeski
# @raycast.authorURL https://raycast.com/joshmedeski

tell application "System Events"
	tell process "NotificationCenter"
		if (count of windows) > 0 then
			tell window 1
				tell group 1
					tell group 1
						tell scroll area 1
							click group 1
						end tell
					end tell
				end tell
			end if
		end tell
	end tell

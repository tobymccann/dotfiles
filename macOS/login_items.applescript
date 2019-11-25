# "Â" charachter tells osascript that the line continues
set login_item_list to {"Alfred 4", "Docker", "Dropbox", "Hammerspoon", "NordVPN IKE", "Numi", "iTerm"}

#tell application "System Events" 
#    get the name of every login item
#    delete every login item
#end tell

repeat with login_item in login_item_list
    tell application "System Events"
        make login item at end with properties {name: login_item, path: ("/Applications/" & login_item & ".app"), hidden: false}
    end tell
end repeat

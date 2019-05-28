#!/bin/bash
set -x
export SCRIPT_HOME=$PWD
declare -a arr=("centos6" "centos7" "rhel6" "rhel7")

# OSX only
[ `uname -s` != "Darwin" ] && echo 'OS X Only' &&return

function iterm () {
    local cmd=""
    local wd="$1"
    local args="$@"

    cmd="echo Launching Vagrant VM"
    for var in "$@"
    do
        cmd="$cmd;$var"
    done

    echo $cmd
   # osascript &>/dev/null <<EOF
    osascript <<EOF
tell application "iTerm"
	activate
	set new_window to (create window with default profile)
	set cSession to current session of new_window
	tell new_window
		tell cSession
			delay 1
			write text "cd $wd;$cmd"
			delay 2
			repeat
				delay 0.1
				--          display dialog cSession is at shell prompt
				set isdone to is at shell prompt
				if isdone then exit repeat
			end repeat
		end tell
	end tell
end tell
EOF
}

for i in "${arr[@]}"
do
  iterm $@ $SCRIPT_HOME/install "vagrant destroy -f v$i" "vagrant up v$i" "vagrant ssh v$i" &
done

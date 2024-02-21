#!/bin/bash

# Open Simulator which is inside the Xcode package
# Need to do this before npm run start (must be last)
open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app

# change dir to where I want to open VSCode and run npm
cd /Users/allison/htdocs/xkpasswd-js/src

# Launches VSCode with current dir open as folder
# Have to add code to PATH per these instructions for this to work
# Open command palette with Cmpd+Shift+P
# Search for: Shell Command: Install 'code' command in PATH# https://code.visualstudio.com/docs/setup/mac#:~:text=Keep%20in%20Dock.-,Launching%20from%20the%20command%20line,code%27%20command%20in%20PATH%20command.
code .

# Finally run npm (which also runs npm watch
npm run start


#!/bin/zsh

# open Steve's Mac Studio to his Desktop

VOLUME="/Volumes/steven/Desktop"
SERVER="smb://100.125.23.54/steven/Desktop"  # update with your actual server URL

# Mount if not already mounted
if ! mount | grep -q "$VOLUME"; then
  open "$SERVER"
  sleep 3  # give it a moment to mount
fi

open "$VOLUME"
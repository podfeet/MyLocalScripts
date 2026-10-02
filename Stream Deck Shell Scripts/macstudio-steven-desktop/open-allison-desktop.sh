#!/bin/zsh

# open Allison's MacBook Pro to her Desktop
open "/Volumes/allison/Desktop"

VOLUME="/Volumes/Allison/Desktop"
SERVER="smb://100.101.128.42/allison/Desktop"  # update with your actual server URL

# Mount if not already mounted
if ! mount | grep -q "$VOLUME"; then
  open "$SERVER"
  sleep 3  # give it a moment to mount
fi

open "$VOLUME"
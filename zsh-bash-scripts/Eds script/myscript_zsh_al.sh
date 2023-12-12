#!/bin/bash
# Author: Ed Tobias
# Created: 6-20-2022

# Create path variables - I chose to move the files to a delete folder 
# after the transfer and have a separate Hazel rule to trash the contents.
# It would be much simpler to use the rm command on the frompath
# folder within this script, but that might be too scarry

ip="192.168.4.95"
frompath="/Users/allison/Documents/deleteme/v/*"
topath="/volume1/Synodo-al-backup/deleteme/"
delpath="/Users/allison/Documents/deleteme/w"

# To prevent having to enter a password, set up ssh to authenticate with keys. 
# You also have to turn on ssh capability on the Synology NAS
# ssh is set up on port 2292
# to be a little more secure, then add that port to the beginnning of the topath

# The AND (&&) prevents the mv command from executing if the scp command can't connect to the NAS
scp -P 2292 $frompath podfeet@$ip:$topath && mv $frompath $delpath

# Use exit 0 to prevent an alert if you can't connect to the NAS
exit 0

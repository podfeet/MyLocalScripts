#!/bin/bash
# Author: Ed Tobias
# Created: 6-20-2022

# Create path variables - I chose to move the files to a delete folder 
# after the transfer and have a separate Hazel rule to trash the contents.
# It would be much simpler to use the rm command on the frompath
# folder within this script, but that might be too scarry

frompath="/Users/tobias/Sites/transfer/*"
topath="/var/services/homes/tobias/from_air"
delpath="/Users/tobias/.Trash/"
myport=1955

# To prevent having to enter a password, set up ssh to authenticate with keys. 
# You also have to turn on ssh capability on the Synology NAS
# On the NAS you can change the port from 22 to something else if you want
# to be a little more secure, then add that port to the beginnning of the topath

# The AND (&&) prevents the mv command from executing if the scp command can't connect to the NAS
echo "scp -P $myport $frompath tobias@192.168.1.97:$topath && mv -v $frompath $delpath"

scp -P $myport $frompath tobias@192.168.1.97:$topath && mv -v $frompath $delpath

# Use exit 0 to prevent an alert if you can't connect to the NAS
exit 0

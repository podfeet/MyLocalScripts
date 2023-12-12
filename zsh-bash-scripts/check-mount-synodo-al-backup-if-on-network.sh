#!/bin/zsh

ip='192.168.4.95'

# test to see if $ip is on the network
if ping -c 1 -W 1 "$ip"; then
	# Use shell BUILTINS export command to assign an environment variable to be used by child processes
	export share='synodo-al-backup'

	# test to see if $share is already mounted by searching for 
	# smb-mounted Volumes and then searching that output for $server
	# echo easy-to-search responses

		if mount | grep $share; then
			echo "$share is mounted already"
		else
			echo "$share is unmounted"
		fi
else
	# send funny message that's easy to search in the output
	echo "$ip is pining for the fjords"
	
	
fi
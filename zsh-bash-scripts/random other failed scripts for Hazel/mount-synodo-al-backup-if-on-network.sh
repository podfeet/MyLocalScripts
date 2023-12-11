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
			# export result="$share is mounted already"
		else
			echo "$share is unmounted"
			# export result="$share is on network but unmounted"
			open smb://$ip/$share
		fi
else
	# send funny message that's easy to search in the output
	echo "$ip is pining for the fjords"
	# export result="$ip is pining for the fjords"
fi

# Based on value of $result:
# ignore if mounted already
# mount if on the network but unmounted
# ignore if not on the network
# simpler path might be to only do something if on network and unmounted


# echo //$ip/$share

if [ $result="$share is on network but unmounted" ];
	then
		echo "opening $share"
		open smb://$ip/$share
fi
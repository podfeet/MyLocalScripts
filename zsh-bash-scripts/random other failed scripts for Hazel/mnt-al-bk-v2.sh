#!/bin/zsh


# Fetch the password from the keychain if it exists
PASSWORD_ENTERED=false
ACCOUNT_NAME='login'
SERVICE_NAME='mount_volume'
PASSWORD=$(
security 2> /dev/null \
	find-generic-password -w \
	-a $ACCOUNT_NAME \
	-s $SERVICE_NAME
)
# Prove it got the password
# echo "PASSWORD: $PASSWORD"
# URL escape the password (allow for special characters in the password)
ENCODED_PASSWORD="$(
perl -MURI::Escape -e \
'print uri_escape($ARGV[0]);' \
"$PASSWORD"
)"
# echo "ENCODED_PASSWORD: $ENCODED_PASSWORD"
# Remote file user
REMOTE_USER='podfeet'
# echo "REMOTE_USER: $REMOTE_USER"

# Declare the IP for the Synology as a variable
IP='192.168.4.95'

# test to see if $IP is on the network
if ping -c 1 -W 1 "$IP"; then
	# Use shell BUILTINS export command to assign an environment variable to be used by child processes
	export SHARE='synodo-al-backup'

	# test to see if $share is already mounted by searching  
	# smb-mounted Volumes and then searching that output for $server
	# echo easy-to-search responses
	  # this if/else works
		if mount | grep $SHARE; then
			STATUS="$SHARE is mounted already"
		echo $STATUS
		else
			STATUS="$SHARE is unmounted"
			echo $STATUS
			# Open the share. not the same as mounting, as the status below says it's still unmounted
			open smb://$REMOTE_USER:$ENCODED_PASSWORD@$IP/$SHARE

			echo $STATUS
		fi
else
	# send funny message that's easy to search in the output
	STATUS="$IP is pining for the fjords"
	echo $STATUS
fi
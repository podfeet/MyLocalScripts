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

# Stop the script from continuing if there's an error
set -e

# Remote file user
REMOTE_USER='podfeet'

# Remote file server
REMOTE_SERVER='192.168.4.95'

# Volumes to mount
declare -a REMOTE_MOUNTS=(synodo-al-backup)

# Where to mount volumes
LOCAL_DESTINATION="$HOME/Mount/"


# Prompt for password if not in keychain
if [ -z $PASSWORD ]; then
  echo "Enter the password for user ${REMOTE_USER} on ${REMOTE_SERVER}:"
  read -s PASSWORD
  PASSWORD_ENTERED=true
fi

# URL escape the password (allow for special characters in the password)
ENCODED_PASSWORD="$(
perl -MURI::Escape -e \
  'print uri_escape($ARGV[0]);' \
  "$PASSWORD"
)"

# Mount each volume from $REMOTE_MOUNTS to $LOCAL_DESTINATION
for MOUNT in ${REMOTE_MOUNTS[*]}
do
  mkdir -p "$LOCAL_DESTINATION/$MOUNT"
  mount_smbfs -o \
    automounted \
    -N "//${REMOTE_USER}:$ENCODED_PASSWORD@${REMOTE_SERVER}/${MOUNT}/" \
    "$LOCAL_DESTINATION/$MOUNT"
done

# Save the password to the keychain if provided
if [ $PASSWORD_ENTERED != false ]
then
  security add-generic-password \
  -a $ACCOUNT_NAME \
    -l "Volume mount password for user ${REMOTE_USER} on ${REMOTE_SERVER}" \
    -s $SERVICE_NAME \
    -w $PASSWORD
fi
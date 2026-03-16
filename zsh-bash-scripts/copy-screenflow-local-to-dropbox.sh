# ScreenFlow does not work well when saving to local storage
# This script is to be referenced inside Hazel
# Process is:
	# Create two folders: "app-name" LOCAL and "app-name DROPBOX"
	# Set Hazel to watch the new Dropbox folder and run this script
	# record, and save to local folder. 
	# Upon save, Hazel will copy the file from Local to Dropbox
	# and append the name with the current date and time

# Get the directory and current name of the file
dir=$(dirname "$1")
current=$(basename "$1")

# Remove the extension to get just the name part
name_only=${current%.screenflow}

# Get the modification date/time of the file in the requested format
date_time=$(stat -f "%Sm" -t "%Y-%m-%d %H%M" "$1")

# Create the new name with date/time appended
new_name="${name_only} ${date_time}.screenflow"

# Move the file with the mv command to preserve the package
mv "$1" "$dir/$new_name"
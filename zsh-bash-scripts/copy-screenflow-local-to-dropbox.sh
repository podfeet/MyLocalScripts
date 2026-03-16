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
#!/bin/zsh
# =============================================================================
# New ScreenCastsONLINE Project Folders
# Version: 1.0
# Created by Allison Sheridan
# Last Updated 2025-07-27
# License: MIT
# Copyright © 2025 Allison
# Permission is hereby granted to use, copy, modify, and share this script freely,
# provided the above copyright and attribution notices are preserved.
# Full license text: https://opensource.org/licenses/MIT
#
# Description:
# Automate creation of folder structure on local disk and Dropbox for SCO videos
#
# Functionality
# 1. Dropbox
# 1.1 Creates a new project directory in 
#     '/Users/allison/Library/CloudStorage/Dropbox/SCO Video/SCO Video DROPBOX'
# 1.2 Directory title will be "APP_NAME DROPBOX"
# 1.3 Inside the Directory will be another folder called "assets"
# 1.4 Add Dir to Finder Sidebar
# 2. Local
# 2.1 Creates a new project directory in 
#     ''/Volumes/ScreenCastsONLINE/SCO Working Show''
# 1.2 Directory title will be "APP_NAME LOCAL"
# 1.3 Add Dir to Finder Sidebar
#
# Usage:
# 1. Make the script executable: chmod +x sco_structure.sh
# 2. Run the script: ./sco_structure.sh
# 3. The project structure should be created in Dropbox and on SCO local drive
# =============================================================================

# Set the app name
APP_NAME=$(osascript -e 'text returned of (display dialog "Enter the app name:" default answer "")')
button_pressed=$(osascript -e 'button returned of (display dialog "You entered: '"$APP_NAME"'" buttons {"Cancel", "Confirm"} default button "Confirm")')

# Create a new project directory in Dropbox for the app
DROPBOX_DIR="$HOME/Library/CloudStorage/Dropbox/SCO Video/SCO Video DROPBOX/SCO Working Show DROPBOX"
APP_DIR_DB=$DROPBOX_DIR/$APP_NAME" DROPBOX"
mkdir $APP_DIR_DB
# Create subdirectory for assets
mkdir $APP_DIR_DB/assets

# Add Dropbox project dir to Finder sidebar
# Note: you may get a popup from macOS asking for Terminal to have access
#       to System Events and to go to 
#       System Settings/Privacy & Security/Accessibility/
#       and toggle on Terminal
open "$APP_DIR_DB"
osascript -e 'tell application "Finder" to activate' -e 'tell application "System Events" to keystroke "t" using {command down, control down}'
osascript -e 'tell application "Finder" to close (first window whose target is folder POSIX file "'"$APP_DIR_DB"'")'

# Add project to ScreenCastsONLINE volume
SCO_DIR="/Volumes/ScreenCastsONLINE/SCO Working Show"
APP_DIR_SCO=$SCO_DIR/$APP_NAME" LOCAL"
mkdir $APP_DIR_SCO 
open "$APP_DIR_SCO"
osascript -e 'tell application "Finder" to activate' -e 'tell application "System Events" to keystroke "t" using {command down, control down}'
folder_name=$(basename "$APP_DIR_SCO")
# osascript -e 'tell application "Finder" to close (first window whose name is "'"$APP_DIR_SCO"'")'

# Confirm completion of all tasks
osascript -e ' "You entered: '$APP_NAME'"'
osascript -e 'display dialog "You have created a folder called '$APP_NAME' in Dropbox and on the SCO volume, and both folders are in the Finder sidebar. Additionally, an assets folder has been created in Dropbox only."'


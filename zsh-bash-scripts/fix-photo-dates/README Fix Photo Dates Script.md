## Problem this solves

When you have a folder of photos from the same event, the filenames and dates are often inconsistent. That can make the files harder to sort, search, and recognize later.

This script fixes that by giving all images in a folder a consistent naming pattern and a shared date.

## What the script does

- Prompts you for:

  - A date in the format `YYYY:MM:DD`
  - A title to use for all files

- Looks in the current directory for common image formats.

- Renames each image in sequence using this format:

  ```
  text
  NN Title YYYY-MM-DD.ext
  ```

- Updates the file modification date to noon on the date you entered.

- On macOS, it can also update the file creation date if `SetFile` is installed.

- Reports each rename as it works, then prints a summary at the end.

Example renamed file:

```
text
01 Beach Party 2024-06-15.jpg
```

## Requirements

- macOS is recommended.
- Bash must be available.
- Optional: Xcode Command Line Tools, if you want the script to update creation dates as well as modification dates.

## Installation

1. Save the script at:

   ```
   text
   /Users/allison/htdocs/MyLocalScripts/zsh-bash-scripts/fix-photo-dates/fix-photo-dates.sh
   ```

2. Make it executable:

   ```
   bash
   chmod +x /Users/allison/htdocs/MyLocalScripts/zsh-bash-scripts/fix-photo-dates/fix-photo-dates.sh
   ```

## How to run it

1. Put the images for one event into a single folder.

2. Open Terminal.

3. Change to that folder:

   ```
   bash
   cd /path/to/my/event/folder
   ```

4. Run the script:

   ```
   bash
   /Users/allison/htdocs/MyLocalScripts/zsh-bash-scripts/fix-photo-dates/fix-photo-dates.sh
   ```

5. Enter:

   - The event date in `YYYY:MM:DD` format
   - The name you want used for all files

The script will then rename the images and update their dates.

## Example

```
text
$ cd /Users/allison/Pictures/BeachParty
$ /Users/allison/htdocs/MyLocalScripts/zsh-bash-scripts/fix-photo-dates/fix-photo-dates.sh
Enter date (YYYY:MM:DD): 2024:06:15
Enter name for all files: Beach Party
Found 12 image(s). Renaming and updating dates...
 [01] IMG_1234.JPG → 01 Beach Party 2024-06-15.jpg
 ...
Done. 12 file(s) processed.
```

## Notes

- The script works on image files in the current directory only.
- If no supported image files are found, it exits without making changes.
- If `SetFile` is not installed, the modification date will still be changed, but the creation date will not.
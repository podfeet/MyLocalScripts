#!/usr/bin/env bash

# ─── Prompt for date ─────────────────────────────────────────────────────────
while true; do
  read -rp "Enter date (YYYY:MM:DD): " raw_date
  if [[ "$raw_date" =~ ^[0-9]{4}:[0-9]{2}:[0-9]{2}$ ]]; then
    break
  else
    echo "Invalid format. Please use YYYY:MM:DD (e.g. 2024:06:15)"
  fi
done

# Parse components
YEAR="${raw_date:0:4}"
MONTH="${raw_date:5:2}"
DAY="${raw_date:8:2}"

LABEL_DATE="${YEAR}-${MONTH}-${DAY}"      # for filename:  2024-06-15
TOUCH_DATE="${YEAR}${MONTH}${DAY}1200.00" # for touch -t:  202406151200.00
SETFILE_DATE="${MONTH}/${DAY}/${YEAR} 12:00:00" # for SetFile: 06/15/2024 12:00:00

# ─── Find images ─────────────────────────────────────────────────────────────
shopt -s nullglob nocaseglob
image_files=()
for f in *.jpg *.jpeg *.png *.gif *.heic *.tiff *.tif *.cr2 *.nef *.arw *.dng *.raw; do
  image_files+=("$f")
done
shopt -u nullglob nocaseglob

count="${#image_files[@]}"

if (( count == 0 )); then
  echo "No image files found in the current directory."
  exit 1
fi

echo "Found ${count} image(s). Renaming and updating dates..."

# Determine zero-pad width
pad_width=${#count}
(( pad_width < 2 )) && pad_width=2

# ─── Check for SetFile (creation date support) ────────────────────────────────
has_setfile=false
if command -v SetFile &>/dev/null; then
  has_setfile=true
fi

# ─── Process each file ────────────────────────────────────────────────────────
index=1
for original in "${image_files[@]}"; do
  ext="${original##*.}"
  ext_lower="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
  counter=$(printf "%0${pad_width}d" "$index")
  new_name="${counter} Fresno Photoshoot ${LABEL_DATE}.${ext_lower}"

  # Rename
  mv -- "$original" "$new_name"

  # Set modification (and access) date to noon
  touch -t "$TOUCH_DATE" "$new_name"

  # Set creation date (macOS only, requires Xcode dev tools)
  if $has_setfile; then
    SetFile -d "$SETFILE_DATE" "$new_name"
  fi

  echo "  [$counter] $original → $new_name"
  (( index++ ))
done

echo ""
echo "Done. ${count} file(s) processed."
if ! $has_setfile; then
  echo "Note: SetFile not found — creation date was not changed (modification date was)."
  echo "      Install Xcode command line tools to enable creation date changes."
fi
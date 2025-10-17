#!/bin/zsh

in_png=$(mktemp /tmp/clip.XXXXXX).png
out_png=$(mktemp /tmp/rounded.XXXXXX).png
mask_png=$(mktemp /tmp/mask.XXXXXX).png

# get image from clipboard
pngpaste "$in_png" >/dev/null 2>&1 || exit 1
W=$(magick identify -format "%w" "$in_png"); H=$(magick identify -format "%h" "$in_png"); r=54

# build opaque rounded-rect mask on black bg
magick -size ${W}x${H} canvas:black -fill white \
  -draw "roundrectangle 0,0 $((W-1)),$((H-1)) $r,$r" "$mask_png" >/dev/null 2>&1 || exit 1

# apply mask to alpha, then draw 2px inside stroke
magick "$in_png" "$mask_png" -alpha set -compose CopyOpacity -composite \
  -stroke "#888888" -strokewidth 2 -fill none \
  -draw "roundrectangle 1,1 $((W-2)),$((H-2)) $r,$r" \
  PNG32:"$out_png" >/dev/null 2>&1 || exit 1

# replace clipboard with only PNG
osascript -e 'set the clipboard to ""' \
          -e 'set the clipboard to (read POSIX file "'"$out_png"'" as «class PNGf»)' >/dev/null 2>&1

rm -f "$in_png" "$out_png" "$mask_png"
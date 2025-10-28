#!/bin/zsh

# -c means send to Clipboard
# -i allows interactive to switch between window and area capture
# -o means don't capture a shadow

screencapture -cio

# Purpose: Read an image from macOS clipboard, apply 54px rounded corners + 2px gray border,
#          then replace the clipboard contents with the processed PNG (with real transparent corners).
# Tools: ImageMagick v7 (`magick`) and `pngpaste` (Homebrew), plus AppleScript to set PNG data only.

# Create unique temporary filenames for the input PNG, output PNG, and the alpha mask PNG.
# mktemp returns a unique path; we append .png to ensure ImageMagick infers PNG format.
in_png=$(mktemp /tmp/clip.XXXXXX).png
out_png=$(mktemp /tmp/rounded.XXXXXX).png
mask_png=$(mktemp /tmp/mask.XXXXXX).png

# Extract the current clipboard image as a PNG into in_png.
# Redirect stdout/stderr to keep the terminal clean of PNG bytes or warnings.
pngpaste "$in_png" >/dev/null 2>&1 || exit 1

# Query the image width and height using ImageMagick identify.
# These are needed to size the mask and to compute the rounded-rectangle coordinates.
W=$(magick identify -format "%w" "$in_png")
H=$(magick identify -format "%h" "$in_png")

# Desired corner radius in pixels.
r=$(osascript -e 'button returned of (display dialog "Choose corner radius:" buttons {"52", "32"} default button "52")')

# Build an opaque/transparent mask the same size as the image:
# - Start all black (fully transparent).
# - Draw a white rounded rectangle from (0,0) to (W-1,H-1) with radius r (fully opaque).
#   Syntax: roundrectangle x0,y0 x1,y1 rx,ry
#   Using W-1, H-1 keeps the stroke/pixels within bounds.
magick -size ${W}x${H} xc:black -fill white \
  -draw "roundrectangle 0,0 $((W-1)),$((H-1)) $r,$r" \
  "$mask_png" >/dev/null 2>&1 || exit 1

# Apply the alpha mask to the original image:
# - Read original + mask.
# - Ensure alpha channel exists (-alpha set).
# - Use -compose CopyOpacity to copy the mask’s grayscale into the image’s alpha.
# Now the image has true 54px rounded transparent corners.
#
# Next, draw a 2px medium-gray border INSIDE the rounded shape:
# - Create a transparent drawing layer sized to the image.
# - Use -stroke "#888888" and -strokewidth 2.
# - Draw the same rounded rectangle, inset by 1px on each side (1..W-2, 1..H-2),
#   so the centered 2px stroke sits fully inside the edge and remains visible.
#
# Then, composite that stroked layer over the rounded image.
#
# Finally, re-apply the same mask as a safety step:
# - Compositing the stroke could theoretically paint into corners; copying the mask
#   again enforces fully transparent corners.
#
# Write the final image explicitly as PNG32 (RGBA) to out_png.
magick -quiet "$in_png" "$mask_png" -alpha set -compose CopyOpacity -composite \
  \( -size ${W}x${H} xc:none -stroke "#888888" -strokewidth 2 -fill none \
     -draw "roundrectangle 1,1 $((W-2)),$((H-2)) $r,$r" \) -compose over -composite \
  "$mask_png" -compose CopyOpacity -composite \
  PNG32:"$out_png" >/dev/null 2>&1 || exit 1

# Replace the system clipboard with ONLY the PNG flavor.
# Many macOS apps prefer the first pasteboard flavor (often TIFF) unless we set PNG explicitly.
# AppleScript reads the file as '«class PNGf»' and sets that as the clipboard, avoiding stale TIFF.
osascript -e 'set the clipboard to ""' \
          -e 'set the clipboard to (read POSIX file "'"$out_png"'" as «class PNGf»)' >/dev/null 2>&1

# Clean up temporary files.
rm -f "$in_png" "$out_png" "$mask_png"
#!/bin/bash
# title="$icon_prn OCRscreen"
# Author: magdesign
# License: MIT4
# Description: Reads text of selected area
# Requirements: bash tesseract-ocr tesseract-ocr-data-eng wl-clipboard
# Notes: v0.2 Works only in sway/wayland
# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. "/usr/bin/sxmo_common.sh"

# check requirements
if command -v tesseract >/dev/null 2>&1 ;then
echo "ok"
else
  notify-send --urgency=critical "Please install tesseract-ocr tesseract-ocr-data-eng"
  exit 1
fi

if command -v wl-paste >/dev/null 2>&1 ;then
echo "ok"
else
  notify-send --urgency=critical "Please install wl-clipboard"
  exit 1
fi
# end of requirements check

# tempdir
DIR=/tmp/ocr_tmp.png

# create a screenshot of wanted area:
area="$(slurp -o)"
grim -g "$area" "$DIR"

# sends image to ocr and extracts text 
tesseract /tmp/ocr_tmp.png /tmp/ocr_tmp

# displays text
notify-send "$(cat /tmp/ocr_tmp.txt)"

# copy text to clipboard
cat /tmp/ocr_tmp.txt | wl-copy

# cleanup
rm /tmp/ocr_tmp.txt
rm /tmp/ocr_tmp.png

exit

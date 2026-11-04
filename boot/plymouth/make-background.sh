#!/bin/bash
# Makes the Plymouth "aurora" background from a wallpaper: cropped to
# 3840x1600, dimmed, with a soft vignette so the logo and prompt read clearly.
# usage: ./make-background.sh WALLPAPER [OUT]   (OUT defaults to aurora/background.png)
set -euo pipefail
here=$(dirname "$(readlink -f "$0")")
in=${1:?usage: $0 WALLPAPER [OUT]}
out=${2:-$here/aurora/background.png}
magick "$in" -resize '3840x1600^' -gravity center -extent 3840x1600 \
  \( +clone -fill black -colorize 100 -fill white -draw "ellipse 1920,800 2250,1050 0,360" -blur 0x330 \) \
  -compose multiply -composite -modulate 80 -strip -define png:compression-level=9 "$out"
echo "wrote $out"

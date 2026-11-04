#!/bin/bash
# Downloads the wallpapers listed in SOURCES.txt from wallhaven and crops them
# to 3840x1600 exactly as used here. The art belongs to the artists credited
# in SOURCES.txt; it isn't redistributed in this repo.
# usage: ./fetch.sh [DIR]   (default ~/Pictures/Wallpapers; existing files are kept)
set -euo pipefail
here=$(dirname "$(readlink -f "$0")")
out=${1:-$HOME/Pictures/Wallpapers}
mkdir -p "$out"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

grep -v '^#' "$here/SOURCES.txt" | while IFS='|' read -r file id y _; do
  file=$(echo $file); id=$(echo $id); y=$(echo $y)
  [[ -z $file ]] && continue
  if [[ -e $out/$file ]]; then echo "have  $file"; continue; fi
  url=$(curl -fsS "https://wallhaven.cc/api/v1/w/$id" | python3 -I -c 'import json,sys; print(json.load(sys.stdin)["data"]["path"])')
  src=$tmp/${url##*/}
  curl -fsS -o "$src" "$url"
  width=$(magick identify -quiet -format '%w' "$src" 2>/dev/null)
  if [[ $file == *.jpg && $src == *.jpg && $width == 3840 ]] && command -v jpegtran >/dev/null; then
    # lossless JPEG crop, no re-encode
    jpegtran -copy none -crop "3840x1600+0+$y" -outfile "$out/$file" "$src"
  else
    magick -quiet "$src" -resize 3840x -crop "3840x1600+0+$y" +repage -strip "$out/$file"
  fi
  echo "got   $file"
  sleep 1  # be polite to the API
done

#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

# Loop over every .mp4 under static/videos (including subfolders)
for f in static/videos/**/*.mp4; do
  echo "Re-encoding $f …"

  # build a temp path in the same folder
  dir="$(dirname "$f")"
  base="$(basename "$f" .mp4)"
  tmp="${dir}/${base}.tmp.mp4"

  # ffmpeg to H.264 baseline + AAC, enable faststart
  ffmpeg -i "$f" \
    -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p -movflags +faststart \
    -c:a aac -b:a 128k \
    -y "$tmp"

  # overwrite the original
  mv -f "$tmp" "$f"
done

echo "All done!"


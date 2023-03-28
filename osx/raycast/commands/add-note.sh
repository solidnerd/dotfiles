#!/bin/bash
set -e
set -o pipefail


# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title daily
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗒️
# @raycast.packageName Notes

NOTE_FOLDER="$HOME/Documents/notes/daily"
TODAY=$(date '+%d-%m-%Y')

DAILY_NOTE="$NOTE_FOLDER/$TODAY.md"

NOTE_TOOL=Typora

if [[ ! -d "$NOTE_FOLDER" ]]; then
mkdir -p "$NOTE_FOLDER"
fi

if [[ ! -f "$DAILY_NOTE" ]]; then
cat > "$DAILY_NOTE" <<EOF
---
tags: [daily]
date: $TODAY
---
# Day $TODAY

Start to Write something cool

EOF
open -a $NOTE_TOOL "$DAILY_NOTE"
else 
open -a $NOTE_TOOL "$DAILY_NOTE"
fi 

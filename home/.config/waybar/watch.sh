#!/bin/bash
# Starts Waybar and reloads it whenever Caelestia's scheme changes (wallpaper change)
pkill -x waybar
python3 ~/.config/waybar/gen-colors.py
waybar &
last=""
while true; do
  m=$(stat -c %Y ~/.local/state/caelestia/scheme.json 2>/dev/null)
  if [ "$m" != "$last" ]; then
    if [ -n "$last" ]; then
      python3 ~/.config/waybar/gen-colors.py
      pkill -SIGUSR2 -x waybar
    fi
    last=$m
  fi
  sleep 2
done

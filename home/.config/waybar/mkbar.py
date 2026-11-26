#!/usr/bin/env python3
import json, os

def ic(code, size="115%"):
    return f"<span font_family='Font Awesome 7 Free' font_weight='900' font_size='{size}'>{chr(code)}</span>"

cfg = {
  "layer": "top", "position": "top", "height": 40,
  "margin-top": 4, "margin-left": 6, "margin-right": 8, "exclusive": True,
  "modules-left": ["clock", "pulseaudio", "mpris"],
  "modules-center": ["hyprland/workspaces"],
  "modules-right": ["tray", "temperature", "cpu", "memory", "network", "battery", "custom/power"],

  "clock": {"format": ic(0xf017) + "  {:%H:%M:%S}", "interval": 1,
            "tooltip-format": "{:%A, %d %B %Y}"},
  "pulseaudio": {"format": "{icon}  {volume}%", "format-muted": ic(0xf026) + "  muted",
                 "format-icons": {"default": [ic(0xf027), ic(0xf028)]}, "on-click": "pavucontrol"},
  "mpris": {"format": "{status_icon}  {title}", "max-length": 35,
            "status-icons": {"playing": ic(0xf001), "paused": ic(0xf04c)}},
  "hyprland/workspaces": {"format": "{id}", "persistent-workspaces": {"*": 4}},
  "tray": {"spacing": 8},
  "temperature": {"format": ic(0xf2c9) + "  {temperatureC}°C", "critical-threshold": 85, "interval": 3},
  "cpu": {"format": ic(0xf2db) + "  {usage}%", "interval": 2, "on-click": "foot -e btop"},
  "memory": {"format": ic(0xf538) + "  {percentage}%", "interval": 2, "on-click": "foot -e btop"},
  "network": {"format-wifi": ic(0xf1eb) + "  {signalStrength}%",
              "format-ethernet": ic(0xf6ff) + "  wired",
              "format-disconnected": ic(0xf071) + "  off",
              "tooltip-format": "{essid}  {ipaddr}"},
  "battery": {"format": "{icon}  {capacity}%", "format-charging": ic(0xf0e7) + "  {capacity}%",
              "format-icons": [ic(0xf244), ic(0xf243), ic(0xf242), ic(0xf241), ic(0xf240)],
              "states": {"warning": 25, "critical": 12}},
  "custom/power": {"format": ic(0xf011), "tooltip": False,
                   "on-click": "hyprctl dispatch 'hl.dsp.global(\"caelestia:session\")'"},
}
json.dump(cfg, open(os.path.expanduser("~/.config/waybar/config.jsonc"), "w"),
          ensure_ascii=False, indent=2)
print("config.jsonc written")

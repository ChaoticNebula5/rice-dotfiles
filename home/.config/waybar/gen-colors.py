#!/usr/bin/env python3
import json, os
home = os.path.expanduser("~")
src = f"{home}/.local/state/caelestia/scheme.json"
out = f"{home}/.config/waybar/colors.css"
d = {"surface": "1a1b26", "onSurface": "c0caf5", "primary": "bb9af7", "secondary": "7aa2f7"}
try:
    s = json.load(open(src))
    c = s.get("colours") or s.get("colors") or {}
    for k in d:
        sn = "".join("_" + ch.lower() if ch.isupper() else ch for ch in k)
        v = c.get(k) or c.get(sn)
        if v:
            d[k] = v.lstrip("#")
except Exception as e:
    print("scheme read failed, using fallback:", e)
rgb = lambda h: tuple(int(h[i:i+2], 16) for i in (0, 2, 4))
r, g, b = rgb(d["surface"])
pr, pg, pb = rgb(d["primary"])
with open(out, "w") as f:
    f.write(f"@define-color background rgba({r},{g},{b},0.6);\n")
    f.write(f"@define-color foreground #{d['onSurface']};\n")
    f.write(f"@define-color color9 #{d['primary']};\n")
    f.write(f"@define-color color10 #{d['secondary']};\n")
    f.write(f"@define-color border rgba({pr},{pg},{pb},0.55);\n")

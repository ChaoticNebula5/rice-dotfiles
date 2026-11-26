-- ~/.config/caelestia/hypr-user.lua
-- Rice layer on top of Caelestia (LeyzS + 43PR bits). Loaded last by hyprland.lua.
-- Every block is wrapped in pcall so one bad line can never take the desktop down.
-- Toggles live in ~/.config/rice/state/ and are flipped with the `rice` command.

local home  = os.getenv("HOME")
local rice  = home .. "/.config/rice"
local state = rice .. "/state/"

local function log(msg)
    print("[rice] " .. tostring(msg))
end

local function try(label, f, ...)
    local ok, err = pcall(f, ...)
    if not ok then log(label .. " failed: " .. tostring(err)) end
    return ok
end

local function flag(name, default)
    local f = io.open(state .. name, "r")
    if not f then return default end
    local v = (f:read("*l") or ""):gsub("%s+", "")
    f:close()
    if v == "" then return default end
    return v
end

local ok_scheme, scheme = pcall(require, "scheme.current")
if not ok_scheme or type(scheme) ~= "table" then scheme = {} end
local function col(key, fallback)
    local v = scheme[key]
    if type(v) == "string" and v:match("^%x%x%x%x%x%x$") then return v end
    return fallback
end

---------------------------------------------------------------------------
-- Misc: silence the hyprland-guiutils "install me" popup
---------------------------------------------------------------------------
try("guiutils check", hl.config, { misc = { disable_hyprland_guiutils_check = true } })

---------------------------------------------------------------------------
-- LeyzS: animated two-colour gradient borders (colours follow the wallpaper)
---------------------------------------------------------------------------
if flag("borders", "on") == "on" then
    local a = col("primary", "c2c1ff")
    local b = col("tertiary", col("secondary", "e8b9d5"))
    try("gradient borders", hl.config, {
        general = {
            border_size = 2,
            col = {
                active_border   = { colors = { "rgba(" .. a .. "ff)", "rgba(" .. b .. "ff)", "rgba(" .. a .. "ff)" }, angle = 45 },
                inactive_border = "rgba(" .. col("outlineVariant", "45464f") .. "66)",
            },
        },
    })
    try("border curve", hl.curve, "riceLinear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
    try("border loop", hl.animation, { leaf = "borderangle", enabled = true, speed = 80, bezier = "riceLinear", style = "loop" })
end

---------------------------------------------------------------------------
-- LeyzS: vibrance screen shader (Super+Alt+P toggles)
---------------------------------------------------------------------------
if flag("vibrance", "on") == "on" then
    try("vibrance shader", hl.config, { decoration = { screen_shader = rice .. "/shaders/vibrance.glsl" } })
end

---------------------------------------------------------------------------
-- Terminals: crisp text, see-through comes from kitty's own background
---------------------------------------------------------------------------
try("kitty opacity", hl.window_rule, { match = { class = "^(kitty|rice-.*)$" }, opacity = "1.0 override" })

---------------------------------------------------------------------------
-- Waybar pills: frosted glass behind them
---------------------------------------------------------------------------
try("waybar blur", hl.layer_rule, { match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.2 })

---------------------------------------------------------------------------
-- LeyzS panel grid as a HUD on special:hud (Super+G)
--   left: btop | top-middle: matrix | top-right: clock | bottom-right: cava
---------------------------------------------------------------------------
do
    local L = (flag("bar", "hover") == "always") and 0.042 or 0.016
    local R, T, B = 0.985, 0.058, 0.975
    local G, GV   = 0.010, 0.012
    local W       = R - L
    local leftW   = W * 0.5 - G / 2
    local x0      = L + W * 0.5 + G / 2
    local RW      = R - x0
    local topH    = (B - T) * 0.48
    local smallW  = RW * 0.5 - G / 2
    local clockX  = x0 + RW * 0.5 + G / 2
    local waveY   = T + topH + GV

    local function panel(class, x, y, w, h)
        try("panel " .. class, hl.window_rule, {
            match     = { class = "^(" .. class .. ")$" },
            float     = true,
            workspace = "special:hud",
            size      = string.format("(monitor_w*%.4f) (monitor_h*%.4f)", w, h),
            move      = string.format("(monitor_w*%.4f) (monitor_h*%.4f)", x, y),
            no_shadow = true,
        })
    end

    panel("rice-sys",   L,      T,     leftW,      B - T)
    panel("rice-rain",  x0,     T,     smallW,     topH)
    panel("rice-clock", clockX, T,     R - clockX, topH)
    panel("rice-wave",  x0,     waveY, RW,         B - waveY)
end

local ok_fn, fn = pcall(require, "utils.functions")
if ok_fn and type(fn) == "table" and type(fn.toggle) == "function" then
    try("hud bind", hl.bind, "SUPER + G", fn.toggle("hud"))
else
    try("hud bind (fallback)", hl.bind, "SUPER + G", hl.dsp.exec_cmd(home .. "/.local/bin/rice hud"))
end

---------------------------------------------------------------------------
-- Keys
---------------------------------------------------------------------------
-- Lock screen: hyprlock instead of the Caelestia lock
try("lock bind", hl.bind, "SUPER + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
try("settings bind", hl.bind, "SUPER + I", hl.dsp.global("caelestia:nexus"))
-- Vibrance on/off
try("vibrance bind", hl.bind, "SUPER + ALT + P", hl.dsp.exec_cmd(home .. "/.local/bin/rice vibrance toggle"))
-- Cheat sheet
try("keys bind", hl.bind, "SUPER + slash", hl.dsp.exec_cmd("kitty --class rice-keys -o background_opacity=0.85 -e sh -c 'cat " .. rice .. "/KEYS.txt; read -r _'"))
try("keys float", hl.window_rule, { match = { class = "^(rice-keys)$" }, float = true, size = "(monitor_w*0.42) (monitor_h*0.72)", center = true })

-- Personal additions that survive re-running the installer
local extra = io.open(rice .. "/user.lua", "r")
if extra then
    extra:close()
    try("rice/user.lua", dofile, rice .. "/user.lua")
end

-- ~/.config/caelestia/hypr-vars.lua
-- Overrides for ~/.config/hypr/variables.lua (Caelestia). Written by the rice installer.
return {
    -- Apps
    terminal      = "kitty",
    browser       = "brave-browser --password-store=kwallet6",
    editor        = "kwrite",
    fileExplorer  = "dolphin",
    audioSettings = "pavucontrol",
    cursorTheme   = "breeze_cursors",

    -- Window styling (between Caelestia's airy gaps and LeyzS's big ones)
    windowGapsIn        = 4,
    windowGapsOut       = 4,
    singleWindowGapsOut = 4,
    windowRounding      = 14,
    windowBorderSize    = 2,

    -- Super+L now runs hyprlock (bound in hypr-user.lua), so drop Caelestia's lock bind
    kbLock = "",
}

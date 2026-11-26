# rice-dotfiles

Fedora + Hyprland rice: Caelestia shell, LeyzS bar/panels, 43PR terminal. Private backup made by `rice-dots`.

## Restore on a fresh Fedora install
1. Install Hyprland and build the Caelestia shell + CLI (the long manual part).
2. `gh repo clone rice-dotfiles ~/dotfiles && bash ~/dotfiles/home/.local/bin/rice-dots restore`
3. `sudo dnf install --skip-unavailable $(cat ~/dotfiles/system/packages.txt)`
4. `rice-shell-patch` (solid panels, clickable Waybar, wallpaper arrows), then `rice-boot` (login/boot themes).
5. Log out and pick Hyprland.

`home/` mirrors your home folder. `system/` holds the package list and boot settings for reference.

#!/usr/bin/env fish
# aribook fresh-install bootstrap. Run on a fresh minimal Arch install:
#   curl -fsSL https://raw.githubusercontent.com/Mahlski/aribook-install/main/bootstrap.fish | fish

# --- 1. yay (AUR helper) ---
if not command -q yay
    echo "==> Building yay from AUR..."
    set tmpdir (mktemp -d)
    git clone https://aur.archlinux.org/yay.git $tmpdir/yay
    cd $tmpdir/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf $tmpdir
else
    echo "==> yay already present, skipping."
end

# --- 2. packages ---
echo "==> Installing packages..."
set packages \
    acpi aerc alsa-utils blueman bluez bluez-utils brightnessctl btop cliphist \
    dunst fastfetch fd file-roller firefox fuzzel fzf github-cli gimp gnupg grim \
    hyprcaffeine hypridle hyprland hyprlock hyprpaper hyprpolkitagent hyprshutdown \
    inetutils \
    intel-media-driver isync jq kitty less libnotify libreoffice-still libreoffice-still-nl \
    libva-utils lua-language-server mesa msmtp nodejs notmuch noto-fonts noto-fonts-cjk noto-fonts-emoji npm nwg-look \
    obsidian openssh pacman-contrib pass pavucontrol pcmanfm pinentry pipewire \
    pipewire-alsa pipewire-jack pipewire-pulse pkgfile playerctl powertop \
    python-pipx qbz-bin qt5-wayland qt6-wayland ripgrep rsync slurp smartmontools socat stow \
    tlp \
    ttf-dejavu ttf-liberation ttf-sourcecodepro-nerd ufw unzip upower vulkan-intel waybar-git \
    webapp-manager wget wireplumber wl-clipboard wpa_supplicant \
    xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-utils \
    xwayland-satellite zram-generator
yay -S --needed --noconfirm $packages
xdg-user-dirs-update

# Disable fish welcome message globally (universal var)
set -U fish_greeting ""

# --- 3. Claude (desktop + code) ---
echo "==> Installing Claude desktop + Claude Code..."
mkdir -p ~/.local/bin
fish_add_path -g ~/.local/bin
yay -S --needed --noconfirm claude-desktop-native
curl -fsSL https://claude.ai/install.sh | bash

# --- 4. dotfiles auth + clone (separate script — needs a real terminal) ---
# The dotfiles repo is private. Auth uses the GitHub device flow (authorize on
# your phone), which needs an interactive terminal — this bootstrap runs as
# `curl ... | fish`, so stdin is the pipe, not the keyboard. We therefore only
# DOWNLOAD the auth/clone/stow script here; run it next from a real shell.
echo "==> Fetching dotfiles setup script..."
curl -fsSL https://raw.githubusercontent.com/Mahlski/aribook-install/main/setup-dotfiles.fish -o ~/setup-dotfiles.fish

echo ""
echo "==> Bootstrap complete (packages + Claude installed)."
echo "==> Next, from THIS terminal (not piped), run:"
echo "      fish ~/setup-dotfiles.fish"
echo "    It authenticates GitHub on your phone, uploads an SSH key, then"
echo "    clones + stows the dotfiles repo over SSH."

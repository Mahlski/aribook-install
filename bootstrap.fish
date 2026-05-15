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
    acpi alsa-utils blueman bluez bluez-utils brightnessctl btop cliphist \
    dunst fastfetch fd file-roller firefox fuzzel fzf github-cli gimp grim \
    hypridle hyprland hyprlock hyprpaper hyprpolkitagent hyprshutdown \
    inetutils \
    intel-media-driver jq kitty less libreoffice-still libreoffice-still-nl \
    libva-utils mesa noto-fonts noto-fonts-cjk noto-fonts-emoji nwg-look \
    obsidian openssh pacman-contrib pavucontrol pcmanfm pipewire \
    pipewire-alsa pipewire-jack pipewire-pulse pkgfile playerctl powertop \
    python-pipx qbz-bin qt5-wayland qt6-wayland ripgrep rsync slurp socat \
    tlp \
    ttf-dejavu ttf-liberation ufw unzip upower vulkan-intel waybar-git \
    webapp-manager wget wireplumber wl-clipboard wpa_supplicant \
    xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-utils \
    xwayland-satellite zram-generator
yay -S --needed --noconfirm $packages
xdg-user-dirs-update

# --- 3. Claude (desktop + code) ---
echo "==> Installing Claude desktop + Claude Code..."
mkdir -p ~/.local/bin
fish_add_path -g ~/.local/bin
yay -S --needed --noconfirm claude-desktop-native
curl -fsSL https://claude.ai/install.sh | bash

# --- 4. dotfiles (public repo over HTTPS — no SSH key, no gh auth) ---
echo "==> Cloning dotfiles bare repo over HTTPS..."
git clone --bare https://github.com/Mahlski/dotfiles.git ~/.dotfiles

echo "==> Checking out dotfiles..."
set conflicts (git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout 2>&1 | grep -E '^\s+' | string trim)
if test (count $conflicts) -gt 0
    echo "==> Backing up pre-existing files with .bak suffix..."
    for f in $conflicts
        if test -e ~/$f
            mv ~/$f ~/$f.bak
            echo "    backed up: $f"
        end
    end
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
end
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

echo "==> Bootstrap complete."
echo "==> Open a NEW shell, then run:  fish ~/.local/bin/setup/post-install.fish"

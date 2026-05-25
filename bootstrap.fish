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
    intel-media-driver jq kitty less libnotify libreoffice-still libreoffice-still-nl \
    libva-utils mesa nodejs noto-fonts noto-fonts-cjk noto-fonts-emoji npm nwg-look \
    obsidian openssh pacman-contrib pavucontrol pcmanfm pipewire \
    pipewire-alsa pipewire-jack pipewire-pulse pkgfile playerctl powertop \
    python-pipx qbz-bin qt5-wayland qt6-wayland ripgrep rsync slurp socat stow \
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

# --- 4. dotfiles (stow from public HTTPS — no SSH key needed) ---
echo "==> Cloning dotfiles over HTTPS..."
git clone https://github.com/Mahlski/dotfiles.git ~/dotfiles

echo "==> Stowing dotfiles..."
cd ~/dotfiles
for line in (stow -n config claude git local 2>&1)
    if string match -qr 'existing target is neither' -- $line
        set target (string replace -r '.*: ' '' -- $line)
        set full ~/$target
        if test -e $full; and not test -L $full
            mv $full $full.bak
            echo "    backed up: $target"
        end
    end
end
stow config claude git local

# ssh: link only .ssh/config (keys live outside the repo); never fold the dir
if test -e ~/.ssh/config; and not test -L ~/.ssh/config
    mv ~/.ssh/config ~/.ssh/config.bak
    echo "    backed up: .ssh/config"
end
stow --no-folding ssh
chmod 600 ~/dotfiles/ssh/.ssh/config

echo "==> Bootstrap complete. Dotfiles at ~/dotfiles (stow)."
echo "==> Open a NEW shell, then run:  fish ~/.local/bin/setup/post-install.fish"
echo ""
echo "    SSH keys are NOT in the repo. To push changes later, generate a key and"
echo "    switch the remote to SSH:"
echo '      ssh-keygen -t ed25519'
echo "      # add ~/.ssh/id_ed25519.pub to GitHub, then:"
echo "      git -C ~/dotfiles remote set-url origin git@github.com:Mahlski/dotfiles.git"

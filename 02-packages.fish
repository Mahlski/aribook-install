#!/usr/bin/env fish

set packages \
    acpi \
    alsa-utils \
    blueman \
    bluez \
    bluez-utils \
    brightnessctl \
    btop \
    cliphist \
    dunst \
    fastfetch \
    fd \
    file-roller \
    firefox \
    fuzzel \
    fzf \
    github-cli \
    gimp \
    grim \
    hypridle \
    hyprland \
    hyprlock \
    hyprpaper \
    hyprpolkitagent \
    inetutils \
    intel-media-driver \
    jq \
    kitty \
    less \
    libreoffice-still \
    libreoffice-still-nl \
    libva-utils \
    mesa \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    nwg-look \
    obsidian \
    openssh \
    pacman-contrib \
    pavucontrol \
    pcmanfm \
    pipewire \
    pipewire-alsa \
    pipewire-jack \
    pipewire-pulse \
    pkgfile \
    playerctl \
    powertop \
    python-pipx \
    qt5-wayland \
    qt6-wayland \
    ripgrep \
    rsync \
    slurp \
    socat \
    tlp \
    ttf-dejavu \
    ttf-liberation \
    ufw \
    unzip \
    upower \
    vulkan-intel \
    waybar-git \
    webapp-manager \
    wget \
    wireplumber \
    wl-clipboard \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-hyprland \
    xdg-utils \
    xwayland-satellite

echo "==> Installing "(count $packages)" packages..."
yay -S --needed --noconfirm $packages

echo "==> Creating XDG user directories..."
xdg-user-dirs-update

echo "==> Done"

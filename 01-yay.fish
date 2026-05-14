#!/usr/bin/env fish

echo "==> Building yay from AUR..."

set tmpdir (mktemp -d)
git clone https://aur.archlinux.org/yay.git $tmpdir/yay
cd $tmpdir/yay
makepkg -si --noconfirm
cd ~
rm -rf $tmpdir

echo "==> yay installed"

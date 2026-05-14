#!/usr/bin/env fish

echo "==> Generating SSH key..."
ssh-keygen -t ed25519 -C "***REMOVED***" -f ~/.ssh/id_ed25519

echo "==> Authenticating with GitHub (device flow — keep this terminal open and enter the code on another device)..."
gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key --scopes admin:public_key

echo "==> Uploading SSH public key to GitHub..."
gh ssh-key add ~/.ssh/id_ed25519.pub --title (hostname)"-"(date +%Y%m%d)

echo "==> Testing GitHub SSH connection (exit code 1 is expected)..."
ssh -T git@github.com; or true

echo "==> Cloning dotfiles bare repo..."
git clone --bare git@github.com:Mahlski/dotfiles.git ~/.dotfiles

echo "==> Checking out dotfiles..."
set checkout_errors (git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout 2>&1 | grep -E '^\s+' | string trim)

if test (count $checkout_errors) -gt 0
    echo "==> Conflicting files — backing up with .bak suffix..."
    for f in $checkout_errors
        if test -e ~/$f
            mv ~/$f ~/$f.bak
            echo "    backed up: $f"
        end
    end
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
end

git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

echo "==> Dotfiles restored. Open a new shell to load fish config."

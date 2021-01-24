#!/bin/bash
sudo pacman --noconfirm -Scc
cat > /etc/pacman.d/mirrorlist <<'EOF'
Server = https://cloudflaremirrors.com/archlinux/$repo/os/$arch
EOF

sudo pacman --noconfirm -Syu
sudo pacman -S --noconfirm python3
sudo pacman --noconfirm -Scc

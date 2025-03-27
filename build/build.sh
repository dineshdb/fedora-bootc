#!/usr/bin/sh

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo



dnf install -y zsh podman-docker openssl smartmontools

dnf install -y syncthing powertop vulkan-tools tailscale wl-clipboard 

# gnome tools
dnf install -y gpaste gnome-shell-extension-gpaste gnome-shell-extension-blur-my-shell
dnf install -y gnome-shell-extension-appindicator
dnf install -y gnome-shell-extension-auto-move-windows

dnf install -y pipewire-v4l2
dnf install -y libva-utils

dnf install -y pritunl-client

# add cosmic-desktop because I want to test run it
dnf install -y cosmic-ext-applet-clipboard-manager cosmic-desktop

dnf install -y "kernel-devel-matched-${kernel_ver}"
dnf install -y akmod-nvidia
akmods --force --kernels "${kernel_ver}"
dnf -y module install nvidia-driver
dnf install -y nvidia-container-toolkit

#### Example for enabling a System Unit File
systemctl enable podman.socket
systemctl enable tailscaled
systemctl enable podman-auto-update.timer


rm /var/log/*.log /var/lib/dnf -rf

#!/usr/bin/sh

kernel_ver="$(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}' kernel)"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

dnf install -y zsh podman-docker openssl smartmontools
dnf install -y syncthing powertop vulkan-tools tailscale wl-clipboard 

# gnome tools
dnf group install gnome-desktop \
	base-graphical container-management core fonts hardware-support \
	multimedia networkmanager-submodules printing workstation-product -y
dnf remove -y gnome-software

dnf install -y gpaste gnome-shell-extension-gpaste gnome-shell-extension-blur-my-shell
dnf install -y gnome-shell-extension-appindicator
dnf install -y gnome-shell-extension-auto-move-windows

dnf install -y pipewire-v4l2
dnf install -y libva-utils
dnf install -y pritunl-client

# add cosmic-desktop because I want to test run it
dnf install -y cosmic-ext-applet-clipboard-manager cosmic-desktop

# for development
dnf install -y clang mold

# nvidia drivers
dnf install -y "kernel-devel-matched-${kernel_ver}"
dnf install -y akmod-nvidia
akmods --force --kernels "${kernel_ver}"
dnf -y module install nvidia-driver
dnf install -y nvidia-container-toolkit
cat <<EOF >/usr/lib/bootc/kargs.d/10-nvidia.toml
kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1"]
EOF

#### Example for enabling a System Unit File
systemctl enable podman.socket
systemctl enable tailscaled
systemctl enable podman-auto-update.timer
systemctl enable bootc-update.timer
systemctl disable nvidia-powerd.service
sudo systemctl set-default graphical.target

dnf clean all
rm /var/log/*.log /var/lib/dnf -rf

bootc container lint

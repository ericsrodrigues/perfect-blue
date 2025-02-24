#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

### Third Party Repos

# VSCode Repo

tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# SwayNC Repo
tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:erikreider:SwayNotificationCenter.repo <<'EOF'
[copr:copr.fedorainfracloud.org:erikreider:SwayNotificationCenter]
name=Copr repo for SwayNotificationCenter owned by Erik Reider
baseurl=https://download.copr.fedorainfracloud.org/results/erikreider/SwayNotificationCenter/fedora-$releasever-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/erikreider/SwayNotificationCenter/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
EOF

# Docker Repo

tee /etc/yum.repos.d/docker-ce.repo <<'EOF'
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

# this installs a package from fedora repos
rpm-ostree install \
code \
zsh \
neovim \
vim \
gnome-tweaks \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin \
bootc \
rclone \
fastfetch \
jetbrains-mono-fonts \
google-noto-sans-cjk-fonts \
SwayNotificationCenter \
alacritty \
gammastep \
gh

# uninstall packages
rpm-ostree uninstall \
firefox \
firefox-langpacks 

#### Example for enabling a System Unit File

systemctl enable podman.socket docker.service

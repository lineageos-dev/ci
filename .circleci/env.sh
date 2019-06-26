#!/bin/bash -e

# non-interactive
echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90non-interactive
echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90non-interactive

# dependencies
apt-get update
apt-get install --no-install-recommends -y \
  wget nano net-tools netcat bzip2 tar gzip xz-utils parallel \
  bc bison build-essential ccache curl flex g++-multilib gcc-multilib \
  git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev \
  lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev \
  libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool \
  squashfs-tools xsltproc openjdk-8-jdk python zip unzip zlib1g-dev \
  libc6-dev-i386 x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev

# repo
curl -sSL https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
chmod a+x /usr/local/bin/repo

# timezone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# swap
dd if=/dev/zero of=/swap count=4096 bs=1M
chmod 666 /swap
mkswap /swap
swapon /swap

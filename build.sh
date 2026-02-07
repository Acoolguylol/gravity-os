#!/bin/bash
set -e

# GravityOS Build Script
# Strategy: Use the official 'releng' profile as a base (to get working bootloaders)
# and overlay our custom packages and configs on top.

# Paths
SOURCE_PROFILE="/usr/share/archiso/configs/releng"
WORK_PROFILE="/tmp/gravity-profile"
CURRENT_DIR="$(pwd)"
OUT_DIR="${CURRENT_DIR}/out"

# Check permissions
if [ "$EUID" -ne 0 ]; then
   echo "This script must be run as root."
   exit 1
fi

echo "--- 🚀 Preparing GravityOS Profile ---"

# 1. Prepare Workspace
rm -rf "$WORK_PROFILE"
mkdir -p "$WORK_PROFILE"
mkdir -p "$OUT_DIR"

# 2. Copy Base Profile (releng)
# This ensures we have all the syslinux/GRUB/systemd-boot binaries and configs
echo "-> Copying base 'releng' profile..."
cp -a "$SOURCE_PROFILE/." "$WORK_PROFILE/"

# 3. Apply Customizations (Overlay)
echo "-> Applying GravityOS configs..."

# Merge Packages: Append our packages to the default list
# We filter out empty lines and comments from our file just in case
grep -vE '^\s*#|^\s*$' packages.x86_64 >> "$WORK_PROFILE/packages.x86_64"

# Overwrite Configurations
cp pacman.conf "$WORK_PROFILE/pacman.conf"
cp profiledef.sh "$WORK_PROFILE/profiledef.sh"

# Overlay airootfs (Filesystem)
# We use cp -rT to merge contents into existing directories
cp -r airootfs/* "$WORK_PROFILE/airootfs/"

# 4. Build ISO
echo "--- 🔨 Building ISO (This may take a while) ---"
cd "$WORK_PROFILE"
mkarchiso -v -w ./work -o "$OUT_DIR" .

echo "--- ✅ Build Complete! ---"
echo "ISO is located in: $OUT_DIR"

#!/bin/bash
set -e

# --- Configuration ---
PROFILE_NAME="gravity-os"
WORK_DIR="./work"
OUT_DIR="./out"

# --- Install Dependencies (For build machine) ---
# IMPORTANT: This script requires 'archiso' tool!
if ! command -v mkarchiso &> /dev/null; then
  echo "Error: mkarchiso not found. You must run this on Arch Linux with 'archiso' package installed."
  echo "Try: sudo pacman -S archiso"
  exit 1
fi

echo "Building GravityOS ISO..."

# --- 1. Clone & Setup OpenClaw ---
echo "Cloning OpenClaw into ISO build root..."
mkdir -p airootfs/opt/GravityOS/Agents
if [ ! -d "airootfs/opt/GravityOS/Agents/OpenClaw" ]; then
    git clone https://github.com/OpenClaw/OpenClaw.git airootfs/opt/GravityOS/Agents/OpenClaw
    # Install dependencies locally?
    # This part is tricky. 'node_modules' are huge and platform specific.
    # It's better to install them during 'customize_airootfs.sh' if networking allows,
    # OR create a dedicated pacman package.
    # We will assume user handles this manually for now or adds a first-boot script.
else
    echo "OpenClaw already present."
fi

# --- 2. Copy Profile Configs ---
# 'archiso' expects specific structure, so we point it to current dir
if [ "$EUID" -eq 0 ]; then
    mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" .
else
    sudo mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" .
fi

echo "Build Complete! ISO is in $OUT_DIR"

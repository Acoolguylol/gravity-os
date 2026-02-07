# GravityOS - Archiso Builder

This folder contains the configuration to build a custom Arch Linux ISO tailored for Gaming and AI development.

## 📦 Contents

- **packages.x86_64**: List of all pre-installed software (Listing Steam, Lutris, Hyprland, Node.js, Ollama etc.)
- **airootfs/**: The filesystem overlay. Contains custom configs and scripts.
- **profiledef.sh**: Archiso metadata.
- **build.sh**: Helper script to run `mkarchiso`.

## 🛠 How to Build

### Option 1: Using Arch Linux
If you have an Arch Linux machine (or VM):

1. Install `archiso`:
   ```bash
   sudo pacman -S archiso
   ```
2. Run the build script:
   ```bash
   chmod +x build.sh
   sudo ./build.sh
   ```
3. The ISO will be generated in `./out/gravity-os-2026.02.01-x86_64.iso`.

### Option 2: Using Docker (Recommended for Windows Users)
If you are on Windows, use Docker Desktop to build the ISO.

1. **Pull the Arch Linux image:**
   ```bash
   docker pull archlinux:latest
   ```

2. **Run the builder container:**
   Because `mkarchiso` needs privileged access to mount filesystems, you must run with `--privileged`.

   ```powershell
   docker run --rm -it --privileged -v ${PWD}:/profile archlinux:latest bash
   ```

3. **Inside the Docker Container:**
   ```bash
   # Install dependencies
   pacman -Syu --noconfirm archiso git

   # Go to mounted profile
   cd /profile

   # Run build
   ./build.sh
   ```

## 🎮 Features
- **Desktop**: Hyprland (Tiling WM) pre-configured with Waybar & Rofi.
- **Gaming**: Proton-GE, Steam, Lutris, Gamemode enabled by default.
- **AI**: OpenClaw (Moltbot) agent pre-cloned to `/opt/GravityOS/Agents`.
- **Shell**: ZSH with Oh-My-Zsh (installed on first boot).

## ⚠️ Notes
- The build process requires significant bandwidth to download packages (~2GB).
- The resulting ISO can be flashed to a USB drive with Rufus or Etcher.

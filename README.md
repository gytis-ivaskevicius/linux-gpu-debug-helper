# Linux GPU Debug Helper

A comprehensive knowledge base for debugging hardware acceleration, gaming, and browser issues on Linux systems. **This repository is specifically designed to be used as context by AI agents** when troubleshooting graphics, display, and performance problems.

[Try it now](https://deepwiki.com/gytis-ivaskevicius/linux-gpu-debug-helper) to explore the full Linux GPU Debug Helper guide.

## Purpose

This repository contains curated documentation and troubleshooting guides for common Linux graphics and gaming issues, designed to help AI agents quickly diagnose and resolve problems related to:

- **Graphics Drivers**: AMD, NVIDIA, Intel graphics troubleshooting
- **Display Systems**: Xorg configuration, multi-monitor setups, display scaling
- **Gaming**: Wine, Steam, emulators, performance optimization
- **Browsers**: Hardware acceleration, browser-specific configurations
- **Hardware Acceleration**: Video decoding, OpenGL, Vulkan, VR

## Repository Structure

### `arch/`
Arch Linux-specific documentation covering:
- **Graphics**: Driver installation, troubleshooting, and optimization guides
- **Gaming**: Steam, Wine, emulators, and game-specific fixes
- **Browsers**: Firefox, Chromium, and alternative browser configurations
- **Display**: Multi-monitor setup, Xorg configuration, display scaling

**Note**: While these instructions are Arch-specific, the underlying concepts and troubleshooting steps are applicable to NixOS systems. AI agents should adapt the package management and configuration approaches when applying these guides to NixOS.

### `nixos/`
NixOS-specific configurations and troubleshooting for:
- **Graphics**: Mesa, NVIDIA, AMD driver setups
- **Gaming**: Gaming on NixOS, Steam, emulators
- **Browsers**: Browser configurations for NixOS

### `fetch-wiki-pages.sh`
Script for fetching and updating wiki pages from external sources.

## Usage

**This repository is designed to be used as context by AI agents** when debugging Linux graphics and gaming issues. When encountering problems with:

1. **Graphics drivers not working properly**
2. **Games not launching or running poorly**
3. **Browser hardware acceleration issues**
4. **Multi-monitor configuration problems**
5. **Display scaling and DPI issues**

AI agents should consult the relevant sections in `arch/` or `nixos/` directories. **For NixOS users, Arch documentation provides valuable troubleshooting concepts** that can be adapted using NixOS-specific package management and configuration methods.

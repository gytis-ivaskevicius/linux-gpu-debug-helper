`<languages/>`{=html}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
[Steam](https://store.steampowered.com/) is a digital distribution platform for video games, offering a vast library for
purchase, download, and management. On NixOS, Steam is generally easy to install and use, often working
\"out-of-the-box\". It supports running many Windows games on Linux through its compatibility layer, Proton.[^1]

```{=html}
</div>
```
`<span id="Installation">`{=html}`</span>`{=html}

## 安装

#### Shell

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To temporarily use Steam-related tools like `steam-run` (for FHS environments) or `steamcmd` (for server management or
tools like steam-tui setup) in a shell environment, you can run:

```{=html}
</div>
```
``` bash
nix-shell -p steam-run # For FHS environment
nix-shell -p steamcmd  # For steamcmd
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
This provides the tools in your current shell without adding them to your system configuration. For `steamcmd` to work
correctly for some tasks (like initializing for steam-tui), you might need to run it once to generate necessary files,
as shown in the \`steam-tui\` section.

```{=html}
</div>
```
`<span id="System_setup">`{=html}`</span>`{=html}

#### 系统设置

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To install the [Steam](Steam "wikilink") package and enable all the system options necessary to allow it to run, add the
following to your `/etc/nixos/configuration.nix`:

```{=html}
</div>
```
``` nix
# Example for /etc/nixos/configuration.nix
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};

# Optional: If you encounter amdgpu issues with newer kernels (e.g., 6.10+ reported issues),
# you might consider using the LTS kernel or a known stable version.
# boot.kernelPackages = pkgs.linuxPackages_lts; # Example for LTS
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
[Anecdata on kernel 6.10 issues](https://news.ycombinator.com/item?id=41549030)

```{=html}
</div>
```
```{=mediawiki}
{{note|Enabling [[steam]] installs several unfree packages. If you are using <code>allowUnfreePredicate</code> you will need to ensure that your configurations permit all of them.
<syntaxhighlight lang="nix">
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
  ];
}
</syntaxhighlight>
}}
```
`<span id="Configuration">`{=html}`</span>`{=html}

## 配置

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Basic Steam features can be enabled directly within the `programs.steam` attribute set:

```{=html}
</div>
```
``` nix
programs.steam = {
  enable = true; # Master switch, already covered in installation
  remotePlay.openFirewall = true;  # For Steam Remote Play
  dedicatedServer.openFirewall = true; # For Source Dedicated Server hosting
  # Other general flags if available can be set here.
};
# Tip: For improved gaming performance, you can also enable GameMode:
# programs.gamemode.enable = true;
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
If you are using a Steam Controller or a Valve Index, ensure Steam hardware support is enabled. This is typically
handled by `programs.steam.enable = true;` which sets `hardware.steam-hardware.enable = true;` implicitly. You can
verify or explicitly set it if needed:

```{=html}
</div>
```
``` nix
hardware.steam-hardware.enable = true;
```

`<span id="Tips_and_tricks">`{=html}`</span>`{=html}

## 提示和技巧

`<span id="Gamescope_Compositor_/_&quot;Boot_to_Steam_Deck&quot;">`{=html}`</span>`{=html}

### Gamescope Compositor / \"启动至 Steam Deck\" {#gamescope_compositor_启动至_steam_deck}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Gamescope can function as a minimal desktop environment, meaning you can launch it from a TTY and have an experience
very similar to the Steam Deck hardware console.

```{=html}
</div>
```
``` nix
# Clean Quiet Boot
boot.kernelParams = [ "quiet" "splash" "console=/dev/null" ];
boot.plymouth.enable = true;

programs.gamescope = {
  enable = true;
  capSysNice = true;
};
programs.steam.gamescopeSession.enable = true; # Integrates with programs.steam

# Gamescope Auto Boot from TTY (example)
services.xserver.enable = false; # Assuming no other Xserver needed
services.getty.autologinUser = "USERNAME_HERE";

services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.gamescope}/bin/gamescope -W 1920 -H 1080 -f -e --xwayland-count 2 --hdr-enabled --hdr-itm-enabled -- steam -pipewire-dmabuf -gamepadui -steamdeck -steamos3 > /dev/null 2>&1";
      user = "USERNAME_HERE";
    };
  };
};
```

### steam-tui {#steam_tui}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
If you want the steam-tui client, you\'ll have to install it. It relies on `steamcmd` being set up, so you\'ll need to
run `steamcmd` once to generate the necessary configuration files. First, ensure `steamcmd` is available (e.g., via
`nix-shell -p steamcmd` or by adding it to `environment.systemPackages`), then run:

```{=html}
</div>
```
``` bash
steamcmd +quit # This initializes steamcmd's directory structure
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Then install and run \`steam-tui\`. You may need to log in within \`steamcmd\` first if \`steam-tui\` has issues:

```{=html}
</div>
```
``` bash
# (Inside steamcmd prompt, if needed for full login before steam-tui)
# login <username> <password> <steam_2fa_code>
# quit
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
After setup, `steam-tui` (if installed e.g. via `home.packages` or `environment.systemPackages`) should start fine.

```{=html}
</div>
```
`<span id="FHS_environment_only">`{=html}`</span>`{=html}

### 仅 FHS 环境 {#仅_fhs_环境}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To run proprietary games or software downloaded from the internet that expect a typical Linux Filesystem Hierarchy
Standard (FHS), you can use `steam-run`. This provides an FHS-like environment without needing to patch the software.
Note that this is not necessary for clients installed from Nixpkgs (like Minigalaxy or Itch), which already use the FHS
environment as needed. There are two options to make `steam-run` available: 1. Install `steam-run` system-wide or
user-specifically:

```{=html}
</div>
```
``` nix
# In /etc/nixos/configuration.nix
environment.systemPackages = with pkgs; [
  steam-run
];
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
2\. If you need more flexibility or want to use an overridden Steam package\'s FHS environment:

```{=html}
</div>
```
``` nix
# In /etc/nixos/configuration.nix
environment.systemPackages = with pkgs; [
  (steam.override { /* Your overrides here */ }).run
];
```

### Proton

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
You should be able to play most Windows games using Proton. If a game has a native Linux version that causes issues on
NixOS, you can force the use of Proton by selecting a specific Proton version in the game\'s compatibility settings in
Steam.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
By default, Steam also looks for custom Proton versions in `~/.steam/root/compatibilitytools.d`. The environment
variable `STEAM_EXTRA_COMPAT_TOOLS_PATHS` can be set to add other search paths.

```{=html}
</div>
```
自定义 Proton 版本的声明式安装（例如 GE-Proton）：

``` nix
programs.steam.extraCompatPackages = with pkgs; [
  proton-ge-bin
];
```

可使用 ProtonUp-Qt 手动管理多个 Proton 版本：

``` nix
environment.systemPackages = with pkgs; [
  protonup-qt
];
```

`<span id="Overriding_the_Steam_package">`{=html}`</span>`{=html}

### 覆盖 Steam 软件包 {#覆盖_steam_软件包}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
In some cases, you may need to override the default Steam package to provide missing dependencies or modify its build.
Use the `programs.steam.package` option for this. Steam on NixOS runs many games in an FHS environment, but the Steam
client itself or certain tools might need extra libraries.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Example: Adding Bumblebee and Primus (for NVIDIA Optimus):

```{=html}
</div>
```
``` nix
programs.steam.package = pkgs.steam.override {
  extraPkgs = pkgs': with pkgs'; [ bumblebee primus ];
};

# For 32-bit applications with Steam, if using steamFull:
# programs.steam.package = pkgs.steamFull.override { extraPkgs = pkgs': with pkgs'; [ bumblebee primus ]; };
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Example: Adding Xorg libraries for Gamescope (when used within Steam):

```{=html}
</div>
```
``` nix
programs.steam.package = pkgs.steam.override {
  extraPkgs = pkgs': with pkgs'; [
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXScrnSaver
    libpng
    libpulseaudio
    libvorbis
    stdenv.cc.cc.lib # Provides libstdc++.so.6
    libkrb5
    keyutils
    # Add other libraries as needed
  ];
};
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
### Fix missing icons for games in GNOME dock and activities overview {#fix_missing_icons_for_games_in_gnome_dock_and_activities_overview}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
GNOME uses the window class to determine the icon associated with a window. Steam currently doesn\'t set the required
key for this in its .desktop files[^2], but you can fix this manually by editing the `StartupWMClass` key for each
game\'s .desktop file, found under `~/.local/share/applications/`.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
For games running through Proton, the value should be `steam_app_``<game_id>`{=html} (where `<game_id>`{=html} matches
the value after <steam://rungameid/> on the `Exec` line).

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
For games running natively, the value should match the game\'s main executable.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
For example, the modified .desktop file for Valheim looks like this:

```{=html}
</div>
```
``` desktop
[Desktop Entry]
Name=Valheim
Comment=Play this game on Steam
Exec=steam steam://rungameid/892970
Icon=steam_icon_892970
Terminal=false
Type=Application
Categories=Game;
StartupWMClass=valheim.x86_64
```

`<span id="Troubleshooting">`{=html}`</span>`{=html}

## 故障排除

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
For all issues: first run `steam -dev -console` through the terminal and read the output.

```{=html}
</div>
```
`<span id="Steam_fails_to_start._What_do_I_do?">`{=html}`</span>`{=html}

### Steam 无法启动。我该怎么办？ {#steam_无法启动我该怎么办}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Run `strace steam -dev -console 2> steam.logs` in the terminal. If `strace` is not installed, temporarily install it
using `nix-shell -p strace` or `nix run nixpkgs#strace -- steam -dev -console 2> steam.logs` (if using Flakes). After
that, create a bug report.

```{=html}
</div>
```
`<span id="Steam_is_not_updated">`{=html}`</span>`{=html}

### Steam 未更新 {#steam_未更新}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
When you restart [Steam](Steam "wikilink") after an update, it starts the old version.
([#181904](https://github.com/NixOS/nixpkgs/issues/181904)) A workaround is to remove the user files in
`/home/<USER>/.local/share/Steam/userdata`. This can be done with `rm -rf /home/<USER>/.local/share/Steam/userdata` in
the terminal or with your file manager. After that, Steam can be set up again by restarting.

```{=html}
</div>
```
`<span id="Game_fails_to_start">`{=html}`</span>`{=html}

### 游戏无法启动

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Games may fail to start because they lack dependencies (this should be added to the script, for now), or because they
cannot be patched. The steps to launch a game directly are:

-   Patch the script/binary if you can
-   Add a file named steam_appid.txt in the binary folder, with the appid as contents (it can be found in the stdout
    from steam)
-   Using the LD_LIBRARY_PATH from the nix/store steam script, with some additions, launch the game binary

```{=html}
</div>
```
``` bash
LD_LIBRARY_PATH=~/.steam/bin32:$LD_LIBRARY_PATH:/nix/store/pfsa... blabla ...curl-7.29.0/lib:. ./Osmos.bin32 (if you could not patchelf the game, call ld.so directly with the binary as parameter)
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Note: If a game gets stuck on Installing scripts, check for a DXSETUP.EXE process and run it manually, then restart the
game launch.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Changing the driver on AMD GPUs {#changing_the_driver_on_amd_gpus}

```{=html}
</div>
```
```{=mediawiki}
{{note|This is not recommended because radv drivers tend to perform better and are generally more stable than amdvlk.}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Sometimes, changing the driver on AMD GPUs helps. To try this, first, install multiple drivers such as radv and amdvlk:

```{=html}
</div>
```
``` nix
hardware.graphics = {
  ## radv: an open-source Vulkan driver from freedesktop
  enable32Bit = true;

  ## amdvlk: an open-source Vulkan driver from AMD
  extraPackages = [ pkgs.amdvlk ];
  extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
};
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
In the presence of both drivers, [Steam](Steam "wikilink") will default to amdvlk. The amdvlk driver can be considered
more correct regarding Vulkan specification implementation, but less performant than radv. However, this tradeoff
between correctness and performance can sometimes make or break the gaming experience.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To \"reset\" your driver to radv when both radv and amdvlk are installed, set either `AMD_VULKAN_ICD = "RADV"` or
`VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"` environment variable. For example,
if you start [Steam](Steam "wikilink") from the shell, you can enable radv for the current session by running
`AMD_VULKAN_ICD="RADV" steam`. If you are unsure which driver you currently use, you can launch a game with
[MangoHud](https://github.com/flightlessmango/MangoHud) enabled, which has the capability to show what driver is
currently in use.

```{=html}
</div>
```
### SteamVR

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
The setcap issue at SteamVR start can be fixed with:
`sudo setcap CAP_SYS_NICE+ep ~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher`

```{=html}
</div>
```
`<span id="Gamescope_fails_to_launch_when_used_within_Steam">`{=html}`</span>`{=html}

### 与 Steam 使用时 Gamescope 无法启动 {#与_steam_使用时_gamescope_无法启动}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Gamescope may fail to start due to missing Xorg libraries. ([#214275](https://github.com/NixOS/nixpkgs/issues/214275))
To resolve this override the steam package to add them:

```{=html}
</div>
```
``` nix
programs.steam.package = pkgs.steam.override {
  extraPkgs = pkgs': with pkgs'; [
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXScrnSaver
    libpng
    libpulseaudio
    libvorbis
    stdenv.cc.cc.lib # Provides libstdc++.so.6
    libkrb5
    keyutils
    # Add other libraries as needed
  ];
};
```

`<span id="Udev_rules_for_additional_Gamepads">`{=html}`</span>`{=html}

### 额外游戏手柄的 udev 规则 {#额外游戏手柄的_udev_规则}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
In specific scenarios gamepads, might require some additional configuration in order to function properly in the form of
udev rules. This can be achieved with `services.udev.extraRules`.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
The following example is for the 8bitdo Ultimate Bluetooth controller, different controllers will require knowledge of
the vendor and product ID for the device:

```{=html}
</div>
```
``` nix
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="3106", MODE="0660", GROUP="input"
  '';
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To find the vendor and product ID of a device
[usbutils](https://search.nixos.org/packages?channel=unstable&show=usbutils&from=0&size=50&sort=relevance&type=packages&query=usbutils)
might be useful

```{=html}
</div>
```
`<span id="Known_issues">`{=html}`</span>`{=html}

### 已知问题

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
\"Project Zomboid\" may report \"couldn\'t determine 32/64 bit of java\". This is not related to java at all, it carries
its own outdated java binary that refuses to start if path contains non-Latin characters. Check for errors by directly
starting local java binary within `steam-run bash`.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Resetting your password through the [Steam](Steam "wikilink") app may fail at the CAPTCHA step repeatedly, with
[Steam](Steam "wikilink") itself reporting that the CAPTCHA was not correct, even though the CAPTCHA UI shows success.
Resetting password through the [Steam](Steam "wikilink") website should work around that.

```{=html}
</div>
```
`<span id="References">`{=html}`</span>`{=html}

## 参考

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

[^1]: <https://store.steampowered.com/>

[^2]: <https://github.com/ValveSoftware/steam-for-linux/issues/12207>

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

要在 shell 环境中临时使用 Steam 相关工具，例如 `steam-run`（用于 FHS 环境）或 `steamcmd`（用于服务器管理或 steam-tui
设置等工具），可以运行以下命令。

``` bash
nix-shell -p steam-run # For FHS environment
nix-shell -p steamcmd  # For steamcmd
```

这样就可以在当前 shell 中使用这些工具，而无需将其添加到系统配置中。为了使 `steamcmd` 能够正确执行某些任务（例如初始化
steam-tui），您可能需要运行一次 steamcmd 来生成必要的文件，如 \`steam-tui\` 部分所示。

`<span id="System_setup">`{=html}`</span>`{=html}

#### 系统设置

要安装 [Steam](Steam "wikilink") 软件包并启用所有必要的系统选项以使其运行，请将以下内容添加到您的
`/etc/nixos/configuration.nix` 中：

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

基本 Steam 功能可以直接在 `programs.steam` 属性集中启用：

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

如果您使用的是 Steam 控制器或 Valve Index，请确保已启用 Steam 硬件支持。这通常由 `programs.steam.enable = true;`
隐式地设置，该设置会同时启用 `hardware.steam-hardware.enable = true;` 。如有需要，您可以验证或显式地进行设置：

``` nix
hardware.steam-hardware.enable = true;
```

`<span id="Tips_and_tricks">`{=html}`</span>`{=html}

## 提示和技巧

`<span id="Gamescope_Compositor_/_&quot;Boot_to_Steam_Deck&quot;">`{=html}`</span>`{=html}

### Gamescope Compositor / \"启动至 Steam Deck\" {#gamescope_compositor_启动至_steam_deck}

Gamescope 可以作为最小桌面环境运行，这意味着您可以从 TTY 启动它，并获得与 Steam Deck 硬件控制台非常相似的体验。

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

如果您想使用 steam-tui 客户端，则需要自行安装。它依赖于 `steamcmd` 的设置，因此您需要运行一次 `steamcmd`
来生成必要的配置文件。 首先，确保 `steamcmd` 可用（例如，运行 `nix-shell -p steamcmd` 或将其添加到
`environment.systemPackages` ），然后运行：

``` bash
steamcmd +quit # This initializes steamcmd's directory structure
```

然后安装并运行 \`steam-tui\`。如果 \`steam-tui\` 出现问题，您可能需要先在 \`steamcmd\` 中登录：

``` bash
# (Inside steamcmd prompt, if needed for full login before steam-tui)
# login <username> <password> <steam_2fa_code>
# quit
```

安装完成后， `steam-tui` （例如通过 `home.packages` 或 `environment.systemPackages` 安装）应该可以正常启动。

`<span id="FHS_environment_only">`{=html}`</span>`{=html}

### 仅 FHS 环境 {#仅_fhs_环境}

要运行需要标准 Linux 文件系统层次结构标准 (FHS) 的专有游戏或从互联网下载的软件，可以使用 `steam-run` 。它提供了一个类似
FHS 的环境，而无需对软件进行任何修改。 请注意，对于从 Nixpkgs 安装的客户端（如 Minigalaxy 或
Itch），这并非必要，因为它们已经根据需要使用 FHS 环境。 有两种方法可以实现 `steam-run` 功能： 1. 安装 `steam-run`
，可选择系统级安装或用户级安装：

``` nix
# In /etc/nixos/configuration.nix
environment.systemPackages = with pkgs; [
  steam-run
];
```

2\. 如果您需要更大的灵活性，或者想要使用已覆盖的 Steam 包的 FHS 环境：

``` nix
# In /etc/nixos/configuration.nix
environment.systemPackages = with pkgs; [
  (steam.override { /* Your overrides here */ }).run
];
```

### Proton

您应该可以使用 Proton 运行大多数 Windows 游戏。如果某个游戏有原生 Linux 版本，但在 NixOS 上会出现问题，您可以通过在
Steam 的游戏兼容性设置中选择特定的 Proton 版本来强制使用 Proton。 默认情况下，Steam 还会在
`~/.steam/root/compatibilitytools.d` 中查找自定义 Proton 版本。可以通过设置环境变量 `STEAM_EXTRA_COMPAT_TOOLS_PATHS`
来添加其他搜索路径。 自定义 Proton 版本的声明式安装（例如 GE-Proton）：

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

在某些情况下，您可能需要覆盖默认的 Steam 程序包以提供缺失的依赖项或修改其构建。为此，请使用 `programs.steam.package`
选项。NixOS 上的 Steam 会在 FHS 环境下运行许多游戏，但 Steam 客户端本身或某些工具可能需要额外的库。 示例：添加 Bumblebee
和 Primus（适用于 NVIDIA Optimus）：

``` nix
programs.steam.package = pkgs.steam.override {
  extraPkgs = pkgs': with pkgs'; [ bumblebee primus ];
};

# For 32-bit applications with Steam, if using steamFull:
# programs.steam.package = pkgs.steamFull.override { extraPkgs = pkgs': with pkgs'; [ bumblebee primus ]; };
```

示例：为 Gamescope 添加 Xorg 库（在 Steam 中使用时）：

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

`<span id="Fix_missing_icons_for_games_in_GNOME_dock_and_activities_overview">`{=html}`</span>`{=html}

### 修复 GNOME Dock 栏和活动概览中游戏图标缺失的问题 {#修复_gnome_dock_栏和活动概览中游戏图标缺失的问题}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
GNOME uses the window class to determine the icon associated with a window. Steam currently doesn\'t set the required
key for this in its .desktop files[^2], but you can fix this manually by editing the `StartupWMClass` key for each
game\'s .desktop file, found under `~/.local/share/applications/`.

```{=html}
</div>
```
对于通过 Proton 运行的游戏，该值应为 `steam_app_``<game_id>`{=html} （在哪里`<game_id>`{=html}与 `Exec` 行中
<steam://rungameid/> 之后的值匹配）。

对于原生运行的游戏，该值应与游戏的主可执行文件匹配。

例如，Valheim 的修改后的 .desktop 文件如下所示：

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

对于所有问题：首先通过终端运行 `steam -dev -console` 并读取输出。

`<span id="Steam_fails_to_start._What_do_I_do?">`{=html}`</span>`{=html}

### Steam 无法启动。我该怎么办？ {#steam_无法启动我该怎么办}

在终端运行 `strace steam -dev -console 2> steam.logs` 命令。如果未安装 `strace` ，请使用 `nix-shell -p strace` 或
`nix run nixpkgs#strace -- steam -dev -console 2> steam.logs` （如果使用 Flakes 版本）临时安装。之后，请提交错误报告。

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

游戏可能无法启动，原因可能是缺少依赖项（目前应将此添加到脚本中），或者无法进行补丁更新。直接启动游戏的步骤如下：
如果可以，请修补脚本/二进制文件。

-   在二进制文件夹中添加一个名为 steam_appid.txt 的文件，内容为 appid（可在 Steam 的标准输出中找到）。
-   使用来自 nix/store steam 脚本的 LD_LIBRARY_PATH，启动游戏二进制文件

``` bash
LD_LIBRARY_PATH=~/.steam/bin32:$LD_LIBRARY_PATH:/nix/store/pfsa... blabla ...curl-7.29.0/lib:. ./Osmos.bin32 (if you could not patchelf the game, call ld.so directly with the binary as parameter)
```

注意：如果游戏卡在"正在安装脚本"界面，请检查是否存在 DXSETUP.EXE 进程并手动运行它，然后重新启动游戏。

`<span id="Changing_the_driver_on_AMD_GPUs">`{=html}`</span>`{=html}

#### 更改 AMD GPU 的驱动程序 {#更改_amd_gpu_的驱动程序}

```{=mediawiki}
{{note|This is not recommended because radv drivers tend to perform better and are generally more stable than amdvlk.}}
```
有时，更换 AMD GPU 的驱动程序会有帮助。要尝试此方法，首先，安装多个驱动程序，例如 radv 和 amdvlk：

``` nix
hardware.graphics = {
  ## radv: an open-source Vulkan driver from freedesktop
  enable32Bit = true;

  ## amdvlk: an open-source Vulkan driver from AMD
  extraPackages = [ pkgs.amdvlk ];
  extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
};
```

如果两个驱动程序都存在，[Steam](Steam "wikilink") 将默认使用 amdvlk。amdvlk 驱动程序在 Vulkan
规范实现方面更准确，但性能不如 radv。然而，这种在正确性和性能之间的权衡有时会直接影响游戏体验。 如果同时安装了 radv 和
amdvlk，要将驱动程序"重置"为 radv，请设置环境变量 `AMD_VULKAN_ICD = "RADV"` 或
`VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"` 。例如，如果您从 shell 启动
Steam，则可以通过运行 `AMD_VULKAN_ICD="RADV" steam` 为当前会话启用
radv。如果您不确定当前使用的是哪个驱动程序，可以启动一个启用了 MangoHud 的游戏，MangoHud
可以显示当前正在使用的驱动程序。

### SteamVR

SteamVR 启动时的 setcap 问题可以通过以下方法解决：
`sudo setcap CAP_SYS_NICE+ep ~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher`
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

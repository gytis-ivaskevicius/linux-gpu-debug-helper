`<languages/>`{=html} [Steam](https://store.steampowered.com/)
是一个数字游戏发行平台，提供庞大的游戏库供用户购买、下载和管理。在 NixOS 系统上，Steam
通常易于安装和使用，很多时候都能"开箱即用"。它通过兼容层 [Proton](#Proton "wikilink") 支持在 Linux 上运行许多 Windows
游戏。[^1]

`<span id="Installation">`{=html}`</span>`{=html}

## 安装

#### Shell

要在 shell 环境中临时使用 Steam 相关工具，例如 `steam-run`（用于 FHS 环境）或 `steamcmd`（用于服务器管理或 steam-tui
设置等工具），可以运行以下命令。

``` console
$ nix-shell -p steam-run # For FHS environment
$ nix-shell -p steamcmd  # For steamcmd
```

这样就可以在当前 shell 中使用这些工具，而无需将其添加到系统配置中。为了使 `steamcmd` 能够正确执行某些任务（例如初始化
steam-tui），您可能需要运行一次 steamcmd 来生成必要的文件，如 [ steam-tui](#steam-tui "wikilink") 部分所示。

`<span id="System_setup">`{=html}`</span>`{=html}

#### 系统设置

要安装 [Steam](Special:MyLanguage/Steam "wikilink")
软件包并启用所有必要的系统选项以使其运行，请将以下内容添加到您的系统配置中：

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|
<nowiki>
programs.steam = {
  enable = true;
};

# Optional: If you encounter amdgpu issues with newer kernels (e.g., 6.10+ reported issues),
# you might consider using the LTS kernel or a known stable version.
# boot.kernelPackages = pkgs.linuxPackages_lts; # Example for LTS
</nowiki>
}}
```
[关于内核 6.10 问题的轶事](https://news.ycombinator.com/item?id=41549030)

```{=mediawiki}
{{note|1=启用 [[Special:MyLanguage/Steam|Steam]] 会安装多个[[Special:MyLanguage/unfree software|非自由软件包]]。如果您使用了 <code>allowUnfreePredicate</code>，则需要确保您的配置允许安装所有这些软件包。

<syntaxhighlight lang="nix">
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
  ];
</syntaxhighlight>}}
```
`<span id="Configuration">`{=html}`</span>`{=html}

## 配置

基本 Steam 功能可以直接在 `{{nixos:option|programs.steam}}`{=mediawiki} 属性集中启用：

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|
<nowiki>
programs.steam = {
  enable = true; # Master switch, already covered in installation
  remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
  # Other general flags if available can be set here.
};
# Tip: For improved gaming performance, you can also enable GameMode:
# programs.gamemode.enable = true;
</nowiki>
}}
```
```{=mediawiki}
{{note|如果您使用的是 Steam 控制器或 Valve Index，Steam 硬件支持会通过设置 <code>programs.steam.enable {{=}}
```
true;`</code>`{=html} 将`{{nixos:option|hardware.steam-hardware.enable}}`{=mediawiki} 选项同步设置为 true 来隐性启用}}

`<span id="Tips_and_tricks">`{=html}`</span>`{=html}

## 提示和技巧

`<span id="Gamescope_Compositor_/_&quot;Boot_to_Steam_Deck&quot;">`{=html}`</span>`{=html}

### Gamescope Compositor / \"启动至 Steam Deck\" {#gamescope_compositor_启动至_steam_deck}

Gamescope 可以作为最小桌面环境运行，这意味着您可以从 TTY 启动它，并获得与 Steam Deck 硬件控制台非常相似的体验。

``` nix
# Clean Quiet Boot
boot = {
  kernelParams = [
    "quiet"
    "splash"
    "console=/dev/null"
  ];
  plymouth.enable = true;
};

programs = {
  gamescope = {
    enable = true;
    capSysNice = true;
  };
  steam.gamescopeSession.enable = true;
};

# Gamescope Auto Boot from TTY (example)
services = {
  xserver.enable = false; # Assuming no other Xserver needed
  getty.autologinUser = <"USERNAME_HERE">;
  greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.gamescope} -W 1920 -H 1080 -f -e --xwayland-count 2 --hdr-enabled --hdr-itm-enabled -- steam -pipewire-dmabuf -gamepadui -steamdeck -steamos3 > /dev/null 2>&1";
        user = <"USERNAME HERE">;
      };
    };
  };
};
```

### Gamescope HDR {#gamescope_hdr}

要使 HDR 在 gamescope 中工作，您需要在启用 `gamescope` 程序的同时，单独安装 `gamescope-wsi` 软件包。

``` nix
programs.gamescope = {
  enable = true;
  capSysNice = false;
};
environment.systemPackages = with pkgs; [
  gamescope-wsi # HDR won't work without this
];
```

此外，在 Steam 中配置游戏启动选项时，可能需要使用参数 `--hdr-debug-force-output` 以在 gamescope 中强制启用
HDR（参考以下示例）。

``` bash
gamescope -W 3840 -H 2160 -r 120 -f --adaptive-sync --hdr-enabled --hdr-debug-force-output --mangoapp -- %command%
```

### steam-tui {#steam_tui}

如果您想使用 steam-tui 客户端，则需要自行安装。它依赖于 `steamcmd` 的设置，因此您需要运行一次 `steamcmd`
来生成必要的配置文件。 首先，确保 `steamcmd` 可用（例如，运行 `nix-shell -p steamcmd` 或将其添加到
`environment.systemPackages` ），然后运行：

``` bash
steamcmd +quit # This initializes steamcmd's directory structure
```

然后安装并运行 `steam-tui`。如果 `steamcmd` 出现问题，您可能需要先在 `steam-tui` 中登录：

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
Steam 的游戏兼容性设置中选择特定的 Proton 版本来强制使用 Proton。

默认情况下，Steam 还会在 `~/.steam/root/compatibilitytools.d` 中查找自定义 Proton 版本。可以通过设置环境变量
`STEAM_EXTRA_COMPAT_TOOLS_PATHS` 来添加其他搜索路径。

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

在某些情况下，您可能需要覆盖默认的 Steam 程序包以提供缺失的依赖项或修改其构建。为此，请使用 `programs.steam.package`
选项。NixOS 上的 Steam 会在 FHS 环境下运行许多游戏，但 Steam 客户端本身或某些工具可能需要额外的库。

示例：添加 Bumblebee 和 Primus（适用于 NVIDIA Optimus）：

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
    libXcursor
    libXi
    libXinerama
    libXScrnSaver
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

GNOME 使用窗口类来确定与窗口关联的图标。Steam 目前在其 .desktop 文件中没有设置所需的键值[^2]，但您可以通过编辑每个游戏的
.desktop 文件中的 `StartupWMClass` 键值来手动修复此问题，该文件位于 `~/.local/share/applications/` 目录下。

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

至少在 `x86-64` 平台上，导致 Steam 无法启动的一个常见问题是未在 `/etc/nixos/hardware-configuration.nix`
文件中启用以下选项：

``` nix
 {
   hardware.graphics.enable = true;
   hardware.graphics.enable32Bit = true;
 }
```

如果您已设置这些选项（或者 32 位不适用于您的系统/平台），但仍然无法运行 Steam，请在终端运行
`strace steam -dev -console 2> steam.logs` 命令。如果未安装 `strace` ，请使用 `nix-shell -p strace` 或
`nix run nixpkgs#strace -- steam -dev -console 2> steam.logs` （如果使用 Flakes 版本）临时安装。之后，请提交错误报告。

`<span id="Steam_is_not_updated">`{=html}`</span>`{=html}

### Steam 未更新 {#steam_未更新}

更新后重启 [Steam](Special:MyLanguage/Steam "wikilink")
时，它会启动旧版本。([#181904](https://github.com/NixOS/nixpkgs/issues/181904)) 一个解决方法是删除
`/home/<USER>/.local/share/Steam/userdata` 目录下的用户文件。您可以在终端中使用
`rm -rf /home/<USER>/.local/share/Steam/userdata` 命令或文件管理器来完成此操作。之后，重启 Steam 即可重新生成配置。

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
{{note|不建议这样做，因为 radv 驱动程序往往性能更好，而且通常比 amdvlk 驱动程序更稳定。}}
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

如果两个驱动程序都存在，[Steam](Special:MyLanguage/Steam "wikilink") 将默认使用 amdvlk。amdvlk 驱动程序在 Vulkan
规范实现方面更准确，但性能不如 radv。然而，这种在正确性和性能之间的权衡有时会直接影响游戏体验。

如果同时安装了 radv 和 amdvlk，要将驱动程序"重置"为 radv，请设置环境变量 `AMD_VULKAN_ICD = "RADV"` 或
`VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"` 。例如，如果您从 shell 启动
Steam，则可以通过运行 `AMD_VULKAN_ICD="RADV" steam` 为当前会话启用
radv。如果您不确定当前使用的是哪个驱动程序，可以启动一个启用了 [MangoHud](https://github.com/flightlessmango/MangoHud)
的游戏，MangoHud 可以显示当前正在使用的驱动程序。

### SteamVR

SteamVR 启动时的 setcap 问题可以通过以下方法解决：
`sudo setcap CAP_SYS_NICE+ep ~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher`

`<span id="Gamescope_fails_to_launch_when_used_within_Steam">`{=html}`</span>`{=html}

### 与 Steam 使用时 Gamescope 无法启动 {#与_steam_使用时_gamescope_无法启动}

Gamescope 可能由于缺少 Xorg 库而无法启动。([#214275](https://github.com/NixOS/nixpkgs/issues/214275))
要解决此问题，请添加以下内容覆盖 steam 包：

``` nix
programs.steam.package = pkgs.steam.override {
  extraPkgs = pkgs': with pkgs'; [
    libXcursor
    libXi
    libXinerama
    libXScrnSaver
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

在某些特定情况下，游戏手柄可能需要一些额外的配置才能正常工作，这些配置以 udev 规则的形式表示。这可以通过
`services.udev.extraRules` 来配置。

以下示例适用于 8bitdo Ultimate 蓝牙控制器，不同的控制器需要知道设备的供应商和产品 ID：

``` nix
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="3106", MODE="0660", GROUP="input"
  '';
```

要查找设备的供应商和产品
ID，[usbutils](https://search.nixos.org/packages?channel=unstable&show=usbutils&from=0&size=50&sort=relevance&type=packages&query=usbutils)
可能有用。

`<span id="Known_issues">`{=html}`</span>`{=html}

### 已知问题

"Project
Zomboid"可能会报告"无法确定Java是32位还是64位"。这与Java本身无关，是由其使用自身过时的Java二进制文件解析路径时，其中包含非拉丁字符导致的。请通过在`steam-run bash`中直接启动本地Java二进制文件来解决错误。

通过 [Steam](Special:MyLanguage/Steam "wikilink")
应用重置密码可能会反复在验证码环节失败，即使验证码界面显示成功，[Steam](Special:MyLanguage/Steam "wikilink")
本身也会提示验证码错误。通过 [Steam](Special:MyLanguage/Steam "wikilink") 网站重置密码应该可以解决这个问题。

`<span id="References">`{=html}`</span>`{=html}

## 参考

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

[^1]: <https://store.steampowered.com/>

[^2]: <https://github.com/ValveSoftware/steam-for-linux/issues/12207>

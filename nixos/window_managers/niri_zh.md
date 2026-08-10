`<languages/>`{=html} `{{DISPLAYTITLE:niri}}`{=mediawiki} `{{infobox application
| name = niri
| type = Wayland compositor
| initialRelease = 2023-11-26
| status = Active
| license = GNU General Public License v3.0 only
| os = Linux, FreeBSD
| programmingLanguage = Rust, GLSL
| github = niri-wm/niri
| documentation = [https://niri-wm.github.io/niri/ Official wiki], [https://github.com/sodiboo/niri-flake/blob/main/docs.md niri-flake]
| image = Niri-icon.svg
| bugTracker = https://github.com/niri-wm/niri/issues
| latestRelease = 26.04; 25 Apr 2026
}}`{=mediawiki}

[Niri](https://github.com/niri-wm/niri) 是一个可滚动平铺的 [Wayland](Special:MyLanguage/Wayland "wikilink") 合成器。

`<span id="Installation">`{=html}`</span>`{=html}

## 安装

只需启用 `{{nixos:option|programs.niri}}`{=mediawiki}：

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
programs.niri.enable = true;
}}
```
```{=mediawiki}
{{Note|<strong>无需安装自定义 flake</strong>（例如 [https://github.com/sodiboo/niri-flake niri-flake]）即可启用 Niri。尽管截至 2025 年，该存储库在搜索引擎中的排名仍然靠前，但只有当您想要使用最新版本的 Niri 或想要用 Nix 语言编写配置时，才需要 {{ic|niri-flake}}。}}
```
```{=mediawiki}
{{Warning|如果没有进行 [[#Configuration|配置]] 或 [[#Additional Setup|附加设置]]，或者在全新安装后，您可能由于缺少 Alacritty 和 fuzzel 等预期程序而无法启动应用程序。请按 <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd> 退出 niri 并继续执行其中一项操作。}}
```
`<span id="Configuration">`{=html}`</span>`{=html}

## 配置

niri 的配置路径为 `{{ic|$XDG_CONFIG_HOME/niri/config.kdl}}`{=mediawiki}。因此，可以使用 [Home
Manager](Special:MyLanguage/Home_Manager "wikilink") 进行配置：

```{=mediawiki}
{{file|~/.config/home-manager/home.nix|nix|3=
xdg.configFile."niri/config.kdl".source = ./config.kdl;
}}
```
如果您希望在构建过程中对配置进行验证，可以使用 `{{ic|pkgs.runCommand}}`{=mediawiki}，用法如下：

```{=mediawiki}
{{file|~/.config/home-manager/home.nix|nix|3=
xdg.configFile."niri/config.kdl".source =
  pkgs.runCommand "niri-config-checked"
    {
      nativeBuildInputs = [ pkgs.niri ];
    }
    ''
      niri validate --config ${./config.kdl}
      cp ${./config.kdl} $out
    '';
}}
```
您可能想从[默认配置文件](https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl)开始，如[这里](https://github.com/niri-wm/niri/wiki/Getting-Started#main-default-hotkeys)所述。

有关 niri 的配置选项，请参阅 [此 wiki](https://niri-wm.github.io/niri/)。

### Greetd

您可以使用 greeted 配置启动 niri：

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
programs.niri.enable = true;

services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${config.programs.niri.package}/bin/niri-session";
      user = "myuser";
    };
  };
};

# NixOS otherwise injects a stripped PATH via Environment= on the niri.service
# unit which shadows the imported user-manager PATH. Disabling the default
# lets niri inherit the full PATH set up by niri-session.
systemd.user.services.niri.enableDefaultPath = false;

}}
```
`<span id="Additional_Setup">`{=html}`</span>`{=html}

## 额外设置

如[示例 systemd 设置 (niri
wiki)](https://github.com/niri-wm/niri/wiki/Example-systemd-Setup)中所述，您可能需要设置一些额外的服务，包括以下的
[Swayidle](Special:MyLanguage/Swayidle "wikilink")、[Swaylock](Special:MyLanguage/Swaylock "wikilink")、[Waybar](Special:MyLanguage/Waybar "wikilink")、[Polkit](Special:MyLanguage/Polkit "wikilink")
和 [Secret
Service](Special:MyLanguage/Secret_Service "wikilink")，以补充常规窗口管理器的功能。其中一些设置也是启用[默认配置文件](https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl)所有功能所必需的。

```{=mediawiki}
{{file|3=
security.polkit.enable = true; # polkit
services.gnome.gnome-keyring.enable = true; # secret service
security.pam.services.swaylock = {};

programs.waybar.enable = true; # top bar
environment.systemPackages = with pkgs; [ alacritty fuzzel swaylock mako swayidle ];
|name=/etc/nixos/configuration.nix|lang=nix}}
```
或者使用 [Home Manager](Special:MyLanguage/Home_Manager "wikilink")：

```{=mediawiki}
{{file|~/.config/home-manager/home.nix|nix|3=
programs.alacritty.enable = true; # Super+T in the default setting (terminal)
programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
programs.waybar.enable = true; # launch on startup in the default setting (bar)
services.mako.enable = true; # notification daemon
services.swayidle.enable = true; # idle management daemon
services.polkit-gnome.enable = true; # polkit
home.packages = with pkgs; [
  swaybg # wallpaper
];
|name=~/.config/home-manager/home.nix|lang=nix}}
```
`<span id="Troubleshooting">`{=html}`</span>`{=html}

## 故障排除

`<span id="IME_not_working_on_Electron_apps">`{=html}`</span>`{=html}

### IME 在 Electron 应用中无法正常工作 {#ime_在_electron_应用中无法正常工作}

有一种通用的解决方法，即按照[Wayland#Electron_and_Chromium](Special:MyLanguage/Wayland#Electron_and_Chromium "wikilink")中的说明设置`{{ic|NIXOS_OZONE_WL}}`{=mediawiki}：

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
environment.sessionVariables.NIXOS_OZONE_WL = "1";
}}
```
然而，由于 niri 不支持 text-input-v1，有时需要通过手动添加
`{{ic|<nowiki>--wayland-text-input-version=3</nowiki>}}`{=mediawiki} 标志来启用 text-input-v3，IME 才能正常工作：

``` console
$ slack --wayland-text-input-version=3
```

`wrapProgram` 可用于自动添加该标志：

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
environment.systemPackages = [
  (pkgs.symlinkJoin {
    pname = pkgs.vscode.pname;
    paths = [ pkgs.vscode ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = "wrapProgram $out/bin/code --add-flags --wayland-text-input-version=3";
  };)
];}}
```
`<span id="XWayland_apps_not_working">`{=html}`</span>`{=html}

### XWayland 应用无法正常工作 {#xwayland_应用无法正常工作}

Niri 有一个可选依赖，强烈建议安装（您可阅读 [这篇文章](https://github.com/niri-wm/niri/wiki/Xwayland)
以了解更多相关信息）。

```{=mediawiki}
{{File|3=environment.systemPackages = with pkgs; [ 
    xwayland-satellite # xwayland support
];|name=/etc/nixos/configuration.nix|lang=nix}}
```
或者使用 [Home Manager](Special:MyLanguage/Home_Manager "wikilink")

```{=mediawiki}
{{File|3=home.packages = with pkgs; [
  xwayland-satellite # xwayland support
];|name=~/.config/home-manager/home.nix|lang=nix}}
```
安装 `{{ic|xwayland-satellite}}`{=mediawiki} 后，niri 将会将其无缝集成，您的所有 XWayland 应用都将正常运行。

`<span id="File_picker_not_working">`{=html}`</span>`{=html}

### 文件选择器无法正常工作

如果您正在使用 `xdg-desktop-portal-gnome`，它会尝试将 Nautilus 用作文件选择器，但如果未安装 Nautilus，则会失败。

为解决此问题，您可以改为强制使用 GTK 或 KDE 的文件选择器门户：

```{=mediawiki}
{{File|3=xdg.portal.config.niri = {
  "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
};|name=/etc/nixos/configuration.nix|lang=nix}}
```
`<span id="Waybar_launches_twice">`{=html}`</span>`{=html}

### Waybar 启动两次 {#waybar_启动两次}

在使用诸如 programs.waybar.enable 这样的配置选项时，waybar 在 Niri 上可能会启动两次。这是因为[默认的 Niri
配置文件会在系统启动时自动启动
waybar](https://github.com/niri-wm/niri/blob/b07bde3ee82dd73115e6b949e4f3f63695da35ea/resources/default-config.kdl#L271)。请从该配置文件中移除
spawn-at-startup \"waybar\" 的设置，或者在不使用 home-manager 选项的情况下，将 waybar 添加到系统的软件包列表中。

`<span id="See_Also">`{=html}`</span>`{=html}

## 另见

-   [Wayland](Special:MyLanguage/Wayland "wikilink")
-   [Sway](Special:MyLanguage/Sway "wikilink")
-   [用于 Wayland 的壁纸](Special:MyLanguage/Wallpapers_for_Wayland "wikilink")
-   [niri-flake](https://github.com/sodiboo/niri-flake/)

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications{{#translation:}}](Category:Applications{{#translation:}} "wikilink")

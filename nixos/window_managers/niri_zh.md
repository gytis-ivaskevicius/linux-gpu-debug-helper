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

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
There is a general workaround to set `{{ic|NIXOS_OZONE_WL}}`{=mediawiki} as described in
[Wayland#Electron_and_Chromium](Special:MyLanguage/Wayland#Electron_and_Chromium "wikilink"):

```{=html}
</div>
```
```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
environment.sessionVariables.NIXOS_OZONE_WL = "1";
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
However, since niri does not support text-input-v1, sometimes enabling text-input-v3 by manually adding
`{{ic|<nowiki>--wayland-text-input-version=3</nowiki>}}`{=mediawiki} flag is necessary for IME to work:

```{=html}
</div>
```
``` console
$ slack --wayland-text-input-version=3
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
`wrapProgram` may be used to add the flag automatically:

```{=html}
</div>
```
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

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
There is a optional dependency for niri which is highly recommended to install (you can read
[this](https://github.com/niri-wm/niri/wiki/Xwayland) article to learn more about this)

```{=html}
</div>
```
```{=mediawiki}
{{File|3=environment.systemPackages = with pkgs; [ 
    xwayland-satellite # xwayland support
];|name=/etc/nixos/configuration.nix|lang=nix}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Or using [Home Manager](Special:MyLanguage/Home_Manager "wikilink")

```{=html}
</div>
```
```{=mediawiki}
{{File|3=home.packages = with pkgs; [
  xwayland-satellite # xwayland support
];|name=~/.config/home-manager/home.nix|lang=nix}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
After you installed `{{ic|xwayland-satellite}}`{=mediawiki} niri will integrate it out of the box and all of your
XWayland apps will function properly.

```{=html}
</div>
```
`<span id="File_picker_not_working">`{=html}`</span>`{=html}

### 文件选择器无法正常工作

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
If you are using `xdg-desktop-portal-gnome`, it will attempt to use Nautilus as the file picker, which will fail if
Nautilus is not installed.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To work around this problem, you can force usage of the gtk or kde portals for file picker instead:

```{=html}
</div>
```
```{=mediawiki}
{{File|3=xdg.portal.config.niri = {
  "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
};|name=/etc/nixos/configuration.nix|lang=nix}}
```
`<span id="Waybar_launches_twice">`{=html}`</span>`{=html}

### Waybar 启动两次 {#waybar_启动两次}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
When using a configuration option like programs.waybar.enable, waybar may launch twice on Niri. This is because the
[default Niri config file launches waybar on
launch](https://github.com/niri-wm/niri/blob/b07bde3ee82dd73115e6b949e4f3f63695da35ea/resources/default-config.kdl#L271).
Remove the spawn-at-startup \"waybar\" from the config file, or add waybar to your systems packages without using the
home-manager option.

```{=html}
</div>
```
`<span id="See_Also">`{=html}`</span>`{=html}

## 另见

-   [Wayland](Special:MyLanguage/Wayland "wikilink")
-   [Sway](Special:MyLanguage/Sway "wikilink")
-   [用于 Wayland 的壁纸](Special:MyLanguage/Wallpapers_for_Wayland "wikilink")
-   [niri-flake](https://github.com/sodiboo/niri-flake/)

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications{{#translation:}}](Category:Applications{{#translation:}} "wikilink")

```{=mediawiki}
{{infobox application
| name = Niri
| type = Wayland compositor
| initialRelease = 2023-11-26
| status = Active
| license = GNU General Public License v3.0 only
| os = Linux, FreeBSD
| programmingLanguage = Rust, GLSL
| github = YaLTeR/niri
| documentation = [https://github.com/YaLTeR/niri/wiki Official wiki], [https://github.com/sodiboo/niri-flake/blob/main/docs.md niri-flake]
| image = Niri-icon.svg
| bugTracker = https://github.com/YaLTeR/niri/issues
| latestRelease = 25.11; 29 Nov 2025
}}
```
[Niri](https://github.com/YaLTeR/niri) is a scrollable-tiling [Wayland](Wayland "wikilink") compositor.

## Installation

Simply enable `{{nixos:option|programs.niri}}`{=mediawiki}:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
programs.niri.enable = true;
}}
```
```{=mediawiki}
{{Note|Niri can be enabled <strong>without installing a custom flake</strong> such as [https://github.com/sodiboo/niri-flake niri-flake]. {{ic|niri-flake}} is only necessary if you want to use a very recent version of Niri or if you want to write configurations in the Nix language, although as of 2025 this repository is listed near the top in search engines.}}
```
```{=mediawiki}
{{Warning|Without [[#Configuration]] or [[#Additional Setup]], or in other words after fresh installation, you may be unable to launch apps because of missing Alacritty and fuzzel. Press <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd> to exit Niri and proceed to one of them.}}
```
## Configuration

The configuration path for Niri is `{{ic|$XDG_CONFIG_HOME/niri/config.kdl}}`{=mediawiki}. Therefore [Home
Manager](Home_Manager "wikilink") can be used for configuration:

```{=mediawiki}
{{file|~/.config/home-manager/home.nix|nix|3=
xdg.configFile."niri/config.kdl".source = ./config.kdl;
}}
```
You might want to start from [the default configuration
file](https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl) described at
[1](https://github.com/YaLTeR/niri/wiki/Getting-Started#main-default-hotkeys).

See [the wiki](https://github.com/YaLTeR/niri/wiki) for configuration options for Niri.

## Additional Setup {#additional_setup}

As described in [Example systemd Setup (Niri wiki)](https://github.com/YaLTeR/niri/wiki/Example-systemd-Setup), you
might want to set up some additional services including [Swayidle](Swayidle "wikilink"),
[Swaylock](Swaylock "wikilink"), [Waybar](Waybar "wikilink"), [Polkit](Polkit "wikilink") and [Secret
Service](Secret_Service "wikilink") as follows to complement the functionality of a regular window manager. Some of the
these settings are also required to enable all the features of [the default configuration
file](https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl).

```{=mediawiki}
{{file|3=
security.polkit.enable = true; # polkit
services.gnome.gnome-keyring.enable = true; # secret service
security.pam.services.swaylock = {};

programs.waybar.enable = true; # top bar
environment.systemPackages = with pkgs; [ alacritty fuzzel swaylock mako swayidle ]
|name=/etc/nixos/configuration.nix|lang=nix}}
```
Or using [Home Manager](Home_Manager "wikilink"):`{{file|~/.config/home-manager/home.nix|nix|3=
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
|name=~/.config/home-manager/home.nix|lang=nix}}`{=mediawiki}

## Troubleshooting

### IME not working on Electron apps {#ime_not_working_on_electron_apps}

There is a general workaround to set `{{ic|NIXOS_OZONE_WL}}`{=mediawiki} as described in
[Wayland#Electron_and_Chromium](Wayland#Electron_and_Chromium "wikilink"):

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
environment.sessionVariables.NIXOS_OZONE_WL = "1";
}}
```
However, since Niri does not support text-input-v1, sometimes enabling text-input-v3 by manually adding
`{{ic|<nowiki>--wayland-text-input-version=3</nowiki>}}`{=mediawiki} flag is necessary for IME to work:

```{=mediawiki}
{{code|<nowiki>slack --wayland-text-input-version=3</nowiki>}}
```
Alternatively, if the package supports `{{ic|commandLineArgs}}`{=mediawiki}, the following may be used instead:

```{=mediawiki}
{{code|<nowiki>(pkgs.vscode.override {
  commandLineArgs = [
    "--wayland-text-input-version=3"
  ];
});</nowiki>}}
```
### XWayland apps not working {#xwayland_apps_not_working}

There is a optional dependency for Niri which is highly recommended to install (you can read
[this](https://github.com/YaLTeR/niri/wiki/Xwayland) article to learn more about this)

```{=mediawiki}
{{File|3=environment.systemPackages = with pkgs; [ 
    xwayland-satellite # xwayland support
];|name=❄︎ /etc/nixos/configuration.nix|lang=Nix}}
```
Or using [Home Manager](Home_Manager "wikilink")

```{=mediawiki}
{{File|3=home.packages = with pkgs; [
  xwayland-satellite # xwayland support
];|name=❄︎ ~/.config/home-manager/home.nix|lang=Nix}}
```
After you installed `{{ic|xwayland-satellite}}`{=mediawiki} Niri will integrate it out of the box and all of your
XWayland apps will function properly.

## See Also {#see_also}

-   [Wayland](Wayland "wikilink")
-   [Sway](Sway "wikilink")
-   [Wallpapers for Wayland](Wallpapers_for_Wayland "wikilink")
-   [niri-flake](https://github.com/sodiboo/niri-flake/)

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications](Category:Applications "wikilink")

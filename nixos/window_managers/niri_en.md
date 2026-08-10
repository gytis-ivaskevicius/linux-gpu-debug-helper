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

[Niri](https://github.com/niri-wm/niri) is a scrollable-tiling [Wayland](Special:MyLanguage/Wayland "wikilink")
compositor.

## Installation

Simply enable `{{nixos:option|programs.niri}}`{=mediawiki}:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
programs.niri.enable = true;
}}
```
```{=mediawiki}
{{Note|Niri can be enabled <strong>without installing a custom flake</strong> such as [https://github.com/sodiboo/niri-flake niri-flake]. {{ic|niri-flake}} is only necessary if you would like to use a very recent version of Niri or if you would want to write configurations in the Nix language, although as of 2025 this repository is listed near the top in search engines.}}
```
```{=mediawiki}
{{Warning|Without [[#Configuration|Configuration]] or [[#Additional Setup|Additional Setup]], or after a fresh installation, you may be unable to launch apps due to missing expected programs such as Alacritty and fuzzel. Press <kbd>Super</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd> to exit niri and proceed to one of them.}}
```
## Configuration

The configuration path for niri is `{{ic|$XDG_CONFIG_HOME/niri/config.kdl}}`{=mediawiki}. Therefore [Home
Manager](Special:MyLanguage/Home_Manager "wikilink") can be used for configuration:

```{=mediawiki}
{{file|~/.config/home-manager/home.nix|nix|3=
xdg.configFile."niri/config.kdl".source = ./config.kdl;
}}
```
If you want to validate your configuration as part of the build process you can use `{{ic|pkgs.runCommand}}`{=mediawiki}
like this:

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
You might want to start from [the default configuration
file](https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl) described at
[here](https://github.com/niri-wm/niri/wiki/Getting-Started#main-default-hotkeys).

See [the wiki](https://niri-wm.github.io/niri/) for configuration options for niri.

### Greetd

You can start niri with greetd configuration:

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
## Additional Setup {#additional_setup}

As described in [Example systemd Setup (niri wiki)](https://github.com/niri-wm/niri/wiki/Example-systemd-Setup), you
might want to set up some additional services including [Swayidle](Special:MyLanguage/Swayidle "wikilink"),
[Swaylock](Special:MyLanguage/Swaylock "wikilink"), [Waybar](Special:MyLanguage/Waybar "wikilink"),
[Polkit](Special:MyLanguage/Polkit "wikilink") and [Secret Service](Special:MyLanguage/Secret_Service "wikilink") as
follows to complement the functionality of a regular window manager. Some of the these settings are also required to
enable all the features of [the default configuration
file](https://github.com/niri-wm/niri/blob/main/resources/default-config.kdl).

```{=mediawiki}
{{file|3=
security.polkit.enable = true; # polkit
services.gnome.gnome-keyring.enable = true; # secret service
security.pam.services.swaylock = {};

programs.waybar.enable = true; # top bar
environment.systemPackages = with pkgs; [ alacritty fuzzel swaylock mako swayidle ];
|name=/etc/nixos/configuration.nix|lang=nix}}
```
Or using [Home Manager](Special:MyLanguage/Home_Manager "wikilink"):

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
## Troubleshooting

### IME not working on Electron apps {#ime_not_working_on_electron_apps}

There is a general workaround to set `{{ic|NIXOS_OZONE_WL}}`{=mediawiki} as described in
[Wayland#Electron_and_Chromium](Special:MyLanguage/Wayland#Electron_and_Chromium "wikilink"):

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=
environment.sessionVariables.NIXOS_OZONE_WL = "1";
}}
```
However, since niri does not support text-input-v1, sometimes enabling text-input-v3 by manually adding
`{{ic|<nowiki>--wayland-text-input-version=3</nowiki>}}`{=mediawiki} flag is necessary for IME to work:

``` console
$ slack --wayland-text-input-version=3
```

`wrapProgram` may be used to add the flag automatically:

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
### XWayland apps not working {#xwayland_apps_not_working}

There is a optional dependency for niri which is highly recommended to install (you can read
[this](https://github.com/niri-wm/niri/wiki/Xwayland) article to learn more about this)

```{=mediawiki}
{{File|3=environment.systemPackages = with pkgs; [ 
    xwayland-satellite # xwayland support
];|name=/etc/nixos/configuration.nix|lang=nix}}
```
Or using [Home Manager](Special:MyLanguage/Home_Manager "wikilink")

```{=mediawiki}
{{File|3=home.packages = with pkgs; [
  xwayland-satellite # xwayland support
];|name=~/.config/home-manager/home.nix|lang=nix}}
```
After you installed `{{ic|xwayland-satellite}}`{=mediawiki} niri will integrate it out of the box and all of your
XWayland apps will function properly.

### File picker not working {#file_picker_not_working}

If you are using `xdg-desktop-portal-gnome`, it will attempt to use Nautilus as the file picker, which will fail if
Nautilus is not installed.

To work around this problem, you can force usage of the gtk or kde portals for file picker instead:

```{=mediawiki}
{{File|3=xdg.portal.config.niri = {
  "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
};|name=/etc/nixos/configuration.nix|lang=nix}}
```
### Waybar launches twice {#waybar_launches_twice}

When using a configuration option like programs.waybar.enable, waybar may launch twice on Niri. This is because the
[default Niri config file launches waybar on
launch](https://github.com/niri-wm/niri/blob/b07bde3ee82dd73115e6b949e4f3f63695da35ea/resources/default-config.kdl#L271).
Remove the spawn-at-startup \"waybar\" from the config file, or add waybar to your systems packages without using the
home-manager option.

## See Also {#see_also}

-   [Wayland](Special:MyLanguage/Wayland "wikilink")
-   [Sway](Special:MyLanguage/Sway "wikilink")
-   [Wallpapers for Wayland](Special:MyLanguage/Wallpapers_for_Wayland "wikilink")
-   [niri-flake](https://github.com/sodiboo/niri-flake/)

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications{{#translation:}}](Category:Applications{{#translation:}} "wikilink")

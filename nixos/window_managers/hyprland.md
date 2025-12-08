[Hyprland](https://hyprland.org/) is an independent, extensible, bleeding-edge [Wayland](Wayland "wikilink") compositor
written in modern C++ with an emphasis on looks. In addition, Hyprland also offers a number of first-party tools as well
as a custom plugin system. The most up-to-date and complete documentation can be found in the project\'s own
[wiki](https://wiki.hyprland.org/).

Some of the most notable features of Hyprland are:

-   **Independent Wayland implementation**: does not rely on wlroots or other external libraries and provides in-house
    alternatives to common components (screen locking, idle daemon, etc).
-   **Easy to configure**: uses a live reloading config file in plain-text with useful defaults.
-   **Dynamic tiling support**: supports both automatic tiling and floating mode with multiple layouts.
-   **Socket-based IPC**: allows controlling the compositor at runtime via UNIX socket.
-   **Global shortcuts**: permits setting global keybinds for any application (for apps such as [OBS
    Studio](OBS_Studio "wikilink")).
-   **Window/Workspace Rules**: set special behaviors for certain windows and workspaces.

## Installation

NixOS 24.11 added support for launching Hyprland with [Universal Wayland Session
Manager](https://github.com/Vladimir-csp/uwsm) (UWSM) and is the recommended way to launch Hyprland as it neatly
integrates with [Systemd](Systemd "wikilink").

```{=mediawiki}
{{file|configuration.nix|nix|<nowiki>
{
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };
}
</nowiki>}}
```
### Nix on Non-NixOS Systems {#nix_on_non_nixos_systems}

If you use the Nix package manager on-top of a non-NixOS distribution then Hyprland can still be installed (albeit with
less support than the NixOS module).

Firstly, enable [flakes](https://wiki.nixos.org/wiki/Flakes#Other_Distros,_without_Home-Manager) in your Nix
installation. Then install Hyprland through `nix profile`:

``` text
nix profile install nixpkgs#hyprland
```

In order for Hyprland to find graphics drivers on a non-NixOS system, you will need to install
[nixGL](nixGL "wikilink"):

``` text
nix profile install github:guibou/nixGL --impure
```

Now you can run Hyprland by invoking it with NixGL:

``` text
nixGL Hyprland
```

#### Hypr Ecosystem {#hypr_ecosystem}

You may also be interested in the Hypr project\'s collection of tools:

-   **hyprlock**: Hyprland\'s GPU-accelerated screen locking utility.
-   **hypridle**: Hyprland\'s idle daemon.
-   [hyprpaper](hyprpaper "wikilink"): Hyprland\'s wallpaper utility.
-   **hyprsunset**: Application to enable a blue-light filter on Hyprland.
-   **hyprpicker**: Wayland color picker that does not suck.
-   **hyprpolkitagent**: Polkit authentication agent written in QT/QML.

All official Hypr\* programs are listed in the project\'s [wiki page](https://wiki.hyprland.org/Hypr-Ecosystem/) along
with documentation.

### Hyprland Flake {#hyprland_flake}

```{=mediawiki}
{{Warning|Installing Hyprland through a Nix flake will require the system to recompile Hyprland and all of its dependencies each time it updates. To avoid this, setup [[Hyprland#Cachix|Hyprland's Cachix settings]] before adding Hyprland as a flake input.}}
```
If you wish to run a development version of Hyprland, you can easily do so by adding its flake to your flake inputs as
demonstrated below:

```{=mediawiki}
{{file|flake.nix|nix|<nowiki>
{
  inputs.hyprland.url = "github:hyprwm/Hyprland";
  # ...

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.YOUR_HOSTNAME = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; }; # this is the important part
      modules = [
        ./configuration.nix
        # ...
      ];
    };
  };
}
</nowiki>}}
```
```{=mediawiki}
{{file|configuration.nix|nix|<nowiki>
{inputs, pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
</nowiki>}}
```
If you experience performance drops in video games or graphics tools like Blender on stable NixOS, then it\'s likely a
[Mesa](Mesa "wikilink") version mismatch with Hyprland and the rest of your system. This can be fixed by substituting
the system\'s mesa package with Hyprland\'s own.

```{=mediawiki}
{{file|3=<nowiki>
{pkgs, inputs, ...}: let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  hardware.graphics = {
    package = pkgs-unstable.mesa;

    # if you also want 32-bit support (e.g for Steam)
    enable32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa;
  };
}
</nowiki>|name=configuration.nix|lang=nix}}
```
#### Cachix

If you use the Hyprland flake, you\'ll have to rebuild Hyprland as well as any of its dependencies (mesa, ffmpeg, etc).
To avoid this, use the [Cachix cache](https://app.cachix.org/cache/hyprland) provided by Hyprland to supplement any
dependency not supplied by Hydra. Note that the setting has to be enabled **before** using the Hyprland flake package
(meaning you should rebuild at least once before adding the flake input).

```{=mediawiki}
{{file|configuration.nix|nix|<nowiki>
{
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
</nowiki>}}
```
### Screensharing

```{=mediawiki}
{{file|configuration.nix|nix|<nowiki>
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
}
</nowiki>}}
```
### Display Manager Support {#display_manager_support}

By default, Hyprland does not come with a [display manager](https://wiki.nixos.org/wiki/Wayland#Display_Managers) and
does not advertise support for one. Though one can start hyprland directly from tty with `Hyprland` or with
`uwsm start select`, some display managers packaged in NixOS are compatible including but may not be limited to:

-   SDDM
-   GDM (works but crashes Hyprland on first launch)
-   greetd (especially with ReGreet)
-   ly (not recommended but works)

## Configuration

On first run, Hyprland will create a configuration file with autogenerated defauts in
`$XDG_CONFIG_HOME/hypr/hyprland.conf` if it does not exist. An example configuration can be found in the [project\'s git
repository](https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.conf).

### Using [Home Manager](Home_Manager "wikilink") {#using_home_manager}

Home Manager allows for declarative configuration of Hyprland using Nix syntax.

```{=mediawiki}
{{file|/etc/nixos/home.nix or ~/.config/home-manager/home.nix|nix|<nowiki>
{
  wayland.windowManager.hyprland.settings = {
    decoration = {
      shadow_offset = "0 5";
      "col.shadow" = "rgba(00000099)";
    };

    "$mod" = "SUPER";

    bindm = [
      # mouse movements
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];
  };
  # ...
}
</nowiki>}}
```
## Plugin Support {#plugin_support}

Hyprland boasts a growing plugin ecosystem that extends the functionality of the compositor such as adding support for
window decorations or a GNOME-like workspaces design. However, hyprpm is unsupported on NixOS due to the way Hyprland is
built.

The [Home Manager](Home_Manager "wikilink") module for Hyprland should be used instead:

```{=mediawiki}
{{file|/etc/nixos/home.nix or ~/.config/home-manager/home.nix|nix|<nowiki>
{
  wayland.windowManager.hyprland.plugins = [
    pkgs.hyprlandPlugins.PLUGIN_NAME
  ];
}
</nowiki>}}
```
### hyprland-plugins {#hyprland_plugins}

[hyprland-plugins](https://github.com/hyprwm/hyprland-plugins) is a repository of first-party plugins. If you wish to
use these plugins then it\'s recommended to use the Hyprland flake instead of the Nixpkgs version as well as using the
[Home Manager](Home_Manager "wikilink") module.

Add the flake to your flake inputs: `{{file|flake.nix|nix|<nowiki>
{
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland"; # Prevents version mismatch.
    };

    # ...
  }
}
</nowiki>}}`{=mediawiki}

And then add the plugin using the hyprland-plugins input:

```{=mediawiki}
{{file|/etc/nixos/home.nix or ~/.config/home-manager/home.nix|nix|<nowiki>
{inputs, pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.PLUGIN_NAME
    ];
  };
}
</nowiki>}}
```
[List of plugins](https://github.com/hyprland-community/awesome-hyprland#plugins)

## Troubleshooting

### Swaylock

If swaylock cannot be unlocked with the correct password: `security.pam.services.swaylock = {};`

### Electron applications defaulting to X11 rather than Wayland {#electron_applications_defaulting_to_x11_rather_than_wayland}

Set the environment variable `NIXOS_OZONE_WL` to \"1\" in your NixOS configuration:
`{{file|configuration.nix|nix|<nowiki>
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
</nowiki>}}`{=mediawiki}

### Theme Support {#theme_support}

To make themes consistent in Hyprland, you can either use Home Manager like this:

```{=mediawiki}
{{file|/etc/nixos/home.nix or ~/.config/home-manager/home.nix|nix|<nowiki>
{
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
}
</nowiki>}}
```
or set themes using dconf in your Hyprland configuration file: `{{file|hyprland.conf|conf|<nowiki>
exec-once = dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'"
exec-once = dconf write /org/gnome/desktop/interface/icon-theme "'Flat-Remix-Red-Dark'"
exec-once = dconf write /org/gnome/desktop/interface/document-font-name "'Noto Sans Medium 11'"
exec-once = dconf write /org/gnome/desktop/interface/font-name "'Noto Sans Medium 11'"
exec-once = dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono Medium 11'"
</nowiki>}}`{=mediawiki}You may also install graphical tools such as gnome tweaks or nwg-look to set the themes
manually.

## See also {#see_also}

-   [Hyprland Website](https://hyprland.org/)
-   [The official documentation](https://wiki.hyprland.org/)
-   [Hyprland Github Page](https://github.com/hyprwm/Hyprland/)
-   [Community-maintained list of tools, plugins and extensions](https://github.com/hyprland-community/awesome-hyprland)

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications](Category:Applications "wikilink")

```{=mediawiki}
{{Expansion|Verify accuracy of article}}
```
[Wayland](https://wayland.freedesktop.org/) is a modern display server protocol intended as a replacement for the legacy
[ X11](Xorg "wikilink") system.

For additional details, see `{{NixOS Manual|anchor=#sec-wayland|name=NixOS Manual: Chapter - Wayland}}`{=mediawiki}.

## Checking for Wayland {#checking_for_wayland}

To check if you are using Wayland, run the following command `{{Commands|$ echo $XDG_SESSION_TYPE}}`{=mediawiki} If
`{{ic|wayland}}`{=mediawiki} is returned, you are running Wayland

## Setup

Two things are required for running Wayland: a compatible Display Manager, and a compatible Compositor.
`{{Expansion|Verify completeness of DM and Compositor lists}}`{=mediawiki}

## Display Managers {#display_managers}

Display Managers are responsible for handling user login.

The following Display Managers support using both X and Wayland protocols

#### Graphical

-   [gdm](https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/nixos/modules/services/x11/display-managers/gdm.nix)
    is the [GNOME](GNOME "wikilink") Display Manager.
-   [sddm](https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/nixos/modules/services/x11/display-managers/sddm.nix)
    is the default Display Manager for [KDE](KDE "wikilink"). Wayland support is currently experimental.

#### Text-based {#text_based}

-   [ly](https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/applications/display-managers/ly/default.nix)
-   [emptty](https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/applications/display-managers/emptty/default.nix)
-   [lemurs](https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/applications/display-managers/lemurs/default.nix)

## Compositors

For the purposes of this basic overview, a compositor can be thought of as equivalent to an X Desktop Environment.
`{{Note|It is important to remember that this is not actually the case as there are [https://en.wikipedia.org/wiki/Wayland_(protocol)#Differences_between_Wayland_and_X multiple differences] between how X and Wayland work internally}}`{=mediawiki}

### Wayland Native {#wayland_native}

-   [Sway](Sway "wikilink") is a i3-like compositor.
-   [Hyprland](Hyprland "wikilink") the dynamic tiling Wayland compositor that doesn\'t sacrifice on its looks.

### X and Wayland support {#x_and_wayland_support}

-   [Mutter](https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/desktops/gnome/core/mutter/default.nix) is the
    default compositor for [GNOME](GNOME "wikilink") Desktop Environment.
-   [KWin](https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/desktops/plasma-5/kwin/default.nix) is the default
    compositor for [KDE](KDE "wikilink") Desktop Environment.

## Applications

Not all apps support running natively on Wayland. To work around this, Xwayland should be enabled.
`{{Note|Enabling XWayland varies slightly from Compositor to Compositor, and may already be enabled. Consult your Compositor's documentation and/or nix file for how to enable}}`{=mediawiki}

### Electron and Chromium {#electron_and_chromium}

Ozone Wayland (which uses Wayland native instead of Xwayland) support in [Chromium](Chromium "wikilink") and
[Electron](Electron "wikilink") based applications can be enabled by setting the environment variable
\"`NIXOS_OZONE_WL`\" with `NIXOS_OZONE_WL=1` *(also see
[commit](https://github.com/NixOS/nixpkgs/commit/b2eb5f62a7fd94ab58acafec9f64e54f97c508a6))*

As of NixOS 25.05 (\"Warbler\"), if `XDG_SESSION_TYPE` is unset or set to \"wayland\", [chromium and electron apps will
default to wayland native](https://issues.chromium.org/issues/40083534#comment599). This ignores the `DISPLAY`
environment variable.

#### Declaratively (permanent) {#declaratively_permanent}

##### NixOS

```{=mediawiki}
{{File|3=environment.sessionVariables.NIXOS_OZONE_WL = "1";|name=/etc/nixos/configuration.nix|lang=nix}}
```
#### Imperatively (each time an application is launched) {#imperatively_each_time_an_application_is_launched}

Example: to launch `code` *(`{{Nixpkg|pkgs/applications/editors/vscode/vscode.nix|vscode}}`{=mediawiki})*

``` console
NIXOS_OZONE_WL=1 code
```

## Virtualization

To have wayland work inside of [QEMU](QEMU "wikilink"), you may need to pass `-vga qxl`.

## See also {#see_also}

-   [Xorg](Xorg "wikilink")

[Category:Desktop](Category:Desktop "wikilink")

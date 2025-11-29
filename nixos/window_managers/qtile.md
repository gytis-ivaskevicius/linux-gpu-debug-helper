[Qtile](https://qtile.org/) is a full-featured, hackable tiling window manager written and configured in Python.

## Enabling

To enable Qtile as your window manager, set `services.xserver.windowManager.qtile.enable = true`. For example:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|}}
```
``` nix
{
  services.xserver.windowManager.qtile.enable = true;
}
```

To start Qtile on Wayland from your display manager (sddm, lightdm, etc) you have to add a Desktop Entry to your config
like this.`{{file|/etc/nixos/qtile.nix|nix|}}`{=mediawiki}

``` nix
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
  (self: super: {
    qtile-unwrapped = super.qtile-unwrapped.overrideAttrs(_: rec {
      postInstall = let
        qtileSession = ''
        [Desktop Entry]
        Name=Qtile Wayland
        Comment=Qtile on Wayland
        Exec=qtile start -b wayland
        Type=Application
        '';
        in
        ''
      mkdir -p $out/share/wayland-sessions
      echo "${qtileSession}" > $out/share/wayland-sessions/qtile.desktop
      '';
      passthru.providedSessions = [ "qtile" ];
    });
  })
];

services.xserver.displayManager.sessionPackages = [ pkgs.qtile-unwrapped ];
}
```

## Warning

The installation of Qtile leads to several of its dependencies being leaked in the user\'s PATH. This prevents the user
from running a custom installation of python3 as Qtile will shadow the systemPackages in the PATH with its own python3.
For more information see: [Cannot use Globally Defined Python Environment While Inside
Qtile](https://github.com/NixOS/nixpkgs/issues/186243) and [Kitty leaks packages into system environment (Additional
context)](https://github.com/NixOS/nixpkgs/issues/171972)

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications](Category:Applications "wikilink")

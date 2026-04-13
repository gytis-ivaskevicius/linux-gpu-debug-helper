[Super Smash Bros. Melee](wikipedia:Super_Smash_Bros._Melee "wikilink") is a 2001 platform fighter game developed by HAL
Laboratory and published by Nintendo.

## Slippi

You can use the [slippi-nix](https://github.com/lytedev/slippi-nix) flake to declaratively install and configure Slippi
with Nix, or get the AppImage directly from [Slippi\'s website](https://slippi.gg/).

If you are using the AppImage, to run Slippi Online or Slippi Playback you will need `libcurl.so.4` to be in your
[appimage-run](Appimage#Run "wikilink") packages. This can be easily added through a package like `curlMinimal`.

``` nix
  programs.appimage.package = pkgs.appimage-run.override { extraPkgs = pkgs: [
    pkgs.curlMinimal.out
  ];};
```

## B0XX Emulation {#b0xx_emulation}

[B0XX controller](https://b0xx.com/) emulation can be done via [keyb0xx](https://gitlab.com/liamjen/keyb0xx). A Nix
package for keyb0xx can be found [here](https://codeberg.org/nyxmeowmeow/keyb0xx-nix).

[Category:Gaming](Category:Gaming "wikilink") [Category:Applications](Category:Applications "wikilink")

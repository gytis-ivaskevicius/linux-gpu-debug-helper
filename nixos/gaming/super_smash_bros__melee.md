[Super Smash Bros. Melee](wikipedia:Super_Smash_Bros._Melee "wikilink") is a 2001 platform fighter game developed by HAL
Laboratory and published by Nintendo.

## Slippi

You can use the [slippi-nix](https://github.com/lytedev/slippi-nix) flake to declaratively install and configure Slippi
with Nix, or get the AppImage directly from [Slippi\'s website](https://slippi.gg/).

If you are using the [Appimage](Appimage "wikilink"), to run Slippi Online or Slippi Playback you will need
`libcurl.so.4` to be in your [appimage-run](Appimage#Run "wikilink") packages. This can be easily added through a
package like `curlMinimal`.

``` nix
  programs.appimage.package = pkgs.appimage-run.override { extraPkgs = pkgs: [
    pkgs.curlMinimal.out
  ];};
```

The configuration to setup Appimage support and specifically the Slippi Appimage would look like the following

``` nix
{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.curlMinimal.out
    ];
  };
}
```

Which is just the snippet from [Appimage#Configuration](Appimage#Configuration "wikilink") with the needed library added
to the `appimage-run` package.

Even when using the Appimage, you can still use [slippi-nix](https://github.com/lytedev/slippi-nix)\'s optional
`default` nixosModule to automatically setup the udev rules needed to optimize GameCube adapters, assuming you have a
[flake-based configuration](NixOS_system_configuration#Defining_NixOS_as_a_flake "wikilink").

``` nix
{
  inputs.slippi= {
    url = "github:lytedev/slippi-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {slippi, nixpkgs, ...}: {
    nixosConfigurations.alice = nixpkgs.lib.nixosSystem {
      modules = [
        slippi.nixosModules.default
      ];
    };
  };
}
```

## B0XX Emulation {#b0xx_emulation}

[B0XX controller](https://b0xx.com/) emulation can be done via [keyb0xx](https://gitlab.com/liamjen/keyb0xx). A Nix
package for keyb0xx can be found [here](https://codeberg.org/nyxmeowmeow/keyb0xx-nix).

[Category:Gaming](Category:Gaming "wikilink") [Category:Applications](Category:Applications "wikilink")

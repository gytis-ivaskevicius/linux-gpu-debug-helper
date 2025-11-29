[Lutris](https://lutris.net/) is a video game preservation platform that you can use to play or emulate pretty much any
game you want.

## Installation

Install Lutris by adding the [Lutris package](https://search.nixos.org/packages?show=lutris&query=lutris)

``` nix
environment.systemPackages = with pkgs; [
  lutris
];
```

### Overriding extra libraries and packages {#overriding_extra_libraries_and_packages}

If any games are unable to run due to missing dependencies, they can be installed using the following methods.

``` nix
environment.systemPackages = with pkgs; [
  (lutris.override {
    # List of additional system libraries
    extraLibraries = pkgs: [ ];

    # List of additional system packages    
    extraPkgs = pkgs: [ ];
  })
];
```

## Known Issues {#known_issues}

### Icons do not appear {#icons_do_not_appear}

You have to install a compatible icon theme. For example, you can install the `adwaita-icon-theme` available as
`gnome3.adwaita-icon-theme` in Nixpkgs.

### Epic Game Store {#epic_game_store}

If you\'re running a 64bit environment you need to ensure that you enable 32bit support:

``` nix
hardware.graphics.enable32Bit = true;
```

### Incompatible Lutris libraries {#incompatible_lutris_libraries}

When installing some games, you may see a message similar to:
`` mktemp: $USER/.local/share/lutris/runtime/steam/amd64/lib/x86_64-linux-gnu/libattr.so.1: version `ATTR_1.3' not found (required by mktemp) ``

This happens because lutris attempts to use it\'s own runtime which has incompatible libraries. To disable these
potentially conflicting libraries:
`More (three horizontal lines) > Preferences > Global Options > Disable Lutris Runtime`. Then attempt to install the
game or application again.

### Using Esync {#using_esync}

The Lutris documentation shows [how to make your system esync
compatible](https://github.com/lutris/docs/blob/master/HowToEsync.md). These steps can be achieved on NixOS with the
config below.

``` nixos
{ config, pkgs, lib, ... }:

{
  systemd.extraConfig = "DefaultLimitNOFILE=524288";
  security.pam.loginLimits = [{
    domain = "yourusername";
    type = "hard";
    item = "nofile";
    value = "524288";
  }];
}
```

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

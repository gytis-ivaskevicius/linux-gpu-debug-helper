[Heroic Games Launcher](https://heroicgameslauncher.com/) is an open-source launcher for GOG, Epic Games Store, and
Amazon Prime Games, for Linux, Windows, and macOS. On NixOS, it fills a similar role to
[Lutris](Lutris "Lutris"){.wikilink} for running native and Windows games, and is also wrapped in a [FHS
environment](FHS_environment "FHS environment"){.wikilink}.

## Platform Support {#platform_support}

Heroic in nixpkgs is only supported on `x86_64-linux`. Upstream does not support 32-bit Linux. If you are on macOS, you
should use the official builds from upstream, unless you are willing to take on maintaining the Heroic package in
nixpkgs for [nix-darwn](Nix-darwin "nix-darwn"){.wikilink}. If you are using just Nix on any non-NixOS Linux
distribution, you should use the official builds from upstream.

## Optional Dependencies {#optional_dependencies}

Heroic has some optional dependencies, such as [Gamescope](https://github.com/ValveSoftware/gamescope) and
[GameMode,](GameMode "GameMode,"){.wikilink} that are not included in the FHS environment wrapper. If you want to use
any of these, you need to override the Heroic derivation to pass extra packages.

``` nix
(heroic.override {
  extraPkgs = pkgs: [
    pkgs.gamescope
  ];
})
```

For Gamescope and GameMode, you also need to enable these in your NixOS configuration.

``` nixos
programs.gamescope.enable = true;
programs.gamemode.enable = true;
```

See [GameMode](GameMode "GameMode"){.wikilink} for additional setup information.

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

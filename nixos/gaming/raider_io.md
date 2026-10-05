[Raider.IO](https://raider.io) is a companion tool for *World of Warcraft* that synchronizes Mythic+ scores, raid
progression, and character database information directly into the game\'s addon directories.

## Installation

### Standard (Once merged into Nixpkgs) {#standard_once_merged_into_nixpkgs}

The package is tracked in [PR #565124](https://github.com/NixOS/nixpkgs/pull/565124). Once merged, add it to your
configuration:

``` nix
environment.systemPackages = [
  pkgs.raiderio-client
];
```

### Before Merge (Using Flakes) {#before_merge_using_flakes}

Before the PR is merged, you can pull the package directly from the PR branch:

``` nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-raiderio.url = "github:thebigjc/nixpkgs/add-raiderio-client";
  };

  outputs = { self, nixpkgs, nixpkgs-raiderio, ... }: {
    nixosConfigurations.myhostname = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            nixpkgs-raiderio.legacyPackages.${pkgs.system}.raiderio-client
          ];
        })
      ];
    };
  };
}
```

### Before Merge (Tarball / Channels) {#before_merge_tarball_channels}

``` nix
let
  raiderioPkgs = import (fetchTarball "https://github.com/thebigjc/nixpkgs/archive/refs/heads/add-raiderio-client.tar.gz") {};
in {
  environment.systemPackages = [
    raiderioPkgs.raiderio-client
  ];
}
```

## Configuration & Known Issues {#configuration_known_issues}

### Autostart on Boot (Error 127) {#autostart_on_boot_error_127}

The upstream Electron app has an internal *\"Launch at startup\"* toggle. In an AppImage/FHS environment on NixOS, this
toggle writes a desktop file pointing to the internal, unpatched Nix store binary, causing systemd to fail with exit
status 127 on boot.

To enable autostart cleanly on NixOS, do not use the in-app toggle; instead, configure it declaratively (e.g., via Home
Manager):

``` nix
# home.nix
xdg.configFile."autostart/raiderio-client.desktop".text = ''
  [Desktop Entry]
  Type=Application
  Version=1.0
  Name=Raider.IO
  Comment=Raider.IO startup script
  Exec=raiderio-client --no-sandbox
  StartupNotify=false
  Terminal=false
'';
```

### Configuring Game Paths {#configuring_game_paths}

The client stores configuration in `~/.config/RaiderIO/config.json`. If you run World of Warcraft via Wine/Lutris, your
retail path typically resides inside your Wine prefix:

``` json
{
  "gameConfigs": {
    "wowretail": {
      "channel": "release",
      "syncMode": "all",
      "syncAmericas": true,
      "syncEurope": true,
      "syncKorea": true,
      "syncTaiwan": true,
      "syncChina": true,
      "wowFolder": "/home/<user>/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_"
    },
    "wowclassic": { "channel": "release", "syncMode": "all", "syncAmericas": true, "syncEurope": true, "syncKorea": true, "syncTaiwan": true, "syncChina": true, "wowFolder": "" },
    "wowera": { "channel": "release", "syncMode": "all", "syncAmericas": true, "syncEurope": true, "syncKorea": true, "syncTaiwan": true, "syncChina": true, "wowFolder": "" },
    "wowforever": { "channel": "release", "syncMode": "all", "syncAmericas": true, "syncEurope": true, "syncKorea": true, "syncTaiwan": true, "syncChina": true, "wowFolder": "" }
  }
}
```

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

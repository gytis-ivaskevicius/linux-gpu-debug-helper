[KaTrain](https://github.com/sanderland/katrain/) is an application to learn the Go boardgame.

``` nix
# pkgs/katrain/default.nix
{pkgs, ...}: let
  katrainFHS = pkgs.buildFHSEnv {
    name = "katrain";

    targetPkgs = pkgs:
      with pkgs; [
        uv
        xclip
        SDL2
        libGL
        mtdev
        zlib
      ];

    runScript = pkgs.writeShellScript "katrain-run" ''
      exec uvx katrain "$@"
    '';
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "katrain";
    desktopName = "KaTrain";
    exec = "${katrainFHS}/bin/katrain %U";
    terminal = false;
    comment = "KaTrain - Go/Baduk AI teaching tool";
    categories = ["Game" "BoardGame" "Education"];
    icon = "katrain";
  };
in
  pkgs.symlinkJoin {
    name = "katrain";
    paths = [katrainFHS desktopItem];
  }
```

``` nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./pkgs/katrain {})
    katago
  ];
  hardware.graphics.extraPackages = with pkgs; [
    mesa.opencl
  ];
  environment.variables = {
    RUSTICL_ENABLE = "nouveau";
  };
}
```

``` json
// ~/.katrain/config.json
{
  "engine": {
    "katago": "katago",
    // ...
  },
  // ...
}
```

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

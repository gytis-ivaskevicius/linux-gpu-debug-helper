[picom](https://github.com/yshui/picom) is a standalone [compositor](compositor "wikilink") for [Xorg](Xorg "wikilink"),
suitable for use with window managers that do not provide compositing. picom is a fork of
[compton](https://github.com/chjj/compton/), which is a fork of
[xcompmgr-dana](https://web.archive.org/web/20150429182855/http://oliwer.net/xcompmgr-dana/), which in turn is a fork of
xcompmgr.

## Installation

Put the following line into your system or [home-manager](Home_Manager "wikilink") config to install picom and enable
it\'s service:

``` nix
services.picom.enable = true;
```

If you just want to install picom without automatically running it every time your system boots, use this instead:

``` nix
packages.picom.enable = true;
```

## Installing a custom fork {#installing_a_custom_fork}

Picom is known for having multiple forks, each having their own features such as animations, better performance or fixes
that the most popular forks don\'t implement. Usually these forks are not available in [nixpkgs](nixpkgs "wikilink").
But with the following code you can compile and build custom versions from any source.
[Nurl](https://github.com/nix-community/nurl) can be used to generate fetch calls.

``` nix
environment.systemPackages = with pkgs; [
  (picom.overrideAttrs (oldAttrs: rec {
    src = fetchFromGitHub {
      owner = "pijulius";
      repo = "picom";
      rev = "da21aa8ef70f9796bc8609fb495c3a1e02df93f9";
      hash = "sha256-rxGWAot+6FnXKjNZkMl1uHHHEMVSxm36G3VoV1vSXLA=";
    };
  }))
];
```

## Troubleshooting

### Issues with Nvidia proprietary drivers {#issues_with_nvidia_proprietary_drivers}

See [Nvidia#Fix_app_flickering_with_Picom](Nvidia#Fix_app_flickering_with_Picom "wikilink")

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications](Category:Applications "wikilink")

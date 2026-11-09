[Mango](https://mangowm.github.io/) is a lightweight, modern [Wayland](Wayland "Wayland"){.wikilink} compositor based on
[dwl](https://codeberg.org/dwl/dwl). Mango provides features like animations, IPC, different layouts and visual effects.

## Installation

If you don\'t want to configure mango using nix, you can just add mango to your systemPackages:

```{=mediawiki}
{{file|3=environment.systemPackages = with pkgs; [
    mango
];
|name=/etc/nixos/configuration.nix|lang=nix}}
```
If you would like to configure mango declaratively using nix and home-manager, you should install the [official
flake](https://mangowm.github.io/docs/installation#nixos). Add it to your inputs:

```{=mediawiki}
{{file|3=inputs = {
  nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
  mango = {
    url = "github:mangowm/mango";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};|name=flake.nix|lang=nix}}
```
## Configuration

After adding the new input, mango can be configured using [Home Manager](Home_Manager "Home Manager"){.wikilink}:
`{{file|3={ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.mango.hmModules.mango
  ];

  wayland.windowManager.mango= {
    enable = true;
    settings = {
      animations = 0;
      bordercolor="0x595959aa";
      bind = [
        "SUPER,r,reload_config"
        "SUPER,space,spawn,fuzzel"
        "SUPER,Return,spawn,foot"
      ];
    };
  };
}|name=home.nix|lang=nix}}`{=mediawiki}

Extra documentation can be found on the [official website](https://mangowm.github.io/docs/nix-options).

[Category:Window managers](Category:Window_managers "Category:Window managers"){.wikilink}
[Category:Applications](Category:Applications "Category:Applications"){.wikilink}

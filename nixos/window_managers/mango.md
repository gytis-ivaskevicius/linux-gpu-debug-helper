[Mango](https://mangowm.github.io/) is a lightweight, modern [Wayland](Wayland "wikilink") compositor based on
[dwl](https://codeberg.org/dwl/dwl). Mango provides features like animations, IPC, different layouts and visual effects.

## Installation

As of August 2026, the mango module is not present by default in NixOS and [Home Manager](Home_Manager "wikilink") and
needs to be imported using [Flakes](Flakes "wikilink").

Here is an example flake:

```{=mediawiki}
{{file|3={
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, mango, ... } @ inputs: 
  {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}|name=flake.nix|lang=nix}}
```
## Configuration

After adding the new input, mango can be configured using [Home Manager](Home_Manager "wikilink"):
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

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications](Category:Applications "wikilink")

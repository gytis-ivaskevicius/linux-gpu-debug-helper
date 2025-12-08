[awesome](https://awesomewm.org/) is a highly configurable, next generation framework window manager for X. It is very
fast, extensible and licensed under the GNU GPLv2 license.

## Enabling

To enable awesomeWM set `services.xserver.windowManager.awesome.enable` to `true`. For example:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|
<nowiki>
{ config, pkgs, ... }: 


  ...
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "none+awesome";
  };

  services.xserver = {
    enable = true;

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        # add any lua packages required by your configuration here
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
  };
  ...
}

</nowiki>
}}
```
Similar configuration using [Home Manager](Home_Manager "wikilink").

Reference: <https://github.com/rycee/home-manager/blob/master/modules/services/window-managers/awesome.nix#blob-path>

```{=mediawiki}
{{Tip|
Awesome provides a default config file [https://awesomewm.org/apidoc/sample%20files/rc.lua.html# rc.lua] which is generated at 
<code>/run/current-system/sw/etc/xdg/awesome/rc.lua</code>. Copy the file to <code>~/.config/awesome/</code> and make changes.
}}
```
## AwesomeWM Flake {#awesomewm_flake}

If you wish to run the development build of AwesomeWM (i.e. the source code at the git master branch), you can use a
flake as shown below: `{{File|3={
  inputs = {
    # ...
    awesome-flake.url = "github:Souheab/awesomewm-git-nix-flake";
  };
  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.YOUR_HOSTNAME = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        # ...
      ];
    };
  };
}|name=flake.nix|lang=nix}}`{=mediawiki} And here\'s how you can install the package: `{{File|3={inputs, pkgs, ...}: {
  services.xserver = {
    enable = true;
    windowManager.awesome = {
      enable = true;
      package = inputs."awesome-flake".packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}|name=configuration.nix|lang=nix}}`{=mediawiki} Note: This uses an unofficial third party flake which is not officially
associated with the AwesomeWM project

Flake reference: <https://github.com/Souheab/awesomewm-git-nix-flake>

## References

-   [Getting started](https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html#)
-   [Default configuration file documentation](https://awesomewm.org/apidoc/documentation/05-awesomerc.md.html#3)

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications](Category:Applications "wikilink")

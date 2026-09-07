```{=mediawiki}
{{tip/unfree}}
```
`<strong>`{=html}[Factorio](https://www.factorio.com)`</strong>`{=html} is a video game created by [Wube
Software](https://www.factorio.com/game/about). Factorio has a multiplayer mode that requires a dedicated server, which
is available on Nixpkgs and can be installed on NixOS.

## Installation

To install the Factorio server, add the following to your [NixOS
configuration](Overview_of_the_NixOS_Linux_distribution#Declarative_Configuration "wikilink"):

```{=mediawiki}
{{file|configuration.nix|nix|
<nowiki>
{
  environment.systemPackages = [ pkgs.factorio-headless ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "factorio-headless"
  ];
}
</nowiki>
}}
```
```{=mediawiki}
{{Evaluate}}
```
It is important to only install `factorio-headless` instead of `factorio` because the headless version is a
redistributable download that does not require login credentials.

## Configuration

Here is a minimum viable configuration for the Factorio server:

```{=mediawiki}
{{file|configuration.nix|nix|
<nowiki>
{
  services.factorio = {
    enable = true;
    openFirewall = true;
  };
}
</nowiki>
}}
```
This will run a unprotected server that binds to the `0.0.0.0` local IP address and uses the default UDP port of
`34197`, with an auto-generated save file. Factorio servers support IPv6 by setting `bind = "[::]";`. All default
settings can be seen here: `{{nixos:option|services.factorio.*}}`{=mediawiki}

### Mods

The NixOS module for Factorio supports [third-party modifications](https://wiki.factorio.com/Modding), or
`<i>`{=html}mods`</i>`{=html}, which are just compressed archives with extra game content. While technically you can
create a full derivation for mods, in practice this can get complicated, especially since authentication is required to
download mods from the official mod site.

Instead, you can download the mods you need imperatively from <https://mods.factorio.com/>, place them in a folder such
as `/etc/nixos/factorio-mods`, and put this code in your [NixOS
configuration](Overview_of_the_NixOS_Linux_distribution#Declarative_Configuration "wikilink"):

```{=mediawiki}
{{file|configuration.nix|nix|
<nowiki>
{
  services.factorio = {
    mods =
      let
        modDir = ./factorio-mods;
        modList = lib.pipe modDir [
          builtins.readDir
          (lib.filterAttrs (k: v: v == "regular"))
          (lib.mapAttrsToList (k: v: k))
          (builtins.filter (lib.hasSuffix ".zip"))
        ];
        validPath = modFileName:
          builtins.path {
            path = modDir + "/${modFileName}";
            name = lib.strings.sanitizeDerivationName modFileName;
          };
        modToDrv = modFileName:
          pkgs.runCommand "copy-factorio-mods" {} ''
            mkdir $out
            ln -s '${validPath modFileName}' $out/'${modFileName}'
          ''
          // { deps = []; };
      in
        builtins.map modToDrv modList;
  };
}
</nowiki>
}}
```
This code was developed by
[nicball](https://github.com/nicball/nuc-nixos-configuration/blob/fccfa8441cba60c835aa2eb4238ae6f53bb781bb/factorio.nix#L16-L37).

## See also {#see_also}

-   [The Factorio wiki page on Multiplayer](https://wiki.factorio.com/Multiplayer)

[Category:Gaming](Category:Gaming "wikilink") [Category:Server](Category:Server "wikilink")

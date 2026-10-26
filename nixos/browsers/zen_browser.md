```{=mediawiki}
{{Infobox application
| name = Zen
| type = Native
| image = Zen-logo-black.png
| website = https://zen-browser.app/
| bugTracker = https://github.com/zen-browser/desktop/issues
| github = zen-browser/desktop
| programmingLanguage = C++
}}
```
**Zen** is a firefox based browser that promises a calmer internet, and features a sideways based tab system.

## Installation

For any installation method, use nixpkgs-unstable to ensure compatibility with the latest Firefox version.

#### System setup (Flakes) {#system_setup_flakes}

Add the zen flake to your `flake.nix`

``` nix
{
  ...
  inputs = {
    ...
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }
}
```

Add zen to your `environment.systemPackages`

``` nix
{
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default # default, beta, twilight, or twilight-official
  ];
}
```

Default and beta both install the beta version of zen.

#### Home Manager (Flakes) {#home_manager_flakes}

First add the zen flake to your `flake.nix`

``` nix
{
  ...
  inputs = {
    ...
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
    };
  }
}
```

Add zen to your Home Manager configuration:

``` nix
{
  imports = [
    inputs.zen-browser.homeModules.beta # beta, twilight, or twilight-official
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
```

Please see the flake repository\'s [Home Manager Reference
Section](https://github.com/0xc000022070/zen-browser-flake#home-manager-reference) or the [Configuration Examples
Section](https://github.com/0xc000022070/zen-browser-flake#configuration-examples) for more information on how to
declaratively configure Zen with Home Manager.

[Category:Web Browser](Category:Web_Browser "wikilink")

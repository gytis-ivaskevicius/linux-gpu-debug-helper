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

#### Shell (Flakes) {#shell_flakes}

``` bash
nix shell github:youwen5/zen-browser-flake
```

The command above makes zen available in your current shell.

#### System setup (Flakes) {#system_setup_flakes}

First add the zen flake to your `flake.nix`

``` nix
{
  ...
  inputs = {
    ...
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }
}
```

Then add zen to your `environment.systemPackages`

``` nix
{
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```

After rebuilding, Zen will be installed system-wide.

## Configuration

This is an example of a pure, declarative, wrapper-based configuration independent of NixOS and home-manager (though it
is presented as a NixOS module for convenience). Extensions are not packaged through Nix, but are installed by the
browser upon startup. It should also work on any Firefox based browser.

``` nix
{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    # Check these out at about:config
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
    # ...
  };

  extensions = [
    # To add additional extensions, find it on addons.mozilla.org, find
    # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    # ...
  ];

in
{
  environment.systemPackages = [
    (pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
          ) prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "ddg";
            Add = [
              {
                Name = "nixpkgs packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "NixOS options";
                URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@no";
              }
              {
                Name = "NixOS Wiki";
                URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "@nw";
              }
              {
                Name = "noogle";
                URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                IconURL = "https://noogle.dev/favicon.ico";
                Alias = "@ng";
              }
            ];
          };
        };
      }
    )
  ];
}
```

[Category:Web Browser](Category:Web_Browser "wikilink")

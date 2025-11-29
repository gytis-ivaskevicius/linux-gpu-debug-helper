[LibreWolf](https://librewolf.net) is a web browser and fork of Firefox with an emphasis on privacy and security. It is
a custom and independent version of Firefox that aims to increase protection against tracking and fingerprinting
techniques, while also removing all the telemetry, data collection and annoyances.

## Installation

To install LibreWolf system wide add the following line to your system configuration

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
environment.systemPackages = [ pkgs.librewolf ];
</nowiki>}}
```
## Configuration

It is possible to configure certain presets of LibreWolf using the [Home Manager](Home_Manager "wikilink") module.

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
home-manager.users.myuser = {
  programs.librewolf = {
    enable = true;
    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };
};
</nowiki>}}
```
This example configures LibreWolf to enable WebGL, remember cookies and history by disabling privacy and security
defaults. This compromises the privacy concept of LibreWolf and is therefore not recommended to use.

[Category:Applications](Category:Applications "wikilink") [Category:Privacy](Category:Privacy "wikilink") [Category:Web
Browser](Category:Web_Browser "wikilink")

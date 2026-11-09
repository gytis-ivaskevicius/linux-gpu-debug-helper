```{=mediawiki}
{{DISPLAYTITLE:LibreWolf}}
```
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

It is possible to configure certain presets of LibreWolf using the [Home
Manager](Home_Manager "Home Manager"){.wikilink} module.

```{=mediawiki}
{{file|3=<nowiki>
home-manager.users.myuser = {
  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
      };
        "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi";
          installation_mode = "force_installed";
      };
    };
  };
};
</nowiki>|name=home.nix|lang=nix}}
```
This example configures LibreWolf to enable WebGL, disable resistFingerprinting and install uBlock Origin and Noscript.

For more advanced configuration, refer to the [Firefox](Firefox "Firefox"){.wikilink} page.

LibreWolf exclusive preferences are not possible to apply using `programs.librewolf.policies` policies.

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Privacy](Category:Privacy "Category:Privacy"){.wikilink} [Category:Web
Browser](Category:Web_Browser "Category:Web Browser"){.wikilink}

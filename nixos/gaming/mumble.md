[Mumble](https://www.mumble.info/) is an open source voice chat application.

# Install client {#install_client}

To install the Mumble client it is needed to install a package:

``` nix
  environment.systemPackages = with pkgs; [
    mumble
  ];
```

## PulseAudio Support {#pulseaudio_support}

Add the following to your configuration.nix for [pulseaudio](https://de.wikipedia.org/wiki/PulseAudio) support:

``` nix
{ config, pkgs, ...}:
{
  environment.systemPackages = [
    (pkgs.mumble.override { pulseSupport = true; })
  ];
}
```

# Install Murmur server {#install_murmur_server}

Murmur is the server service for Mumble clients. It can be enabled and has several
[options](https://search.nixos.org/options?query=murmur) available.

``` nix
  services.murmur = {
    enable = true;
    openFirewall = true;
  };
```

The initial password for the user *SuperUser* is written in the *slog* table in the sqlite database:
/var/lib/murmur/murmur.sqlite

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")
[Category:Server](Category:Server "wikilink")

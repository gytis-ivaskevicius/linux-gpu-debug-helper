[Teamspeak](https://www.teamspeak.com) is an unfree voice chat application mainly used for online games. It is available
as client, but its also possible to host an (older) version of Teamspeak as server service.

# Install client {#install_client}

To install the client just add the package:

``` nix
environment.systemPackages = with pkgs; [
  # pick the version you want:
  teamspeak3
  teamspeak5_client
];
```

# Install server {#install_server}

To install a Teamspeak3 server with NixOS for up to 32 users:

``` nix
services.teamspeak3 = {
  enable = true;
  openFirewall = true;
};
```

Because teamspeak has an unfree licence, you also need to accept that manually. Place the following in your config in
order to do so.

``` nixos
nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  "teamspeak-server"
];
```

Teamspeak has several additional options for configuration. To get elevated rights on the server, it is needed to use
the ServerAdmin privilege key from the first log in `/var/log/teamspeak3-server`.

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}
[Category:Server](Category:Server "Category:Server"){.wikilink}

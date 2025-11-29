[OpenArena](https://openarena.ws/) is an open-source fork of Quake 3 Arena.

### Firewall Configuration in NixOS for Local Games {#firewall_configuration_in_nixos_for_local_games}

If you want to play OpenArena in a LAN setting (LAN-Party, Office Tournament) the game will not show locally hosted
games. That is unless you allow the necessary UDP ports:

``` nixos
  networking.firewall.allowedUDPPorts = [ 27960 27961 27962 27963 ];
```

[Category:Gaming](Category:Gaming "wikilink")

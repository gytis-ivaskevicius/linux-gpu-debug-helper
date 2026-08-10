[ioquake3](https://ioquake3.org/) is an open-source, community-maintained engine port of Quake III Arena, compatible
with the original game data.

### Client setup {#client_setup}

```{=mediawiki}
{{Warning|The ioquake3 module is not yet upstream and will be available in the upcoming NixOS 26.11 release.}}
```
The game can be installed and configured using the dedicated `programs.ioquake3` option.

``` nix
programs.ioquake3 = {
  enable = true;
  settings = {
    name = "onny";
    com_maxfps = 125;
    cg_frawFPS = true;
    cg_fov = 115;
    r_mode = "-1";
    r_customheight = 1080;
    r_customwidth = 1920;
    model = "sarge/default";
  };
};
```

ioquake3 will use the demo game files. If you have purchased the game and have a full copy, you can point
`programs.ioquake3.baseq3` to the baseq3 file system path.

### Dedicated server setup {#dedicated_server_setup}

```{=mediawiki}
{{Warning|Parts of this module are not yet upstream and will be available in the upcoming NixOS 26.11 release.}}
```
Following snippet will enable a Quake 3 Arena dedicated server. The map `q3tourney3` (Hell\'s Gate) will be loaded.

``` nix
services.quake3-server = {
  enable = true;
  openFirewall = true;
  baseq3 = "/var/lib/quake3";
  settings = {
    rconPassword = "super_secret";
    sv_hostname = "My NixOS Quake 3 Arena Dedicated Server";
  };
  # Configure map rotation
  extraConfig = ''
    set d1 "map q3tourney3 ; set nextmap vstr d2"
    set d2 "map q3dm17 ; set nextmap vstr d3"
    set d3 "map q3tourney5 ; set nextmap vstr d1"
    vstr d1
  '';
};
```

Game files must be present and readable on the path specified. The full path to the single game file will be
`/var/lib/quake3/.q3a/baseq3/pak0.pk3`. Permissions must be set world-readable.

``` bash
chmod -R o+rX /var/lib/quake3/.q3a/
```

[Category: Applications](Category:_Applications "wikilink") [Category: Gaming](Category:_Gaming "wikilink")

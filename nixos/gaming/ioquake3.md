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
Following snippet will enable a Quake 3 Arena dedicated server. The map *q3dm7* will be loaded.

``` nix
services.quake3-server = {
  enable = true;
  openFirewall = true;
  settings = {
    rconPassword = "super_secret";
    sv_hostname = "My NixOS Quake 3 Arena Dedicated Server";
  };
  # Configure map rotation
  extraConfig = ''
    set d1 "map q3dm7 ; set nextmap vstr d2"
    set d2 "map q3dm1 ; set nextmap vstr d1"
    vstr d1
  '';
};
```

The server will use the demo game files, so various maps and assets won\'t be available.

If you have purchased the game and have a full copy, you can point `services.quake3-server.baseq3` to the baseq3 file
system path. Setting it, for example, to `/var/lib/quake3`, the game file is to be expected at
`/var/lib/quake3/.q3a/baseq3/pak0.pk3`.

[Category: Applications](Category:_Applications "wikilink") [Category: Gaming](Category:_Gaming "wikilink")

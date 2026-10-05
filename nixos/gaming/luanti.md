[Luanti](https://www.luanti.org/) (formerly Minetest) is an open-source voxel-based game engine focused on modding.

## Minetest server {#minetest_server}

Below is a basic configuration that will host a Minetest server on port 30000:

``` nix
{
 services.minetest-server = {
   enable = true;
   port = 30000;
 };
}
```

With this configuration, a user named `{{ic|minetest}}`{=mediawiki} will be created, along with its home folder
`{{ic|/var/lib/minetest}}`{=mediawiki}. All default Minetest configuration and world files are stored in
`{{ic|/var/lib/minetest/.minetest}}`{=mediawiki}.

The Minetest service will be started after running nixos-rebuild. It can be controlled using systemctl:

``` nix
systemctl start minetest-server.service
systemctl stop minetest-server.service
```

Additional options can be found in the NixOS options
[search](https://search.nixos.org/options?channel=unstable&query=minetest&type=options)

[Category:Server](Category:Server "wikilink") [Category:Applications](Category:Applications "wikilink")
[Category:Gaming](Category:Gaming "wikilink")

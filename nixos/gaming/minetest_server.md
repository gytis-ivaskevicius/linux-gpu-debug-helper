[Luanti](https://www.luanti.org/) (formerly Minetest) is a voxel game engine than allows for many different games to be
played.

## Minetest Server Setup {#minetest_server_setup}

Below is a basic configuration that will setup the Minetest server and use port 30000.

``` nix
{
 services.minetest-server = {
   enable = true;
   port = 30000;
 };
}
```

With this setup, a user named `{{ic|minetest}}`{=mediawiki} will be created, along with its home folder
\'/var/lib/minetest\'. All standard Minetest configuration and world files are stored in
`{{ic|/var/lib/minetest/.minetest}}`{=mediawiki}.

The Minetest service will be started after running nixos-rebuild. It can be controlled using `systemctl`

``` nix
systemctl start minetest-server.service
systemctl stop minetest-server.service
```

Additional options can be found in the NixOS options
[search](https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&query=minetest-server)

[Category:Server](Category:Server "Category:Server"){.wikilink}
[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

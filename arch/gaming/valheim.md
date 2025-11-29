[ja:Valheim](ja:Valheim "ja:Valheim"){.wikilink} [Valheim](https://www.valheimgame.com/) is a survival and sandbox game
made by Swedish developers at [Iron Gate Studio](https://irongatestudio.se/). It is currently in early access since 2nd
February 2021 with no full release date announced so far.

This guide is related to the [Steam](https://store.steampowered.com/app/892970/Valheim/) version of the game, which has
a native Linux build since it is built with [Unity3D](Unity3D "Unity3D"){.wikilink} engine.

## Installation

### Without mods {#without_mods}

```{=mediawiki}
{{Note|The official [https://valheim.fandom.com/ wiki] says the [https://valheim.fandom.com/wiki/Valheim_Dedicated_Server#Server_Requirements Valheim Dedicated Server requirements] are at least a 4 core CPU with 2GB of RAM and 2 GB of storage. In practice even with a relatively small world (~25 MB) and few players the server will require around 3 GB of RAM.}}
```
If you buy the game on Steam you will also have the [Valheim Dedicated Server tool](https://steamdb.info/app/896660/),
but you can [install](install "install"){.wikilink} `{{AUR|valheim-server}}`{=mediawiki} and edit
`{{ic|/etc/valheim/server.conf}}`{=mediawiki} to change the name, port, password, and world name of the server.

[Start/enable](Start/enable "Start/enable"){.wikilink} `{{ic|valheim-server.service}}`{=mediawiki}. The server will log
into the [journal](journal "journal"){.wikilink}.

If you want to import the world you played previously, you should find your data in
`{{ic|~/.config/unity3d/IronGate/Valheim/worlds_local}}`{=mediawiki} or
`{{ic|''/path/to''/SteamLibrary/steamapps/compatdata/892970/pfx/drive_c/users/steamuser/AppData/LocalLow/IronGate/Valheim/worlds_local}}`{=mediawiki}
when using Proton.

This server uses its own configuration directory at
`{{ic|/opt/valheim-server/.config/unity3d/IronGate/Valheim/worlds_local}}`{=mediawiki}

The default port is 2456.

### With mods, BepInEx client and server {#with_mods_bepinex_client_and_server}

[BepInEx](https://github.com/BepInEx/BepInEx) is a plugin/modding framework for Unity games.

Due to an [issue with stripped DLLs](https://github.com/BepInEx/BepInEx/issues/251), the release from the BepInEx page
cannot be used.

[Denikson\'s pack](https://valheim.thunderstore.io/package/denikson/BepInExPack_Valheim/) contains the fixed DLLs.
Download the zip manually, as using the Windows only Thunderstore Mod manager will not be covered here. This will work
only with the native version, not when launching via Proton.

In the zip, there is folder BexInPack_Valheim, unpack its contents to the root folder of Valheim, so you have BenInEx
folder and `{{ic|start_game/server/bepinex.sh}}`{=mediawiki} in the same folder as `{{ic|valheim.exe}}`{=mediawiki}.

Make the `{{ic|start_game_bepinex.sh}}`{=mediawiki} [executable](executable "executable"){.wikilink} and in Steam go to
the game\'s properties and set the game\'s launch arguments to:

`./start_game_bepinex.sh %command%`

And start the game, you should see in the top left corner that one plugin is loaded and the bottom right corner should
have information that Valheim is modded.

Now you can download [mods](https://valheim.thunderstore.io/package/) and unpack the *.dll*s to
`{{ic|Valheim/BepInEx/Plugins}}`{=mediawiki}.

- [BepInEx ConfigurationManager](https://valheim.thunderstore.io/package/TJzilla/BepInEx_ConfigurationManager/) - allows
  Open Config Menu button in the bottom left to check which mods loaded and edit their configs.

#### Server

```{=mediawiki}
{{Note|The following instructions might be possible with {{AUR|valheim-server}}, but pointing it to that binary failed.}}
```
For the server, you will need to have [Valheim Dedicated Server tool](https://steamdb.info/app/896660/) installed
(available in Steam), unpack the same [Denikson\'s
pack](https://valheim.thunderstore.io/package/denikson/BepInExPack_Valheim/) to the root of a dedicated server. Edit the
`{{ic|start_server_bepinex.sh}}`{=mediawiki} and edit the name, password, etc\... parameters.

Run the script and the server should create `{{ic|BepInEx/config/org.bepinex.valheim.displayinfo.cfg}}`{=mediawiki}.

Some mods will require the *.dll* to be in the plugin folder on both the client and server.

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

```{=mediawiki}
{{disambiguation|message=Not to be confused with the [[Minecraft]] client.}}
```
```{=mediawiki}
{{tip/unfree}}
```
[Minecraft Server](https://minecraft.wiki/w/Server) is a server for the blocky sandbox game
[Minecraft](Minecraft "wikilink"). Currently only servers for the [Java
Edition](https://www.minecraft.net/en-us/article/java-or-bedrock-edition) of the game are supported.

## Setup

The minimum example to have a Minecraft server running on localhost at the default port of `25565`. By setting the
`eula` option to `true`, you are agreeing to the [Minecraft EULA](https://www.minecraft.net/en-us/eula).

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
services.minecraft-server.enable = true;
services.minecraft-server.eula = true;
</nowiki>}}
```
## Configuration

This example is a more thorough declarative configuration that sets a few options including opening the firewall,
restricting the server to only whitelisted users and setting the port to `43000`.

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
services.minecraft-server = {
  enable = true;
  eula = true;
  openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
  declarative = true;
  whitelist = {
    # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
    username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
    username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
  };
  serverProperties = {
    server-port = 43000;
    difficulty = 3;
    gamemode = 1;
    max-players = 5;
    motd = "NixOS Minecraft server!";
    white-list = true;
    allow-cheats = true;
  };
  jvmOpts = "-Xms2048M -Xmx4096M";
};
</nowiki>}}
```
You might want to view the [list of all available server properties for the vanilla
server](https://minecraft.wiki/w/Server.properties#Keys).

## Tips and tricks {#tips_and_tricks}

### Use a different server version/package {#use_a_different_server_versionpackage}

To use a specific server version, or another Minecraft server---such as [PaperMC](https://papermc.io/)---change
`services.minecraft-server.package` to a nix package that represents your desired server.

For example:

`services.minecraft-server.package = pkgs.minecraftServers.vanilla-1-12;`

or

`services.minecraft-server.package = pkgs.papermc;`

### Accessing the Minecraft server console {#accessing_the_minecraft_server_console}

The Minecraft server console allows you to view server logs and issue [commands](https://minecraft.wiki/w/Commands) to
the server interactively. The Minecraft server console is `<strong>`{=html}not`</strong>`{=html} directly accessible on
NixOS---unlike on imperative systems, where running the server through a shell command provides the interactive console
to the current terminal session.

#### Accessing logs {#accessing_logs}

Since the Minecraft server runs as a systemd service, you can access its stdout through the systemd journal:

`journalctl -eu minecraft-server.service`

The logs are also available in the `logs` subdirectory of the server\'s data directory, which is configured via
`services.minecraft-server.dataDir`. The default value for this option is `/var/lib/minecraft`.

#### Issuing commands {#issuing_commands}

There are two ways to issue commands to the Minecraft server:

1\. Writing to the server's stdin via its named pipe at `/run/minecraft-server.stdin`:

`echo "say Removed Herobrine" > /run/minecraft-server.stdin`

2\. Using the [server\'s provided RCON feature](https://minecraft.wiki/w/RCON).

Example minimal configuration: `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
 services.minecraft-server.serverProperties = {
    enable-rcon = true;
    "rcon.password" = "your password";
 };
</nowiki>}}`{=mediawiki}

### Prefer IPv4 {#prefer_ipv4}

To use IPv4 by default, add `-Djava.net.preferIPv4Stack=true` to `jvmOpts`.

## See also {#see_also}

-   [nix-minecraft](https://github.com/Infinidoge/nix-minecraft), a [flake](flake "wikilink") based attempt to better
    support Minecraft related content for the Nix ecosystem. It can be used for more complex server setups, including
    mods and plugins.
-   [Aikar\'s flags](https://docs.papermc.io/paper/aikars-flags/) or the [Minecraft performance flags
    benchmark](https://github.com/Mukul1127/Minecraft-Java-Flags) for setting additional JVM options in the `jvmOpts`
    option.

[Category: Applications](Category:_Applications "wikilink") [Category: Gaming](Category:_Gaming "wikilink")

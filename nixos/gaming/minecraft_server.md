```{=mediawiki}
{{disambiguation|message=Not to be confused with the [[Minecraft]] client.}}
```
```{=mediawiki}
{{tip/unfree}}
```
[Minecraft Server](https://minecraft.wiki/w/Server) is a server for the sandbox game [Minecraft](Minecraft "wikilink").
Currently, only servers for the [Java Edition](https://www.minecraft.net/en-us/article/java-or-bedrock-edition) of
Minecraft are supported.

## Setup

The minimum example to have a Minecraft server running on localhost at the default port of `25565`. By setting the
`eula` option to `true`, you are agreeing to the [Minecraft EULA](https://www.minecraft.net/en-us/eula).

```{=mediawiki}
{{file|||<nowiki>
services.minecraft-server.enable = true;
services.minecraft-server.eula = true;
</nowiki>|name=/etc/nixos/configuration.nix|lang=nix}}
```
## Configuration

This example is a more thorough declarative configuration that sets a few options including opening the firewall,
restricting the server to only whitelisted users and setting the port to `43000`.

```{=mediawiki}
{{file|||<nowiki>
services.minecraft-server = {
  enable = true;
  eula = true;
  openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
  declarative = true;
  whitelist = {
    # This is a mapping of Minecraft usernames to to the players' UUIDs
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
  jvmOpts = "-Xms2048M -Xmx2048M"; 
};
</nowiki>|name=/etc/nixos/configuration.nix|lang=nix}}
```
You might want to view the [list of all available server properties for the vanilla
server](https://minecraft.wiki/w/Server.properties#Keys).

See [#See also](#See_also "wikilink") for recommended JVM flags for the `jvmOpts` option. These primarily depend on your
[Java](Java "wikilink") version.

## Tips and tricks {#tips_and_tricks}

### Accessing the Minecraft server console {#accessing_the_minecraft_server_console}

The Minecraft server console allows you to view server logs and issue [commands](https://minecraft.wiki/w/Commands) to
the server interactively. The Minecraft server console is `<strong>`{=html}not`</strong>`{=html} directly accessible on
NixOS---unlike on non-declarative systems, where running the server through a shell command provides the interactive
console to the current terminal.

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

Example minimal configuration: `{{file|||<nowiki>
 services.minecraft-server.serverProperties = {
    enable-rcon = true;
    "rcon.password" = "your password";
 };
</nowiki>|name=/etc/nixos/configuration.nix|lang=nix}}`{=mediawiki}

### Use a different server {#use_a_different_server}

To use a specific server version, or another Minecraft server---such as [PaperMC](https://papermc.io/)---change
`services.minecraft-server.package` to a nix package that represents your desired server.

For example:

``` nix
services.minecraft-server.package = pkgs.minecraftServers.vanilla-1-12;
```

or

``` nix
services.minecraft-server.package = pkgs.papermc;
```

#### Other versions {#other_versions}

[Nix-minecraft](https://github.com/Infinidoge/nix-minecraft) is based on [Nix flakes](Flakes "wikilink") and supports a
couple different modded servers:

  Server     \*    Package name
  ---------- ----- ----------------------------
  Vanilla    Yes   `vanillaServers.vanilla`
  Fabric     No    `fabricServers.fabric`
  Quilt      No    `quiltServers.quilt`
  Paper      Yes   `paperServers.paper`
  Purpur     Yes   `purpurServers.purpur`
  NeoForge   No    `neoforgeServers.neoforge`
  Velocity   No    `velocityServers.velocity`

*`<small>`{=html}\*Does it use the correct Java for versions `≥26.1`?`</small>`{=html}*

`Nix-minecraft` supports hosting multiple servers at once, therefore you must name your servers (even if you only have
one).

Here is an example with a server called `example` using the latest major fabric version:

``` nix
services.minecraft-servers.example.package = pkgs.fabricServers.fabric;
# ↑ this will not launch ↑
# ↓   this will launch   ↓
services.minecraft-servers.example.package = pkgs.fabricServers.fabric.override 
{ jre_headless = pkgs.openjdk25_headless; };
```

^*Note\ that\ the\ version\ is\ formatted\ as\ `26_1_2`,\ `1_18_2`,\ or\ `25w10a`.\ Using\ a\ specific\ version\ could\ look\ like\ this:\ `pkgs.vanillaServer.vanilla-1_8_9`*^

Why doesn\'t the top example work? Because versions `≥26.1` `Nix-minecraft` use *[the wrong version of
Java](https://minecraft.wiki/w/Tutorial:Setting_up_a_Java_Edition_server#Version_requirements).*

### Use an exotic server {#use_an_exotic_server}

Some mods like [BTA!](https://www.betterthanadventure.net/installation-guide/) are neither supported by `Nix-minecraft`,
nor `Nixpkgs`. They provide their own `server.jar` to run with Java, summoning a *Minecraft server*.

*^Make\ sure\ to\ move\ the\ `server.jar`\ file\ inside\ a\ separate\ directory,\ or\ else\ it\ might\ spawn\ server\ files\ where\ you\ don\'t\ want\ them.^*

1.  Download the `server.jar`
2.  Install *[the appropriate version of
    Java](https://minecraft.wiki/w/Tutorial:Setting_up_a_Java_Edition_server#Version_requirements) .*
    ``` nixos
    pkgs.jdkX # replace the X with the correct Java version number here
    ```
3.  Run the provided `server.jar` with java

java -Xmx4G -jar /path/to/server.jar -nogui

```{=html}
</syntaxhighlight>
```
*`<small>`{=html}The `-Xmx` flag sets the max memory allocation (here 4GB). The `-nogui` flag disables the minecraft
server gui`</small>`{=html}*

### Prefer IPv4 {#prefer_ipv4}

To use IPv4 by default, add `-Djava.net.preferIPv4Stack=true` to `jvmOpts`.

## See also {#see_also}

-   [nix-minecraft](https://github.com/Infinidoge/nix-minecraft), a [flake](flake "wikilink") based attempt to better
    support Minecraft related content for the Nix ecosystem. It can be used for more complex server setups, including
    mods and plugins.
-   <https://exa.y2k.diy/garden/jvm-args> for setting additional JVM flags in the `jvmOpts` option. Some server-related
    software---like the Velocity proxy---have their own recommended JVM flags list.
-   <https://mcuuid.net> to get a player\'s UUID from their current username or vice versa.

[Category: Applications](Category:_Applications "wikilink") [Category: Gaming](Category:_Gaming "wikilink")

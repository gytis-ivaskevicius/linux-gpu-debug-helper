[zh-hans:Minecraft/Java 版服务端](zh-hans:Minecraft/Java_版服务端 "zh-hans:Minecraft/Java 版服务端"){.wikilink}
Minecraft is a [multiplayer game](w:Multiplayer_video_game "multiplayer game"){.wikilink}. It uses the [client-server
model](w:Client-server_model "client-server model"){.wikilink} in which the game itself is a client which can be played
standalone, or can be played with other players when the client connects to a public server.

```{=mediawiki}
{{Note|Minecraft servers are ran by third parties. You should read their privacy policies to learn about how they process your data. Some servers require third party accounts to login, and some servers support microtransactions allowing you to pay for items on the server, although this could break the [https://www.minecraft.net/en-us/eula Minecraft EULA] depending on what the server is selling.}}
```
## Installation

The Java Edition Minecraft server can be installed via the `{{aur|minecraft-server}}`{=mediawiki} package. It provides
additional [systemd](systemd "systemd"){.wikilink} unit files and includes a small control script.

Also see [#Alternatives](#Alternatives "#Alternatives"){.wikilink} for an overview of alternative programs to host
Minecraft.

## Configuration

In the installation process, the `{{ic|minecraft}}`{=mediawiki} user and group are created. Establishing a
Minecraft-specific user is recommended for security reasons. By running Minecraft under an unprivileged user account,
anyone who successfully exploits your Minecraft server will only get access to that user account, and not yours.
However, you may safely [add](Users_and_groups#Group_management "add"){.wikilink} your user to the
`{{ic|minecraft}}`{=mediawiki} group and add group write permission to the directory `{{ic|/srv/minecraft}}`{=mediawiki}
(default) to modify Minecraft server settings. Make sure that all files in the `{{ic|/srv/minecraft}}`{=mediawiki}
directory are either owned by the `{{ic|minecraft}}`{=mediawiki} user, or that the user has by other means read and
write permissions. The server will error out if it is unable to access certain files and might even have insufficient
rights to write an according error message to the log.

The package provides a systemd service and timer to take automatic backups. By default, the backups are located in the
`{{ic|backup}}`{=mediawiki} folder under the server root directory. Though to keep the disk footprint small only the 10
most recent backups are preserved (configurable via `{{ic|KEEP_BACKUPS}}`{=mediawiki}). The related systemd files are
`{{ic|minecraftd-backup.timer}}`{=mediawiki} and `{{ic|minecraftd-backup.service}}`{=mediawiki}. They may easily be
[adapted](edit "adapted"){.wikilink} to your liking, e.g. to follow a custom backup interval.

### Starting the server {#starting_the_server}

To start the server, you may either use systemd or run it directly from the command line. Either way, the server is
encapsulated in a [tmux](tmux "tmux"){.wikilink} session which is owned by the `{{ic|minecraft}}`{=mediawiki} user.
Using systemd, you may [start/enable](start/enable "start/enable"){.wikilink} the included
`{{ic|minecraftd.service}}`{=mediawiki}. Alternatively, run

`# minecraftd start`

### Accepting the EULA {#accepting_the_eula}

In order to run the Minecraft server, you must accept the *E*nd *U*ser *L*icense *A*greement. This only needs to happen
once after installation. The [EULA](Wikipedia:EULA "EULA"){.wikilink} file resides under
`{{ic|/srv/minecraft/eula.txt}}`{=mediawiki} after being created by the package. You will need to edit this file to
state that you have agreed to the contract in order to run the server. All you need to do is change:

`eula=false`

to the value `{{ic|true}}`{=mediawiki}. Here is an example of an accepted EULA:

```{=mediawiki}
{{hc|/srv/minecraft/eula.txt|2=
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Sat Sep 11 11:11:11 PDT 2011
eula=true
}}
```
### Firewall configuration {#firewall_configuration}

There are three settings in the `{{ic|server.properties}}`{=mediawiki} which determine ports that your server will use.

```{=mediawiki}
{{ic|server-port}}
```
determines the `{{ic|TCP}}`{=mediawiki} port at which the server will listen for incoming connections. The default port
is `{{ic|25565}}`{=mediawiki}.

```{=mediawiki}
{{ic|query.port}}
```
determines the `{{ic|UDP}}`{=mediawiki} port at which the server will share game info/advertising information. The
default port is `{{ic|25565}}`{=mediawiki}. Note that since the server and query ports are TCP and UDP, they can share
the same port. To enable query, you also have to specify `{{ic|1=enable-query=true}}`{=mediawiki}.

```{=mediawiki}
{{ic|rcon.port}}
```
determines the `{{ic|TCP}}`{=mediawiki} port if you choose to allow remote access to admin console. The default port is
`{{ic|25575}}`{=mediawiki}. To enable rcon, you also have to specify `{{ic|1=enable-rcon=true}}`{=mediawiki} and
`{{ic|1=rcon.password=...}}`{=mediawiki}.

You will need to allow incoming connections at least on the `{{ic|server-port}}`{=mediawiki}. It is advisable to allow
query and its `{{ic|query.port}}`{=mediawiki}. On the other hand, enabling remote console access is a security risk, and
you should be careful of allowing it.

The above information is for the official Minecraft server. If you are using an alternative server, please see its
documentation for details about its configuration.

See [1](https://minecraft.wiki/Tutorials/Setting_up_a_server) and [2](https://minecraft.wiki/Server.properties) for more
information.

### Server management script {#server_management_script}

To easily control the server, you may use the provided `{{ic|minecraftd}}`{=mediawiki} script. It is capable of doing
basic commands like `{{ic|start}}`{=mediawiki}, `{{ic|stop}}`{=mediawiki}, `{{ic|restart}}`{=mediawiki} or attaching to
the session with `{{ic|console}}`{=mediawiki}. Moreover, it may be used to display status information with
`{{ic|status}}`{=mediawiki}, backup the server world directory with `{{ic|backup}}`{=mediawiki}, restore world data from
backups with `{{ic|restore}}`{=mediawiki} or run single commands in the server console with
`{{ic|command ''do-something''}}`{=mediawiki}.

```{=mediawiki}
{{Note|Regarding the server console (reachable via {{ic|minecraftd console}}), remember that you can exit any [[tmux]] session with {{ic|ctrl+b}} {{ic|d}}.}}
```
### Tweaking

To tweak the default settings (e.g. the maximum RAM, number of threads etc.), edit the file
`{{ic|/etc/conf.d/minecraft}}`{=mediawiki}.

For example, more advanced users may wish to enable `{{ic|IDLE_SERVER}}`{=mediawiki} by setting it to
`{{ic|true}}`{=mediawiki}. This will enable the management script to suspend the server if no player was online for at
least `{{ic|IDLE_IF_TIME}}`{=mediawiki} (defaults to 20 minutes). When the server is suspended, an
`{{ic|idle_server}}`{=mediawiki} will listen on the Minecraft port using `{{man|1|ncat}}`{=mediawiki} from
`{{Pkg|nmap}}`{=mediawiki} (or any other implementation of [netcat](netcat "netcat"){.wikilink}) and will immediately
start the server at the first incoming connection. Though this obviously delays joining for the first time after
suspension, it significantly decreases the CPU and memory usage leading to more reasonable resource and power
consumption levels.
`{{Note|If running for the first time with this option enabled, the {{ic|/srv/minecraft/eula.txt}} file will not get created. You need to disable it to initially start.}}`{=mediawiki}

## Alternatives

### Spigot (respectively Craftbukkit) {#spigot_respectively_craftbukkit}

[Spigot](https://www.spigotmc.org/) is the most widely-used **modded** Minecraft server in the world. It can be
installed with the `{{AUR|spigot}}`{=mediawiki} package. The spigot PKGBUILD builds on top of the files from the
`{{AUR|minecraft-server}}`{=mediawiki} package. This means that the spigot server provides its own systemd unit files,
spigot script and corresponding script configuration file. The binary is called `{{ic|spigot}}`{=mediawiki} and is
capable of fulfilling the same commands as `{{ic|minecraftd}}`{=mediawiki}. The configuration file resides under
`{{ic|/etc/conf.d/spigot}}`{=mediawiki}.

Be sure to read [#Configuration](#Configuration "#Configuration"){.wikilink} and replace `{{ic|minecraftd}}`{=mediawiki}
with `{{ic|spigot}}`{=mediawiki} wherever you encounter it.

It is somewhat affiliated with [Bukkit](https://bukkit.org/) and has grown in popularity since Bukkit\'s demise.

### Cuberite

[Cuberite](https://cuberite.org/) is a highly efficient and extensively moddable Minecraft server, written in C++ and
Lua. It achieves much better performances than the vanilla Minecraft server, but it is not fully compatible with the
latest Minecraft client (some game aspects might be missing or not working).

The Cuberite Minecraft server can be installed as a `{{AUR|cuberite}}`{=mediawiki} package, which provides a simple web
interface by default at port `{{ic|8080}}`{=mediawiki} with which most server operations can easily be done through the
browser. The cuberite PKGBUILD builds on top of the files from the `{{AUR|minecraft-server}}`{=mediawiki} package. This
means that the cuberite server provides its own systemd unit files, cuberite script and corresponding script
configuration file. The binary is called `{{ic|cuberite}}`{=mediawiki} and is capable of fulfilling the same commands as
`{{ic|minecraftd}}`{=mediawiki}. The configuration file resides under `{{ic|/etc/conf.d/cuberite}}`{=mediawiki}.

Be sure to read [#Configuration](#Configuration "#Configuration"){.wikilink} and replace `{{ic|minecraftd}}`{=mediawiki}
with `{{ic|cuberite}}`{=mediawiki} wherever you encounter it.

### PaperMC

[PaperMC](https://papermc.io) is a Minecraft server, compatible with Spigot plugins which aims to offer better
performance. It can be installed via `{{AUR|papermc}}`{=mediawiki}.

Be sure to read [#Configuration](#Configuration "#Configuration"){.wikilink} and replace `{{ic|minecraftd}}`{=mediawiki}
with `{{ic|papermc}}`{=mediawiki} wherever you encounter it.

### Forge

[Forge](https://minecraftforge.net) is a widely used Minecraft modding API. The following server packages are available:

- ```{=mediawiki}
  {{AUR|forge-server}}
  ```
  for the latest Minecraft version (1.19.x)

- ```{=mediawiki}
  {{AUR|forge-server-1.15.2}}
  ```
  for Minecraft 1.15.2

- ```{=mediawiki}
  {{AUR|forge-server-1.14.4}}
  ```
  for Minecraft 1.14.4

- ```{=mediawiki}
  {{AUR|forge-server-1.12.2}}
  ```
  for Minecraft 1.12.2

- ```{=mediawiki}
  {{AUR|forge-server-1.11.2}}
  ```
  for Minecraft 1.11.2

- ```{=mediawiki}
  {{AUR|forge-server-1.10.2}}
  ```
  for Minecraft 1.10.2

- ```{=mediawiki}
  {{AUR|forge-server-1.9.4}}
  ```
  for Minecraft 1.9.4

- ```{=mediawiki}
  {{AUR|forge-server-1.8.9}}
  ```
  for Minecraft 1.8.9

- ```{=mediawiki}
  {{AUR|forge-server-1.7.10}}
  ```
  for Minecraft 1.7.10

Be sure to read [#Configuration](#Configuration "#Configuration"){.wikilink} and replace `{{ic|minecraftd}}`{=mediawiki}
with `{{ic|forged}}`{=mediawiki} (`{{ic|forge-x.x.xd}}`{=mediawiki} for legacy versions) wherever you encounter it.

### Fabric

[Fabric](https://fabricmc.net/) is a lightweight, experimental modding toolchain for Minecraft. The server package can
be installed via `{{AUR|fabric-server}}`{=mediawiki}.

Be sure to read [#Configuration](#Configuration "#Configuration"){.wikilink} and replace `{{ic|minecraftd}}`{=mediawiki}
with `{{ic|fabricd}}`{=mediawiki} wherever you encounter it.

### Quilt

[Quilt](https://quiltmc.org/) is an open-source, community-driven modding toolchain designed primarily for Minecraft.
The server package can be installed via `{{AUR|quilt-server}}`{=mediawiki}.

Be sure to read [#Configuration](#Configuration "#Configuration"){.wikilink} and replace `{{ic|minecraftd}}`{=mediawiki}
with `{{ic|quiltd}}`{=mediawiki} wherever you encounter it.

It is originally forked from Fabric, meaning it is mostly backwards compatible with Fabric mods.

## Tips and tricks {#tips_and_tricks}

### Minecraft server port {#minecraft_server_port}

```{=mediawiki}
{{Expansion|Document SRV record support to allow the use of a non-default port without needing to specify the port when using domain names}}
```
By default Minecraft servers run on port `{{ic|25565}}`{=mediawiki}, this port is assumed if an address is entered
without a port specified.

Most Minecraft server providers will charge a premium for a server with the default minecraft port, therefore if your
port differs from `{{ic|25565}}`{=mediawiki} you must specify the port by appending a colon (**:**) to the end of the
hostname or address followed by the port which was allocated to your server, for example if you address was
`{{ic|43.12.122.96}}`{=mediawiki} and port was `{{ic|28543}}`{=mediawiki} you would connect to
`{{ic|43.12.122.96:28543}}`{=mediawiki}.

## See also {#see_also}

- There are several server wrappers available providing everything from automatic backup to managing dozens of servers
  in parallel; refer to [Server Wrappers](https://minecraftservers.gamepedia.com/Server_wrappers) for more information.
  However, the management script provided by the [AUR](AUR "AUR"){.wikilink} packages should suffice most needs.
- You might want to set up a [systemd timer](systemd_timer "systemd timer"){.wikilink} with e.g.
  [mapper](https://minecraft.wiki/wiki/Programs_and_editors#Mappers) to generate periodic maps of your world.
- Be sure to take periodic backups e.g. using the provided management script (see
  [#Configuration](#Configuration "#Configuration"){.wikilink}) or plain [rsync](rsync "rsync"){.wikilink}.

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}
[Category:Servers](Category:Servers "Category:Servers"){.wikilink}

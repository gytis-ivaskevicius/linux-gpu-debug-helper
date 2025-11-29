[ja:DDRaceNetwork](ja:DDRaceNetwork "wikilink") [pt:DDRaceNetwork](pt:DDRaceNetwork "wikilink") **DDNet**, as it is
popularly known, is a sidescrolling platform game, featuring weaponry and a cooperative gameplay, and is a mod of
[Teeworlds](https://www.teeworlds.com). The game name comes from Dummy Drag Race Network, as it was based in DDRace.

From the official website [ddnet.org](https://ddnet.org):

:   DDraceNetwork (DDNet) is an actively maintained version of DDRace, a Teeworlds modification with a unique
    cooperative gameplay. Help each other play through custom maps with up to 64 players, compete against the best in
    international tournaments, design your own maps, or run your own server. The official servers are located in
    Germany, Russia, USA, Canada, China, Japan, Singapore, Chile, Brazil, South Africa and Australia. All ranks made on
    official servers are available worldwide and you can collect points!

You control a *tee*, a ball-shaped 2D character, using your keyboard and mouse to shoot, grapple hook and jump around to
interact with other players and the environment in the map with the finish line as target.

The game works in a client--server model, where the user plays using a Client which connects to a local or remote
Server. Since DDNet has official servers, you most likely will only start the Client and play online.

## Installation

[Install](Install "wikilink") the `{{AUR|ddnet}}`{=mediawiki} package.

## Play

To play DDNet, run the command `{{bc|$ DDNet}}`{=mediawiki} or run the `{{ic|.desktop}}`{=mediawiki} file provided in
the package (e.g. in GNOME, search for \"ddnet\" in its Activities Overview)

It is very straightforward -- all user configuration (skin selection, video, controls etc.) can be done from the GUI of
the DDNet Client.

No server setup is required; if you want to set up a local server, see [#Server](#Server "wikilink").

Also, some extra tools -- which you probably will not need -- are available in
`{{ic|/usr/lib/ddnet/tools/}}`{=mediawiki}. See [#Extra tools](#Extra_tools "wikilink").

### Gametypes

Gametypes (a.k.a. game types or game modes) are different ways of playing Teeworlds-like games (DDNet included!), and
different ways of exploring its resources (e.g. physics, weapons kill or just push other players, etc.).

In the main dashboard of DDNet Client, several server instances are listed (not only DDNet\'s), each one is launched
with only one gametype. In order to play a gametype, you have to join the server instance that has the desired gametype
(e.g. you want to play \"ctf\", you have to look for and join a \"ctf\" server instance)

See below a non-exhaustive list with name and an explanation of gametypes that can be found in DDNet official servers
(although there are a lot more).

#### DDNet gametypes {#ddnet_gametypes}

These are the official DDNet gametypes, which DDNet maintains. That means these gametypes\' maps are stored and made
available in DDNet\'s maps repository. It also means that the Test Staff runs some test before the maps being added to
the repository and published.

Some of these might require DDNet Client due to features (e.g. dummy *tee*, teaming, specific key bindings) that this
client provides, but other could be played with other clients, like Teeworlds.

The goal of these maps, unless mentioned otherwise below, is to overcome obstacules and other difficulties of the map,
while helping each other, in order to reach the finish line of map.

This set of gametypes consists of:

-   **novice** -- The easiest collaborative maps can be found here. Newcomers should start here.
-   **moderate** -- Moderate-level collaborative maps for more experienced users.
-   **brutal** -- Hard collaborative maps for very experienced users.
-   **insane** -- Insanely hard collaborative maps for insanely experienced users.
-   **solo** -- Play alone the whole map, without any a dummy or any physical interaction with users (you can chat with
    other players, though)
-   **ddmax** -- Maps from DDracemaX, one of the first race mod and very popular one. This project discontinued, so
    DDNet adopted[1](https://forum.ddnet.org/viewtopic.php?f=3&t=1253) its maps and made available in official servers.
    See [2](https://forum.ddnet.org/viewtopic.php?f=3&t=1253&start=50#p13111) for info of this gametype.
-   **dummy** -- Move your dummy to the finish line, collaboratively or solo depending on the map.
-   **oldschool** -- Some old maps to make long-time players nostalgic.
-   **race** -- Reach the finish line as fast as you can in a solo run.

```{=mediawiki}
{{Note|When looking at the server list of the client dashboard, you may notice that all DDNet server instances have Type column as ''DDRace'', and the server instance's name will include the gametype listed above, e.g. "DDNet GER - DDmaX [DDRaceNetwork]"}}
```
#### Vanilla gametypes {#vanilla_gametypes}

The so-called *vanilla* gametypes are the first ones, and were created in Teeworlds, and which DDNet supports. This set
of gametypes include:

-   *dm* (*d*eath*m*atch) -- The goal is to kill as many players as possible until you reach the death or time limit.
    The match is over as soon as one of the conditions is met, and the winner is the player that accumulated the
    greatest number of kills.
-   *tdm* (*t*eam *d*eath*m*atch) -- Same as Deathmatch above, except that the players are organized into two teams,
    with each team having its own kill count.
-   *ctf* (*c*apture *t*he *f*lag) -- Two teams each have a flag (red for red team and blue for blue team) and the
    objective is to capture the other team\'s flag, located at the team\'s \"base,\" and bring it safely back to their
    own base until reach a certain score or the time runs out. Kill the enemy to avoid having your flag captured or to
    get the flag back to your team\'s base.

#### Blocker gametype {#blocker_gametype}

```{=mediawiki}
{{Note|You will find it with type ''ddrace'', but the server title and map name can be easily identified as Blocker}}
```
**Blocker** has as only target to block other players, which means to fool around throwing into freeze areas. There is
no score or time limit in this type of game, or at least it does not matter.

Please notice that while being a blocker is expected in the blocker gametype, the same does **not** apply to [#DDNet
gametypes](#DDNet_gametypes "wikilink") -- in this last case it is rude and you most likely will be banned by vote of
others.

#### FNG-like gametypes {#fng_like_gametypes}

Types noteworthy: **fng** (discontinued, incompatible), **openfng**
([thread](https://www.teeworlds.com/forum/viewtopic.php?id=7868)), **fng2**
([source](https://github.com/teeworldsmods/teeworlds-fng2)).

In this gametype, the players are divided in 2 teams and the target is to win by making more points. You will points by
hitting the player with hammer or laser gun (the only weapons available), which will cause freeze, and to throwing into
the spikes.

## Configuration

Configurations are stored in plain text files in the user\'s home directory and can be applied in the GUI options or in
the embedded console. See more information below on this topic.

### File and directory for user settings {#file_and_directory_for_user_settings}

The directory `{{ic|$HOME/.teeworlds/}}`{=mediawiki} stores user configuration, demos, screenshots downloaded maps and
other user contents.

```{=mediawiki}
{{ic|settings_ddnet.cfg}}
```
is where user\'s configuration is stored, in a simple text format in a proper syntax. This file is loaded by the Client
on startup, and updated when exiting. Therefore, you are not required to set your settings manually in the configuration
file. For all supported client settings, see [Client Settings](https://ddnet.org/settingscommands/#client-settings).

The subdirectory `{{ic|downloadedmaps/}}`{=mediawiki} will store maps downloaded in runtime by DDNet Client when
connecting to server instances, if the maps are not available already.

```{=mediawiki}
{{Tip|With {{aur|ddnet-maps-git}} installed, you avoid having to download maps while connecting to server instances}}
```
### Optional skins {#optional_skins}

You can choose between many skins to play with a fancy *tee* char. However, this will not affect anything in the
gameplay.

DDNet features automatic, on-demand download of tee skins. To use this feature make sure to have enabled Settings \>
*Tee* \> *Download skins*.

Alternatively, skins can be manually download from the [DDNet Skin Database](https://ddnet.org/skins/) and manually
placed at `{{ic|~/.teewords/downloadedskins}}`{=mediawiki} to be recognized by the DDNet Client.

```{=mediawiki}
{{Tip|Consider submitting your custom skins to DDNet Skin Database so that other users can see it as well. See [https://ddnet.org/discord #info and #submit-skins channels under "Skins Submission" in DDNet Discord server].}}
```
### Optional offline maps {#optional_offline_maps}

When playing DDNet, maps are downloaded on demand (i.e. whenever you enter join a server with a map that hasn\'t been
downloaded yet).

However, there are scenarios where need to have **all** DDNet maps available:

-   To play without Internet connection, using a local server
-   To serve a DDNet Server for a LAN play with friends, which local time records.

To have all playable DDNet maps available offline, [install](install "wikilink") `{{aur|ddnet-maps-git}}`{=mediawiki}.

## Server

```{=mediawiki}
{{Expansion|Much more information could be added here, like specific instructions for setting up, NAT forwarding etc.}}
```
Although a local DDNet server is not required for playing DDNet (See [#Play](#Play "wikilink")), one may want to run it
for playing without Internet connection, want to avoid high latency (\"ping\" in the game interface) of servers on the
Internet, simply want to test features, etc.

There are two methods for starting a DDNet server: [via the client\'s main
menu](#Server_via_the_client's_main_menu "wikilink") and [via systemd service](#Server_via_systemd_service "wikilink").

For more info, see [Server Features](https://ddnet.org/server/), [Server
Settings](https://ddnet.org/settingscommands/#server-settings), [Server
Commands](https://ddnet.org/settingscommands/#server-commands), and much more in [DDNet
Forums](https://forum.ddnet.org/).

```{=mediawiki}
{{Tip|Consider to [[#Optional offline maps|install DDNet maps and configurations]] for an easy server setup.}}
```
### Server via the client\'s main menu {#server_via_the_clients_main_menu}

On DDNet client startup, press *Run server* button. Now press *Play* button and browse the *LAN* tab for your local
server.

This is the easiest option for playing by yourself (with your dummy) or for testing a map that you created/edited.

### Server via systemd service {#server_via_systemd_service}

[Start](Start "wikilink") (optionally, [enable](enable "wikilink") as well) `{{ic|ddnet-server.service}}`{=mediawiki}
[systemd](systemd "wikilink") unit file. Now, in the DDNet Client, press *Play* button and browse the *LAN* tab for your
local server.

This unit file runs the server instance as the system user `{{ic|ddnet}}`{=mediawiki} from its home folder
`{{ic|/var/lib/ddnet/}}`{=mediawiki} as working directory, having log messages available in
`{{ic|/var/lib/ddnet/autoexec_server.log}}`{=mediawiki} file and via [systemd journal](systemd_journal "wikilink")
command-line `{{ic|journactl -u ddnet-server}}`{=mediawiki}.

This option is could be better for playing with friends or running a server-only instance global wide, as it excludes
the need for firing up the DDNet Client.

### MySQL support {#mysql_support}

The DDNet packages have MySQL/MariaDB support enabled. This allows you store records achieved in a local server.

In case you want to disable MySQL support on buildtime, edit the DDNet package\'s [PKGBUILD](PKGBUILD "wikilink") by
setting the `{{ic|-DMYSQL}}`{=mediawiki} to `{{ic|OFF}}`{=mediawiki}, and remove the dependency
`{{Pkg|mariadb-libs}}`{=mediawiki}.

## Extra tools {#extra_tools}

DDNet packages comes with command-line tools that can be used for the propose of debugging (mostly used when developing
DDNet) and mapping (mostly used when creating or improving maps for DDNet).

These tools are available in `{{ic|/usr/lib/ddnet/}}`{=mediawiki} in the DDNet packages.

See [Extra tools](https://wiki.ddnet.org/wiki/Extra_tools) in DDNet Wiki for a list and description of these tools.

## See also {#see_also}

-   [DDNet official website](https://ddnet.org/)
-   [DDNet Forum](https://forum.ddnet.org/)
-   [DDNet Wiki](https://wiki.ddnet.org/)
-   [DDNet source code repository](https://github.com/ddnet/ddnet)
-   [The History of DDNet](https://forum.ddnet.org/viewtopic.php?f=3&t=1824)
-   [Tutorials and other useful links](https://forum.ddnet.org/viewtopic.php?f=35&t=2420)

[Category:Gaming](Category:Gaming "wikilink")

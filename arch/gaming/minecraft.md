[de:Minecraft](de:Minecraft "wikilink") [hu:Minecraft](hu:Minecraft "wikilink") [ja:Minecraft](ja:Minecraft "wikilink")
[zh-hans:Minecraft](zh-hans:Minecraft "wikilink") `{{Style|
* Does not follow the conventional format for most pages, encapsulates a lot of different software, which gets highly confusing whether this is a minecraft install guide or whether this is a package page
* These guides and troubleshooting should be split off into dedicated pages to be more clear. Compressing them all into a single page is messy and hard to find the information you want.
* The page would benefit from the use of a "software" category, listing all the software, and linking to the dedicated page if there is one for it.
}}`{=mediawiki}

[Minecraft](https://minecraft.net/en-us/) is a game about breaking and placing blocks. At first, people built structures
to protect against nocturnal monsters, but as the game grew, players worked together to create wonderful, imaginative
things.

There are two separate editions of this game: Minecraft Java Edition, and Bedrock Edition. Java Edition is the original
version of the game, starting development back in 2009. This edition can be played on Mac, Windows and Linux. Bedrock
Edition was originally Pocket Edition, but has since been ported to different platforms. It is currently supported on
Windows 10 and 11, Amazon FireOS and FireTV, Android, iOS, Xbox One, Playstation 4, Nintendo Switch and Samsung Gear VR
devices. The Bedrock Edition client is not supported on Linux officially, but Bedrock server software is available.

## Client

### Java Edition {#java_edition}

#### Installation

The Minecraft client can be installed via the `{{AUR|minecraft-launcher}}`{=mediawiki} package. It provides the official
game launcher, a script to launch it and a *.desktop* file. The package is officially recommended by Mojang on their
website.

#### Firewall configuration for Client/LAN worlds {#firewall_configuration_for_clientlan_worlds}

Most shared Minecraft worlds are hosted using dedicated Minecraft servers. For more information about hosting dedicated
servers, see the [#Server](#Server "wikilink") section below.

A simpler way is to allow others to join your current Minecraft game. When playing, your Minecraft client also allows
others to join the game in progress. Your client automatically broadcasts the info about your game on port 4445. It will
also listen for TCP connections on which other players join. This TCP listening port is picked at random every time you
start Minecraft. This works well if you do not have a firewall. But if your firewall blocks incoming TCP connections,
then it is very tricky to allow this random port in.

To allow your client to host a local LAN game, your [firewall](firewall "wikilink") needs to allow:

-   UDP port `{{ic|4445}}`{=mediawiki} to broadcast your game.
-   A TCP port to allow friends to join your game.

```{=mediawiki}
{{Tip|After a world has been opened to LAN, a confirmation message will be sent to the game's chat with the TCP port number. For example: {{ic|Local game hosted on port ''port_number''.}}}}
```
See also:

-   [Setting up a LAN world](https://minecraft.wiki/w/Tutorials/Setting_up_a_LAN_world).

### Bedrock Edition {#bedrock_edition}

The unofficial Bedrock Minecraft client can be installed by `{{AUR|mcpelauncher-ui}}`{=mediawiki} package, which is the
UI interface for `{{AUR|mcpelauncher-linux}}`{=mediawiki}.

### Minecraft Education {#minecraft_education}

[Minecraft Education](https://minecraft.wiki/w/Minecraft_Education) can be used as an alternative way of running
Minecraft with online features stripped out, since the code is mostly based on the Minecraft for Windows 10 edition
(i.e. a win32 codebase).

It can be installed manually and runs fine with [Wine](Wine "wikilink") or [Proton](Proton "wikilink").

Additionally, Minecraft Education can be used as a gateway to Minecraft RTX running on Linux using
`{{Pkg|vkd3d}}`{=mediawiki} (This is exclusive to the Microsoft store, x64 release of Minecraft Education).

```{=mediawiki}
{{Note|Since version 1.19.50, Microsoft Authentication no longer works on [[Wine]] within Minecraft Education. This is due to changes in the login procedure.}}
```
## Server

### Java Edition {#java_edition_1}

See [Minecraft/Java Edition server](Minecraft/Java_Edition_server "wikilink") for more information on how to set up a
Minecraft Java server.

### Bedrock Edition {#bedrock_edition_1}

#### Installation {#installation_1}

The Bedrock Minecraft server can be installed via the `{{aur|minecraft-bedrock-server}}`{=mediawiki} package. It
provides a [systemd](systemd "wikilink") unit file. This package creates a separate
`{{ic|minecraft-bedrock}}`{=mediawiki} account.

To start the server, you may either use systemd or run it directly from the command line. Using systemd, you may
[start](start "wikilink") and [enable](enable "wikilink") the included
`{{ic|minecraft-bedrock-server.service}}`{=mediawiki}. Alternatively, run the following as the minecraft-bedrock user
inside the `{{ic|/opt/minecraft-bedrock-server}}`{=mediawiki} directory:

`$ LD_LIBRARY_PATH=. ./bedrock_server`

#### Configuration

The configuration file `{{ic|server.properties}}`{=mediawiki} contains the server settings and additional documentation.
Most importantly, `{{ic|server-port}}`{=mediawiki} determines the `{{ic|UDP}}`{=mediawiki} port at which the server will
listen for incoming connections. The default port is `{{ic|19132}}`{=mediawiki} for IPv4, and `{{ic|19133}}`{=mediawiki}
for IPv6. UDP ports `{{ic|43351}}`{=mediawiki} for IPv4 and `{{ic|51885}}`{=mediawiki} for IPv6 are required for
authentication.

## Minecraft mod launchers {#minecraft_mod_launchers}

You can launch Minecraft from different so called *launchers* that often include an array of modpacks to enhance one\'s
gameplay and add [mods](https://minecraft.wiki/Mods).

-   ```{=mediawiki}
    {{App|ATLauncher|Minecraft ModPack launcher consisting of multiple different modpacks made by the community.|https://atlauncher.com/|{{AUR|atlauncher}}}}
    ```

-   ```{=mediawiki}
    {{App|Badlion Client|PvP modpack for all modern versions of Minecraft.|https://client.badlion.net|{{AUR|badlion-client}}}}
    ```

-   ```{=mediawiki}
    {{App|CheatBreaker Client|The free FPS boosting modpack for Minecraft 1.7 & 1.8|https://cheatbreaker.net/|{{AUR|cheatbreaker}}}}
    ```

-   ```{=mediawiki}
    {{App|Feed The Beast|Originated as a custom challenge map in Minecraft that made heavy use of multiple tech mods, and later evolved into a mod package launcher.|https://www.feed-the-beast.com/|{{AUR|ftb-app}}, {{AUR|feedthebeast-classic}}}}
    ```

-   ```{=mediawiki}
    {{App|GDLauncher Carbon|Open-source Minecraft launcher written in Electron/React.|https://gdlauncher.com/|{{AUR|gdlauncher-carbon-bin}}}}
    ```

-   ```{=mediawiki}
    {{App|Hello Minecraft Launcher|Open-source Minecraft launcher supports Mod Management, Game Customizing, Auto Installing, Modpack Creating, UI Customization...|https://github.com/HMCL-dev/HMCL|{{AUR|hmcl}}}}
    ```

-   ```{=mediawiki}
    {{App|Labymod Launcher|LabyMod Launcher for launching LabyMod, which is a Minecraft client that adds bunch of useful features|https://www.labymod.net/|{{AUR|labymodlauncher-appimage}} and {{aur|labymodlauncher}}}}
    ```

-   ```{=mediawiki}
    {{App|LauncherX|Next generation Minecraft launcher with powerful features and pleasing UI.|https://corona.studio/lx|{{AUR|launcherx}}}}
    ```

-   ```{=mediawiki}
    {{App|Lunar Client|PvP modpack for all modern versions of Minecraft.|https://lunarclient.com|{{AUR|lunar-client}}}}
    ```

-   ```{=mediawiki}
    {{App|Modrinth Launcher|The open-source, lightweight and official Modrinth launcher.|https://modrinth.com/|{{AUR|modrinth-app-git}}}}
    ```

-   ```{=mediawiki}
    {{App|MultiMC|Sandbox environment manager for separable pack association.|https://multimc.org/|{{AUR|multimc-bin}}}}
    ```

-   ```{=mediawiki}
    {{App|PolyMC|Power user launcher with features like mod management. Originally forked from MultiMC.|https://polymc.org/|{{AUR|polymc}}, {{AUR|polymc-qt5}}}}
    ```

-   ```{=mediawiki}
    {{App|portablemc|Cross-platform command-line Minecraft launcher and API for developers. Supports mod loaders such as Fabric, Forge, NeoForge and Quilt.|https://github.com/mindstorm38/portablemc|{{AUR|portablemc}}}}
    ```

-   ```{=mediawiki}
    {{App|Prism Launcher| Power user launcher with features like mod management. Originally forked from MultiMC, now forked from PolyMC.|https://prismlauncher.org/|{{Pkg|prismlauncher}}, {{AUR|prismlauncher-qt5}}}}
    ```

-   ```{=mediawiki}
    {{App|SKlauncher|A free Minecraft Launcher supporting skins and capes.|https://skmedix.pl|{{AUR|sklauncher-bin}}}}
    ```

-   ```{=mediawiki}
    {{App|Technic Launcher|Modpack installer with a focus on mod discovery via popularity rankings.|https://www.technicpack.net/|{{AUR|minecraft-technic-launcher}}}}
    ```

## Other programs and editors {#other_programs_and_editors}

There are several [programs and editors](https://minecraft.wiki/Programs_and_editors) which can make your Minecraft
experience a little easier to navigate. The most common of these programs are map generators. Using one of these
programs will allow you to load up a Minecraft world file and render it as a 2D image, providing you with a top-down map
of the world.

-   ```{=mediawiki}
    {{App|AMIDST|Standing for Advanced Minecraft Interface and Data/Structure Tracking, it is a program that aids in the process of finding structures, biomes, and players in Minecraft worlds. It can draw the biomes of a world out and show where points of interest are likely to be by either giving it a seed, telling it to make a random seed, or having it read the seed from an existing world (in which case it can also show where players in that world are). The project has been forked in the past, of which the most notable one is "Amidst Exporter" ({{AUR|amidstexporter}}) which includes a patch for calculating Ocean Monument locations in 1.8+ worlds.|https://github.com/toolbox4minecraft/amidst|{{AUR|amidst}}}}
    ```

```{=html}
<!-- -->
```
-   ```{=mediawiki}
    {{App|Mapcrafter|A high performance Minecraft map renderer written in C++ which renders worlds to maps with an 3D-isometric perspective. You can view these maps in any webbrowser hence they are easily deployed on one's server. Mapcrafter has a simple configuration file format to specify worlds to render, different rendermodes such as day/night/cave and can also render worlds from different rotations.|https://github.com/mapcrafter/mapcrafter|{{AUR|mapcrafter-git}}}}
    ```

```{=html}
<!-- -->
```
-   ```{=mediawiki}
    {{App|MCA Selector|An external tool to export or delete selected chunks and regions from a world save of Minecraft Java Edition.|https://github.com/Querz/mcaselector|{{AUR|mcaselector}}}}
    ```

```{=html}
<!-- -->
```
-   ```{=mediawiki}
    {{App|Minutor|A minimalistic map generator for Minecraft. You are provided with a simple GTK based interface for viewing your world. Several rendering modes are available, as well as custom coloring modes and the ability to slice through z-levels.|http://seancode.com/minutor/|{{AUR|minutor-git}}}}
    ```

## Troubleshooting

### Logs

```{=mediawiki}
{{Merge|Minecraft/Java Edition server|Better fit for the page which talks about the server side.}}
```
Screen logs are in `{{ic|/tmp/spigot_spigot_command_dump.txt}}`{=mediawiki} file. If *systemctl* fails to start the
service, inspect the *screen* logs.

[Journal](Journal "wikilink") logs are under `{{ic|spigot.service}}`{=mediawiki}.

### Client or server does not start {#client_or_server_does_not_start}

It might be a problem with the [Java](Java "wikilink") version. Different Minecraft version numbers have different JRE
requirements.

  Minecraft Version   Minimum Compatible JRE Version
  ------------------- --------------------------------
  \< 1.17             8
  1.17                16
  \<= 1.20.4          17
  \> 1.20.4           21

```{=mediawiki}
{{Warning|
* Note that the client/server work with newer versions of [[Java]], such as {{Pkg|jre-openjdk}}, but the Minecraft game launcher (and possibly mods) might only work with [[Java]] version 8.
* If running an old Minecraft version, it is also recommended to run it with its potentially old "Minimum Compatible JRE Version". For example, the 1.20.1 is compatible with the JRE 17 and 21, but not with the JRE 24.
}}
```
```{=mediawiki}
{{Tip|When multiple Java environments are installed, one can switch between them using {{ic|archlinux-java}}.}}
```
### Broken fonts with MinecraftForge {#broken_fonts_with_minecraftforge}

Force Unicode fonts from the language menu.

Since you cannot read any of the menu options: in the main menu, choose the bottom-left most button is Options,
second-from-the-bottom on the left side is the Language Button. From there, the Force Unicode Font button is on the
bottom, on the left side.

### MultiMC forks unable to build {#multimc_forks_unable_to_build}

If you are trying to install one of *multimc5* forks like (`{{AUR|polymc}}`{=mediawiki}) and get an error similar to:

```{=mediawiki}
{{bc|
No CMAKE_Java_COMPILER could be found.
Tell CMake where to find the compiler by setting either the environment
variable "JAVA_COMPILER" or the CMake cache entry CMAKE_Java_COMPILER to
the full path to the compiler, or to the compiler name if it is in the
PATH.
}}
```
The error could be caused by Java missing, which can be fixed by installing `{{Pkg|jdk8-openjdk}}`{=mediawiki}. If the
error is not fixed by that or Java was properly installed in the first place, the wrong version could still be the
default environment:

```{=mediawiki}
{{hc|$ archlinux-java status|
Available Java environments:
  java-13-openjdk (default)
  java-8-openjdk
}}
```
You can set the default java version using `{{ic|archlinux-java set ''version''}}`{=mediawiki}.

### Cannot change pulseaudio sink {#cannot_change_pulseaudio_sink}

If you are unable to switch the audio output device (indicated by `{{ic|DONT_MOVE}}`{=mediawiki} flag in the output of
`{{ic|pacmd list-sink-inputs}}`{=mediawiki}), then the following openalsoft config may help

```{=mediawiki}
{{hc|1=~/.alsoftrc|2=
[pulse]
allow-moves=yes
}}
```
### Audio stutters on PipeWire or Java crashes with SIGFPE {#audio_stutters_on_pipewire_or_java_crashes_with_sigfpe}

OpenAL defaults to using JACK over PipeWire\'s PulseAudio backend. If that causes issues for you, you can tell OpenAL to
use Pulse instead:

```{=mediawiki}
{{hc|1=~/.alsoftrc|2=
drivers=pulse
}}
```
Alternatively, you can set the following environment variable `{{ic|1=ALSOFT_DRIVERS=pulse}}`{=mediawiki} if you do not
want to set it for all applications.

### Minecraft does not start on native Wayland {#minecraft_does_not_start_on_native_wayland}

You may see an error like
`{{ic|GLFW error 65548: Wayland: The platform does not support setting the window icon}}`{=mediawiki}.

This is because of the version of GLFW bundled with Minecraft defaulting to X. If you do not want to use
[Xwayland](Xwayland "wikilink"), you can resolve this by using the system installation of `{{Pkg|glfw}}`{=mediawiki}:

-   For MultiMC-based launchers (like `{{Pkg|prismlauncher}}`{=mediawiki}) check *Workarounds \> Native Settings \> Use
    system GLFW* in the instance settings.
-   For others, add `{{ic|1=-Dorg.lwjgl.glfw.libname=/usr/lib/libglfw.so}}`{=mediawiki} to the java command in the
    settings.

```{=mediawiki}
{{Warning|Native Wayland is not officially supported and the Forge and NeoForge mod loaders may not launch at all.}}
```
```{=mediawiki}
{{Note|
* There is a bug present which will prevent the cursor from being centered when opening menus, leading to a suboptimal experience. This can be fixed by installing {{AUR|glfw-wayland-minecraft-cursorfix}}.
* You can use [https://modrinth.com/mod/vulkanmod VulkanMod] to add native support for Wayland.
}}
```
### 2 and 6 do not work when pressed in combination with shift on legacy versions {#and_6_do_not_work_when_pressed_in_combination_with_shift_on_legacy_versions}

This is a problem caused by LWGLJ2. There are a few ways to fix it:

-   Use a client that uses an updated version of LWGLJ or adds the patch themselves.
-   Switch keyboard layout to a different one (e.g. German).
-   Use mods to fix it. On 1.8.9 Forge, you can use [mckeyboardfix](https://github.com/Leo3418/mckeyboardfix).

## See also {#see_also}

-   [Official Minecraft site](https://www.minecraft.net/)
-   [Minecraft community links](https://www.minecraft.net/community)
-   [Minecraft Wiki](https://minecraft.wiki/)
-   [Minecraft Client and Server download link](https://minecraft.net/download)
-   [Crafting Recipes](https://www.minecraft.wiki/wiki/Crafting)
-   [Block and item data values](https://www.minecraft.wiki/wiki/Data_values)
-   [Reddit Minecraft community](https://www.reddit.com/r/minecraft)
-   [Minecraft Skins](https://www.minecraftskins.net)

[Category:Gaming](Category:Gaming "wikilink")

`{{Note|Star Citizen is still in active development and therefore currently in the alpha state. Any information in this article may be outdated after a game update.}}`{=mediawiki}

[Star Citizen](Wikipedia:Star_Citizen "wikilink") is a crowdfunded
[MMO](Wikipedia:Massively_multiplayer_online_game "wikilink") [first
person](Wikipedia:First-person_(video_games) "wikilink") [space flight
simulator](Wikipedia:Space_flight_simulation_game "wikilink"), developed by Cloud Imperium Games. The game does not
natively support Linux, but there have been promises for a native version.

## Installation

Star Citizen can be [installed](install "wikilink") using the community developed `{{AUR|lug-helper}}`{=mediawiki},
which runs the game under a custom, Star Citizen tuned [Wine runner](https://github.com/starcitizen-lug/lug-wine).

### Alternatives

There are some alternative ways to install the game without using the LUG Helper:

```{=mediawiki}
{{Note|"Frequently successful" rates if the install has a predictable success rate. Third party launchers are by default considered as "unstable".}}
```
+--------------------------------------------------------------------------+-----------------------+-----------------+
| Installation                                                             | Frequently successful | Managed by LUG  |
+==========================================================================+=======================+=================+
| [Flatpack](https://github.com/mactan-sc/rsilauncher)                     | ```{=mediawiki}       | ```{=mediawiki} |
|                                                                          | {{Yes}}               | {{Yes}}         |
|                                                                          | ```                   | ```             |
+--------------------------------------------------------------------------+-----------------------+-----------------+
| [Proton](https:/                                                         | ```{=mediawiki}       | ```{=mediawiki} |
| /wiki.starcitizen-lug.org/Alternative-Installations#proton-installation) | {{Yes}}               | {{No}}          |
|                                                                          | ```                   | ```             |
+--------------------------------------------------------------------------+-----------------------+-----------------+
| [Lutris](https://lutris.net/games/star-citizen/)                         | ```{=mediawiki}       | ```{=mediawiki} |
|                                                                          | {{No}}                | {{No}}          |
|                                                                          | ```                   | ```             |
+--------------------------------------------------------------------------+-----------------------+-----------------+
| [Heroic](https://w                                                       | ```{=mediawiki}       | ```{=mediawiki} |
| iki.starcitizen-lug.org/Alternative-Installations#heroic-games-launcher) | {{No}}                | {{No}}          |
|                                                                          | ```                   | ```             |
+--------------------------------------------------------------------------+-----------------------+-----------------+
| [Bott                                                                    | ```{=mediawiki}       | ```{=mediawiki} |
| les](https://wiki.starcitizen-lug.org/Alternative-Installations#bottles) | {{No}}                | {{No}}          |
|                                                                          | ```                   | ```             |
+--------------------------------------------------------------------------+-----------------------+-----------------+
| [Fagus](htt                                                              | ```{=mediawiki}       | ```{=mediawiki} |
| ps://wiki.starcitizen-lug.org/Alternative-Installations#faugus-launcher) | {{No}}                | {{No}}          |
|                                                                          | ```                   | ```             |
+--------------------------------------------------------------------------+-----------------------+-----------------+

## Usage

`$ lug-helper [ -options ]`

The lug helper comes with both a graphical and terminal interface. By default, it will start with the graphical
interface, prompting the user with a [zenity](zenity "wikilink") selection menu.

The terminal based mode can be forced using the `{{ic|--no-gui}}`{=mediawiki} or `{{ic|-g}}`{=mediawiki} option. For a
list of all available command-line options run:

`$ lug-helper --help`

### Game installation {#game_installation}

To install the game either select the corresponding options in the graphical interface or run:

`$ lug-helper --no-gui -i`

### Post-installation {#post_installation}

After installing the game, there are still some recommended options to modify:

-   [Non-US keyboard layout configuration](https://wiki.starcitizen-lug.org/Troubleshooting/mouse-keyboard-issues)
-   [Wayland issue workarounds](https://wiki.starcitizen-lug.org/Troubleshooting/mouse-keyboard-issues)
-   [NVIDIA](https://wiki.starcitizen-lug.org/Troubleshooting/nvidia#severe-frame-drops)

### Troubleshooting

Because Star Citizen does not have native Linux support, there are a number of issues that can arise during the
installation or while running the game.

For any sort of issue with the LUG Helper or the game in general, refer to the corresponding section on the [LUG
Wiki](https://wiki.starcitizen-lug.org/Troubleshooting/)

## Configuration

There are some ways to customize how the game is being run, as well as options to configure in-game behavior.

### Alternative wine runners {#alternative_wine_runners}

Although the standard LUG Wine Runner is preferred by most users, there may still be some who want to try out other
runners. This is a small list of runners recommended by the [LUG
Wiki](https://wiki.starcitizen-lug.org/Tips-and-Tricks#recommended-runners):

-   [RawFox](https://github.com/starcitizen-lug/raw-wine)
-   [Mactan](https://github.com/mactan-sc/mactan-sc-wine)

### Modifying launch script {#modifying_launch_script}

The installation using the LUG Helper creates a Star Citizen launch scripts which can be easily modified by the user. An
upstream version of this script can be found on the [LUG Helper
GitHub](https://github.com/starcitizen-lug/lug-helper/blob/main/lib/sc-launch.sh) Page.

An example of this may be the addition of [environment variables](environment_variables "wikilink") to active certain
features, e.g. performance profilers:

`export DXVK_HUD=fps,compiler`\
`export MANGOHUD=1`

### User configuration {#user_configuration}

Star Citizen supports user configuration files, which can specify graphics options, show debug displays and more.

To make use of this feature, create a file called `{{ic|USER.cfg}}`{=mediawiki} in the Star Citizen LIVE directory. When
using wine, this directory is commonly located under:
`{{ic|./drive_c/Program Files/Roberts Space Industries/StarCitizen/LIVE}}`{=mediawiki}. This also applies for custom
installation directory names and alternative game version installations.

For available console commands, see the [Console Commands](https://starcitizen.tools/Console_commands) page on the
unofficial [Star Citizen Wiki](https://starcitizen.tools/).

## See also {#see_also}

-   [The LUG Wiki](https://wiki.starcitizen-lug.org/)
-   [The LUG GitHub Organization](https://github.com/starcitizen-lug)

[Category:Gaming](Category:Gaming "wikilink")

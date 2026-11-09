[ja:OpenTTD](ja:OpenTTD "ja:OpenTTD"){.wikilink} [zh-hans:OpenTTD](zh-hans:OpenTTD "zh-hans:OpenTTD"){.wikilink} OpenTTD
is a free re-implementation of the popular DOS game [Transport Tycoon
Deluxe](Wikipedia:Transport_Tycoon_Deluxe "Transport Tycoon Deluxe"){.wikilink}. You are a transport company owner, and
you must manage it over the years in order to make profit.

## Installation

[Install](Install "Install"){.wikilink} the `{{Pkg|openttd}}`{=mediawiki} package.

If you do not own the original game, `{{Pkg|openttd-opengfx}}`{=mediawiki} and `{{Pkg|openttd-opensfx}}`{=mediawiki}
contains the free graphics & sounds.

Additionally, you may install the free OpenMSX music pack either from
[openttd.org](https://wiki.openttd.org/en/Basesets/OpenMSX), from `{{AUR|openttd-openmsx}}`{=mediawiki} or in-game from
the main menu option *Check Online Content*. You can check [FluidSynth#Standalone
mode](FluidSynth#Standalone_mode "FluidSynth#Standalone mode"){.wikilink} to make sure
[FluidSynth](FluidSynth "FluidSynth"){.wikilink} works properly.

### Original Transport Tycoon Deluxe data (optional) {#original_transport_tycoon_deluxe_data_optional}

OpenTTD can use the non-free graphics and sound data of the original Windows/DOS version of Transport Tycoon Deluxe.

```{=mediawiki}
{{Note|While you can dump the files from either the DOS or the Windows version of the game, only the Windows version provides the original music.}}
```
You can get these files from the game CD-ROM, from an existing install or you get them from the freely available game
installation archive available at [Abandonia](http://www.abandonia.com/en/games/240).

To use the original graphics & sound effects, copy the following files to `{{ic|/usr/share/openttd/data/}}`{=mediawiki}
or `{{ic|~/.openttd/baseset}}`{=mediawiki} :

- Windows : trg1r.grf, trgcr.grf, trghr.grf, trgir.grf, trgtr.grf
- DOS : TRG1.GRF, TRGC.GRF, TRGH.GRF, TRGI.GRF, TRGT.GRF
- sample.cat from either version

For the original soundtrack, copy the files from the gm folder of the original TTD game directory to
`{{ic|~/.openttd/gm}}`{=mediawiki}.

## Tutorial

The game can be quite confusing at first. A good tutorial is available on the wiki
[here](https://wiki.openttd.org/en/Manual/Tutorial/).

For an in-game tutorial, a game script has been implemented. Just download \'Beginner Tutorial\' with the in-game
download manager and load the \'Beginner Tutorial\' scenario.

## Configuration

The OpenTTD main configuration file is located at `{{ic|~/.openttd/openttd.cfg}}`{=mediawiki} and is automatically
created upon first startup.

Various settings in the configuration file can be edited with buttons on the main menu.

## Multiplayer

### Client

Players can join a server using the Multiplayer menu. In multiplayer, fast forwarding, pausing by the player and cheats
are disabled.

All problems with a server should resolve the administrator of the server and are usually not a bug, just a
misconfiguration on the server.

### Server

You can start the server by passing the `{{ic|-D }}`{=mediawiki} argument, e.g.:

`# openttd -D 0.0.0.0:3979`

This starts the server and accepts [additional commands](https://wiki.openttd.org/en/Manual/Console%20Commands).
Configuration is generated and stored in `{{ic|~/.config/openttd/openttd.cfg}}`{=mediawiki} and is read every time the
server starts. It can be overriden with commands issued directly to the server while running. Some settings cannot be
changed during a game.

## Tips and tricks {#tips_and_tricks}

### Heightmaps

OpenTTD allows using a grayscale image as a [heightmap](https://wiki.openttd.org/en/Manual/Heightmap) for landscape
generation. There is an excellent heightmap generator available at [terrain.party](https://terrain.party/), based on
real Earth terrain. Alternatively, you can use the `{{AUR|bother}}`{=mediawiki} application, which can download larger
areas and contains a number of options for fine-tuning the resulting heightmap (see the
[README](https://github.com/bunburya/bother/blob/master/README.md) for some notes on usage). You may further use
`{{Pkg|gimp}}`{=mediawiki} for fine-tuning the heightmap, especially useful are the Levels and Gaussian Blur tools.

### Cheats

```{=mediawiki}
{{Out of date|Cheat menu is now the sandbox option.}}
```
A cheat menu can be shown in a local game by pressing `{{ic|Ctrl+Alt+c}}`{=mediawiki}.

Detailed information about cheats are available for [sandbox (single
player)](https://wiki.openttd.org/en/Manual/Sandbox%20options) and
[multiplayer](https://wiki.openttd.org/en/Manual/Sandbox%20options) modes.

### Multiplayer {#multiplayer_1}

Always set a password for your own company to avoid others taking over. Some servers reset your password after some idle
time.

Chat can be brought up with the `{{ic|t}}`{=mediawiki} letter if the rail building menu is not open.

You can invest in other companies by buying shares (if enabled on server). You can later sell the shares for profit, or
loss.

## Troubleshooting

### Music is not playing {#music_is_not_playing}

The soundtrack of the game is made of [MIDI](MIDI "MIDI"){.wikilink} files. Therefore, you need a [MIDI
synthesizer](MIDI#Synthesizers "MIDI synthesizer"){.wikilink} to play them.

The game will automatically try to use [FluidSynth](FluidSynth "FluidSynth"){.wikilink} with no additional arguments.
Make sure a soundfont is also installed. Usually, installing `{{Pkg|soundfont-fluid}}`{=mediawiki} should enable music
playback.

If for some reason you need/want to use another synthesizer, OpenTTD provides the \"extmidi\" music driver, which allows
you to configure a command to be ran to play music.

```{=mediawiki}
{{Warning|
* When using the extmidi driver, the in-game volume control sliders are disabled and cannot be used to change the volume.
* If the command you want to run is not included in {{ic|$PATH}}, you must specify the absolute path.
}}
```
Edit your openttd.cfg to configure extmidi :

```{=mediawiki}
{{hc|~/.openttd/openttd.cfg|2=
[misc]
musicdriver = "extmidi:cmd=<command>"
}}
```
```{=mediawiki}
{{Note|You can also configure extmidi when starting up the game : {{ic|1=openttd -m extmidi:cmd=<command>}}}}
```
However, extmidi does not allow additionnal arguments in the command. The solution is to use a wrapper script:

```{=mediawiki}
{{hc|~/.openttd/playmidi|
#!/bin/bash

#here, we want to use the [[FluidSynth]] synthesizer with the soundfont
#provided in {{Pkg|soundfont-fluid}} and [[PulseAudio]]

trap "pkill fluidsynth" EXIT
fluidsynth -a pulseaudio -i /usr/share/soundfonts/FluidR3_GM2-2.sf2 $*
}}
```
Mark it as [executable](executable "executable"){.wikilink}.

Then you can specify the full path to the script as the command to be used with extmidi :

```{=mediawiki}
{{hc|~/.openttd/openttd.cfg|2=
[misc]
musicdriver = "extmidi:cmd=/home/<user>/.openttd/playmidi"
}}
```
## See also {#see_also}

- [OpenTTD](https://www.openttd.org)
- [OpenTTD FAQ](https://wiki.openttd.org/en/Archive/Community/FAQ%20troubleshooting)
- [OpenTTD Wiki](https://wiki.openttd.org/en/)

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

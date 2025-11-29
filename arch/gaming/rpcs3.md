[ja:RPCS3](ja:RPCS3 "wikilink") [RPCS3](Wikipedia:RPCS3 "wikilink") is an emulator for PlayStation 3 games.

## Installation

[Install](Install "wikilink") `{{AUR|rpcs3-git}}`{=mediawiki} or `{{AUR|rpcs3-bin}}`{=mediawiki}.

To be able to actually run games, the PlayStation 3 system software is required, as indicated in the [quickstart
guide](https://rpcs3.net/quickstart). Fortunately it is easy to acquire this firmware compared with other Sony systems
like the PlayStation 2. Sony even provides the files online, so it is not necessary to dump anything.
[Download](https://www.playstation.com/en-us/support/hardware/ps3/system-software/) the
`{{ic|PS3UPDAT.PUP}}`{=mediawiki} file by clicking on the big button.

After installing RPCS3, open it and go to *File* \> *Install Firmware*, then choose the downloaded file.

## Configuration

In order to play games comfortably, a [gamepad](gamepad "wikilink") should be present. In the most optimal case, it is
an original PlayStation 3 controller. Other gamepads are supported as well, make sure *Handlers* is set to
`{{ic|evdev}}`{=mediawiki} under the menu entry *Pads*.

## Installing games {#installing_games}

```{=mediawiki}
{{Note|1=Make sure to use an unmodified game dump. See the RPCS3 Wiki article [https://wiki.rpcs3.net/index.php?title=Help:Validating_PlayStation_3_game_dumps Validating PlayStation 3 game dumps] for instructions on checking the validity of a game dump.}}
```
RPCS3 stores its data in `{{ic|$XDG_CONFIG_HOME/rpcs3}}`{=mediawiki}. More game directories can be added. It
differentiates between disc dumps and downloaded (PSN) games. Put disc dumps into the `{{ic|disc}}`{=mediawiki}
directory and the downloaded ones into the `{{ic|game}}`{=mediawiki} directory.

The usual way of running games is pointing rpcs3 to the directory or installing it, if it is a *.pkg* file.

### The difference between downloads and disc dumps {#the_difference_between_downloads_and_disc_dumps}

Downloaded games (or other content, such as DLCs) usually consist of only two files, a key (or license) and the actual
game. The key is usually contained in a tiny *.rap* file, the game is much bigger in size, usually around 10-15
gigabytes. Put both files into `{{ic|game dir/''name of the game''}}`{=mediawiki}. *name of the game* is purely
cosmetic, as this directory only exists so that the files, which may have random names, do not make the directory
listing unreadable.

Disc dumps contain many files and can easily identified by the `{{ic|PS3_GAME}}`{=mediawiki} directory in it.
`{{ic|PS3_GAME/ICON0.png}}`{=mediawiki} and `{{ic|PS3_GAME/PIC1.png}}`{=mediawiki} contain the icon and background for
that specific game.

## Troubleshooting

### Enabling the debug menu {#enabling_the_debug_menu}

Unfortunately many games are still not fully playable and require workarounds. Since not all settings that are visible
by default will help with glitches and other bugs, some important configuration is done in the debug menu. See the
[RPCS3 FAQ](https://wiki.rpcs3.net/index.php?title=Help:Frequently_Asked_Questions#Enabling_Debug_tab) on how to enable
the debug menu.

### The main window looks odd with a system-wide dark theme {#the_main_window_looks_odd_with_a_system_wide_dark_theme}

Users which configured their environment to use dark themes may have problems with the default theme. Go to *Config* \>
*GUI* and choose a different theme.

### Graphics suddenly pop in when compiling shaders {#graphics_suddenly_pop_in_when_compiling_shaders}

Go to *Config* \> *GPU* and set *Shader Mode* to *Async with Shader Interpreter*.

This can help with situations where it takes a while to fully compile the shaders. Objects are invisible until their
shader is compiled, which can ruin the fun of e.g cutscenes.

### Weird graphics errors {#weird_graphics_errors}

If the game once worked perfectly and suddenly stopped working after starting it, clear the cache. It is usually found
in `{{ic|$XDG_CACHE_HOME/rpcs3}}`{=mediawiki} and is safe to remove. This location only contains logs and other things
that can be regenerated without problems, like compiled shaders and PPU modules. Removing this will cause the next
startup to be slower.

```{=mediawiki}
{{Note|This does not apply if it stopped working after an update. [[General troubleshooting#Debugging regressions|Regressions]] are possible and should be reported.}}
```
### Increasing RLIMIT_MEMLOCK {#increasing_rlimit_memlock}

`Failed to set RLIMIT_MEMLOCK size to 2 GiB. Try to update your system configuration`

Install `{{Pkg|realtime-privileges}}`{=mediawiki} and add your own user to the `{{ic|realtime}}`{=mediawiki} [user
group](user_group "wikilink").

## See also {#see_also}

-   [Official website](https://rpcs3.net)
-   [RPCS3 Wiki](https://wiki.rpcs3.net/)
-   <https://emulation.gametechwiki.com/index.php/RPCS3>
-   <https://github.com/RipleyTom/rpcn>

[Category:Emulation](Category:Emulation "wikilink") [Category:Gaming](Category:Gaming "wikilink")

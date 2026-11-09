[ja:Brutal Doom](ja:Brutal_Doom "ja:Brutal Doom"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|List of games}}`{=mediawiki} `{{Related|Gaming}}`{=mediawiki} `{{Related|Doom}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki} [Brutal Doom](https://www.moddb.com/mods/brutal-doom) is a gore-themed gameplay
mod for [Doom](Doom "Doom"){.wikilink} that was created in 2010 by Marcos Abenante (A.K.A. *Sergeant_Mark_IV*). It is
compatible with Doom, The Ultimate Doom, Doom II: Hell on Earth, Final Doom, and other custom WADs. Brutal Doom won the
first ever Cacoward in 2011 for Best Gameplay Mod and a MOTY award for creativity by Mod DB in 2012.

The mod adds features many new graphical effects like additional blood (blood gets splattered on walls and ceilings if
enemies or the player get hit), the ability to blow off body parts with strong weapons like the shotgun, new death
animations, fake flares and 3D blood effects for OpenGL, and the addition of special illuminating effects on projectiles
and pick ups. It is compatible with the source ports ZDoom, GZDoom, Skulltag, and Zandronum.

While primarily a gore mod, it goes further and alters the gameplay by changing the weapons, monster AI, sounds,
graphics, and combat. One such change is the increased difficulty, making enemy behavior much faster, unpredictable and
dangerous (many attacks do double the normal damage to the player) and altering their attacks. It makes the animations
smoother and gives the player new abilities. [\[1\]](https://doom.wikia.com/wiki/Brutal_Doom)
[\[2\]](https://doomwiki.org/wiki/Brutal_Doom)

## Installation

[Install](Install "Install"){.wikilink} the `{{AUR|brutal-doom}}`{=mediawiki} package, which requires having two
`{{ic|gzdoom.ini}}`{=mediawiki} files. Alternatively `{{AUR|gzdoom-git}}`{=mediawiki} can be modified directly as shown
below. However, if you want to be able to run both *gzdoom* and *brutal-doom* separately in order to play both versions,
then you would need the *brutal-doom* package.

### Brutal Doom Mod {#brutal_doom_mod}

Acquire a registered IWAD (Internal WAD) file for [DOOM](https://zdoom.org/wiki/IWAD): `{{ic|doom.wad}}`{=mediawiki},
`{{ic|doom2.wad}}`{=mediawiki}, `{{ic|doomu.wad}}`{=mediawiki}, `{{ic|tnt.wad}}`{=mediawiki}, or
`{{ic|plutonia.wad}}`{=mediawiki}. `{{ic|freedoom1.wad}}`{=mediawiki} and `{{ic|freedoom2.wad}}`{=mediawiki} from
`{{AUR|freedoom}}`{=mediawiki} are also compatible.

Download the *.zip* file containing the *.pk3* for the latest [Brutal
Doom](https://www.moddb.com/mods/brutal-doom/downloads). You may need to install `{{Pkg|unzip}}`{=mediawiki}.

Optionally you can acquire some [metal
music](https://www.moddb.com/mods/brutal-doom/downloads/doom-metal-soundtrack-mod-volume-5) for the gameplay.

Place all the *.wad* and *.pk3* files in a created folder such as `{{ic|/usr/share/games/brutal-doom}}`{=mediawiki}.

### Configuration

Change `{{ic|~/.config/gzdoom/gzdoom.ini}}`{=mediawiki} as follows (the `{{ic|Search.Directories}}`{=mediawiki}
mentioned are the only directories needed):

```{=mediawiki}
{{bc|1=
[IWADSearch.Directories]
Path=/usr/share/games/brutal-doom
...

[FileSearch.Directories]
Path=/usr/share/games/brutal-doom
Path=/usr/share/gzdoom
...

[Global.Autoload]
Path=/usr/share/games/brutal-doom/''modfile''.pk3
Path=/usr/share/games/brutal-doom/DoomMetalVol4.wad
...

vid_defheight=''<height in pixels>''
vid_defwidth=''<width in pixels>''}}
```
*modfile* is the downloaded *.pk3* file. *`<height in pixels>`{=html}* and *`<width in pixels>`{=html}* should be
roughly the size of your screen resolution or preferred size.

The folder permissions for the created folder and files (all the files inside the `{{ic|brutal-doom}}`{=mediawiki}
directory):

`drwxr-xr-x root root brutal-doom`

`-rw-r--r-- root root `*`<files in directory>`{=html}*

To start the program:

`$ gzdoom`

## See Also {#see_also}

- [Brutal Doom on Wikia](https://doom.wikia.com/wiki/Brutal_Doom)

<!-- -->

- [Brutal Doom on Doom Wiki](https://doomwiki.org/wiki/Brutal_Doom)

<!-- -->

- [IWAD files on ZDoom Wiki](https://zdoom.org/wiki/IWAD)

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

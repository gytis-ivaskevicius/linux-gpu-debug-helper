[ja:東方Project](ja:東方Project "wikilink") [zh-hans:Touhou](zh-hans:Touhou "wikilink") [Touhou
Project](Wikipedia:Touhou_Project "wikilink") is the name of a series of *danmaku* games, also known as
[bullet-hell](Wikipedia:Bullet_hell "wikilink") shooters.

Bullet-hell shooters is a genre of [2D](Wikipedia:2D_computer_graphics "wikilink") shooters based on really complex
patterns, which are beautiful and interesting to look at, and implies great difficulty, memorizing patterns and fast
player reaction.

Touhou Project games are one of the most popular of this genre because---among other things---the in-game world is a
giant universe, the music (at least the WAVs in the full version) is spectacular, and---if you have been on the internet
for a while---you might stumble upon its curious fanbase, which has produced videos, music,
[manga](Wikipedia:Manga "wikilink") (Japanese comics) and even unofficial games.

```{=mediawiki}
{{Tip|Despite the difficulty, they can be very addicting games.}}
```
## Installation

[PC-98](Wikipedia:PC-98 "wikilink") games can be played using Linux-native X Neko Project II
emulator---[install](install "wikilink") the `{{AUR|xnp2}}`{=mediawiki} package.

The following packages only depend on [Wine](Wine "wikilink") to run, and [Timidity++](Timidity++ "wikilink") to play
[MIDI](Wikipedia:MIDI "wikilink") music. They install the free trial versions. You can easily replace the trials with
the full game if you have it.

```{=mediawiki}
{{Tip|A [[#Python engine]] is under development to remove the Wine dependency.}}
```
These games have been packaged for your convenience:

-   Touhou 6: Embodiment of Scarlet Devil --- `{{AUR|th06-demo-wine}}`{=mediawiki} or
    `{{AUR|th06-demo-pytouhou}}`{=mediawiki}
-   Touhou 7: Perfect Cherry Blossom --- `{{AUR|th07}}`{=mediawiki}
-   Touhou 8: Imperishable Night --- `{{AUR|th08}}`{=mediawiki}

We need help [packaging](Wine_PKGBUILD_Guidelines "wikilink") more Touhou games for the [Arch User
Repository](Arch_User_Repository "wikilink"). This is a list of games that have free, downloadable trial editions to
build off of:

-   Touhou 7.5: Immaterial and Missing Power
-   Touhou 9: Phantasmagoria of Flower View
-   Touhou 10: Mountain of Faith
-   Touhou 10.5: Scarlet Weather Rhapsody
-   Touhou 11: Subterranean Animism
-   Touhou 12: Undefined Fantastic Object
-   Touhou 13: Ten Desires
-   Touhou 13.5: Hopeless Masquerade.
-   Touhou 14: Double Dealing Character
-   Touhou 14.5: Urban Legend in Limbo
-   Touhou 15: Legacy of Lunatic Kingdom
-   Touhou 15.5: Antinomy of Common Flowers
-   Touhou 16: Hidden Star in Four Seasons
-   Touhou 17: Wily Beast and Weakest Creature
-   Touhou 18: Unconnected Marketeers

### Python engine {#python_engine}

[Linkmauve](https://linkmauve.fr/doc/touhou/) has made an experimental
[Python](Wikipedia:Python_(programming_language) "wikilink") engine to make the games more portable. See the
`{{AUR|pytouhou-hg}}`{=mediawiki} and `{{AUR|th06-demo-data}}`{=mediawiki} packages.

```{=mediawiki}
{{Note|It is definitely not stable, and is more of an outline for an engine than an actual one, but it is interesting nonetheless.}}
```
## Extra information {#extra_information}

### Installing the full version {#installing_the_full_version}

If you have the full version of either Imperishable Night or Perfect Cherry Blossom, you can place them in your home
folder, or you can place them in the overlay so that they will work in the liveCD and also get installed to disk.

```{=mediawiki}
{{Tip|{{ic|.th08}} is Imperishable Night Wine prefix folder, and {{ic|.th07}} is Perfect Cherry Blossom one.}}
```
1.  Find the folder with the Touhou game files.
2.  Set your file manager to see hidden files/folders.

:   

    :   ```{=mediawiki}
        {{Tip|In Cherimoya Dolphin file manager, just press {{ic|Alt+.}}.}}
        ```

1.  Go to your \"Home\" folder and find the folders `{{ic|.th08}}`{=mediawiki} and/or `{{ic|.th07}}`{=mediawiki}.
2.  Paste your game files right over the shortcuts in either `{{ic|.th08}}`{=mediawiki} or `{{ic|.th07}}`{=mediawiki}
3.  Start your games normally. They will use the full version.

### MIDI Music {#midi_music}

If you are using the trial edition, they only include MIDI files. To play them, you will also need to install
`{{Pkg|timidity++}}`{=mediawiki} along with some soundfonts (`{{Pkg|freepats-general-midi}}`{=mediawiki}).

Now add the following lines to the Timidity++ configuration file:

```{=mediawiki}
{{hc|/etc/timidity++/timidity.cfg|
dir /usr/share/timidity/freepats
source /etc/timidity++/freepats/freepats.cfg
}}
```
Remember to [start](start "wikilink") the `{{ic|timidity.service}}`{=mediawiki} user unit before playing.

### Audio in Windows-era games {#audio_in_windows_era_games}

If you find that you have no audio in any of the Windows era or later games (Touhou 6 and later), make sure to install
`{{Pkg|lib32-alsa-lib}}`{=mediawiki} and `{{Pkg|lib32-alsa-plugins}}`{=mediawiki}, and recheck your configuration in
*winecfg*. In addition, set the audio in-game to \"WAV\" mode.

## Steam version {#steam_version}

You can find games available on Steam from
[this](https://store.steampowered.com/curator/42231740-Touhou-Official-Games-Info/list/93128) list.

### thcrap

The [Touhou Community Reliant Automatic Patcher](https://www.thpatch.net/) (thcrap) is mainly developed to facilitate
self-updating, multilingual translation of the [Touhou Project](wikipedia:Touhou_Project "wikilink") games on [Touhou
Patch Center](https://thpatch.net/), but can theoretically be used for just about any other patch for these games,
without going through that site.

The simplest way to launch Touhou games with thcrap is to use
[thcrap-steam-proton-wrapper](https://github.com/tactikauan/thcrap-steam-proton-wrapper) script.

-   Download your purchased game from Steam.

```{=html}
<!-- -->
```
-   [Install](Install "wikilink") `{{AUR|thcrap-steam-proton-wrapper-git}}`{=mediawiki}. For
    [Flatpak](Flatpak "wikilink") version of Steam install
    `{{ic|com.valvesoftware.Steam.Utility.thcrap_steam_proton_wrapper}}`{=mediawiki} from *Flathub* instead.
-   Change your Touhou game launch options. Right click your Touhou games in your Steam library, then click
    *Properties*. Under the *General* tab, change *LAUNCH OPTIONS* to

`thcrap_proton -c `*`en.js`*` -- %command%`

Checkout the [manual](https://github.com/tactikauan/thcrap-steam-proton-wrapper) to launch Touhou games with other
languages.

-   First time launching the game, it will ask you to install thcrap.
-   After that, it will update thcrap and launch the game. When thcrap window show up, it\'s recommended you uncheck the
    *Keep the updater running in background* in the setting, so Steam could properly shutdown the game when you quit.

### thprac

[thprac](https://github.com/touhouworldcup/thprac) is a tool for practicing. Add `{{ic|-p}}`{=mediawiki} option will
install and launch Touhou game with thprac.

`thcrap_proton -p -c en.js -- %command%`

### vpatch

```{=mediawiki}
{{Note|Vsync Patches (vpatch) only works for the executable file from original disk. You need an {{ic|.exe}} file from original disk, not the steam version. See [https://en.touhouwiki.net/wiki/Purchasing_Guide this] for purchasing guide.}}
```
Vsync patch reduces input delay (game responds more quickly when a button is pressed).

-   Download the patch from [touhouwiki](https://en.touhouwiki.net/wiki/Game_Tools_and_Modifications#Vsync_Patches).

```{=html}
<!-- -->
```
-   Copy `{{ic|vpatch.exe}}`{=mediawiki}, `{{ic|vpatch.ini}}`{=mediawiki} and `{{ic|vpatch_thxx.dll}}`{=mediawiki} to
    your game directory `{{ic|~/.local/share/Steam/steamapps/common/thxx/}}`{=mediawiki} (or
    `{{ic|~/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/thxx/}}`{=mediawiki} for Flatpak version of
    Steam).

```{=html}
<!-- -->
```
-   Open `{{ic|vpatch.ini}}`{=mediawiki} in the game directory with your favorite text editor. We are going to change
    windows size. For TH10 the default window is very small. First, set `{{ic|1=enabled = 1}}`{=mediawiki} under
    `{{ic|[Window]}}`{=mediawiki} section. If using 4K display, set *Width = 2667* and *Height = 2000*. If using 1080p
    display set *Width = 1280* and *Height = 960*. Based on
    [this](https://steamcommunity.com/sharedfiles/filedetails/?id=2196860604) tutorial. To fix the Th10 Marisa B 3.xx
    power bug, add `{{ic|1=BugFixTh10Power3 = 1}}`{=mediawiki} to `{{ic|[Option]}}`{=mediawiki} section.

```{=html}
<!-- -->
```
-   Make a backup of original Steam executable `{{ic|~/.local/share/Steam/steamapps/common/thxx/thxx.exe}}`{=mediawiki}.
    This is for convenience, you can always recover it using *verify local data* in Steam.

```{=html}
<!-- -->
```
-   Replace the `{{ic|~/.local/share/Steam/steamapps/common/thxx/thxx.exe}}`{=mediawiki} with the one you legally
    obtained from original disk.

```{=html}
<!-- -->
```
-   Change the Steam game launch option to

`thcrap_proton -v -c en.js -- %command%`

:   the `{{ic|-v}}`{=mediawiki} flag let Steam runs `{{ic|vpatch.exe}}`{=mediawiki}.

## See also {#see_also}

-   [Running Touhou Games in Linux](https://en.touhouwiki.net/wiki/Running_in_Linux_and_MacOS_X)
-   [Wine PKGBUILD Guidelines](Wine_PKGBUILD_Guidelines "wikilink")
-   [How to use thcrap (Touhou Community Reliant Automatic Patcher) on the Steam
    Deck](https://www.reddit.com/r/touhou/comments/yypp3q/how_to_use_thcrap_touhou_community_reliant/)
-   [\[WIN/LINUX\] English Patch with ThCRAP, Plus V-Sync Patch, All From Within
    Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=2196860604)

[Category:Gaming](Category:Gaming "wikilink")

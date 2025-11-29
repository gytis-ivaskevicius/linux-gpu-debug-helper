[cs:DOSBox](cs:DOSBox "wikilink") [es:DOSBox](es:DOSBox "wikilink") [ja:DOSBox](ja:DOSBox "wikilink")
[pl:Dosbox](pl:Dosbox "wikilink") [ru:DOSBox](ru:DOSBox "wikilink") [zh-hans:DOSBox](zh-hans:DOSBox "wikilink")
`{{Related articles start}}`{=mediawiki} `{{Related|Wine}}`{=mediawiki} `{{Related|Proton}}`{=mediawiki}
`{{Related|Video game platform emulators}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}
[DOSBox](https://www.dosbox.com/) is an x86 PC DOS-emulator for running old DOS games or programs.

## Installation

[Install](Install "wikilink") the `{{Pkg|dosbox}}`{=mediawiki} package. DOSBox has not seen a new release since 2019,
you may want to try the `{{AUR|dosbox-svn}}`{=mediawiki} development version. Alternatively, two forks can be installed:

-   ```{=mediawiki}
    {{AUR|dosbox-staging}}
    ```
    aims to modernize the codebase (and [some distributions](https://src.fedoraproject.org/rpms/dosbox) ship it as the
    default)

-   ```{=mediawiki}
    {{AUR|dosbox-x}}
    ```
    tries to emulate hardware much more accurately

## Configuration

No initial configuration is needed, however the official DOSBox manual refers to a configuration file named
`{{ic|dosbox.conf}}`{=mediawiki}. By default that file exists in your `{{ic|~/.dosbox}}`{=mediawiki} folder.

You can also make a new configuration file on a per-application basis by copying `{{ic|dosbox.conf}}`{=mediawiki} from
`{{ic|~/.dosbox}}`{=mediawiki} to the directory where your DOS app resides and modifying the settings accordingly. You
can also create a configuration file automatically: simply run `{{ic|dosbox}}`{=mediawiki} without any parameters inside
your desired application\'s folder:

`$ dosbox`

Then at the DOS prompt, type:

`Z:\> config -wc dosbox.conf`

The configuration file `{{ic|dosbox.conf}}`{=mediawiki} will then be saved in the current directory. Go in a change
whatever settings you need.

The configuration options are described in the official [DOSBox wiki](https://www.dosbox.com/wiki/Dosbox.conf).

## Usage

A simple way to run DOSBox is to place your DOS game (or its setup files) into a directory and then run
`{{ic|dosbox}}`{=mediawiki} with the directory path appended. For example:

`$ dosbox ./game-folder/`

You should now have a DOS prompt whose working directory is the one specified above. From there, you can execute the
desired programs:

`C:\> SETUP.EXE`

## Tips and tricks {#tips_and_tricks}

### Free DOSBox focus {#free_dosbox_focus}

If DOSBox traps your focus, use `{{ic|Ctrl+F10}}`{=mediawiki} to free it.

### Play music in DOS games {#play_music_in_dos_games}

To play music, some DOS games require a [MIDI](MIDI "wikilink") synthesizer which DOSBox does not emulate. However,
DOSBox can use one if it is available. A software synthesizer such as [FluidSynth](FluidSynth "wikilink") or
[Timidity](Timidity "wikilink") can be used if your computer does not have a hardware synthesizer.

## See also {#see_also}

-   [The official DOSBox website](https://www.dosbox.com)
-   [DOSGames.com](https://www.dosgames.com) - large repository of DOS games.
-   [Abandonia](http://www.abandonia.com) - large repository of old and abandoned DOS games.

[Category:Emulation](Category:Emulation "wikilink") [Category:Gaming](Category:Gaming "wikilink")

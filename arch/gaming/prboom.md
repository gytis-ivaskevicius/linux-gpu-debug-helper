[ja:PrBoom](ja:PrBoom "wikilink") [PrBoom](https://prboom.sourceforge.net/) is a cross-platform version of the classic
3D first person shooter [Doom](wikipedia:Doom_(video_game) "wikilink") from id Software. Originally written for
Microsoft Windows, PrBoom has since been ported to Linux and many other platforms. It offers a number of enhancements
over the original game, including OpenGL rendering and high video resolutions, while attempting to remain true to the
original Doom in terms of play. You will need the original Doom data, unless you install the FreeDoom package (see
below).

## Installation

Install the `{{AUR|prboom}}`{=mediawiki} package.

## Usage

To use prboom, the original data files are required. An [IWAD](https://zdoom.org/wiki/IWAD) - short for Internal WAD -
is the main resource file for a Doom-engine game, containing all the game\'s original sounds, levels, and graphics. With
an IWad file with default settings (unless you already have `{{ic|~/.prboom/prboom.cfg}}`{=mediawiki} edited):

`# prboom -iwad /path/to/file`

To change window resolution (you must disable fullscreen in options in-game):

`# prboom -width 800 -height 600 -iwad /path/to/file`

A full list of settings can be found in `{{man|6|prboom|url=https://www.mankier.com/6/prboom}}`{=mediawiki}.

## Server

To start a server:

`# prboom-game-server`

By default it listens on port `{{ic|5030}}`{=mediawiki}, so to join the game:

`# prboom -net localhost:5030 -iwad /path/to/file`

## Music

If music is not working, then follow these steps. Install `{{Pkg|timidity++}}`{=mediawiki} and
`{{Pkg|freepats-general-midi}}`{=mediawiki}, then add:

```{=mediawiki}
{{hc|/etc/timidity++/timidity.cfg|
dir /usr/share/timidity/freepats
source /etc/timidity++/freepats/freepats.cfg
}}
```
Please note that freepats is an incomplete soundfont; therefore it will not play every instrument used by Doom and Doom
2. You should consider installing an alternative [SoundFont](MIDI#List_of_SoundFonts "wikilink").

## See also {#see_also}

[Wikipedia:PrBoom](Wikipedia:PrBoom "wikilink")

[Category:Gaming](Category:Gaming "wikilink")

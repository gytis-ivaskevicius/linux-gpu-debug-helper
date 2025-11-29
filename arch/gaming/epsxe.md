```{=mediawiki}
{{Lowercase title}}
```
[es:EPSXe](es:EPSXe "es:EPSXe"){.wikilink} [ja:EPSXe
プレイステーションエミュレータ](ja:EPSXe_プレイステーションエミュレータ "ja:EPSXe プレイステーションエミュレータ"){.wikilink}
[ePSXe](Wikipedia:ePSXe "ePSXe"){.wikilink} (enhanced PSX emulator) is a PlayStation emulator for x86-based PC hardware
with Microsoft Windows or Linux, as well as devices running Android. It was written by three authors, using the aliases
*Calb*, *\_Demo\_* and *Galtor*. ePSXe is closed source with the exception of the application programming interface
(API) for its plug-ins.

## Installation

```{=mediawiki}
{{Warning|The installation and use of this emulator requires a Sony PlayStation BIOS file. In most jurisdictions, you may not use such a file to play games in a PSX emulator if you do not own a Sony PlayStation, Sony PSOne or Sony PlayStation 2 console as it is a violation of copyright law.}}
```
[Install](Install "Install"){.wikilink} `{{AUR|epsxe}}`{=mediawiki}, along with any
[plugins](https://aur.archlinux.org/packages?K=epsxe-plugin). Also, you should have a legally obtained BIOS file handy
and place them in `{{ic|~/.epsxe/bios}}`{=mediawiki}.

Add yourself to the `{{ic|games}}`{=mediawiki} [user group](user_group "user group"){.wikilink}. If the group does not
exist, [create it](Users_and_groups#Group_management "create it"){.wikilink} first.

## Configuration

Configure video and sound by going to *Config \> Video* and *Config \> Sound* respectively, and configuring the plugins
you want. Verify that they are working by clicking the Test buttons in each of the windows.

The CD-ROM path should be set by default. You can check it by going to *Config \> Cdrom*.

Set up the controls for player one by going to *Config \> Game Pad \> Port 1 \> Pad 1*.

## Playing

Run a game from your CD-ROM by clicking *File \> Run CDROM*.

Load up a game from an ISO by clicking *File \> Run ISO*.

You can manipulate game states by going to *Run \> Save State (F1)* and *Run \> Load State (F3)*, or using the hotkeys
`{{ic|F1}}`{=mediawiki} and `{{ic|F3}}`{=mediawiki}.

## Troubleshooting

### Sound device not found {#sound_device_not_found}

If the sound plugin does not work and you are using [ALSA](ALSA "ALSA"){.wikilink}, see [Advanced Linux Sound
Architecture#OSS
emulation](Advanced_Linux_Sound_Architecture#OSS_emulation "Advanced Linux Sound Architecture#OSS emulation"){.wikilink}.

## See also {#see_also}

- ePSXe - <https://www.epsxe.com/>
- Pete\'s PSX plugins - <http://www.pbernert.com/index.htm>

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}
[Category:Emulation](Category:Emulation "Category:Emulation"){.wikilink}

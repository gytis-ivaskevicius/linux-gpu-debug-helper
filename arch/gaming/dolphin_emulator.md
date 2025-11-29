[zh-hans:Dolphin 模拟器](zh-hans:Dolphin_模拟器 "zh-hans:Dolphin 模拟器"){.wikilink} [ja:Dolphin
エミュレータ](ja:Dolphin_エミュレータ "ja:Dolphin エミュレータ"){.wikilink} [Dolphin](https://dolphin-emu.org/) is a
Nintendo GameCube and Wii emulator, currently supporting the x86_64 and AArch64 architectures. Dolphin is available for
Linux, macOS, Windows, and Android. It is a free and open source, community-developed project. Dolphin was the first
GameCube and Wii emulator, and currently the only one capable of playing commercial games.

## Installation

[Install](Install "Install"){.wikilink} the `{{Pkg|dolphin-emu}}`{=mediawiki} package.

## Playing

```{=mediawiki}
{{Note|Dolphin is a resource-heavy application, so expect not all games to run properly. See the reason [https://dolphin-emu.org/docs/faq/#why-do-i-need-such-powerful-computer-emulate-old-c here].}}
```
```{=mediawiki}
{{Warning|Make sure you '''only''' use Dolphin for legally obtained self-made disc dumps of games you legally bought. Dolphin was not developed for unlawful use. Act legally as applying laws define. You are responsible for any usage of the emulator that you make. No links, instructions or tips for obtaining illegal content will be provided on this wiki. No copyright infringement intended.}}
```
Click on browse to set a directory of ISOs so that they are shown as a library on Dolphin\'s default screen. Otherwise
just click *Open* and select the file.

Also check the official [configuration guide](https://wiki.dolphin-emu.org/index.php?title=Configuration_Guide) and
[performance guide](https://dolphin-emu.org/docs/guides/performance-guide/).

### Dolphin\'s Wiki {#dolphins_wiki}

Whenever a game does not work properly, try reading its page on [Dolphin\'s wiki](https://wiki.dolphin-emu.org). Listed
there are tips on setting up the emulator for each game, version compatibility charts, testing entries, troubleshooting
and video previews. Contributions, such as testing entries and workarounds are welcome and help other users.

Here is a `{{Pkg|xfce4-whiskermenu-plugin}}`{=mediawiki} search action command for searching on Dolphin\'s wiki:

`exo-open --launch WebBrowser `[`https://wiki.dolphin-emu.org/index.php?search=%u`](https://wiki.dolphin-emu.org/index.php?search=%u)

### Use gamepad motion controls {#use_gamepad_motion_controls}

Dolphin can use the motion sensors included with gamepads, such as the DualShock 4 or Switch Pro Controller, to emulate
the motion in Wii Remotes.

The easiest way to set this up is to choose the SDL controller instead of the evdev controller in the controller
configuration. Motion Inputs should already be set up by the *Default* mapping.

If moving the gamepad doesn\'t produce a reaction, SDL might not have permission to read the motion sensors: see
[Gamepad#Device permissions](Gamepad#Device_permissions "Gamepad#Device permissions"){.wikilink}.

If you cannot use SDL for some reason and need motion controls with evdev, see [this
guide](https://wiki.dolphin-emu.org/index.php?title=Motion%20evdev).

## Themes

To change the theme of Dolphin, place a css file in `{{ic|~/.local/share/dolphin-emu/Styles}}`{=mediawiki} directory.
Then go to the *interface* tab in the *options* and check the *Use Custom User Style* box. Click on the *User Style* tab
to change the theme.

## Troubleshooting

### Input is not detected after emulation window loses focus once {#input_is_not_detected_after_emulation_window_loses_focus_once}

Enable *Render to Main Window* under Graphics Settings, or enable *Background Input* under Controller Settings.
[1](https://bugs.dolphin-emu.org/issues/13354)

## See also {#see_also}

- [Wikipedia:Dolphin (emulator)](Wikipedia:Dolphin_(emulator) "Wikipedia:Dolphin (emulator)"){.wikilink}
- [Dolphin\'s performance guide.](https://dolphin-emu.org/docs/guides/performance-guide/)
- [Dolphin\'s FAQ](https://dolphin-emu.org/docs/faq/)
- [Dolphin\'s wiki entry for legally obtaining game
  dumps.](https://wiki.dolphin-emu.org/index.php?title=Ripping_Game_Discs)

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}
[Category:Emulation](Category:Emulation "Category:Emulation"){.wikilink}

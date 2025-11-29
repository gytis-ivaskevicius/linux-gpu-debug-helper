[ja:RuneScape](ja:RuneScape "ja:RuneScape"){.wikilink} From [Wikipedia](Wikipedia:RuneScape "Wikipedia"){.wikilink}:

:   RuneScape is a fantasy massively multiplayer online role-playing game (MMORPG) developed and published by Jagex,
    released in January 2001. RuneScape was originally a browser game built with the Java programming language; it was
    largely replaced by a standalone C++ client in 2016. The game has had over 300 million accounts created and was
    recognised by the Guinness World Records as the largest and most-updated free MMORPG.

From [Wikipedia](Wikipedia:Jagex#Old_School_RuneScape "Wikipedia"){.wikilink}:

:   Old School RuneScape is a separate incarnation of RuneScape released on 22 February 2013, based on a copy of the
    game from August 2007. Old School RuneScape receives regular content updates, which must be voted on by its players
    before they can be added to the game.

## Installation

The installation alternatives offer different features to make a choice on, and may use different dependencies.

```{=mediawiki}
{{Note|Independent of the chosen client, it may be necessary to separately open an account with the game publisher [[wikipedia:Jagex|Jagex]] in order to access the multi-player game. An exception is [[#Steam]].}}
```
### Jagex Launcher {#jagex_launcher}

The Jagex Launcher offers installation and shortcuts to each game client
[Executable](Wikipedia:Executable "Executable"){.wikilink} and does not Linux support on release.

#### Unofficial client {#unofficial_client}

[jagex-launcher-linux](https://github.com/TormStorm/jagex-launcher-linux) is a repository that \"contains community
projects to install the Jagex Launcher and use Jagex Accounts in Linux\" as recommended by [Jagex
Support](https://help.jagex.com/hc/en-gb/articles/13413514881937-Downloading-the-Jagex-Launcher-on-Linux).

[Bolt](https://github.com/adamcake/Bolt) is a third-party launcher. [Install](Install "Install"){.wikilink} with the
`{{AUR|bolt-launcher}}`{=mediawiki} package or with [Flatpak](Flatpak "Flatpak"){.wikilink} as
`{{ic|com.adamcake.Bolt}}`{=mediawiki} from [Flathub](https://flathub.org/).

### RuneScape

#### Official client {#official_client}

Install the official RuneScape NXT client with the `{{AUR|runescape-launcher}}`{=mediawiki} package. The official client
can also be installed with [Flatpak](Flatpak "Flatpak"){.wikilink} as `{{ic|com.jagex.RuneScape}}`{=mediawiki} from
[Flathub](https://flathub.org/).

### Old School RuneScape (OSRS) {#old_school_runescape_osrs}

#### RuneLite

[RuneLite](https://runelite.net/) is an open-source alternative to other third-party Old School RuneScape clients. It is
available on the AUR: `{{AUR|runelite}}`{=mediawiki}.

To enable the GPU feature within RuneLite, ensure you meet the
[requirements](https://github.com/runelite/runelite/wiki/GPU-FAQ) and have updated to the latest version of
`{{Pkg|mesa}}`{=mediawiki}.

#### OSRS-Launcher {#osrs_launcher}

**osrs-launcher** is a repackaging of the mac version of the official Old School RuneScape launcher. It is available for
installation from the AUR, `{{AUR|osrs-launcher}}`{=mediawiki}.

### Steam

It is worth mentioning that RuneScape and OSRS are individually available on [Steam](Steam "Steam"){.wikilink}, which
offers its own [Compatibility layer](Wikipedia:Compatibility_layer "Compatibility layer"){.wikilink}
[Proton](Wikipedia:Proton_(software) "Proton"){.wikilink}. Steam is a separate program, and **not recommended** if
unfamiliar. The Steam releases predate the official [#Jagex Launcher](#Jagex_Launcher "#Jagex Launcher"){.wikilink}
release by around three years, and lack support for Jagex Account features such as multiple characters.

## Troubleshooting

### Audio issues {#audio_issues}

The Java client (jagexappletviewer.jar) requires `{{Pkg|pulseaudio-alsa}}`{=mediawiki} to be installed for sound to work
properly. Otherwise there will be no in-game sound or other applications will not be able to play audio due to the
client claiming direct access to `{{ic|/dev/snd/*}}`{=mediawiki} devices. For more details, see
[PulseAudio#ALSA](PulseAudio#ALSA "PulseAudio#ALSA"){.wikilink}.

### SSL errors {#ssl_errors}

If you receive an error like this (with RuneLite or otherwise):

`javax.net.ssl.SSLHandshakeException: Received fatal alert: handshake_failure`

This error may be due to Java\'s new TLSv1.3 implementation. Try adding
`{{ic|1=-Djdk.tls.client.protocols=TLSv1.2}}`{=mediawiki} to your client\'s launch options. For example:

`$ java -Djdk.tls.client.protocols=TLSv1.2 -jar RuneLite.jar`

## See also {#see_also}

- [The RuneScape Wiki](https://runescape.wiki/w/Linux)
- [Jagex Support](https://support.runescape.com/hc/en-gb/articles/206659489-Linux-native-clients)

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

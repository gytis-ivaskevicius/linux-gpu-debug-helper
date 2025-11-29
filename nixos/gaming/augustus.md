Augustus is an engine to run the 1998 game Caesar III with modern improvements (higher resolution, ..). Caesar III is a
city builder with complex manufacturing and optional military path.

You need the orginal Caesar III game files to run Augustus.

Augustus is a fork of Julius. This article also applies for „Julius", for Julius just install the „julius" instead of
the „augustus" package.

The three versions of the game:

-   Caesar III/ Caesar 3: 1998 version of the game
-   Julius: Modern engine to run the game. The game itself is true to Caesar III.
-   Augustus: Based on Julius but with more changes in gameplay compared to Julius.

## Install game {#install_game}

-   Install the game: You can e.g. install the GOG version of Caesar III via Lutris:
    <https://lutris.net/games/caesar-iii/>
-   Install the augustus engine: just add the package to your NixOS configuration and rebuild:

environment.systemPackages = with pkgs; \[ augustus \];

```{=html}
</syntaxhighlight>
```
## Install modifications {#install_modifications}

### Better music files {#better_music_files}

see: <https://github.com/bvschaik/julius-support/releases/tag/music>

### Better videos {#better_videos}

see: <https://www.moddb.com/mods/caesar-3-restored-cinematics-v10/downloads/caesar-3-restored-cinematics-v101>

## Troubleshooting: It is impossible set the game path {#troubleshooting_it_is_impossible_set_the_game_path}

Due to your settings of your desktop environment and shell settings it may not be possible to choose the path of the
installed Caesar III game. You can always use the terminal to start „augustus" in the path where the c3.exe is.

## References

-   Augustus Engine: <https://github.com/Keriew/augustus>
-   Julius Engine: <https://github.com/bvschaik/julius>

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

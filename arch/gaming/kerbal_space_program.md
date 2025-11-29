[ja:Kerbal Space Program](ja:Kerbal_Space_Program "wikilink") As described on its website, [Kerbal Space
Program](https://www.kerbalspaceprogram.com/) is a game where you:

:   take charge of the space program for the alien race known as the Kerbals. You have access to an array of parts to
    assemble fully-functional spacecraft that fly (or don't) based on realistic aerodynamic and orbital physics. Launch
    your Kerbal crew into orbit and beyond (while keeping them alive) to explore moons and planets in the Kerbol solar
    system, constructing bases and space stations to expand the reach of your expedition.

Since version 0.19, Kerbal Space Program includes a native Linux version. However, only Ubuntu is officially supported,
so it may not work on Arch Linux out of the box.

## Installation

Install Kerbal Space Program in the [Steam](Steam "wikilink") client if you bought that version of the game.

For non Steam users, the Kerbal Space Program website currently offers a pre-built Linux version as a *.zip* file.
Download and extract that file to your chosen install location, execute the game using:

`$ ./KSP.x86_64`

## Mod Support {#mod_support}

For ease of installation and mod management, currently most modifications are available using `{{AUR|ckan}}`{=mediawiki}
which will automatically resolve dependencies and install / remove mods.

It is worth noting that not all mods are available for all release versions, if you have your heart set on using a
particular mod it may be worth researching and installing an older KSP version first.

## Known issues {#known_issues}

### Game won\'t load after Private Division launcher appears {#game_wont_load_after_private_division_launcher_appears}

In the Steam game properties \"Compatibility panel\", make sure that \"Force the use of a specific Steam Play
compatibility Tool\" is unchecked.

### Game never progresses past initial loading {#game_never_progresses_past_initial_loading}

To fix this, set:

`LC_ALL=C`

This is also relevant if your rocket\'s parts do not connect.

### Game segfaults before launching, v1.1+ {#game_segfaults_before_launching_v1.1}

The Unity 5 engine expects you to be running [PulseAudio](PulseAudio "wikilink"). You can install
`{{AUR|pulsenomore}}`{=mediawiki} or download it from [the KSP bug
tracker](https://bugs.kerbalspaceprogram.com/issues/7515#note-28) as a workaround until this is fixed by the Unity
developers.

### No text display {#no_text_display}

The game requires Arial and Arial Black fonts [installed](install "wikilink"), provided in the
`{{AUR|ttf-ms-fonts}}`{=mediawiki} package.

Another alternative is to try to use `{{Pkg|gnu-free-fonts}}`{=mediawiki}.

### In-game menus are blank, v1.1+ {#in_game_menus_are_blank_v1.1}

Some resolutions cause menus to appear empty. Try using your `{{ic|settings.cfg}}`{=mediawiki} file to enable fullscreen
and/or change your resolution by a few pixels, e.g. `{{ic|1366x768}}`{=mediawiki} to `{{ic|1363x768}}`{=mediawiki}.

Imperfect resolutions can cause poor font rendering. If this happens you can use the AnyRes mod to change your
resolution in-game to find a good one, rather than launching the game for every change.

Another solution that may work on some architectures is to add `{{ic|-force-glcore}}`{=mediawiki} as a launch option, or
to pass it in as a command line flag. For Steam: go to Library, right click on KSP, Properties, Set up launch options,
and add `{{ic|-force-glcore}}`{=mediawiki}. The game engine will try to run the game with the best OpenGL version
possible and all available OpenGL extensions. With this option enabled you may encounter shadow glitches, try few
different settings in-game in the setting panel to resolve the problem.

### Graphics flickering when using primusrun {#graphics_flickering_when_using_primusrun}

Run with `{{ic|1=PRIMUS_SYNC=2}}`{=mediawiki}, but you will get reduced frame rate this way. Alternatively run KSP using
*optirun*.

### Game crashes when accessing settings or saves on 64 bit systems on Steam {#game_crashes_when_accessing_settings_or_saves_on_64_bit_systems_on_steam}

In the properties for Kerbal Space program, set the launch options as:

`LC_ALL=C %command%_64`

The `{{ic|_64}}`{=mediawiki} part makes sure that Steam launches the 64-bit version of the game and not the 32-bit one.

### Game has garbled graphics when running on x86_64 with all lib32 drivers installed {#game_has_garbled_graphics_when_running_on_x86_64_with_all_lib32_drivers_installed}

Steam launches the `{{ic|KSP.x86}}`{=mediawiki} executable instead of the `{{ic|KSP.x86_64}}`{=mediawiki} executable.
Navigate to

`"/home/$USER/.local/share/Steam/SteamApps/common/Kerbal Space Program/"`

Launch with

`$ ./KSP.x86_64`

Alternatively, to launch it from steam, set the following launch option:

`%command%_64`

### No audio on 64-bit systems {#no_audio_on_64_bit_systems}

Run the 64-bit executable: see [#Game has garbled graphics when running on x86_64 with all lib32 drivers
installed](#Game_has_garbled_graphics_when_running_on_x86_64_with_all_lib32_drivers_installed "wikilink").

Alternatively, right click on Kerbal Space Program on your game list, click on Properties, click on SET LAUNCH OPTIONS,
then add:

`LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH" LC_ALL=C %command%_64`

### Black in-game textures {#black_in_game_textures}

Disable \"Edge Highlighting (PPFX)\" in the graphics settings in-game.

### Joystick inputs are not recognized, v1.4+ {#joystick_inputs_are_not_recognized_v1.4}

This is a [bug in KSP](https://bugs.kerbalspaceprogram.com/issues/17984). As it has existed for a while now and depends
on an upstream bug in the Unity engine it is unlikely to be fixed soon. Currently your only options are reverting to an
older version of KSP (1.3 or lower) that used an older version of Unity, to emulate an XBox Controller, or to use a
third party mod like
[AFBW](https://forum.kerbalspaceprogram.com/index.php?/topic/175359-15-afbw-revived-joystick-controller-mod/). With some
configuration the latter one comes pretty close to the vanilla behavior and even grants some additional features.

### Alt key not working {#alt_key_not_working}

In the Linux version, the modifier key is mapped to `{{ic|RShift}}`{=mediawiki} since some window managers use
`{{ic|Alt+Click}}`{=mediawiki} for moving windows.

See [Key bindings (KSP Wiki)](https://wiki.kerbalspaceprogram.com/wiki/Key_bindings#Modifier_key).

### Game does not start on wayland {#game_does_not_start_on_wayland}

If the game does not launch on wayland, make sure Xwayland is installed and launch with:

`SDL_VIDEODRIVER=x11 ./start.sh `

or

`SDL_VIDEODRIVER=x11 ./KSP.x86_64 `

This may work for other Unity3D games as well.

## See also {#see_also}

-   <https://wiki.kerbalspaceprogram.com/wiki/Linux>!
-   <https://forum.kerbalspaceprogram.com/index.php?/topic/22561-the-linux-compatibility-thread/>!

[Category:Gaming](Category:Gaming "wikilink")

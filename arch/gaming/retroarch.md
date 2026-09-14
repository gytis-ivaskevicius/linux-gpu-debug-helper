[es:RetroArch](es:RetroArch "wikilink") [ja:RetroArch](ja:RetroArch "wikilink") [ru:RetroArch](ru:RetroArch "wikilink")

[RetroArch](https://www.retroarch.com/) is the reference implementation of the libretro API. It is a modular front-end
for video game system emulators, game engines, video games, media players and other applications that offers several
uncommon technical features such as multi-pass shader support, real-time rewinding and video recording (using
[FFmpeg](FFmpeg "wikilink")), it also features a gamepad-driven UI on top of a full-featured command-line interface.

## Installation

[Install](Install "wikilink") the `{{Pkg|retroarch}}`{=mediawiki} package.

```{=mediawiki}
{{Tip|
* Install {{Pkg|retroarch-assets-xmb}} to get the fonts and icons for the RetroArch GUI. You may also want to install {{Pkg|retroarch-assets-ozone}} for a more desktop-friendly GUI.
* Install {{AUR|retroarch-standalone-service}} to get system user, system service and RetroArch configuration for standalone game-box. Then start and/or enable {{ic|retroarch-standalone.service}}.
* Install {{AUR|retroarch-steam-launcher}} to map the retroarch in your PATH to the Steam installation of retroarch. This can be useful for using Steam features, such as cloud saves, with applications like {{AUR|emulationstation-de}} which use retroarch from the PATH.
}}
```
## Usage

RetroArch relies on separate libraries, called \"cores\", for most of its functionality. You can
[install](install "wikilink") the most popular cores by installing the `{{Grp|libretro}}`{=mediawiki} group. Additional
cores can be found on the [AUR](https://aur.archlinux.org/packages/?O=0&K=libretro-). Alternatively you can download the
cores on a per-user basis within RetroArch itself (via the [libretro Buildbot](https://buildbot.libretro.com/)).

```{=mediawiki}
{{Note|By default RetroArch is configured to load the cores installed by [[pacman]]. Edit your [[#Configuration]] if you want to use the per-user Online Updater instead.}}
```
To boot directly into a game you can use the command

`$ retroarch -L `*`/path/to/some_core_libretro.so`*` `*`/path/to/rom`*

## Configuration

When you first run RetroArch it will create the user configuration file
`{{ic|~/.config/retroarch/retroarch.cfg}}`{=mediawiki}.

If you prefer to install cores with the built-in Online Updater instead of pacman, you need to enable it and update the
path in your configuration file. `{{hc|
~/.config/retroarch/retroarch.cfg|
2=libretro_directory = "~/.config/retroarch/cores"
menu_show_core_updater = "true"
}}`{=mediawiki}

```{=mediawiki}
{{Note| Install {{Pkg|libretro-core-info}} to ensure the core downloader works correctly.  Without this package it will not fetch the core list to choose from.
Alternatively, you can edit your config file to use the core info from the Online Updater.
{{hc|~/.config/retroarch/retroarch.cfg|2=
libretro_info_path = "~/.config/retroarch/cores/info"}}
}}
```
```{=mediawiki}
{{Note|RetroArch does not support multiple search paths for these components. For example, if you install cores with [[pacman]] '''and''' download cores using RetroArch's GUI, you cannot configure RetroArch to show all of them at once since they are installed in different directories. It is recommended to choose one method of installing cores and not mix both.}}
```
If you want to override your configuration (for example when running certain cores) you can use the
`{{ic|--appendconfig ''/path/to/config''}}`{=mediawiki} command line option.

## Tips and tricks {#tips_and_tricks}

### Filters and shaders {#filters_and_shaders}

RetroArch can load [CG shaders](https://github.com/libretro/common-shaders), which are considered old and deprecated, as
well as [GLSL and Slang](https://retroarch.com/?page=shaders)
shaders.[1](https://emulation.gametechwiki.com/index.php/Shaders_and_filters) The shaders can be obtained and updated
directly inside RetroArch using the Online Updater.

```{=mediawiki}
{{Note|{{AUR|retroarch-git}} requires {{pkg|nvidia-cg-toolkit}} in order to use the ''CG shaders''.}}
```
### Reset settings to their default value {#reset_settings_to_their_default_value}

To reset a setting or keybind to its default value through the GUI, highlight it and press `{{ic|Start}}`{=mediawiki}.
To remove a button from a keybind, highlight the keybind and press `{{ic|Y}}`{=mediawiki}.

## Troubleshooting

### No cores found {#no_cores_found}

```{=mediawiki}
{{Remove|This was only an issue because this wiki page was providing out of date information. This issue can't happen if you follow the updated wiki instructions.}}
```
By default RetroArch searches for cores in `{{ic|~/.config/retroarch/cores}}`{=mediawiki}, which is where the Online
Updater installs them. Cores installed with [pacman](pacman "wikilink") are placed in
`{{ic|/usr/lib/libretro}}`{=mediawiki} and thus will not appear in RetroArch\'s GUI. You should choose one method of
installing cores (pacman or the Online Updater) and change [your configuration](#Configuration "wikilink") to match.

If you still face a \"No Cores Available\" message, you likely need to install the core info files. To solve this:

1.  Navigate to *Settings \> Directory*, and ensure all configured paths are writable without requiring superuser
    permissions.
2.  Go to *Settings \> User Interface \> Menu Item Visibility*, and make sure that *Show \'Core Downloader*\' is
    enabled.
3.  Finally, access *Main Menu \> Online Updater* and proceed to update the core info files. It is also recommended to
    update all other available components.

Upon restarting RetroArch, you should be able to run ROMs using any of the installed cores.

### Input devices do not operate {#input_devices_do_not_operate}

```{=mediawiki}
{{Accuracy|We might want to update this section to point to [[Udev#Allowing regular users to use devices]]?}}
```
You may encounter problems if running on a CLI or a display server other than [Xorg](Xorg "wikilink") or if you use the
[udev](udev "wikilink") input driver, because `{{ic|/dev/input}}`{=mediawiki} nodes are limited to root-only access. Try
adding your user to the `{{ic|input}}`{=mediawiki} [user group](user_group "wikilink") then logging in again.

Alternatively, manually add a rule in `{{ic|/etc/udev/rules.d/99-evdev.rules}}`{=mediawiki}, with
`{{ic|1=KERNEL=="event*", NAME="input/%k", MODE="666"}}`{=mediawiki} as its contents and [reload udev
rules](udev#Loading_new_rules "wikilink").

If rebooting the system or re-plugging the devices are not options, permissions may be forced using:

`# chmod 666 /dev/input/event*`

### Poor video performance {#poor_video_performance}

If poor video performance is met, RetroArch may be run on a separate thread by setting
`{{ic|1=video_threaded = true}}`{=mediawiki} in `{{ic|~/.config/retroarch/retroarch.cfg}}`{=mediawiki}.

This is, however, a solution that should be not be used if tweaking RetroArch\'s video resolution/refresh rate fixes the
problem, as it makes perfect V-Sync impossible, and slightly increases latency.

### Audio issues with ALSA {#audio_issues_with_alsa}

When using [ALSA](ALSA "wikilink") the `{{ic|audio_out_rate}}`{=mediawiki} must match the system\'s default output rate,
usually `{{ic|48000}}`{=mediawiki}.

### Start game from playlist but reports \'No Items\' {#start_game_from_playlist_but_reports_no_items}

```{=mediawiki}
{{Remove|This seems to not be relevant anymore. I'm only finding very few people mentioning this error and all of them are from 7-8 year ago. I'm also not finding this error inside the RetroArch source code.}}
```
If RetroArch reports `{{ic|libretro core requires contents, but nothing provided}}`{=mediawiki}, try to load game by
manually choosing the path of the ROM from *Main Menu \> Load Content*. It seems unreliable to start game from
*playlist*.

### BIOS files are missing or not accepted {#bios_files_are_missing_or_not_accepted}

RetroArch\'s cores are looking for BIOS files at the location set with the `{{ic|system_directory}}`{=mediawiki} option
in `{{ic|retroarch.cfg}}`{=mediawiki}.

The GUI menu *Settings \> Directory \> System/BIOS* shows the directory as well.

Some of the cores require the files directly in this directory. Other cores need a subdirectory within this directory
with a specific name for their specific BIOS files. Some cores even look for their files in the same directory as the
ROM file they try to run.

Every installed core provides information on needed files, their MD5 sums and the directory they need to be placed in.
You can find this information in the GUI menu under *Settings \> Core \> Manage Core*. Choose a core here to get
information on the needed BIOS files for this specific core. RetroArch describes them as \"firmware\" files on the core
info pages.

Further in depth info on BIOS files for many of the supported cores can be found in the official documentation.
[2](https://docs.libretro.com/library/bios/)

## See also {#see_also}

-   [Official Website](https://www.retroarch.com/)
-   [RetroArch wiki](https://docs.libretro.com/)
-   [Documentation for developers](https://docs.libretro.com/development/libretro-overview/)

[Category:Gaming](Category:Gaming "wikilink") [Category:Emulation](Category:Emulation "wikilink")

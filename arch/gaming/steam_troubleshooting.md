[ja:Steam/トラブルシューティング](ja:Steam/トラブルシューティング "wikilink") [ru:Steam
(Русский)/Troubleshooting](ru:Steam_(Русский)/Troubleshooting "wikilink")
[zh-hans:Steam/疑难解答](zh-hans:Steam/疑难解答 "wikilink")

1.  Make sure that you have followed [Steam#Installation](Steam#Installation "wikilink").
2.  If the Steam client / a game is not starting and/or you have error message about a library, read [#Steam
    runtime](#Steam_runtime "wikilink") and see [#Debugging shared libraries](#Debugging_shared_libraries "wikilink").
3.  If the issue is related to networking, make sure that you have forwarded the [required ports for
    Steam](https://help.steampowered.com/en/faqs/view/2EA8-4D75-DA21-31EB).
4.  If the issue is about a game, consult [Steam/Game-specific
    troubleshooting](Steam/Game-specific_troubleshooting "wikilink").

## Steam runtime {#steam_runtime}

Steam for Linux ships with its own set of libraries called the [Steam
runtime](https://github.com/ValveSoftware/steam-runtime). By default Steam launches all Steam Applications within the
runtime environment. The Steam runtime is located at `{{ic|~/.steam/root/ubuntu12_32/steam-runtime/}}`{=mediawiki}.

If you mix the Steam runtime libraries with system libraries you will run into binary incompatibility issues, see
[steam-for-linux issue #4768](https://github.com/ValveSoftware/steam-for-linux/issues/4768). Binary incompatibility can
lead to the Steam client and games not starting (manifesting as a crash, as hanging or silently returning), audio issues
and various other problems.

The `{{Pkg|steam}}`{=mediawiki} package offers two ways to launch Steam:

-   ```{=mediawiki}
    {{ic|/usr/bin/steam}}
    ```
    (alias `{{ic|steam}}`{=mediawiki}), which overrides runtime libraries known to cause problems via the
    `{{ic|LD_PRELOAD}}`{=mediawiki} [environment variable](environment_variable "wikilink") (see
    `{{man|8|ld.so}}`{=mediawiki}).

-   ```{=mediawiki}
    {{ic|/usr/lib/steam/steam}}
    ```
    , the default Steam launch script

As the Steam runtime libraries are older they can lack newer features, e.g. the OpenAL version of the Steam runtime
lacks [HRTF](Gaming#Binaural_audio_with_OpenAL "wikilink") and surround71 support.

### Steam native runtime {#steam_native_runtime}

```{=mediawiki}
{{Warning|Using the Steam native runtime is not recommended as it might break some games due to binary incompatibility and it might miss some libraries present in the Steam runtime.}}
```
The `{{AUR|steam-native-runtime}}`{=mediawiki} package depends on over 130 packages to pose a native replacement of the
Steam runtime, some games may however still require additional packages.

This package provides the `{{ic|steam-native}}`{=mediawiki} script, which launches Steam with the
`{{ic|1=STEAM_RUNTIME=0}}`{=mediawiki} environment variable making it ignore its runtime and only use system libraries.

```{=mediawiki}
{{Note|{{ic|1=STEAM_RUNTIME=0}} only disables runtime for Steam itself, games are still forced to use the Scout runtime. To run games with system libraries you also have to use cli argument {{ic|1=-compat-force-slr off}} when launching Steam. Note that this will only apply to games that use the Scout runtime, if developers choose to use the Sniper runtime, take for example Barony, the only way to escape that will be to either launch the game not from Steam or modify the launch arguments to something like {{ic|1=./<game_executable> &vert;&vert; exit &vert;&vert; %command%}}.}}
```
You can also use the Steam native runtime without `{{AUR|steam-native-runtime}}`{=mediawiki} by manually installing just
the packages you need. See [#Finding missing runtime libraries](#Finding_missing_runtime_libraries "wikilink").

## Debugging shared libraries {#debugging_shared_libraries}

To see the shared libraries required by a program or a shared library run the `{{ic|ldd}}`{=mediawiki} command on it,
see `{{man|1|ldd}}`{=mediawiki}. The `{{ic|LD_LIBRARY_PATH}}`{=mediawiki} and `{{ic|LD_PRELOAD}}`{=mediawiki}
[environment variables](environment_variables "wikilink") can alter which shared libraries are loaded, see
`{{man|8|ld.so}}`{=mediawiki}. To correctly debug a program or shared library it is therefore important that these
environment variables in your debug environment match the environment you wish to debug.

If you figure out a missing library you can use [pacman](pacman "wikilink") or [pkgfile](pkgfile "wikilink") to search
for packages that contain the missing library.

### Finding missing game libraries {#finding_missing_game_libraries}

If a game fails to start, a possible reason is that it is missing required libraries. You can find out what libraries it
requests by running `{{ic|ldd ''game_executable''}}`{=mediawiki}. `{{ic|''game_executable''}}`{=mediawiki} is likely
located somewhere in `{{ic|~/.steam/root/steamapps/common/}}`{=mediawiki}. Please note that most of these \"missing\"
libraries are actually already included with Steam, and do not need to be installed globally.

### Finding missing runtime libraries {#finding_missing_runtime_libraries}

If individual games or Steam itself is failing to launch when using `{{ic|steam-native}}`{=mediawiki} you are probably
missing libraries. To find the required libraries run:

`$ cd ~/.steam/root/ubuntu12_32`\
`$ file * | grep ELF | cut -d: -f1 | LD_LIBRARY_PATH=. xargs ldd | grep 'not found' | sort | uniq`

Alternatively, run Steam with `{{ic|steam}}`{=mediawiki} and use the following command to see which non-system libraries
Steam is using (not all of these are part of the Steam runtime):

`$ for i in $(pgrep steam); do sed '/\.local/!d;s/.*  //g' /proc/$i/maps; done | sort | uniq`

## Debugging Steam {#debugging_steam}

```{=mediawiki}
{{Out of date| Steam no longer redirects stdout and stderr to {{ic|/tmp/dumps/''USER''_stdout.txt}} by default. See: [https://github.com/ValveSoftware/steam-for-linux/issues/7114 steam-for-linux issue 7114] A similar effect can be achieved by starting steam with {{ic|steam 2>&1 | tee /path/to/logfile}} }}
```
The Steam launcher redirects its stdout and stderr to `{{ic|/tmp/dumps/''USER''_stdout.txt}}`{=mediawiki}. This means
you do not have to run Steam from the command-line to see that output. s It is possible to debug Steam to gain more
information which could be useful to find out why something does not work.

You can set `{{ic|DEBUGGER}}`{=mediawiki} environment variable with one of `{{ic|gdb}}`{=mediawiki},
`{{ic|cgdb}}`{=mediawiki}, `{{ic|valgrind}}`{=mediawiki}, `{{ic|callgrind}}`{=mediawiki}, `{{ic|strace}}`{=mediawiki}
and then start `{{ic|steam}}`{=mediawiki}.

For example with `{{Pkg|gdb}}`{=mediawiki}

`$ DEBUGGER=gdb steam`

```{=mediawiki}
{{ic|gdb}}
```
will open, then type `{{ic|run}}`{=mediawiki} which will start `{{ic|steam}}`{=mediawiki} and once crash happens you can
type `{{ic|backtrace}}`{=mediawiki} to see call stack.

## Runtime issues {#runtime_issues}

### \'GLBCXX_3.X.XX\' not found when using Bumblebee {#glbcxx_3.x.xx_not_found_when_using_bumblebee}

This error is likely caused because Steam packages its own out of date `{{ic|libstdc++.so.6}}`{=mediawiki}. See
[#Finding missing runtime libraries](#Finding_missing_runtime_libraries "wikilink") about working around the bad
library. See also [steam-for-linux issue 3773](https://github.com/ValveSoftware/steam-for-linux/issues/3773).

### Steam\>Warning: failed to init SDL thread priority manager: SDL not found {#steamwarning_failed_to_init_sdl_thread_priority_manager_sdl_not_found}

Solution: [install](install "wikilink") the `{{AUR|lib32-sdl2}}`{=mediawiki} package.

### Game crashes immediately {#game_crashes_immediately}

This is likely due to [#Steam runtime](#Steam_runtime "wikilink") issues, see [#Debugging shared
libraries](#Debugging_shared_libraries "wikilink").

Disabling the in-game Steam Overlay in the game properties might help.

And finally, if those do not work, you should check Steam\'s output for any error from the game. You may encounter the
following:

-   ```{=mediawiki}
    {{ic|munmap_chunk(): invalid pointer}}
    ```

-   ```{=mediawiki}
    {{ic|free(): invalid pointer}}
    ```

In these cases, try replacing the `{{ic|libsteam_api.so}}`{=mediawiki} file from the problematic game with one of a game
that works. This error usually happens for games that were not updated recently when Steam runtime is disabled. This
error has been encountered with AYIM, Bastion and Monaco.

If the game crashes with `{{ic|terminate called after throwing an instance of 'dxvk::DxvkError'}}`{=mediawiki} it\'s
likely that conflicting versions of vulkan are
[installed](https://www.reddit.com/r/archlinux/comments/s1vjjg/comment/hsb10ac/?context=3).
`{{Pkg|lib32-vulkan-intel}}`{=mediawiki} and Nvidia vulkan drivers are mutually exclusive. This is solved by
uninstalling the unneeded driver. To obtain information about the chipset vendor one can run:

`# lshw -C display | grep vendor`

To get a list of installed packages

`# pacman -Qs vulkan`

### Game and Steam crashes after game start {#game_and_steam_crashes_after_game_start}

If the following error is output:

`failed to dlopen engine.so error=/home/`*`GAMEPATH`*`` /bin/libgcc_s.so.1: version `GCC_7.0.0' not found (required by /usr/lib32/libopenal.so.1) ``

moving the incompatible lib can be a workaround.

`mv .local/share/Steam/steamapps/common/`*`GAME`*`/bin/libgcc_s.so.1 .local/share/Steam/steamapps/common/`*`GAME`*`/bin/libgcc_s.so.1.b`

### Some games freeze at start when in focus {#some_games_freeze_at_start_when_in_focus}

A combination of using `{{ic|ForceFullCompositionPipeline}}`{=mediawiki}, specific Proton versions and Nvidia driver
version 535 is known [to freeze some games](https://github.com/ValveSoftware/Proton/issues/6869) [using
DXVK/Vulkan](https://github.com/doitsujin/dxvk/issues/3670) at launch under Xorg. Using Alt+Tab allows bringing Steam in
focus, and the game seems to run properly in the background. Solution: disable
`{{ic|ForceFullCompositionPipeline}}`{=mediawiki} or downgrade Nvidia drivers.

### Version \`CURL_OPENSSL_3\` not found {#version_curl_openssl_3_not_found}

This is because `{{Pkg|curl}}`{=mediawiki} alone is not compatible with previous versions. You need to install the
compatibility libraries:

One of the following messages may show up:

`# Nuclear Throne`\
`` ./nuclearthrone: /usr/lib32/libcurl.so.4: version `CURL_OPENSSL_3' not found (required by ./nuclearthrone) ``\
\
`# Devil Daggers`\
`` ./devildaggers: /usr/lib/libcurl.so.4: version `CURL_OPENSSL_3' not found (required by ./devildaggers) ``

You need to install either `{{Pkg|libcurl-compat}}`{=mediawiki} or `{{Pkg|lib32-libcurl-compat}}`{=mediawiki} and link
the compatibility library manually:

`# Nuclear Throne`\
`$ ln -s /usr/lib32/libcurl-compat.so.4.4.0 "`*`LIBRARY`*`/steamapps/common/Nuclear Throne/lib/libcurl.so.4"`\
\
`# Devil Daggers`\
`$ ln -s /usr/lib/libcurl-compat.so.4.4.0 `*`LIBRARY`*`/steamapps/common/devildaggers/lib64/libcurl.so.4`

### Steam webview/game browser not working in native runtime (Black screen) {#steam_webviewgame_browser_not_working_in_native_runtime_black_screen}

Since the new Steam Friends UI update, the client webview is not working correctly with the native-runtime.

`./steamwebhelper: error while loading shared libraries: libpcre.so.3: cannot open shared object file: No such file or directory`

It can be solved preloading glib libraries; Those do not require libpcre and selinux to work.

`$ LD_PRELOAD="/usr/lib/libgio-2.0.so.0 /usr/lib/libglib-2.0.so.0" steam-native`

Alternatively, you may create a symbolic link to the native Arch libpcre library.

`# ln -s /usr/lib/libpcre.so /usr/lib64/libpcre.so.3`

Since update from around 3/3/2022, there are some reports of black screen still persisting after applying above
workaround.

The workaround for now is to run Steam with the `{{ic|-no-cef-sandbox}}`{=mediawiki} option. More information can be
found in Github Steam-For-Linux repository Issue [#8451](https://github.com/ValveSoftware/steam-for-linux/issues/8451)
and [#8420](https://github.com/ValveSoftware/steam-for-linux/issues/8420).

### Steam: An X Error occurred {#steam_an_x_error_occurred}

When using an NVidia GPU and proprietary drivers, Steam may fail to start and (if run from the terminal) produce errors
of the form:

`Steam: An X Error occurred`\
`X Error of failed request:  GLXBadContext`\
`Major opcode of failed request:  151`\
`Serial number of failed request:  51`\
`xerror_handler: X failed, continuing`

Install the package `{{Pkg|lib32-nvidia-utils}}`{=mediawiki} (or `{{AUR|lib32-nvidia-390xx-utils}}`{=mediawiki} if using
an old GPU).

If `{{Pkg|lib32-nvidia-utils}}`{=mediawiki} is installed, ensure that the package version matches
`{{Pkg|nvidia}}`{=mediawiki} with

`# pacman -Qs nvidia`

You may need to change which [mirrors](mirrors "wikilink") you are using to install the drivers if they do not match.

If you are using AMD, have enabled 10-bit color depth, and are having this problem. You will likely need to disable
10-bit color depth.

Another issue that causes this error message can be [solved by removing the config.vdf
file](https://github.com/ValveSoftware/steam-for-linux/issues/4340#issuecomment-258593713):

`$ rm ~/.local/share/Steam/config/config.vdf`

### Steam: Compatibility tool configuration failed {#steam_compatibility_tool_configuration_failed}

If you are trying to run a native game using Proton but get a Steam compatibility tool error immediately after starting
the game, you might have to reinstall the runtime.

1.  Navigate to your Steam library.
2.  In the dropdown above your game list check the *Tools* option to make them visible.
3.  Search for *Proton*, right click on each installed tool, visit *Properties*, open the *Local files* tab and click
    *Verify integrity of tool files* for each entry.
4.  Search for *Steam Linux Runtime* and repeat the same procedure. If none are available, install the latest *Steam
    Linux Runtime - Soldier*.

### Game starts but closes immediately with custom kernel {#game_starts_but_closes_immediately_with_custom_kernel}

Make sure that you have enabled *User namespace* in *General setup -\> Namespaces support*.

### Steam Library won\'t start {#steam_library_wont_start}

Opening the steam library either displays nothing, or a brief splash, but no window appears. Running
`{{ic|/usr/bin/steam}}`{=mediawiki} in a terminal window gives this error:

`Assertion 'device' failed at src/libsystemd/sd-device/device-private.c:103, function device_get_tags_generation(). Aborting.`

Bugs reports are filed: [#79006](https://bugs.archlinux.org/task/79006)

See also discussion at: [Steam failing to launch since systemd 253.5-2
update](https://bbs.archlinux.org/viewtopic.php?id=287033)

A workaround is to install `{{Pkg|lib32-libnm}}`{=mediawiki}.

## Graphical issues {#graphical_issues}

### Blurry text and graphics with Xwayland and HiDPI {#blurry_text_and_graphics_with_xwayland_and_hidpi}

When Steam runs as an [Xwayland](Xwayland "wikilink") client under a compositor that uses [HiDPI](HiDPI "wikilink")
scaling, you may find that Steam and games are rendered at half resolution and then upscaled to fit the HiDPI screen.
This results in blurry graphics.

One option is to run Steam under a nested [gamescope](gamescope "wikilink") compositor. Install the
`{{Pkg|gamescope}}`{=mediawiki} package:

`$ gamescope -f -m 1 -e -- steam -gamepadui`

This runs Steam in \"big picture\" mode (actually Steam Deck mode), in fullscreen, without scaling (i.e. at full
resolution). The same settings should also propagate to games run under Steam.

Another option is to configure your compositor to prevent Xwayland from scaling applications entirely. For example,
[Hyprland](Hyprland "wikilink") users can add

`xwayland {`\
`  force_zero_scaling = true`\
`}`

to the hyprland.conf file to prevent Xwayland from scaling any applications. Note that **all** applications that use
Xwayland will stop scaling, and so on HiDPI displays, text and other elements in those applications may become too small
to be comfortably viewed.

### Steam flicker/blink with black screen not loading Store/Library or other pages {#steam_flickerblink_with_black_screen_not_loading_storelibrary_or_other_pages}

When Steam is started on Wayland (not confirmed X11) with dual graphics in some cases Steam client is unstable display
black screen and flicker/blink. This is due to option PrefersNonDefaultGPU set to true in steam.desktop file.

#### Method 1 - Edit steam.desktop file {#method_1___edit_steam.desktop_file}

Locate .desktop file you are starting from your Application Launcher, and change line: From: PrefersNonDefaultGPU=true
To: PrefersNonDefaultGPU=false Usually located at \~/.local/share/applications/steam.desktop

If opened close steam and relaunch.

#### Method 2 - KDE Plasma - edit menu option in GUI {#method_2___kde_plasma___edit_menu_option_in_gui}

.Right click on .desktop file \> Edit application\... \> select tab \"Application\" \> Advanced Options \> Uncheck
option \"Run using dedicated graphics card\" \> save changes, and relaunch Steam

#### Workaround 1 - run steam from terminal {#workaround_1___run_steam_from_terminal}

It has been noted that starting steam from terminal is not affected so it is a known workaround.

`$ steam &`

Ampersand (&) at the end is to run steam in background, terminal can be closed after Steam starts.

## Audio issues {#audio_issues}

If the sections below do not address the issue, using the [#Steam native runtime](#Steam_native_runtime "wikilink")
might help.

### Configure PulseAudio {#configure_pulseaudio}

Games that explicitly depend on ALSA can break PulseAudio. Follow the directions for
[PulseAudio#ALSA](PulseAudio#ALSA "wikilink") to make these games use PulseAudio instead.

If you are using [PipeWire](PipeWire "wikilink"), then instead install `{{Pkg|lib32-pipewire}}`{=mediawiki} and set up
[PipeWire#PulseAudio clients](PipeWire#PulseAudio_clients "wikilink").

### No audio or 756 Segmentation fault {#no_audio_or_756_segmentation_fault}

First [#Configure PulseAudio](#Configure_PulseAudio "wikilink") and see if that resolves the issue. If you do not have
audio in the videos which play within the Steam client, it is possible that the ALSA libraries packaged with Steam are
not working.

Attempting to playback a video within the steam client results in an error similar to:

`ALSA lib pcm_dmix.c:1018:(snd_pcm_dmix_open) unable to open slave`

A workaround is to rename or delete the `{{ic|alsa-lib}}`{=mediawiki} folder and the `{{ic|libasound.so.*}}`{=mediawiki}
files. They can be found at:

`~/.steam/steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/`

An alternative workaround is to add the `{{ic|libasound.so.*}}`{=mediawiki} library to the
`{{ic|LD_PRELOAD}}`{=mediawiki} environment variable:

`$ LD_PRELOAD='/usr/$LIB/libasound.so.2 '${LD_PRELOAD} steam`

If audio still will not work, adding the PulseAudio libraries to the `{{ic|LD_PRELOAD}}`{=mediawiki} variable may help:

`$ LD_PRELOAD='/usr/$LIB/libpulse.so.0 /usr/$LIB/libpulse-simple.so.0 '${LD_PRELOAD} steam`

Be advised that their names may change over time. If so, it is necessary to take a look in

`~/.steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu`

and find the new libraries and their versions.

Bugs reports have been filed: [#3376](https://github.com/ValveSoftware/steam-for-linux/issues/3376) and
[#3504](https://github.com/ValveSoftware/steam-for-linux/issues/3504)

### FMOD sound engine {#fmod_sound_engine}

```{=mediawiki}
{{Accuracy|No source / bug report.}}
```
The [FMOD](https://www.fmod.com/) audio middleware package is a bit buggy, and as a result games using it may have sound
problems.

It usually occurs when an unused sound device is used as default for ALSA. See [Advanced Linux Sound Architecture#Set
the default sound card](Advanced_Linux_Sound_Architecture#Set_the_default_sound_card "wikilink").

:   Affected games: Hotline Miami, Hotline Miami 2, Transistor

### PulseAudio & OpenAL: Audio streams cannot be moved between devices {#pulseaudio_openal_audio_streams_cannot_be_moved_between_devices}

If you use [PulseAudio](PulseAudio "wikilink") and cannot move an audio stream between sinks, it might be because recent
OpenAL versions default to disallow audio streams from being moved. Try to add the following to your
`{{ic|~/.alsoftrc}}`{=mediawiki}:

`[pulse]`\
`allow-moves=true`

### Cracking Microphone in Steam Voice and Games {#cracking_microphone_in_steam_voice_and_games}

If you experience cracking with your audio input while using Steam Voice or in games, you can try to launch steam with
the environmental variable `{{ic|PULSE_LATENCY_MSEC{{=}}`{=mediawiki}30}}

## Steam client issues {#steam_client_issues}

### Cannot browse filesystem to add a library folder or library folder appears as empty {#cannot_browse_filesystem_to_add_a_library_folder_or_library_folder_appears_as_empty}

If the file chooser is empty when trying add a library folder, or if a previously set up folder now appears with 0 games
installed, this can be the result of an incorrect timestamp on the root directory or in the library folder. Timestamps
can be checked with *stat*:

`$ stat `*`path`*

If the timestamp is in the future, run

`$ touch `*`path`*

to reinitialize it to the current date, then re-run Steam.

### Cannot add library folder because of missing execute permissions {#cannot_add_library_folder_because_of_missing_execute_permissions}

If you add another Steam library folder on another drive, you might get the error message:

`New Steam library folder must be on a filesystem mounted with execute permissions`

Make sure you are mounting the filesystem with the correct flags in your `{{ic|/etc/fstab}}`{=mediawiki}, usually by
adding `{{ic|exec}}`{=mediawiki} to the list of mount parameter. The parameter must occur after any
`{{ic|user}}`{=mediawiki} or `{{ic|users}}`{=mediawiki} parameter since these can imply `{{ic|noexec}}`{=mediawiki}.

This error might also occur if your library folder does not contain a `{{ic|steamapps}}`{=mediawiki} directory. Previous
versions used `{{ic|SteamApps}}`{=mediawiki} instead, so ensure the name is fully lowercase.

This error can also occur because of Steam runtime issues and may be fixed following the [#Finding missing runtime
libraries](#Finding_missing_runtime_libraries "wikilink") section or due to no space being left on the device. For
debugging purposes it might be useful to run Steam from the console and observe the log.

### Unusually slow download speed {#unusually_slow_download_speed}

If your Steam (games, software...) download speed through the client is unusually slow, but browsing the Steam store and
streaming videos is unaffected, installing a DNS cache program, such as [dnsmasq](dnsmasq "wikilink") can help
[1](https://steamcommunity.com/app/221410/discussions/2/616189106498372437/).

Something else that might help would be disabling [IPv6](IPv6 "wikilink"). See
[2](https://github.com/ValveSoftware/steam-for-linux/issues/6126) for more information.

Another potential fix is to disable HTTP2 [3](https://github.com/ValveSoftware/steam-for-linux/issues/10248) by creating
\~/.steam/steam/steam_dev.cfg with the line

`@nClientDownloadEnableHTTP2PlatformLinux 0`

Adding the following line to the steam_dev.cfg file to increase the server connections may improve but may also
negatively affect speeds

`@fDownloadRateImprovementToAddAnotherConnection 1.0`

### \"Needs to be online\" error {#needs_to_be_online_error}

```{=mediawiki}
{{Out of date|''nscd'' was removed in [https://gitlab.archlinux.org/archlinux/packaging/packages/glibc/-/commit/25032a8abb2760257c3dceb78e649a0a2c4e3ab2 glibc 2.38-4].}}
```
```{=mediawiki}
{{Expansion|Unclear why enabling nscd can help|section=Needs to be online error: Enabling nscd.service}}
```
If the Steam launcher refuses to start and you get an error saying: \"*Fatal Error: Steam needs to be online to
update*\" while you are online, then there might be issues with name resolving.

Try installing `{{Pkg|lib32-systemd}}`{=mediawiki}, `{{Pkg|lib32-libcurl-compat}}`{=mediawiki},
`{{Pkg|nss-mdns}}`{=mediawiki}, `{{Pkg|lib32-nss}}`{=mediawiki}, `{{Pkg|lib32-glu}}`{=mediawiki} or
`{{Pkg|lib32-dbus}}`{=mediawiki}.

This may also be as simple as DNS resolution not correctly working and is not always obvious since modern browsers will
use their own DNS servers. Follow [Domain name resolution](Domain_name_resolution "wikilink").

Steam may have issues if *systemd-resolved* is providing DNS resolution. Make sure `{{Pkg|lib32-systemd}}`{=mediawiki}
is present to resolve this.

If DNS resolution works but the Steam launcher still shows the same error message, [enabling](enabling "wikilink") DNS
caching e.g. via the \"Name Service Caching Daemon\", `{{ic|nscd.service}}`{=mediawiki}, has shown to work around this
issue.

It is unclear what exactly running `{{ic|nscd}}`{=mediawiki} does to make it work again though. Please check the [talk
page](Talk:Steam/Troubleshooting#Needs_to_be_online_error:_Enabling_nscd.service "wikilink") for more info.

### Steam forgets password {#steam_forgets_password}

:   Related: [steam-for-linux#5030](https://github.com/ValveSoftware/steam-for-linux/issues/5030)

Steam for Linux has a bug which causes it to forget the password of some users.

As a workaround, after logging in to Steam, run

`# chattr +i ~/.steam/registry.vdf`

This will set the file\'s immutable bit so Steam cannot modify, delete, or rename it and thus not log you out.

### Preventing crash memory dumps {#preventing_crash_memory_dumps}

Every time Steam crashes, it writes a memory dump to `{{ic|/tmp/dumps/}}`{=mediawiki}. If Steam falls into a crash loop,
the dump files can become quite large. When `{{ic|/tmp}}`{=mediawiki} is mounted as [tmpfs](tmpfs "wikilink"), memory
and swap file can be consumed needlessly.

To prevent this, link `{{ic|/tmp/dumps/}}`{=mediawiki} to `{{ic|/dev/null}}`{=mediawiki}:

`# ln -s /dev/null /tmp/dumps`

Or alternatively, create and modify permissions on `{{ic|/tmp/dumps}}`{=mediawiki}. Then Steam will be unable to write
dump files to the directory.

`# mkdir /tmp/dumps`\
`# chmod 600 /tmp/dumps`

This also has the added benefit of Steam not uploading these dumps to Valve\'s servers.

### Steam license problem with playing videos {#steam_license_problem_with_playing_videos}

Steam uses [Google\'s Widevine DRM](w:Widevine "wikilink") for some videos. If it is not installed you will get the
following error:

`This video requires a license to play which cannot be retrieved. This may be a temporary network condition. Please restart the video to try again.`

To solve this issue follow the [*Streaming Videos on Steam* support
page](https://help.steampowered.com/en/faqs/view/2FC3-54BF-465F-E556#15).

### No context menu for joining/inviting friends {#no_context_menu_for_joininginviting_friends}

Since the new Steam Friends UI update, it may be the case that in the right-click menu the entries for \"Join Game\",
\"Invite to Game\" and \"View Game Info\" are missing.

In order to fix this, it maybe be necessary to install `{{Pkg|lsof}}`{=mediawiki}.

### Slow and unresponsive user interface {#slow_and_unresponsive_user_interface}

If you experience extremely slow and sluggish performance when using the Steam client it might help to disable the
*Enable GPU accelerated rendering in web views* option under the *Interface* tab in the Steam client settings.

The friends list can also cause this problem. Two workarounds are mentioned in
<https://github.com/ValveSoftware/steam-for-linux/issues/7245>:

-   Moving the friends list to another monitor
    [4](https://github.com/ValveSoftware/steam-for-linux/issues/7245#issuecomment-663629964).
-   Disabling animated avatars. Open Settings and navigate to Friends & Chat. Set *Enable Animated Avatars & Animated
    Avatar Frames in your Friends List and Chat \> OFF*
    [5](https://github.com/ValveSoftware/steam-for-linux/issues/7245#issuecomment-813443906).

### Steam fails to start correctly {#steam_fails_to_start_correctly}

One troubleshooting step is to run

`$ steam --reset`

This can fix various issues that come with a broken install.

### Missing taskbar menu {#missing_taskbar_menu}

If clicking your steam taskbar icon does not give you a menu, it may be necessary to install the
`{{AUR|libappindicator-gtk2}}`{=mediawiki} and `{{AUR|lib32-libappindicator-gtk2}}`{=mediawiki} packages and restart
steam.

### \"Your browser does not support the minimum set of features required to watch this broadcast\" error {#your_browser_does_not_support_the_minimum_set_of_features_required_to_watch_this_broadcast_error}

See [steam-for-linux issue 6780](https://github.com/ValveSoftware/steam-for-linux/issues/6780)

If you get an error stating \"*Your browser does not support the minimum set of features required to watch this
broadcast*\" when attempting to watch a stream/broadcast try the following troubleshooting steps:

1.  Navigate to *Community \> Broadcasts*. If the page displays \"*Updating Steam*\" wait a few minutes to see if the
    process completes and cancel it after a while in case it does not. Now test if you are able to watch broadcasts,
    e.g. by clicking on one of the ones display under *Community \> Broadcasts*.
2.  Start a broadcast while in Big Picture mode (*View \> Big Picture Mode*). If a broadcast starts fine while in Big
    Picture mode check if it still works after switching back to the main interface.
3.  Trigger the Steam client to directly unlock H.264 decoding using the following command:
    `{{ic|steam steam://unlockh264/}}`{=mediawiki}. The Steam client should start headless and run the unlock command.
    Wait a minute to be sure the process completes, then close and relaunch the Steam client.

### Using system titlebar and frame {#using_system_titlebar_and_frame}

Currently steam client tries to manage its windows itself, but it does it improperly, see
[steam-for-linux#1040](https://github.com/ValveSoftware/steam-for-linux/issues/1040). As a workaround you can use
[steamwm](https://github.com/dscharrer/steamwm) project. Run steam like this: `{{ic|./steamwm.cpp steam}}`{=mediawiki}.
Also the project provides a skin that removes unnative control buttons and frame, but leaves default skin decorations.

### More selective DPMS inhibition {#more_selective_dpms_inhibition}

By default, the Steam client totally disables screensaving when it is running, whether a game is launched or not.

A workaround to this issue is provided by `{{AUR|steam-screensaver-fix}}`{=mediawiki}: run
`{{ic|steam-screensaver-fix-native}}`{=mediawiki} or `{{ic|steam-screensaver-fix-runtime}}`{=mediawiki}.

This will allow your screen to turn off if Steam is running, but will keep inhibiting the screensaver if a game is
launched.

See [Issue 5607](https://github.com/ValveSoftware/steam-for-linux/issues/5607) at Valve\'s GitHub for the details.

### Enabling fractional scaling {#enabling_fractional_scaling}

If the text and icons in the Steam client window are too small to read on your display, it may be beneficial to enable
fractional scaling. The Steam client has a settings option to enable it, at *Settings \> Interface \> Scale text and
icons to match monitor settings*. Enabling this should tell the client to use the system\'s fractional scaling settings.

However, if this does not automatically work, there is a command line parameter to force fractional scaling. Running
Steam with the `{{ic|-forcedesktopscaling 1.5}}`{=mediawiki} flag will scale the client to 1.5x size. This value can be
changed to the correct scaling factor for your monitor. If you wish to make this change permanent, you can edit the
`{{ic|Exec}}`{=mediawiki} field in the `{{ic|steam.desktop}}`{=mediawiki} file.

### Steam Beta crashes {#steam_beta_crashes}

If you are using Steam Beta (which can be confirmed with the presence of
`{{ic|You are in the 'publicbeta' client beta}}`{=mediawiki} in the logs) and encounter breaking bugs, manually switch
back to non-Beta:

`$ rm -f ~/.local/share/Steam/package/beta`

Report the issue after looking for duplicates at <https://github.com/ValveSoftware/steam-for-linux>.

### Cannot access store page (client displays error -105) {#cannot_access_store_page_client_displays_error__105}

If the store page is inaccessible but other networking features (such as game downloads) are working, it may be a DNS
resolution failure. A possible solution is to ensure [systemd-resolved](systemd-resolved "wikilink") is enabled and
started, then create the `{{ic|/etc/resolv.conf}}`{=mediawiki} symlink as explained in
[systemd-resolved#DNS](systemd-resolved#DNS "wikilink").

## Steam Remote Play issues {#steam_remote_play_issues}

See [Steam#Steam Remote Play](Steam#Steam_Remote_Play "wikilink").

### Remote Play does not work from Arch Linux host to Arch Linux guest {#remote_play_does_not_work_from_arch_linux_host_to_arch_linux_guest}

Chances are you are missing `{{Pkg|lib32-libcanberra}}`{=mediawiki}. Once you [install](install "wikilink") that, it
should work as expected.

With that, Steam should no longer crash when trying to launch a game through Remote Play.

### Hardware decoding not available {#hardware_decoding_not_available}

Remote Play hardware decoding uses `{{ic|vaapi}}`{=mediawiki}, but steam requires `{{ic|libva2_32bit}}`{=mediawiki},
where as Arch defaults to 64bit.

As a basic set, this is `{{Pkg|libva}}`{=mediawiki} and `{{Pkg|lib32-libva}}`{=mediawiki}. Intel graphics users will
also require both `{{Pkg|libva-intel-driver}}`{=mediawiki} and `{{Pkg|lib32-libva-intel-driver}}`{=mediawiki}.

For more information about vaapi see [hardware video acceleration](hardware_video_acceleration "wikilink").

It may also be necessary to remove the steam runtime version of libva, in order to force it to use system libraries. The
current library in use can be found by using:

`$ pgrep steam | xargs -I {} cat /proc/{}/maps | grep libva`

If this shows locations in `{{ic|~/.local/Share/steam}}`{=mediawiki} steam is still using its packaged version of libva.
This can be rectified by deleting the libva library files at
`{{ic|~/.local/share/Steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libva*}}`{=mediawiki}, so that steam
falls back to the system libraries.

### Big Picture Mode minimizes itself after losing focus {#big_picture_mode_minimizes_itself_after_losing_focus}

This can occur when you play a game via Remote Play or if you have a multi-monitor setup and move the mouse outside of
BPM\'s window. To prevent this, set the `{{ic|1=SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0}}`{=mediawiki} environment variable
and restart Steam.

See also the [steam-for-linux issue 4769](https://github.com/ValveSoftware/steam-for-linux/issues/4769).

## Other issues {#other_issues}

### Steam Library in NTFS partition {#steam_library_in_ntfs_partition}

```{=mediawiki}
{{Note|The kernel [[NTFS]] driver is vastly more performant than the [[NTFS-3G]] [[FUSE]] driver [https://openbenchmarking.org/result/2009092-NE-NTFSCOMPA56]. So, for gaming scenario, it is better to uninstall {{Pkg|ntfs-3g}} package as GUI file managers driven by [[udisks]] prefer it when present.}}
```
If your Steam library resides in [NTFS](NTFS "wikilink") partition it is probable that games residing there could not
start.

The trouble is that Wine uses a colon in its `{{ic|$WINEPREFIX/dosdevices}}`{=mediawiki} directory, and when mounted
with the `{{ic|windows_names}}`{=mediawiki} option, is instructed to not create such colon names which can confuse
Windows. Not adding it is not that unsafe: Windows will act fine besides being unable to open the symlink (which it will
not need to do anyways); `{{ic|chkdsk}}`{=mediawiki} may delete the link, but it is easily recreated.

Better workaround: mount without `{{ic|windows_names}}`{=mediawiki}. This option is often added by GUI file explorers
via [udisks](udisks "wikilink") for caution, but adding a real [fstab](fstab "wikilink") line will give it a proper way
to do so.

1.  Run `{{ic|genfstab -U /}}`{=mediawiki} and extract the line containing the ntfs partition, e.g.
    `{{bc|1=UUID=12345678ABCDEF00 /run/media/user/Gamez ntfs3 rw,uid=1000,gid=1000,windows_names 0 0}}`{=mediawiki}
2.  Write the line into `{{ic|/etc/fstab}}`{=mediawiki}, editing it to use the proper options without
    `{{ic|windows_names}}`{=mediawiki}. With the earlier example, we would write
    `{{bc|1=UUID=12345678ABCDEF00 /run/media/user/Gamez ntfs3 rw,uid=1000,gid=1000 0 0}}`{=mediawiki}
3.  Unmount the partition, then remount.

Alternatively, disable udisks use of `{{ic|windows_names}}`{=mediawiki} globally following instructions in [udisks#NTFS
file creation failing (filename-dependent)](udisks#NTFS_file_creation_failing_(filename-dependent) "wikilink").

Other workaround: move the `{{ic|steamapps/common/Proton ''x''.''y''}}`{=mediawiki} and
`{{ic|steamapps/compatdata}}`{=mediawiki} to a non-NTFS drive, then create symbolic link in their original locations.
You may be wasting some space on your otherwise important Linux drive, however.

`$ mv `*`SteamLibrary`*`/steamapps/common/Proton\ `*`x`*`.`*`y`*` /home/`*`user`*`/dir/`\
`$ mv `*`SteamLibrary`*`/steamapps/compatdata /home/`*`user`*`/dir/`\
`$ ln -s /home/`*`user`*`/dir/Proton\ `*`x`*`.`*`y`*`/ `*`SteamLibrary`*`/steamapps/common/Proton\ `*`x`*`.`*`y`*\
`$ ln -s /home/`*`user`*`/dir/compatdata/ `*`SteamLibrary`*`/steamapps/compatdata`

### Wrong ELF class {#wrong_elf_class}

If you see this message in Steam\'s console output

`ERROR: ld.so: object '~/.local/share/Steam/ubuntu12_32/gameoverlayrenderer.so' from LD_PRELOAD cannot be preloaded (wrong ELF class: ELFCLASS32): ignored.`

you can safely ignore it. It is not really any error: Steam includes both 64- and 32-bit versions of some libraries and
only one version will load successfully. This \"error\" is displayed even when Steam (and the in-game overlay) is
working perfectly.

### Multiple monitors setup {#multiple_monitors_setup}

```{=mediawiki}
{{Expansion|Is this Nvidia-only? Can this be reproduced by anyone? Is there an upstream report?}}
```
A setup with multiple monitors may prevent games from starting. Try to disable all additional displays, and then run a
game. You can enable them after the game successfully started.

Also you can try running Steam with this environment variable set:

`$ export LD_LIBRARY_PATH=/usr/lib32/nvidia:/usr/lib/nvidia:$LD_LIBRARY_PATH`

### Text is corrupt or missing {#text_is_corrupt_or_missing}

Try installing `{{Pkg|lib32-fontconfig}}`{=mediawiki}, `{{Pkg|ttf-liberation}}`{=mediawiki} and
`{{Pkg|wqy-zenhei}}`{=mediawiki} (for Asian characters), then restart Steam to see whether the problem is solved.

```{=mediawiki}
{{Note|
* Steam for Linux does not follow system-level font configurations.[https://github.com/ValveSoftware/steam-for-linux/issues/10422#issuecomment-1944396010] Thus, modify user-level configuration if you want change fontconfig for steam.
* When Steam cannot find the Arial font, font-config likes to fall back onto the Helvetica bitmap font. Steam does not render this and possibly other bitmap fonts correctly, so either removing problematic fonts or [[Font configuration#Disable bitmap fonts|disabling bitmap fonts]] will most likely fix the issue without installing the Arial or ArialBold fonts. The font being used in place of Arial can be found with the command: {{bc|$ fc-match -v Arial}}
}}
```
### SetLocale(\'en_US.UTF-8\') fails at game startup or typing non-ASCII characters does not work in the Steam client {#setlocaleen_us.utf_8_fails_at_game_startup_or_typing_non_ascii_characters_does_not_work_in_the_steam_client}

You need to generate the `{{ic|en_US.UTF-8 UTF-8}}`{=mediawiki} locale. See [Locale#Generating
locales](Locale#Generating_locales "wikilink").

### Missing libc {#missing_libc}

```{=mediawiki}
{{Accuracy|Issue #3730 is closed. Is {{ic|$HOME}} ending in a slash still relevant?}}
```
This could be due to a corrupt Steam executable. Check the output of:

`$ ldd ~/.local/share/Steam/ubuntu12_32/steam`

Should `{{ic|ldd}}`{=mediawiki} claim that it is not a dynamic executable, then Steam likely corrupted the binary during
an update. The following should fix the issue:

`$ cd ~/.local/share/Steam/`\
`$ ./steam.sh --reset`

If it does not, try to delete the `{{ic|~/.local/share/Steam/}}`{=mediawiki} directory and launch Steam again, telling
it to reinstall itself.

This error message can also occur due to a bug in Steam which occurs when your `{{ic|$HOME}}`{=mediawiki} directory ends
in a slash (Valve GitHub [issue 3730](https://github.com/ValveSoftware/steam-for-linux/issues/3730)). This can be fixed
by editing `{{ic|/etc/passwd}}`{=mediawiki} and changing `{{ic|/home/''username''/}}`{=mediawiki} to
`{{ic|/home/''username''}}`{=mediawiki}, then logging out and in again. Afterwards, Steam should repair itself
automatically.

### Games do not launch on older Intel hardware {#games_do_not_launch_on_older_intel_hardware}

:   [source](https://steamcommunity.com/app/8930/discussions/1/540744299927655197/)

On older Intel hardware which does not support OpenGL 3, such as Intel GMA chips or Westmere CPUs, games may immediately
crash when run. It appears as a `{{ic|gameoverlayrenderer.so}}`{=mediawiki} error in
`{{ic|/tmp/dumps/mobile_stdout.txt}}`{=mediawiki}, but looking in `{{ic|/tmp/gameoverlayrenderer.log}}`{=mediawiki} it
shows a GLXBadFBConfig error.

This can be fixed, by forcing the game to use a later version of OpenGL than it wants. Add
`{{ic|1=MESA_GL_VERSION_OVERRIDE=3.1 MESA_GLSL_VERSION_OVERRIDE=140}}`{=mediawiki} to your [launch
options](launch_option "wikilink").

### Mesa: Game does not launch, complaining about OpenGL version supported by the card {#mesa_game_does_not_launch_complaining_about_opengl_version_supported_by_the_card}

Some games are badly programmed, to use any OpenGL version above 3.0. With Mesa, an application has to request a
specific core profile. If it does not make such a request, only OpenGL 3.0 and lower are available.

This can be fixed, by forcing the game to use a version of OpenGL it actually needs. Add
`{{ic|1=MESA_GL_VERSION_OVERRIDE=4.1 MESA_GLSL_VERSION_OVERRIDE=410}}`{=mediawiki} to your [launch
options](launch_option "wikilink").

### 2K games do not run on XFS partitions {#k_games_do_not_run_on_xfs_partitions}

```{=mediawiki}
{{Expansion|Seems to be a general issue, e.g. [https://github.com/ValveSoftware/Source-1-Games/issues/1685]}}
```
If you are running 2K games such as Civilization 5 on [XFS](XFS "wikilink") partitions, then the game may not start or
run properly due to how the game loads files as it starts. [6](https://bbs.archlinux.org/viewtopic.php?id=185222)

### Steam controller not being detected correctly {#steam_controller_not_being_detected_correctly}

See [Gamepad#Steam Controller](Gamepad#Steam_Controller "wikilink").

### Steam controller makes a game crash {#steam_controller_makes_a_game_crash}

See [Gamepad#Steam Controller makes a game crash or not
recognized](Gamepad#Steam_Controller_makes_a_game_crash_or_not_recognized "wikilink").

### Steam hangs on \"Installing breakpad exception handler\...\" {#steam_hangs_on_installing_breakpad_exception_handler...}

[BBS#177245](https://bbs.archlinux.org/viewtopic.php?id=177245)

You have an Nvidia GPU and Steam has the following output:

`Running Steam on arch rolling 64-bit`\
`STEAM_RUNTIME is enabled automatically`\
`Installing breakpad exception handler for appid(steam)/version(0_client)`

Then nothing else happens. Ensure you have the correct drivers installed as well as their 32-bit versions (the 64-bit
and 32-bit variants have to have the same versions): see [NVIDIA#Installation](NVIDIA#Installation "wikilink").

### Killing standalone compositors when launching games {#killing_standalone_compositors_when_launching_games}

Utilizing the `{{ic|%command%}}`{=mediawiki} switch, you can kill standalone compositors (such as
[Xcompmgr](Xcompmgr "wikilink") or [picom](picom "wikilink")) - which can cause lag and tearing in some games on some
systems - and relaunch them after the game ends by adding the following to your game\'s launch options.

`killall `*`compositor`*` && %command%; nohup `*`compositor`*` &`

You can also add -options to `{{ic|%command%}}`{=mediawiki} or `{{ic|''compositor''}}`{=mediawiki}, of course.

Steam will latch on to any processes launched after `{{ic|%command%}}`{=mediawiki} and your Steam status will show as in
game. So in this example, we run the compositor through `{{ic|nohup}}`{=mediawiki} so it is not attached to Steam (it
will keep running if you close Steam) and follow it with an ampersand so that the line of commands ends, clearing your
Steam status.

If your compositor supports running in daemon mode, you can use it instead. For example, `{{man|1|picom}}`{=mediawiki}
has the `{{ic|--daemon}}`{=mediawiki} / `{{ic|-b}}`{=mediawiki} option to daemonize its process:

`killall picom && %command%; picom -b`

### Symbol lookup error using DRI3 {#symbol_lookup_error_using_dri3}

Steam outputs this error and exits.

`symbol lookup error: /usr/lib/libxcb-dri3.so.0: undefined symbol: xcb_send_request_with_fds`

To work around this, run Steam with `{{ic|1=LIBGL_DRI3_DISABLE=1}}`{=mediawiki}, disabling DRI3 for Steam.

### Launching games on Nvidia optimus laptops {#launching_games_on_nvidia_optimus_laptops}

```{=mediawiki}
{{Out of date|Was for using bumblebee : what is the equivalent for recommended setup now, using prime-run instead does not work }}
```
To be able to play games which require using Nvidia GPU (for example, Hitman 2016) on optimus enabled laptop, you should
start game with *primusrun* prefix in launch options. Otherwise, game will not work.

Right click the game in your steam library and select *Properties \> GENERAL \> LAUNCH OPTIONS*. Change options to

`primusrun %command%`

Running steam with *primusrun* used to work. While steam has changed some behavior that now running steam with
*primusrun* would not have effect on launching games. As a result, you need to set launch options for each game (and you
do NOT have to run steam with *primusrun*).

For *primusrun*, VSYNC is enabled by default it could result in a mouse input delay lag, slightly decrease performance
and in-game FPS might be locked to a refresh rate of a monitor/display. In order to disable VSYNC for primusrun default
value of option `{{ic|vblank_mode}}`{=mediawiki} needs to be overridden by environment variable.

`vblank_mode=0 primusrun %command%`

Same with optirun that uses primus as a bridge.

`vblank_mode=0 optirun -b primus %command%`

If that did not work try:

`LD_PRELOAD="libpthread.so.0 libGL.so.1" __GL_THREADED_OPTIMIZATIONS=1 optirun %command%`

For more details see [Bumblebee#Primusrun mouse delay (disable
VSYNC)](Bumblebee#Primusrun_mouse_delay_(disable_VSYNC) "wikilink").

### HiDPI

[HiDPI](HiDPI "wikilink") support should work out of the box, although on some systems it is necessary to [force
it](HiDPI#Steam "wikilink") setting the `{{ic|1=-forcedesktopscaling ''factor''}}`{=mediawiki} cli option or the
`{{ic|STEAM_FORCE_DESKTOPUI_SCALING}}`{=mediawiki} environment variable to set the desired scale factor.

### Protocol support under KDE Plasma {#protocol_support_under_kde_plasma}

If you are getting an error after running a game through web browser *(or executing the link through xdg-open)*

`Error — KIOExec`\
`File not found: `[`steam://run/440`](steam://run/440)

Go to *System Settings -\> Applications -\> File Associations*, add new, select `{{ic|inode}}`{=mediawiki} group and
name it `{{ic|vnd.kde.service.steam}}`{=mediawiki}, then under *Application Preference Order* you have to add Steam.
Apply changes, It should be working now.

### The game crashes when using Steam Linux Runtime - Soldier {#the_game_crashes_when_using_steam_linux_runtime___soldier}

```{=mediawiki}
{{Out of date|Was a fix 2021-03 : is this still relevant today?}}
```
Since Proton 5.13 Steam uses the Steam Linux Runtime - Soldier by default. Some games crash when using it.

To bypass it, you can:

-   Manually [build](https://github.com/ValveSoftware/Proton#alternative-building-without-the-steam-runtime) a proton
    without the Steam Runtime
-   Replace the Soldier entry point script:

```{=mediawiki}
{{hc|~/.steam/steam/steamapps/common/SteamLinuxRuntime_soldier/_v2-entry-point|
#!/bin/bash

shift 2
exec "${@}"
}}
```
### Games running with Proton 5.13+ have no Internet connectivity {#games_running_with_proton_5.13_have_no_internet_connectivity}

If you are using [systemd-resolved](systemd-resolved "wikilink") as your DNS resolver, ensure you have created the
`{{ic|resolv.conf}}`{=mediawiki} symlink as described in [systemd-resolved#DNS](systemd-resolved#DNS "wikilink").

The file should contain something similar to:

```{=mediawiki}
{{hc|1=/etc/resolv.conf|2=
# This is /run/systemd/resolve/stub-resolv.conf managed by man:systemd-resolved(8).
# Do not edit.
}}
```
### \"could not determine 32/64 bit of java\" {#could_not_determine_3264_bit_of_java}

A forgotten install of the `{{AUR|linux-steam-integration}}`{=mediawiki} package caused this with at least one game.
Early on there were conflicts between the system and the steam runtime versions of some libraries, and that package
helped resolve some of them. It is unclear whether it is still helpful, but uninstalling it resolved the above error
message for Project Zomboid. The solution was discovered by noticing that running the
`{{ic|projectzomboid.sh}}`{=mediawiki} command from the command line worked, but switching the launch options to
`{{ic|sh -xc 'echo %command%; declare -p'}}`{=mediawiki} showed Steam was trying to run the exact same command, but
there were a lot of `{{ic|lsi-}}`{=mediawiki}-prefixed libraries inserted in the preload and path.

### Stuttering with Vulkan {#stuttering_with_vulkan}

If you notice a constant intense stutter every 1-2 seconds, there may be conflicts in your vsync settings. Manually
configuring vsync in the parameters will possibly fix it.

Go to the game properties and configure it in Launch Options:

`DXVK_FRAME_RATE=60 %command%`

### Force OpenGL emulation {#force_opengl_emulation}

Some, especially older games might not work with the default Vulkan ([DXVK](DXVK "wikilink")) wrapper Proton uses. Try
running the application with WineD3D OpenGL wrapper instead:

`PROTON_USE_WINED3D=1 %command%`

### File picker does not see anything but steam library {#file_picker_does_not_see_anything_but_steam_library}

See `{{Bug|78625}}`{=mediawiki}. You need to install `{{Pkg|xdg-desktop-portal}}`{=mediawiki}.

### DirectX errors on hybrid graphics {#directx_errors_on_hybrid_graphics}

For laptop with Intel/Nvidia [Hybrid graphics](Hybrid_graphics "wikilink") encountering the following error:

`A d3d11-compatible gpu (feature level 11.0, shader model 5.0) is required to run the engine.`

It\'s probably because your game is running on the iGPU instead of the dedicated GPU and you need to configure
[PRIME](PRIME "wikilink"). If it\'s still not doing it, try using [Direct3D instead of
DXVK](#Force_OpenGL_emulation "wikilink").

### No Internet Connection when downloading {#no_internet_connection_when_downloading}

If you see *No Internet Connection* while downloading games, a possible solution is clearing the download cache (*Steam
\> Settings \> Downloads \> Clear Download Cache*).

### Poor performance or stuttering after launching Steam {#poor_performance_or_stuttering_after_launching_steam}

If you experience reduced performance or stuttering, lasting anywhere from a few seconds to a couple of minutes after
launching Steam, it may be cased by bugged or outdated Proton installations.

Remove bugged Proton installed under app ID 0: `{{ic|1=~/.steam/root/steamapps/compatdata/0}}`{=mediawiki}. You may also
need to remove outdated and problematic Proton versions, including custom ones like GE-Proton, especially
`{{ic|1=5.21-GE-1}}`{=mediawiki}.

For more details, see [steam-for-linux#8114](https://github.com/ValveSoftware/steam-for-linux/issues/8114).

### Very long startup and slow user interface response {#very_long_startup_and_slow_user_interface_response}

Steam\'s use of `{{ic|1=steamloopback.host}}`{=mediawiki} in its Chromium backend to refer to itself. Due to the way
*systemd-resolvd* attempts to resolve this host (via `{{ic|1=mdns}}`{=mediawiki} by default for some users) this issue
can hang the interface. This causes very long startups (if it ever starts) and a slow-responding (or not at all) user
interface. This issue can temporary be addressed by editing `{{ic|1=/etc/nsswitch.conf}}`{=mediawiki} to change
`{{ic|1=mdns}}`{=mediawiki} to `{{ic|1=mdns_minimal}}`{=mediawiki} and restarting systemd-resolvd. For more details, see
[7](https://github.com/ValveSoftware/steam-for-linux/issues/10879).

## See also {#see_also}

-   [Multimedia and Games / Arch Linux Forums](https://bbs.archlinux.org/viewforum.php?id=32)
-   [ValveSoftware/steam-for-linux](https://github.com/ValveSoftware/steam-for-linux) -- Issue tracking for the Steam
    for Linux client
-   [Steam Community discussions of the game](https://steamcommunity.com/)
-   [Steam Support FAQ](https://help.steampowered.com/en/)

[Category:Gaming](Category:Gaming "wikilink")

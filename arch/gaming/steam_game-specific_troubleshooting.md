[ja:Steam/ゲーム別のトラブルシューティング](ja:Steam/ゲーム別のトラブルシューティング "wikilink")
[zh-hans:Steam/游戏疑难解答](zh-hans:Steam/游戏疑难解答 "wikilink") See
[Steam/Troubleshooting](Steam/Troubleshooting "wikilink") first.

This page assumes familiarity with the [Steam#Directory structure](Steam#Directory_structure "wikilink"), [Steam#Launch
options](Steam#Launch_options "wikilink"), [environment variables](environment_variables "wikilink"), the [Steam
runtime](Steam_runtime "wikilink") and [shared libraries](Steam/Troubleshooting#Debugging_shared_libraries "wikilink").
The `{{ic|''GAME''}}`{=mediawiki} pseudo-variable is used to refer to a game\'s directory. When the text reads \"*run
the game with `{{ic|1=FOO=bar}}`{=mediawiki}*\" it is implied that you either update your launch options or run the game
from the command-line with the environment variable.

## Contributing

-   Use \"game directory\" or the `{{ic|''GAME''}}`{=mediawiki} pseudo-variable to refer to a game\'s directory.
-   Link bug reports and sources of workarounds.

## Other sources {#other_sources}

The following links offer even more fixes and tweaks for various games which would otherwise exceed this article\'s
purpose:

-   [PC Gaming Wiki](https://pcgamingwiki.com/wiki/Home)

For games running with Proton, you can check ProtonDB which lists a lot of useful user reports for specific games. You
can filter searched reports by Linux distribution and by hardware. Users also describe if they had to apply tweaks.

-   [ProtonDB](https://www.protondb.com/) crowdsourced Linux compatibility reports.

## Common steps {#common_steps}

### OpenSSL 1.0 setup {#openssl_1.0_setup}

```{=mediawiki}
{{Out of date|The linked bug report is from 2017, are there still games affected?}}
```
Some Steam games are built against OpenSSL 1.0. (`{{Bug|53618}}`{=mediawiki})

Install `{{AUR|lib32-openssl-1.0}}`{=mediawiki} and run the game with
`{{ic|1=LD_LIBRARY_PATH=/usr/lib/openssl-1.0}}`{=mediawiki}.

### Missing libcurl.so.4 or version CURL_OPENSSL_3 not found {#missing_libcurl.so.4_or_version_curl_openssl_3_not_found}

[Install](Install "wikilink") `{{Pkg|lib32-libcurl-compat}}`{=mediawiki} and run the game with
`{{ic|1=LD_PRELOAD=libcurl.so.3}}`{=mediawiki}.

### Steam Link {#steam_link}

Currently Steam Link does not work with Wayland. You will only see a blank screen or even flickering when connecting to
a Steam host running on Wayland. So you have to disable Wayland, for example:

```{=mediawiki}
{{hc|/etc/gdm/custom.conf|2=
WaylandEnable=false
}}
```
And restart the login manager before continuing.

### Squares or invisible symbols, special characters and cyrillic letters in Source-based games {#squares_or_invisible_symbols_special_characters_and_cyrillic_letters_in_source_based_games}

Any special character may produce a square or an empty space mark in the game, main menu and game console. In practice,
any characters other than latin ones are not working. The problem is that `{{ic|Bitstream Vera Sans}}`{=mediawiki} is
configured as the system primary default font for latin sans-serif fonts.

First, make sure that per-user font customization files are enabled, i.e. the following file exist:

`/etc/fonts/conf.d/50-user.conf`

Next, create `{{ic|fonts.conf}}`{=mediawiki} file in your fontconfig directory with the following content or if the file
already exist, append only the alias section to the file:

```{=mediawiki}
{{hc|~/.config/fontconfig/fonts.conf|2=
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
 <alias>
  <family>sans-serif</family>
   <prefer>
    <family>DejaVu Sans</family>
    <family>Verdana</family>
    <family>Arial</family>
    <family>Albany AMT</family>
    <family>Luxi Sans</family>
    <family>Nimbus Sans L</family>
    <family>Nimbus Sans</family>
    <family>Helvetica</family>
    <family>Lucida Sans Unicode</family>
    <family>BPG Glaho International</family> <!-- lat,cyr,arab,geor -->
    <family>Tahoma</family> <!-- lat,cyr,greek,heb,arab,thai -->
   </prefer>
 </alias>
</fontconfig>
}}
```
### PipeWire & FMOD {#pipewire_fmod}

If you are using PipeWire and do not have any sound in games utilising FMOD as an audio backend then you may require
`{{Pkg|pipewire-alsa}}`{=mediawiki}. Such games include Project Zomboid, Don\'t Starve, and Unrailed.

You will see similar to the following in your logs if this affects you.

`[00:00:01]: FMOD Error: An invalid object handle was used.`\
`[00:00:10]: FMOD Error: Can't play event dontstarve/HUD/click_mouseover: An invalid object handle was used.`

### tcmalloc.cc error in Source 1 games {#tcmalloc.cc_error_in_source_1_games}

If games such as like Counter-Strike Source, Portal, Team Fortress 2 crash at startup with the following error:

`src/tcmalloc.cc:278] Attempt to free invalid pointer 0x9e13ad0`\
`~/.local/share/Steam/steamapps/common/Team Fortress 2/hl2.sh: line 72:  6280 Aborted                 (core dumped) ${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} "$@"`

Install `{{AUR|lib32-gperftools}}`{=mediawiki}, and point the crashing game to the proper library using:

`LD_PRELOAD=/usr/lib32/libtcmalloc_minimal.so`

From this [steam community post](https://steamcommunity.com/app/440/discussions/0/3815166265396512006/).

### Crash with Unity games {#crash_with_unity_games}

Games using Unity, e.g. Papers Please, Vampire Survivors, expect [PulseAudio](PulseAudio "wikilink") to be installed and
will quietly crash with SIGSEGV on running if it is not installed. You can also use [PipeWire](PipeWire "wikilink") with
`{{Pkg|pipewire-pulse}}`{=mediawiki}.

### Split lock detection / mitigation {#split_lock_detection_mitigation}

Split lock detection is a warning to aid developers, mitigation on the other hand is designed to hinder performance in
order to encourage developers to write better code. This results in significantly reduced performance under a myriad of
gaming scenarios[1](https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming), including Counter-Strike Source engine
games and games using BattleEye anti-cheat.

Since kernel 6.2, a new sysctl
tunable[2](https://lore.kernel.org/lkml/20221212191524.553244-1-dave.hansen@linux.intel.com/) of
`{{ic|1=split_lock_mitigate = 1}}`{=mediawiki} is available (by default) to enable mitigation, instead of the
older[3](https://www.phoronix.com/news/Linux-5.19-Split-Lock)`{{ic|1=split_lock_detect=on}}`{=mediawiki} [kernel
parameter](kernel_parameter "wikilink").

Upon setting:

`# echo "kernel.split_lock_mitigate = 0" > /etc/sysctl.d/99-splitlock.conf`

The kernel will log Steam / Cef lock splitting, but without the sequential access penalty.

```{=mediawiki}
{{Note|Disabling split lock mitigation may have negative impact on overall system performance. It is therefore suggested to use {{ic|sysctl}} to toggle the flag only when necessary.}}
```
Additionally, [GameMode](GameMode "wikilink") can be used to toggle this kernel parameter at runtime.

## Games

### 7 Days To Die {#days_to_die}

If the game crashes on start, add the following to Steam launch options:

`LD_PRELOAD="libpthread.so.0 libGL.so.1" __GL_THREADED_OPTIMIZATIONS=1 %command% -force-glcore`

If the game does not recognize your screen\'s resolution, launch the game with **Game Launcher** and check the **Unity
screen selector** option to correct the resolution. This will give you a GUI in which you can select the correct screen
when the game is started.

```{=mediawiki}
{{Note|The game tends to crash or disfunction in windowed mode. It may be advisable to run it in full screen mode.}}
```
If that does not help try running the game in **32-bit** mode by checking the respective option in the Game-engine in
the launcher options.

It will help the game performance if the **GLCore** option is checked in launcher options.

```{=mediawiki}
{{Note|The game does accept {{ic|.dll}} mods if installing mods. However, this requires an override for your Proton prefix. Use Protontricks to access {{ic|winecfg}} for the prefix 7 Days is using, go to libraries, and add ''winhttp'' as an override. This at least works for Harmony DLL mods.}}
```
### Age of Wonders 3 {#age_of_wonders_3}

If game fails to start at launch you will need to create a pthread_yield.so file. Do the following in a text editor:

`extern int sched_yield(void);`\
\
`int pthread_yield()`\
`{`\
`   return sched_yield();`\
`}`

Then save file as a pthread_yield.c then issue following command in terminal in the directory that has the file:

`$ gcc -m32 -shared -fPIC pthread_yield.c -o pthread_yield.so`

Copy pthread_yield.so in the AOW3 game directory and then edit the AoW3Launcher.sh file and add the following:

`export LD_PRELOAD="pthread_yield.so"`

Do this at the bottom of the file but before exec ./AoW3Launcher after this the game should then launch as normal.

### Alien Isolation {#alien_isolation}

#### Missing libpcre.so.3 and libidn.so.11 {#missing_libpcre.so.3_and_libidn.so.11}

`$ ln -s /usr/lib/libpcre.so `*`'GAME`*`/lib/x86_64/libpcre.so.3'`\
`$ ln -s /usr/lib/libidn.so `*`'GAME`*`/lib/x86_64/libidn.so.11'`

Append `{{ic|./lib/x86_64}}`{=mediawiki} to your
`{{ic|LD_LIBRARY_PATH}}`{=mediawiki}.[4](https://steamcommunity.com/app/214490/discussions/0/154644705028020291/)

#### Missing libcrypt.so.1 {#missing_libcrypt.so.1}

Install the package `{{Pkg|libxcrypt-compat}}`{=mediawiki}.
[5](https://github.com/FeralInteractive/ferallinuxscripts/issues/3)

### Amnesia: The Dark Descent {#amnesia_the_dark_descent}

Dependencies: [6](https://steamcommunity.com/app/221410/discussions/0/864957183198111387/)

-   ```{=mediawiki}
    {{AUR|lib32-freealut}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-glu}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libxmu}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-sdl_ttf}}
    ```

#### Gamepad not working {#gamepad_not_working}

The version of libSDL2 shipped with the game seems to be out-of-date and may not support your gamepad yet. Simply remove
or rename `{{ic|<install_dir>/game/lib64/libSDL2-2.0.so.0}}`{=mediawiki}, the linker will fall back to using the
up-to-date version from /usr/lib.

### Amnesia: Rebirth {#amnesia_rebirth}

```{=mediawiki}
{{Accuracy|There should be no reason for rebooting, but some services might have to be (re)started.}}
```
If you encounter a popup with `{{ic|Fatal Error: Fmod could not be initialized!!}}`{=mediawiki} on startup which
immediately closes the game and you are using [PipeWire](PipeWire "wikilink"), [install](install "wikilink") these
packages if they are not already: `{{Pkg|pulseaudio-alsa}}`{=mediawiki}, `{{Pkg|lib32-libpulse}}`{=mediawiki} and
`{{Pkg|lib32-alsa-plugins}}`{=mediawiki}. Reboot and re-open the game.

### And Yet It Moves {#and_yet_it_moves}

Dependencies:

-   ```{=mediawiki}
    {{AUR|lib32-libjpeg6-turbo}}
    ```

-   ```{=mediawiki}
    {{AUR|lib32-libpng12}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libtheora}}
    ```

-   ```{=mediawiki}
    {{AUR|lib32-libtiff4}}
    ```

#### Game does not start {#game_does_not_start}

When the game refuses to launch and prints one of the following error messages:

`readlink: extra operand ‘Yet’`\
`Try 'readlink --help' for more information.`

`This script must be run as a user with write priviledges to game directory.`

Open `{{ic|''GAME''/AndYetItMovesSteam.sh}}`{=mediawiki} and surround `{{ic|${BASH_SOURCE[0]} }}`{=mediawiki} in the
following line with double quotes.

`ayim_dir="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"`

### Anomaly Warzone Earth {#anomaly_warzone_earth}

#### Leave fullscreen {#leave_fullscreen}

There are no in-game settings for this, but fullscreen can be toggled with `{{ic|Alt+Enter}}`{=mediawiki}

#### Infinite loading {#infinite_loading}

Create file `{{ic|loadfix.c}}`{=mediawiki} next to the game executable:
[src](https://steamcommunity.com/app/282070/discussions/0/610573751159186268/?ctp=4#c530647080133257413)

`#define _GNU_SOURCE`\
`#include <dlfcn.h>`\
`#include <semaphore.h>`\
`#include <stdio.h>`\
`#include <time.h>`\
`#include <unistd.h>`\
`static int (*_realSemTimedWait)(sem_t *, const struct timespec *) = NULL;`\
\
`int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout)`\
`{`\
`    if (abs_timeout->tv_nsec >= 1000000000)`\
`    {`\
`        //fprintf(stderr, "to: %lu:%lu\n", abs_timeout->tv_sec, abs_timeout->tv_nsec);`\
`        ((struct timespec *)abs_timeout)->tv_nsec -= 1000000000;`\
`        ((struct timespec *)abs_timeout)->tv_sec++;`\
`    }`\
`    return _realSemTimedWait(sem, abs_timeout);`\
`}`\
\
`__attribute__((constructor)) void init(void)`\
`{`\
`    _realSemTimedWait = dlsym(RTLD_NEXT, "sem_timedwait");`\
`}`

Compile with `{{ic|gcc -m32 -o loadfix.so loadfix.c -ldl -shared -fPIC -Wall -Wextra}}`{=mediawiki}

Launch with `{{ic|1=LD_PRELOAD=$LD_PRELOAD:./loadfix.so %command%}}`{=mediawiki}

#### Gamepad not working {#gamepad_not_working_1}

You have to enable keyboard control and map gamepad to keys.

Config for Steam: `{{ic|steam://controllerconfig/91200/1498735506}}`{=mediawiki}

### Aquaria

#### Mouse pointer gets stuck in one direction {#mouse_pointer_gets_stuck_in_one_direction}

If the mouse pointer gets stuck in one direction, make sure `{{ic|''GAME''/usersettings.xml}}`{=mediawiki} contains
`{{ic|1=<JoystickEnabled on="0" />}}`{=mediawiki}.

If that does not fix the issue, try unplugging any joysticks or joystick adapter devices you have plugged in.

### ARK: Survival Evolved {#ark_survival_evolved}

#### Game does not start, displays text window with unreadable text {#game_does_not_start_displays_text_window_with_unreadable_text}

Run the game with `{{ic|1=MESA_GL_VERSION_OVERRIDE=4.0 MESA_GLSL_VERSION_OVERRIDE=400}}`{=mediawiki}.

#### Gray water {#gray_water}

Download the TheCenter map and copy `{{ic|Water_DepthBlur_MIC.uasset}}`{=mediawiki} from that map into TheIsland as
described
[here](https://www.gamingonlinux.com/articles/heres-a-way-to-fix-the-broken-water-in-ark-survival-evolved-on-linux.10530)`{{Dead link|2024|07|30|status=404}}`{=mediawiki}.

Ragnarok uses TheIsland\'s texture, so the same procedure fixes the issue on Ragnarok as well.

#### Segmentation fault on startup {#segmentation_fault_on_startup}

Caused by the games packaged libopenal. Use system libopenal to solve the segfault by running the game with with
`{{ic|1=LD_PRELOAD=/usr/lib/libopenal.so.1}}`{=mediawiki}

#### Crash on joining a game {#crash_on_joining_a_game}

Set steam to \'offline mode\' and try again

### Audiosurf 2 {#audiosurf_2}

#### error. unable to load song `<filename>`{=html} ,came back with zero duration {#error._unable_to_load_song_came_back_with_zero_duration}

If you get this in your log, install `{{Pkg|pulseaudio-alsa}}`{=mediawiki}.

### BADLAND: Game of the Year Edition {#badland_game_of_the_year_edition}

Refer to [#Missing libcurl.so.4 or version CURL_OPENSSL_3 not
found](#Missing_libcurl.so.4_or_version_CURL_OPENSSL_3_not_found "wikilink").

### Barony

#### Broken/Incorrect Textures {#brokenincorrect_textures}

Use the following launch options:

`LD_PRELOAD="$LD_PRELOAD ./libSDL2-2.0.so.0 ./libSDL2_ttf-2.0.so.0 ./libSDL2_image-2.0.so.0" %command%`

The issue is caused by a newer version of SDL than what the game bundles, this workaround simply has the game use the
bundled libraries instead, as described [here](https://github.com/TurningWheel/Barony/issues/568).

### BATTLETECH

#### Game freezes after opening studio credits (opening cinematic does not play) {#game_freezes_after_opening_studio_credits_opening_cinematic_does_not_play}

Try installing `{{Pkg|libbsd}}`{=mediawiki} (as suggested in the [Paradox
forums](https://forum.paradoxplaza.com/forum/threads/battletech-black-screen-after-initial-credit-logos-linux.1312273/post-26187776)).

#### Game does not start {#game_does_not_start_1}

Try deleting `{{ic|''BATTLETECH''/BattleTech_Data/plugins/x86_64/libc.so.6}}`{=mediawiki}, this should make the game run
again.

### Beat Cop {#beat_cop}

#### \"BeatCop.x86_64\" is not responding {#beatcop.x86_64_is_not_responding}

Run `{{ic|BeatCop.x86}}`{=mediawiki} instead of `{{ic|BeatCop.x86_64}}`{=mediawiki}.

### Binding of Isaac: Rebirth {#binding_of_isaac_rebirth}

#### No sound {#no_sound}

```{=mediawiki}
{{Note|This also helps with Never Alone (Kisima Ingitchuna) and No Time to Explain.}}
```
Prepend `{{ic|/usr/lib}}`{=mediawiki} to `{{ic|LD_LIBRARY_PATH}}`{=mediawiki}.

Adjust the audio levels in the game options.

### BioShock Infinite {#bioshock_infinite}

#### Game launching on wrong monitor in fullscreen mode {#game_launching_on_wrong_monitor_in_fullscreen_mode}

Add the following launch option:

`--eon_force_display=1`

Various more fixes and tweaks can be found [here](https://pcgamingwiki.com/wiki/BioShock_Infinite)

#### Audio crackling {#audio_crackling}

Change the launch options to

`PULSE_LATENCY_MSEC=60 %command%`

Discussion on the variable can be found in [Proton issue #1209](https://github.com/ValveSoftware/Proton/issues/1209).
Lower values maintain lower audio latency but crackling may still occur; higher values are more likely to eliminate
crackling but allow for higher audio latency.

### BLACKHOLE

Refer to [#Missing libcurl.so.4 or version CURL_OPENSSL_3 not
found](#Missing_libcurl.so.4_or_version_CURL_OPENSSL_3_not_found "wikilink").

### Black Mesa {#black_mesa}

If the game have crashing on start, install `{{AUR|lib32-gperftools}}`{=mediawiki} for 32bit version of
`{{ic|libtcmalloc_minimal.so.4}}`{=mediawiki} which is needed
[Source](https://steamcommunity.com/app/362890/discussions/1/340412628175324858/?ctp=7).

Also add this to the game\'s launch command line in Steam\'s preferences:

`%command% -oldgameui`

### Block\'hood

#### White screen on startup {#white_screen_on_startup}

When launched the game may only display a white screen with no interface and no way to play the game. Add
\"-screen-fullscreen 0\" to launch options.

### The Book of Unwritten Tales {#the_book_of_unwritten_tales}

Dependencies:

-   ```{=mediawiki}
    {{AUR|lib32-jasper}}
    ```

-   ```{=mediawiki}
    {{AUR|lib32-libxaw}}
    ```
    ```{=mediawiki}
    {{Broken package link|package not found}}
    ```

If the game does not start, uncheck: *Properties \> Enable Steam Community In-Game*.

The game is known to segfault when opening the settings and possibly during or before playing. A workaround from the
[Steam discussions](https://steamcommunity.com/app/221410/discussions/3/846939071081758230/#p2) is to replace the
game\'s `{{ic|RenderSystem_GL.so}}`{=mediawiki} with one from Debian\'s repositories. To do that download [this deb
file](https://launchpad.net/ubuntu/+archive/primary/+files/libogre-1.7.4_1.7.4-3_i386.deb), and extract it with
`{{Pkg|dpkg}}`{=mediawiki}:

`$ dpkg -x libogre-*.deb outdir`

Now replace `{{ic|''GAME''/lib/32/RenderSystem_GL.so}}`{=mediawiki} with the one extracted from the
`{{ic|.deb}}`{=mediawiki} package.

### BRAIN/OUT

If the game does not start with error message saying \"invalid app configuration\". Go to the game directory:

`$ cd ~/.steam/steam/steamapps/common/BrainOut/`

Run the game directly:

`$ java -jar brainout-steam.jar`

You need to have steam running in the background.

### The Book of Unwritten Tales: The Critter Chronicles {#the_book_of_unwritten_tales_the_critter_chronicles}

See [#The Book of Unwritten Tales](#The_Book_of_Unwritten_Tales "wikilink").

To prevent the game from crashing at the end credits, change the size of the credits image as described
[here](https://steamcommunity.com/app/221830/discussions/0/828925849276110960/#c810921273836530791).

### Borderlands 2 {#borderlands_2}

```{=mediawiki}
{{Warning|The Linux native version of Borderlands 2 does not have working Steam multiplayer, cannot use Steam Cloud saves made on the Windows version, does not support the ''Commander Lilith & the Fight for Sanctuary'' DLC, and has several other issues. Most players report via [https://www.protondb.com/app/49520 ProtonDB], that Proton overall works best.}}
```
#### Proton troubleshooting {#proton_troubleshooting}

##### Game crashes instantly on launch {#game_crashes_instantly_on_launch}

Borderlands 2 is a 32-bit DirectX 9 based game, therefore it is possible on 64-bit installs to be missing 32-bit Vulkan
drivers. Installing the [steam-native-runtime](https://archlinux.org/packages/?name=steam-native-runtime) or
specifically the appropriate multilib drivers
([lib32-nvidia-utils](https://archlinux.org/packages/?name=lib32-nvidia-utils) or
[lib32-vulkan-radeon](https://archlinux.org/packages/?name=lib32-vulkan-radeon) for NVIDIA and AMD Radeon respectively)
may resolve the issue.

#### Linux Native troubleshooting {#linux_native_troubleshooting}

##### Migrating saves from other platforms {#migrating_saves_from_other_platforms}

Borderlands 2 does not support cross-platform Steam Cloud syncing, you have to manually copy the files between
platforms. Save locations can be found [here](https://pcgamingwiki.com/wiki/Borderlands_2#Game_data). Make sure your
user can access the files.

##### Using Ctrl Key {#using_ctrl_key}

Borderlands 2 does not allow the `{{ic|Ctrl}}`{=mediawiki} key to be used by default. The game seems to be accessing
keycodes and not keysyms, therefore xmodmap has no affect. A workaround is using *setkeycodes* to map the Ctrl-scancode
to some other key, as described in [Map scancodes to keycodes#Using
setkeycodes](Map_scancodes_to_keycodes#Using_setkeycodes "wikilink"). I use `{{ic|setkeycodes 0x1d 56}}`{=mediawiki} (as
root) to map Ctrl to Alt before starting the game and `{{ic|setkeycodes 0x1d 29}}`{=mediawiki} to restore the default.

##### Logging into SHiFT {#logging_into_shift}

Out of the box you will not be able to log into SHiFT since the game expects certificates to be in
`{{ic|/usr/lib/ssl}}`{=mediawiki}, which is where Ubuntu stores them. Arch however uses `{{ic|/etc/ssl}}`{=mediawiki}.
To resolve the problem, run the game with `{{ic|1=SSL_CERT_DIR=/etc/ssl/certs}}`{=mediawiki}.

##### Game crashes nearly instantly {#game_crashes_nearly_instantly}

The game crashes in libopenal directly after launch.

Possible solution 0: Run the game with the `{{ic|-nostartupmovies}}`{=mediawiki} flag. It no longer crashes in libopenal
with a general protection error.

Possible solution 1: As of lib32-openal version 1.18.0-1, the game crashes instantly. The possible solutions are to
downgrade lib32-openal to 1.17.2-1, or to start the game with
`{{ic|LD_PRELOAD<nowiki>=</nowiki>'$HOME/.steam/root/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libopenal.so.1'}}`{=mediawiki}.

In case there are messages like this in the terminal:

`[  671.617205] Borderlands2[2772]: segfault at 0 ip           (null) sp 00000000ff9a462c error 14 in Borderlands2[8048000+235a000]`

The following change may help ([source](https://steamcommunity.com/app/49520/discussions/0/348292787746982160/)):

`LD_PRELOAD='./libcxxrt.so:/usr/$LIB/libstdc++.so.6' %command%`

Possible solution 2: Launch steam as `{{ic|steam-native}}`{=mediawiki} as described in [#Steam native
runtime](Steam/Troubleshooting#Steam_native_runtime "wikilink"). If the game still fails to launch even after installing
the `{{AUR|steam-native-runtime}}`{=mediawiki} meta package, then you might be missing some libraries. You can find
those missing libraries as described in [#Debugging shared
libraries](Steam/Troubleshooting#Debugging_shared_libraries "wikilink").

### Borderlands: The Pre-Sequel {#borderlands_the_pre_sequel}

See [#Borderlands 2](#Borderlands_2 "wikilink").

#### Keyboard not working {#keyboard_not_working}

This can occur with certain window managers e.g. [dwm](dwm "wikilink"). Try a different [window
manager](window_manager "wikilink"), or install `{{Pkg|wmname}}`{=mediawiki} and run:

`$ wmname LG3D`

see [Java#Impersonate another window manager](Java#Impersonate_another_window_manager "wikilink") for more information.

#### Not starting via Steam {#not_starting_via_steam}

If the game appears as *Running*, then syncs and closes when you launch it from Steam, try creating a
`{{ic|steam_appid.txt}}`{=mediawiki} in the game directory containing `{{ic|261640}}`{=mediawiki}. This should resolve
the issue and let you start the game directly from the game directory. If that does not work, try using the
`{{AUR|steam-native-runtime}}`{=mediawiki}.

### Celeste

#### Steam overlay is missing text {#steam_overlay_is_missing_text}

Add the following [launch option](launch_option "wikilink") (as documented [in this
issue](https://github.com/ValveSoftware/steam-for-linux/issues/7889#issuecomment-917554177)):

`-gldevice:Vulkan`

### Chaos Engine {#chaos_engine}

Set your [launch options](launch_option "wikilink") to:

`LD_PRELOAD="/usr/lib32/libpng16.so.16" %command%`

If such error is seen in terminal output of steam-native:

`/home/`*`username`*`/.local/share/Steam/steamapps/common/Chaos engine/TheChaosEngineSteam: /home/`*`username`*`` /.local/share/Steam/steamapps/common/Chaos engine/lib/libz.so.1: version `ZLIB_1.2.9' not found (required by /usr/lib32/libpng16.so.16) ``\
`/home/`*`username`*`/.local/share/Steam/steamapps/common/Chaos engine/TheChaosEngineSteam: /home/`*`username`*`` /.local/share/Steam/steamapps/common/Chaos engine/lib/libz.so.1: version `ZLIB_1.2.3.4' not found (required by /usr/lib32/libpng16.so.16) ``

Then link the system libz.so:

`$ cd ~/.local/share/Steam/steamapps/common/Chaos\ engine/lib`\
`$ mv libz.so.1 libz.so.1.old`\
`$ ln -s /lib/libz.so.1`

### Cities in Motion 2 {#cities_in_motion_2}

#### Dialog boxes fail to display properly {#dialog_boxes_fail_to_display_properly}

You will not be able to read or see anything, and you will have this in your logs:

`Fontconfig error: "/etc/fonts/conf.d/10-scale-bitmap-fonts.conf", line 69: non-double matrix element`\
`Fontconfig error: "/etc/fonts/conf.d/10-scale-bitmap-fonts.conf", line 69: wrong number of matrix elements`

Workaround for the bug `{{Bug|35039}}`{=mediawiki} is available [here](https://archive.is/L9AoT) (replace
`{{ic|/etc/fonts/conf.d/10-scale-bitmap-fonts.conf}}`{=mediawiki}).

### Cities Skylines {#cities_skylines}

#### Game not starting {#game_not_starting}

If you set ELECTRON_OZONE_PLATFORM_HINT=auto [environment variables](environment_variables "wikilink") globaly, because
you want to switch all your [Electron](Electron "wikilink") apps use [Wayland](Wayland "wikilink") natively, you should
know that the game launcher of Cities Skylines currently is [Electron](Electron "wikilink")-based and compiled as
[x11](x11 "wikilink")-only, without [Wayland](Wayland "wikilink") support. So it will crashed when you try to start it.
As workaround you should set ELECTRON_OZONE_PLATFORM_HINT=x11 %command% to the [Steam](Steam "wikilink")\'s command line
for this game. So the game will work using [Xwayland](Xwayland "wikilink").

If you set `{{ic|$XDG_DATA_HOME}}`{=mediawiki} to something other than `{{ic|$HOME/.local/share}}`{=mediawiki}, Cities
Skylines will put some files in `{{ic|$XDG_DATA_HOME/Paradox Interactive}}`{=mediawiki} and some hard-coded in
`{{ic|~/.local/share/Paradox Interactive}}`{=mediawiki}. Unset the Variable to fix this issue.

#### Textures not rendering properly {#textures_not_rendering_properly}

Run the game with `{{ic|1=UNITY_DISABLE_GRAPHICS_DRIVER_WORKAROUNDS=yes}}`{=mediawiki}.

#### Game crashes in loading screen when Node Controller or Intersection Marking tool are enabled in Content Manager {#game_crashes_in_loading_screen_when_node_controller_or_intersection_marking_tool_are_enabled_in_content_manager}

If the game crashes with one or both of the above mods enabled when loading a save or starting a new game but works fine
with both mods disabled, install `{{Pkg|mono}}`{=mediawiki}.

### Civilization V {#civilization_v}

Run the game with
`{{ic|1=LD_PRELOAD=/usr/lib32/libopenal.so.1 %command% }}`{=mediawiki}.[7](https://steamcommunity.com/app/8930/discussions/0/1621726179576099775/)
If `{{ic|libopenal.so.1}}`{=mediawiki} is not in `{{ic|/usr/lib32}}`{=mediawiki}, you may need to install
`{{Pkg|lib32-openal}}`{=mediawiki} after making sure [multilib](multilib "wikilink") is enabled.

For old versions of PulseAudio (\<12.0), use
`{{ic|1=LD_PRELOAD='./libcxxrt.so:/usr/$LIB/libstdc++.so.6:/usr/lib32/libopenal.so.1' %command% }}`{=mediawiki}.[8](https://github.com/ValveSoftware/steam-for-linux/issues/4379)

If you are experiencing heavy lag (less than 1fps) or the game crashes on startup, try adding the following paths to
LD_PRELOAD:
`{{ic|1='/usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1 /usr/$LIB/libgpg-error.so ./libcxxrt.so /usr/lib32/libstdc++.so.6 /usr/lib32/libopenal.so.1'}}`{=mediawiki}.[9](https://forum.manjaro.org/t/civ-v-wont-launch-after-update/10825/6)`{{Dead link|2021|05|17|status=404}}`{=mediawiki}

#### Stuttering sound with PulseAudio {#stuttering_sound_with_pulseaudio}

See [PulseAudio/Troubleshooting#Laggy sound](PulseAudio/Troubleshooting#Laggy_sound "wikilink").

#### Segfault with high core count CPU {#segfault_with_high_core_count_cpu}

The Linux port of Civ V experiences a bug which induces segfaults when running on a CPU with \>8 logical cores. This
includes many common CPUs, especially Ryzen 7 and i7 series parts. To diagnose this problem, check the output of dmesg:

`# journalctl -k | grep -E "Civ5XP.*segfault"`

One solution is to run `{{ic|1=taskset -c 0-7 steam steam://rungameid/8930}}`{=mediawiki}, which limits the number of
cores that the game can access[10](https://steamcommunity.com/app/8930/discussions/0/1693788384127278334/). It is
convenient to run this in the launch options:

`LD_PRELOAD=/usr/lib32/libopenal.so.1 taskset -c 0-7 %command%`

Another solution is to set `{{ic|MaxSimultaneousThreads}}`{=mediawiki} to `{{ic|16}}`{=mediawiki} in
`{{ic|config.ini}}`{=mediawiki}, which is stored in the game
directory.[11](https://www.reddit.com/r/civ5/comments/5z77jr/game_crashes_randomly_on_linux_amd_ryzen/)

#### Game crashes after intro video with \"Unable to load texture (LoadingBaseGame.dds)\" / configuration reset at startup {#game_crashes_after_intro_video_with_unable_to_load_texture_loadingbasegame.dds_configuration_reset_at_startup}

The issue is a result of the game calling some file in a case-insensitive manner.

The solution is either to install the game on a case-insensitive file system like VFAT, or on a mount point for
`{{AUR|ciopfs}}`{=mediawiki}.

It is not enough the game is in a case-insensitive filesystem, but also the configuration/data directory at
\"\~/.local/share/Aspyr/Sid Meier\'s Civilization 5\" needs to be in a case-insensitive filesystem or mount point. If
the data directory is in a case-sensitive filesystem, the game will not work correctly and symptoms such as
configuration getting constantly reset can be observed.

#### Steam Overlay not working {#steam_overlay_not_working}

An invisible Steam Overlay can be fixed by preloading the overlay renderer in the launch options:

`LD_PRELOAD='/home/`*`username`*`/.local/share/Steam/ubuntu12_32/gameoverlayrenderer.so' %command%`

#### Crashes during \_\_memcpy_ssse3 {#crashes_during___memcpy_ssse3}

This appears to be a memory alignment bug that can be corrected by compiling the libraries with
`{{ic|1=-mstackrealign}}`{=mediawiki}. GDB can also be used to run it as-is with the following launch options:

`LD_PRELOAD=/usr/lib/libcurl.so.4 /bin/gdb -windows -batch -return-child-result -nx -eval-command="run" -exec=%command%`

### Civilization: Beyond earth {#civilization_beyond_earth}

If you are getting an instant crash/close upon launch, make sure you have the following packages installed:

-   ```{=mediawiki}
    {{Pkg|lib32-libcurl-compat}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libcurl-gnutls}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-openal}}
    ```

You also need an older version of lib32-tbb which provides libtbb.so.2. To get this:

1.  Download the [libtbb2
    deb-package](https://archive.ubuntu.com/ubuntu/pool/universe/t/tbb/libtbb2_4.2~20130725-1.1ubuntu1_i386.deb) from
    the Ubuntu archive.
2.  Unpack `{{ic|libtbb.so.2}}`{=mediawiki} from
    `{{ic|libtbb2_4.2_20130725-1.1ubuntu1_i386.deb/data.tar.xz/usr/lib}}`{=mediawiki} into the game directory.

Note that if you have a globally installed 32-bit libtbb.so.2, you will need to run the game with:

1.  Run the game with `{{ic|1=LD_PRELOAD='./libtbb.so.2'}}`{=mediawiki}.

To force it to use this version. This version also resolves crashes with the following backtrace:

`   #0  0x08b71d06 in FireGrafix::DynamicsLock``<Graphics::BuildingSkinnedDataDynamicConsts>`{=html}`::DynamicsLock(Graphics::SurfaceSet**, FireGrafix::SurfaceSetPoolAllocator*, unsigned short) ()`\
`   #1  0x08c25ffc in cvLandmarkVisSystem::cvLandmarkVisDynamicConstantUpdaterSS::HandleBuildingShaderSkinned(Graphics::FGXShaderPackageInstanceView*, FireGrafix::FGXModelNode*, FGXVector4*) ()`\
`   #2  0x08c25f34 in cvLandmarkVisSystem::cvLandmarkVisDynamicConstantUpdaterSS::UpdateNode(Graphics::FGXShaderPackageInstanceView*, FireGrafix::FGXModelNode*, FGXVector4*) ()`\
`   #3  0x08c25e2c in FireGrafix::FGXModelRenderByNodeSSExample_Shadow<cvLandmarkVisSystem::cvLandmarkVisDynamicConstantUpdaterSS, 2, FireGrafix::FGXModelRenderEndSuperclass>::RenderNode(unsigned int*, FireGrafix::FGX_SPIV_GENERIC*, FireGrafix::FGXModelNode*, FGXVector4*) ()`\
`   #4  0x08c24ff5 in cvLandmarkVisSystem::LandmarkRenderJob::Execute(unsigned int) ()`\
`   #5  0x093d26d9 in `[`Platform::JobTask`](Platform::JobTask)`::execute() ()`\
`   #6  0xf749f3c0 in ?? () from /usr/lib32/libtbb.so.2`\
`   #7  0xf7497551 in ?? () from /usr/lib32/libtbb.so.2`\
`   #8  0xf7495fc3 in ?? () from /usr/lib32/libtbb.so.2`\
`   #9  0xf7491b7e in ?? () from /usr/lib32/libtbb.so.2`\
`   #10 0xf7491db7 in ?? () from /usr/lib32/libtbb.so.2`\
`   #11 0xf78f4346 in start_thread () from /usr/lib32/libpthread.so.0`\
`   #12 0xf7716026 in clone () from /usr/lib32/libc.so.6`

### Civilization VI {#civilization_vi}

Although there is a native [#Civilization VI Linux version](#Civilization_VI_Linux_version "wikilink"), many users
report better performance with the [#Civilization VI Windows version](#Civilization_VI_Windows_version "wikilink").

#### Civilization VI Linux version {#civilization_vi_linux_version}

Either run with steam-native, launch option
`{{ic|1=LD_PRELOAD='/usr/lib/libfreetype.so.6:/usr/lib/libbrotlicommon.so.1:/usr/lib/libbrotlidec.so.1' %command%}}`{=mediawiki},
and go to *Properties \> Compatibility*, check \"Force the use of a specific Steam Play compatiblity tool\" and select
\"Steam Linux runtime\".

If you are using [Wayland](Wayland "wikilink"), you might need to also set `{{ic|1=QT_QPA_PLATFORM=xcb}}`{=mediawiki},
as the game\'s launcher uses a version of Qt which only supports Xorg (see [Wayland#Qt](Wayland#Qt "wikilink")), another
way is to replace the bundled Qt with one provided by Arch Linux
[12](https://www.patreon.com/posts/running-civ6-53028614). Some versions of the game also seem to require adding
`{{ic|1=SDL_VIDEODRIVER=x11}}`{=mediawiki} and will otherwise refuse to start with an error message that reads \"An
unrecoverable error has occurred, and Civilization VI cannot continue.\"

```{=mediawiki}
{{Out of date|The OpenSSL 1.0 package has been dropped, is this game still affected?}}
```
Follow [#OpenSSL 1.0 setup](#OpenSSL_1.0_setup "wikilink").

Ensure that Steam Workshop mods are disabled as certain ones may cause issues following loading.

##### Steam Overlay not working {#steam_overlay_not_working_1}

Since the introduction of the new launcher, the steam overlay does not work in this game. To get it working again,
simlpy skip the launcher as described in [#Launcher unable to load page](#Launcher_unable_to_load_page "wikilink").

##### If Segfault Immediately on Start {#if_segfault_immediately_on_start}

This is a strange corner case which happens infrequently at best (and the prerequisites for reproducing it are unknown),
but the crash would look like this:

1.  Immediate segfault on start, before any windows get created
2.  The game creates `{{ic|~/.local/share/aspyr-media/Sid Meier's Civilization VI/AppOptions.txt}}`{=mediawiki}
3.  The string `{{ic|AppHost::BugSubmissionPackager::BugSubmissionPackager}}`{=mediawiki} appears in the backtrace
    output when running the game under `{{Pkg|gdb}}`{=mediawiki}
    1.  To run under `{{Pkg|gdb}}`{=mediawiki}, first launch a shell and change into the game directory.
    2.  Then `{{ic|echo 289070 > steam_appid.txt}}`{=mediawiki} *(otherwise the game will not launch outside of Steam
        itself)*
    3.  Then run something like `{{ic|gdb -ex run -ex bt -ex quit --args ./Civ6 ./Civ6}}`{=mediawiki}
    4.  The relevant info towards the end of the output should look like this:

`   Thread 3 "Civ6" received signal SIGSEGV, Segmentation fault.`\
`   [Switching to Thread 0x7fffe5d06700 (LWP 12315)]`\
`   0x000000000201121e in AppHost::BugSubmissionPackager::BugSubmissionPackager(unsigned long, String::BasicT<`[`Platform::StaticHeapAllocator`](Platform::StaticHeapAllocator)`<5, 0>, (String::Encoding)4> const&, String::BasicT<`[`Platform::StaticHeapAllocator`](Platform::StaticHeapAllocator)`<5, 0>, (String::Encoding)0> const&, AppHost::ModuleVersionInfo const&) ()`\
`   #0  0x000000000201121e in AppHost::BugSubmissionPackager::BugSubmissionPackager(unsigned long, String::BasicT<`[`Platform::StaticHeapAllocator`](Platform::StaticHeapAllocator)`<5, 0>, (String::Encoding)4> const&, String::BasicT<`[`Platform::StaticHeapAllocator`](Platform::StaticHeapAllocator)`<5, 0>, (String::Encoding)0> const&, AppHost::ModuleVersionInfo const&) ()`\
`   #1  0x000000000200c796 in AppHost::_INTERNAL::SetupFXSPlatform(AppHost::AppEnvironment const*, AppHost::AppOptions*)`\
`       ()`\
`   #2  0x000000000200fea0 in AppHost::RunApp(int, char**, AppHost::Application*) ()`\
`   #3  0x000000000200f9bc in AppHost::RunApp(char*, AppHost::Application*) ()`\
`   #4  0x0000000001112d98 in WinMain ()`\
`   #5  0x00000000010bdab0 in ?? ()`\
`   #6  0x00000000010bfb31 in ThreadHANDLE::ThreadProc(void*) ()`\
`   #7  0x00007ffff473e08a in start_thread () from /usr/lib/libpthread.so.0`\
`   #8  0x00007ffff38f747f in clone () from /usr/lib/libc.so.6`

If all of that is the case for you, the fix is pretty simple. Edit
`{{ic|~/.local/share/aspyr-media/Sid Meier's Civilization VI/AppOptions.txt}}`{=mediawiki} and change the line reading
`{{ic|EnableBugCollection 1}}`{=mediawiki} to `{{ic|EnableBugCollection 0}}`{=mediawiki}.

Presumably this fix will prevent any automated bug reports from reaching Aspyr, should you encounter crashes/bugs in the
future, but it will at least let the game launch properly.

##### If Crash with Error \"undefined symbol FT_Done_MM_Var\" {#if_crash_with_error_undefined_symbol_ft_done_mm_var}

If the game crashed with:

`./GameGuide/Civ6: symbol lookup error: /usr/lib/libfontconfig.so.1: undefined symbol: FT_Done_MM_Var`

The solution is to set launch options to:

`LD_PRELOAD=/usr/lib/libfreetype.so.6 %command%`

##### If the game ends up being a grey-color blank screen {#if_the_game_ends_up_being_a_grey_color_blank_screen}

The solution is to disable mods.

##### If the computer becomes irresponsive after \"Loading\" screen {#if_the_computer_becomes_irresponsive_after_loading_screen}

This may be caused by amdgpu driver crash due to insuffcient video memory. If running an integrated graphics (eg. AMD
Renoir), try allocating more memory in your BIOS.

##### Multi-monitor and wayland: mismatched resolution {#multi_monitor_and_wayland_mismatched_resolution}

Wayland does not define a primary monitor, so the game will show the available resolutions of an arbitrary monitor; it
may not have the same size and the mouse may be off. A solution is to set an Xwayland monitor as primary.

To find the list of Xwayland monitors: `{{ic|xrandr --listmonitors}}`{=mediawiki}

To set (eg) the XWAYLAND4 monitor as the primary: `{{ic|xrandr --output XWAYLAND4 --primary}}`{=mediawiki}

##### Launcher window is huge (wrong scaling) {#launcher_window_is_huge_wrong_scaling}

If the launcher window is huge (sometimes bigger than the screen), then the scaling is wrong. Add
`{{ic|1=QT_AUTO_SCREEN_SCALE_FACTOR=0}}`{=mediawiki} to the launch options and on next start the launcher should be
usable.

##### Launcher unable to load page {#launcher_unable_to_load_page}

The launcher often shows errors like `{{ic|1=Error loading page}}`{=mediawiki}. It is possible to bypass the launcher by
editing the games startup configuration
`{{ic|~/.local/share/Steam/steamapps/common/Sid Meier's Civilization VI/Civ6}}`{=mediawiki} and changing the line
`{{ic|1=./GameGuide/Civ6}}`{=mediawiki} to `{{ic|1=./Civ6Sub}}`{=mediawiki}.

#### Civilization VI Windows version {#civilization_vi_windows_version}

To play the Windows version of Civ VI, first you must [force Proton usage](Steam#Force_Proton_usage "wikilink"). Then,
you need to bypass the launcher which is buggy through proton. To skip the launcher, right click on the game, click
*Properties*, and set the following *Launch options*:

`eval $( echo "%command%" | sed "s/2KLauncher\/LauncherPatcher.exe'.*/Base\/Binaries\/Win64Steam\/CivilizationVI.exe'/" )`

### The Clockwork Man {#the_clockwork_man}

Requires `{{Pkg|lib32-libidn}}`{=mediawiki} (pulled in by `{{AUR|steam-native-runtime}}`{=mediawiki}).

### Company of Heroes 2 {#company_of_heroes_2}

Make sure you have `{{AUR|lib32-gconf}}`{=mediawiki}`{{Broken package link|package not found}}`{=mediawiki} installed.

#### Missing libpcre.so.3 and libidn.so.11 {#missing_libpcre.so.3_and_libidn.so.11_1}

Like with [#Alien Isolation](#Alien_Isolation "wikilink") you need to symlink `{{ic|/usr/lib/libpcre.so}}`{=mediawiki}
to `{{ic|''GAME''/lib/''arch''/libpcre.so.3}}`{=mediawiki}, as well as `{{ic|/usr/lib/libidn.so}}`{=mediawiki} to
`{{ic|''GAME''/lib/''arch''/libidn.so.11}}`{=mediawiki}, otherwise the game will fail to start.

### Cossacks 3 {#cossacks_3}

#### No sound {#no_sound_1}

Use the steam-runtime, e.g. set the [launch options](https://support.steampowered.com/kb_article.php?ref=1040-JWMT-2947)
to:

`~/.steam/root/ubuntu12_32/steam-runtime/run.sh %command%`

#### Flashing screen with primus {#flashing_screen_with_primus}

Set `{{ic|1=PRIMUS_SYNC=2}}`{=mediawiki}in the launch options.

### Counter-Strike: Source (CS:S) {#counter_strike_source_css}

#### Invisible symbols, special characters and cyrillic letters {#invisible_symbols_special_characters_and_cyrillic_letters}

Check [#Squares or invisible symbols, special characters and cyrillic letters in Source-based
games](#Squares_or_invisible_symbols,_special_characters_and_cyrillic_letters_in_Source-based_games "wikilink")

### Counter-Strike: Global Offensive (CS:GO) {#counter_strike_global_offensive_csgo}

#### Game cannot launch and crash with black screen {#game_cannot_launch_and_crash_with_black_screen}

[CSGO not running on my Arch](https://bbs.archlinux.org/viewtopic.php?pid=2035227#p2035227)

This problem was found after the kernel update to 5.17: the game does not start properly.

A possible workaround is to change
`{{ic|~/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/panorama/videos}}`{=mediawiki}, rename
it to `{{ic|videos.bak}}`{=mediawiki}, then add `{{ic|-novid}}`{=mediawiki} to the startup parameters. The game will
lose the background of the main game interface, but can run normally.

#### Game starts on the wrong screen {#game_starts_on_the_wrong_screen}

[csgo-osx-linux issue #60](https://github.com/ValveSoftware/csgo-osx-linux/issues/60)

If it happens, go into fullscreen windowed or windowed mode and drag the window to the correct monitor. Then go back
into fullscreen, the game should now be on the correct monitor.

#### Cannot reach bottom of the screen on menus {#cannot_reach_bottom_of_the_screen_on_menus}

[csgo-osx-linux issue #594](https://github.com/ValveSoftware/csgo-osx-linux/issues/594)

If you have a secondary monitor you might have a part of your lower screen you cannot reach in menus. If on GNOME you
can try to open the overview (Super key) and drag the game to the other monitor and back.

If you are not on GNOME or dragging the window back and forth did not work you can try to [install](install "wikilink")
`{{Pkg|wmctrl}}`{=mediawiki} and run this command, where X and Y is the offset of the window and H and W is the size.

`$ wmctrl -r "Counter-Strike: Global Offensive - OpenGL" -e 0,`*`X`*`,`*`Y`*`,`*`W`*`,`*`H`*

**Example**: SecondaryMonitor: on the left 2560x1600, GamingMonitor: on the right 2560x1440).

`$ wmctrl -r "Counter-Strike: Global Offensive - OpenGL" -e 0,2560,0,1600,1200`

Here X and Y are 2560,0 to move the window to the monitor on the right and W and H are 1600,1200 is set to match the
in-game resolution.

#### Sound is played slightly delayed {#sound_is_played_slightly_delayed}

[csgo-osx-linux issue #45](https://github.com/ValveSoftware/csgo-osx-linux/issues/45)

See [PulseAudio/Troubleshooting#Laggy sound](PulseAudio/Troubleshooting#Laggy_sound "wikilink") for a possible solution.

#### Mouse not working in-game {#mouse_not_working_in_game}

If your mouse works in the main menu but not in-game, run the game with `{{ic|1=SDL_VIDEO_X11_DGAMOUSE=0}}`{=mediawiki}.
[13](https://bbs.archlinux.org/viewtopic.php?id=184905) If it still does not work, turn off \"Raw Input\" in the in-game
settings.

#### Brightness slider not working {#brightness_slider_not_working}

[Install](Install "wikilink") `{{Pkg|xorg-xrandr}}`{=mediawiki} and run `{{ic|xrandr}}`{=mediawiki} to find out the name
of your connected display output.

Edit `{{ic|''GAME''/csgo.sh}}`{=mediawiki} and add the following lines (adapt *output_name*):

**`# gamma correction`**\
**`xrandr --output `*`output_name`*` --gamma 1.6:1.6:1.6 # play with values if required`**\
`STATUS=42`\
`while [$STATUS -eq 42]; do`\
` ...`\
`done`\
**`# restore gamma`**\
**`xrandr --output `*`output_name`*` --gamma 1:1:1`**\
`exit $STATUS`

#### Microphone not working {#microphone_not_working}

[csgo-osx-linux issue #573](https://github.com/ValveSoftware/csgo-osx-linux/issues/573#issuecomment-174016722)

CS:GO uses the default PulseAudio sound device ignoring what is configured in Steam settings.

First find out the source name of your microphone (it should start with `{{ic|alsa_input.}}`{=mediawiki}):

`$ pacmd list-sources`

Then set the default device (change the name accordingly):

`$ pacmd set-default-source `*`device_name`*

Also lower the microphone level to 60% otherwise you will get some nasty background noise and you will be difficult to
understand (change the name accordingly):

`$ pacmd set-source-volume `*`device_name`*` 0x6000`

#### Mouse is unrensponsive or moves slowly {#mouse_is_unrensponsive_or_moves_slowly}

Set launch options to:

`vblank_mode=0 %command%`

Works with almost any other game.

#### Game crashes on startup with game controller plugged in {#game_crashes_on_startup_with_game_controller_plugged_in}

-   The solution is to add `{{ic|-nojoy}}`{=mediawiki} to the launch options: [csgo-osx-linux issue
    #1757](https://github.com/ValveSoftware/csgo-osx-linux/issues/1757)

```{=html}
<!-- -->
```
-   Another solution: delete startup video: [csgo-osx-linux issue
    #2659](https://github.com/ValveSoftware/csgo-osx-linux/issues/2659#issuecomment-934357559)

#### Some texts are missing or mis-positioned {#some_texts_are_missing_or_mis_positioned}

[Generate](Locale#Generating_locales "wikilink") the `{{ic|en_US.UTF-8}}`{=mediawiki} locale will solve the problem.

#### Stuck on map loading \"Initializing World\"/\"Loading Resources\" with AMD Radeon RX 6000 series {#stuck_on_map_loading_initializing_worldloading_resources_with_amd_radeon_rx_6000_series}

[csgo-osx-linux issue #2801](https://github.com/ValveSoftware/csgo-osx-linux/issues/2801)

When using the amdgpu driver, some users
[14](https://community.amd.com/t5/graphics/amd-csgo-loading-bug-on-current-graphics-hardware-drivers/m-p/474323)
experience a problem with map loading taking longer than one minute and being stuck on \"Initializing World\" or
\"Loading Resources\". You can try the following workaround:

Create the file:

```{=mediawiki}
{{hc|/etc/udev/rules.d/70-amdgpu-mclk.rules|2=
KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="manual", ATTR{device/pp_dpm_mclk}="1 2 3"
}}
```
This disables the lowest memory clock state \"0\".

Activate immediately with:

`# udevadm control --reload && udevadm trigger`

### Creeper World 3: Arc Eternal {#creeper_world_3_arc_eternal}

#### Game does not start {#game_does_not_start_2}

```{=mediawiki}
{{Accuracy|Would this not be fixed by using native versions instead of the Steam runtime?}}
```
Search for `{{ic|Player.log}}`{=mediawiki} (might be in
`{{ic|~/.config/unity3d/Knuckle Cracker LLC/Creeper World 3/}}`{=mediawiki}).

If it says somewhere in `{{ic|Player.log}}`{=mediawiki}:

`FMOD failed to get number of drivers ... An error occured that was not supposed to.  Contact support.`

Unity is probably having problem with some PulseAudio libraries.

Remove or rename all instances of libpulse-simple\* files in `{{ic|/usr/lib}}`{=mediawiki},
`{{ic|/usr/lib32}}`{=mediawiki},
`{{ic|~/.steam/steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/}}`{=mediawiki},
`{{ic|~/.steam/steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/}}`{=mediawiki}.

### CrossCode

#### If FontConfig errors on start {#if_fontconfig_errors_on_start}

```{=mediawiki}
{{bc|
...
Fontconfig error: "/etc/fonts/fonts.conf", line 6: invalid attribute 'translate'
Fontconfig error: "/etc/fonts/fonts.conf", line 6: invalid attribute 'selector'
Fontconfig error: "/etc/fonts/fonts.conf", line 7: invalid attribute 'xmlns:its'
Fontconfig error: "/etc/fonts/fonts.conf", line 7: invalid attribute 'version'
Fontconfig warning: "/etc/fonts/fonts.conf", line 9: unknown element "description"
Fontconfig warning: "/etc/fonts/conf.d/10-hinting-slight.conf", line 4: unknown element "its:rules"
Fontconfig warning: "/etc/fonts/conf.d/10-hinting-slight.conf", line 5: unknown element "its:translateRule"
Fontconfig error: "/etc/fonts/conf.d/10-hinting-slight.conf", line 5: invalid attribute 'translate'
Fontconfig error: "/etc/fonts/conf.d/10-hinting-slight.conf", line 5: invalid attribute 'selector'
Fontconfig error: "/etc/fonts/conf.d/10-hinting-slight.conf", line 6: invalid attribute 'xmlns:its'
Fontconfig error: "/etc/fonts/conf.d/10-hinting-slight.conf", line 6: invalid attribute 'version'
Fontconfig warning: "/etc/fonts/conf.d/10-hinting-slight.conf", line 8: unknown element "description"
Fontconfig warning: "/etc/fonts/conf.d/10-scale-bitmap-fonts.conf", line 4: unknown element "its:rules"
Fontconfig warning: "/etc/fonts/conf.d/10-scale-bitmap-fonts.conf", line 5: unknown element "its:translateRule"
...
}}
```
Download the latest version of nwjs from [here](https://nwjs.io/) and extract its contents into your CrossCode
directory, overwriting the files.

Be sure to rename `{{ic|nw}}`{=mediawiki} to `{{ic|CrossCode}}`{=mediawiki} after.

This solution was documented to work with CrossCode 1.2 and nwjs 0.41.2 and is based on [this steam
post](https://steamcommunity.com/app/368340/discussions/1/1727575977598417554/)

#### Crash during startup : X server probably went away {#crash_during_startup_x_server_probably_went_away}

If the game crashes on startup, with the logs ending with a line like the following:

`[19142:19142:0315/222104.782993:ERROR:chrome_browser_main_extra_parts_x11.cc(62)] X IO error received (X server probably went away)`

Add `{{ic|--disable-gpu}}`{=mediawiki} to the launch options (as documented [in this steam
post](https://steamcommunity.com/app/368340/discussions/1/1733213724900972605/?&ctp=6#c3185738591085997507)).

### Crusader Kings II {#crusader_kings_ii}

#### No audio {#no_audio}

SDL uses [PulseAudio](PulseAudio "wikilink") by default, so to use it with [ALSA](ALSA "wikilink") you need to
[set](Environment_variables#Graphical_environment "wikilink") the `{{ic|1=SDL_AUDIODRIVER=alsa}}`{=mediawiki}
environment variable.

#### Oddly sized starting window {#oddly_sized_starting_window}

You can make full screen mode the default by setting `{{ic|1=fullscreen=yes}}`{=mediawiki} in
`{{ic|~/.paradoxinteractive/Crusader Kings II/settings.txt}}`{=mediawiki}.

#### DLCs not detected {#dlcs_not_detected}

If the DLC tab in the launcher is not selectable, rename the `{{ic|DLC}}`{=mediawiki} directory in the game directory to
`{{ic|dlc}}`{=mediawiki}.

#### Game takes ages to start {#game_takes_ages_to_start}

If you are using a NVIDIA graphics card, make sure you have enabled the [DRM kernel mode
setting](NVIDIA#DRM_kernel_mode_setting "wikilink").

#### Game does not start at all {#game_does_not_start_at_all}

If the game stopped launching after Patch 3.3 (when the game became 64-bit only), install `{{Pkg|onetbb}}`{=mediawiki}.

### Crypt of the NecroDancer {#crypt_of_the_necrodancer}

#### Crashes after splash screen {#crashes_after_splash_screen}

The following error occurs if launching Steam from the terminal.

`FMOD ERROR: UpdateFMOD SystemUpdate: This command failed because System::init or System::setDriver was not called.`

This error is solved by installing `{{Pkg|pulseaudio-alsa}}`{=mediawiki}.

#### Game does not launch at all (Wayland) {#game_does_not_launch_at_all_wayland}

On Wayland, it is currently (as of May 2024) necessary to add `{{ic|1=SDL_VIDEODRIVER=x11}}`{=mediawiki} to your launch
options. If you have not added any launch options, also add `{{ic|%command%}}`{=mediawiki} at the end of your launch
options. Game should launch normally.

### The Curious Expedition {#the_curious_expedition}

#### Game stuck on loading screen {#game_stuck_on_loading_screen}

The Electron shipped with this game is too old for Arch Linux.

Install `{{Pkg|electron}}`{=mediawiki} and run the game with `{{ic|electron resources/app.asar}}`{=mediawiki}.

### Death Road To Canada {#death_road_to_canada}

#### No music {#no_music}

Prepend `{{ic|/usr/lib}}`{=mediawiki} to `{{ic|LD_LIBRARY_PATH}}`{=mediawiki}.

### Deus Ex: Mankind Divided {#deus_ex_mankind_divided}

```{=mediawiki}
{{Out of date|The OpenSSL 1.0 package has been dropped, is this game still affected?}}
```
Follow [#OpenSSL 1.0 setup](#OpenSSL_1.0_setup "wikilink").

Requires `{{AUR|libidn11}}`{=mediawiki} & `{{AUR|librtmp0}}`{=mediawiki}.

Also if you use Bumblebee set your [launch options](launch_option "wikilink") to:

`LD_PRELOAD="$LD_PRELOAD:libpthread.so.0:libGL.so.1" __GL_THREADED_OPTIMIZATIONS=1  optirun %command%`

If the game will not activate and you are running [systemd-resolved](systemd-resolved "wikilink") and Proton, follow
[Steam/Troubleshooting#Games running with Proton 5.13+ have no Internet
connectivity](Steam/Troubleshooting#Games_running_with_Proton_5.13+_have_no_Internet_connectivity "wikilink").

### Dirt

```{=mediawiki}
{{Out of date|The OpenSSL 1.0 package has been dropped, is this game still affected?}}
```
Follow [#OpenSSL 1.0 setup](#OpenSSL_1.0_setup "wikilink").

### Dirt Rally {#dirt_rally}

Run the beta version: right click on the game, then *Properties... \> Betas*, enter the code: \"feraldirtsupport\" and
click *Check Code*, finally, choose *feral_support_branch* as the version.

To use the native libraries, [installing](install "wikilink") `{{AUR|gconf}}`{=mediawiki} and
`{{AUR|libldap24}}`{=mediawiki} is required.

If you use [Wayland](Wayland "wikilink"), start the game with `{{ic|1=SDL_VIDEODRIVER=x11}}`{=mediawiki}. Similarly, if
you use [PipeWire](PipeWire "wikilink"), start the game with `{{ic|1=SDL_AUDIODRIVER=pulseaudio}}`{=mediawiki} - other
backends might also work, but the default one does not.

Due to changes in how linking works, the game might not properly load its bundled dependencies. To fix this, you can
either run the game with `{{ic|1=LD_LIBRARY_PATH="''GAME''/lib/x86_64/"}}`{=mediawiki} or symlink the libraries from
`{{ic|''GAME''/lib/x86_64/*}}`{=mediawiki} to
`{{ic|''GAME''/lib/*}}`{=mediawiki}.[15](https://github.com/FeralInteractive/ferallinuxscripts/issues/3#issuecomment-326052969)

The game may also segfault if you use an AMD Zen 3 or newer CPU. To fix this you can hack together a small shared
library to replace the `{{ic|mprotect}}`{=mediawiki} function and make sure the allocated memory has the
`{{ic|PROT_READ}}`{=mediawiki} access flag.[16](https://news.ycombinator.com/item?id=25821288). Here is an example:

`$ cat game.c`\
`#include <sys/mman.h>`\
`#include <unistd.h>`\
`#include <sys/syscall.h>`\
\
`int mprotect(void *addr, size_t len, int prot) {`\
`  if (prot == PROT_EXEC) {`\
`    prot |= PROT_READ;`\
`  }`\
`  return syscall(__NR_mprotect, addr, len, prot);`\
`}`

You can then compile the library and move the shared object to the game libraries:

`$ gcc game.c -shared -o game.so`\
`$ mv game.so `*`GAME`*`/lib/`

After that you can add `{{ic|1=LD_PRELOAD=game.so}}`{=mediawiki} to the game launch options.

### Divinity: Original Sin - Enhanced Edition {#divinity_original_sin___enhanced_edition}

#### Game does not start when using Bumblebee optirun or primusrun {#game_does_not_start_when_using_bumblebee_optirun_or_primusrun}

Edit `{{ic|''GAME''/runner.sh}}`{=mediawiki} to use primusrun:

`LD_LIBRARY_PATH="." primusrun ./EoCApp`

#### Game does not work with mesa {#game_does_not_work_with_mesa}

It is a known bug and they have no intention of fixing it, see [the
bug](https://bugs.freedesktop.org/show_bug.cgi?id=93551).

Workaround[17](https://www.gamingonlinux.com/articles/divinity-original-sin-may-soon-work-with-mesa-drivers.8867/comment_id=81524)`{{Dead link|2024|07|30|status=404}}`{=mediawiki}
(see [step by step guide](https://bugs.freedesktop.org/show_bug.cgi?id=93551#c46))

Get the following file: <https://bugs.freedesktop.org/attachment.cgi?id=125302> and rename it to
`{{ic|divos-hack.c}}`{=mediawiki}

Then execute:

`$ gcc -s -O2 -shared -fPIC -o divos-hack.{so,c} -ldl`

Copy the `{{ic|divos-hack.so}}`{=mediawiki} to the *game* directory.

For GOG version, go to the said game directory and run Divinity with the following command:

`$ allow_glsl_extension_directive_midshader=true LD_PRELOAD="divos-hack.so" ./runner.sh`

For *steam*, open a console, change to the divinity directory with

`$ cd ~/.steam/steam/steamapps/common/Divinity Original Sin Enhanced Edition`

Launch steam and got o the preferences of the game, and open the \"Set Launch Options\" dialogue. There, put the
following

`allow_glsl_extension_directive_midshader=true LD_PRELOAD="divos-hack.so:$LD_PRELOAD" %command%`

Then just start the game.

### Doki Doki Literature Club {#doki_doki_literature_club}

Linux version is shipped with the Windows version, but can only be installed with Steam Play.

Native version can be started with this launch option: `{{ic|./DDLC.sh # %command%}}`{=mediawiki}

### Don\'t Starve Together {#dont_starve_together}

If you get a crash on start in `{{ic|libX11.so.6.4.0}}`{=mediawiki}, the problem is likely a bug in SDL1.3.
Unfortunately, DST is statically linked and we cannot use `{{ic|LD_PRELOAD}}`{=mediawiki} to replace libSDL with
something newer. The bug has been reported to the developer, but a possible workaround is [to patch
`{{ic|XGetICValues()}}`{=mediawiki} to not crash when it is incorrectly given a null
parameter.](https://forums.kleientertainment.com/klei-bug-tracker/dont-starve-together/crash-on-startup-r32786/?do=findComment&comment=49731)

### Dota 2 {#dota_2}

Dependencies:

-   ```{=mediawiki}
    {{AUR|libudev0}}
    ```
    ```{=mediawiki}
    {{Broken package link|package not found}}
    ```

-   ```{=mediawiki}
    {{AUR|libpng12}}
    ```

#### In-game font is unreadable {#in_game_font_is_unreadable}

Run the game with `{{ic|1=MESA_GL_VERSION_OVERRIDE=2.1}}`{=mediawiki}.

#### Error with libpangoft2 {#error_with_libpangoft2}

1.  [Install](Install "wikilink") the `{{Pkg|pango}}`{=mediawiki} package.
2.  Remove `{{ic|libpango-1.0.so}}`{=mediawiki} and `{{ic|libpangoft2-1.0.so}}`{=mediawiki} in
    `{{ic|''GAME''/game/bin/linuxsteamrt64}}`{=mediawiki}.
3.  If you are using Bumblebee add
    `{{ic|1=LD_PRELOAD="libpthread.so.0 libGL.so.1" __GL_THREADED_OPTIMIZATIONS=1 optiru}}`{=mediawiki} to your [launch
    options](launch_option "wikilink").

#### The game does not start {#the_game_does_not_start}

If you run the game from the terminal and, although no error is shown, try disabling: *Steam \> Settings \> In-Game \>
Enable Steam Community In-Game*.

Apparently the game [#The Book of Unwritten Tales](#The_Book_of_Unwritten_Tales "wikilink") has the same problem. It
also describes a workaround that is untested in Dota 2.

#### Game runs on the wrong screen {#game_runs_on_the_wrong_screen}

See [GitHub Dota 2 issue #11](https://github.com/ValveSoftware/Dota-2/issues/11)

#### Game does not start with libxcb-dri3 error message {#game_does_not_start_with_libxcb_dri3_error_message}

After a recent Mesa update, Dota 2 stopped working. The error message is:

`SDL_GL_LoadLibrary(NULL) failed: Failed loading libGL.so.1: /usr/lib32/libxcb-dri3.so.0: undefined symbol: xcb_send_fd`

#### Game has no audio {#game_has_no_audio}

This might happen because Dota 2 is trying to output through ALSA, which has already been taken over by PulseAudio. Try
installing `{{Pkg|pulseaudio-alsa}}`{=mediawiki} and setting in-game audio output to \'Default\'.

#### Steam overlay {#steam_overlay}

Steam distributes a copy of libxcb which is incompatible with the latest xorg libxcb. See
[18](https://github.com/ValveSoftware/steam-for-linux/issues/3199),
[19](https://github.com/ValveSoftware/steam-for-linux/issues/3093).

#### Clear or disable shader cache for troubleshooting purposes {#clear_or_disable_shader_cache_for_troubleshooting_purposes}

To clear shader cache delete delete the 570 (Dota\'s app ID) directory under the steam shadercache directory e.g.

`/home/`*`username`*`/steam/steamapps/shadercache/`

To disable shader cache add the following to dota\'s launch options:

`-vulkan_disable_steam_shader_cache`

#### Chinese tips and player names not shown {#chinese_tips_and_player_names_not_shown}

The Chinese characters in tips and player names are displayed as block characters.

The problem is caused by the font packages: `{{Pkg|ttf-dejavu}}`{=mediawiki}, `{{Pkg|ttf-liberation}}`{=mediawiki} and
`{{AUR|ttf-ms-fonts}}`{=mediawiki}.

See [GitHub Steam issue #1688](https://github.com/ValveSoftware/Dota-2/issues/1688)

#### Chinese input method problem {#chinese_input_method_problem}

Dota2 is compatible with [IBus](IBus "wikilink") and [Fcitx](Fcitx "wikilink"). XIM support Should be enabled.

`XMODIFIERS=@im=fcitx %command%`

### Devil Daggers {#devil_daggers}

Refer to [#Missing libcurl.so.4 or version CURL_OPENSSL_3 not
found](#Missing_libcurl.so.4_or_version_CURL_OPENSSL_3_not_found "wikilink").

### Drox Operative {#drox_operative}

If the game fails to start with \"Couldn\'t find Database/database.dbl!\", manually extract the assets. assets003.zip
will overwrite some files from the previous files.

`$ cd "~/.steam/root/steamapps/common/Drox Operative/Assets"`\
`$ unzip assets00[123].zip`

### Dungeon Souls {#dungeon_souls}

For AMD cards this game crashes on launch, unless you start it like this:

`R600_DEBUG=mono %command%`

### Dying Light {#dying_light}

#### Game crashes on startup {#game_crashes_on_startup}

The game runs with the Steam setting \"Force the use of a specific Steam Play compatibility tool\" \> \"Steam Linux
Runtime\"

### Dynamite Jack {#dynamite_jack}

Requires `{{AUR|lib32-sdl}}`{=mediawiki}.

#### Sound Issues {#sound_issues}

When running on 64-bit Arch Linux, there may be \"pops and hisses\" when running Dynamite Jack. This could be caused by
not having `{{ic|1=STEAM_RUNTIME=0}}`{=mediawiki} set. (However, even with `{{ic|1=STEAM_RUNTIME=0}}`{=mediawiki} set,
the game may still sometimes start with this issue. Exiting and restarting the game seems to make the problem go away.)

#### Game does not start {#game_does_not_start_3}

If running steam with the `{{ic|1=STEAM_RUNTIME=0}}`{=mediawiki}, Dynamite Jack may have a problem starting. Check the
steam error messages for this message:

`/home/`*`username`*`/.steam/root/steamapps/common/Dynamite Jack/bin/main: error while loading shared libraries: libSDL-1.2.so.0: cannot open shared object file: No such file or directory`

Install `{{AUR|lib32-sdl}}`{=mediawiki} from [multilib](multilib "wikilink") and Dynamite Jack should start up.

### Empire Total War {#empire_total_war}

#### Weird unreadable fonts {#weird_unreadable_fonts}

Open `{{ic|~/.local/share/feral-interactive/Empire/preferences}}`{=mediawiki}, then find
`{{ic|UsePBOSurfaces}}`{=mediawiki} and change it from 1 to 0.

### Euro Truck Simulator 2 {#euro_truck_simulator_2}

#### Shows only a black screen {#shows_only_a_black_screen}

Select safe mode when the game starts up.

### Firewatch

If Firewatch starts but does not show anything, try running Steam with

`$ STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0 steam`

### Football Manager 2014 {#football_manager_2014}

This game will not run when installed on an [XFS](XFS "wikilink") or reiserfs filesystem. Workaround is to install on an
ext4 filesystem.

### FORCED

Requires `{{Pkg|lib32-glu}}`{=mediawiki}.

This game has 32-bit and 64-bit binaries. For some reason, Steam will launch the 32-bit binary even on 64-bit Arch
Linux. When manually launching the 64-bit binary, the game starts, but cannot connect to Steam account, so you cannot
play. So install 32-bits dependencies, and launch the game from Steam.

### For the King {#for_the_king}

#### With steam-native {#with_steam_native}

Starts with black page. Requires to be told to use the libSDL2 shipping with Steam

Add to Steam launch options for game:

`LD_PRELOAD=~/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0 %command%`

Note however, that this disables the Steam overlay as a side effect.

#### With steam-runtime {#with_steam_runtime}

It works out of the box.

For the full experience, run FTK via steam-runtime instead of steam-native.

### FTL: Faster than Light {#ftl_faster_than_light}

#### Compatibility

After installation, FTL may fail to run due to a \'Text file busy\' error (characterised in Steam by your portrait
border going green then blue again). The easiest way to mend this is to just reboot your system. Upon logging back in
FTL should run.

The Steam overlay in FTL does not function as it is not a 3D accelerated game. Because of this the desktop notifications
will be visible. If playing in fullscreen, therefore, these notifications in some systems may steal focus and revert you
back to windowed mode with no way of going back to fullscreen without relaunching. The binaries for FTL on Steam have no
DRM and it is possible to run the game *without* Steam running, so in some cases that may be optimum - just ensure that
you launch FTL via the launcher script in `{{ic|''GAME''/data/}}`{=mediawiki} rather than the FTL binary in the \$arch
directory.

#### Problems with open-source video driver {#problems_with_open_source_video_driver}

FTL may fail to run if you are using an opensource driver for your video card. There are two solutions: install a
proprietary video driver or delete (rename if you are unsure) the library \"libstdc++.so.6\" inside
`{{ic|''GAME''/data/amd64/lib}}`{=mediawiki}. This is if you are using a 64bit system. In case you are using a 32bit
system you have to remove (rename) the same library located into `{{ic|''GAME''/data/x86/lib}}`{=mediawiki}.

#### Artifacts when launching, Problems with openGL {#artifacts_when_launching_problems_with_opengl}

Using the open source drivers, ATI for radeon cards, the game can display artifacts on screen. Run the game with
`{{ic|1=MESA_GL_VERSION_OVERRIDE=3.0 %command%}}`{=mediawiki}

### Game Dev Tycoon {#game_dev_tycoon}

#### Game does not start {#game_does_not_start_4}

You might get an error about missing `{{ic|libudev.so.0}}`{=mediawiki}.

Run the game with `{{ic|1=LD_PRELOAD=/usr/lib/libudev.so.1}}`{=mediawiki}.

### Garry\'s Mod {#garrys_mod}

#### Game does not start {#game_does_not_start_5}

When an error about a missing `{{ic|client.so}}`{=mediawiki} appears, try the following:

`$ cd ~/.steam/root/steamapps/common/GarrysMod/bin/`\
`$ ln -s libawesomium-1-7.so.0 libawesomium-1-7.so.2`\
`$ ln -s ../garrysmod/bin/client.so ./`

If the error mentions a missing library for `{{ic|libgconf-2.so.4}}`{=mediawiki}, install
`{{AUR|lib32-gconf}}`{=mediawiki}`{{Broken package link|package not found}}`{=mediawiki}.

#### Opening some menus causes the game to crash {#opening_some_menus_causes_the_game_to_crash}

Most menus work fine, but ones with checkboxes (LAN multiplayer, mounted games list) do not work at all. This is a bug
in the menu code.

If you prefer the default menu style and do not mind a hacky solution:
[Simon311](https://github.com/Facepunch/garrysmod-issues/issues/86#issuecomment-30935491) has written code with
instructions to fix it.

If you do not care for the default menu style and want a more stable but feature-incomplete solution, Facepunch
developer [robotboy655](https://github.com/robotboy655/gmod-lua-menu) has written a new menu.

#### Game crashes after attempting to join server {#game_crashes_after_attempting_to_join_server}

While in the process of joining a server, downloading resources, etc, the game seems to hang and after a while, perhaps
during the \"sending client info\" portion the game crashes, usually without any error messages. Error does not give
much information, however, the process for Garry\'s mod is killed.

This issue arises more often when joining servers with many addons like DarkRP servers specifically.

The problem seems to correlate with a weak GPU and the game is timing out from the server, so if the GPU is the problem,
lowering the graphics settings to the minimum should fix the problem.

The problem seems to be related to RAM usage, once you hit around 2GB of RAM used, the game will crash. Servers with
many addons have much more RAM usage, and lowering graphics settings to the minimum lowers RAM usage and mitigates
crashes.

Using the experimental x86-64 branch may help mitigate this issue, however keep in mind that some addons may return
errors while using this branch.

### Gods will be watching {#gods_will_be_watching}

```{=mediawiki}
{{Out of date|The OpenSSL 1.0 package has been dropped, is this game still affected?}}
```
Follow [#OpenSSL 1.0 setup](#OpenSSL_1.0_setup "wikilink").

### GRID Autosport {#grid_autosport}

```{=mediawiki}
{{Out of date|The OpenSSL 1.0 package has been dropped, is this game still affected?}}
```
Follow [#OpenSSL 1.0 setup](#OpenSSL_1.0_setup "wikilink").

#### Black screen when trying to play {#black_screen_when_trying_to_play}

Run the game with `{{ic|1=LC_ALL=C.UTF-8}}`{=mediawiki}.

### Guns of Icarus Online {#guns_of_icarus_online}

If you encounter problems, check out the error log:

`~/.config/unity3d/Muse Games/GunsOfIcarusOnline/Player.log`

#### version \`CURL_OPENSSL_4\' not found (required by /usr/lib/libdebuginfod.so.1) {#version_curl_openssl_4_not_found_required_by_usrliblibdebuginfod.so.1}

Install the package `{{Pkg|lib32-libcurl-compat}}`{=mediawiki} and include \'libcurl.so.4\' in your LD_PRELOAD in your
shell environment like so:

`export LD_PRELOAD=$LD_PRELOAD libcurl.so.4`

### Hack \'n\' Slash {#hack_n_slash}

#### Crashes when trying to load a game {#crashes_when_trying_to_load_a_game}

Prepend `{{ic|/usr/lib}}`{=mediawiki} to `{{ic|LD_LIBRARY_PATH}}`{=mediawiki}.

### Hacker Evolution {#hacker_evolution}

Requires `{{Pkg|lib32-sdl2_mixer}}`{=mediawiki}.

### Half-Life {#half_life}

#### Invisible text {#invisible_text}

Half-Life uses microsoft fonts to display text, see [Microsoft fonts](Microsoft_fonts "wikilink") for ways to install
them.

### Half-Life 2 and episodes {#half_life_2_and_episodes}

#### Cyrillic fonts problem {#cyrillic_fonts_problem}

This problem can be solved by deleting \"Helvetica\" font.

### Hammerwatch

#### The game does not start via Steam {#the_game_does_not_start_via_steam}

Prepend `{{ic|/usr/lib}}`{=mediawiki} to `{{ic|LD_LIBRARY_PATH}}`{=mediawiki}.

#### No sound {#no_sound_2}

Hammerwatch opens with a popup: \"Sound Error\" \-- \"Could not initialize OpenAL, no sounds will be played. Try
updating your OpenAL drivers.\"

OpenAL, which Hammerwatch uses, defaults to PulseAudio. To change that, add the following line to
`{{ic|/etc/openal/alsoft.conf}}`{=mediawiki}:

`drivers=alsa,pulse`

This way, Hammerwatch will use ALSA. This solution was found
[here](https://stackoverflow.com/questions/9547396/what-does-al-lib-pulseaudio-c612-context-did-not-connect-access-denied-me).

### Harvest: Massive Encounter {#harvest_massive_encounter}

Dependencies:

-   ```{=mediawiki}
    {{AUR|lib32-sfml}}
    ```
    ```{=mediawiki}
    {{Broken package link|package not found}}
    ```

-   ```{=mediawiki}
    {{AUR|lib32-libjpeg6-turbo}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-nvidia-cg-toolkit}}
    ```

-   ```{=mediawiki}
    {{AUR|lib32-gtk2}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libvorbis}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-openal}}
    ```

#### Compatibility {#compatibility_1}

If the game refuses to launch and throws you into a library installer loop, run the `{{ic|Harvest}}`{=mediawiki}
executable instead of the `{{ic|run_harvest}}`{=mediawiki} script.

### Hatoful Boyfriend {#hatoful_boyfriend}

#### Japanese text invisible {#japanese_text_invisible}

Install `{{Pkg|wqy-microhei}}`{=mediawiki} and `{{Pkg|wqy-microhei-lite}}`{=mediawiki}.

### HEARTBEAT

#### If FontConfig Errors on Start {#if_fontconfig_errors_on_start_1}

Follow the same process described in [#CrossCode](#CrossCode "wikilink").

### HuniePop

#### Game crashes upon launch {#game_crashes_upon_launch}

Install `{{Pkg|lsb-release}}`{=mediawiki}.

### Hyper Light Drifter {#hyper_light_drifter}

#### The controller does not work {#the_controller_does_not_work}

[Install](Install "wikilink") `{{AUR|lib32-sdl2}}`{=mediawiki} and run the game with
`{{ic|1=LD_PRELOAD=libSDL2.so}}`{=mediawiki}.

See the following Steam Community discussions:

-   [Controller Issues](https://steamcommunity.com/app/257850/discussions/1/365163686036494421)
-   [Common Bugs + Known Issues](https://steamcommunity.com/app/257850/discussions/1/365163686045397160/)

It is suggested to run the *next_update* branch to get new fixes, there however currently is a libcurl segfault keeping
it from starting without special workarounds.

#### Missing libcurl.so.4 or version CURL_OPENSSL_3 not found {#missing_libcurl.so.4_or_version_curl_openssl_3_not_found_1}

Refer to [#Missing libcurl.so.4 or version CURL_OPENSSL_3 not
found](#Missing_libcurl.so.4_or_version_CURL_OPENSSL_3_not_found "wikilink").

### Rome Total War Remastered {#rome_total_war_remastered}

#### Slowness of loading screen for open-source drivers {#slowness_of_loading_screen_for_open_source_drivers}

[Install](Install "wikilink") `{{Pkg|vulkan-swrast}}`{=mediawiki} and then change the renderer option in the game
launcher to llvmpipe after a system restart.

Once done the loading screen scene would then be fixed and should load up as normal for open-source drivers.

### Imperator: Rome {#imperator_rome}

Paradox Launcher freezes or crashes after start. Set your launch options to:

`LD_PRELOAD=/usr/lib/libc.so.6 %command%`

If the screen freezes every \~3 seconds, run:

`# chmod o-rx /dev/input/`

After playing, undo it with:

`# chmod o+rx /dev/input/`

### The Impossible Game {#the_impossible_game}

Dependencies:

-   ```{=mediawiki}
    {{AUR|lib32-sdl2}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-sdl2_image}}
    ```

### The Inner World {#the_inner_world}

Requires `{{AUR|java-commons-codec}}`{=mediawiki} for sound support.

#### Bringing up the inventory or main menu {#bringing_up_the_inventory_or_main_menu}

Hold the tab key.

##### Cutscenes

The game has cutscenes. It starts directly with a cutscene before you start the actual game in the backyard. To see
these cutscenes you need to use Oracle\'s [Java](Java "wikilink") instead of the OpenJDK.

Furthermore you need the package `{{AUR|ffmpeg-compat-55}}`{=mediawiki}.

There seem to be problems with the Steam overlay. Try to run the game directly with
`{{ic|''GAME''/TIW_start.sh}}`{=mediawiki}.

Note that cutscenes open in a new window. So pay attention to that and switch to the new window to enjoy the movies.

See the [Steam Forums](https://steamcommunity.com/app/251430/discussions/0/611701360817206606/#c611701360827509770) for
details.

### Insurgency

#### Game does not start {#game_does_not_start_6}

Set the following launch option:

`LD_PRELOAD='/usr/$LIB/libstdc++.so.6:/usr/$LIB/libgcc_s.so.1:/usr/$LIB/libxcb.so.1:/usr/$LIB/libgpg-error.so' %command%`

### Interloper

Requires `{{Pkg|alsa-lib}}`{=mediawiki}.

#### Game does not start {#game_does_not_start_7}

The game can sometimes segfault due to an incompatibility with the Steam Runtime\'s `{{ic|libasound.so.2}}`{=mediawiki}.

### Invisible Apartment {#invisible_apartment}

Requires `{{Pkg|qt5-multimedia}}`{=mediawiki}.

#### Game does not start {#game_does_not_start_8}

If the game does not run when you launch it via Steam, try to directly run `{{ic|./ia1}}`{=mediawiki} in the game
directory.

### Joe Danger 2: The Movie {#joe_danger_2_the_movie}

Requires `{{Pkg|lib32-libpulse}}`{=mediawiki}.

#### Compatibility {#compatibility_2}

Game only worked after obtaining from the [Humble Bundle](https://www.humblebundle.com/) directly and
`{{Pkg|lib32-libpulse}}`{=mediawiki} was installed.

### Kerbal Space Program {#kerbal_space_program}

See [Kerbal Space Program](Kerbal_Space_Program "wikilink").

### Killing Floor {#killing_floor}

#### Cannot change screen resolution {#cannot_change_screen_resolution}

If trying to modify the resolution in-game crashes your desktop environment, edit
`{{ic|~/.killingfloor/System/KillingFloor.ini}}`{=mediawiki}:

`[WinDrv.WindowsClient]`\
`WindowedViewportX=`*`width`*\
`WindowedViewportY=`*`height`*\
`FullscreenViewportX=`*`width`*\
`FullscreenViewportY=`*`height`*\
`MenuViewportX=`*`width`*\
`MenuViewportY=`*`height`*\
\
`[SDLDrv.SDLClient]`\
`WindowedViewportX=`*`width`*\
`WindowedViewportY=`*`height`*\
`FullscreenViewportX=`*`width`*\
`FullscreenViewportY=`*`height`*\
`MenuViewportX=`*`width`*\
`MenuViewportY=`*`height`*

#### Windowed mode {#windowed_mode}

Uncheck fullscreen in the options menu, and press `{{ic|Ctrl+g}}`{=mediawiki} to stop mouse capturing.

#### Stuttering sound {#stuttering_sound}

KillingFloor comes with its own OpenAL library `{{ic|''GAME''/System/openal.so}}`{=mediawiki}.

Back it up, [install](install "wikilink") `{{Pkg|openal}}`{=mediawiki} or `{{Pkg|lib32-openal}}`{=mediawiki} (if using a
64bit system).

Then symlink the installed system library (`{{ic|/usr/lib32/libopenal.so.1}}`{=mediawiki} or
`{{ic|/usr/lib/libopenal.so.1}}`{=mediawiki}) to `{{ic|openal.so}}`{=mediawiki}.

### Left for Dead 2 {#left_for_dead_2}

#### Missing Chinese font {#missing_chinese_font}

L4D2 looks for the [WenQuanYi](Wikipedia:WenQuanYi "wikilink") font to render Chinese text with. You can either install
a package that provides the font, such as `{{Pkg|wqy-zenhei}}`{=mediawiki} or `{{AUR|ttf-ms-fonts}}`{=mediawiki}, or
configure a [fallback font](Font_configuration#Match_tests "wikilink"):

```{=mediawiki}
{{hc|/etc/fonts/local.conf (or ~/.config/fontconfig/fonts.conf)|2=
...
         <match target="pattern">
                <test qual="any" name="family">
                        <string>WenQuanYi Zen Hei</string>
                </test>
                <edit name="family" mode="assign" binding="same">
                        <string>Source Han Sans CN</string>
                </edit>
        </match>
...
}}
```
#### Game Light Too Dark {#game_light_too_dark}

Reasons of too dim in-game environment light varies, one of which is dedicated GPU is not employed.

According to multiple steam [guide](https://steamcommunity.com/sharedfiles/filedetails/?id=2816736620), please run this
game using NVIDIA GPU **with 32-bit libraries support**.

### Lethal League {#lethal_league}

Requires `{{AUR|lib32-glew1.10}}`{=mediawiki}.

### Life is Strange {#life_is_strange}

Requires `{{Pkg|sdl2_image}}`{=mediawiki} `{{AUR|librtmp0}}`{=mediawiki} `{{AUR|libidn11}}`{=mediawiki}
`{{Pkg|libxcrypt-compat}}`{=mediawiki} `{{Pkg|lib32-libxcrypt-compat}}`{=mediawiki} `{{AUR|gconf}}`{=mediawiki}.

### Little Racers STREET {#little_racers_street}

Install `{{Pkg|sdl2_mixer}}`{=mediawiki}.

Move/backup `{{ic|''GAME''/lib64/libSDL2_mixer-2.0.so.0}}`{=mediawiki}.

Symlink `{{ic|/usr/lib/libSDL2_mixer-2.0.so.0}}`{=mediawiki} to
`{{ic|''GAME''/lib64/libSDL2_mixer-2.0.so.0}}`{=mediawiki}.

### The Long Dark {#the_long_dark}

#### Game does not start {#game_does_not_start_9}

The 64-bit version fails to start. Either use the 32-bit version `{{ic|tld.x86}}`{=mediawiki} in the game directory or
start the 64-bit version like so:

`LD_PRELOAD=~/.steam/root/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0 ./tld.x86_64`

#### Game starts, but some overlay text is missing and cutscenes shows black screen {#game_starts_but_some_overlay_text_is_missing_and_cutscenes_shows_black_screen}

In addition to the command above, add the following to the Steam launch command:

`-screen-fullscreen 0 -screen-width WIDTH_PIXELS -screen-height HEIGHT_PIXELS`

For example, if you have a screen resolution of 1280x720 and are launching the x64 version from the terminal (within the
directory which contains the binaries), the full command would be:

`$ LD_PRELOAD=~/.steam/root/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0 ./tld.x86_64 -screen-fullscreen 0 -screen-width 1280 -screen-height 720`

and from Steam, the complete game [launch options](launch_option "wikilink") would be:

`LD_PRELOAD=~/.steam/root/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0 %command% -screen-fullscreen 0 -screen-width 1280 -screen-height 720`

#### Cutscenes are still black {#cutscenes_are_still_black}

Turn off Vertical Sync in the Display options, and/or set POST FX to Low in the Quality options, and/or turn global
Quality options down a notch.

#### Cursor disappears {#cursor_disappears}

Go to Options \> Controls, and set mouse locking to unlocked.

The options is visible only if you are navigating using your (invisible) mouse. It will not show up when navigating with
a controller. One solution is to go to Options -\> Controls with a controller before switching to the mouse and trying
to blindly it the setting.

### Grand Theft Auto V {#grand_theft_auto_v}

#### BattleEye connection issues {#battleeye_connection_issues}

```{=mediawiki}
{{Remove|The solution here probably does not work, as the Windows and Proton versions are distinct and according to user reports. Players may get to Online for a few minutes at maximum, whether or not having the environment variable set, which may confuse users to thinking Online mode works. You may try this workaround at your own discretion, however this section should be removed in case it is established Online does not work. It has been clearly established before GTA V only supports the Windows version of BattlEye. GTA V compatibility with Proton is tracked here: https://github.com/ValveSoftware/Proton/issues/37}}
```
See [#BattlEye](#BattlEye "wikilink").

Modify launch options to include `{{ic|PROTON_BATTLEYE_RUNTIME}}`{=mediawiki}:

```{=mediawiki}
{{bc|1=PROTON_BATTLEYE_RUNTIME=~/.local/share/Steam/steamapps/common/Proton\ BattlEye\ Runtime/ %command%}}
```
#### Game crashes in Online {#game_crashes_in_online}

If you experience crashes in GTA Online (e.g. when creating a new character), set these launch options:

`PROTON_NO_ESYNC=1 WINEDLLOVERRIDES=winedbg.exe=d %command%`

#### Graphical Issues using a NVIDIA GPU {#graphical_issues_using_a_nvidia_gpu}

Try launch options: -force-glcore42 -force-clamped

### Magicka 2 {#magicka_2}

#### Indefinitely stuck at start {#indefinitely_stuck_at_start}

The game does not start if the output of the command \"ip -s link\" is longer than 4096 characters. That is because, in
the function bitsquid::network_info(char\*), where they query the networking information, they do not handle that case
correctly. See [this picture](https://i.imgur.com/AOTLoTY.png) for reference. It was reported to upstream (Pieces
Interactive) but Magicka 2 does not seem to be maintained anymore.

A dirty fix is to wrap your ip binary, as such:

```{=mediawiki}
{{bc|1=
#!/bin/sh
if [ "$*" = "-s link" ]; then
    echo "<paste a smaller subset of the normal output>"
else
    /path/to/your/real/ip "$@"
fi
}}
```
### Mark of the Ninja {#mark_of_the_ninja}

#### Bad sound {#bad_sound}

Prepend `{{ic|/usr/lib}}`{=mediawiki} to `{{ic|LD_LIBRARY_PATH}}`{=mediawiki}.

### Metro: Last Light {#metro_last_light}

```{=mediawiki}
{{Out of date|References the AMD Catalyst driver, which has been abandoned for a while.}}
```
The game does not allow you to change its resolution on a multi-monitor setup on GNOME with the AMD Catalyst drivers. A
temporary workaround is to disable the side monitors. Jason over at [unencumbered by
facts](https://unencumberedbyfacts.com/2013/11/20/multiple-monitor-gaming-on-linux/) managed to get it working with his
multi-monitor setup using a single display server, he however is using NVIDIA.

### Metro: 2033 Redux {#metro_2033_redux}

#### No sound {#no_sound_3}

Install `{{Pkg|pulseaudio-alsa}}`{=mediawiki}.

#### No image {#no_image}

Try setting `{{ic|r_fullscreen off}}`{=mediawiki} in
`{{ic|~/.local/share/Steam/steamapps/common/Metro 2033 Redux/user.cfg}}`{=mediawiki}.

### Middle-earth: Shadow of Mordor {#middle_earth_shadow_of_mordor}

#### Floating heads {#floating_heads}

Run the game with `{{ic|1=__GL_ShaderPortabilityWarnings=0}}`{=mediawiki}.

### Mount & Blade: Warband {#mount_blade_warband}

#### Segmentation fault (core dumped) with Wayland {#segmentation_fault_core_dumped_with_wayland}

Use [Xorg](Xorg "wikilink") instead, or force the session to use `{{ic|xcb}}`{=mediawiki} as
`{{ic|QT_QPA_PLATFORM}}`{=mediawiki}.

#### DLC chooser {#dlc_chooser}

Requires building `{{Pkg|qt5-tools}}`{=mediawiki}.

#### Crash on startup {#crash_on_startup}

Set launch options to:

`LD_LIBRARY_PATH="." %command%`

### Move or Die {#move_or_die}

#### No Sound {#no_sound_4}

Install `{{Pkg|lib32-libpulse}}`{=mediawiki}. Remove file \"Move or Die/Love/linux32/libogg.so.0\"

### Multiwinia

Requires `{{Pkg|lib32-openal}}`{=mediawiki}.

#### Crash on startup {#crash_on_startup_1}

If Multiwinia crashes on startup on X64 systems, force launching the 32-bit executable by replacing
`{{ic|''GAME''/run_steam.sh}}`{=mediawiki} with the following script:

```{=mediawiki}
{{bc|
#!/bin/sh
./multiwinia.bin.x86
}}
```
See [20](https://steamcommunity.com/app/1530/discussions/0/864969481950542663/#c558746995160431396).

### Natural Selection 2 {#natural_selection_2}

```{=mediawiki}
{{Pkg|sndio}}
```
is required, furthermore, you must also execute

`$ ln -s /usr/lib/libsndio.so x64/libsndio.so.6.1`

within the root of the NS2 directory. This is because NS2 uses an older outdated version of sndio, but it is still
compatible with the new version, thankfully.

For a more minimal solution, one can attempt to set the audio driver used through the environment variable
`{{ic|SDL_AUDIODRIVER}}`{=mediawiki}. For example, `{{ic|1=SDL_AUDIODRIVER=sndio}}`{=mediawiki} or
`{{ic|1=SDL_AUDIODRIVER=alsa}}`{=mediawiki}.

The environment variable `{{ic|SDL_VIDEODRIVER}}`{=mediawiki} must not be set to `{{ic|wayland}}`{=mediawiki}. Try
setting `{{ic|SDL_VIDEODRIVER}}`{=mediawiki} to `{{ic|x11}}`{=mediawiki} if it still does not work.

### No Man\'s Sky {#no_mans_sky}

#### Black screen at start {#black_screen_at_start}

Edit `{{ic|~/Steam/SteamApps/common/No Man's Sky/Binaries/SETTINGS/TKGRAPHICSSETTINGS.MXML}}`{=mediawiki} and set
`{{ic|FullScreen}}`{=mediawiki} to `{{ic|false}}`{=mediawiki} and `{{ic|Borderless}}`{=mediawiki} to
`{{ic|true}}`{=mediawiki}.

#### White screen at start {#white_screen_at_start}

If you get a white screen, it may seem like the game has froze, but it has not. Hold down `{{ic|e}}`{=mediawiki} to
continue.

### Nuclear Throne {#nuclear_throne}

Refer to [#Missing libcurl.so.4 or version CURL_OPENSSL_3 not
found](#Missing_libcurl.so.4_or_version_CURL_OPENSSL_3_not_found "wikilink").

### OneShot

#### Game fails to start {#game_fails_to_start}

This problem occurs because the game use outdated libraries. Go to the game directory and remove
`{{ic|libdrm.so.2}}`{=mediawiki}, `{{ic|libGLdispatch.so.0}}`{=mediawiki}, `{{ic|libstdc++.so.6}}`{=mediawiki},
`{{ic|librt.so.1}}`{=mediawiki}, `{{ic|libcrypt.so.1}}`{=mediawiki} and `{{ic|libcrypto.so.1.1}}`{=mediawiki}. Those
files usually have an equivalent already installed on the system.

#### File \_\_\_\_\_\_\_ will not run {#file_________will_not_run}

The executable \_\_\_\_\_\_\_ may fail when run from the Documents directory. It also exists in the game directory and
will run from there.

#### Game fails to start on Wayland {#game_fails_to_start_on_wayland}

Run the game with `{{ic|1=GDK_BACKEND=x11}}`{=mediawiki}.

### Oxygen Not Included {#oxygen_not_included}

#### World generation hangs {#world_generation_hangs}

This problem occurs with locales that use comas instead of dots to separate decimals.

Set launch options in steam to
`{{ic|1=LANG=C.UTF-8 %command%}}`{=mediawiki}.[21](https://steamcommunity.com/app/457140/discussions/3/1488866180617243731/#c1488866813753688864)

#### Graphics errors, corruption and lines through tiles {#graphics_errors_corruption_and_lines_through_tiles}

This is a result of using the [Zink](OpenGL#OpenGL_over_Vulkan_(Zink) "wikilink") MESA driver. If you have this globally
enabled, disable it specifically for this game and launch it normally.

### Pandora: First Contact {#pandora_first_contact}

#### Launch issue {#launch_issue}

If the game refuses to launch at start you will need to replace bundled libraries by those from the main system.

Replace the bundled files in the game binaries directory with symlinks to `{{ic|libcurl.so.4.8.0}}`{=mediawiki},
`{{ic|libcurl.so.4}}`{=mediawiki}, `{{ic|libglfw.so.3.4}}`{=mediawiki} and `{{ic|libglfw.so.3}}`{=mediawiki} from
`{{ic|/usr/lib/}}`{=mediawiki} to allow the game to launch as normal.

```{=mediawiki}
{{Note|Some systems will not have {{Pkg|glfw}} pre-installed: you will need to [[install]] it, then the files will be available in {{ic|/usr/lib/}}.}}
```
### Penumbra: Overture {#penumbra_overture}

Dependencies:

-   ```{=mediawiki}
    {{Pkg|lib32-glu}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libvorbis}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libxft}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-openal}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-sdl_image}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-sdl_ttf}}
    ```

#### Windowed mode {#windowed_mode_1}

There is no in-game option to change to the windowed mode, you will have to edit
`{{ic|~/.frictionalgames/Penumbra/Overture/settings.cfg}}`{=mediawiki} to activate it.

Find `{{ic|1=FullScreen="true"}}`{=mediawiki} and change it to `{{ic|1=FullScreen="false"}}`{=mediawiki}, after this the
game should start in windowed mode.

### Portal 2 {#portal_2}

#### Game does not start {#game_does_not_start_10}

Several OpenGL-related errors (such as
`{{ic|PROBLEM: You appear to have OpenGL 1.4.0, but we need at least 2.0.0!}}`{=mediawiki} or
`{{ic|libGL error: driver pointer missing}}`{=mediawiki}) are caused by Portal 2 bundling an old libstdc++ file. This
error is especially common with open source Radeon drivers (`{{ic|radeonsi}}`{=mediawiki}).

A problem with libstdc can be fixed by running the game with
`{{ic|1=LD_PRELOAD='/usr/$LIB/libstdc++.so.6'}}`{=mediawiki}.

#### Resolution too low {#resolution_too_low}

When the game starts with a resolution so low that you cannot reach the game settings, run the game in windowed mode
using the `{{ic|-windowed}}`{=mediawiki} flag.

#### Missing non Latin font {#missing_non_latin_font}

The phenomenon is no menu in Portal. Portal and Portal2 use Helvetica, add the following lines to
`{{ic|~/.config/fontconfig/fonts.conf}}`{=mediawiki}:

`<match target="pattern">`{=html}\
`    ``<test qual="any" name="family">`{=html}\
`        ``<string>`{=html}`Helvetica``</string>`{=html}\
`    ``</test>`{=html}\
`    ``<edit name="family" mode="assign" binding="same">`{=html}\
`        ``<string>`{=html}`Source Han Sans CN``</string>`{=html}\
`    ``</edit>`{=html}\
`</match>`{=html}

You can replace \"Source Han Sans CN\" by your favoriate and existing font.

### Prison Architect {#prison_architect}

#### ALSA error when using PulseAudio or PipeWire {#alsa_error_when_using_pulseaudio_or_pipewire}

The error:

`ALSA lib pcm_dmix.c:1018:(snd_pcm_dmix_open) unable to open slave`

was resolved by installing:

-   ```{=mediawiki}
    {{Pkg|pulseaudio-alsa}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libpulse}}
    ```

-   ```{=mediawiki}
    {{Pkg|pipewire-alsa}}
    ```

per [PulseAudio#ALSA](PulseAudio#ALSA "wikilink").

Alternatively, if running the game through Steam, you can force the game to be ran through proton, and that can resolve
other audio errors.

You can do this by opening the game\'s properties through steam, and under \"general\" tick the \"Force the use of a
specific Steam Play comparability tool\", and then select a proton version from the dropdown below

#### Game only starting in safe mode {#game_only_starting_in_safe_mode}

If the game does not start, but Steam thinks it is running, probably the Paradox launcher has problems running properly.
If this is the case, you will find some processes running in background:

```{=mediawiki}
{{ic|$ ps -ef {{!}}
```
grep paradoxlauncher}}

Kill them all, then modify the game startup options as follows:

`LD_PRELOAD=/usr/lib64/libc.so %command%`

Eventually, if the above option has not worked, an option to skip it:

`./PrisonArchitect %command%`

Note: even if we are using another executable to start the game, `{{ic|%command%}}`{=mediawiki} has to be added at the
end of the command to trick Steam.

### Project Zomboid {#project_zomboid}

#### No sound {#no_sound_5}

Prepend `{{ic|/usr/lib}}`{=mediawiki} to `{{ic|LD_LIBRARY_PATH}}`{=mediawiki}.

In the game, go to the options and set all audio to the proper volume.

### Redshirt

Requires `{{Pkg|lib32-libpulse}}`{=mediawiki} if you use PulseAudio.

### Revenge of the Titans {#revenge_of_the_titans}

Requires `{{Pkg|libxtst}}`{=mediawiki} and `{{Pkg|lib32-libxtst}}`{=mediawiki}.

### Rise of the Tomb Raider {#rise_of_the_tomb_raider}

Run in an X session.

#### Game does not start {#game_does_not_start_11}

If running in X session is not available or is not preferred, another alternative is to create the script:

```{=mediawiki}
{{hc|/usr/local/bin/pulseaudio|
#!/bin/sh
exit 0
}}
```
and make it [executable](executable "wikilink").

After this the game was found to have loaded on Linux according to some game testers.

### Risk of Rain {#risk_of_rain}

Refer to [#Missing libcurl.so.4 or version CURL_OPENSSL_3 not
found](#Missing_libcurl.so.4_or_version_CURL_OPENSSL_3_not_found "wikilink").

### Rock Boshers DX: Directors Cut {#rock_boshers_dx_directors_cut}

Requires `{{Pkg|lib32-libcaca}}`{=mediawiki}.

### Saints Row: The Third {#saints_row_the_third}

#### Impossible to save custom display settings {#impossible_to_save_custom_display_settings}

Although game settings menu allows to choose custom display settings, the game may have problems saving them.

In such case, adjust these settings manually in the game\'s configuration file
`{{ic|~/.local/share/Steam/steamapps/common/Saints Row the Third/display.ini}}`{=mediawiki}.

The comments in this file explain well all the settings and acceptable values.

#### Incorrect screen resolution in game {#incorrect_screen_resolution_in_game}

This can occur when game is launched in a multi-head environment, with some monitors rotated, etc., so the game detects
available screen resolutions incorrectly.

In such case, adjust `{{ic|ResolutionWidth}}`{=mediawiki} and `{{ic|ResolutionHeight}}`{=mediawiki} options in the
`{{ic|display.ini}}`{=mediawiki} file. Also, one must set option `{{ic|1=VerifyResolution = false}}`{=mediawiki}.

### Saints Row IV {#saints_row_iv}

#### Game fails to launch after update to new NVIDIA drivers {#game_fails_to_launch_after_update_to_new_nvidia_drivers}

```{=mediawiki}
{{Accuracy|General settings not specific to this game}}
```
Run the game with `{{ic|/usr/lib32/libGLX_nvidia.so}}`{=mediawiki} appended to the `{{ic|LD_PRELOAD}}`{=mediawiki}.

#### Game causes GPU lockup with mesa drivers {#game_causes_gpu_lockup_with_mesa_drivers}

Saints Rows IV can cause a GPU lockup when trying to play on certain AMD hardware using open source drivers: [Bug
93475](https://bugs.freedesktop.org/show_bug.cgi?id=93475).

A workaround is to run the game with `{{ic|1=R600_DEBUG=nosb}}`{=mediawiki}.

### Serious Sam 3: BFE {#serious_sam_3_bfe}

#### No audio {#no_audio_1}

Try running:

`# mkdir -p /usr/lib/i386-linux-gnu/alsa-lib/`\
`# ln -s /usr/lib32/alsa-lib/libasound_module_pcm_pulse.so /usr/lib/i386-linux-gnu/alsa-lib/`

If that does not work, try tweaking `{{ic|~/.alsoftrc}}`{=mediawiki} as proposed by the [Steam
community](https://steamcommunity.com/app/221410/discussions/3/846940248238406974/) (Serious Sam 3: BFE uses OpenAL to
output sound). If you are not using PulseAudio, you may want to write the following configuration:

```{=mediawiki}
{{hc|~/.alsoftrc|2=
[general]
drivers = alsa
[alsa]
device = default
capture = default
mmap = true
}}
```
### SJ-19 Learns to Love {#sj_19_learns_to_love}

If the game crashes at startup with this error in Steam\'s output:

`/home/`*`username`*`/.local/share/Steam/steamapps/common/SJ-19 Learns To Love/sj-19-linux/sj-19-learns-to-love.x86_64: error while loading shared libraries: libsteam_api.so: cannot open shared object file: No such file or directory`

Right click the game in steam, select Properties, and set this in Launch Options:

`LD_LIBRARY_PATH=./sj-19-linux %command%`

### Slay the Spire {#slay_the_spire}

If the game does not start or crashes at startup, install `{{Pkg|xorg-xrandr}}`{=mediawiki}.

If the game crashes with the xrandr stacktrace:

```{=mediawiki}
{{bc|<nowiki>
Caused by: java.lang.ArrayIndexOutOfBoundsException: 0
at org.lwjgl.opengl.XRandR.findPrimary(XRandR.java:326)
at org.lwjgl.opengl.XRandR.ScreentoDisplayMode(XRandR.java:315)
</nowiki>}}
```
It is likely due to a [known bug in LWJGL](https://github.com/LWJGL/lwjgl/issues/112#issuecomment-291598776). The
workaround is to change the xrandr configuration to only contain the resolution (For example:
`{{ic|2560x1440_60.00}}`{=mediawiki} should become `{{ic|2560x1440}}`{=mediawiki}.

If the game does not move sink input, you can edit the following file to allow sink moves:

```{=mediawiki}
{{hc|~/.alsoftrc|<nowiki>
[pulse]
allow-moves=yes
</nowiki>}}
```
### Stick Fight: The Game {#stick_fight_the_game}

If the game does not launch, try appending `{{ic|1=PROTON_USE_WINED3D=1 %command%}}`{=mediawiki} to force using WINE
direct3D. To do this you must have `{{Pkg|wine}}`{=mediawiki} installed.

### Songbringer

#### Launch error with Wayland {#launch_error_with_wayland}

Install `{{Pkg|glfw}}`{=mediawiki} and run the game with `{{ic|1=LD_PRELOAD=/usr/lib/libglfw.so.3}}`{=mediawiki}.

### Space Pirates and Zombies {#space_pirates_and_zombies}

Requires `{{Pkg|lib32-openal}}`{=mediawiki}.

#### No audio {#no_audio_2}

Try running:

`# mkdir -p /usr/lib/i386-linux-gnu/alsa-lib/`\
`# ln -s /usr/lib32/alsa-lib/libasound_module_pcm_pulse.so /usr/lib/i386-linux-gnu/alsa-lib/`

If that does not work, try tweaking `{{ic|~/.alsoftrc}}`{=mediawiki} as proposed by the Steam community (Serious Sam 3:
BFE uses OpenAL to output sound). If you are not using PulseAudio, you may want to write the following configuration:

```{=mediawiki}
{{hc|~/.alsoftrc|2=
[general]
drivers = alsa
[alsa]
device = default
capture = default
mmap = true
}}
```
### Spacechem

Dependencies:

-   ```{=mediawiki}
    {{Pkg|lib32-sdl_mixer}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-sdl_image}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-sqlite}}
    ```

#### Game crash {#game_crash}

The shipped x86 version of Spacechem does not work on x64 with the game\'s own libSDL\* files, and crashes with some
strange output.

To solve this just remove the three files `{{ic|libSDL-1.2.so.0}}`{=mediawiki},
`{{ic|libSDL_image-1.2.so.0}}`{=mediawiki}, `{{ic|libSDL_mixer-1.2.so.0}}`{=mediawiki} from the game directory.

### Splice

Requires `{{Pkg|glu}}`{=mediawiki}.

### The Stanley Parable {#the_stanley_parable}

#### Game will not start {#game_will_not_start}

As discussed in the Steam store page, remove `{{ic|bin/libstdc++.so.6}}`{=mediawiki} from the game directory.

### Shadow Tactics: Blades of the Shogun {#shadow_tactics_blades_of_the_shogun}

Dependencies:

-   ```{=mediawiki}
    {{AUR|lib32-libstdc++5}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libxcursor}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libxrandr}}
    ```

### Stardew Valley {#stardew_valley}

#### Unable to move or input text {#unable_to_move_or_input_text}

When in game, you are stuck in your bed as you cannot move your character or you cannot enter text into the input fields
when starting a new game. This is a bug with the SDL2 lib bundled with the game.

Install `{{AUR|sdl2}}`{=mediawiki}.

Modify this config line: `{{hc|~/.steam/steam/steamapps/common/Stardew\ Valley/MonoGame.Framework.dll.config|<nowiki>
<dllmap dll="SDL2.dll" os="linux" cpu="x86-64" target="./lib64/libSDL2-2.0.so.0"/>
</nowiki>}}`{=mediawiki}

To this (the period is removed at the beginning of target):
`{{hc|~/.steam/steam/steamapps/common/Stardew\ Valley/MonoGame.Framework.dll.config|<nowiki>
<dllmap dll="SDL2.dll" os="linux" cpu="x86-64" target="/lib64/libSDL2-2.0.so.0"/>
</nowiki>}}`{=mediawiki}

### Steel Storm: Burning Retribution {#steel_storm_burning_retribution}

#### Start with black screen {#start_with_black_screen}

The game by default tries to launch in fullscreen mode with a resolution of 1024x768, which does not work on some
devices (for example the Samsung Series9 laptop with Intel hd4000 video).

Run the game in windowed mode by using the `{{ic|-window}}`{=mediawiki} flag. Then change the resolution in-game.

### Stellaris

#### No window opening, only sound {#no_window_opening_only_sound}

Happens with some AMD GPU and mesa combination, set `{{ic|1=multi_sampling=0}}`{=mediawiki} in
`{{ic|~/.local/share/Paradox Interactive/Stellaris/settings.txt}}`{=mediawiki}.

On some window managers (e.g. Xmonad) you should set `{{ic|1=fullScreen=no}}`{=mediawiki}.

#### Immediate crash to desktop {#immediate_crash_to_desktop}

##### Steam using Proton instead of Linux Runtime {#steam_using_proton_instead_of_linux_runtime}

To diagnose, run Steam in a terminal and launch Stellaris. Ignore any errors mentioning \"LD_PRELOAD\" and look for this
error:

`/home/`*`username`*`/.local/share/Steam/steamapps/common/Stellaris/dowser.exe: /home/`*`username`*`/.local/share/Steam/steamapps/common/Stellaris/dowser.exe: cannot execute binary file`

If you see that error then the solution is to force Steam to use the Linux runtime for Stellaris:

1.  Right-click on Stellaris and select \"Properties\...\"
2.  Select the \"Compatibility\" tab.
3.  Select \"Force the use of a specific Steam Play compatibility tool\".
4.  Select \"Steam Linux Runtime 1.0 (scout)\"

##### Missing libnss_sss.so.2 {#missing_libnss_sss.so.2}

It seems that Stellaris requires a 32bit libnss_sss.so.2 to operate. You can confirm if this is your problem by running

`$ strace ~/.local/share/Steam/steamapps/common/Stellaris/stellaris 2>&1 | grep sss`

and seeing if you get output like

`openat(AT_FDCWD, "/usr/lib32/tls/i686/sse2/libnss_sss.so.2", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = -1 ENOENT (No such file or directory)`

If this is indeed your problem, download the libnss-sss package from Ubuntu\'s repository
[22](https://packages.ubuntu.com/bionic/i386/libnss-sss/download), extract the libnss_sss.so.2 from the downloaded
package, and place it at \~/.local/share/Steam/steamapps/common/Stellaris. The game should now load properly.

#### Game instantly crashes to desktop on Wayland {#game_instantly_crashes_to_desktop_on_wayland}

Append `{{ic|1=SDL_VIDEODRIVER=x11}}`{=mediawiki} to your launch options.

#### Launcher is blank {#launcher_is_blank}

This is a recurring problem on Linux following the Machine Age expansion. If this happens to you, back up all your
custom empires and savegames (found in `{{ic|$XDG_DATA_HOME/Paradox Interactive/Stellaris/}}`{=mediawiki} and
`{{ic|$XDG_DATA_HOME/Steam/userdata/''your_user_ID''/281990/remote/}}`{=mediawiki} for cloud saves). If you have no
other Paradox games installed, then remove the Paradox Interactive directory underneath
`{{ic|$XDG_DATA_HOME/}}`{=mediawiki}.

If you have other Paradox games installed, then do not remove the entire Paradox directory. Just remove the Stellaris
directory and the launcher-v2 directory.

Attempt to run the game again. The launcher should open normally after re-downloading. Once the game launches properly,
close the game and put your empires and savegames back in their directories from where you got them.

### Stephen\'s Sausage Roll {#stephens_sausage_roll}

#### No sound {#no_sound_6}

If using [native libraries](Steam/Troubleshooting#Steam_native_runtime "wikilink") and `{{Pkg|libpulse}}`{=mediawiki} is
installed, Unity may try to use that library for sound and fail. To test if this is the problem, try removing
`{{Pkg|libpulse}}`{=mediawiki} or renaming the package files that are named `{{ic|libpulse-simple*}}`{=mediawiki}. To
see which `{{Pkg|libpulse}}`{=mediawiki} files are relevant, run:

```{=mediawiki}
{{hc|$ pacman -Qql libpulse {{!}}
```
grep /usr/lib/libpulse-simple\| /usr/lib/libpulse-simple.so /usr/lib/libpulse-simple.so.0
/usr/lib/libpulse-simple.so.0.1.0 }}

If renaming any of those files works for you, you can proceed with the following instructions (revert any renaming you
just did). Browse to the game\'s directory:

`$ cd "$HOME/.steam/root/steamapps/common/Stephen's Sausage Roll"`

And create a sub-directory that we can use to hold 0-byte look-alike library files:

`$ mkdir noload/`

Use `{{ic|touch}}`{=mediawiki} to create 0-byte versions of the above files that we want the dynamic linker to skip,
e.g.:

`$ touch noload/{libpulse-simple.so,libpulse-simple.so.0,libpulse-simple.so.0.1.0}`

```{=mediawiki}
{{Note|Only a 0-byte {{ic|libpulse-simple.so.0}} file may be required.}}
```
After you have created these 0-byte files, you can now attempt to run the game binary directly, telling the dynamic
linker to use our 0-byte files:

`$ LD_LIBRARY_PATH="noload/:$LD_LIBRARY_PATH" ./Sausage.x86_64`

If everything works up to this point, prepend `{{ic|noload/}}`{=mediawiki} to your `{{ic|LD_LIBRARY_PATH}}`{=mediawiki}.

Again, this should work because Steam checks for a `{{ic|noload/}}`{=mediawiki} directory relative to the game\'s
directory. The dynamic linker should respect the `{{ic|$LD_LIBRARY_PATH}}`{=mediawiki} variable and fail to load the
necessary `{{Pkg|libpulse}}`{=mediawiki} files. The game should then fallback to plain ALSA.

### Superbrothers: Sword & Sworcery EP {#superbrothers_sword_sworcery_ep}

Dependencies:

-   ```{=mediawiki}
    {{Pkg|lib32-glu}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libpulse}}
    ```
    if you use PulseAudio

The game bundles an outdated version of libstdc++ which prevents the game from starting.
[23](https://steamcommunity.com/app/204060/discussions/0/364039785161291413) The following can be observed when you run
Steam and S&S from the terminal:

`libGL error: unable to load driver: i965_dri.so`\
`libGL error: driver pointer missing`\
`libGL error: failed to load driver: i965`\
`libGL error: unable to load driver: i965_dri.so`\
`libGL error: driver pointer missing`\
`libGL error: failed to load driver: i965`\
`libGL error: unable to load driver: swrast_dri.so`\
`libGL error: failed to load driver: swrast`

To solve this problem remove `{{ic|''GAME''/lib/libstdc++.so.6*}}`{=mediawiki}. After that the game will use the
libstdc++ from Steam.

### System Shock 2 {#system_shock_2}

You get these errors when running it with the native client:

`C:\windows\system32\winedevice.exe: symbol lookup error: /usr/lib32/libX11.so.6: undefined symbol: xcb_wait_for_reply64`\
`C:\windows\system32\wineboot.exe: symbol lookup error: /usr/lib32/libX11.so.6: undefined symbol: xcb_wait_for_reply64`

Just delete or rename the libxcb library it got shipped with:

`mv /mnt/olhdd/steam/steamapps/common/SS2/lib/libxcb.so.1{,.old}`\
`mv /mnt/olhdd/steam/steamapps/common/SS2/lib/libxcb.so.1.1.0{,.old}`

#### Game does not launch {#game_does_not_launch}

If you encounter the game not launching, do the following:

1.  Move `{{ic|libsteam_api.so}}`{=mediawiki} from the `{{ic|SS2/Bin}}`{=mediawiki} directory within the main Steam
    common directory and transfer it to the `{{ic|SS2}}`{=mediawiki} main game directory, not the
    `{{ic|SS2/Bin}}`{=mediawiki} subdirectory.
2.  Put `{{ic|1=LD_PRELOAD='/usr/$LIB/libxcb.so.1' %command%}}`{=mediawiki} into the [launch
    options](launch_option "wikilink").

Once all of these have been implemented, the game should work.

#### Resolution fix {#resolution_fix}

You may encounter some resolution problems with this game on Steam not working properly in full screen mode. Do the
following:

1.  Open `{{ic|cam.cfg}}`{=mediawiki} in the `{{ic|SS2}}`{=mediawiki} directory, you may have to search for it via the
    search mode while in the game directory.
2.  Place `{{ic|game_screen_size 1024 768}}`{=mediawiki} or `{{ic|game_screen_size 1920 1080}}`{=mediawiki} depending on
    your resolution and put `{{ic|game_full_screen 1}}`{=mediawiki} into bottom of the `{{ic|cam.cfg}}`{=mediawiki}
    file.
3.  Go to `{{ic|cam_ext.cfg}}`{=mediawiki} and next to the display setting place a semicolon prefix next to the
    `{{ic|use_d3d_display}}`{=mediawiki} option so it should be like this: `{{ic|;use_d3d_display}}`{=mediawiki}

It should then properly not go off-screen and should stay full screen within the active main screen.

### Sven Co-op {#sven_co_op}

#### No sound in-game (FMOD ex error code 60) {#no_sound_in_game_fmod_ex_error_code_60}

If using [PipeWire](PipeWire "wikilink"), make sure you have installed `{{Pkg|lib32-pipewire}}`{=mediawiki}.

### Tabletop Simulator {#tabletop_simulator}

#### CJK characters not showing in game {#cjk_characters_not_showing_in_game}

Install `{{Pkg|wqy-microhei}}`{=mediawiki} and `{{Pkg|wqy-microhei-lite}}`{=mediawiki}.

### Team Fortress 2 {#team_fortress_2}

As of an update in September 2023, the game will not have the correct version of `{{ic|tcmalloc}}`{=mediawiki} and will
silently crash during launch.

Follow the fix outlined in [#tcmalloc.cc error in Source 1 games](#tcmalloc.cc_error_in_Source_1_games "wikilink")

#### HRTF setup {#hrtf_setup}

Assuming HRTF (head-related transfer function) has been properly set up in the operating system, HRTF will not be
enabled unless you disable the original processing. To do so, add this to your autoexec

`dsp_slow_cpu 1`

For best results, also change the following:

`snd_spatialize_roundrobin 1`\
`dsp_enhance_stereo 0`\
`snd_pitchquality 1`

#### Loading screen freeze {#loading_screen_freeze}

If you are a non-English (speaking) user, you have to enable \"en_US.UTF-8\" in the locale.gen! Generate a new locale
after that.

#### No audio {#no_audio_3}

It happens if there is no PulseAudio in your system. If you want to use [ALSA](ALSA "wikilink"), you need to launch
Steam or the game directly with `{{ic|1=SDL_AUDIODRIVER=alsa}}`{=mediawiki} (From
[SteamCommunity](https://steamcommunity.com/app/221410/discussions/0/882966056462819091/#c882966056470753683)).

If it still does not work, you may also need to set the environment variable AUDIODEV. For instance
`{{ic|1=AUDIODEV=Live}}`{=mediawiki}. Use `{{ic|aplay -l}}`{=mediawiki} to list the available sound cards.

#### Slow loading textures {#slow_loading_textures}

If you are using Chris\' FPS Configs or any other FPS config, you may have set `{{ic|mat_picmip}}`{=mediawiki} to
`{{ic|2}}`{=mediawiki}. This spawns multiple threads for texture loading, which may cause more jittering and lag on
Linux, especially on alternative kernels. Try setting it to `{{ic|-1}}`{=mediawiki}, the default.

#### \"Invalid color format\" Error at loading screen on integrated Intel Atom/BayTrail HD Graphics {#invalid_color_format_error_at_loading_screen_on_integrated_intel_atombaytrail_hd_graphics}

Add the following to the game startup options:

`-force_vendor_id 0x10DE -force_device_id 0x1180`

These options deceive the game engine that we are having a NVIDIA GPU, not Intel/AMD.

#### Wrong mouse sensitivity {#wrong_mouse_sensitivity}

TF2 ships with an old version of libSDL2.so. Following
[mastercomfig](https://docs.mastercomfig.com/page/os/linux/#native-libraries)\'s guide helps using the Steam Runtime
instead of using the bundled libSDL2 version and updates the Steam Runtime by using the Distribution shipped version.

### Terraria

See the KNOWN ISSUES & WORKAROUNDS​ section of the [release
announcement](https://forums.terraria.org/index.php?threads/terraria-1-3-0-8-can-mac-linux-come-out-play.30287/).

#### Input Issues {#input_issues}

The symptoms of this problem are: When moving after standing still, your character seems to vary their speed, if wearing
running boots they do not activate. When jumping with an item for double jumping sometimes you double jump even if you
just jumped once. Going up/down ropes seems slow/choppy.

The solution is to preload the system SDL2 libraries:
`{{ic|1=LD_PRELOAD='/usr/$LIB/libSDL2-2.0.so:/usr/lib32/libSDL2-2.0.so' }}`{=mediawiki} For more information: [Terraria
Forums](https://forums.terraria.org/index.php?threads/keyboard-input-bug-involving-linux.56763/page-2#post-1533051)`{{Dead link|2021|05|17|status=403}}`{=mediawiki}

### This War of Mine {#this_war_of_mine}

#### Game does not start {#game_does_not_start_12}

This happens because of an incompatibility with the newer version of `{{ic|lib32-curl}}`{=mediawiki}. To fix the
problem, set your [launch options](launch_option "wikilink") to:

`LD_PRELOAD=./libcurl.so.4 %command%`

#### Sound glitches with Steam native {#sound_glitches_with_steam_native}

The bundled `{{ic|libOpenAL}}`{=mediawiki} might not work correctly, try symlinking
`{{ic|/usr/lib32/libopenal.so}}`{=mediawiki} to `{{ic|''GAME''/libOpenAL.so}}`{=mediawiki}.

### Ticket to Ride {#ticket_to_ride}

```{=mediawiki}
{{Out of date|{{AUR|lib32-gstreamer0.10-base}}{{Broken package link|package not found}} is [https://lists.archlinux.org/hyperkitty/list/aur-requests@lists.archlinux.org/message/JIP24NM32G52WITZO7C2BPFL7B7LDLWA/ flagged for deletion] and does not exist in the multilib-alucryd repository.}}
```
Dependencies:

-   ```{=mediawiki}
    {{AUR|lib32-gstreamer0.10-base}}
    ```
    ```{=mediawiki}
    {{Broken package link|package not found}}
    ```

-   ```{=mediawiki}
    {{AUR|lib32-pangox-compat}}
    ```

As lib32-gstreamer0.10-base is quite hard to build you can use
[multilib-alucryd](Unofficial_user_repositories#alucryd "wikilink") repo for this package

### The Tiny Bang Story {#the_tiny_bang_story}

#### Missing libGLEW.so.1.6 {#missing_libglew.so.1.6}

`# ln -s /usr/lib32/libGLEW.so.1.10.0 /usr/lib32/libGLEW.so.1.6`

### Tomb Raider (2013) {#tomb_raider_2013}

#### Game immediately closes {#game_immediately_closes}

Tomb Raider has a very heavy amount of dependency on the Steam runtime, the easiest solution is to just run it using the
runtime.

If this does not solve the problem, look up the shared library dependencys of the main executable. Go into your steam
directory and do

`$ ldd steamapps/common/Tomb\ Raider/bin/TombRaider | grep found`

Note all missing librarys and try installing them from the standard repositories and the AUR. If after that you are
still missing librarys you can search on the web for them and download corresponding packaged *.rpm* x86 (32bit) files
and extract them into `{{ic|steamapps/common/Tomb\ Raider/lib/i686/}}`{=mediawiki} to provide the missing librarys. Run
*ldd* again and see whether you have all the necessary librarys installed. If there are no more missing librarys and the
added librarys are of the correct version, architecture and 32/64bit word length and are placed on one of the linkers
search paths then the game should work.

Another alternative to this is to do the following in the Launch options:

`LD_LIBRARY_PATH="$HOME/.local/share/Steam/steamapps/common/Tomb Raider/lib/i686:$LD_LIBRARY_PATH" %command%`

#### Steam Controller not working in-game {#steam_controller_not_working_in_game}

If your Steam Controller is correctly recognized and paired but still not working in-game try the following:

-   In Steam, non Big Screen, go to *Settings \> Account \> Beta participation \> Change\...* and in the dropdown select
    box select Steam Beta Update
-   Restart Steam
-   Go to Big Screen and start Tomb Raider

Correctly recognized means you can control the desktop mouse and Steam in Big Picture mode and the controller is shown
in the Big Picture settings.

#### Failed to Initialize Direct3D {#failed_to_initialize_direct3d}

This can happen when switching monitors.

You need to manually edit the preferences file (found in \~/.local/share/feral-interactive/Tomb Raider/) and change the
ExclusiveFullscreen option to 0. After this you should be able to successfully start the game (after which you may exit
and revert that option to a 1 to restore fullscreen).

#### Stuck at the start menu {#stuck_at_the_start_menu}

Tomb Raider for Linux will not start if there are any active VPNs that use TUN devices. This is because it makes
incorrect assumptions about the return value of `{{ic|getifaddrs()}}`{=mediawiki}. The only reason it calls
`{{ic|getifaddrs()}}`{=mediawiki} is to get the MAC address for a Version 1 UUID, and fall back to a different algorithm
if `{{ic|getifaddrs()}}`{=mediawiki} returns no interfaces at all.

One optional solution for such a situation is listed down below, which fixes assumptions made by Tomb Raiders about the
output of `{{ic|getifaddrs()}}`{=mediawiki} (see
[tomb_raider_vpn_fix/releases](https://github.com/PinkPandaKatie/tomb_raider_vpn_fix/releases) for the original code):

```{=mediawiki}
{{bc|1=
#include <stdio.h>
#include <errno.h>
#include <ifaddrs.h>

int getifaddrs(struct ifaddrs **ifap) {
   fprintf(stderr, "\n\n\n---------------- dummied out getifaddrs()!\n\n\n");
   *ifap = NULL;
   return 0;
}

void freeifaddrs(struct ifaddrs *ifap) {
   /* do nothing */
}
}}
```
Compile it using

`$ gcc -m32 -fPIC -shared `*`file_name`*`.c -o `*`file_name`*`.so -ldl -Wall`

Then use the following launch option:

`env LD_PRELOAD=$LD_PRELOAD:`*`path/to/file_name`*`.so %command%`

### Torchlight 2 {#torchlight_2}

#### Libfreetype/libfontconfig Incompatibility {#libfreetypelibfontconfig_incompatibility}

If you are experiencing issues with launching games such as Torchlight 2 or Civilization IV, it could be due to using a
newer libfontconfig than the game currently supports.

Right click the game in Steam, and set the following as its launch option:

`LD_PRELOAD=/usr/lib/libfreetype.so.6 %command%`

then attempt launching the game.

Alternately, re-naming or deleting these 2 files will force it to use your system\'s libraries:

`Torchlight 2/game/lib/libfreetype.so.6`\
`Torchlight 2/game/lib64/libfreetype.so.6`

#### Locale incompatibility {#locale_incompatibility}

Some users report that Torchlight 2 does not work if you do not have en_US.UTF8 in your locale.

Double check you have generated the locale needed in [Steam Installation Requirements](Steam#Installation "wikilink").

### Tower Unite {#tower_unite}

#### Graphical glitches {#graphical_glitches}

This is a known issue, and it occurs because the shaders had not been ported to Linux yet by the developers. To minimize
glitches and make the game playable add `{{ic|-opengl4}}`{=mediawiki} to your [launch
options](launch_option "wikilink"), set Ocean Quality to \"Potato\" and Effects Quality to \"Low\" in the game settings.

### Towns / Towns Demo {#towns_towns_demo}

Requires [Java](Java "wikilink").

### Transistor

#### Crash on launch / FMOD binding crash / audio issues {#crash_on_launch_fmod_binding_crash_audio_issues}

Run the game with:

`LD_PRELOAD='/usr/lib/libstdc++.so.6:/usr/lib/libgcc_s.so.1:/usr/lib/libxcb.so.1:/usr/lib/libasound.so.2'`

Otherwise, run the game via shell and set up proper audio device for FMOD, as discussed in
[24](https://steamcommunity.com/app/237930/discussions/2/620695877176333955/).

Also, check out this thread [25](https://steamcommunity.com/app/237930/discussions/2/492378265893557247/).

#### Game does not start on Wayland {#game_does_not_start_on_wayland}

The game will not start with SDL set to use Wayland. You can have only the game run in X11 by adding the following
launch options in Steam:

`SDL_VIDEODRIVER=x11 %command%`

### Transmissions: Element 120 {#transmissions_element_120}

Dependencies:

-   ```{=mediawiki}
    {{AUR|lib32-libgcrypt15}}
    ```

-   ```{=mediawiki}
    {{AUR|lib32-libpng12}}
    ```

#### Troubleshooting

Make sure you have all libraries installed. Above the standard set required by Steam runtime, the game requires few
additional ones. The typical error message that indicates that is

`AppFramework : Unable to load module vguimatsurface.so!`

To find missing dependencies go into the game directory and run:

`LD_LIBRARY_PATH=bin ldd bin/vguimatsurface.so`

Look for entries that say *not found*.

### Transport Fever 2 {#transport_fever_2}

#### Game will not launch {#game_will_not_launch}

Rename or delete the following files in game directory
(`{{ic|~/.steam/steam/steamapps/common/Transport Fever 2}}`{=mediawiki}) as discussed in
[26](https://steamcommunity.com/app/1066780/discussions/0/1740010344363244243/)

-   ```{=mediawiki}
    {{ic|libstdc++.so.6}}
    ```

-   ```{=mediawiki}
    {{ic|libstdc++.so.6.0.25}}
    ```

### Trine 2 {#trine_2}

#### Sound

```{=mediawiki}
{{Accuracy|General settings not specific to this game}}
```
If sound plays choppy, try:

```{=mediawiki}
{{hc|/etc/openal/alsoft.conf|2=
drivers=pulse,alsa
frequency=48000
}}
```
#### Resolution

If the game resolution is wrong when using a dual monitor setup and you cannot see the whole window edit
`{{ic|~/.frozenbyte/Trine2/options.txt}}`{=mediawiki} and change the options `{{ic|ForceFullscreenWidth}}`{=mediawiki}
and `{{ic|ForceFullscreenHeight}}`{=mediawiki} to the resolution of your monitor on which you want to play the game.

### Tropico 5 {#tropico_5}

#### Blank screen with sound only on startup {#blank_screen_with_sound_only_on_startup}

Run the game with `{{ic|1=MESA_GL_VERSION_OVERRIDE=4.0 MESA_GLSL_VERSION_OVERRIDE=400}}`{=mediawiki}.

### Unbound: Worlds Apart {#unbound_worlds_apart}

If your controller does not work, try selecting the game in your inventory, click the gear icon on the right, then
Properties, Controller, and select Disable Steam Input in the dropdown.

### Unity of Command {#unity_of_command}

Requires `{{Pkg|lib32-pango}}`{=mediawiki}.

#### Squares

If squares are shown instead of text, try removing `{{ic|''GAME''/bin/libpangoft2-1.0.so.0}}`{=mediawiki}.

#### No audio {#no_audio_4}

If you get this error:

`ALSA lib dlmisc.c:254:(snd1_dlobj_cache_get) Cannot open shared library /usr/lib/i386-linux-gnu/alsa-lib/libasound_module_pcm_pulse.so`

Try running:

`# mkdir -p /usr/lib/i386-linux-gnu/alsa-lib/`\
`# ln -s /usr/lib32/alsa-lib/libasound_module_pcm_pulse.so /usr/lib/i386-linux-gnu/alsa-lib/`

### Unity3D

Games based on the Unity3D engine, like *War For The Overworld* or *Pixel Piracy* may need the package
`{{Pkg|lsb-release}}`{=mediawiki} to understand that they run on Linux and work properly.

#### Locale settings {#locale_settings}

Games made in C# often have a problem with some locales (e.g. Russian, German) because developers do not specify
locale-agnostic number formatting. This can result in some game screens loading only partially, problems with online
features or other bugs.

```{=mediawiki}
{{Accuracy|Would this not be fixed with only setting {{ic|1=LC_NUMERIC}}?}}
```
To work around this, run the game with `{{ic|1=LC_ALL=C.UTF-8}}`{=mediawiki}.

Affected games: *FORCED, Gone Home, Ichi, Nimble Quest, Syder Arcade*.

#### Unity 5 sound problems {#unity_5_sound_problems}

The sound system in Unity 5 changed and to be able to play games created with it you must most likely install and run
[PulseAudio](PulseAudio "wikilink").

Another solution is to disable the Steam runtime: in the launch options for the game, write this:
`{{ic|1=LD_LIBRARY_PATH="" %command%}}`{=mediawiki}

Another solution is to prevent Unity from trying to use PulseAudio using `{{AUR|pulsenomore}}`{=mediawiki}. Once it is
installed, use the following as launch options :`{{ic|/usr/bin/pulsenomore %command%}}`{=mediawiki}

Affected games: *Kerbal Space Program, SUPERHOT, ClusterTruck*

#### Game launching on wrong monitor in fullscreen mode {#game_launching_on_wrong_monitor_in_fullscreen_mode_1}

Unity games that do not support monitor selection will most likely launch the game on a wrong monitor.

The problem is that Unity games write the default parameter
`{{ic|1=<pref name="UnitySelectMonitor" type="int">-1</pref>}}`{=mediawiki} to the game config file.

This will lead to the game launching on a non-primary monitor.

When changing to value into `{{ic|1=<pref name="UnitySelectMonitor" type="int">'''0'''</pref>}}`{=mediawiki} for the
according game, the game will start on the correct (primary) monitor.

A Unity game config file usually resides in
`{{ic|~/.config/unity3d/''CompanyName''/''ProductName''/prefs}}`{=mediawiki}.

Affected games: *Cities: Skylines, Tabletop Simulator, Assault Android Cactus, Wasteland 2, Tyranny, Beat Cop*.

Be aware that some games do not support setting that parameter, it will simply be ignored. This is the case for *Pillars
of Eternity*, *Kentucky Route Zero*, *Sunless Sea*.

#### Chinese/Japanese/Korean display bug {#chinesejapanesekorean_display_bug}

Install `{{Pkg|wqy-microhei}}`{=mediawiki} and `{{Pkg|wqy-microhei-lite}}`{=mediawiki}. Then

`$ fc-cache -fv`

#### Game does not respond {#game_does_not_respond}

Add the following line to your [launch options](launch_option "wikilink") :

`SDL_DYNAMIC_API=/usr/lib/libSDL2-2.0.so %command%`

#### No window opens on Wayland {#no_window_opens_on_wayland}

See [Unity3D#No window opens: Desktop is 0 x 0 @ 0 Hz](Unity3D#No_window_opens:_Desktop_is_0_x_0_@_0_Hz "wikilink").

### Unrest

Requires `{{Pkg|fluidsynth}}`{=mediawiki}.

### Volgarr the Viking {#volgarr_the_viking}

Delete the `{{ic|lib}}`{=mediawiki} directory in the game directory to get rid of the libGL errors.

### War Thunder {#war_thunder}

#### No audio {#no_audio_5}

If there is no audio after launching the game, install `{{Pkg|pulseaudio-alsa}}`{=mediawiki}.

#### Blank screen {#blank_screen}

If having a green or blank screen on startup, run the game with
`{{ic|1=MESA_GL_VERSION_OVERRIDE=4.1COMPAT}}`{=mediawiki}.
[27](https://forum.warthunder.com/index.php?/topic/267809-linux-potential-workaround-for-mesa-drivers-black-screen/)`{{Dead link|2023|07|30|status=404}}`{=mediawiki}
[28](http://forum.warthunder.com/index.php?search_term=0030709&app=core&module=search&do=search&fromMainBar=1&search_app=forums%3Aforum%3A920&sort_field=&sort_order=&search_in=posts)`{{Dead link|2020|04|03|status=404}}`{=mediawiki}

#### Launcher fails to auto-close {#launcher_fails_to_auto_close}

When running through Steam a startup option must be set or the War Thunder Launcher will not auto-close when the game
exits. Doing so will prevent it from being reported as the running game on the Steam Community, and more importantly
running up CPU and RAM usage in the background. Put `{{ic|<nowiki>XMODIFIERS="" %command%</nowiki>}}`{=mediawiki} in the
Launch Options/Parameters of War Thunder on Steam.

### Victor Vran {#victor_vran}

#### Launch failure {#launch_failure}

The game might die on launch with the following (or similar) console print:

`Auto configuration failed`\
`4034673992:error:25066067:DSO support routines:DLFCN_LOAD:could not load the shared library:dso_dlfcn.c:185:filename(libssl_conf.so): libssl_conf.so: cannot open shared object file: No such file or directory`

Add the following line to your [launch options](launch_option "wikilink"):

`OPENSSL_CONF=/dev/null %command%`

### Warhammer 40,000: Dawn of War II {#warhammer_40000_dawn_of_war_ii}

Dependencies:

-   ```{=mediawiki}
    {{Pkg|alsa-lib}}
    ```

-   ```{=mediawiki}
    {{AUR|librtmp0}}
    ```

The start script does not point to the right direction of `{{ic|libasound.so.2}}`{=mediawiki}.

To fix it open `{{ic|''GAME''/DawnOfWar2.sh}}`{=mediawiki} and replace the following lines:

```{=mediawiki}
{{bc|<nowiki>HAS_LSB_RELEASE=$(command -v lsb_release)
if [ -n "${HAS_LSB_RELEASE}" ] && [ "$(lsb_release -c | cut -f2)" = "trusty" ]; then
    LD_PRELOAD_ADDITIONS="/usr/lib/x86_64-linux-gnu/libasound.so.2:${LD_PRELOAD_ADDITIONS}"
fi </nowiki>}}
```
with:

```{=mediawiki}
{{bc|1=LD_PRELOAD_ADDITIONS="/usr/lib64/libasound.so.2:${LD_PRELOAD_ADDITIONS}"}}
```
### Wasteland 2 {#wasteland_2}

If Wasteland 2 immediately exits when you try to launch it there may not be enough system file descriptors available. To
increase the descriptor limit, edit `{{ic|/etc/security/limits.conf}}`{=mediawiki} and add the line:

`* hard nofile 524288`

Then reboot for the new limit to take effect, Wasteland 2 should now launch and this setting might also fix other games.

### We Were Here {#we_were_here}

#### Stuck on black screen or logo on launch {#stuck_on_black_screen_or_logo_on_launch}

Add `{{ic|-screen-fullscreen 0}}`{=mediawiki} to launch options.
[29](https://steamcommunity.com/app/582500/discussions/1/1470840994974091613/)

### Worms W.M.D {#worms_w.m.d}

The game includes a script with a minor workaround included in the `{{ic|Run.sh}}`{=mediawiki} script, however this
workaround alone does not usually work. The game seems to be trying to use libraries which depend on out-of date
libraries. It also depends on `{{Pkg|libcurl-gnutls}}`{=mediawiki}. It is unlikely the game will run on modern systems
or be updated again by the developer.

So, editing the script is needed. At the moment (2/2024) the following works on a system, however this may change at any
time (edit `{{ic|STEAM_RUNTIME}}`{=mediawiki} and `{{ic|WORMSWMDINSTALLDIR}}`{=mediawiki} as required):

```{=mediawiki}
{{hc|head=Run.sh|output=
#!/bin/bash

export LOGFILE=${HOME}/wormswmd.log

export LC_ALL=C.UTF-8
export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib"

export STEAM_ROOT=~/.steam
export PLATFORM=bin32
export STEAM_RUNTIME=$STEAM_ROOT/$PLATFORM/steam-runtime

export WORMSWMDINSTALLDIR=${HOME}/.steamapps/steamapps/common/WormsWMD


export LD_PRELOAD="$(
        printf "%s " "$WORMSWMDINSTALLDIR"/lib/libQt5*.so* \
                ${HOME}/.steam/steam/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu/libdbus-1.so.3 \
                ${HOME}/.steam/steam/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu/libdbus-1.so.3.5.8 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libidn.so.11 \
                "$STEAM_RUNTIME"/lib/x86_64-linux-gnu/libgcrypt.so.11 \
                "$STEAM_RUNTIME"/lib/x86_64-linux-gnu/libwrap.so.0 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/librtmp.so.0 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libhogweed.so.4 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libnettle.so.6 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libsndfile.so.1 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libFLAC.so.8 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libpulse.so.0 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libjson.so.0 \
                "$STEAM_RUNTIME"/usr/lib/x86_64-linux-gnu/libpulsecommon-1.1.so \
        lib/libicuuc.so.56
)"


chmod a+x ./Worms\ W.M.Dx64
./Worms\ W.M.Dx64 >> $LOGFILE
}}
```
Now the game should run from Steam using the \"Play Worms W.M.D (Run.sh)\" option.

You may also try to run `{{ic|Worms W.M.Dx64}}`{=mediawiki} directly but this is unlikely to work because of the reasons
stated above, or run the script `{{ic|Run.sh}}`{=mediawiki} from a terminal to see what libraries it is missing
currently if the above script is not working for you.

If the game crashes after playing the intro movies, add the Steam Runtime dbus libraries to the game\'s library
directory (but this is already covered by the `{{ic|LD_PRELOAD}}`{=mediawiki} in the example
`{{ic|Run.sh}}`{=mediawiki}):

`$ ln -s ~/.steam/steam/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu/*dbus* ~/.steam/steam/steamapps/common/WormsWMD/lib`

See also Steam community discussions [30](https://steamcommunity.com/app/327030/discussions/2/133257959065155871/),
[31](https://steamcommunity.com/app/327030/discussions/1/343785380902286766/) and
[32](https://steamcommunity.com/app/327030/discussions/0/4033601726325456210/).

Steam overlay does not seem to work at the moment, possibly the game is still looking for some incompatible libraries.

On some systems there are terrain bugs where holes in terrain are not rendered properly and worms can fall through
terrain unexpectedly. These bugs can make the game unplayable in many situations and there is no known fix for them.

### Witcher 2: Assassin of Kings {#witcher_2_assassin_of_kings}

Dependencies:

-   ```{=mediawiki}
    {{Pkg|lib32-gnutls}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libcurl-compat}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-libcurl-gnutls}}
    ```

-   ```{=mediawiki}
    {{Pkg|lib32-sdl2_image}}
    ```

-   ```{=mediawiki}
    {{AUR|lib32-sdl2}}
    ```

#### Game does not start {#game_does_not_start_13}

The game will not start with SDL set to use wayland. You can have only the game run in x11 by adding the following
launch options in steam:

`SDL_VIDEODRIVER=x11 %command%`

If the game does not run, enable error messages:

`$ LIBGL_DEBUG=verbose ./witcher2`

### Wizardry 6: Bane of the Cosmic Forge {#wizardry_6_bane_of_the_cosmic_forge}

Requires [DOSBox](DOSBox "wikilink").

To fix the crash at start, open `{{ic|''GAME''/dosbox_linux/launch_wizardry6.sh}}`{=mediawiki} and:

1.  comment the line `{{ic|1=export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./libs}}`{=mediawiki}
2.  change the beginning of the line starting with `{{ic|exec ./dosbox}}`{=mediawiki} to
    `{{ic|exec dosbox}}`{=mediawiki}

### World of Goo {#world_of_goo}

#### Changing resolution {#changing_resolution}

To change the game resolution edit the *Graphics display* section in
`{{ic|''GAME''/properties/config.txt}}`{=mediawiki}. For example:

`<!-- Graphics display -->`\
`<param name="screen_width" value="1680" />`{=html}\
`<param name="screen_height" value="1050" />`{=html}\
`<param name="color_depth" value="0" />`{=html}\
`<param name="fullscreen" value="true" />`{=html}\
`<param name="ui_inset" value="10" />`{=html}

### X3: Terran Conflict {#x3_terran_conflict}

#### Game crashes on startup {#game_crashes_on_startup_1}

The game may crash on startup because it is linked to libz version 1.2.9, while the latest version of this library in
Arch Linux is higher. The following message in the terminals appears in this case:

`./X3TC_config: lib/libz.so.1: version 'ZLIB_1.2.9' not found (required by /usr/lib32/libpng16.so.16`

Renaming or removing lib/libz.so.1 may help.

### X Rebirth {#x_rebirth}

#### Game crashes on startup {#game_crashes_on_startup_2}

The game may crash on startup because it is linked to the shadergl function of the game. Do the follow in the
`{{ic|.../steamapps/common/X Rebirth/shadergl/shaders/common.fh}}`{=mediawiki} file.

`--- ./common.fh.orig`\
`+++ ./common.fh`\
\
`@@ -574 +574 @@`\
`-       /*      OUT_COLOR.rgb *= 0.0001; OUT_COLOR.rgb += half3(specstr);/**/   \`\
`+       /*      OUT_COLOR.rgb *= 0.0001; OUT_COLOR.rgb += half3(specstr);*/     \`\
\
`@@ -622 +622 @@`\
`-       /*      OUT_COLOR.rgb *= 0.0001; OUT_COLOR.rgb += LightColor.xyz/ 10;/**/       \`\
`+       /*      OUT_COLOR.rgb *= 0.0001; OUT_COLOR.rgb += LightColor.xyz/ 10;*/ \`

After this workaround is implemented the game should load as normal.

### XCOM

Dependencies:

-   ```{=mediawiki}
    {{AUR|librtmp0}}
    ```

-   ```{=mediawiki}
    {{Pkg|sdl2_image}}
    ```
    (required to enable keyboard functionality in-game)

#### Hangs on startup {#hangs_on_startup}

If you are running a [hybrid graphics](hybrid_graphics "wikilink") system, try:

`__GL_THREADED_OPTIMIZATIONS=0 primusrun %command%`

#### Graphical glitches on Intel HD {#graphical_glitches_on_intel_hd}

XCOM: Enemy Unknown may not recognize the SDL2 shared libraries shipped with the Steam runtime. Check if the binary
finds all required files and install missing packages if necessary (`{{AUR|sdl2}}`{=mediawiki} and
`{{Pkg|sdl2_image}}`{=mediawiki}).

```{=mediawiki}
{{bc|ldd binaries/linux/game.x86_64 | grep "not found"}}
```
### XCOM 2 {#xcom_2}

#### Unable to start with steam native {#unable_to_start_with_steam_native}

needs `{{ic|libgconf-2.so.4}}`{=mediawiki} which is not available in arch repositories, loading it from steams runtime
seems to work.

`LD_PRELOAD="$HOME/.local/share/Steam/ubuntu12_32/steam-runtime/usr/lib/x86_64-linux-gnu/libgconf-2.so.4" %command%`

#### Unable to start needs command line launch option {#unable_to_start_needs_command_line_launch_option}

If having `{{ic|libgconf-2.so.4}}`{=mediawiki} in the game directory but the game still does not work put the following
in the launch options.

`LD_LIBRARY_PATH=./lib/x86_64/:../lib/x86_64/ %command% -allowconsole`

If the above command on Steam does not work for you then its possible that this may work as an alternative.

`LD_LIBRARY_PATH=/usr/lib:$HOME/.local/share/Steam/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu/:$HOME/.steam/steam/steamapps/common/XCOM\ 2/lib/x86_64/ %command%`

## Anti-cheat {#anti_cheat}

Anti-cheat software is a common component of modern games. There are many anti-cheat implementations, most of which
target Windows. Some may work without any further configuration. Consult [are we anti cheat
yet](https://areweanticheatyet.com/) for a comprehensive and crowd-sourced list of games using anti-cheats and their
compatibility with GNU/Linux or Wine/Proton.

### BattlEye

BattlEye is a cross platform anti-cheat software used by Grand Theft Auto: Online. Native runtime binaries can be
installed directly from the Steam store.

```{=mediawiki}
{{Note|BattlEye will degrade system performance unless [[#Split lock detection / mitigation]] is disabled.}}
```
[Category:Gaming](Category:Gaming "wikilink")

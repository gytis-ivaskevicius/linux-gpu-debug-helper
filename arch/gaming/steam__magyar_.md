```{=mediawiki}
{{TranslationStatus (Magyar)|Steam|2025.12.14|856264}}
```
[de:Steam](de:Steam "wikilink") [en:Steam](en:Steam "wikilink") [fi:Steam](fi:Steam "wikilink")
[fr:Steam](fr:Steam "wikilink") [ja:Steam](ja:Steam "wikilink") [pt:Steam](pt:Steam "wikilink")
[ru:Steam](ru:Steam "wikilink") [zh-hans:Steam](zh-hans:Steam "wikilink")
`{{Related articles start (Magyar)}}`{=mediawiki} `{{Related|Steam (Magyar)/Troubleshooting (Magyar)}}`{=mediawiki}
`{{Related|Steam (Magyar)/Game-specific troubleshooting (Magyar)}}`{=mediawiki}
`{{Related|Gaming (Magyar)}}`{=mediawiki} `{{Related|Gamepad (Magyar)}}`{=mediawiki}
`{{Related|List of games (Magyar)}}`{=mediawiki} `{{Related|Gamescope (Magyar)}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

A [Steam](https://store.steampowered.com/about/) egy népszerű játékterjesztő platform, amelyet a Valve fejlesztett ki.

```{=mediawiki}
{{Note (Magyar)|A Steam for Linux kizárólag a legfrissebb Ubuntu vagy Ubuntu LTS verziót támogatja.[https://help.steampowered.com/en/faqs/view/1114-3F74-0B8A-B784][https://github.com/ValveSoftware/steam-for-linux] Ezért ne forduljon a Valve fejlesztőihez támogatásért a Steam Arch Linuxon való használatával kapcsolatos problémák esetén.}}
```
## Telepítés

Engedélyezze a [multilib](multilib_(Magyar) "wikilink") szoftvercsomag-tárolót, és
[telepítse](install_(Magyar) "wikilink") a `{{Pkg|steam}}`{=mediawiki} szoftvercsomagot (ajánlott), vagy alternatívaként
telepítse a `{{AUR|steam-native-runtime}}`{=mediawiki} szoftvercsomagot a Steam futtatásához natív
rendszerfüggvénykönyvtárakkal. Tekintse meg ezzel kapcsolatban a [/Troubleshooting (Magyar)#Steam
runtime](/Troubleshooting_(Magyar)#Steam_runtime "wikilink") című leírást.

```{=mediawiki}
{{Note (Magyar)|Ha Ön először telepíti a Steam szoftvercsomagot, akkor előfordulhat, hogy a 32 bites [[Vulkan (Magyar)|Vulkan]] alkalmazásprogramozási interfészt tartalmazó szoftvercsomagot kéri az operációs rendszer. Alapértelmezés szerint a [[pacman (Magyar)|pacman]] ábécérendben a {{Pkg|lib32-nvidia-utils}} szoftvercsomagot választja ki a feltelepítéshez, ami problémákat okozhat, például teljesen használhatatlanná teheti a Vulkan alkalmazásprogramozási interfészt, ha véletlenül Ön más GPU gyártóhoz telepíti.}}
```
Ahhoz, hogy a Steam futni tudjon az Arch Linux operációs rendszeren, a következőkre van szükség:

-   Telepíteni kell az Ön operációs rendszerének megfelelő [OpenGL grafikus
    illesztőprogram](Xorg#Driver_installation "wikilink") 32 bites verzióját.
-   Ha ez még nem történt meg [a telepítés során](Installation_guide_(Magyar)#Nyelvterület_beállítása "wikilink"), akkor
    Önnek [létre kell hoznia az en_US.UTF-8 nyelvterületi beállítást](Locale#Generating_locales "wikilink"), annak
    érdekében, hogy elkerülje az érvénytelen pointerhibákat.
-   Ha Önnek függvénykönyvtárak könyvtárait kell hozzáadnia, vagy ha olyan játékokat szeretne hozzáadni a Steam
    könyvtárához amelyek nem Steam alapúak, akkor telepítse az [XDG Desktop Portal](XDG_Desktop_Portal "wikilink")
    szoftvercsomagot egy olyan háttérszoftverrel, amely fájlkiválasztót biztosít.
-   Ha Ön a [systemd-resolved](systemd-resolved_(Magyar) "wikilink") szolgáltatást használja DNS névfeloldáshoz, akkor
    kövesse [a lépéseket](systemd-resolved_(Magyar)#DNS "wikilink") a `{{ic|/etc/resolv.conf}}`{=mediawiki} javításához,
    hogy a Steam képes legyen feloldani a gépneveket.
-   Ha Ön a Big Picture Mode grafikai felületet (Steam Deck UI) használja, akkor előfordulhat, hogy a
    [NetworkManager](NetworkManager_(Magyar) "wikilink") szükséges ahhoz, hogy a hálózattal kapcsolatos panelek
    megfelelően működjenek.
-   A `{{ic|vm.max_map_count}}`{=mediawiki} értékét növelni kell ahhoz, hogy bizonyos játékok összeomlás nélkül
    fussanak. Részletekért tekintse meg a [Gaming#Increase
    vm.max_map_count](Gaming#Increase_vm.max_map_count "wikilink") című leírást.

### SteamCMD

[Install](Install "wikilink") `{{AUR|steamcmd}}`{=mediawiki} for [the command-line version of
Steam](https://developer.valvesoftware.com/wiki/SteamCMD).

## Directory structure {#directory_structure}

The default Steam install location is `{{ic|~/.local/share/Steam}}`{=mediawiki}. If Steam cannot find it, it will prompt
you to reinstall it or select the new location. This article uses the `{{ic|~/.steam/root}}`{=mediawiki} symlink to
refer to the install location.

### Library folders {#library_folders}

Every Steam application has a unique AppID, which you can find by either looking at its [Steam
Store](https://store.steampowered.com/) page path or visiting [SteamDB](https://steamdb.info/).

Steam installs games into a directory under `{{ic|''LIBRARY''/steamapps/common/}}`{=mediawiki}.
`{{ic|''LIBRARY''}}`{=mediawiki} normally is `{{ic|~/.steam/root}}`{=mediawiki} but you can also have multiple library
folders (*Steam \> Settings \> Storage \> (+) Add Drive*).

In order for Steam to recognize a game it needs to have an `{{ic|appmanifest_''AppId''.acf}}`{=mediawiki} file in
`{{ic|''LIBRARY''/steamapps/}}`{=mediawiki}. The appmanifest file uses the
[KeyValues](https://developer.valvesoftware.com/wiki/KeyValues) format and its `{{ic|installdir}}`{=mediawiki} property
determines the game directory name.

```{=mediawiki}
{{Note (Magyar)|In order to add additional drives to a Steam installation made through flathub, the user must first give the Steam Client authorization to access the mount-point of the additional drive manually through a tool such as {{AUR|flatseal}}.}}
```
## Használat

`steam [ -options ] [ `[`steam://`](steam://)` URL ]`

For the available command-line options see the [Command Line Options article on the Valve Developer
Wiki](https://developer.valvesoftware.com/wiki/Command_Line_Options#Steam_.28Windows.29).

Steam also accepts an optional Steam URL, see the [Steam browser
procotol](https://developer.valvesoftware.com/wiki/Steam_browser_protocol).

## Launch options {#launch_options}

When you launch a Steam game, Steam executes its **launch command** with `{{ic|/bin/sh}}`{=mediawiki}. To let you alter
the launch command Steam provides **launch options**, which can be set for a game by right-clicking on it in your
library, selecting Properties and clicking on *Set Launch Options*.

By default Steam simply appends your option string to the launch command. To set environment variables or pass the
launch command as an argument to another command you can use the `{{ic|%command%}}`{=mediawiki} substitute.

### Examples

-   only arguments: `{{ic|-foo}}`{=mediawiki}
-   environment variables: `{{ic|1=FOO=bar BAZ=bar %command% -baz}}`{=mediawiki}
-   completely different command: `{{ic|othercommand # %command%}}`{=mediawiki}

## Tips and tricks {#tips_and_tricks}

### Start Minimized {#start_minimized}

It is possible to have Steam start minimized to the system tray, rather than taking focus. Add
`{{ic|-silent}}`{=mediawiki} to the list of command line arguments; see [Desktop entries#Modify desktop
files](Desktop_entries#Modify_desktop_files "wikilink") for doing this by default.

### Small Mode {#small_mode}

Steam supports an alternative, minimal UI with just your game list - the store, community and cover collection views are
hidden. You can switch to it with *View* \> *Small Mode*. To go back to the standard UI, select *View* \> *Large Mode*.

You can also launch steam with this argument:`{{ic|+open steam://open/minigameslist}}`{=mediawiki}

### Proton Steam-Play {#proton_steam_play}

Valve developed a compatibility tool for Steam Play based on Wine and additional components named
[Proton](w:Proton_(software) "wikilink"). It allows you to launch many Windows games (see [compatibility
list](https://www.protondb.com/)).

It is open-source and available on [GitHub](https://github.com/ValveSoftware/Proton/). Steam will install its own
versions of Proton when Steam Play is enabled.

\"Proton Experimental\" is enabled by default on the Steam client: *Steam \> Settings \> Compatibility*. You can enable
Steam Play for games that have and have not been whitelisted by Valve in that dialog.

Proton supports *Easy AntiCheat* integration if the developer activates it, however EAC may require a particular
[patched version](https://github.com/ValveSoftware/Proton/issues/5214) of glibc: if a game is been reported to be
working but is not in your machine, try using Steam Flatpak because it comes with glibc patched. Additionally, [setting
the procfs mount option `{{ic|1=hidepid}}`{=mediawiki} to a hardened value](Security#hidepid "wikilink") may cause Easy
Anti-Cheat to fail with the message \"Launch Error: 261\".

#### Force Proton usage {#force_proton_usage}

If needed, to force enable Proton or a specific version of Proton for a game, right click on the game, click *Properties
\> Compatibility \> Force the use of a specific Steam Play compatibility tool*, and select the desired version. Doing so
can also be used to force games that have a Linux port to use the Windows version.

#### Use Proton outside of Steam {#use_proton_outside_of_steam}

You can [install](install "wikilink") `{{AUR|proton-cachyos}}`{=mediawiki}, but extra setup is required to work with
Steam. See the [Proton GitHub](https://github.com/ValveSoftware/Proton?#install-proton-locally) for details on how Steam
recognizes Proton installs.

### Steam Input {#steam_input}

When a controller is plugged in while Steam is running, Steam\'s default behavior is to leave it alone and let games use
it as-is. The gamepad\'s evdev and joystick devices are exposed by the kernel, and games may use them using APIs such as
[SDL2](https://www.libsdl.org/) as if Steam were not in the picture.

The [Steam Input](https://partner.steamgames.com/doc/features/steam_controller) subsystem offers an abstraction layer
which allows for more advanced functionality such as rebinding buttons and axes, having game-specific profiles, and
doing higher-level button mappings based on in-game actions. The [Steam Input
Configurator](https://partner.steamgames.com/doc/features/steam_controller/concepts) (SIC) is the part of the system
that implements this functionality. To enable Steam Input for a controller, go to *Steam* \> *Settings* \> *Controller*
\> *External Gamepad Settings*. Here you will find toggles to *Enable Steam Input* corresponding to your controller.

#### Steam Input Configurator {#steam_input_configurator}

```{=mediawiki}
{{Move|Steam Input Configurator|No reason to keep such a large text here when it could be in its own article}}
```
See [Steam Input Configurator](Steam_Input_Configurator "wikilink") for configurator usage instructions.

When SIC is enabled for a controller, there are a few different controller devices:

-   The virtual Steam Controller, used by games that utilize the Steam Input API. All rebindings and Steam-specific
    features are functional.
    -   This is not to be confused with the [Valve Steam
        Controller](https://store.steampowered.com/app/353370/Steam_Controller/), the physical controller.
-   An evdev device representing an emulated Xbox 360 controller, used by games that do not support Steam Input. Basic
    rebindings are in effect.
    [1](https://partner.steamgames.com/doc/features/steam_controller/steam_input_gamepad_emulation_bestpractices)
-   The original controller evdev device, whose inputs are passed through the SIC. Rebindings are not in effect, but
    games should be defaulting to the 360 controller instead.
-   The joystick analogues of the above two devices.

The SIC\'s behavior is context dependent:

-   When launching a game that supports the Steam Input API, it is using the SIC in native mode. The game receives
    \"actions\" rather than raw inputs to handle.
    -   This works for games running in Proton that would be using Steam Input on Windows.
    -   Even though it\'s theoretically not needed, the emulated 360 controller is still present.
    -   A game may choose to provide both support for the Steam Input, and traditional input API libraries that defer to
        evdev and joystick under the hood. When the game is launched with Steam and with SIC enabled for the controller,
        Steam Input takes higher priority.
    -   A game can also choose to *only* support Steam Input. For example, in Among Us, a gamepad will not work unless
        you have the SIC running.
-   When launching a game that does not support Steam Input, it is (unknowingly) using the SIC in legacy mode. The game
    receives its expected low-level raw inputs from what seems to be a 360 controller, but they are actually spoofed by
    the SIC to emulate the desired behavior of native mode.
    -   This is the case for native games that use evdev or joystick, as well as Windows games running through Proton
        that use DirectInput or XInput.
-   When launching a game that supports neither Steam Input nor other gamepad APIs, SIC can activate a profile that
    emulates gamepad support as described below.
-   When Big Picture has focus, the current Big Picture profile is in effect. This is not configurable.
-   When anything else has focus, the current Desktop profile is in effect, configurable via *Steam* \> *Settings* \>
    *Controller* \> *Desktop Layout*.
-   When anything has focus, additional global bindings can be configured via *Steam* \> *Settings* \> *Controller* \>
    *Guide Button Chord Layout*. This is not available on a Steam Deck.

Games are rated on how comprehensive their gamepad support is. This is dependent on the controller model.

-   Supports Your Controller, indicating that the game has full controller support. This can be achieved even if the
    game does not use the Steam Input API; the focus is on accessibility regardless of API.
-   Mostly Playable With Your Controller, indicating that the game has partial gamepad support. Even if the game is
    using the Steam Input API, there are instances like Team Fortress 2 where certain parts are still inaccessible to
    warrant this rating.
-   Controllers Not Supported, indicating the game does not have native gamepad support.
-   Unknown Controller Support, indicating that Valve has not yet verified the controller support of a game.

In cases where the game does not have full gamepad support, SIC tries to fill the gaps. For example, in Bloons Tower
Defense 5, a game that requires you to point and click, Steam will automatically activate the *Keyboard (WASD) and
Mouse* profile, allowing you to use your gamepad to move and click.

#### Recommended Steam Input usage {#recommended_steam_input_usage}

To summarize what this all means for usage:

-   Enabling \"Configuration Support\" is *recommended* for enhanced gamepad support such as rebinding to one\'s liking,
    or automated fixes like Nintendo-style button remapping or keyboard/mouse.
-   For some games, enabling this is outright *required* if they do not support traditional gamepad APIs.
-   By default, if you have enabled this, then the controller will not work with non-Steam games because the 360
    controller takes precedence over the original controller device, but the default Desktop profile has the buttons
    disabled. To fix this, you can either:
    -   Have the configuration change action sets. Some official desktop configurations will switch to a gamepad mode
        when the start button is held. If the configuration for your controller does not have this, you can add it by
        adding a new action set to the configuration, setting the set to contain gamepad buttons, adding an *Extra
        Command* to the start button, setting the extra command to *Change Action Set*, and then setting that extra
        command to activate on long press.
    -   Set your Desktop profile to the template for *Gamepad*. This will pass through the inputs to the 360 controller,
        making the default device usable for other programs.
    -   Have the other game use the original device if it supports this. Note that the game will not benefit from any
        Steam Input rebindings.
    -   Disable the whole feature for the controller so Steam does not create the 360 controller at all. Note that Steam
        games would then not benefit from the enhanced gamepad support.
    -   Close Steam when using the other games.

#### Disabling Steam Input {#disabling_steam_input}

If you wish to completely disable Steam Input, launch steam with the *-nojoy* argument, and also disable Steam Input for
each game individually, as there is no global option for doing so.

### HiDPI

See [HiDPI#Steam](HiDPI#Steam "wikilink").

### Big Picture Mode from a display manager {#big_picture_mode_from_a_display_manager}

To start Steam in Big Picture Mode from a [display manager](display_manager "wikilink") with
[Gamescope](Gamescope "wikilink") as its [compositor](Wayland#Compositors "wikilink"):

-   [Install](Install "wikilink") `{{Pkg|gamescope}}`{=mediawiki}
-   Create the following [desktop entry](desktop_entry "wikilink") with the following contents:

```{=mediawiki}
{{hc|/usr/share/wayland-sessions/steam-big-picture.desktop|2=
[Desktop Entry]
Name=Steam Big Picture Mode
Comment=Start Steam in Big Picture Mode
Exec=/usr/bin/gamescope -e -- /usr/bin/steam -tenfoot
Type=Application
}}
```
```{=mediawiki}
{{Note (Magyar)|The {{ic|-tenfoot}} flag tells Steam to start in Big Picture Mode.}}
```
Then instruct your display manager to launch gamescope.

```{=mediawiki}
{{Warning (Magyar)|The "Switch to desktop" menu entry softlocks the session. To exit to the display manager you need to run {{ic|steam -shutdown}} on a terminal. You can also create a script with this command and add it as a non-Steam game. This creates a "shortcut" to exit back to the display manager.}}
```
### Steam skins {#steam_skins}

```{=mediawiki}
{{Note (Magyar)|A new Steam UI was released in June 2023. Skins not updated for this new UI will have no effect.}}
```
The Steam interface can be customized using skins. Follow [this Steam
guide](https://steamcommunity.com/sharedfiles/filedetails/?id=3003438937) for more information.

Some skins updated for the 2023 UI are:

-   [Adwaita for Steam](https://github.com/tkashkin/Adwaita-for-Steam)
-   [Shiina\'s Steam Skins](https://github.com/AikoMidori/SteamSkins)
-   [Zehn](https://github.com/yurisuika/Zehn)
-   More skins are available in the guide linked above.

### Changing the Steam notification position {#changing_the_steam_notification_position}

The default Steam notification position is bottom right.

You can change the Steam notification position by altering `{{ic|Notifications.PanelPosition}}`{=mediawiki} in

-   ```{=mediawiki}
    {{ic|resource/styles/steam.styles}}
    ```
    for desktop notifications, and

-   ```{=mediawiki}
    {{ic|resource/styles/gameoverlay.styles}}
    ```
    for in-game notifications

Both files are overwritten by Steam on startup and `{{ic|steam.styles}}`{=mediawiki} is only read on startup.

```{=mediawiki}
{{Note (Magyar)|Some games do not respect the setting in {{ic|gameoverlay.styles}} e.g. XCOM: Enemy Unknown.}}
```
#### Use a skin {#use_a_skin}

You can create a skin to change the notification position to your liking. For example to change the position to top
right:

`$ cd ~/.steam/root/skins`\
`$ mkdir -p Top-Right/resource`\
`$ cp -r ~/.steam/root/resource/styles Top-Right/resource`\
`$ sed -i '/Notifications.PanelPosition/ s/"[A-Za-z]*"/"TopRight"/' Top-Right/resource/styles/*`

#### Live patching {#live_patching}

```{=mediawiki}
{{ic|gameoverlay.styles}}
```
can be overwritten while Steam is running, allowing you to have game-specific notification positions.

```{=mediawiki}
{{hc|~/.steam/notifpos.sh|
sed -i "/Notifications.PanelPosition/ s/\"[A-Za-z]*\"/\"$1\"/" ~/.steam/root/resource/styles/gameoverlay.styles
}}
```
And the [#Launch options](#Launch_options "wikilink") should be something like:

`~/.steam/notifpos.sh TopLeft && %command%`

### Steam Remote Play {#steam_remote_play}

```{=mediawiki}
{{Note (Magyar)|Steam In-Home Streaming [https://store.steampowered.com/news/51761/ has become Steam Remote Play].}}
```
Steam has built-in support for [remote play](https://store.steampowered.com/streaming/).

See [this Steam Community guide](https://steamcommunity.com/sharedfiles/filedetails/?id=680514371) on how to setup a
headless streaming server on Linux.

### Sharing games with Windows when using Proton {#sharing_games_with_windows_when_using_proton}

If you use Proton (Steam Play) for launching your games, and still keep a Windows installation for some reason (for
example, if some game has problems with anti cheat or if you want to make a comparison tests with Windows), you may want
to store your games in a common partition instead of keeping two copies of game one per OS.

To add another folder for library, click on *Steam \> Settings \> Downloads \> STEAM LIBRARY FOLDERS*, then on the *⊕
(Plus)* button.

There are four file systems, that can be read/write by both Windows and Linux.

#### NTFS

```{=mediawiki}
{{Warning (Magyar)|Valve discourages the usage of NTFS to store a steam libray as it may lead to unexpected errors, specially for cases where a library is shared between multiple OSs.

You WILL run into problems where games don't start. You WILL run into problems where games crash unexpectedly.}}
```
See [Using a NTFS disk with Linux and
Windows](https://github.com/ValveSoftware/Proton/wiki/Using-a-NTFS-disk-with-Linux-and-Windows) for more information on
how to configure that. To launch games from an NTFS drive, follow the steps from [Steam/Troubleshooting#Steam Library in
NTFS partition](Steam/Troubleshooting#Steam_Library_in_NTFS_partition "wikilink").

Using ntfs has disadvantages. It happens often that shaders cache folder becomes corrupted. Messages saying
`{{ic|1=ntfs3: sdb6 ino=1921f, steamapprun_pipeline_cache Looks like your dir is corrupt.}}`{=mediawiki} You cannot fix
that from linux. You need to boot to Windows and use chkdsk for that.

#### exFAT

This filesystem has disadvantage that it is case-insensitive. You will get such message:
`{{ic|SteamLibrary has both 'SteamApps' and 'steamapps' directories. This will cause problems. Please fix manually and only keep 'steamapps' }}`{=mediawiki}
See [issue #7665](https://github.com/ValveSoftware/steam-for-linux/issues/7665)

Also it is problematic to create symlinks on exfat, so you cannot use the method of symlinking compatdata as in ntfs
method.

#### Btrfs

[Btrfs](Btrfs "wikilink") has a fairly mature Windows [Driver](https://github.com/maharmstone/btrfs).

NTFS can be also converted into Btrfs, see [Btrfs#NTFS to Btrfs conversion](Btrfs#NTFS_to_Btrfs_conversion "wikilink").

This filesystem eliminates most NTFS/exFAT compatibility issues, but **sharing a Steam library between Windows and Linux
has limitations**:

```{=mediawiki}
{{Note (Magyar)|
Valve [https://github.com/ValveSoftware/steam-for-linux/blob/master/RelNotes.md#installation officially discourages] sharing Steam libraries between OSes. Even with correct WinBtrfs UID/GID mappings, Windows processes create lock-files and staging folders owned by {{ic|nobody:100}}, causing "Disk write failure" or "content file locked" errors in Linux.  

After Windows usage you must run:

{{bc|
# chown -R $USER:$USER /path/to/steam_library/steamapps
$ find /path/to/steam_library/steamapps -name "*.lock" -delete
$ rm -rf /path/to/steam_library/steamapps/{downloading,temp}/*
}}

Only then start Steam on Linux. For reliable operation, keep separate libraries per OS.
}}
```
#### UDF

This filesystem can be used without issue, but to ensure compatibility, it must be formatted to the correct UDF
revision. Linux lacks write support for revisions 2.50 and higher. Therefore, revision 2.01 is required for proper
functionality.

The UDF block size must match the logical sector size of the partition. This value can be obtained using
`{{man|8|blockdev}}`{=mediawiki}:

`# blockdev --getss /dev/`*`the_partition_to_be_formatted`*

The partition is then formatted to UDF using `{{man|8|mkfs.udf}}`{=mediawiki} provided by
`{{Pkg|udftools}}`{=mediawiki}. For both HDDs and SSDs, the appropriate media type is `{{ic|hd}}`{=mediawiki}.

`# mkfs.udf --utf8 --label=`*`label`*` --blocksize=`*`block-size`*` --media-type=hd --udfrev=0x0201 /dev/`*`the_partition_to_be_formatted`*

Where:

-   ```{=mediawiki}
    {{ic|''the_partition_to_be_formatted''}}
    ```
    is the name of the target partition (e.g. `{{ic|sdb4}}`{=mediawiki}, `{{ic|nvme2n5p3}}`{=mediawiki} etc.).

-   ```{=mediawiki}
    {{ic|''label''}}
    ```
    is the desired volume label.

-   ```{=mediawiki}
    {{ic|''block-size''}}
    ```
    is the output of the `{{ic|blockdev}}`{=mediawiki} command.

Alternatively, graphical tools like `{{pkg|gparted}}`{=mediawiki} can be used to handle formatting. They correctly
manage UDF revision selection to ensure compatibility.

### Faster shader pre-compilation {#faster_shader_pre_compilation}

In certain circumstances shader pre-compilation may only use one core, however this can be overridden by the user,
example to use 8 cores:

```{=mediawiki}
{{hc|~/.steam/steam/steam_dev.cfg|
unShaderBackgroundProcessingThreads 8
}}
```
### Compatibility layers other than Proton {#compatibility_layers_other_than_proton}

There are compatibility tools other than Proton/Wine.

-   ```{=mediawiki}
    {{App|Luxtorpeda|Run games using native Linux engines.|https://luxtorpeda-dev.github.io/|{{AUR|luxtorpeda-git}}}}
    ```

-   ```{=mediawiki}
    {{App|Boxtron|Run DOS games using native Linux DOSBox|https://github.com/dreamer/boxtron|{{AUR|boxtron}}}}
    ```

You can also use `{{AUR|protonup-qt}}`{=mediawiki} to manage them:

1.  Close Steam
2.  [Install](Install "wikilink") `{{AUR|protonup-qt}}`{=mediawiki}
3.  Open protonup-qt and install desired tools
4.  Start Steam
5.  In the *game properties* window, select *Force the use of a specific Steam Play compatibility tool* and select the
    desired tool.

### Disable HTTP2 for faster downloads {#disable_http2_for_faster_downloads}

Some systems and configurations seem to have issues with HTTP2. Disabling HTTP2 will probably yield faster downloads on
those configurations. You can either use the console command
`{{ic|@nClientDownloadEnableHTTP2PlatformLinux 0}}`{=mediawiki} or set it in `{{ic|steam_dev.cfg}}`{=mediawiki} like so:
`{{hc|~/.steam/steam/steam_dev.cfg|
@nClientDownloadEnableHTTP2PlatformLinux 0
}}`{=mediawiki}

### Run games using discrete GPU {#run_games_using_discrete_gpu}

On [hybrid graphics](hybrid_graphics "wikilink") laptops, Steam runs games using the integrated GPU by default. See
[PRIME#PRIME GPU offloading](PRIME#PRIME_GPU_offloading "wikilink") to switch to the more powerful discrete GPU for
specific games.

### Flatpak

```{=mediawiki}
{{Note (Magyar)|Installing Steam from Flathub/Flatpak will fix many of the issues faced on the client but will require alternative, less documented forms of troubleshooting on the long run.}}
```
Steam can also be installed with [Flatpak](Flatpak "wikilink") as `{{ic|com.valvesoftware.Steam}}`{=mediawiki} from
[Flathub](https://flathub.org/). The easiest way to install it for the current user is by using the Flathub repository:

`$ flatpak --user remote-add --if-not-exists flathub `[`https://dl.flathub.org/repo/flathub.flatpakrepo`](https://dl.flathub.org/repo/flathub.flatpakrepo)\
`$ flatpak --user install flathub com.valvesoftware.Steam`\
`$ flatpak run com.valvesoftware.Steam`

The Flatpak application currently does not support themes. Also you currently cannot run games via
`{{ic|optirun}}`{=mediawiki}/`{{ic|primusrun}}`{=mediawiki}, see
[Issue#869](https://github.com/flatpak/flatpak/issues/869) for more details.

Steam installed via Flatpak is not able to access your home directory and overriding this will cause Steam to not run
because it is not safe. However, you can freely add directories outside the home directory. If you want to add an
external library, run the following command to add it:

`$ flatpak override --user com.valvesoftware.Steam --filesystem=/path/to/directory`

Launching Steam with Flatpak might warn you about installing the `{{ic|steam-devices}}`{=mediawiki} package. This
package currently does not exist but `{{aur|game-devices-udev}}`{=mediawiki} can be installed instead, see
[Gamepad#Device permissions](Gamepad#Device_permissions "wikilink").

#### Asian Font Problems with Flatpak {#asian_font_problems_with_flatpak}

If you are having problem getting Asian fonts to show in game, it is because org.freedesktop.Platform does not include
it. First try mounting your local font :

`$ flatpak run --filesystem=~/.local/share/fonts --filesystem=~/.config/fontconfig com.valvesoftware.Steam`

If that does not work, consider this hack: make the fonts available by directly copying the font files into
org.freedesktop.Platform\'s directories, e.g.

`/var/lib/flatpak/runtime/org.freedesktop.Platform/x86_64/`*`version`*`/`*`hash`*`/files/etc/fonts/conf.avail`\
`/var/lib/flatpak/runtime/org.freedesktop.Platform/x86_64/`*`version`*`/`*`hash`*`/files/etc/fonts/conf.d `\
`/var/lib/flatpak/runtime/org.freedesktop.Platform/x86_64/`*`version`*`/`*`hash`*`/files/share/fonts`

#### Steam Flatpak start (run) issues {#steam_flatpak_start_run_issues}

After launch, Steam will try to download files and you will see a progress bar. If it crashes, you may try to give
additional permissions to the flatpak package:

`$ flatpak permission-set background background com.valvesoftware.Steam yes`\
`$ flatpak run com.valvesoftware.Steam`

For an alternative way to control permissions, install [flatseal](https://flathub.org/apps/com.github.tchx84.Flatseal).

### Steam settings to reduce video card memory usage {#steam_settings_to_reduce_video_card_memory_usage}

This is useful for video cards with a small amount of video memory.

Make a copy of the Steam shortcut:

`$ cp /usr/share/applications/steam.desktop ~/.local/share/applications/steam_minimal.desktop`

and change the `{{ic|Exec{{=}}`{=mediawiki}}} and `{{ic|Name{{=}}`{=mediawiki}}} sections in the shortcut copy:
`{{hc|~/.local/share/applications/steam_minimal.desktop|
Name{{=}}`{=mediawiki}Steam Minimal (Runtime) Exec{{=}}/usr/bin/steam -cef-disable-gpu-compositing -cef-disable-gpu
<steam://open/minigameslist> %U }}

As a result, when launching the Steam Minimal (Runtime) shortcut you will get an ascetic interface, which is still
functional enough to install and run games, and when launching the standard Steam (Runtime) shortcut you will get a
full-fledged client.

## Hibaelhárítás

See [Steam/Troubleshooting](Steam/Troubleshooting "wikilink").

## See also {#see_also}

-   [Gentoo:Steam](Gentoo:Steam "wikilink")
-   [The Big List of DRM-Free Games on Steam](https://pcgamingwiki.com/wiki/The_Big_List_of_DRM-Free_Games_on_Steam) at
    PCGamingWiki
-   [Steam Linux store](https://store.steampowered.com/browse/linux)
-   [Proton](https://github.com/ValveSoftware/Proton/) Compatibility tool for Steam Play based on Wine and additional
    components.
-   [ProtonDB](https://www.protondb.com/) crowdsourced Linux compatibility reports.
-   [are we anti cheat yet](https://areweanticheatyet.com/) A comprehensive and crowd-sourced list of games using
    anti-cheats and their compatibility with GNU/Linux or Wine/Proton.

[Category:Gaming](Category:Gaming "wikilink")

[de:Wine](de:Wine "wikilink") [fr:Wine](fr:Wine "wikilink") [hu:Wine](hu:Wine "wikilink") [ja:Wine](ja:Wine "wikilink")
[ru:Wine](ru:Wine "wikilink") [zh-hans:Wine](zh-hans:Wine "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|CrossOver}}`{=mediawiki} `{{Related|Wine package guidelines}}`{=mediawiki} `{{Related|Bottles}}`{=mediawiki}
`{{Related|Proton}}`{=mediawiki} `{{Related|DOSBox}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[Wine](Wikipedia:Wine_(software) "wikilink") is a [compatibility layer](Wikipedia:Compatibility_layer "wikilink")
capable of running [Microsoft Windows](Wikipedia:Microsoft_Windows "wikilink") applications on
[Unix-like](Wikipedia:Unix-like "wikilink") [operating systems](Wikipedia:Operating_system "wikilink").

Wine does not use [emulation](Wikipedia:Emulator "wikilink"), [binary
translation](Wikipedia:Binary_translation "wikilink"), or [virtualization](Wikipedia:Virtualization "wikilink") to
operate. Instead, Wine provides an implementation of the [Win32 API](Wikipedia:Windows_API "wikilink") to applications
that require it. As Wine\'s implementation of the Win32 API will naturally differ from what is provided by Microsoft
Windows, applications may suffer behavioral, compatibility, or performance penalties when using Wine.

```{=mediawiki}
{{Warning|
* Wine is '''not isolated''' from your system: if ''you'' can access a file or resource with your user account, programs running in Wine ''can too''—see [[#Running Wine under a separate user account]] and [[Security#Sandboxing applications]] for possible precautions.
* Wine can also run [[Wikipedia:Malware|Malware]]—see [https://gitlab.winehq.org/wine/wine/-/wikis/FAQ#is-wine-malware-compatible Wine FAQ on Malware compatibility].
}}
```
## Installation

Wine can be installed either through the `{{Pkg|wine}}`{=mediawiki} (development), `{{AUR|wine-stable}}`{=mediawiki}
(stable) or `{{Pkg|wine-staging}}`{=mediawiki} (testing) package. [Wine
Staging](https://gitlab.winehq.org/wine/wine-staging/-/wikis/home) is a patched version of
[Wine](https://www.winehq.org/), which contains bug fixes and features that have not been integrated into the stable or
development branch yet.

```{=mediawiki}
{{Tip|Consider installing {{pkg|wine-gecko}} and {{pkg|wine-mono}} for applications that depend on Internet Explorer and .NET, respectively. These packages are not strictly required as Wine will download the relevant files as needed. However, you should [[System maintenance#Use the package manager to install software|manage them with pacman]].}}
```
If using `{{AUR|wine-stable}}`{=mediawiki}, see [#Using 32-bit Wine builds](#Using_32-bit_Wine_builds "wikilink") for
additional requirements.

### Optional dependencies {#optional_dependencies}

Wine has numerous [optional dependencies](Optional_dependency "wikilink"), which may not be required for basic
applications, but should be installed to provide functionality such as sounds, 3D graphics, video playback, etc.

#### Sound

By default sound issues may arise when running Wine applications. Ensure only one sound device is selected in *winecfg*.

##### MIDI support {#midi_support}

[MIDI](MIDI "wikilink") was a quite popular system for video games music in the 90s. If you are trying out old games, it
is not uncommon that the music will not play out of the box. Wine has excellent MIDI support. However you first need to
make it work on your host system, as explained in [MIDI](MIDI "wikilink"). Last but not least you need to make sure Wine
will use the correct MIDI output, though by default, no extra configuration may be required.

For MIDI tracks to play in-game, install Microsoft\'s General MIDI DLS Collection, DirectSound and DirectMusic using
`{{ic|winetricks gmdls dsound directmusic}}`{=mediawiki} or by searching for them on the dependency manager if using
Bottles.

#### Other dependencies {#other_dependencies}

Some applications may require additional packages
[1](https://gitlab.winehq.org/wine/wine/-/wikis/Building-Wine#satisfying-build-dependencies).

-   For encryption support install `{{Pkg|gnutls}}`{=mediawiki}
-   For joystick and gamepad support install `{{Pkg|sdl2-compat}}`{=mediawiki}
-   For media playback programs install `{{Pkg|gst-plugins-base}}`{=mediawiki}, `{{Pkg|gst-plugins-good}}`{=mediawiki},
    `{{Pkg|gst-plugins-bad}}`{=mediawiki}, `{{Pkg|gst-plugins-ugly}}`{=mediawiki} and `{{Pkg|ffmpeg}}`{=mediawiki}
-   For [NTLM](Wikipedia:NTLM "wikilink") authentication install `{{Pkg|samba}}`{=mediawiki}

### In-prefix dependencies {#in_prefix_dependencies}

Aside from system dependencies, many programs require additional fonts and DLLs to be installed to the Wine prefix
[2](https://gitlab.winehq.org/wine/wine/-/wikis/FAQ#my-application-says-some-dll-or-font-is-missing-what-do-i-do). To
satisfy these dependencies you can use [Winetricks](https://github.com/Winetricks/winetricks), a primitive \"package
manager\" where each *verb* either installs something or applies a configuration tweak. There are two ways to use
Winetricks:

-   Through the CLI: Run `{{ic|winetricks ''verb_name''}}`{=mediawiki}.
-   Through the GUI: Install `{{Pkg|zenity}}`{=mediawiki} or `{{Pkg|kdialog}}`{=mediawiki} then run
    `{{ic|winetricks}}`{=mediawiki}.

Due to conflicts between dependencies, you may not be able to create the \"perfect\" Windows installation that can run
everything [3](https://github.com/Winetricks/winetricks/issues/1580#issuecomment-666604256)
[4](https://github.com/Winetricks/winetricks/issues/469). Rather, you should treat prefixes as disposable (unless they
contain important configurations or data) and use separate prefixes for programs with different dependencies. You can
use the [#WINEPREFIX](#WINEPREFIX "wikilink") environment variable to control which prefix the verbs act on.

Determining the verbs required by a program needs can require much trial and error. See the [Bottles dependency
page](https://usebottles.com/database/dependencies/) for some of the more common dependencies, as well as the following
program-specific resources:

-   [Wine Application Database](https://appdb.winehq.org/). Official resource, but old and may be less maintained than
    others.
-   [Lutris website](https://lutris.net/). If you are trying to run a game which happens to be featured on this site,
    you can click the drop-down menu and then *View install script* to see what Winetricks verbs are used by Lutris.
-   [Bottles program repository](https://github.com/bottlesdevs/programs). Smaller, but not just games.
-   [ProtonDB](https://www.protondb.com/). Although Proton has different compatibility than Wine (and you should
    probably just use Proton if you are on this site), the verbs commented by users may be of use.
    -   You can also consult the source for the fast-moving
        [protonfixes](https://github.com/Open-Wine-Components/ULWGL-protonfixes/) tool that ships with
        [proton-ge-custom](https://github.com/GloriousEggroll/proton-ge-custom), but beware that it assumes the presence
        of additional Proton and GE patches that fix games.

If you find yourself spending a lot of time managing prefixes for games, it may be easier to use a third-party
application that handles it for you.

### Third-party applications {#third_party_applications}

These have their own communities and websites, and are **not supported** by the main Wine community. See [Wine
Wiki](https://gitlab.winehq.org/wine/wine/-/wikis/Third-Party-Applications) for more details.

-   ```{=mediawiki}
    {{App|[[Bottles]]|Graphical prefix and runners manager for Wine based on GTK.|https://usebottles.com/|{{AUR|bottles}}}}
    ```

-   ```{=mediawiki}
    {{App|[[CrossOver]]|Official paid version of Wine which provides a graphical interface and more comprehensive end-user support.|https://www.codeweavers.com/crossover|{{AUR|crossover}}}}
    ```

-   ```{=mediawiki}
    {{App|[[Wikipedia:Lutris|Lutris]]|Gaming launcher for all types of games, including Wine games (with prefix management), native Linux games and emulators.|https://lutris.net|{{Pkg|lutris}}}}
    ```

-   ```{=mediawiki}
    {{App|[[Wikipedia:PlayOnLinux|PlayOnLinux]]|Graphical prefix manager for Wine. Contains scripts to assist with program installation and configuration.|https://www.playonlinux.com|{{AUR|playonlinux}}}}
    ```

-   ```{=mediawiki}
    {{App|PyWinery|Simple graphical prefix manager for Wine.|https://github.com/ergoithz/pywinery|{{AUR|pywinery}}}}
    ```

-   ```{=mediawiki}
    {{App|Q4Wine|Graphical prefix manager for Wine. Can export [[Qt]] themes into the Wine configuration for better integration.|https://sourceforge.net/projects/q4wine/|{{AUR|q4wine-git}}}}
    ```

-   ```{=mediawiki}
    {{App|WINEgui|A user-friendly WINE graphical interface.|https://gitlab.melroy.org/melroy/winegui|{{AUR|winegui}},{{AUR|winegui-bin}}}}
    ```

## Configuration

Configuring Wine is typically accomplished using:

-   [control](https://gitlab.winehq.org/wine/wine/-/wikis/Commands/control) --- Wine\'s implementation of the [Windows
    Control Panel](Wikipedia:Control_Panel_(Windows) "wikilink"), which can be started by running
    `{{ic|wine control}}`{=mediawiki},
-   [regedit](https://gitlab.winehq.org/wine/wine/-/wikis/Commands/regedit) --- Wine\'s
    [registry](Wikipedia:Windows_Registry "wikilink") editing tool, which can be started by running
    `{{ic|regedit}}`{=mediawiki}---see also [Useful Registry
    Keys](https://gitlab.winehq.org/wine/wine/-/wikis/Useful-Registry-Keys),
-   [winecfg](https://gitlab.winehq.org/wine/wine/-/wikis/Commands/winecfg) --- a
    [GUI](Wikipedia:Graphical_user_interface "wikilink") configuration tool for Wine, which can be started by running
    `{{ic|winecfg}}`{=mediawiki}.

See [Programs](https://gitlab.winehq.org/wine/wine/-/wikis/Commands#programs) for the full list.

### WINEPREFIX

By default, Wine stores its configuration files and installed Windows programs in `{{ic|~/.wine}}`{=mediawiki}. This
directory is commonly called a \"Wine prefix\" or \"Wine bottle\". It is created/updated automatically whenever you run
a Windows program or one of Wine\'s bundled programs such as *winecfg*. The prefix directory also contains a tree which
your Windows programs will see as `{{ic|C:}}`{=mediawiki} (the C-drive).

```{=mediawiki}
{{Note|Wine prefixes are not forward compatible. New versions of Wine will automatically upgrade old prefixes if necessary, at which point they may become broken for old Wine versions. [https://github.com/GloriousEggroll/wine-ge-custom/releases/tag/7.0-GE-8-LoL]}}
```
You can override the location Wine uses for a prefix with the `{{ic|WINEPREFIX}}`{=mediawiki} [environment
variable](environment_variable "wikilink"). This is useful if you want to use separate configurations for different
Windows programs. The first time a program is run with a new Wine prefix, Wine will automatically create a directory
with a bare C-drive and registry.

For example, if you run one program with `{{ic|1=env WINEPREFIX=~/.win-a wine program-a.exe}}`{=mediawiki}, and another
with `{{ic|1=env WINEPREFIX=~/.win-b wine program-b.exe}}`{=mediawiki}, the two programs will each have a separate
C-drive and separate registries.

```{=mediawiki}
{{Warning|Wine prefixes are not [[Wikipedia:Sandbox (computer security)|sandboxes]]! Programs running under Wine can still access the rest of the system! (for example, {{ic|Z:}} is mapped to {{ic|/}}, regardless of the Wine prefix).}}
```
To create a default prefix without running a Windows program or other GUI tool you can use:

`$ env WINEPREFIX=~/.customprefix wineboot -u`

### Fonts

If Wine applications have unreadable or missing fonts, you may not have any fonts installed. To easily link all of the
system fonts so they are accessible from wine:

`$ cd ${WINEPREFIX:-~/.wine}/drive_c/windows/Fonts && for i in /usr/share/fonts/**/*.{ttf,otf}; do ln -s "$i"; done`

Wine uses FreeType to render fonts, and FreeType\'s defaults changed a few releases ago. Try using the following
[environment variable](environment_variable "wikilink") when running programs in Wine:

`FREETYPE_PROPERTIES="truetype:interpreter-version=35"`

Another possibility is to [install Microsoft\'s TrueType fonts](Microsoft_fonts#Installation "wikilink") into your wine
prefix. If this does not help, try running `{{ic|winetricks corefonts}}`{=mediawiki} first, then
`{{ic|winetricks allfonts}}`{=mediawiki} as a last resort.

After running such programs, kill all Wine servers and run `{{ic|winecfg}}`{=mediawiki}. Fonts should be legible now.

If the fonts look somehow smeared, run the following command to change a setting in the Wine registry:

`$ wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /v ClientSideWithRender /t REG_SZ /d N`

For high resolution displays, you can adjust dpi values in winecfg.

See also [Font configuration#Applications without Fontconfig
support](Font_configuration#Applications_without_Fontconfig_support "wikilink").

#### Enable font smoothing {#enable_font_smoothing}

A good way to improve wine font rendering is to enable cleartype font smoothing. To enable \"Subpixel smoothing
(ClearType) RGB\":

```{=mediawiki}
{{hc|/tmp/fontsmoothing.reg|2=
REGEDIT4

[HKEY_CURRENT_USER\Control Panel\Desktop]
"FontSmoothing"="2"
"FontSmoothingOrientation"=dword:00000001
"FontSmoothingType"=dword:00000002
"FontSmoothingGamma"=dword:00000578
EOF
}}
```
`$ WINE=${WINE:-wine} WINEPREFIX=${WINEPREFIX:-$HOME/.wine} $WINE regedit /tmp/fontsmoothing.reg 2> /dev/null`

If you have installed `{{Pkg|winetricks}}`{=mediawiki}, there is a simpler way to do this:

```{=mediawiki}
{{bc|
winetricks fontsmooth{{=}}
```
rgb }}

For more information, check [the original answer](https://askubuntu.com/a/219795)

### Desktop launcher menus {#desktop_launcher_menus}

When a Windows application installer creates a shortcut Wine creates a [.desktop](.desktop "wikilink") file instead. The
default locations for those files in Arch Linux are:

-   Desktop shortcuts are put in `{{ic|~/Desktop}}`{=mediawiki}
-   Start menu shortcuts are put in `{{ic|~/.local/share/applications/wine/Programs/}}`{=mediawiki}

```{=mediawiki}
{{Note|1=Wine does not support installing Windows applications for all users, so it will not put ''.desktop'' files in {{ic|/usr/share/applications}}. See WineHQ bug [https://bugs.winehq.org/show_bug.cgi?id=11112 11112]}}
```
```{=mediawiki}
{{Tip|If menu items were ''not'' created while installing software or have been lost, {{ic|wine winemenubuilder}} may be of some use.}}
```
#### Creating menu entries for Wine utilities {#creating_menu_entries_for_wine_utilities}

By default, installation of Wine does not create desktop menus/icons for the software which comes with Wine (e.g. for
*winecfg*, *winebrowser*, etc). This can be achieved by installing `{{AUR|wine-installer}}`{=mediawiki} or
`{{AUR|wine-installer-git}}`{=mediawiki} meta-package (the latter has no additional dependencies), otherwise these
instructions will add entries for these applications.

First, install a Windows program using Wine to create the base menu. After the base menu is created, you can create the
following files in `{{ic|~/.local/share/applications/wine/}}`{=mediawiki}:

```{=mediawiki}
{{hc|wine-browsedrive.desktop|2=
[Desktop Entry]
Name=Browse C: Drive
Comment=Browse your virtual C: drive
Exec=wine winebrowser c:
Terminal=false
Type=Application
Icon=folder-wine
Categories=Wine;
}}
```
```{=mediawiki}
{{hc|wine-uninstaller.desktop|2=
[Desktop Entry]
Name=Uninstall Wine Software
Comment=Uninstall Windows applications for Wine
Exec=wine uninstaller
Terminal=false
Type=Application
Icon=wine-uninstaller
Categories=Wine;
}}
```
```{=mediawiki}
{{hc|wine-winecfg.desktop|2=
[Desktop Entry]
Name=Configure Wine
Comment=Change application-specific and general Wine options
Exec=winecfg
Terminal=false
Icon=wine-winecfg
Type=Application
Categories=Wine;
}}
```
And create the following file in `{{ic|~/.config/menus/applications-merged/}}`{=mediawiki}:

```{=mediawiki}
{{hc|wine.menu|<nowiki>
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
"http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
<Menu>
  <Name>Applications</Name>
  <Menu>
    <Name>wine-wine</Name>
    <Directory>wine-wine.directory</Directory>
    <Include>
      <Category>Wine</Category>
    </Include>
  </Menu>
</Menu>
</nowiki>}}
```
If these settings produce a ugly/non-existent icon, it means that there are no icons for these launchers in the icon set
that you have enabled. You should replace the icon settings with the explicit location of the icon that you want.
Clicking the icon in the launcher\'s properties menu will have the same effect. A great icon set that supports these
shortcuts is `{{AUR|gnome-colors-icon-theme}}`{=mediawiki}.

#### Removing menu entries {#removing_menu_entries}

Menu entries created by Wine are located in `{{ic|~/.local/share/applications/wine/Programs/}}`{=mediawiki}. Remove the
program\'s *.desktop* entry to remove the application from the menu.

In addition to remove unwanted extensions binding by Wine, execute the following commands:
[5](https://gitlab.winehq.org/wine/wine/-/wikis/FAQ#how-do-i-clean-the-open-with-list)

`$ rm ~/.local/share/mime/packages/x-wine*`\
`$ rm ~/.local/share/applications/wine-extension*`\
`$ rm ~/.local/share/icons/hicolor/*/*/application-x-wine-extension*`\
`$ rm ~/.local/share/mime/application/x-wine-extension*`

Sometimes you should also remove `{{ic|wine-*.menu}}`{=mediawiki} files from `{{ic|/.config/menus/}}`{=mediawiki} to
completely remove items from Wine submenu in KDE.

### Appearance

A similar to XP-looking theme can be [downloaded](https://archive.org/download/zune-desktop-theme/ZuneDesktopTheme.msi).
To install it, see [this upstream wiki
article](https://gitlab.winehq.org/wine/wine/-/wikis/Wine-User's-Guide#running-msi-files). Lastly, use *winecfg* to
select it.

```{=mediawiki}
{{Note|The theme linked above can only be installed on 32-bit prefixes with Windows XP as the prefix version. To install it on 64-bit prefixes, you might want to create a temporary 32-bit prefix, install the theme and copy the {{ic|Zune}} folder and {{ic|Zune.theme}} files from {{ic|drive_c/Windows/Resources/Themes}} in that prefix to the same location in your usual prefix.}}
```
Wine staging users may instead want to try enabling the option *Enable GTK3 Theming* under the Staging section of
*winecfg* for a theme that matches the current GTK theme.

### Printing

In order to use your installed printers (both local and network) with wine applications (e.g. MS Word), install the
`{{Pkg|libcups}}`{=mediawiki} package, reboot wine (*wineboot*) and restart your wine application.

### Networking

After installation, the `{{pkg|gnutls}}`{=mediawiki} package may need to be [installed](install "wikilink") for
applications making TLS or HTTPS connections to work.

For ICMP (ping), Wine may need the network access as described in the [WineHQ
FAQ](https://gitlab.winehq.org/wine/wine/-/wikis/FAQ#failed-to-use-icmp-network-ping-this-requires-special-permissions):

`# setcap cap_net_raw+epi /usr/bin/wine-preloader`

If issues arise after this (such as an unhandled exception or privileged instruction), remove via:

`# setcap -r /usr/bin/wine-preloader`

## Usage

```{=mediawiki}
{{Warning|Do not run or install Wine applications as root! See [https://gitlab.winehq.org/wine/wine/-/wikis/FAQ#should-i-run-wine-as-root Wine FAQ] for details.}}
```
See [Wine User\'s Guide](https://gitlab.winehq.org/wine/wine/-/wikis/Wine-User's-Guide#using-wine) for general
information on Wine usage.

See [Wine Application Database (AppDB)](https://appdb.winehq.org/) for additional information on specific Windows
applications in Wine.

### Wayland

```{=mediawiki}
{{Warning|The native [[Wayland]] driver is still experimental.}}
```
By default, Wine runs on Wayland through [Xwayland](Xwayland "wikilink"), providing a satisfactory experience for most
users. As of version 9.0rc1, Wine has made substantial progress on merging native Wayland support, now making it
suitable for some use cases.

To experiment with the native Wayland driver added in recent Wine versions, you can follow these steps:

-   For Wine versions older than 9.22, run the following command to change a setting in the Wine registry:
    `{{bc|$ wine reg add 'HKEY_CURRENT_USER\Software\Wine\Drivers' /v Graphics /t REG_SZ /d 'x11,wayland'}}`{=mediawiki}
-   Bypass the use of Xwayland and force the native Wayland driver by unsetting the `{{Ic|DISPLAY}}`{=mediawiki}
    [environment variable](environment_variable "wikilink"): `{{bc|1=$ env -u DISPLAY wine example.exe}}`{=mediawiki}

If the second step makes Wine stop working, check to see if your Wine version is built with support for the new Wayland
driver.

### Stop running Wine {#stop_running_wine}

Stopping started executables, `{{ic|wine}}`{=mediawiki} with Ctrl+Z or `{{ic|wineconsole}}`{=mediawiki} with Ctrl+C,
might leave processes running in the background. See for example:

```{=mediawiki}
{{bc|<nowiki>
$ ps -xo pid,cmd
    PID CMD
    297 -bash
    933 /usr/bin/wineserver
    939 C:\windows\system32\services.exe
    942 C:\windows\system32\winedevice.exe
    950 C:\windows\system32\explorer.exe /desktop
    954 C:\windows\system32\winedevice.exe
    965 C:\windows\system32\plugplay.exe
    977 C:\windows\system32\svchost.exe -k LocalServiceNetworkRestricted
    984 C:\windows\system32\rpcss.exe
    997 mbserver.exe
   1017 start.exe /exec
   1019 C:\windows\system32\conhost.exe --unix --width 169 --height 40 --server 0x10
   1021 Z:\home\wineuser\mbserver.exe
   1030 ps -xo pid,cmd
</nowiki>}}
```
All running `{{ic|wine}}`{=mediawiki} and `{{ic|wineconsole}}`{=mediawiki} processes are stopped at once using the
[wineserver -k](https://gitlab.winehq.org/wine/wine/-/wikis/Wine-User's-Guide#-k-n) command. For example:

`$ wineserver -k 15`

This command is `{{ic|WINEPREFIX}}`{=mediawiki}-dependent, so when using a custom Wine prefix, run:

`$ WINEPREFIX=~/wine/my-prefix wineserver -k`

An equivalent command to gracefully finish both executables in the above example is:

`$ kill 997 1021`

### 32-bit Windows applications {#bit_windows_applications}

Upstream Wine supports three ways of running 32-bit Windows applications on a 64-bit system:

-   ```{=mediawiki}
    {{ic|WINEARCH{{=}}
    ```
    win32}} which runs Wine as a 32-bit Linux application in a 32-bit prefix.

-   \"Old WoW64\", which runs Wine as a 32-bit Linux application in a 64-bit prefix. This allows 32-bit and 64-bit
    applications to coexist in the same prefix.

-   \"New WoW64\". which runs Wine as a 64-bit Linux application in a 64-bit prefix. 32-bit Windows applications are
    supported via thunking to 64-bit Wine code. This is most similar to [WoW64](Wikipedia:WoW64 "wikilink") on Windows.

Since Wine [10.8-2](https://archlinux.org/news/transition-to-the-new-wow64-wine-and-wine-staging/), Arch Linux enables
the new WoW64 mode. Most 32-bit Windows applications will install and run without any additional steps needed.

#### Using 32-bit Wine builds {#using_32_bit_wine_builds}

While the new WoW64 mode will work for most applications, it has a few limitations:

-   Any existing 32-bit `{{ic|WINEPREFIX}}`{=mediawiki} will no longer work, and should be recreated as 64-bit. Then
    32-bit applications can be installed into it.
-   A known limitation of the new WoW64 mode is reduced performance for 32-bit applications that use OpenGL directly.
    ([Bug report](https://bugs.winehq.org/show_bug.cgi?id=55981)).
-   A few 32-bit Windows applications do not work correctly in WoW64 mode (under either wine or Windows).

As a workaround, `{{AUR|wine32}}`{=mediawiki} is an alternate wine package that provides 32-bit builds of wine. The
`{{AUR|wine-stable}}`{=mediawiki} package also currently provides a 32-bit build. These packages require the host system
to have 32-bit versions of libraries installed for Wine to be able to run 32-bit applications. Some common 32-bit
libraries are listed below. When installing other libraries listed on this page (e.g. those listed in [#Other
dependencies](#Other_dependencies "wikilink")), you should also install the corresponding `{{ic|lib32-}}`{=mediawiki}
package if you are running a 32-bit application.

##### Graphics drivers {#graphics_drivers}

You need to install the 32-bit version of your graphics driver. Please install the package that is listed in the *OpenGL
(multilib)* column in the table in [Xorg#Driver installation](Xorg#Driver_installation "wikilink").

A good sign that your drivers are inadequate or not properly configured is when Wine reports the following in your
terminal window:

`Direct rendering is disabled, most likely your OpenGL drivers have not been installed correctly`

```{=mediawiki}
{{Note|You might need to restart [[Xorg]] after having installed the correct library.}}
```
##### Sound {#sound_1}

Install the correct packages for the audio driver you want to use:

-   For [ALSA](ALSA "wikilink") install `{{Pkg|lib32-alsa-lib}}`{=mediawiki} and
    `{{Pkg|lib32-alsa-plugins}}`{=mediawiki}
-   For [PulseAudio](PulseAudio "wikilink") install `{{Pkg|lib32-libpulse}}`{=mediawiki}
-   For [PipeWire](PipeWire "wikilink") install `{{Pkg|lib32-pipewire}}`{=mediawiki} and either:
    -   ```{=mediawiki}
        {{Pkg|pipewire-pulse}}
        ```
        and `{{Pkg|lib32-libpulse}}`{=mediawiki} to use PulseAudio as a frontend.

    -   ```{=mediawiki}
        {{Pkg|pipewire-alsa}}
        ```
        , `{{Pkg|lib32-alsa-lib}}`{=mediawiki}, and `{{Pkg|lib32-alsa-plugins}}`{=mediawiki} to use ALSA as a frontend.
-   For [OSS](OSS "wikilink") install `{{Pkg|lib32-alsa-oss}}`{=mediawiki}

If *winecfg* **still** fails to detect the audio driver (Selected driver: (none)), [configure it via the
registry](https://gitlab.winehq.org/wine/wine/-/wikis/Wine-User's-Guide#using-regedit). For example, in a case where the
microphone was not working in a 32-bit Windows application on a 64-bit stock install of wine-1.9.7, this provided full
access to the sound hardware (sound playback and mic): open *regedit*, look for the key *HKEY_CURRENT_USER \> Software
\> Wine \> Drivers*, and add a string called *Audio* and give it the value `{{ic|alsa}}`{=mediawiki}. Also, it may help
to [recreate the prefix](#WINEPREFIX "wikilink").

##### WINEARCH

```{=mediawiki}
{{Note|Setting {{ic|WINEARCH}} no longer works with the {{Pkg|wine}} or {{Pkg|wine-staging}} packages, only {{AUR|wine-stable}} and {{AUR|wine32}}.}}
```
If supported, you can use `{{ic|WINEARCH}}`{=mediawiki} with `{{ic|WINEPREFIX}}`{=mediawiki} to make separate
`{{ic|win32}}`{=mediawiki} and `{{ic|win64}}`{=mediawiki} (old WoW64) environments:

`$ WINEARCH=win32 WINEPREFIX=~/win32 winecfg`\
`$ WINEPREFIX=~/win64 winecfg`

You can also use `{{ic|WINEARCH}}`{=mediawiki} in combination with other Wine programs, such as *winetricks* (using
Steam as an example):

`WINEARCH=win32 WINEPREFIX=~/.local/share/wineprefixes/steam winetricks steam`

In order to see the architecture of an existing prefix you can check its registry file. The command below reads the
system registry of the `{{ic|~/.wine}}`{=mediawiki} prefix and returns `{{ic|1=#arch=win32}}`{=mediawiki} or
`{{ic|1=#arch=win64}}`{=mediawiki} depending on the architecture type:

`$ grep '#arch' ~/.wine/system.reg`

## Tips and tricks {#tips_and_tricks}

### Wineconsole

Often you may need to run *.exe*\'s to patch game files, for example a widescreen mod for an old game, and running the
*.exe* normally through Wine might yield nothing happening. In this case, you can open a terminal and run the following
command:

`$ wineconsole cmd`

Then navigate to the directory and run the *.exe* file from there.

### Winetricks

[Winetricks](https://gitlab.winehq.org/wine/wine/-/wikis/Winetricks) is a script to allow one to install base
requirements needed to run Windows programs. Installable components include DirectX 9.x, MSXML (required by Microsoft
Office 2007 and Internet Explorer), Visual Runtime libraries and many more.

[Install](Install "wikilink") the `{{pkg|winetricks}}`{=mediawiki} package (or alternatively
`{{AUR|winetricks-git}}`{=mediawiki}). Then run it with:

`$ winetricks`

For using GUI you can [install](install "wikilink") either `{{pkg|zenity}}`{=mediawiki}(GTK) or
`{{pkg|kdialog}}`{=mediawiki}(Qt).

### Performance

#### CSMT

CSMT is a technology used by Wine to use a separate thread for the OpenGL calls to improve performance noticeably. Since
Wine 3.2, CSMT is enabled by default.

Note that CSMT may actually hurt performance for some applications - if this is the case, disable it by running
`{{ic|wine regedit}}`{=mediawiki} and set the DWORD value for *HKEY_CURRENT_USER -\> Software \> Wine \> Direct3D \>
csmt* to 0x00 (disabled).

Further information:

:   [Phoronix Forum
    discussion](https://www.phoronix.com/forums/showthread.php?93967-Wine-s-Big-Command-Stream-D3D-Patch-Set-Updated/page3&s=7775d7c3d4fa698089d5492bb7b1a435)
    with the CSMT developer Stefan Dösinger

#### Force OpenGL mode in games {#force_opengl_mode_in_games}

Some games might have an OpenGL mode which *may* perform better than their default DirectX mode. While the steps to
enable OpenGL rendering is *application specific*, many games accept the `{{Ic|-opengl}}`{=mediawiki} parameter.

`$ wine `*`/path/to/3d_game.exe`*` -opengl`

You should of course refer to your application\'s documentation and Wine\'s [AppDB](https://appdb.winehq.org) for such
application specific information.

#### DXVK

[DXVK](https://github.com/doitsujin/dxvk) is an implementation of DirectX 8, 9, 10, and 11 over Vulkan. It beats the
WineD3D driver in performance and compatibility for most games. It does not support DirectX 12, see
[#VKD3D-Proton](#VKD3D-Proton "wikilink") instead. DXVK and VKD3D-Proton can and should be installed alongside each
other to be able to support all DirectX versions.

To install the latest version, use [#Winetricks](#Winetricks "wikilink"):

`$ WINEPREFIX=`*`your-prefix`*` winetricks dxvk`

You can also specify a version to install. For example, to install a DXVK version with [relaxed
requirements](https://github.com/doitsujin/dxvk/wiki/Driver-support#dxvk-1103), use:

`$ WINEPREFIX=`*`your-prefix`*` winetricks dxvk1103`

Alternatively, install `{{AUR|dxvk-mingw}}`{=mediawiki} or `{{AUR|dxvk-bin}}`{=mediawiki}. Then run the following
command to activate it in your Wine prefix (by default `{{ic|~/.wine}}`{=mediawiki}):

`$ WINEPREFIX=`*`your-prefix`*` setup_dxvk install --symlink`

While using DXVK with a dual graphics setup, Wine prefers the dedicated GPU. On laptops for power saving, this can be
overridden:

`$ VK_DRIVER_FILES=/usr/share/vulkan/icd.d/`*`your_driver`*`.json wine `*`executable`*

#### VKD3D-Proton {#vkd3d_proton}

[VKD3D-Proton](https://github.com/HansKristian-Work/vkd3d-proton) is a fork of
[VKD3D](https://gitlab.winehq.org/wine/vkd3d/-/wikis/home) which aims to implement the full Direct3D 12 API using
Vulkan. The project serves as the development effort for Direct3D 12 support in Proton improving performance and
compatibility for DirectX 12 games.

```{=mediawiki}
{{Tip|Despite having Proton in its name, the DLLs work perfectly with the normal version of Wine and function alongside [[#DXVK]].}}
```
To install the latest version, use [#Winetricks](#Winetricks "wikilink"):

`$ WINEPREFIX=`*`your-prefix`*` winetricks vkd3d`

Alternatively, install `{{AUR|vkd3d-proton-mingw}}`{=mediawiki} or `{{AUR|vkd3d-proton-bin}}`{=mediawiki}. Then run the
following command to activate it in your Wine prefix (by default `{{ic|~/.wine}}`{=mediawiki}):

`$ WINEPREFIX=`*`your-prefix`*` setup_vkd3d_proton install --symlink`

```{=mediawiki}
{{Tip|For [[AMDGPU]] users '''only''': when paired with [[Gamescope]], DXVK v2.1+ offers support for [[Wikipedia:HDR10|HDR10]] displays. See [[HDR monitor support]] for details.}}
```
#### xSync

Some games heavily use windows sync objects to run multi-threaded workloads, Wine is able to provide a user space
implementation through wineserver, however most of the time the default implementation have major performance impact in
CPU bound scenarios.

Currently there are 3 options available to improve the performance, and you should use only one at same time:

-   ESync - User-space eventfd-based synchronization.
    -   Not included in `{{Pkg|wine}}`{=mediawiki}. Included in `{{Pkg|wine-staging}}`{=mediawiki} up to version
        10.15[6](https://gitlab.winehq.org/wine/wine-staging/-/commit/38d4b8ca780f51227661211ead02b1283774be0b), but not
        enabled by default.
    -   Enabled by default in [Proton](Proton "wikilink") unless FSync is available.
-   FSync - In-kernel Futex2-based implementation of synchronization, should have better performance than ESync.
    -   Available if you use a kernel version [starting from
        5.16](https://kernelnewbies.org/Linux_5.16#New_futex_waitv.28.29_system_call_for_faster_game_performance).
    -   Not included in `{{Pkg|wine}}`{=mediawiki}: you will need a patched version.
    -   Enabled by default in [Proton](Proton "wikilink").
-   [NTSync](https://www.youtube.com/watch?v=NjU4nyWyhU8) - In-kernel implementation of synchronization. Compared to
    ESync and FSync, NTSync closely emulates the behavior of MS Windows NT kernel implementation, with performance on
    par with FSync or smoother.
    -   Available if you use a kernel version [starting from
        6.14](https://kernelnewbies.org/Linux_6.14#NT_synchronization_primitive_driver_for_faster_games).
    -   NTSync [was implemented in Wine 10.16](https://gitlab.winehq.org/wine/wine/-/merge_requests/9091), but not
        included in [Proton](Proton "wikilink"), because Proton\'s latest version is based on Wine 10.0 stable, which
        did not yet include NTSync.
    -   [Proton-TKG](https://github.com/Frogging-Family/wine-tkg-git) can be used if you want a Proton version with
        NTSync.

```{=mediawiki}
{{Note|The Wine developers have no plans to add ESync or FSync because since Wine 10.16, the full version of NTSync has been added and enabled by default. NTSync being more accurate than Esync or FSync without performance penalty, there is no reason to use ESync or FSync if you are using the latest Wine and Linux kernel releases.}}
```
To enable ESync, [export](export "wikilink") the following [environment variable](environment_variable "wikilink")
before running Wine:

`WINEESYNC=1`

Or for FSync with patched Wine:

`WINEFSYNC=1`

NTSync does not require setting an environment variable, instead it will automatically be used if the
`{{ic|ntsync}}`{=mediawiki} kernel module is loaded. `{{Pkg|wine}}`{=mediawiki} and `{{Pkg|wine-staging}}`{=mediawiki}
ship with a file to [load the module at boot](load_the_module_at_boot "wikilink"), otherwise you can manually create:

```{=mediawiki}
{{hc|/etc/modules-load.d/ntsync.conf|
ntsync
}}
```
```{=mediawiki}
{{Note|Now in Arch Linux packages {{Pkg|wine}} and {{Pkg|wine-staging}} since [https://gitlab.archlinux.org/archlinux/packaging/packages/wine/-/commit/3fb78d47987fbe35cea74ddcfc3921850da4fa34 version 10.16] automatically create the /usr/lib/modules-load.d/10-ntsync.conf configuration file by default during installation to enable autoloading of the ntsync kernel module on every system reboot. Therefore, you don't need to manually create this file yourself. You should only restart your system after installing these packages, or instead manually run the ntsync kernel module once.
However, you may still need to do so only if you're using a custom, unofficial version of Proton or Wine from the AUR.}}
```
[MangoHud](MangoHud "wikilink") can shows the absence or presence of ESync, FSync or NTSync in games if you have enabled
an indication of *winesync* in its config file.

### Unregister existing Wine file associations {#unregister_existing_wine_file_associations}

By default, Wine takes over as the default application for a lot of formats. Some (e.g. `{{ic|vbs}}`{=mediawiki} or
`{{ic|chm}}`{=mediawiki}) are Windows-specific, and opening them with Wine can be a convenience. However, having other
formats (e.g. `{{ic|gif}}`{=mediawiki}, `{{ic|jpeg}}`{=mediawiki}, `{{ic|txt}}`{=mediawiki}, `{{ic|js}}`{=mediawiki})
open in Wine\'s bare-bones simulations of Internet Explorer and Notepad can be annoying.

Wine\'s file associations are set in `{{ic|~/.local/share/applications/}}`{=mediawiki} as
`{{ic|wine-extension-''extension''.desktop}}`{=mediawiki} files. Delete the files corresponding to the extensions you
want to unregister. Or, to remove all wine extensions:

`$ rm -f ~/.local/share/applications/wine-extension*.desktop`\
`$ rm -f ~/.local/share/icons/hicolor/*/*/application-x-wine-extension*`

Next, remove the old cache:

`$ rm -f ~/.local/share/applications/mimeinfo.cache`\
`$ rm -f ~/.local/share/mime/packages/x-wine*`\
`$ rm -f ~/.local/share/mime/application/x-wine-extension*`

And, update the cache:

`$ update-desktop-database ~/.local/share/applications`\
`$ update-mime-database ~/.local/share/mime/`

Please note Wine will still create new file associations and even recreate the file associations if the application sets
the file associations again.

### Prevent Wine from creating filetype associations {#prevent_wine_from_creating_filetype_associations}

```{=mediawiki}
{{Note|This has to be done for each Wine prefix which should not update file associations unless you opt to change {{ic|/usr/share/wine/wine.inf}}.}}
```
This method prevents the creation of filetype associations but retains the creation of XDG .desktop files (that you
might see e.g. in menus).

If you want to stop wine from creating filetype associations via winecfg you have to uncheck the \"Manage File
Associations\" checkbox under the Desktop Integration tab. See [Wine
FAQ](https://gitlab.winehq.org/wine/wine/-/wikis/FAQ#how-can-i-prevent-wine-from-changing-the-filetype-associations-on-my-system-or-adding-unwanted-menu-entriesdesktop-links)

To make the same change via registry add the string `{{ic|Enable}}`{=mediawiki} with value `{{ic|N}}`{=mediawiki} under:

`HKEY_CURRENT_USER\Software\Wine\FileOpenAssociations`

*You might have to create the key `{{ic|FileOpenAssociations}}`{=mediawiki} first!*

To make this change via the command-line, run the following command:

`$ wine reg add "HKEY_CURRENT_USER\Software\Wine\FileOpenAssociations" /v Enable /d N`

If you want to apply this by default for new Wine prefixes, edit `{{ic|/usr/share/wine/wine.inf}}`{=mediawiki} and add
this line for example under the `{{ic|[Services]}}`{=mediawiki} section:

`HKCU,"Software\Wine\FileOpenAssociations","Enable",2,"N"`

To prevent a package upgrade from overriding the modified file, create a pacman hook to make the change automatically:

```{=mediawiki}
{{hc|/etc/pacman.d/hooks/stop-wine-associations.hook|2=
[Trigger]
Operation = Install
Operation = Upgrade
Type = Path
Target = usr/share/wine/wine.inf

[Action]
Description = Stopping Wine from hijacking file associations...
When = PostTransaction
<nowiki>Exec = /bin/sh -c '/usr/bin/grep -q "HKCU,\"Software\\\Wine\\\FileOpenAssociations\",\"Enable\",2,\"N\"" /usr/share/wine/wine.inf || /usr/bin/sed -i "s/\[Services\]/\[Services\]\nHKCU,\"Software\\\Wine\\\FileOpenAssociations\",\"Enable\",2,\"N\"/g" /usr/share/wine/wine.inf'</nowiki>
}}
```
See [Pacman#Hooks](Pacman#Hooks "wikilink") for more information.

### Execute Windows binaries with Wine implicitly {#execute_windows_binaries_with_wine_implicitly}

The `{{pkg|wine}}`{=mediawiki} package installs a *binfmt* file which will allows you to run Windows programs directly,
e.g. `{{ic|''./myprogram.exe''}}`{=mediawiki} will launch as if you had typed
`{{ic|wine ''./myprogram.exe''}}`{=mediawiki}. Service starts by default on boot, if you have not rebooted after
installing Wine you can [start](start "wikilink") `{{ic|systemd-binfmt.service}}`{=mediawiki} to use it right away.

```{=mediawiki}
{{Note|Make sure the Windows binary is [[executable]], otherwise the binary will not run.}}
```
### Dual Head with different resolutions {#dual_head_with_different_resolutions}

Installing `{{Pkg|libxinerama}}`{=mediawiki} might fix dual-head issues with wine (for example, unclickable buttons and
menus of application in the right most or bottom most monitor, not redrawable interface of application in that zone,
dragging mouse cursor state stucked after leaving application area).

### Burning optical media {#burning_optical_media}

To burn CDs or DVDs, you will need to load the `{{ic|sg}}`{=mediawiki} [kernel module](kernel_module "wikilink").

### Proper mounting of optical media images {#proper_mounting_of_optical_media_images}

Some applications will check for the disc to be in drive. They may check for data only, in which case it might be enough
to configure the corresponding path as being a CD-ROM drive in *winecfg*. However, other applications will look for a
name and/or a serial number, in which case the image has to be mounted with these special properties.

Some virtual drive tools do not handle these metadata, like fuse-based virtual drives (Acetoneiso for instance).
[CDemu](CDemu "wikilink") will handle it correctly.

### Show FPS overlay in games {#show_fps_overlay_in_games}

Wine features an embedded FPS monitor which works for all graphical applications if the environment variable
`{{ic|1=WINEDEBUG=fps}}`{=mediawiki} is set. This will output the framerate to stdout. You can display the FPS on top of
the window thanks to *osd_cat* from the `{{pkg|xosd}}`{=mediawiki} package. See
[winefps.sh](https://gist.github.com/anonymous/844aefd70bb50bf72b35) for a helper script.

### Running Wine under a separate user account {#running_wine_under_a_separate_user_account}

```{=mediawiki}
{{Warning|This is not a proper sandboxing solution and will only protect your home directory using filesystem permissions. If you want a sandbox you should use something like [[firejail]] or [[bubblewrap]], which do not come with the downsides of requiring rootful Xorg or having audio issues.}}
```
It may be desirable to run Wine under a specifically created user account in order to reduce concerns about Windows
applications having access to your home directory.

First, create a [user account](user_account "wikilink") for Wine:

`# useradd -m -s /bin/bash wineuser`

Now switch to another TTY and start your X WM or DE as you normally would or keep reading\...

```{=mediawiki}
{{Note|The following approach only works when enabling root for Xorg. See [[Xorg#Rootless Xorg]] for more information on how to execute the {{ic|xhost}} command under your main user.}}
```
Afterwards, in order to open Wine applications using this new user account you need to add the new user to the X server
permissions list:

`$ xhost +SI:localuser:wineuser`

Finally, you can run Wine via the following command, which uses `{{ic|env}}`{=mediawiki} to launch Wine with the
environment variables it expects:

`$ sudo -u wineuser env HOME=/home/wineuser USER=wineuser USERNAME=wineuser LOGNAME=wineuser wine `*`arguments`*

It is possible to automate the process of running Windows applications with Wine via this method by using a shell script
as follows:

```{=mediawiki}
{{hc|1=/usr/local/bin/runaswine|2=
#!/bin/sh
xhost +SI:localuser:wineuser
sudo -u wineuser env HOME=/home/wineuser USER=wineuser USERNAME=wineuser LOGNAME=wineuser wine "$@"
}}
```
Wine applications can then be launched via:

`$ runaswine `*`"C:\path\to\application.exe"`*

In order to not be asked for a password each time Wine is run as another user the following entry can be added to the
sudoers file: `{{ic|1=''mainuser'' ALL=(wineuser) NOPASSWD: ALL}}`{=mediawiki}. See
[Sudo#Configuration](Sudo#Configuration "wikilink") for more information.

It is recommended to run `{{ic|winecfg}}`{=mediawiki} as the Wine user and remove all bindings for directories outside
the home directory of the Wine user in the \"Desktop Integration\" section of the configuration window so no program run
with Wine has read access to any file outside the special user\'s home directory.

Keep in mind that audio will probably be non-functional in Wine programs which are run this way if
[PulseAudio](PulseAudio "wikilink") is used. See [PulseAudio/Examples#Allowing multiple users to share a PulseAudio
daemon](PulseAudio/Examples#Allowing_multiple_users_to_share_a_PulseAudio_daemon "wikilink") for information about
allowing the Wine user to access the PulseAudio daemon of the principal user.

### Temp directory on tmpfs {#temp_directory_on_tmpfs}

To prevent Wine from writing its temporary files to a physical disk, one can define an alternative location, like
*tmpfs*. Remove Wine\'s default directory for temporary files and creating a symlink:

`$ rm -r ~/.wine/drive_c/users/$USER/Temp ~/.wine/drive_c/windows/temp`\
`$ ln -s /tmp/ ~/.wine/drive_c/users/$USER/Temp`\
`$ ln -s /tmp/ ~/.wine/drive_c/windows/temp`

### Prevent installing Mono/Gecko {#prevent_installing_monogecko}

If Gecko and/or Mono are not present on the system nor in the Wine prefix, Wine will prompt to download them from the
internet. If you do not need Gecko and/or Mono, you might want to disable this dialog, by setting the
`{{ic|WINEDLLOVERRIDES}}`{=mediawiki} [environment variable](environment_variable "wikilink") to
`{{ic|1=mscoree=d;mshtml=d}}`{=mediawiki}.

### Remove Wine file bindings {#remove_wine_file_bindings}

For security reasons it may be useful to remove the preinstalled Wine bindings so Windows applications cannot be
launched directly from a file manager or from the browser (Firefox offers to open EXE files directly with Wine!). If you
want to do this, you may add the following [NoExtract](NoExtract "wikilink") lines in
`{{ic|/etc/pacman.conf}}`{=mediawiki}:

`NoExtract = usr/lib/binfmt.d/wine.conf`\
`NoExtract = usr/share/applications/wine.desktop`

### Wine is setting its own applications as defaults {#wine_is_setting_its_own_applications_as_defaults}

Every time Wine creates (or updates) a prefix it will set its own bundled apps like Notepad and Winebrowser as the
default text editor and web browser accordingly.

A way to work around this undesirable behavior is by using this [environment variable](environment_variable "wikilink"):

`$ WINEDLLOVERRIDES=winemenubuilder.exe=d ...`

### WineASIO

If you need professional audio support under wine you can use `{{Aur|wineasio}}`{=mediawiki} which provides an ASIO
interface for wine that you can then use with [JACK](JACK "wikilink").

In order to use wineasio you must add yourself to the `{{ic|realtime}}`{=mediawiki} [user group](user_group "wikilink").

Next you need to register wineasio in your desired wine prefix. Register the 32-bit and/or 64-bit version as needed:

`$ regsvr32 /usr/lib32/wine/i386-windows/wineasio32.dll`\
`$ wine64 regsvr32 /usr/lib/wine/x86_64-windows/wineasio64.dll`

### Disable starting explorer.exe {#disable_starting_explorer.exe}

If you run a text mode ([Command User
Interface](https://gitlab.winehq.org/wine/wine/-/wikis/Wine-User's-Guide#text-mode-programs-cui-console-user-interface))
executable without X installed, these errors might appear while starting the executable:

```{=mediawiki}
{{bc|
0060:err:winediag:nodrv_CreateWindow Application tried to create a window, but no driver could be loaded.
0060:err:winediag:nodrv_CreateWindow L"The explorer process failed to start."
0060:err:systray:initialize_systray Could not create tray window
}}
```
This is because `{{ic|wine}}`{=mediawiki} by default starts explorer.exe. Even `{{ic|wineconsole}}`{=mediawiki} starts
`{{ic|explorer.exe /desktop}}`{=mediawiki} according to `{{ic|ps}}`{=mediawiki} output.

Starting explorer including systray can be disabled with this environment setting:

`$ WINEDLLOVERRIDES="explorer.exe=d" wine program.exe`

Depending on your CUI program, you might be able to use it with lowest memory footprint by disabling services.exe too:

`$ WINEDLLOVERRIDES="explorer.exe,services.exe=d" wine program.exe`

## Troubleshooting

See [Wine User\'s Guide](https://gitlab.winehq.org/wine/wine/-/wikis/Wine-User's-Guide#troubleshooting--reporting-bugs)
and [Wine FAQ](https://gitlab.winehq.org/wine/wine/-/wikis/FAQ) (especially its
[Troubleshooting](https://gitlab.winehq.org/wine/wine/-/wikis/FAQ#troubleshooting) section) for general tips.

Also refer to the [Wine AppDB](https://appdb.winehq.org/) for an advice on specific applications.

### General installation issues {#general_installation_issues}

Each [Wine prefix](#WINEPREFIX "wikilink") has a lot of persistent state, between the installed programs and the
registry. The first step to troubleshooting issues with program installation should be to either create an isolated
prefix, or clear the default prefix via `{{ic|rm -rf ~/.wine}}`{=mediawiki}. The latter will delete any of the programs
and settings you have added to the default prefix.

### Error loading libc.so.6 {#error_loading_libc.so.6}

You might get the following error when running wine:

```{=mediawiki}
{{hc|$ wine cmd|
/usr/bin/wine: error while loading shared libraries: libc.so.6: cannot create shared object descriptor: Operation not permitted
}}
```
This is caused by the syscall to `{{ic|mmap2}}`{=mediawiki} failing:

`mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = -1 EPERM (Operation not permitted)`

This is a known [bug in the kernel](https://bugzilla.kernel.org/show_bug.cgi?id=198355).

Changing the `{{ic|vm.mmap_min_addr}}`{=mediawiki} [sysctl](sysctl "wikilink") value from the default of
`{{ic|65536}}`{=mediawiki} seems to fix the problem:

`# sysctl -w vm.mmap_min_addr=32768`

### Xwayland problems {#xwayland_problems}

If you use Wine under [Xwayland](Xwayland "wikilink"), you can activate the option for \"Emulating a virtual desktop\"
in the Graphics Tab in winecfg, to avoid problems with:

-   flickering;
-   wrong window location;
-   wrong mouse cursor location and clicks;
-   keyboard detection.

If disabling the Virtual Desktop left you unable to interact with the winecfg window with mouse & keyboard anymore, you
can explicitly start winecfg on a Virtual Desktop anyway and reenable it with:

`$ wine explorer /desktop=name,800x600 winecfg`

When starting GUI windows (eg. winecfg) with Wayland and none are displayed with these errors in console:

```{=mediawiki}
{{hc|$ wine winecfg|
Authorization required, but no authorization protocol specified

008c:err:winediag:nodrv_CreateWindow Application tried to create a window, but no driver could be loaded.
008c:err:winediag:nodrv_CreateWindow L"The explorer process failed to start."
008c:err:systray:initialize_systray Could not create tray window
}}
```
You may try setting the `{{ic|DISPLAY}}`{=mediawiki} variable to `{{ic|:1}}`{=mediawiki}:

`$ DISPLAY=:1 wine winecfg`

### Keyboard input not working {#keyboard_input_not_working}

This could be caused by the window manager not switching focus. In the *Graphics* tab of *winecfg*, disable the \'Allow
the window manager\...\' options, or set windowed mode with \'Emulate a virtual desktop\'.

-   Some suggest to toggle all the *Window settings*, click *Apply*, then change them back. If that does not work, try
    the above.

If the keyboard does not work after unfocusing the application, try editing the registry:

-   Under `{{ic|HKEY_CURRENT_USER\Software\Wine\X11 Driver}}`{=mediawiki}, add a string value
    `{{ic|UseTakeFocus}}`{=mediawiki} and set it to `{{ic|N}}`{=mediawiki}.
-   Alternatively, you can use winetricks to set the value: `{{bc|1=$ winetricks usetakefocus=n}}`{=mediawiki} or use
    wine reg
    `{{bc|1=$ wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /t REG_SZ /v UseTakeFocus /d N /f}}`{=mediawiki}

### Application fails to start {#application_fails_to_start}

Some older games and applications assume that the current [working directory](Wikipedia:Working_directory "wikilink") is
the same as that which the executable is in. Launching these executables from other locations will prevent them from
starting correctly. Use `{{ic|cd ''path_containing_exe''}}`{=mediawiki} before invoking Wine to rule this possibility
out.

### EA App fails to launch games {#ea_app_fails_to_launch_games}

If the total size of the [environment variable](environment_variable "wikilink") block exceeds \~32768 characters, when
attempting to launch any game from the EA App, an error popup will appear instead (the message has changed through the
versions: usually it\'s a generic \"Failed to launch game\", but other times it\'s been \"The game hasn\'t released
yet\").

This is an issue with the application itself, not Wine. The only way to work around this issue is to unset the large
environment variables in your system so that the total size doesn\'t exceed the threshold. Note that Wine intentionally
does not import some environment variables, which alleviates the
issue.[7](https://gitlab.winehq.org/wine/wine/-/blob/a99dc1a779c392980aed0ff12149a2b33966693e/dlls/ntdll/unix/env.c#L343-359)
It is also possible to prevent specific environment variables from being imported by setting an environment variable
with the same key prefixed with
`{{ic|WINE_HOST_}}`{=mediawiki}.[8](https://gitlab.winehq.org/wine/wine/-/blob/baeb97c3572bfcc41b0c13c8e93aa09ae15b7c35/dlls/ntdll/unix/env.c#L884)

## See also {#see_also}

-   [Wine Homepage](https://www.winehq.org/)
-   [Wine Wiki](https://gitlab.winehq.org/wine/wine/-/wikis/home)
-   [Wine Application Database (AppDB)](https://appdb.winehq.org/) - Information about running specific Windows
    applications (Known issues, ratings, guides, etc tailored to specific applications)
-   [Wine Forums](https://forum.winehq.org/) - A great place to ask questions *after* you have looked through the FAQ
    and AppDB
-   [Gentoo:Wine](Gentoo:Wine "wikilink")
-   [Darling](https://www.darlinghq.org/) - a similar project for MacOS software
-   [WineASIO](https://github.com/wineasio/wineasio) - GitHub page of the WineASIO project with further information

[Category:Emulation](Category:Emulation "wikilink") [Category:Gaming](Category:Gaming "wikilink")

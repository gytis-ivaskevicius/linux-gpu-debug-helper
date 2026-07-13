[de:Wayland](de:Wayland "wikilink") [es:Wayland](es:Wayland "wikilink") [hu:Wayland](hu:Wayland "wikilink")
[ja:Wayland](ja:Wayland "wikilink") [pt:Wayland](pt:Wayland "wikilink") [ru:Wayland](ru:Wayland "wikilink")
[zh-hans:Wayland](zh-hans:Wayland "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|Graphics processing unit}}`{=mediawiki} `{{Related|KMS}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki}
`{{Related|Screen capture#Wayland}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[Wayland](https://wayland.freedesktop.org/) is a [display server](Wikipedia:Windowing_system#Display_server "wikilink")
protocol. It has been widely established as the successor of the [X Window System](X_Window_System "wikilink")
[1](https://blogs.kde.org/2025/11/26/going-all-in-on-a-wayland-future/)
[2](https://blogs.gnome.org/alatiera/2025/06/08/the-x11-session-removal/)
[3](https://discourse.ubuntu.com/t/ubuntu-25-10-drops-support-for-gnome-on-xorg/62538)
[4](https://pagure.io/fesco/issue/3408). You can find a [comparison between Wayland and Xorg on
Wikipedia](Wikipedia:Wayland_(display_server_protocol)#Differences_between_Wayland_and_X "wikilink").

Display servers using the Wayland protocol are called **compositors** because they also act as [compositing window
managers](Wikipedia:Compositing_window_manager "wikilink"). Below you can find a [list of Wayland
compositors](#Compositors "wikilink").

For compatibility with native X11 applications to run them seamlessly, [Xwayland](#Xwayland "wikilink") can be used,
which provides an X Server in Wayland.

## Requirements

Wayland is just the protocol, unlike [Xorg](Xorg "wikilink") it does not have a common \"display server\" to install. To
use it, you only need a compatible display driver (this section) and a compositor (next section) or [desktop
environment](desktop_environment "wikilink") (e.g. [GNOME](GNOME "wikilink") or [Plasma](Plasma "wikilink")) that
implements the Wayland protocol. Most Wayland compositors only work on systems using [Kernel mode
setting](Kernel_mode_setting "wikilink").

For the [GPU driver](Graphics_processing_unit "wikilink") and Wayland compositor to be compatible they must support the
same buffer API. There are two main APIs: [GBM](Wikipedia:Generic_Buffer_Management "wikilink") and
[EGLStreams](https://www.phoronix.com/scan.php?page=news_item&px=XDC2016-Device-Memory-API).

  Buffer API   GPU driver support                                Wayland compositor support
  ------------ ------------------------------------------------- -------------------------------------
  GBM          All except [NVIDIA](NVIDIA "wikilink") \< 495\*   All
  EGLStreams   [NVIDIA](NVIDIA "wikilink")                       [GNOME](GNOME "wikilink") \< 51\*\*

:   \* NVIDIA ≥ 495 supports both EGLStreams and
    GBM.[5](https://www.phoronix.com/scan.php?page=news_item&px=NVIDIA-495.44-Linux-Driver)
:   \*\* GNOME 51 drops support for EGLStreams.[6](https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/5079)

Since NVIDIA introduced GBM support, many compositors (including Mutter and KWin) started using it by default for NVIDIA
≥ 495. GBM is generally considered better with wider support, and EGLStreams only had support because NVIDIA did not
provide any alternative way to use their GPUs under Wayland with their proprietary drivers. Furthermore, KWin [dropped
support for EGLStreams](https://invent.kde.org/plasma/kwin/-/merge_requests/1638) after GBM was introduced into NVIDIA.

If you use a popular desktop environment/compositor and a GPU still supported by NVIDIA, you are most likely already
using GBM backend. To check, run `{{ic|journalctl -b 0 --grep "renderer for"}}`{=mediawiki}. To force GBM as a backend,
set the following [environment variables](environment_variables "wikilink"):

`GBM_BACKEND=nvidia-drm`\
`__GLX_VENDOR_LIBRARY_NAME=nvidia`

## Compositors

See [Window manager#Types](Window_manager#Types "wikilink") for the difference between **Stacking**, **Tiling** and
**Dynamic**.

### Stacking

-   ```{=mediawiki}
    {{App|hikari|wlroots-based compositor inspired by [[cwm]] which is actively developed on FreeBSD but also supports Linux.|https://codeberg.org/thomasadam/hikari|{{AUR|hikari}}}}
    ```

-   ```{=mediawiki}
    {{App|KDE [[w:KWin|KWin]]|See [[KDE#Starting Plasma]].|https://userbase.kde.org/KWin|{{Pkg|kwin}}}}
    ```

-   ```{=mediawiki}
    {{App|[[labwc]]|wlroots-based compositor inspired by Openbox.|https://github.com/labwc/labwc|{{Pkg|labwc}}}}
    ```

-   ```{=mediawiki}
    {{App|[[w:Mutter (software)|Mutter]]|See [[GNOME#Starting]].|https://gitlab.gnome.org/GNOME/mutter|{{Pkg|mutter}}}}
    ```

-   ```{=mediawiki}
    {{App|waybox |a *box-style (minimalist) Wayland compositor modeled largely on Openbox|https://github.com/wizbright/waybox | {{AUR|waybox}}}}
    ```

-   ```{=mediawiki}
    {{App|wayfire|3D compositor inspired by [[Compiz]] and based on wlroots.|https://wayfire.org/|{{Pkg|wayfire}}}}
    ```

-   ```{=mediawiki}
    {{App|[[Weston]]|Wayland compositor designed for correctness, reliability, predictability, and performance.|https://gitlab.freedesktop.org/wayland/weston|{{Pkg|weston}}}}
    ```

-   ```{=mediawiki}
    {{App|wio|wlroots-based compositor that aims to replicate the look and feel of Plan 9's Rio desktop.|https://gitlab.com/Rubo/wio|{{AUR|wio-wl}}}}
    ```

-   ```{=mediawiki}
    {{App|wlmaker|wlroots-based compositor that's inspired by [[Window Maker]].|https://phkaeser.github.io/wlmaker/|{{AUR|wlmaker}}}}
    ```

-   ```{=mediawiki}
    {{App|woodland|a minimal lightweight wlroots-based window-stacking compositor for Wayland, inspired by Wayfire and TinyWl.|https://github.com/DiogenesN/woodland|{{AUR|woodland}}}}
    ```

### Tiling

-   ```{=mediawiki}
    {{App|[[Cagebreak]]|Based on cage, inspired by [[ratpoison]].|https://github.com/project-repo/cagebreak|{{AUR|cagebreak}}}}
    ```

-   ```{=mediawiki}
    {{App|jay|A Wayland compositor, written in Rust. Appearance is based on the default i3 look and feel. Jay can be configured via a declarative TOML file or a shared library that gets injected into the compositor.|https://github.com/mahkoh/jay|{{AUR|jay}}}}
    ```

-   ```{=mediawiki}
    {{App|IonWL|Manual tiling compositor. Follows Ion3's design with a comprehensive Python API.|https://codeberg.org/ideasman42/IonWL|{{AUR|ionwl-git}}}}
    ```

-   ```{=mediawiki}
    {{App|miracle-wm|A Wayland compositor based on Mir in the style of i3 and sway with the intention to be flashier and more feature-rich than either, like swayfx.|https://github.com/miracle-wm-org/miracle-wm|{{AUR|miracle-wm}}}}
    ```

-   ```{=mediawiki}
    {{App|[[niri]]|A scrollable-tiling Wayland compositor.|https://github.com/niri-wm/niri|{{Pkg|niri}}}}
    ```

-   ```{=mediawiki}
    {{App|[[Qtile]]|A full-featured, hackable tiling window manager and Wayland compositor written and configured in Python.|https://github.com/qtile/qtile|{{Pkg|qtile}}}}
    ```

-   ```{=mediawiki}
    {{App|[[Sway]]|[[i3]]-compatible Wayland compositor based on wlroots.|https://github.com/swaywm/sway|{{Pkg|sway}}}}
    ```

-   ```{=mediawiki}
    {{App|SwayFx|[[Sway]], but with eye candy!|https://github.com/WillPower3309/swayfx|{{AUR|swayfx}}}}
    ```

-   ```{=mediawiki}
    {{App|Velox|Simple window manager based on swc, inspired by dwm and [[xmonad]].|https://github.com/michaelforney/velox|{{AUR|velox-git}}}}
    ```

### Dynamic

-   ```{=mediawiki}
    {{App|[[COSMIC]] Compositor|Compositor for the COSMIC desktop environment.|https://github.com/pop-os/cosmic-comp|{{Pkg|cosmic-comp}}}}
    ```

-   ```{=mediawiki}
    {{App|[[cwc]]|[[awesome]]-like Wayland compositor based on wlroots.|https://cudiph.github.io/cwc/apidoc/| {{AUR|cwc}}}}
    ```

-   ```{=mediawiki}
    {{App|[[MangoWM]]|A [[dwl]]-based compositor with a standard configuration file, an optional scrolling layout and support for eye candy.|https://github.com/mangowm/mango|{{AUR|mangowm}}}}
    ```

-   ```{=mediawiki}
    {{App|[[dwl]]|[[dwm]]-like Wayland compositor based on wlroots.|https://codeberg.org/dwl/dwl|{{AUR|dwl}}}}
    ```

-   ```{=mediawiki}
    {{App|[[Hyprland]]|A dynamic tiling Wayland compositor that does not sacrifice on its looks.|https://hypr.land|{{Pkg|hyprland}}}}
    ```

-   ```{=mediawiki}
    {{App|japokwm|Dynamic Wayland tiling compositor based around creating layouts, based on wlroots.|https://github.com/werererer/japokwm|{{AUR|japokwm-git}}}}
    ```

-   ```{=mediawiki}
    {{App|[[river-classic]]|Dynamic tiling Wayland compositor inspired by dwm and [[bspwm]].|https://codeberg.org/river/river-classic|{{Pkg|river-classic}}}}
    ```

-   ```{=mediawiki}
    {{App|pinnacle-comp|A Smithay-based Wayland compositor, inspired by AwesomeWM and configured in Lua or Rust |https://github.com/pinnacle-comp/pinnacle|{{AUR|pinnacle-comp}}}}
    ```

### Other

-   ```{=mediawiki}
    {{App|Cage|Displays a single fullscreen application like a kiosk.|https://www.hjdskes.nl/projects/cage/|{{Pkg|cage}}}}
    ```

-   ```{=mediawiki}
    {{App|GNOME Kiosk|Mutter based compositor that provides an environment suitable for fixed purpose, or single application deployments like wall displays and point-of-sale systems.|https://gitlab.gnome.org/GNOME/gnome-kiosk|{{AUR|gnome-kiosk}}}}
    ```

-   ```{=mediawiki}
    {{App|phoc|A tiny wlroots-based compositor for mobile devices.|https://gitlab.gnome.org/World/Phosh/phoc|{{Pkg|phoc}}}}
    ```

-   ```{=mediawiki}
    {{App|Wayback|X11 compatibility layer which allows for running full X11 desktop environments using Wayland components. It is experimental, in the early stage of development.|https://wayback.freedesktop.org/|{{AUR|wayback-x11}}}}
    ```

-   ```{=mediawiki}
    {{App|[[River]]| A non-monolithic Wayland compositor. Unlike other Wayland compositors, it does not combine the compositor and window manager into one program. Instead, users can choose any window manager implementing the river-window-management-v1 protocol.|https://isaacfreund.com/software/river/|{{Pkg|river}}}}
    ```

Some of the above may support [display managers](display_manager "wikilink"). Check
`{{ic|/usr/share/wayland-sessions/''compositor''.desktop}}`{=mediawiki} to see how they are started.

## Display managers {#display_managers}

Display managers listed below support launching Wayland compositors.

+--------------------------------------+--------------------------------------+--------------------------------------+
| Name                                 | Runs on                              | Description                          |
+======================================+======================================+======================================+
| ```{=mediawiki}                      | Wayland                              | Display manager with first-class     |
| {{AUR|atrium}}                       |                                      | multiseat support.                   |
| ```                                  |                                      |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| ```{=mediawiki}                      | tty                                  | Simple CLI Display Manager on TTY.   |
| {{Pkg|emptty}}                       |                                      |                                      |
| ```                                  |                                      |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [GDM](GDM "wikilink")                | Wayland                              | [GNOME](GNOME "wikilink") display    |
|                                      |                                      | manager.                             |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [greetd](greetd "wikilink")          | Wayland/Xorg/tty See                 | Minimal and flexible login daemon.   |
|                                      | [Greetd#Gr                           |                                      |
|                                      | eeters](Greetd#Greeters "wikilink"). |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| ```{=mediawiki}                      | tty                                  | TUI display manager written in Rust. |
| {{Pkg|lemurs}}                       |                                      |                                      |
| ```                                  |                                      |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| ```{=mediawiki}                      | tty                                  | A fully colorful customizable TUI    |
| {{AUR|lidm}}                         |                                      | display manager made in C.           |
| ```                                  |                                      |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [LightDM](LightDM "wikilink")        | Xorg[7](https://gith                 | Cross-desktop display manager.       |
|                                      | ub.com/canonical/lightdm/issues/267) |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [ly](ly "wikilink")                  | tty                                  | TUI display manager written in Zig   |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [Plasma Login                        | Wayland                              | [KDE](KDE "wikilink") display        |
| Manag                                |                                      | manager.                             |
| er](Plasma_Login_Manager "wikilink") |                                      |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [SDDM](SDDM "wikilink")              | Wayland/Xorg                         | QML-based display manager.           |
+--------------------------------------+--------------------------------------+--------------------------------------+
| ```{=mediawiki}                      | tty                                  | Simple CLI session launcher written  |
| {{AUR|tbsm}}                         |                                      | in pure bash.                        |
| ```                                  |                                      |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [uwsm](uwsm "wikilink")              | tty                                  | Session and XDG autostart manager    |
|                                      |                                      | for standalone compositors. Provides |
|                                      |                                      | a TUI menu, but can also be used     |
|                                      |                                      | with other display managers.         |
+--------------------------------------+--------------------------------------+--------------------------------------+

## Xwayland

```{=mediawiki}
{{man|1|Xwayland}}
```
is an X server that runs under Wayland and provides compatibility for native [X11](X11 "wikilink") applications that are
yet to provide Wayland support. To use it, [install](install "wikilink") the `{{Pkg|xorg-xwayland}}`{=mediawiki}
package.

Xwayland is started via a compositor, so you should check the documentation for your chosen compositor for Xwayland
compatibility and instructions on how to start Xwayland.

By default, Xwayland runs its X server in [rootless](Xorg#Rootless_Xorg "wikilink") mode.

```{=mediawiki}
{{Note|
* Security: Xwayland is an X server, so it does not have the security features of Wayland.
* Performance: Xwayland has a [https://openbenchmarking.org/result/2202053-NE-NVIDIARTX35 nearly identical performance] to that of X11, in most cases.
* Compatibility: Xwayland is not fully backward compatible with X11. Some applications may not work properly under Xwayland.
}}
```
### Wayback

[Wayback](https://wayback.freedesktop.org/) (`{{AUR|wayback-x11}}`{=mediawiki}, `{{AUR|wayback-x11-git}}`{=mediawiki}),
is an X11 compatibility layer which allows for running full X11 desktop environments using Wayland components. It is
intended to eventually replace the classic X.Org server, thus reducing maintenance burden of X11 applications.

### NVIDIA driver {#nvidia_driver}

```{=mediawiki}
{{Note|NVIDIA drivers prior to version 470 (e.g. {{AUR|nvidia-390xx-dkms}}) do not support hardware accelerated Xwayland, causing non-Wayland-native applications to suffer from poor performance in Wayland sessions.}}
```
Enabling [DRM KMS](NVIDIA#DRM_kernel_mode_setting "wikilink") is required. There may be additional information in the
[official documentation](https://download.nvidia.com/XFree86/Linux-x86_64/515.48.07/README/xwayland.html) regarding your
display manager (e.g. [GDM](GDM#Wayland_and_the_proprietary_NVIDIA_driver "wikilink")).

### Detect Xwayland applications {#detect_xwayland_applications}

To determine whether an application is running via Xwayland, you can use *xeyes* from `{{pkg|xorg-xeyes}}`{=mediawiki}:
the eyes are moving, when moving the mouse pointer over an application window.

Another option is to run *xwininfo* (from `{{Pkg|xorg-xwininfo}}`{=mediawiki}) in a terminal window: when hovering over
an Xwayland window the mouse pointer will turn into a + sign. If you click the window it will display some information
and end, but it will not do anything with native Wayland windows.You can use `{{ic|Ctrl+C}}`{=mediawiki} to end it.

You can also use *xlsclients* (from the `{{Pkg|xorg-xlsclients}}`{=mediawiki} package). To list all applications running
via Xwayland, run `{{ic|xlsclients -l}}`{=mediawiki}.

Alternatively, you can start `{{AUR|extramaus}}`{=mediawiki} and move your mouse pointer over the window of an
application. If the red mouse moves, the application is running via Xwayland.

```{=mediawiki}
{{Tip|For KDE Plasma, you can also inspect windows with [[KDE#KWin debug console]].}}
```
## GUI libraries {#gui_libraries}

### EFL

Enlightenment has [Wayland support](https://www.enlightenment.org/about-wayland). To run an EFL-based application on
Wayland, set the environment variable `{{ic|1=ELM_DISPLAY=wl}}`{=mediawiki}.

### Electron

Since [Electron](Electron "wikilink") 38.2, Wayland is used by default.
[8](https://www.electronjs.org/blog/tech-talk-wayland) For earlier versions, Wayland support can be activated using the
`{{ic|1=--ozone-platform=auto}}`{=mediawiki} or `{{ic|1=--ozone-platform=wayland}}`{=mediawiki} command line flags, or
by setting the [environment variable](environment_variable "wikilink") `{{ic|ELECTRON_OZONE_PLATFORM_HINT}}`{=mediawiki}
to `{{ic|auto}}`{=mediawiki} or `{{ic|wayland}}`{=mediawiki}.

### FLTK

Wayland is supported since `{{Pkg|fltk}}`{=mediawiki} 1.4, and it uses the Wayland backend by default. It is possible to
override it to use Xwayland in a Wayland session by modifying an environment variable:
`{{ic|1=FLTK_BACKEND=x11}}`{=mediawiki}. [9](https://github.com/fltk/fltk/blob/master/README.Wayland.txt).

### GLFW

The `{{Pkg|glfw}}`{=mediawiki} package has support for Wayland, and uses the Wayland backend if the [environment
variable](environment_variable "wikilink") `{{ic|1=XDG_SESSION_TYPE}}`{=mediawiki} is set to
`{{ic|1=wayland}}`{=mediawiki} and the application developer has not set a specific desired backend.

See the [source code](https://github.com/glfw/glfw/blob/3.4/src/platform.c#L87-L99) for more information.

### GTK

The `{{Pkg|gtk3}}`{=mediawiki} and `{{Pkg|gtk4}}`{=mediawiki} packages have the Wayland backend enabled. GTK will
default to the Wayland backend, but it is possible to override it to use Xwayland in a Wayland session by modifying an
environment variable: `{{ic|1=GDK_BACKEND=x11}}`{=mediawiki}.

For theming issues, see [GTK#Wayland backend](GTK#Wayland_backend "wikilink").

### Java

The open source implementation of the [Java](Java "wikilink") platform OpenJDK does not yet have native support for
Wayland. The [Wakefield](https://openjdk.java.net/projects/wakefield/) project is working on a component named
[WLToolkit](https://wiki.openjdk.org/display/wakefield/Pure+Wayland+toolkit+prototype) to add Wayland support to
OpenJDK.

It is possible to use Wakefield's `{{ic|jdk25-wayland}}`{=mediawiki}
[10](https://github.com/openjdk/wakefield/tree/jdk25-wayland) work-in-progress branch. Some programs such as the
[JetBrains IDEs](https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/) do just that so they
support Wayland out of the box. For other Java programs, you need you bring your own Wakefield build, e.g.
`{{AUR|jdk-openjdk-wakefield}}`{=mediawiki}. To use it, point `{{ic|JAVA_HOME}}`{=mediawiki} to
`{{ic|/usr/lib/jvm/java-25-openjdk-wakefield}}`{=mediawiki} and run your program with the
`{{ic|-Dawt.toolkit.name{{=}}`{=mediawiki}WLToolkit}} option.

### Qt

[Qt](Qt "wikilink") 6 supports Wayland and uses it by default in a Wayland session.

To enable Wayland support in [Qt](Qt "wikilink") 5, install the `{{Pkg|qt5-wayland}}`{=mediawiki} package, and use
`{{ic|1=-platform wayland}}`{=mediawiki} command line parameter or `{{ic|1=QT_QPA_PLATFORM=wayland}}`{=mediawiki}
[environment variable](environment_variable "wikilink"). [11](https://wiki.qt.io/QtWayland#How_do_I_use_QtWayland.3F).
`{{ic|1=QT_QPA_PLATFORM="wayland;xcb"}}`{=mediawiki} allows Qt to use the xcb (X11) plugin instead if Wayland is not
available.

To force the usage of Xwayland in a Wayland session, use `{{ic|1=-platform xcb}}`{=mediawiki} command line parameter or
`{{ic|1=QT_QPA_PLATFORM=xcb}}`{=mediawiki}.

### SDL

In [SDL3](SDL "wikilink"), Wayland is used by default if the compositor supports the [fifo-v1
protocol](https://wayland.app/protocols/fifo-v1).
[12](https://github.com/libsdl-org/SDL/blob/8c54961de02d8f62ed155925cb334efcaa2d1f95/src/video/wayland/SDL_waylandvideo.c#L536C9-L536C20)
Otherwise, X11 and Wayland are tried in order. Either can be forced either using the
`{{ic|1=SDL_VIDEO_DRIVER=x11}}`{=mediawiki} or `{{ic|1=SDL_VIDEO_DRIVER=wayland}}`{=mediawiki} environment variables
respectively (or, with a lower precedence, the SDL2 environment variable below).
[13](https://github.com/libsdl-org/SDL/blob/8c54961de02d8f62ed155925cb334efcaa2d1f95/docs/README-migration.md?plain=1#L802)

```{=mediawiki}
{{Pkg|sdl2-compat}}
```
follows the SDL3 rules above, barring [application-specific
exceptions](https://github.com/libsdl-org/sdl2-compat/blob/8b85f95bbcc3411c78c1f2cbd62b23b7f96093c2/src/sdl2_compat.c#L504-L538).
As for SDL2 proper (e.g. `{{AUR|sdl2}}`{=mediawiki}), set `{{ic|1=SDL_VIDEODRIVER=wayland}}`{=mediawiki}.
`{{ic|1=SDL_VIDEODRIVER="wayland,x11"}}`{=mediawiki} allows SDL2 to use the x11 video driver instead if Wayland is not
available. [14](https://wiki.libsdl.org/SDL2/FAQUsingSDL)

You may also want to install `{{Pkg|libdecor}}`{=mediawiki} to enable client-side window decorations (for example, on
GNOME).

Refer to the [official documentation](https://wiki.libsdl.org/SDL3/README-wayland) for more details.

### winit

Winit is a window handling library in Rust. It will default to the Wayland backend, but it is possible to override it to
use Xwayland by modifying environment variables:

-   Prior to version 0.29.2, set `{{ic|1=WINIT_UNIX_BACKEND=x11}}`{=mediawiki}
-   For version 0.29.2 and higher, unset `{{ic|1=WAYLAND_DISPLAY}}`{=mediawiki}, which forces a fallback to X using the
    `{{ic|1=DISPLAY}}`{=mediawiki} variable.
    [15](https://github.com/rust-windowing/winit/blob/baf10de95843f156b0fbad6b10c3137f1ebd4f1e/src/changelog/v0.29.md?plain=1#L134)

## Tips and tricks {#tips_and_tricks}

### Automation

-   ```{=mediawiki}
    {{App|{{man|1|ydotool}}|Generic command-line automation tool (not limited to Wayland). [[Enable/start]] the {{ic|ydotool.service}} [[user unit]].|https://github.com/ReimuNotMoe/ydotool|{{Pkg|ydotool}}}}
    ```

-   ```{=mediawiki}
    {{App|{{man|1|wtype}}|xdotool type for Wayland.|https://github.com/atx/wtype|{{Pkg|wtype}}}}
    ```

-   ```{=mediawiki}
    {{App|keyboard|Python library to hook and simulate keyboard events.|https://github.com/boppreh/keyboard|{{AUR|python-keyboard}}}}
    ```

-   ```{=mediawiki}
    {{App|mouse|Python library to hook and simulate mouse events.|https://github.com/boppreh/mouse|{{AUR|python-mouse}}}}
    ```

-   ```{=mediawiki}
    {{App|wlrctl|A command line utility for miscellaneous wlroots extensions (supports the foreign-toplevel-management, virtual-keyboard, virtual-pointer).|https://git.sr.ht/~brocellous/wlrctl|{{AUR|wlrctl}}}}
    ```

-   ```{=mediawiki}
    {{App|CrossMacro|Cross-platform desktop automation app with macro recording, playback, scheduling, text expansion, CLI tools, and Wayland/X11-aware Linux support.|https://github.com/alper-han/CrossMacro|{{AUR|crossmacro}}}}
    ```

### Remap keyboard or mouse keys {#remap_keyboard_or_mouse_keys}

See [Input remap utilities](Input_remap_utilities "wikilink").

### Screencast

See [Screen capture#Screencasting](Screen_capture#Screencasting "wikilink") and [Screen capture#Screencast Wayland
windows with X11 applications](Screen_capture#Screencast_Wayland_windows_with_X11_applications "wikilink").

### Persist clipboard after app close {#persist_clipboard_after_app_close}

```{=mediawiki}
{{Merge|Clipboard|This is a standard behavior even on Xorg. There are many other clipboard managers.}}
```
Due to Wayland\'s design philosophy, clipboard data is stored in the memory of the source client. When the client
closes, the clipboard data is lost. You can solve this using `{{Pkg|wl-clip-persist}}`{=mediawiki}, which runs in the
background to reads the clipboard data and stores it in its own memory, separate from the source client.

### Autostart wayland compositor as systemd service {#autostart_wayland_compositor_as_systemd_service}

```{=mediawiki}
{{Note| [[Universal Wayland Session Manager]] automatically generates systemd units for your compositors, moreover it helps you to [[Universal Wayland Session Manager#Applications and autostart|integrate graphical applications with systemd]].}}
```
If you do not want to use a display manager or a shell, you can autostart your Wayland compositor with a
[systemd](systemd "wikilink") service. Adjust the `{{ic|ExecStart}}`{=mediawiki} line with the compositor you want to
use. Here is an example for [KDE Plasma](KDE_Plasma "wikilink"):

```{=mediawiki}
{{hc|/etc/systemd/system/wayland-compositor.service|2=
[Unit]
After=graphical.target systemd-user-sessions.service modprobe@drm.service
Conflicts=getty@tty1.service

[Service]
User=''username''
WorkingDirectory=~

PAMName=login
TTYPath=/dev/tty1
UnsetEnvironment=TERM

StandardOutput=journal
ExecStart=/usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland

[Install]
WantedBy=graphical.target
}}
```
### Use another renderer for wlroots based compositor {#use_another_renderer_for_wlroots_based_compositor}

You can use another [wlroots renderer](https://gitlab.freedesktop.org/wlroots/wlroots/-/tree/master/render) such as
[Vulkan](Vulkan "wikilink") by specifying the `{{ic|WLR_RENDERER}}`{=mediawiki} environment variable for wlroots based
compositor. The list of available ones is on the [wlroots
documentation](https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md).

### Specifying the primary graphics cards on wlroot based compositor {#specifying_the_primary_graphics_cards_on_wlroot_based_compositor}

If your device has [Hybrid graphics](Hybrid_graphics "wikilink") , then you can use `{{ic|WLR_DRM_DEVICES}}`{=mediawiki}
environment variable to specifies primary graphics cards according to the [wlroots
documentation](https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md)

Example:

`WLR_DRM_DEVICES='/dev/dri/card1:/dev/dri/card2:/dev/dri/card0'`

### Remote display {#remote_display}

-   ```{=mediawiki}
    {{Pkg|wlroots0.18}}
    ```
    and `{{Pkg|wlroots0.19}}`{=mediawiki} (used by [sway](sway "wikilink")) offers a VNC backend via
    `{{Pkg|wayvnc}}`{=mediawiki} since version 0.10. RDP backend has been removed
    [16](https://github.com/swaywm/wlroots/releases/tag/0.10.0).

-   ```{=mediawiki}
    {{pkg|mutter}}
    ```
    has now remote desktop enabled at compile time, see [17](https://wiki.gnome.org/Projects/Mutter/RemoteDesktop) and
    `{{Pkg|gnome-remote-desktop}}`{=mediawiki} for details.

-   ```{=mediawiki}
    {{pkg|krfb}}
    ```
    offers a VNC server for `{{pkg|kwin}}`{=mediawiki}. `{{ic|krfb-virtualmonitor}}`{=mediawiki} can be used to set up
    another device as an extra monitor.

-   There was a merge of FreeRDP into Weston in 2013, enabled via a compile flag. The `{{Pkg|weston}}`{=mediawiki}
    package has it enabled since version 6.0.0.

-   ```{=mediawiki}
    {{Pkg|waypipe}}
    ```
    is a transparent proxy for Wayland applications, with a wrapper command to run over [SSH](SSH "wikilink")

    -   Here is an example for launching a remote KDE kcalc under Plasma:

:   

    :   ```{=mediawiki}
        {{bc|1=$ waypipe ssh example.local env QT_QPA_PLATFORM=wayland QT_QPA_PLATFORMTHEME=KDE dbus-launch kcalc}}
        ```

## Troubleshooting

First, make sure that your current session is running under Wayland instead of [X11](X11 "wikilink") (many compositors
support both). This can be done by examining the `{{ic|WAYLAND_DISPLAY}}`{=mediawiki} [environment
variable](environment_variable "wikilink") (it should begin with `{{ic|wayland-}}`{=mediawiki}), and/or checking that
`{{ic|XDG_SESSION_TYPE}}`{=mediawiki} is `{{ic|wayland}}`{=mediawiki}.

For (possibly) application-related issues, consider also checking whether the application [is running under
XWayland](#Detect_XWayland_applications "wikilink").

### Useful tools {#useful_tools}

-   ```{=mediawiki}
    {{ic|wayland-info}}
    ```
    from `{{Pkg|wayland-utils}}`{=mediawiki}: displays information about the current compositor.

-   ```{=mediawiki}
    {{Pkg|wev}}
    ```
    : for debugging Wayland events on a Wayland window, analagous to the X11 tool [xev](xev "wikilink").

-   ```{=mediawiki}
    {{Pkg|wlopm}}
    ```
    : Wayland output power management for compositors that support the [wlr output power management
    protocol](https://wayland.app/protocols/wlr-output-power-management-unstable-v1).

-   ```{=mediawiki}
    {{Pkg|wlr-randr}}
    ```
    : Manages outputs of Wayland compositors that support the [wlr output management
    protocol](https://wayland.app/protocols/wlr-output-management-unstable-v1).

### Color correction {#color_correction}

See [Backlight#Color correction](Backlight#Color_correction "wikilink").

### GNOME: Slow motion, graphical glitches, and crashes {#gnome_slow_motion_graphical_glitches_and_crashes}

Gnome-shell users may experience display issues when they switch to Wayland from X. One of the root cause might be the
`{{ic|1=CLUTTER_PAINT=disable-clipped-redraws:disable-culling}}`{=mediawiki} set by yourself for Xorg-based gnome-shell.
Just try to remove it from `{{ic|/etc/environment}}`{=mediawiki} or other rc files to see if everything goes back to
normal.

### Input grabbing in games, remote desktop and virtual machine windows {#input_grabbing_in_games_remote_desktop_and_virtual_machine_windows}

In contrast to Xorg, Wayland does not allow exclusive input device grabbing, also known as active or explicit grab (e.g.
[keyboard](https://tronche.com/gui/x/xlib/input/XGrabKeyboard.html),
[mouse](https://tronche.com/gui/x/xlib/input/XGrabPointer.html)), instead, it depends on the Wayland compositor to pass
keyboard shortcuts and confine the pointer device to the application window.

This change in input grabbing breaks current applications\' behavior, meaning:

-   Hotkey combinations and modifiers will be caught by the compositor and will not be sent to remote desktop and
    virtual machine windows.
-   The mouse pointer will not be restricted to the application\'s window which might cause a parallax effect where the
    location of the mouse pointer inside the window of the virtual machine or remote desktop is displaced from the
    host\'s mouse pointer.

Wayland solves this by adding protocol extensions for Wayland and Xwayland. Support for these extensions is needed to be
added to the Wayland compositors. In the case of native Wayland clients, the used widget toolkits (e.g GTK, Qt) needs to
support these extensions or the applications themselves if no widget toolkit is being used. In the case of Xorg
applications, no changes in the applications or widget toolkits are needed as the Xwayland support is enough.

These extensions are already included in `{{pkg|wayland-protocols}}`{=mediawiki}, and supported by
`{{pkg|xorg-xwayland}}`{=mediawiki}.

The related extensions are:

-   [Xwayland keyboard grabbing
    protocol](https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/main/unstable/xwayland-keyboard-grab/xwayland-keyboard-grab-unstable-v1.xml)
-   [Compositor shortcuts inhibit
    protocol](https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/main/unstable/keyboard-shortcuts-inhibit/keyboard-shortcuts-inhibit-unstable-v1.xml)
-   [Relative pointer
    protocol](https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/main/unstable/relative-pointer/relative-pointer-unstable-v1.xml)
-   [Pointer constraints
    protocol](https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/main/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml)

Supporting Wayland compositors:

-   Mutter, [GNOME](GNOME "wikilink")\'s compositor [since release
    3.28](https://bugzilla.gnome.org/show_bug.cgi?id=783342)
-   wlroots supports relative-pointer and pointer-constraints
-   Kwin
    -   [KDE#X11 shortcuts conflict on Wayland](KDE#X11_shortcuts_conflict_on_Wayland "wikilink")
    -   [Keyboard shortcuts
        inhibit](https://invent.kde.org/plasma/kwin/-/blob/master/src/wayland/keyboard_shortcuts_inhibit_v1_interface.cpp)

Supporting widget toolkits:

-   GTK since release 3.22.18.

### GTK themes not working {#gtk_themes_not_working}

See <https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland>.

### Avoid loading NVIDIA modules {#avoid_loading_nvidia_modules}

Add `{{ic|1=__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json}}`{=mediawiki} as [environment
variable](environment_variable "wikilink") before launching a Wayland compositor like [sway](sway "wikilink").

### Magnifying/surface scaling {#magnifyingsurface_scaling}

Screen magnifying is not solved yet, a pull request was merged mid-2022 [providing the protocol
wp-surface-scale](https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/145).

### Wayland lag/stuttering since kernel 6.11.2 (AMD) {#wayland_lagstuttering_since_kernel_6.11.2_amd}

Until this issue is patched in future kernel releases, a workaround is to add
`{{ic|1=amdgpu.dcdebugmask=0x400}}`{=mediawiki} to the cmdline.

See: <https://community.frame.work/t/wayland-lag-stuttering-since-kernel-6-11-2/59422>

### Games / applications suspended when changing a virtual desktop {#games_applications_suspended_when_changing_a_virtual_desktop}

```{=mediawiki}
{{Expansion|Add more information and reference to upstream documentation here if found: the feature is elusive and seems poorly documented.}}
```
When changing workspace or using `{{ic|Alt+Tab}}`{=mediawiki}, games (and possibly other graphical applications) are
suspended, put in some weird state, and they (partially) stop. This includes VRR applications and applications with
VSync turned on but is not limited to them only. Symptoms include things like audio dropping (partially) out, game not
progressing, ping times rising high or network dropping out, but only if the game window is not in focus. This may only
affect applications with VSync on.

It is possible some games can work around this issue by changing to a window, but some do not. This is extremely
annoying in more complex games which require heavy usage of web browsing, documentation and 3rd party tools or if the
gameplay is interrupted for some reason.

Possible workaround include setting environment variables `{{ic|1=MESA_VK_WSI_PRESENT_MODE=immediate}}`{=mediawiki}
and/or `{{ic|1=vk_xwayland_wait_ready=false}}`{=mediawiki}, but setting these will break any VSync or VRR
implementations.

## See also {#see_also}

-   [Wayland documentation online](https://wayland.freedesktop.org/docs/html/)
-   [Official repository](https://gitlab.freedesktop.org/wayland)
-   [Fedora:How to debug Wayland problems](Fedora:How_to_debug_Wayland_problems "wikilink")
-   [We are Wayland now!](https://wearewaylandnow.com/) - An updated version of \"Are we Wayland yet?\"
-   [Awesome Wayland projects](https://awesomeopensource.com/projects/wayland)
-   [Cursor themes](Cursor_themes "wikilink")
-   [Arch Linux forum discussion](https://bbs.archlinux.org/viewtopic.php?id=107499)
-   [i3 Migration Guide - Common X11 apps used on i3 with Wayland
    alternatives](https://github.com/swaywm/sway/wiki/i3-Migration-Guide#common-x11-apps-used-on-i3-with-wayland-alternatives)
-   [Wayland Explorer - A better way to read Wayland documentation](https://wayland.app/protocols/)
-   [How can I tell if an application is using
    XWayland](https://askubuntu.com/questions/1393618/how-can-i-tell-if-an-application-is-using-xwayland)

[Category:Wayland](Category:Wayland "wikilink")

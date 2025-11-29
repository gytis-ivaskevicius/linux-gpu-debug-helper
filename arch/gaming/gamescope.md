[ja:Gamescope](ja:Gamescope "ja:Gamescope"){.wikilink}
[zh-hans:Gamescope](zh-hans:Gamescope "zh-hans:Gamescope"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|Steam}}`{=mediawiki} `{{Related|Gaming}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[Gamescope](https://github.com/ValveSoftware/gamescope) is a
[microcompositor](Wayland#Compositors "microcompositor"){.wikilink} from Valve that is used on the [Steam
Deck](Steam_Deck "Steam Deck"){.wikilink}. Its goal is to provide an isolated compositor that is tailored towards gaming
and supports many gaming-centric features such as:

- Spoofing resolutions.
- Upscaling using AMD FidelityFX™ Super Resolution or NVIDIA Image Scaling.
- Limiting framerates.

As a microcompositor it is designed to run as a nested session on top of your existing desktop environment though it is
also possible to use it as an embedded compositor as well.

## Installation

Gamescope can be [installed](install "install"){.wikilink} with the `{{pkg|gamescope}}`{=mediawiki} package.
Additionally there is also `{{aur|gamescope-plus}}`{=mediawiki} which includes extra patches not present in the mainline
build.

### Requirements

- AMD: Mesa 20.3 or above
- Intel: Mesa 21.2 or above
- NVIDIA: proprietary drivers 515.43.04 or above, and the `{{ic|1=nvidia_drm.modeset=1}}`{=mediawiki} [kernel
  parameter](kernel_parameter "kernel parameter"){.wikilink}

## Usage

Gamescope offers many options, far too many to cover here. For a full list use the `{{ic|gamescope --help}}`{=mediawiki}
command from a terminal.

### From a display manager {#from_a_display_manager}

See [Steam#Big Picture Mode from a display
manager](Steam#Big_Picture_Mode_from_a_display_manager "Steam#Big Picture Mode from a display manager"){.wikilink}.

### From a desktop session {#from_a_desktop_session}

The following command will run supertuxkart using Gamescope and force a 1920x1080 resolution at 60 FPS

`$ gamescope -W 1920 -H 1080 -r 60 -- supertuxkart`

### From Steam {#from_steam}

You can run games from Steam using Gamescope by adding the following to the games launch options

`gamescope -- %command%`

```{=mediawiki}
{{Note|It is still required that you set flags such as resolution, FPS etc when launching from Steam otherwise Gamescope will launch at an incorrect resolution. You can do this in the same way as from a terminal, for example}}
```
`gamescope -W 1920 -H 1080 -r 60 -- %command%`

### From Wine {#from_wine}

To run programs using Gamescope through [Wine](Wine "Wine"){.wikilink}, simply append *wine* followed by the executable.

`$ gamescope -W 1920 -H 1080 -r 60 -- wine supertuxkart.exe`

Almost all the popular Wine managers such as [Lutris](Lutris "Lutris"){.wikilink},
[Bottles](Bottles "Bottles"){.wikilink}, and [PlayOnLinux](PlayOnLinux "PlayOnLinux"){.wikilink} have support for
Gamescope. Using them is as simple as installing the desired Gamescope package and checking the *Use Gamescope* (or
similar) option.

```{=mediawiki}
{{Note|Wine managers also tend to have a graphical interface to configure basic Gamescope options making them, in general, the easiest way to use Gamescope.}}
```
### From Flatpak {#from_flatpak}

You can also use Gamescope from [Flatpak](Flatpak "Flatpak"){.wikilink} versions of Wine managers and
[Steam](Steam "Steam"){.wikilink} in the same way as you would from a package install. It does however require that you
first install Gamescope from Flathub with the following command:

`$ flatpak install gamescope`

### Upscaling

The `{{ic|-F fsr}}`{=mediawiki} and `{{ic|-F nis}}`{=mediawiki} flags can be used to upscale games using AMD FidelityFX™
Super Resolution 1.0 (FSR) or NVIDIA Image Scaling v1.0.3 (NIS) respectively. You can also use
`{{ic|-S integer}}`{=mediawiki} for integer upscaling or `{{ic|-S stretch}}`{=mediawiki} for stretch scaling.

To upscale a 720p game to 1440p using FSR:

`$ gamescope -h 720 -H 1440 -F fsr -- supertuxkart`

To run a game at 1080p internal resolution but display it at 4K using NIS:

`$ gamescope -w 1920 -h 1080 -W 3840 -H 2160 -F nis -- supertuxkart`

Games with low resolutions typically use linear filtering on fullscreen by default and sometimes get stretched. This is
specially noticeable in classic JRPG. To have a pixelated look and keep aspect ratio:

`$ gamescope -F nearest -S fit -- tecnoballz`

Filters can be changed while the game is running:

- ```{=mediawiki}
  {{ic|Super+n}}
  ```
  toggle nearest filtering.

- ```{=mediawiki}
  {{ic|Super+u}}
  ```
  toggle FSR upscaling.

- ```{=mediawiki}
  {{ic|Super+y}}
  ```
  toggle NIS upscaling.

- ```{=mediawiki}
  {{ic|Super+o}}
  ```
  increase FSR sharpness by 1.

- ```{=mediawiki}
  {{ic|Super+i}}
  ```
  decrease FSR sharpness by 1.

### HDR support {#hdr_support}

Gamescope is a requirement for HDR10 support when playing games, to make use of this feature you must launch your
Gamescope session using the `{{ic|--hdr-enabled}}`{=mediawiki} flag.

```{=mediawiki}
{{Note|HDR support on Linux is still in its infancy and has many caveats. See [[HDR monitor support]] for details.}}
```
### Wayland support {#wayland_support}

Gamescope does not support [Wayland](Wayland "Wayland"){.wikilink} clients by default. To enable support for Wayland
clients, add the `{{ic|--expose-wayland}}`{=mediawiki} flag to Gamescope\'s parameters.

### SDR Gamut Wideness {#sdr_gamut_wideness}

Since [SteamOS 3.5.5](https://store.steampowered.com/news/app/1675200/view/5484882897552407488), Valve has changed the
default color rendering for the Steam Deck LCD. The effect is achieved through Gamescope by changing the \"wideness\" of
the gamut for SDR content, which can result in a warmer and more vibrant color appearance depending on the adjustment.

In a Steam game\'s launch options, simply add `{{ic|--sdr-gamut-wideness}}`{=mediawiki} followed by a value that\'s
equal or between 0-1:

`gamescope --sdr-gamut-wideness 1 -- %command%`

### Mangoapp

Using traditional [MangoHud](MangoHud "MangoHud"){.wikilink} with gamescope [is not
supported](https://github.com/flightlessmango/MangoHud?tab=readme-ov-file#gamescope). Instead the gamescope argument
`{{ic|--mangoapp}}`{=mediawiki} should be used. This allows MangoHud to run on top of gamescope instead of the
underlying application. Certain MangoHud configurations, such as displaying FSR or HDR status, require the use of
mangoapp with gamescope in order to work.

### Variable Refresh {#variable_refresh}

If your monitor supports it, enable variable refresh rate by passing the `{{ic|--adaptive-sync}}`{=mediawiki} flag.

## Tips and tricks {#tips_and_tricks}

### Recording the gamescope output {#recording_the_gamescope_output}

Gamescope exposes a video node in [PipeWire](PipeWire "PipeWire"){.wikilink} for recording. You can record this with
[GStreamer](GStreamer "GStreamer"){.wikilink}.

`$ gst-launch-1.0 --eos-on-shutdown pipewiresrc do-timestamp=true target-object=gamescope ! vaapih264enc ! h264parse ! mux. pulsesrc do-timestamp=true device="Recording_$(pactl get-default-sink).monitor" ! opusenc ! mux. matroskamux name=mux ! filesink location=recording.mkv`

## Troubleshooting

### Cursor doesn\'t behave properly {#cursor_doesnt_behave_properly}

If the cursor is not captured by the application, for example by limiting your camera movement or by not properly
disappearing out of menu, use the `{{ic| --force-grab-cursor}}`{=mediawiki} option. Some proton/wine games require this
workaround.

### Switching to fullscreen causes low performance {#switching_to_fullscreen_causes_low_performance}

This is a known bug when using Gamescopes fullscreen hotkey `{{ic|Meta+f}}`{=mediawiki}, if you encounter this issue it
can be worked around by using the fullscreen flag `{{ic|-f}}`{=mediawiki} when launching the game.

### Setting Gamescopes priority {#setting_gamescopes_priority}

Another known cause of low performance and/or stuttering is not having Gamescope\'s priority set correctly. You can tell
this is the case if you see an error like this in the terminal while Gamescope is running: `{{bc|
No CAP_SYS_NICE, falling back to regular-priority compute and threads.
Performance will be affected.}}`{=mediawiki} The following command will fix this:

`# setcap 'CAP_SYS_NICE=eip' $(which gamescope)`

```{=mediawiki}
{{Warning|
:* Using this command will cause some vulkan environmental variables to be ignored: for example, if you specify the GPU for Gamescope to use by setting {{ic|MESA_VK_DEVICE_SELECT}}. See [https://github.com/ValveSoftware/gamescope/issues/107 here]. You can use {{AUR|ananicy}} or similar to get around this limitation.
:* Using this command is known to stop the Steam In-Game Overlay from working, which can be especially troublesome with games which require the use of it in order to access their multiplayer functionality. }}
```
### Window does not appear in Flatpak on NVIDIA {#window_does_not_appear_in_flatpak_on_nvidia}

This is because Flatpak Gamescope fails to access the NVIDIA DRM\'s GBM backend. It can be solved by simply setting an
environment variable with the following command:

`$ flatpak override --env=GBM_BACKENDS_PATH=/usr/lib/x86_64-linux-gnu/GL/nvidia-`*`XXX`*`-`*`YY`*`-`*`ZZ`*`/extra/gbm `*`packageid`*

where `{{ic|''packageid''}}`{=mediawiki} is the Flatpak package identifier of Gamescope **or** the app you want to use
Gamescope with, such as [Bottles](Bottles "Bottles"){.wikilink}. Replace
`{{ic|nvidia-''XXX''-''YY''-''ZZ''}}`{=mediawiki} with the currently installed NVIDIA driver version; inside Flatpak, it
can be queried with this command:

`$ flatpak run --command=ls `*`packageid`*` /usr/lib/x86_64-linux-gnu/GL`

where `{{ic|''packageid''}}`{=mediawiki} is any Flatpak package identifier; do note that the directory only exists
inside Flatpak.

```{=mediawiki}
{{Note|

{{Expansion|This step can probably be automated by a [[pacman hook]].}}

The command '''must''' be reran, and modified accordingly, on every driver update.
}}
```
### Image corruption on Intel graphics {#image_corruption_on_intel_graphics}

If gamescope outputs corrupted image colors on Intel graphics disabling lossless color compression can be a work-around
at the cost of increased memory bandwidth utilization. [1](https://github.com/ValveSoftware/gamescope/issues/356) To
disable it pass `{{ic|1=INTEL_DEBUG=noccs}}`{=mediawiki} [environment
variable](environment_variable "environment variable"){.wikilink}.

### VRR stutters when HDR is enabled {#vrr_stutters_when_hdr_is_enabled}

If VRR and HDR work independently, but the framerate is unstable when they\'re both enabled, then you may be hitting
issues with long HDR compositing times. See <https://github.com/ValveSoftware/gamescope/issues/1006>. This only applies
to using Gamescope in embedded mode, and not when using gamescope within an existing wayland or X session.

When using AMD graphics this can be fixed by using experimental AMD color management, which uses hardware planes to
composite the final image. This requires one of two setups:

#### Steam Deck kernel {#steam_deck_kernel}

- The Steam Deck Linux kernel `{{AUR|linux-neptune-65}}`{=mediawiki} or a kernel built with the [Steam Deck color
  management patch](https://gitlab.com/evlaV/linux-integration/-/commit/90e3a855c922d0b8c4b18c886c5cf73223d69475.patch)

- ```{=mediawiki}
  {{Pkg|gamescope}}
  ```

#### Linux kernel with experimental AMD color management enabled {#linux_kernel_with_experimental_amd_color_management_enabled}

Linux 6.8 or newer compiled with `{{ic|KCFLAGS}}`{=mediawiki} including `{{ic|-DAMD_PRIVATE_COLOR}}`{=mediawiki}, eg
`{{AUR|linux-amd-color}}`{=mediawiki}

### High polling rate mice cause stuttering {#high_polling_rate_mice_cause_stuttering}

Moving a high polling rate mouse (observed with 4000Hz) in the game window might cause stuttering or temporary freezes
[2](https://github.com/ValveSoftware/gamescope/issues/1279). Setting a lower polling rate like 1000Hz should work around
this issue.

### Swapchain Errors {#swapchain_errors}

A common cause of swapchain errors is improperly attempting to use mangohud instead of mangoapp. See the Mangoapp
section of [#Usage](#Usage "#Usage"){.wikilink}, above.

### Launching gamescope from Steam, stuttering after \~24 minutes (Gamescope Lag Bomb) {#launching_gamescope_from_steam_stuttering_after_24_minutes_gamescope_lag_bomb}

If after launching gamescope from Steam you experience heavy stuttering setting in around \~24 minutes, then you can fix
this by either enabling the Steam Overlay `{{ic|-e}}`{=mediawiki} option on your Steam Client, or by overwriting the
environment variable `{{ic|LD_PRELOAD}}`{=mediawiki} with an empty value. For example:

`$ LD_PRELOAD="" gamescope -- %command%`

This, however, will disable the Steam Overlay and any additional Steam features; game recording being one of them.
Depending on the game, you may be able to restore Steam functionality by bypassing `{{ic|LD_PRELOAD}}`{=mediawiki}
running on gamescope, and passing it instead as an env directly to the desired command. For example:

`$ gamescope -- env LD_PRELOAD="$LD_PRELOAD" %command%`

The above seems to work well for games that do not contain a secondary launcher (Rockstar, EA, etc.)

See [ValveSoftware/gamescope#163](https://github.com/ValveSoftware/gamescope/issues/163).

### Games crash on launch if Gamescope is launched non-fullscreen. {#games_crash_on_launch_if_gamescope_is_launched_non_fullscreen.}

Several reports have indicated that some games on certain systems will crash if Gamescope is not launched in fullscreen,
and the current workaround is to add `{{ic|--fullscreen}}`{=mediawiki} to the launch options. This will, however, lead
to issues where the camera can pan in games rotationally indefinitely due to a failure to capture the mouse cursor
correctly (see [4.1](#Troubleshooting "4.1"){.wikilink}). Thus, `{{ic|--force-grab-cursor}}`{=mediawiki} is recommended
to be used in conjunction with this fix.

### Rapidly cycling framebuffer on OpenGL/32-bit games with NVidia. {#rapidly_cycling_framebuffer_on_opengl32_bit_games_with_nvidia.}

See [ValveSoftware/gamescope#495](https://github.com/ValveSoftware/gamescope/issues/495) for a report regarding the
details. Causes are unconfirmed, and no fixes have been listed yet.

## See also {#see_also}

- [Gamescope Github Page](https://github.com/ValveSoftware/gamescope)
- [Gamescope at Steamtinkerlaunch Github Wiki](https://github.com/sonic2kk/steamtinkerlaunch/wiki/GameScope)

[Category:Wayland compositors](Category:Wayland_compositors "Category:Wayland compositors"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

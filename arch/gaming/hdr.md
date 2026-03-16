[fr:HDR monitor support](fr:HDR_monitor_support "wikilink") [ja:HDR
モニターのサポート](ja:HDR_モニターのサポート "wikilink") [zh-hans:HDR 显示器支持](zh-hans:HDR_显示器支持 "wikilink")
`{{Related articles start}}`{=mediawiki} `{{Related|Steam}}`{=mediawiki} `{{Related|Gaming}}`{=mediawiki}
`{{Related|Gamescope}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[High-dynamic range](Wikipedia:High-dynamic-range_television "wikilink") (HDR) is supported by
[Wayland](Wayland "wikilink")\'s [Color management and HDR
protocol](https://gitlab.freedesktop.org/wayland/wayland-protocols/-/tree/main/staging/color-management), and some
compositors have implemented it. [X.org](X.org "wikilink") has [no
plans](https://gitlab.freedesktop.org/xorg/xserver/-/issues/1037#note_521100) to support HDR.

## Requirements

-   HDR-capable display
    -   While many displays advertise HDR support, many may provide a suboptimal experience if they lack any form of
        local dimming. More information is available at [RTINGS: Local Dimming on
        TVs](https://www.rtings.com/tv/tests/picture-quality/local-dimming).
-   HDR-capable GPU and driver
    -   [AMDGPU](AMDGPU "wikilink") and [NVIDIA](NVIDIA "wikilink") are both supported
    -   [Intel graphics](Intel_graphics "wikilink") has experimental HDR support with [Gen 9 and
        newer](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1a911350dd6c777b4a08ca60fe6e2249fd3c254a)
        -   The implementation is [reportedly
            incomplete](https://reddit.com/r/linux/comments/1atnp5k/hdr_and_intel/kqzj69z/).
-   [Supported compositor](#Compositor_configuration "wikilink")
-   [Supported application](#Application_configuration "wikilink")
-   [Vulkan WSI with HDR support](#Vulkan_HDR_WSI "wikilink")

### Vulkan HDR WSI {#vulkan_hdr_wsi}

```{=mediawiki}
{{ic|VK_EXT_swapchain_colorspace}}
```
and `{{ic|VK_EXT_hdr_metadata}}`{=mediawiki} extensions are required for HDR support when using the Vulkan API. Users
with certain GPUs or drivers may need to use `{{aur|vk-hdr-layer-kwin6-git}}`{=mediawiki} to support these extensions.

-   ```{=mediawiki}
    {{pkg|mesa}}
    ```
    25.1+ supports these extensions and should not require package installation

-   [NVIDIA](NVIDIA "wikilink") users must use `{{aur|vk-hdr-layer-kwin6-git}}`{=mediawiki} for Vulkan HDR support
    -   NVIDIA drivers since Vulkan beta 580.94.11 support `{{ic|VK_EXT_hdr_metadata}}`{=mediawiki} on Wayland
        [1](https://www.phoronix.com/news/NVIDIA-580.94.11-Linux-Driver)
        -   Stable NVIDIA drivers do **not** yet include this extension, including the R590 driver series
    -   NVIDIA drivers still lack support for `{{ic|VK_EXT_swapchain_colorspace}}`{=mediawiki} on Linux
        [2](https://developer.nvidia.com/vulkan-driver)

```{=mediawiki}
{{ic|ENABLE_HDR_WSI{{=}}
```
1}} can be used to enable the Vulkan HDR WSI layer. Enabling this globally is **not** recommended. Set this for
individual games and applications that will be used with HDR.

## Compositor configuration {#compositor_configuration}

### KDE Plasma {#kde_plasma}

See [KDE#HDR](KDE#HDR "wikilink").

### Hyprland

#### Monitor v1 {#monitor_v1}

Append `{{ic|, bitdepth, 10, cm, hdr}}`{=mediawiki} to the monitor\'s config line in your Hyprland config file.

```{=mediawiki}
{{Note| Monitorv2s are declared as such, whereas monitorv1s are declared simply as "monitor"}}
```
#### Monitor v2 {#monitor_v2}

Add a new line to the monitor\'s config and add

```{=mediawiki}
{{bc|
monitorv2 {
   # ...
   bitdepth {{=}}
```
10

`  cm {{=}} hdr`

} }}

Additional settings can be found on the [Hyprland wiki](https://wiki.hypr.land/Configuring/Monitors/#monitor-v2).

More information can be found in the [Hyprland experimental
docs](https://wiki.hyprland.org/Configuring/Variables/#experimental) and the [Hyprland monitor
docs](https://wiki.hypr.land/Configuring/Monitors/#color-management-presets).

### GNOME

Ensure `{{pkg|mutter}}`{=mediawiki} is \>= 48.0.

Enable HDR in GNOME\'s display settings. The HDR toggle is per-monitor and is located next to the resolution and refresh
rate setting.

```{=mediawiki}
{{Note|Gamescope HDR appears "washed out" with GNOME as GNOME lacks scRGB or support for the {{ic|frog-color-management-v1}} protocol [https://gitlab.gnome.org/GNOME/mutter/-/issues/4083] [https://github.com/ValveSoftware/gamescope/issues/1825]. See [[#With Gamescope]]}}
```
### Gamescope with Steam session {#gamescope_with_steam_session}

Valve\'s Steam compositor [gamescope](gamescope "wikilink") offers experimental HDR support. Following these steps will
allow you to try out Valve\'s Steam client running through the HDR capable gamescope.

```{=mediawiki}
{{Tip|An [[AMDGPU]] is recommended for use with gamescope - [[NVIDIA]] is known to have critical issues.}}
```
-   Install `{{Pkg|gamescope}}`{=mediawiki} and `{{AUR|gamescope-session-steam-git}}`{=mediawiki}
-   You may create the optional config file `{{ic|~/.config/environment.d/gamescope-session.conf}}`{=mediawiki} with the
    following content: `{{bc|<nowiki>
    if [ "$XDG_SESSION_DESKTOP" = "gamescope" ] ; then
        SCREEN_WIDTH=1920
        SCREEN_HEIGHT=1080
        CONNECTOR=*,eDP-1
        CLIENTCMD="steam -gamepadui -pipewire-dmabuf"
        GAMESCOPECMD="/usr/bin/gamescope --hdr-enabled --hdr-itm-enable \
        --hide-cursor-delay 3000 --fade-out-duration 200 --xwayland-count 2 \
        -W $SCREEN_WIDTH -H $SCREEN_HEIGHT -O $CONNECTOR"
    fi
    </nowiki>}}`{=mediawiki}
    -   Update the resolution values above to the correct ones. You can list your displays by running
        `{{ic|xrandr --query}}`{=mediawiki}.
    -   You may need to set the Display `{{ic|CONNECTOR}}`{=mediawiki} if it does not pick the right one by default.

You can now start `{{ic|gamescope}}`{=mediawiki} from your login manager or a terminal using one of the following steps:

#### Via a login manager {#via_a_login_manager}

Log out and select the *Steam Big Picture* in your login manager and log in.

#### Via the command line {#via_the_command_line}

1.  Go to a new TTY by pressing `{{ic|Ctrl+Alt+F2}}`{=mediawiki}
2.  Log in and run `{{ic|gamescope-session-plus steam}}`{=mediawiki} to start the [standalone steam
    session](https://github.com/ChimeraOS/gamescope-session) in HDR.
    -   If networking does not work you can fix it by installing and enabling
        [NetworkManager](NetworkManager "wikilink").

#### Configure Steam {#configure_steam}

1.  In the general settings, under Display, you should now see HDR settings. Enable HDR and Experimental HDR Support.
2.  Select an HDR compatible game and click on the cog next to it.
3.  Set Compatibility to Force Proton 8.0 or Proton Experimental.
4.  Set Game Resolution to match your monitor otherwise it will launch at Steam Deck native resolution.
5.  Click Play to start the game. Check the in-game settings to see if the HDR setting is available and enable it.
6.  To switch back to your normal session, select *Power* and *Switch to desktop mode* from the Steam menu.

### COSMIC

The [COSMIC](COSMIC "wikilink") developers have [promised HDR
support](https://blog.system76.com/post/may-flowers-spring-cosmic-showers) in the initial stable release.

### sway

Add `{{ic|render_bit_depth 10}}`{=mediawiki} and `{{ic|hdr off}}`{=mediawiki} to the outputs\'s config in your sway
config file, and start sway with `{{ic|WLR_RENDERER{{=}}`{=mediawiki}vulkan}} environment variable set.

Setup a binding to toggle hdr or toggle manually i.e.: `{{ic|swaymsg output DP-1 hdr toggle}}`{=mediawiki}.

```{=mediawiki}
{{Note| Needs commit [https://github.com/swaywm/sway/commit/94c819cc1f9328223509883e4b62939bdf85b760 94c819cc1f9], so {{aur|sway-git}} is needed (or sway 1.12 released) }}
```
## Application configuration {#application_configuration}

### Wine/Proton

HDR through [Wine](Wine "wikilink") or [Steam Proton](Steam#Proton_Steam-Play "wikilink") requires
[DXVK](DXVK "wikilink") (2.1+) or [VKD3D-Proton](Wine#VKD3D-Proton "wikilink") (2.8+), depending on DirectX version used
by the game.

```{=mediawiki}
{{Tip|Use either Proton 8.0+ or Proton GE 44+. All come packaged with sufficient DXVK and VKD3D versions.}}
```
#### Without Gamescope {#without_gamescope}

To use HDR without gamescope run a build of Wine which includes the Wayland driver.

```{=mediawiki}
{{Note|Wines native [[Wayland]] driver is experimental and may perform better or worse than Xwayland depending on the game.}}
```
-   [proton-ge-custom](https://github.com/GloriousEggroll/proton-ge-custom): install
    `{{aur|proton-ge-custom-bin}}`{=mediawiki} and set `{{ic|PROTON_ENABLE_WAYLAND{{=}}`{=mediawiki}1}} and
    `{{ic|PROTON_ENABLE_HDR{{=}}`{=mediawiki}1}}
    [3](https://github.com/GloriousEggroll/proton-ge-custom/releases/tag/GE-Proton10-1).

```{=mediawiki}
{{Note|{{ic|PROTON_ENABLE_HDR}} sets {{ic|DXVK_HDR{{=}}1}}
```
[4](https://github.com/GloriousEggroll/proton-ge-custom/blob/master/proton#L1718).}}

-   [wine-tkg](https://github.com/Frogging-Family/wine-tkg-git): install wine-tkg, set
    `{{ic|DXVK_HDR{{=}}`{=mediawiki}1}}, and unset `{{ic|DISPLAY}}`{=mediawiki}.
-   [proton-cachyos](https://github.com/cachyos/proton-cachyos) or
    [wine-cachyos](https://github.com/CachyOS/wine-cachyos): install your choice of
    `{{aur|proton-cachyos}}`{=mediawiki}, `{{aur|wine-cachyos-opt}}`{=mediawiki}, or `{{aur|wine-cachyos}}`{=mediawiki}
    and set `{{ic|PROTON_ENABLE_WAYLAND{{=}}`{=mediawiki}1}} and `{{ic|DXVK_HDR{{=}}`{=mediawiki}1}}
    [5](https://www.reddit.com/r/linux_gaming/comments/1km81f4/proton_cachy_10_released_native_wayland_gaming/).

```{=mediawiki}
{{Tip|You can also easily install the aforementioned wine builds to Lutris, Bottles, or Steam using {{aur|protonup-qt}}.}}
```
#### With Gamescope {#with_gamescope}

Gamescope with proper HDR requires scRGB and `{{ic|xx-color-management-v4}}`{=mediawiki} protocol support or
[frog-color-management-v1](https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/14) protocol
support in your compositor.

Because of this gamescope will not work with the `{{AUR|vk-hdr-layer-kwin6-git}}`{=mediawiki} layer. Ensure
`{{ic|ENABLE_HDR_WSI}}`{=mediawiki} is not `{{ic|1}}`{=mediawiki}.

You have many options for using gamescope depending on your desired configuration:

-   Launch Steam with HDR enabled. All games will then have HDR enabled, but Steam and all games will be launched inside
    a gamescope window.

`$ gamescope --hdr-enabled --steam -- env DXVK_HDR=1 steam`

-   Enable HDR for a single game in Steam. Set the following *Launch options*:

`DXVK_HDR=1 gamescope -f --hdr-enabled -- %command%`

-   To launch a non-Steam game within gamescope:

`$ DXVK_HDR=1 gamescope -f --hdr-enabled -- `*`executable`*

```{=mediawiki}
{{Note|By default {{ic|gamescope}} will launch with 1280x720 resolution. To override the default resolution, use the {{ic|-W}} and {{ic|-H}} parameters to a desired resolution.}}
```
### RetroArch

HDR in RetroArch is supported from version [1.10.0](https://github.com/libretro/RetroArch/blob/master/CHANGES.md#1100)
with Vulkan video driver. First, select video driver Vulkan. Then, enable HDR in RetroArch video settings via Settings
tab \> Video \> HDR \> Enable HDR.

`$ retroarch`

### Native SDL {#native_sdl}

To run native games that use SDL with HDR set `{{ic|SDL_VIDEODRIVER{{=}}`{=mediawiki}wayland}}.

For example for Quake II RTX:

`$ SDL_VIDEODRIVER=wayland quake2rtx`

### mpv

For best image quality mpv maintainers recommend using the `{{ic|gpu-next}}`{=mediawiki}
[6](https://github.com/mpv-player/mpv/discussions/16105#discussioncomment-12629196) video output driver, which is the
default. `{{ic|gpu-next}}`{=mediawiki} supports HDR with `{{ic|--gpu-context{{=}}`{=mediawiki}waylandvk}}, which is
selected by default on Wayland.

```{=mediawiki}
{{Note|This requires a Vulkan WSI with HDR support, see [[#Vulkan HDR WSI]]}}
```
`$ mpv "path/to/video"`

Other ways of enabling [Wayland HDR
support](https://github.com/mpv-player/mpv/discussions/16105#discussioncomment-12619072) include using the
`{{ic|dmabuf-wayland}}`{=mediawiki} video output and the `{{ic|drm}}`{=mediawiki} GPU context.

`$ mpv --vo=dmabuf-wayland "path/to/video"`

-   From the tty terminal, one could do (`{{ic|--gpu-context{{=}}`{=mediawiki}drm}} is selected by default)

`$ mpv "path/to/video"`

### Firefox

```{=mediawiki}
{{pkg|firefox}}
```
introduces working experimental HDR in 138.0 under the hidden preference `{{ic|gfx.wayland.hdr}}`{=mediawiki}. You can
enable it at `{{ic|about:config}}`{=mediawiki}.

Stable HDR is still in progress [7](https://bugzilla.mozilla.org/show_bug.cgi?id=hdr)
[8](https://bugzilla.mozilla.org/show_bug.cgi?id=1642854).

### Chromium

```{=mediawiki}
{{pkg|chromium}}
```
has work-in-progress HDR support [9](https://chromium-review.googlesource.com/c/chromium/src/+/6771393). Support has
been merged as of version 141.0.7370.0.

## Troubleshooting

### HDR video samples {#hdr_video_samples}

[Kodi](Kodi "wikilink") wiki [maintains the list of fair use HDR video
samples](https://kodi.wiki/view/Samples#4K_(UltraHD)_&_HDR_Formats). These can be used to test the HDR output using
video players that support HDR such as [#mpv](#mpv "wikilink").

### Broken screen sharing with HDR10 {#broken_screen_sharing_with_hdr10}

Pipewire attempts to stream what it sees as BGRA, which WebRTC cannot interpret, due to its current lack of capacity to
interpret it. As such, a \"ParamId:EnumFormat: 0:0 Invalid argument\" exception is thrown and the WebRTC socket crashes
for that application [10](https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/52).

## See also {#see_also}

-   [X.Org Developers\' Conference 2022 \| Harry Wentland: \"Is HDR
    Harder?\"](https://www.youtube.com/watch?t=21171&v=yTO8QRIfOjA)
-   [wlroots/wlroots \| HDR10 support](https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/3941)
-   [Xaver Hugl\'s blog \| An update on HDR and color management in
    KWin](https://zamundaaa.github.io/wayland/2023/12/18/update-on-hdr-and-colormanagement-in-plasma.html)

[Category:Display control](Category:Display_control "wikilink") [Category:Gaming](Category:Gaming "wikilink")
[Category:Graphics](Category:Graphics "wikilink") [Category:Graphical user
interfaces](Category:Graphical_user_interfaces "wikilink")

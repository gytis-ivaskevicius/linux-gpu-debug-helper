[de:Chromium](de:Chromium "wikilink") [ja:Chromium](ja:Chromium "wikilink")
[zh-hans:Chromium](zh-hans:Chromium "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|Browser extensions}}`{=mediawiki} `{{Related|Firefox}}`{=mediawiki} `{{Related|Vivaldi}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

[Chromium](Wikipedia:Chromium_(web_browser) "wikilink") is an open-source graphical web browser based on the
[Blink](Wikipedia:Blink_(web_engine) "wikilink") rendering engine. It is the basis for the proprietary Google Chrome
browser.

See [this page](https://chromium.googlesource.com/chromium/src/+/master/docs/chromium_browser_vs_google_chrome.md) for
an explanation of the differences between Chromium and Google Chrome. Additionally:

-   Sync is unavailable in Chromium 89+ (2021-03-02)
    [1](https://archlinux.org/news/chromium-losing-sync-support-in-early-march/)

```{=mediawiki}
{{Note|Sync can be temporarily restored by [https://gist.github.com/foutrelis/14e339596b89813aa9c37fd1b4e5d9d5 using Chrome's OAuth2 credentials] or [https://www.chromium.org/developers/how-tos/api-keys getting your own], but pay attention to the disclaimers and do not consider this to be a long-term solution.
Consider switching to [https://www.xbrowsersync.org xbrowsersync] for bookmarks syncing as long term solution.
}}
```
See [List of applications/Internet#Blink-based](List_of_applications/Internet#Blink-based "wikilink") for other browsers
based on Chromium.

## Installation

[Install](Install "wikilink") the `{{Pkg|chromium}}`{=mediawiki} package, which tracks the
`{{AUR|google-chrome}}`{=mediawiki} releases.

```{=mediawiki}
{{Note|From the [https://www.chromium.org/Home/chromium-privacy Chromium privacy page]: "Features that communicate with Google made available through the compilation of code in Chromium are subject to the [https://www.google.com/policies/privacy/ Google Privacy Policy]." For those who want to avoid all integration with Google services, there are some [[List of applications/Internet#Privacy-focused chromium spin-offs|privacy-focused spin-offs]].}}
```
## Configuration

```{=mediawiki}
{{Merge|#Tips and tricks|Most of the content in this section should be split between [[#Tips and tricks]] and maybe [[#Troubleshooting]] for the applicable sections.}}
```
### Default applications {#default_applications}

To set Chromium as the default browser and to change which applications Chromium launches when opening downloaded files,
see [default applications](default_applications "wikilink").

### Certificates

Chromium uses [Network Security Services](Network_Security_Services "wikilink") for certificate management. Certificates
can be managed in `{{ic|chrome://certificate-manager}}`{=mediawiki}.

The \"Local certificates\" tab manages server certificates. Certificates added in the \"Custom\" section are
per-profile, and stored in the `{{ic|ServerCertificate}}`{=mediawiki} SQLite database in the profile directory.
Certificates in the \"Linux\" section are read from the NSS Shared DB at `{{ic|~/.pki/nssdb}}`{=mediawiki}, and cannot
be modified in this UI. To add to NSS Shared DB, use another tool such as *certutil*. See [#SSL
certificates](#SSL_certificates "wikilink") for usage examples.

The \"Your certificates\" tab manages client certificates. Certificates added here are stored in the NSS Shared DB.

### Making flags persistent {#making_flags_persistent}

```{=mediawiki}
{{Note|The {{ic|chromium-flags.conf}} file and the accompanying custom launcher script are specific to the various Chromium packages. For Google Chrome, use {{ic|chrome-flags.conf}} (or {{ic|chrome-''channel''-flags.conf}} for the Dev and Beta channels) instead.}}
```
You can put your flags in a `{{ic|chromium-flags.conf}}`{=mediawiki} file under `{{ic|$HOME/.config/}}`{=mediawiki} (or
under `{{ic|$XDG_CONFIG_HOME}}`{=mediawiki} if you have configured that environment variable) or
`{{ic|/etc/}}`{=mediawiki} for global.

No special syntax is used; flags are defined as if they were written in a terminal.

-   The arguments are split on whitespace and shell quoting rules apply, but no further parsing is performed.
-   In case of improper quoting anywhere in the file, a fatal error is raised.
-   Flags can be placed in separate lines for readability, but this is not required.
-   Lines starting with a hash symbol (#) are skipped. (This is only supported by the Chromium launcher script and will
    not work when using Google Chrome.)

Below is an example `{{ic|chromium-flags.conf}}`{=mediawiki} file that defines the flags
`{{ic|--start-maximized --incognito}}`{=mediawiki}:

```{=mediawiki}
{{hc|~/.config/chromium-flags.conf|
# This line will be ignored.
--start-maximized
--incognito
}}
```
### Force GPU acceleration {#force_gpu_acceleration}

Since at least Chromium 110, GPU acceleration is enabled by default for most systems. You may have to
[append](append "wikilink") the following flags to [persistent
configuration](/Tips_and_tricks#Making_flags_persistent "wikilink") if your system configuration is matched by the
[block list](https://chromium.googlesource.com/chromium/src/gpu/+/master/config/software_rendering_list.json):

```{=mediawiki}
{{Warning|Disabling the rendering blocklist may cause unstable behavior, including crashes of the host. See the bug reports in {{ic|chrome://gpu}} for details.}}
```
```{=mediawiki}
{{hc|~/.config/chromium-flags.conf|
--ignore-gpu-blocklist
--enable-zero-copy
}}
```
### Hardware video acceleration {#hardware_video_acceleration}

```{=mediawiki}
{{Note|1=<nowiki/>
* There is no official support from Chromium or Arch Linux for this feature [https://chromium.googlesource.com/chromium/src/+/master/docs/gpu/vaapi.md#vaapi-on-linux]. However, {{Pkg|chromium}} from official repositories is compiled with VA-API support and you may ask for help in [https://bbs.archlinux.org/viewtopic.php?id=244031 the dedicated forum thread].
* Since Chromium version 122, an extra [[VA-API]] package is no longer needed. VA-API works when using the native Wayland backend with the {{Pkg|chromium}} package from official repositories.
* Chromium 116 dropped support for Intel iGPUs using {{Pkg|libva-intel-driver}}. To have working h264 acceleration, {{AUR|libva-intel-driver-irql}} is required.
* On AMD GPU devices, VA-API [https://crbug.com/1445074 does not work out of the box] and requires mesa >= 24.1 as well as [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/26165 enabling Vulkan]. This may cause issues with WebGL under X11/XWayland. Vulkan with [[#Native Wayland support]] works since version 125.0.6422.141-1.
* When trying to find the correct combination of flags in {{ic|chromium-flags.conf}}, note that this file should contain at most one line starting with {{ic|--enable-features}} and {{ic|--disable-features}}. Multiple features must be concatenated with commas.
}}
```
If you have confirmed working VA-API support by checking the output of `{{ic|1=vainfo}}`{=mediawiki} (see [Hardware
video acceleration#Verifying VA-API](Hardware_video_acceleration#Verifying_VA-API "wikilink")), you might first try the
following flag alone:

```{=mediawiki}
{{hc|~/.config/chromium-flags.conf|
--enable-features{{=}}
```
AcceleratedVideoDecodeLinuxGL }}

```{=mediawiki}
{{Note|
* In addition, the following flag can improve performance when using EGL/Wayland:
{{ic|--enable-features{{=}}AcceleratedVideoDecodeLinuxZeroCopyGL}}
```
.

-   Chromium versions prior to 131 should use `{{ic|--enable-features{{=}}`{=mediawiki}VaapiVideoDecodeLinuxGL}}
    instead.

}}

Otherwise, continue reading.

To enable accelerated **en**coding in Chromium:

-   Append the `{{ic|AcceleratedVideoEncoder}}`{=mediawiki} feature, e.g.
    `{{ic|1=--enable-features{{=}}`{=mediawiki}AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder}}. See
    [2](https://github.com/chromium/chromium/blob/main/docs/gpu/vaapi.md#vaapi-on-linux) and
    [3](https://issues.chromium.org/issues/40225939#comment54) for details.

To enable VA-API support:

-   Install the correct VA-API driver for your video card and verify VA-API has been enabled and working correctly, see
    [Hardware video acceleration](Hardware_video_acceleration "wikilink"). For proprietary NVIDIA support, you must
    install `{{Pkg|libva-nvidia-driver}}`{=mediawiki} and append the `{{ic|VaapiOnNvidiaGPUs}}`{=mediawiki} feature in
    addition to the features above.
-   Set the option `{{ic|1=--enable-features=VaapiVideoDecoder}}`{=mediawiki}. This is enough when using ANGLE GL
    renderer and `{{Pkg|libva-intel-driver}}`{=mediawiki}.
-   When using ANGLE, Chromium forces the older i965 driver and fails when `{{Pkg|intel-media-driver}}`{=mediawiki} is
    used. As a workaround, [configure VA-API manually](Hardware_video_acceleration#Configuring_VA-API "wikilink"). See
    [4](https://github.com/intel/media-driver/issues/818) for details.
-   To use the system GL renderer on Xorg or Wayland, use `{{ic|1=--use-gl=egl}}`{=mediawiki}. Setting this option might
    no longer be needed when using Chrome 112 and may break GPU acceleration when using AMD GPUs.
-   If VA-API still does not work, try the `{{ic|1=--enable-features=VaapiIgnoreDriverChecks}}`{=mediawiki}
    or`{{ic|1=--disable-features=UseChromeOSDirectVideoDecoder}}`{=mediawiki} flag
-   If VA-API still does not work on X11 and old GPUs, set the `{{ic|1=LIBVA_DRI3_DISABLE=1}}`{=mediawiki} [environment
    variable](environment_variable "wikilink") [5](https://www.phoronix.com/news/VA-API-libva-2.18).

#### Vulkan

When using Vulkan, the following flags are required and might also be sufficient on Chromium 126 and Mesa 24.1:
`{{hc|~/.config/chromium-flags.conf|
--enable-features{{=}}`{=mediawiki}VaapiVideoDecoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE
}} without any of the additional flags mentioned above.

#### Tips and tricks {#tips_and_tricks}

```{=mediawiki}
{{Out of date|
* Chromium uses VaapiVideoDecoder for AV1 on Wayland + RADV
* Chromium uses VaapiVideoDecoder for videos of any size on Wayland + RADV
}}
```
To check if it is working play a video which is using a codec supported by your VA-API driver (*vainfo* tells you which
codecs are supported, but Chromium will only support VP9 and h264):

-   Open the DevTools by pressing `{{ic|Ctrl+Shift+I}}`{=mediawiki} or on the *Inspect* button of the context
    (right-click) menu
-   Add the Media inspection tab: *Hamburger menu \> More tools \> Media*
-   In the newly opened Media tab, look at the hardware decoder state of the video decoder

Test on a large enough video. Starting with version 86, Chromium on desktop [will only accelerate videos larger than
720p](https://bugs.chromium.org/p/chromium/issues/detail?id=684792).

To reduce CPU usage while watching YouTube where VP8/VP9 hardware decoding is not available use the
[h264ify](https://chrome.google.com/webstore/detail/h264ify/aleakchihdccplidncghkekgioiakgal),
[enhanced-h264ify](https://chrome.google.com/webstore/detail/enhanced-h264ify/omkfmpieigblcllmkgbflkikinpkodlk) or [Not
yet,
AV1](https://chrome.google.com/webstore/detail/not-yet-av1/dcmllfkiihingappljlkffafnlhdpbai)[6](https://bbs.archlinux.org/viewtopic.php?pid=2039884#p2039884)
extension.

On some systems (especially on Xwayland) you might need to [#Force GPU
acceleration](#Force_GPU_acceleration "wikilink"). Only `{{ic|--ignore-gpu-blocklist}}`{=mediawiki} is enough for our
purposes.

```{=mediawiki}
{{Expansion|Provide a link to some bug report.}}
```
You might need to disable the Skia renderer, as it is currently not compatible with video decode acceleration:
`{{ic|1=--disable-features=UseSkiaRenderer}}`{=mediawiki}

### KDE integration {#kde_integration}

For integration into [Plasma](Plasma "wikilink"), you can:

-   install `{{Pkg|plasma-browser-integration}}`{=mediawiki} on your system, and [Plasma
    Integration](https://chromewebstore.google.com/detail/plasma-integration/cimiefiiaegbelhefglklhhakcgmhkai) in your
    browser (see [KDE Plasma Browser Integration](https://community.kde.org/Plasma/Browser_Integration) for more
    details)
-   install `{{Pkg|kdialog}}`{=mediawiki} to allow Chromium to use native KDE open/save dialogs
-   [configure Chromium to use KWallet](KDE_Wallet#KDE_Wallet_for_Chrome_and_Chromium "wikilink")

### PDF viewer plugin {#pdf_viewer_plugin}

Chromium and Google Chrome are bundled with the *Chromium PDF Viewer* plugin. If you do not want to use this plugin,
check *Download PDFs* in `{{ic|chrome://settings/content/pdfDocuments}}`{=mediawiki}.

### Running on Xwayland {#running_on_xwayland}

If you are using NVIDIA\'s proprietary driver, running Chromium on Xwayland may cause the GPU process to occasionally
crash. To prevent the GPU process from crashing, add the following flags:

`--use-angle=vulkan --use-cmd-decoder=passthrough`

```{=mediawiki}
{{Note|This does not prevent all Xwayland-related crashes.}}
```
### Native Wayland support {#native_wayland_support}

Chromium 140 supports [Wayland](Wayland "wikilink") by default. For old versions, you can use

`--ozone-platform-hint=auto`

or

`--ozone-platform=wayland`

See [#Making flags persistent](#Making_flags_persistent "wikilink") for a permanent configuration. The flag is also
available via [browser flags menu](#chrome://_URLs "wikilink").

This will select wayland Ozone backend when in wayland session, so you can use a single desktop entry if you switch
between X11 and Wayland often.

```{=mediawiki}
{{Note|When changing the "ozone-platform-hint" in browser flags menu, the browser will provide you a relaunch button. Do not use it, because the browser will still be relaunched in a platform it was before changing the flag. You need to close the browser, then open it.}}
```
Additionally, if you are having [trouble with input
methods](https://bugs.chromium.org/p/chromium/issues/detail?id=1422087) you may also want to force newer GTK:

`--gtk-version=4`

If a `{{ic|AltGr}}`{=mediawiki}/`{{ic|Compose}}`{=mediawiki} key stops working, adding this workaround might fix it:

`--disable-gtk-ime`

If you are using Fcitx5 and not work properly when using the above flags, try using the
`{{ic|--enable-wayland-ime}}`{=mediawiki} flag instead of `{{ic|--gtk-version{{=}}`{=mediawiki}4}}.
[7](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Chromium_.2F_Electron)

`--enable-wayland-ime --wayland-text-input-version=3`

```{=mediawiki}
{{Note|Enabling the {{ic|--enable-wayland-ime}} flag works if the {{ic|text_input_v1}} protocol is implemented by default. Known compositors that implement this protocol are: Weston, KWin, Hyprland.}}
```
#### Touchpad gestures for navigation {#touchpad_gestures_for_navigation}

To enable two finger swipe to go back and forward through your history, use the following flags:

`--ozone-platform-hint=auto --enable-features=TouchpadOverscrollHistoryNavigation`

#### Force device scale factor {#force_device_scale_factor}

```{=mediawiki}
{{Merge|HiDPI#Chromium / Google Chrome|Same topic.}}
```
To force a scale factor on native Wayland, use the following flags
[8](https://chromium.googlesource.com/chromium/src/+/756e64489c84c22998470beddb1facab5e78e1fa):

`--force-device-scale-factor=1.33 --gtk-version=4 --enable-features=WaylandPerSurfaceScale,WaylandUiScale`

## Tips and tricks {#tips_and_tricks_1}

The following tips and tricks should work for both Chromium and Chrome unless explicitly stated.

### Browsing experience {#browsing_experience}

#### <chrome://> URLs {#chrome_urls}

A number of tweaks can be accessed via Chrome URLs. See **<chrome://chrome-urls>** for a complete list.

-   **<chrome://flags>** - access experimental features such as WebGL and rendering webpages with GPU, etc.
-   **<chrome://extensions>** - view, enable and disable the currently used Chromium extensions.
-   **<chrome://gpu>** - status of different GPU options.
-   **<chrome://sandbox>** - indicate sandbox status.
-   **<chrome://version>** - display version and switches used to invoke the active
    `{{ic|/usr/bin/chromium}}`{=mediawiki}.

An automatically updated, complete listing of Chromium switches (command line parameters) is available
[here](https://peter.sh/experiments/chromium-command-line-switches/).

#### Chromium task manager {#chromium_task_manager}

Shift+ESC can be used to bring up the browser task manager wherein memory, CPU, and network usage can be viewed.

#### Chromium overrides/overwrites Preferences file {#chromium_overridesoverwrites_preferences_file}

If you enabled syncing with a Google Account, then Chromium will override any direct edits to the Preferences file found
under `{{ic|~/.config/chromium/Default/Preferences}}`{=mediawiki}. To work around this, start Chromium with the
`{{ic|--disable-sync-preferences}}`{=mediawiki} switch:

`$ chromium --disable-sync-preferences`

If Chromium is started in the background when you login in to your desktop environment, make sure the command your
desktop environment uses is:

`$ chromium --disable-sync-preferences --no-startup-window`

#### Search engines {#search_engines}

Make sites like [wiki.archlinux.org](https://wiki.archlinux.org) and [wikipedia.org](https://en.wikipedia.org) easily
searchable by first executing a search on those pages, then going to *Settings \> Search* and click the *Manage search
engines..* button. From there, \"Edit\" the Wikipedia entry and change its keyword to **w** (or some other shortcut you
prefer). Now searching Wikipedia for \"Arch Linux\" from the address bar is done simply by entering \"**w arch
linux**\".

```{=mediawiki}
{{Note| Google search is used automatically when typing something into the URL bar. A hard-coded keyword trigger is also available using the '''?''' prefix.}}
```
#### Tmpfs

##### Cache in tmpfs {#cache_in_tmpfs}

```{=mediawiki}
{{Note|Chromium stores its cache separate from its browser profile directory.}}
```
To limit Chromium from writing its cache to a physical disk, one can define an alternative location via the
`{{ic|--disk-cache-dir}}`{=mediawiki} flag:

`$ chromium --disk-cache-dir="$XDG_RUNTIME_DIR/chromium-cache"`

Cache should be considered temporary and will **not** be saved after a reboot or hard lock. Another option is to setup
the space in `{{ic|/etc/fstab}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/fstab|2=
tmpfs   /home/''username''/.cache   tmpfs   noatime,nodev,nosuid,size=400M  0   0
}}
```
Alternatively create a symbolic link to `{{ic|/tmp}}`{=mediawiki}. Make sure to delete Chromium\'s cache folder before
you run the command:

`$ ln -s /tmp /home/`*`username`*`/.cache/chromium`

##### Profile in tmpfs {#profile_in_tmpfs}

Relocate the browser profile to a [tmpfs](Wikipedia:Tmpfs "wikilink") filesystem, including `{{ic|/tmp}}`{=mediawiki},
or `{{ic|/dev/shm}}`{=mediawiki} for improvements in application response as the entire profile is now stored in RAM.

Use an active profile management tool such as `{{Pkg|profile-sync-daemon}}`{=mediawiki} for maximal reliability and ease
of use. It symlinks or bind mounts and syncs the browser profile directories to RAM. For more, see
[Profile-sync-daemon](Profile-sync-daemon "wikilink").

#### Launch a new browser instance {#launch_a_new_browser_instance}

When you launch the browser, it first checks if another instance using the same data directory is already running. If
there is one, the new window is associated with the old instance. If you want to launch an independent instance of the
browser, you must specify separate directory using the `{{ic|--user-data-dir}}`{=mediawiki} parameter:

`$ chromium --user-data-dir=`*`/path/to/some/directory`*

```{=mediawiki}
{{Note|The default location of the user data is {{ic|~/.config/chromium/}}.}}
```
#### Directly open \*.torrent files and magnet links with a torrent client {#directly_open_.torrent_files_and_magnet_links_with_a_torrent_client}

By default, Chromium downloads `{{ic|*.torrent}}`{=mediawiki} files directly and you need to click the notification from
the bottom-left corner of the screen in order for the file to be opened with your default torrent client. This can be
avoided with the following method:

-   Download a `{{ic|*.torrent}}`{=mediawiki} file.
-   Right-click the notification displayed at the bottom-left corner of the screen.
-   Check the \"*Always Open Files of This Type*\" checkbox.

See [xdg-open](xdg-open "wikilink") to change the default assocation.

#### Touch Scrolling on touchscreen devices {#touch_scrolling_on_touchscreen_devices}

You may need to specify which touch device to use. Find your touchscreen device with `{{ic| xinput list}}`{=mediawiki}
then launch Chromium with the `{{ic|1=--touch-devices='''x'''}}`{=mediawiki} parameter, where \"**x**\" is the id of
your device.
`{{Note|If the device is designated as a slave pointer, using this may not work, use the master pointer's ID instead.}}`{=mediawiki}

#### Reduce memory usage {#reduce_memory_usage}

By default, Chromium uses a separate OS process for each *instance* of a visited web site.
[9](https://www.chromium.org/developers/design-documents/process-models#Supported_Models) However, you can specify
command-line switches when starting Chromium to modify this behaviour.

For example, to share one process for all instances of a website:

`$ chromium --process-per-site`

To use a single process model:

`$ chromium --single-process`

```{=mediawiki}
{{Warning|The single-process model is discouraged because it is unsafe and may contain bugs not present in other models.[https://www.chromium.org/developers/design-documents/process-models#TOC-Single-process]}}
```
In addition, you can suspend or store inactive Tabs with extensions such as [Tab
Suspender](https://chrome.google.com/webstore/detail/tab-suspender/fiabciakcmgepblmdkmemdbbkilneeeh?hl=en) and
[OneTab](https://chrome.google.com/webstore/detail/onetab/chphlpgkkbolifaimnlloiipkdnihall?hl=en).

#### User Agent {#user_agent}

The User Agent can be arbitrarily modified at the start of Chromium\'s base instance via its
`{{Ic|<nowiki>--user-agent="[string]"</nowiki>}}`{=mediawiki} parameter.

#### DOM Distiller {#dom_distiller}

```{=mediawiki}
{{Remove|The project has been archived and the flag no longer works.}}
```
Chromium has a similar reader mode to Firefox. In this case it is called DOM Distiller, which is an [open source
project](https://github.com/chromium/dom-distiller). It is disabled by default, but can be enabled using the
`{{Ic|chrome://flags/#enable-reader-mode}}`{=mediawiki} flag, which you can also make
[persistent](#Making_flags_persistent "wikilink"). Not only does DOM Distiller provide a better reading experience by
distilling the content of the page, it also simplifies pages for print. Even though the latter checkbox option has been
removed from the print dialog, you can still print the distilled page, which basically has the same effect.

After enabling the flag, you will find a new \"Enter reader mode\" menu item and corresponding icon in the address bar
when Chromium thinks the website you are visiting could do with some distilling.

#### Forcing specific GPU {#forcing_specific_gpu}

In multi-GPU systems, Chromium automatically detects which GPU should be used for rendering (discrete or integrated).
This works 99% of the time, except when it does not - if an unavailable GPU is picked (for example, discrete graphics on
VFIO GPU passthrough-enabled systems), `{{ic|chrome://gpu}}`{=mediawiki} will complain about not being able to
initialize the GPU process. On the same page below **Driver Information** there will be multiple GPUs shown (GPU0, GPU1,
\...). There is no way to switch between them in a user-friendly way, but you can read the device/vendor IDs present
there and configure Chromium to use a specific GPU with flags:

`$ chromium --gpu-testing-vendor-id=0x8086 --gpu-testing-device-id=0x1912`

\...where `{{ic|0x8086}}`{=mediawiki} and `{{ic|0x1912}}`{=mediawiki} is replaced by the IDs of the GPU you want to use
(as shown on the `{{ic|chrome://gpu}}`{=mediawiki} page).

#### Import bookmarks from Firefox {#import_bookmarks_from_firefox}

To ease the transition, you can import bookmarks from [Firefox](Firefox "wikilink") into Chromium.

Navigate Chromium to `{{ic|chrome://settings/importData}}`{=mediawiki}

If Firefox is already installed on your computer, you can directly import bookmarks as well as many other things from
Firefox.

Make sure **Mozilla Firefox** is selected. Optionally, you can uncheck some unwanted items here. Click the **Import**
and then **Done**. You are done with it.

```{=mediawiki}
{{note|If you have not created any bookmarks in Chromium yet, the bookmarks will show up in your bookmarks bar. If you already have bookmarks, the bookmarks will be in a new folder labeled "Imported From Firefox"}}
```
If you import bookmarks from another PC, you have to export bookmarks from Firefox first.

```{=mediawiki}
{{ic|Ctrl+Shift+o}}
```
*Import and Backup \> Export Bookmarks To HTML* in Firefox.

The procedure is pretty much the same. You need to go to `{{ic|chrome://settings/importData}}`{=mediawiki}. However,
this time, in the **From** drop-down menu, select **Bookmarks HTML File** and click the **Choose File** button and
upload the desired bookmark file.

#### Enabling native notifications {#enabling_native_notifications}

```{=mediawiki}
{{Remove|In newer versions of Chromium, the flag is removed, and this behavior is the default.}}
```
Go to `{{ic|chrome://flags#enable-system-notifications}}`{=mediawiki} and select *Enabled*.

#### Enabling autoscroll with middle mouse button {#enabling_autoscroll_with_middle_mouse_button}

The autoscroll is still an experimental feature [10](https://niek.github.io/chrome-features/). It is intended to be
disabled by default if Chromium or Chromium-based browsers are not a development build and is running on a Linux
environment. [11](https://issues.chromium.org/issues/40811836)

To enable this feature, launch your browser with the `{{ic|1=--enable-features=MiddleClickAutoscroll}}`{=mediawiki}
flag. In case you want to make the option persistent, see [#Making flags
persistent](#Making_flags_persistent "wikilink").

```{=mediawiki}
{{Note|
* While setting {{ic|--enable-blink-features}} works in the same way as only typing {{ic|--enable-features}}, the browser instead may display a warning to state this is an unsupported flag, which "stability and security will suffer".
* As an alternative you can add an extension like [https://chromewebstore.google.com/detail/wheely-wheel-scroll-for-l/kkmfljfnlmppiaoijkfaejgkhccokpdn WHEELY] with similar behavior from Chrome Web Store.
}}
```
```{=mediawiki}
{{Tip|Another option is to [[install]] {{AUR|chromium-extension-autoscroll}}, but this is not recommended since it is an outdated package and not official. Use it with caution.}}
```
#### U2F authentication {#u2f_authentication}

Install `{{Pkg|libfido2}}`{=mediawiki} library. This provides the udev rules required to enable access to the
[U2F](U2F "wikilink") key as a user. U2F keys are by default only accessible by root, and without these rules Chromium
will give an error.

#### Theming

You can make Chromium use your current GTK theme for browser menus and controls. Simply press *Use GTK* in
`{{ic|chrome://settings/appearance}}`{=mediawiki}.

#### Dark mode {#dark_mode}

Since Chromium 114, [XDG Desktop Portal](XDG_Desktop_Portal "wikilink") is used to automatically determine the user\'s
preferred appearance ([issue](https://bugs.chromium.org/p/chromium/issues/detail?id=998903)), thereby dissociating dark
mode enablement from the user\'s GTK theme. This preference will be applied to *prefers-color-scheme* in CSS,
JavaScript, Settings and Dev-Tools.

The way to change the preferred appearance depends on your XDG Desktop Portal backend. For instance, many desktop
environments have a switch in their appearance settings. Or when using e.g.
`{{Pkg|xdg-desktop-portal-gtk}}`{=mediawiki}, set the preferred mode to `{{ic|prefer-light}}`{=mediawiki},
`{{ic|prefer-dark}}`{=mediawiki} or `{{ic|default}}`{=mediawiki} with:

`$ dconf write /org/gnome/desktop/interface/color-scheme \'prefer-dark\'`

You can query the current preferred appearance using `{{ic|dbus-send}}`{=mediawiki} in `{{Pkg|dbus}}`{=mediawiki}
([documentation](https://flatpak.github.io/xdg-desktop-portal/#gdbus-org.freedesktop.portal.Settings)):

`$ dbus-send --session --print-reply=literal --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:org.freedesktop.appearance string:color-scheme | tr -s ' ' | cut -d ' ' -f 5`

-   **0**: No preference
-   **1**: Prefer dark appearance
-   **2**: Prefer light appearance

##### Pre Chromium 114 {#pre_chromium_114}

To enable dark mode and enable the dark theme (normally used for incognito mode) [append](append "wikilink") the
following flag to [persistent configuration](#Making_flags_persistent "wikilink"):

```{=mediawiki}
{{hc|1=~/.config/chromium-flags.conf|2=
--force-dark-mode
--enable-features=WebUIDarkMode
}}
```
#### Enable Side Panel {#enable_side_panel}

The Side Panel can be enabled through `{{ic|chrome://flags}}`{=mediawiki}. You can enable or disable **Side panel**, and
change options such as **Side panel border** and **Side panel drag and drop**.

### Profile maintenance {#profile_maintenance}

Chromium uses [SQLite](SQLite "wikilink") databases to manage history and the like. Sqlite databases become fragmented
over time and empty spaces appear all around. But, since there are no managing processes checking and optimizing the
database, these factors eventually result in a performance hit. A good way to improve startup and some other bookmarks-
and history-related tasks is to defragment and trim unused space from these databases.

```{=mediawiki}
{{Pkg|profile-cleaner}}
```
and `{{AUR|browser-vacuum}}`{=mediawiki} do just this.

### Security

#### Disable JIT {#disable_jit}

At the cost of reduced performance, you can disable just-in-time compilation of JavaScript to native code, which is
responsible for [roughly half of the security vulnerabilities in the JS
engine](https://microsoftedge.github.io/edgevr/posts/Super-Duper-Secure-Mode/), using the flag
`{{ic|1=--js-flags=--jitless}}`{=mediawiki}.

#### WebRTC

WebRTC is a communication protocol that relies on JavaScript that can leak one\'s actual IP address and hardware hash
from behind a VPN. While some software may prevent the leaking scripts from running, it is probably a good idea to block
this protocol directly as well, just to be safe. As of October 2016, there is no way to disable WebRTC on Chromium on
desktop, there are extensions available to disable local IP address leak, one is this
[extension](https://chrome.google.com/webstore/detail/webrtc-network-limiter/npeicpdbkakmehahjeeohfdhnlpdklia).

One can test WebRTC via <https://browserleaks.com/webrtc>.

```{=mediawiki}
{{Warning|Even though IP leak can be prevented, Chromium still sends your unique hash, and there is no way to prevent this. Read more on https://www.browserleaks.com/webrtc#webrtc-disable}}
```
#### SSL certificates {#ssl_certificates}

See [#Certificates](#Certificates "wikilink") for general information.

##### Adding CAcert certificates for self-signed certificates {#adding_cacert_certificates_for_self_signed_certificates}

Grab the CAcerts and create an `{{ic|nssdb}}`{=mediawiki}, if one does not already exist. To do this, first install the
`{{Pkg|nss}}`{=mediawiki} package, then complete these steps:

`$ mkdir -p $HOME/.pki/nssdb`\
`$ cd $HOME/.pki/nssdb`\
`$ certutil -N -d sql:.`

`$ curl -k -o "cacert-root.crt" "`[`http://www.cacert.org/certs/root.crt`](http://www.cacert.org/certs/root.crt)`"`\
`$ curl -k -o "cacert-class3.crt" "`[`http://www.cacert.org/certs/class3.crt`](http://www.cacert.org/certs/class3.crt)`"`\
`$ certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "CAcert.org" -i cacert-root.crt `\
`$ certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "CAcert.org Class 3" -i cacert-class3.crt`

```{=mediawiki}
{{Note|Users will need to create a password for the database, if it does not exist.}}
```
Now users may manually import a self-signed certificate.

##### Example 1: Using a shell script to isolate the certificate from TomatoUSB {#example_1_using_a_shell_script_to_isolate_the_certificate_from_tomatousb}

Below is a simple script that will extract and add a certificate to the user\'s `{{ic|nssdb}}`{=mediawiki}:

`#!/bin/sh`\
`#`\
`# usage:  import-cert.sh remote.host.name [port]`\
`#`\
`REMHOST=$1`\
`REMPORT=${2:-443}`\
`exec 6>&1`\
`exec > $REMHOST`\
`echo | openssl s_client -connect ${REMHOST}:${REMPORT} 2>&1 |sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'`\
`certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n "$REMHOST" -i $REMHOST `\
`exec 1>&6 6>&-`

Syntax is advertised in the commented lines.

References:

-   <https://web.archive.org/web/20180718193807/https://blog.avirtualhome.com/adding-ssl-certificates-to-google-chrome-linux-ubuntu>
-   <https://chromium.googlesource.com/chromium/src/+/master/docs/linux/cert_management.md>

##### Example 2: Using Firefox to isolate the certificate from TomatoUSB {#example_2_using_firefox_to_isolate_the_certificate_from_tomatousb}

The `{{Pkg|firefox}}`{=mediawiki} browser can be used to save the certificate to a file for manual import into the
database.

Using firefox:

1.  Browse to the target URL.
2.  Upon seeing the \"This Connection is Untrusted\" warning screen, click: *I understand the Risks \> Add
    Exception\...*
3.  Click: *View \> Details \> Export* and save the certificate to a temporary location
    (`{{ic|/tmp/easy.pem}}`{=mediawiki} in this example).

Now import the certificate for use in Chromium:

`$ certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "easy" -i /tmp/easy.pem`

```{=mediawiki}
{{Note|Adjust the name to match that of the certificate. In the example above, "easy" is the name of the certificate.}}
```
Reference:

-   <https://sahissam.blogspot.com/2012/06/new-ssl-certificates-for-tomatousb-and.html>

#### Canvas Fingerprinting {#canvas_fingerprinting}

Canvas fingerprinting is a technique that allows websites to identify users by detecting differences when rendering to
an HTML5 canvas. This information can be made inaccessible by using the
`{{ic|--disable-reading-from-canvas}}`{=mediawiki} flag.

To confirm this is working run [this test](https://panopticlick.eff.org) and make sure \"hash of canvas fingerprint\" is
reported as undetermined in the full results.

```{=mediawiki}
{{Note|1=<nowiki/>
* Some extensions require reading from canvas and may be broken by setting {{ic|--disable-reading-from-canvas}}.
* The YouTube player or Google Maps do not work properly without canvas reading (see [https://github.com/qutebrowser/qutebrowser/issues/5345 Qutebrowser issue 5345], [https://bbs.archlinux.org/viewtopic.php?id=255958 BBS#255958], [https://bbs.archlinux.org/viewtopic.php?id=276425 BBS#276425]).
}}
```
#### Privacy extensions {#privacy_extensions}

See [Browser extensions#Privacy](Browser_extensions#Privacy "wikilink").

```{=mediawiki}
{{Tip|Installing too many extensions might take up much space in the toolbar. Those extensions which you would not interact with anyway can be hidden by right-clicking on the extension and choosing ''Hide in Chromium menu''.}}
```
#### Do Not Track {#do_not_track}

To enable [Do Not Track](wikipedia:Do_Not_Track "wikilink"), visit `{{ic|chrome://settings}}`{=mediawiki}, scroll down
to *Advanced* and under *Privacy and security*, check *Send a \"Do Not Track\" request with your browsing traffic*.

#### Force a password store {#force_a_password_store}

Chromium uses a password store to store your passwords and the *Chromium Safe Storage* key, which is used to encrypt
cookie values. [12](https://codereview.chromium.org/24734007)

By default Chromium auto-detects which password store to use, which can lead to you apparently losing your passwords and
cookies when switching to another desktop environment or window manager.

You can force Chromium to use a specific password store by launching it with the `{{ic|--password-store}}`{=mediawiki}
flag with one of following the values
[13](https://chromium.googlesource.com/chromium/src/+/master/docs/linux/password_storage.md):

-   ```{=mediawiki}
    {{ic|gnome-libsecret}}
    ```
    , uses [Gnome Keyring](Gnome_Keyring "wikilink") via [libsecret](https://gitlab.gnome.org/GNOME/libsecret).

-   ```{=mediawiki}
    {{ic|kwallet5}}
    ```
    , uses [KDE Wallet](KDE_Wallet "wikilink") 5

-   ```{=mediawiki}
    {{ic|kwallet6}}
    ```
    , uses [KDE Wallet](KDE_Wallet "wikilink") 6

-   ```{=mediawiki}
    {{ic|basic}}
    ```
    , saves the passwords and the cookies\' encryption key as plain text in the file `{{ic|Login Data}}`{=mediawiki}

-   ```{=mediawiki}
    {{ic|detect}}
    ```
    , the default auto-detect behavior

For example, to force Chromium to use Gnome Keyring in another desktop or WM use
`{{ic|1=--password-store=gnome-libsecret}}`{=mediawiki}, see [#Making flags
persistent](#Making_flags_persistent "wikilink") for making it permanent.

When using a password store of another desktop environment you probably also want to unlock it automatically. See
[GNOME/Keyring#Using the keyring](GNOME/Keyring#Using_the_keyring "wikilink") and [KDE Wallet#Unlock KDE Wallet
automatically on login](KDE_Wallet#Unlock_KDE_Wallet_automatically_on_login "wikilink").

#### Enable hybrid post-quantum key exchange {#enable_hybrid_post_quantum_key_exchange}

Chromium supports the hybrid post-quantum key exchange
[X25519Kyber768](https://www.ietf.org/archive/id/draft-tls-westerbaan-xyber768d00-02.html) for TLS 1.3 since version 155
[14](https://blog.chromium.org/2023/08/protecting-chrome-traffic-with-hybrid.html). This feature is disabled by default,
but can be enabled using the `{{Ic|chrome://flags/#enable-tls13-kyber}}`{=mediawiki} flag.

### Open any website as a native application {#open_any_website_as_a_native_application}

You can open any website in a tabless window intended for [Progressive Web
Apps](https://developer.chrome.com/blog/getting-started-pwa/):

`$ chromium --app=`*[`https://archlinux.org/`](https://archlinux.org/)*

You need to use a correct full URL. This could be combined with `{{ic|--user-data-dir}}`{=mediawiki} to split configs.
Local html file is also used at native application with
`{{ic|1=--allow-file-access-from-files --app=file://*}}`{=mediawiki}.

### Force offline {#force_offline}

You can force offline state by `{{ic|1=--proxy-server=dummy}}`{=mediawiki} for security when you use local html file
from Chromium.

### Faster downloading {#faster_downloading}

Chromium has `{{ic|--enable-parallel-downloading}}`{=mediawiki} flag for parallel downloading without extensions.

## Troubleshooting

### Fonts

```{=mediawiki}
{{Note|Chromium does not fully integrate with fontconfig/GTK/Pango/X/etc. due to its sandbox. For more information, see the [https://dev.chromium.org/developers/linux-technical-faq Linux Technical FAQ].}}
```
#### Tab font size is too large {#tab_font_size_is_too_large}

Chromium will use the GTK settings as described in [GTK#Configuration](GTK#Configuration "wikilink"). When configured,
Chromium will use the `{{ic|gtk-font-name}}`{=mediawiki} setting for tabs (which may mismatch window font size). To
override these settings, use `{{ic|1=--force-device-scale-factor=1.0}}`{=mediawiki}.

Since Chrome Refresh 2023 became default, GNOME users with Cantarell font may notice some characters (like lowercase g)
cut off in the tab title. See the [issue on chromium.org](https://issues.chromium.org/issues/40934082).

Until the issue resolved, a workaround is to replace Cantarell with another font using a configuration based on [Font
configuration#Set default or fallback fonts](Font_configuration#Set_default_or_fallback_fonts "wikilink"), e.g.

```{=mediawiki}
{{hc|~/.config/fontconfig/conf.d/10-chromium-font.conf|<nowiki>
<match target="pattern">
    <test name="prgname" compare="eq">
        <string>chromium</string>
    </test>
    <test qual="any" name="family">
         <string>Cantarell</string>
    </test>
    <edit name="family" mode="assign" binding="strong">
        <string>Ubuntu</string>
    </edit>
</match>
</nowiki>}}
```
This configuration will apply only if process name `{{ic|chromium}}`{=mediawiki} matches. You can use
`{{ic|chrome}}`{=mediawiki} for Google Chrome.

### WebGL

There is the possibility that your graphics card has been blacklisted by Chromium. See [#Force GPU
acceleration](#Force_GPU_acceleration "wikilink").

If you are using Chromium with [Bumblebee](Bumblebee "wikilink"), WebGL might crash due to GPU sandboxing. In this case,
you can disable GPU sandboxing with `{{ic|optirun chromium --disable-gpu-sandbox}}`{=mediawiki}.

Visit `{{ic|chrome://gpu/}}`{=mediawiki} for debugging information about WebGL support.

Chromium can save incorrect data about your GPU in your user profile (e.g. if you use switch between an Nvidia card
using Optimus and Intel, it will show the Nvidia card in `{{ic|chrome://gpu}}`{=mediawiki} even when you are not using
it or primusrun/optirun). Running using a different user directory, e.g,
`{{ic|1=chromium --user-data-dir=$(mktemp -d)}}`{=mediawiki} may solve this issue. For a persistent solution you can
reset the GPU information by deleting `{{ic|~/.config/chromium/Local\ State}}`{=mediawiki}.

### Incorrect HiDPI rendering {#incorrect_hidpi_rendering}

Chromium will automatically scale for a [HiDPI](HiDPI "wikilink") display, however, this may cause an incorrect rendered
GUI.

The flag `{{ic|1=--force-device-scale-factor=1}}`{=mediawiki} may be used to overrule the automatic scaling factor.

When [native Wayland support](#Native_Wayland_support "wikilink") is enabled, Chromium will automatically scale based on
the configured scale of each monitor.

### Password prompt on every start with GNOME Keyring {#password_prompt_on_every_start_with_gnome_keyring}

See [GNOME/Keyring#Passwords are not remembered](GNOME/Keyring#Passwords_are_not_remembered "wikilink").

### Everything is syncing except for password {#everything_is_syncing_except_for_password}

If synchronization is not working for password only (you can check it on `{{ic|chrome://sync-internals/}}`{=mediawiki})
delete profile login data:

`$ rm ~/.config/chromium/Default/Login\ Data*`

See [Google Chrome Help forum](https://support.google.com/chrome/thread/9947763?hl=en&msgid=23687608) for details.

### Losing cookies and passwords when switching between desktop environments {#losing_cookies_and_passwords_when_switching_between_desktop_environments}

If you see the message `{{ic|Failed to decrypt token for service AccountId-*}}`{=mediawiki} in the terminal when you
start Chromium, it might try to use the wrong password storage backend. This might happen when you switch between
Desktop Environments.

See [#Force a password store](#Force_a_password_store "wikilink").

### Hang on startup when Google Sync enabled {#hang_on_startup_when_google_sync_enabled}

Try launching Chrome with `{{ic|1=--password-store=basic}}`{=mediawiki} or another appropriate password store.

See [#Force a password store](#Force_a_password_store "wikilink").

### Chromium asks to be set as the default browser every time it starts {#chromium_asks_to_be_set_as_the_default_browser_every_time_it_starts}

If you are using KDE and have once set Firefox as the default browser (by clicking the button inside Firefox), you might
find Chromium asks to be set as the default browser every time it starts, even if you click the \"set as default\"
button.

Chromium checks for this status by running `{{ic|xdg-settings check default-web-browser chromium.desktop}}`{=mediawiki}.
If the output is \"no\", it is not considering itself to be the default browser. The script
`{{ic|xdg-settings}}`{=mediawiki} checks for the following MIME associations and expect all of them to be
`{{ic|chromium.desktop}}`{=mediawiki}:

```{=mediawiki}
{{bc|
x-scheme-handler/http
x-scheme-handler/https
text/html}}
```
To fix it, go to *System settings \> Applications \> Default applications \> Web browser* and choose Chromium. Then, set
the MIME association for `{{ic|text/html}}`{=mediawiki}:

`$ xdg-mime default chromium.desktop text/html`

Finally, [update the MIME database](XDG_MIME_Applications#New_MIME_types "wikilink"):

`$ update-mime-database ~/.local/share/mime`

### \"This browser or app may not be secure\" error logging in to Google {#this_browser_or_app_may_not_be_secure_error_logging_in_to_google}

As of 2020.04.20 if you run chromium with `{{ic|1=--remote-debugging-port=9222}}`{=mediawiki} flag for web development,
you cannot log in to your Google account. Temporarily disable this flag to login and then you can enable it back.

### Chromium rendering at 60 FPS despite using a display with a higher refresh rate {#chromium_rendering_at_60_fps_despite_using_a_display_with_a_higher_refresh_rate}

Upstream bug report about the general issue which may contain some additional workarounds can be found
[here](https://bugs.chromium.org/p/chromium/issues/detail?id=1200167), and a sister issue about mixed refresh rates
[here](https://bugs.chromium.org/p/chromium/issues/detail?id=1138080).

#### Mixed refresh rates {#mixed_refresh_rates}

```{=mediawiki}
{{Tip|This issue is possibly not present on the Wayland backend, needs testing.}}
```
When using displays with mixed refresh rates(for example 60Hz and 144Hz), Chromium might render for the lower Hz
display.

There is a suitable workaround for this issue, [append](append "wikilink") the following flags to [persistent
configuration](#Making_flags_persistent "wikilink"):

```{=mediawiki}
{{hc|1=~/.config/chromium-flags.conf|2=
--use-gl=egl
--ignore-gpu-blocklist
--enable-gpu-rasterization
}}
```
This should make Chromium run at 144 FPS when used on a 144Hz display, assuming your compositor is also refreshing at
144 FPS. Keep in mind it might be a little choppy due to `{{Bug|67035}}`{=mediawiki}, but it is way better than being
stuck at 60 FPS.

#### Running on the Wayland backend {#running_on_the_wayland_backend}

There seem to be Wayland compositor-specific problems that trigger this issue. Notably, Plasma 5 seems to only ever
render on 60Hz no matter the setup, but Plasma 6(rc1, at the time of writing) makes Chromium work flawlessly on high
refresh rates.

A workaround may be to switch to the XWayland backend if all else fails.

### Chromium slow scroll speed {#chromium_slow_scroll_speed}

Mouse whell scrolling in chromium and electron based applications may be too slow for daily usage. Here are some
solutions.

[Libinput#Mouse wheel scrolling speed scaling](Libinput#Mouse_wheel_scrolling_speed_scaling "wikilink") injects
`{{ic|libinput_event_pointer_get_axis_value}}`{=mediawiki} function in libinput and provides an interface to change
scale factor. This is not an application level injection, so an addition script for application specific scale factor
tuning is needed. Note that scroll on chromium\'s small height developer tools may be too fast when scale factor is big
enough.

[IMWheel](IMWheel "wikilink") increases scroll distance by replaying X wheel button event for multiple times. However,
chromium assumes the real scroll and the replayed ones as two events. There is a small but noticeable delay between
them, so one mouse wheel scroll leads to twice page jumps. Also, touchpad scroll needs additional care.

[Linux Scroll Speed
Fix](https://chrome.google.com/webstore/detail/linux-scroll-speed-fix/mlboohjioameadaedfjcpemcaangkkbp) and
[SmoothScroll](https://chrome.google.com/webstore/detail/smoothscroll/nbokbjkabcmbfdlbddjidfmibcpneigj) are two chromium
extensions with support for scroll distance modification. Upon wheel scroll in a web page, the closest scrollable
ancestor of current focused node will be found, then a scroll method with given pixel distance will be called on it,
even if it has been scrolled to bottom. So once you scroll into a text editor or any scrollable element, you can never
scroll out of it, except moving mouse. Also, extension based methods can not be used outside chromium.

### Videos load but do not play {#videos_load_but_do_not_play}

```{=mediawiki}
{{Out of date|The linked section states that Chromium is not affected.}}
```
This may be a PulseAudio issue. See the suggested fix in [PulseAudio/Troubleshooting#Browsers (firefox) load videos but
do no play](PulseAudio/Troubleshooting#Browsers_(firefox)_load_videos_but_do_no_play "wikilink").

### Passwords are not saved due to a corrupted database {#passwords_are_not_saved_due_to_a_corrupted_database}

The stored password database can become corrupted and in need of getting rebuilt. Doing so will destroy all data
therein/lose stored passwords.

Launch chromium from a terminal and look for output like:

`[472531:472565:1207/055404.688559:ERROR:login_database.cc(1048)] Password decryption failed, encryption_result is 2`

Exit chromium and then delete these three database files: `{{ic|~/.config/chromium/Default/Login Data*}}`{=mediawiki}

Launching chromium again should re-create them.

### Cursor is not correct on KDE Wayland {#cursor_is_not_correct_on_kde_wayland}

See [KDE#Plasma cursor sometimes shown incorrectly](KDE#Plasma_cursor_sometimes_shown_incorrectly "wikilink").

### Chromium window is transparent under Wayland {#chromium_window_is_transparent_under_wayland}

Due to a [bug](https://issues.chromium.org/issues/329678163), chromium 124 must be started with the explicit command
line flag `{{ic|1=--ozone-platform=wayland}}`{=mediawiki}.

### Wayland hardware acceleration buffer handle is null errors {#wayland_hardware_acceleration_buffer_handle_is_null_errors}

Due to a [bug](https://issues.chromium.org/issues/331796411), you may see the below in your log when launching from
terminal, especially with hardware acceleration enabled on Wayland:

```{=mediawiki}
{{bc|[333310:333425:0919/121130.103852:ERROR:gpu_channel.cc(502)] Buffer Handle is null.
[333341:18:0919/121130.104000:ERROR:shared_image_interface_proxy.cc(134)] Buffer handle is null. Not creating a mailbox from it.
[333310:333425:0919/121130.137149:ERROR:gbm_pixmap_wayland.cc(82)] Cannot create bo with format{{=}}
```
YUV_420_BIPLANAR and usage{{=}}SCANOUT_CPU_READ_WRITE }}

Workaround for now is adding this flag: `{{hc|1=~/.config/chromium-flags.conf|2=
--disable-gpu-memory-buffer-video-frames
}}`{=mediawiki}

### No audio available without sound server {#no_audio_available_without_sound_server}

Chromium does not support [Advanced Linux Sound Architecture#Addressing hardware
directly](Advanced_Linux_Sound_Architecture#Addressing_hardware_directly "wikilink"). Set output devices
`{{ic|pcm.dmixer}}`{=mediawiki} and `{{ic|pcm.dsnooper}}`{=mediawiki} as seen in the page and use
`{{ic|1=-alsa-output-device=pcm.dmixer -alsa-input-device=pcm.dsnooper}}`{=mediawiki} flags.

### Gnome \"Global Shortcuts\" menu appears on startup {#gnome_global_shortcuts_menu_appears_on_startup}

Due to extensions which define global shortcuts (such as obsidian web clipper), the gnome \"Global Shortcuts\" appears
at startup. This is described in <https://github.com/brave/brave-browser/issues/44886> and can be fixed by adding this
flag:

```{=mediawiki}
{{hc|1=~/.config/chromium-flags.conf|2=
--disable-features=GlobalShortcutsPortal
}}
```
### Compose key does not work: Typing special characters with keyboard not possible {#compose_key_does_not_work_typing_special_characters_with_keyboard_not_possible}

Due to a bug the \"Compose\" key does not work in recent versions of chromium. This becomes apparent when user tries to
type in special characters such as \`@\` or umlauts anywhere in the browser. The special key combinations utilizing the
compose key (for example \`ALT GR\`) work in all applications except chromium. This issue is most likely related to gtk
and cannot be resolved by switching between Wayland and X11. It is described at
<https://issues.chromium.org/issues/327158031> and can be fixed by adding this flag:

```{=mediawiki}
{{hc|1=~/.config/chromium-flags.conf|2=
--disable-gtk-ime 
}}
```
### Chromium does not fully maximize on Wayland {#chromium_does_not_fully_maximize_on_wayland}

You have to enable *Use system title bar and borders* via the *<chrome://settings/appearance>* menu.

### Chromium has no sound but sound output device is present {#chromium_has_no_sound_but_sound_output_device_is_present}

For WirePlumber users, [resetting WirePlumber state](WirePlumber#Delete_corrupt_settings "wikilink") may help.

## See also {#see_also}

-   [Chromium homepage](https://www.chromium.org/)
-   [Google Chrome release notes](https://chromereleases.googleblog.com/)
-   [Chrome web store](https://chrome.google.com/webstore/)
-   [Differences between Chromium and Google
    Chrome](Wikipedia:Chromium_(web_browser)#Differences_from_Google_Chrome "wikilink")
-   [List of Chromium command-line switches](https://peter.sh/experiments/chromium-command-line-switches/)
-   [Profile-sync-daemon](Profile-sync-daemon "wikilink") - Systemd service that saves Chromium profile in tmpfs and
    syncs to disk
-   [Tmpfs](Tmpfs "wikilink") - Tmpfs Filesystem in `{{ic|/etc/fstab}}`{=mediawiki}
-   [Official tmpfs kernel Documentation](https://docs.kernel.org/filesystems/tmpfs.html)

[Category:Web browser](Category:Web_browser "wikilink") [Category:Google](Category:Google "wikilink")

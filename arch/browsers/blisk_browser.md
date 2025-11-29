`{{Style|Multiple sections duplicate [[Chromium]], they should be shortened to link there and only keep on this page what diverges, per the [[Help:Reading#Organization|don't repeat yourself]] principle.}}`{=mediawiki}
`{{Related articles start}}`{=mediawiki} `{{Related|Browser extensions}}`{=mediawiki} `{{Related|Chromium}}`{=mediawiki}
`{{Related|Wayland}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[Blisk](https://blisk.io) is a specialized web browser, made for web designers and web developers, made by Estonian
company **SyncUI OÜ**. The browser is free to use with limited functionality, but in order to get full access to the
development features, a paid subscription is required. The Blisk browser is based on Chrome, using
[Chromium](Chromium "wikilink") as its base.

## Installation

[Install](Install "wikilink") the `{{AUR|blisk-browser-stable}}`{=mediawiki} package.

### Add-ons {#add_ons}

Blisk is based on [Chromium](Chromium "wikilink") and has access to the Chrome Extension Store. However, while most
extension should work just fine, there are possible issues, especially with more complex extensions, focusing on more
Chrome specific functions and features. Hence, **not all of these add-ons actually work** with Blisk.

## Configuration

Configuration of Blisk is possible through the menu, in the same way as it works with [Chromium](Chromium "wikilink").
However, as with Chrome and other browsers, you can also access are more complex set of options and settings by using:

[`chrome://settings`](chrome://settings)

This gives access to some advanced and experimental settings, mainly meant for experimental features and debugging.
Unless you know what you are doing, or are specifically told to change them, you can usually leave them alone.

```{=mediawiki}
{{Note|Unlike [[Firefox]] or [[Chromium]], the Blisk browser does not offer synchronization with other devices or browsers.}}
```
### KDE integration {#kde_integration}

For integration into [Plasma](Plasma "wikilink") install `{{Pkg|plasma-browser-integration}}`{=mediawiki}. See [KDE
Plasma Browser Integration](https://community.kde.org/Plasma/Browser_Integration) for more details.

### PDF viewer plugin {#pdf_viewer_plugin}

Blisk, like [Chromium](Chromium "wikilink") and Google Chrome are bundled with the *Chromium PDF Viewer* plugin. If you
do not want to use this plugin, check *Download PDFs* in `{{ic|chrome://settings/content/pdfDocuments}}`{=mediawiki}.

### Running on Xwayland {#running_on_xwayland}

If you are using NVIDIA\'s proprietary driver, running Blisk on Xwayland may cause the GPU process to occasionally
crash. To prevent the GPU process from crashing, add the following flags:

`--use-angle=vulkan --use-cmd-decoder=passthrough`

```{=mediawiki}
{{Note|This does not prevent all Xwayland-related crashes.}}
```
### Native Wayland support {#native_wayland_support}

Blisk supports native [Wayland](Wayland "wikilink"), the same way Chromium does. This can be enabled with the following
flags [1](https://chromium.googlesource.com/chromium/src/+/43cfb2f92a5cdc1a787d7326e74676884abf5052):

`--ozone-platform-hint=auto`

The flag is also available via [browser flags menu](#chrome://_URLs "wikilink").

This will select Wayland\'s Ozone backend when in wayland session. So you can use a single [desktop
entry](desktop_entry "wikilink"), if you switch between X11 and Wayland often.

```{=mediawiki}
{{Note|When changing the "ozone-platform-hint" in browser flags menu, the browser will provide you a relaunch button. Do not use it, because the browser will still be relaunched in a platform it was before changing the flag. You need to close the browser, then open it.}}
```
Additionally, if you are having [trouble with input
methods](https://bugs.chromium.org/p/chromium/issues/detail?id=1422087), which may or may not apply to Blisk, you may
also want to force newer GTK:

`--gtk-version=4`

If you are using [Fcitx5](Fcitx5 "wikilink") and it does not work properly using the above flags, try using the
`{{ic|--enable-wayland-ime}}`{=mediawiki} flag instead of `{{ic|--gtk-version{{=}}`{=mediawiki}4}}.
[2](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Chromium_.2F_Electron)

`--enable-wayland-ime --wayland-text-input-version=3`

```{=mediawiki}
{{Note|Enabling the {{ic|--enable-wayland-ime}} flag works if the {{ic|text_input_v1}} protocol is implemented by default. Known compositors that implement this protocol are: Weston, KWin, Hyprland.}}
```
## Tips and tricks {#tips_and_tricks}

The following tips and tricks should work for both Blisk and Chromium, unless explicitly stated.

### Browsing experience {#browsing_experience}

#### <chrome://> URLs {#chrome_urls}

A number of tweaks can be accessed via Chrome URLs. See **<chrome://chrome-urls>** for a complete list.

-   **<chrome://flags>** - access experimental features such as WebGL and rendering webpages with GPU, etc.
-   **<chrome://extensions>** - view, enable and disable the currently used Chromium extensions.
-   **<chrome://gpu>** - status of different GPU options.
-   **<chrome://sandbox>** - indicate sandbox status.
-   **<chrome://version>** - display version and switches used to invoke the active
    `{{ic|/usr/bin/chromium}}`{=mediawiki}.

An automatically updated, complete listing of [Chromium](Chromium "wikilink") / Blisk [command-line
parameters](https://peter.sh/experiments/chromium-command-line-switches/) is available.

#### Blisk task manager {#blisk_task_manager}

```{=mediawiki}
{{ic|Shift+ESC}}
```
can be used to bring up the browser task manager wherein memory, CPU, and network usage can be viewed. This is a helpful
tool for developers or if your browser is running slow.

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
{{Note|Blisk stores its cache separate from its browser profile directory.}}
```
To limit Blisk from writing its cache to a physical disk, it is possible to define an alternative location via the
`{{ic|--disk-cache-dir}}`{=mediawiki} flag:

`$ blisk --disk-cache-dir="$XDG_RUNTIME_DIR/chromium-cache"`

Cache should be considered temporary and will **not** be saved after a reboot or hard lock. Another option is to setup
the space in `{{ic|/etc/fstab}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/fstab|2=
tmpfs   /home/''username''/.cache   tmpfs   noatime,nodev,nosuid,size=400M  0   0
}}
```
Alternatively, create a symbolic link to `{{ic|/tmp}}`{=mediawiki}. Make sure to delete Blisks\'s cache folder before
you run the command, to avoid any problems:

`$ ln -s /tmp /home/`*`username`*`/.cache/blisk`

##### Profile in tmpfs {#profile_in_tmpfs}

Relocate the browser profile to a [tmpfs](Wikipedia:Tmpfs "wikilink") filesystem, including `{{ic|/tmp}}`{=mediawiki},
or `{{ic|/dev/shm}}`{=mediawiki} for improvements in application response as the entire profile is now stored in RAM.

Use an active profile management tool such as `{{Pkg|profile-sync-daemon}}`{=mediawiki} for maximal reliability and ease
of use. It symlinks or bind mounts and syncs the browser profile directories to RAM. For more, see
[Profile-sync-daemon](Profile-sync-daemon "wikilink").

#### Launch a new browser instance {#launch_a_new_browser_instance}

When you launch the browser, it first checks if another instance using the same data directory is already running. If
there is one, the new window is associated with the old instance. If you want to launch an independent instance of the
browser, you must specify a separate directory using the `{{ic|--user-data-dir}}`{=mediawiki} parameter:

`$ blisk --user-data-dir=`*`/path/to/some/directory`*

```{=mediawiki}
{{Note|The default location of the user data is {{ic|~/.config/blisk/}}.}}
```
#### Directly open \*.torrent files and magnet links with a torrent client {#directly_open_.torrent_files_and_magnet_links_with_a_torrent_client}

By default, Blisk downloads `{{ic|*.torrent}}`{=mediawiki} files directly and you need to click the notification from
the bottom-left corner of the screen in order for the file to be opened with your default torrent client. This can be
avoided with the following method:

-   Download a `{{ic|*.torrent}}`{=mediawiki} file.
-   Right-click the notification displayed at the bottom-left corner of the screen.
-   Check the \"*Always Open Files of This Type*\" checkbox.

See [xdg-open](xdg-open "wikilink") to change the default association.

#### Reduce memory usage {#reduce_memory_usage}

By default, Blisk uses a separate OS process for each *instance* of a visited website.
[3](https://www.chromium.org/developers/design-documents/process-models#Supported_Models) However, you can specify
command-line switches when starting Blisk to modify this behavior.

For example, to share one process for all instances of a website:

`$ blisk --process-per-site`

To use a single process model:

`$ blisk --single-process`

```{=mediawiki}
{{Warning|The single-process model is discouraged because it is unsafe and may contain bugs not present in other models.[https://www.chromium.org/developers/design-documents/process-models#TOC-Single-process]}}
```
In addition, you can suspend or store inactive Tabs with extensions such as [Tab
Suspender](https://chrome.google.com/webstore/detail/tab-suspender/fiabciakcmgepblmdkmemdbbkilneeeh?hl=en) and
[OneTab](https://chrome.google.com/webstore/detail/onetab/chphlpgkkbolifaimnlloiipkdnihall?hl=en).

#### User Agent {#user_agent}

"The User Agent can be arbitrarily modified at the start of Blisks\'s base instance via its
`{{Ic|<nowiki>--user-agent="[string]”</nowiki>}}`{=mediawiki} parameter.

#### DOM Distiller {#dom_distiller}

Chromium has a similar reader mode to Firefox. In Blisk, this is called DOM Distiller, which is an [open source
project](https://github.com/chromium/dom-distiller). It is disabled by default, but can be enabled using the
`{{Ic|chrome://flags/#enable-reader-mode}}`{=mediawiki} flag, which you can also make
[persistent](Chromium#Making_flags_persistent "wikilink").

Not only does DOM Distiller provide a better reading experience by distilling the content of the page, it also
simplifies pages for print. Even though the latter checkbox option has been removed from the print dialog, you can still
print the distilled page, which basically has the same effect.

After enabling the flag, you will find a new "Enter reader mode" menu item and corresponding icon in the address bar
when Blisk thinks the website you are visiting could do with some distilling.

#### Forcing specific GPU {#forcing_specific_gpu}

In multi-GPU systems, Blisk automatically detects which GPU should be used for rendering (discrete or integrated). This
works 99% of the time, except when it does not --- if an unavailable GPU is picked (for example, discrete graphics on
VFIO GPU passthrough-enabled systems), `{{ic|chrome://gpu}}`{=mediawiki} will complain about not being able to
initialize the GPU process. On the same page below **Driver Information** there will be multiple GPUs shown (GPU0, GPU1,
\...). There is no way to switch between them in a user-friendly way, but you can read the device/vendor IDs present
there and configure Blisk to use a specific GPU with flags:

`$ blisk --gpu-testing-vendor-id=0x8086 --gpu-testing-device-id=0x1912`

\...where `{{ic|0x8086}}`{=mediawiki} and `{{ic|0x1912}}`{=mediawiki} is replaced by the IDs of the GPU you want to use
(as shown on the `{{ic|chrome://gpu}}`{=mediawiki} page).

#### Import bookmarks from Firefox {#import_bookmarks_from_firefox}

To ease the transition, you can import bookmarks from [Firefox](Firefox "wikilink") into Blisk.

Navigate Blisk to `{{ic|chrome://settings/importData}}`{=mediawiki}

If Firefox is already installed on your computer, you can directly import bookmarks as well as many other things from
Firefox.

Make sure **Mozilla Firefox** is selected. Optionally, you can uncheck some unwanted items here. Click the **Import**
and then **Done**. You are done with it.

```{=mediawiki}
{{note|If you have not created any bookmarks in Blisk yet, the bookmarks will show up in your bookmarks bar. If you already have bookmarks, the bookmarks will be in a new folder labeled "Imported From Firefox"}}
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

Go to `{{ic|chrome://flags#enable-system-notifications}}`{=mediawiki} and select *Enabled*.

#### Enabling autoscroll with middle mouse button {#enabling_autoscroll_with_middle_mouse_button}

The autoscroll is still an experimental feature [4](https://niek.github.io/chrome-features/). It is intended to be
disabled by default if Blisk or Chromium-based browsers are not a development build and is running on a Linux
environment. [5](https://issues.chromium.org/issues/40811836)

To enable this feature, launch your browser with the `{{ic|1=--enable-features=MiddleClickAutoscroll}}`{=mediawiki}
flag. In case you want to make the option persistent, see [Chromium#Making flags
persistent](Chromium#Making_flags_persistent "wikilink").

```{=mediawiki}
{{Note|
* While setting {{ic|--enable-blink-features}} works in the same way as only typing {{ic|--enable-features}}, the browser instead may display a warning to state this is an unsupported flag, which "stability and security will suffer".
* As an alternative you can add an extension like [https://chromewebstore.google.com/detail/wheely-wheel-scroll-for-l/kkmfljfnlmppiaoijkfaejgkhccokpdn WHEELY] with similar behavior from Chrome Web Store.
}}
```
```{=mediawiki}
{{Tip|Another option is to [[install]] {{AUR|chromium-extension-autoscroll}}, but this is not recommended since it is an outdated package and not official. Use it with caution.}}
```
[Category:Web browser](Category:Web_browser "wikilink")

[de:Firefox](de:Firefox "wikilink") [es:Firefox](es:Firefox "wikilink") [ja:Firefox](ja:Firefox "wikilink")
[ru:Firefox](ru:Firefox "wikilink") [zh-hans:Firefox](zh-hans:Firefox "wikilink")
[zh-hant:Firefox](zh-hant:Firefox "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|/Privacy}}`{=mediawiki} `{{Related|/Profile on RAM}}`{=mediawiki} `{{Related|/Tweaks}}`{=mediawiki}
`{{Related|Browser extensions}}`{=mediawiki} `{{Related|Chromium}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[Firefox](https://www.mozilla.org/firefox) is a popular open source graphical web browser from
[Mozilla](https://www.mozilla.org).

## Installation

[Install](Install "wikilink") the `{{Pkg|firefox}}`{=mediawiki} package.

Other alternatives include:

-   ```{=mediawiki}
    {{App|Firefox Beta|cutting-edge version|https://www.mozilla.org/firefox/channel/desktop/#beta|{{AUR|firefox-beta-bin}}}}
    ```

-   ```{=mediawiki}
    {{App|Firefox Developer Edition|for developers|https://www.mozilla.org/firefox/developer/|{{Pkg|firefox-developer-edition}}}}
    ```

-   ```{=mediawiki}
    {{App|Firefox Extended Support Release|long-term supported version|https://www.mozilla.org/firefox/organizations/|{{AUR|firefox-esr}}}}
    ```

-   ```{=mediawiki}
    {{App|Firefox KDE|incorporates an OpenSUSE patch for better [[#KDE integration|KDE integration]] than is possible through simple Firefox add-ons|https://build.opensuse.org/package/show/mozilla:Factory/MozillaFirefox|{{AUR|firefox-kde-opensuse}}}}
    ```

-   ```{=mediawiki}
    {{App|Firefox Nightly|nightly builds for testing ([https://developer.mozilla.org/Firefox/Experimental_features experimental features])|https://www.mozilla.org/firefox/channel/desktop/#nightly|{{AUR|firefox-nightly}}}}
    ```

-   On top of the different Mozilla build channels, a number of forks exist with more or less special features---see
    [List of applications/Internet#Gecko-based](List_of_applications/Internet#Gecko-based "wikilink").

A number of language packs are available for Firefox, other than the standard English. Language packs are usually named
as `{{ic|firefox-i18n-''languagecode''}}`{=mediawiki} (where `{{ic|''languagecode''}}`{=mediawiki} can be any language
code, such as **de**, **ja**, **fr**, etc.). For a list of available language packs, see
[firefox-i18n](https://archlinux.org/packages/extra/any/firefox-i18n/) for `{{Pkg|firefox}}`{=mediawiki},
[firefox-developer-edition-i18n](https://archlinux.org/packages/extra/any/firefox-developer-edition-i18n/) for
`{{Pkg|firefox-developer-edition}}`{=mediawiki} and
[firefox-nightly-](https://aur.archlinux.org/packages/?K=firefox-nightly-) for `{{AUR|firefox-nightly}}`{=mediawiki}.

```{=mediawiki}
{{Note|1=Language packs are disabled on ''-nightly'' and ''-developer-edition'' due to frequent string changes that may cause crashes. To force a change to the UI language, you may need to set {{ic|intl.locale.requested}} in {{ic|about:config}} [https://www.reddit.com/r/firefox/comments/lx3dp9/how_to_change_interface_language/gpovlsp/?context=8&depth=9]. To display language settings in the setting page, set {{ic|intl.multilingual.enabled}} to {{ic|true}} in {{ic|about:config}}.}}
```
## Add-ons {#add_ons}

Firefox is well known for its large library of add-ons which can be used to add new features or modify the behavior of
existing features. Firefox\'s \"Add-ons Manager\" is used to manage installed add-ons or find new ones.

For instructions on how to install add-ons and a list of add-ons, see [Browser
extensions](Browser_extensions "wikilink").

### Adding search engines {#adding_search_engines}

Search engines may be added to Firefox by creating bookmarks:

-   Press the star on the address bar or `{{ic|Ctrl+d}}`{=mediawiki}.
-   Right click on the bookmark you have created, then press *Edit Bookmark\...*
-   Complete the *URL* field with search URLs. Complete the place of the query with `{{ic|%s}}`{=mediawiki}. Complete
    the *Keyword* field with user-defined characters. Like this:

`URL:`\
[`https://duckduckgo.com/html/?q=%s`](https://duckduckgo.com/html/?q=%s)\
`Keyword:`\
`d`

```{=mediawiki}
{{Note|Older versions use "Location" instead of "URL".}}
```
Searches are performed by pre-pending the search term with the keyword of the specified search engine:
`{{ic|d archwiki}}`{=mediawiki} will query DuckDuckGo using the search term `{{ic|archwiki}}`{=mediawiki}

Search engines may also be added to Firefox through add-on extensions; see [this
page](https://addons.mozilla.org/firefox/search-tools/) for a list of available search tools and engines.

A very extensive list of search engines can be found at the [Mycroft Project](https://mycroftproject.com/).

#### firefox-extension-arch-search {#firefox_extension_arch_search}

[Install](Install "wikilink") the `{{AUR|firefox-extension-arch-search}}`{=mediawiki} package to add Arch-specific
searches (AUR, wiki, forum, packages, etc) to the Firefox search toolbar.

## Configuration

Firefox exposes a number of configuration options. To examine them, enter in the Firefox address bar:

[`about:config`](about:config)

Once set, these affect the user\'s current profile, and may be synchronized across all devices via [Firefox
Sync](https://www.mozilla.org/firefox/sync/). Please note that only a subset of the `{{ic|about:config}}`{=mediawiki}
entries are synchronized by this method, and the exact subset may be found by searching for
`{{ic|services.sync.prefs}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}. Additional preferences and third party
preferences may be synchronized by creating new boolean entries prepending the value with
[services.sync.prefs.sync](https://support.mozilla.org/en-US/kb/sync-custom-preferences). To synchronize the whitelist
for the extension [NoScript](https://addons.mozilla.org/firefox/addon/noscript/):

`services.sync.prefs.sync.capability.policy.maonoscript.sites`

The boolean `{{ic|noscript.sync.enabled}}`{=mediawiki} must be set to `{{ic|true}}`{=mediawiki} to synchronize the
remainder of NoScript\'s preferences via Firefox Sync.

```{=mediawiki}
{{Tip|For a complete guide over how to properly set options within {{ic|about:config}}, see the [https://support.mozilla.org/en-US/kb/about-config-editor-firefox Configuration Editor for Firefox].}}
```
### Settings storage {#settings_storage}

Firefox stores the configuration for a profile via a `{{ic|prefs.js}}`{=mediawiki} in the profile folder, usually
`{{ic|~/.mozilla/firefox/''xxxxxxxx''.default/}}`{=mediawiki}.

Firefox also allows configuration for a profile via a `{{ic|user.js}}`{=mediawiki} file:
[user.js](https://kb.mozillazine.org/User.js_file) kept also in the profile folder. A `{{ic|user.js}}`{=mediawiki}
configuration supersedes a `{{ic|prefs.js}}`{=mediawiki}. The `{{ic|user.js}}`{=mediawiki} configuration is only parsed
at start-up of a profile. Hence, you can test changes via `{{ic|about:config}}`{=mediawiki} and modify
`{{ic|user.js}}`{=mediawiki} at runtime accordingly. For a useful starting point, see e.g [custom
user.js](https://github.com/pyllyukko/user.js) which is targeted at privacy/security conscious users.

One drawback of the above approach is that it is not applied system-wide. Furthermore, this is not useful as a
\"pre-configuration\", since the profile directory is created after first launch of the browser. You can, however, let
*firefox* create a new profile and, after closing it again, [copy the
contents](https://support.mozilla.org/en-US/kb/back-and-restore-information-firefox-profiles#w_restoring-a-profile-backup)
of an already created profile folder into it.

Sometimes, it may be desired to lock certain settings, a feature useful in widespread deployments of customized Firefox.
In order to create a system-wide configuration, follow the steps outlined in [Customizing Firefox Using
AutoConfig](https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig):

1\. Create `{{ic|/usr/lib/firefox/defaults/pref/autoconfig.js}}`{=mediawiki}:

`pref("general.config.filename", "firefox.cfg");`\
`pref("general.config.obscure_value", 0);`

2\. Create `{{ic|/usr/lib/firefox/firefox.cfg}}`{=mediawiki} (this stores the actual configuration):

`//`\
`//...your settings...`\
`// e.g to disable Pocket, uncomment the following lines`\
`// lockPref("extensions.pocket.enabled", false);`\
`// lockPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);`

Please note that the first line must contain exactly `{{ic|//}}`{=mediawiki}. The syntax of the file is similar to that
of `{{ic|user.js}}`{=mediawiki}.

### Multimedia playback {#multimedia_playback}

Firefox uses [FFmpeg](FFmpeg "wikilink") for playing multimedia inside HTML5 `{{ic|<audio>}}`{=mediawiki} and
`{{ic|<video>}}`{=mediawiki} elements. Use <https://cconcolato.github.io/media-mime-support/> to test video or
<https://hpr.dogphilosophy.net/test/>`{{Dead link|2025|11|16|status=SSL error}}`{=mediawiki} to test audio, to determine
which formats are actually supported.

Firefox uses [PulseAudio](PulseAudio "wikilink") for audio playback and capture. If PulseAudio is not installed, Firefox
uses [ALSA](ALSA "wikilink") instead. Note that by default, Firefox blocks all media with sound from playing
automatically [1](https://support.mozilla.org/en-US/kb/block-autoplay).

```{=mediawiki}
{{Tip|Firefox might not play video if audio is not configured. If you are intending to use [[PipeWire]] and [[WirePlumber]], make sure they are working properly and have the necessary {{Pkg|pipewire-pulse}} compatibility layer.}}
```
#### HTML5 DRM/Widevine {#html5_drmwidevine}

Widevine is a digital rights management tool that Netflix, Amazon Prime Video, and others use to protect their video
content. It can be enabled in *Settings \> General \> Digital Rights Management (DRM) Content*. If you visit a
Widevine-enabled page when this setting is disabled, Firefox will display a prompt below the address bar asking for
permission to install DRM. Approve this and then wait for the \"Downloading\" bar to disappear; now, you are able to
watch videos from Widevine protected sites.

Firefox can only play 720p video (or lower) with Widevine, due to not using [hardware DRM
playback](https://bugzilla.mozilla.org/show_bug.cgi?id=1700815). It is also required that the private mode browsing is
disabled, for the window and in the Settings.

#### \"Open With\" extension {#open_with_extension}

1.  Install [Open With](https://addons.mozilla.org/firefox/addon/open-with/) add-on.
2.  Go to *Add-ons \> Open With \> Preferences*.
3.  Proceed with instructions to install a file in your system and test the installation.
4.  Click *Add browser*.
5.  In the dialog, write a name for this menu entry and command to start a video streaming capable player (e.g.
    `{{ic|/usr/bin/mpv}}`{=mediawiki}).
    1.  Optionally, add needed arguments to the player (e.g. you may want `{{ic|--force-window --ytdl}}`{=mediawiki} for
        [mpv](mpv "wikilink")).
6.  Right click on links or visit pages containing videos. Select newly created entry from Open With\'s menu and if the
    site is supported, the player will open as expected.

The same procedure can be used to associate video downloaders such as *youtube-dl*.

#### Hardware video acceleration {#hardware_video_acceleration}

[Hardware video acceleration](Hardware_video_acceleration "wikilink") via VA-API is available under
[Wayland](Wayland "wikilink")
[2](https://mastransky.wordpress.com/2020/06/03/firefox-on-fedora-finally-gets-va-api-on-wayland/) and
[Xorg](Xorg "wikilink") [3](https://bugzilla.mozilla.org/show_bug.cgi?id=1619523)
[4](https://www.phoronix.com/scan.php?page=news_item&px=Firefox-80-VA-API-X11).

To enable VA-API in Firefox:

1.  Ensure that your video card is correctly configured for VA-API as described in [Hardware video
    acceleration](Hardware_video_acceleration "wikilink").
2.  Ensure WebRender is enabled by navigating to `{{ic|about:support}}`{=mediawiki} and verifying the *Compositing*
    value is \"WebRender\". It is enabled by default in GNOME and other desktop environments
    [5](https://mastransky.wordpress.com/2021/01/10/firefox-were-finally-getting-hw-acceleration-on-linux/).
    -   Ensure you are not running \"Software WebRender\" as that will not work as of August 2021
        [6](https://bugzilla.mozilla.org/show_bug.cgi?id=1723540#c1).
    -   If necessary, Hardware WebRender can be force enabled by setting `{{ic|gfx.webrender.all}}`{=mediawiki} to
        `{{ic|true}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.
3.  VA-API is enabled by default for [Intel](Intel "wikilink") GPUs
    [7](https://bugzilla.mozilla.org/show_bug.cgi?id=1777430) since Firefox 115, and for [AMD](AMD "wikilink") GPUs
    [8](https://bugzilla.mozilla.org/show_bug.cgi?id=1837140) since Firefox 136. For other GPUs, set
    `{{ic|media.hardware-video-decoding.force-enabled}}`{=mediawiki} to `{{ic|true}}`{=mediawiki} in
    `{{ic|about:config}}`{=mediawiki}.
4.  Optionally, to save power on multi-GPU systems (e.g. Ryzen 7000 series with IGP and GPU) and/or take advantage of
    more video codecs supported by a IGP/GPU: run Firefox with `{{ic|MOZ_DRM_DEVICE}}`{=mediawiki} environment variable
    set to the preferred rendering device. (Available devices can be listed with `{{ic|stat /dev/dri/*}}`{=mediawiki}).

```{=mediawiki}
{{Note|1=<nowiki/>
* If hardware video acceleration is blocked with error code {{ic|FEATURE_HARDWARE_VIDEO_DECODING_DISABLE}} or {{ic|FEATURE_FAILURE_VIDEO_DECODING_TEST_FAILED}} in {{ic|about:support}}, you can override it with {{ic|media.hardware-video-decoding.force-enabled{{=}}true}}
```
. See [9](https://bbs.archlinux.org/viewtopic.php?id=281398) for more information. Alternatively, you can install
`{{AUR|firefox-vaapi}}`{=mediawiki}.

-   While NVIDIA\'s proprietary driver does not support VA-API, newer versions support DMA-BUF. Using
    `{{Pkg|libva-nvidia-driver}}`{=mediawiki} will allow for hardware video decoding on NVIDIA using
    [CUDA](CUDA "wikilink"). See the [GitHub project](https://github.com/elFarto/nvidia-vaapi-driver/#firefox) for
    documentation on necessary environment variables and <about:config> changes.
-   For NVIDIA users in addition to the config changes firefox needs to run with
    `{{ic|MOZ_DISABLE_RDD_SANDBOX}}`{=mediawiki} environment variable set 1 [nvidia-vaapi-driver
    github](https://github.com/elFarto/nvidia-vaapi-driver)
-   Currently, Firefox\'s VA-API implementation can decode H.264/AVC, H.265/HEVC, VP8 & VP9, AV1 encoded video. AV1
    support requires Firefox 98+ [10](https://bugzilla.mozilla.org/show_bug.cgi?id=1745225). H.265/HEVC support requires
    Firefox 137+ [11](https://bugzilla.mozilla.org/show_bug.cgi?id=1894818).
-   Multi-GPU systems should automatically choose a suitable GPU for VA-API according to this [solved
    issue](https://bugzilla.mozilla.org/show_bug.cgi?id=1588904#c36).
-   [AMDGPU](AMDGPU "wikilink") users under `{{Pkg|linux-hardened}}`{=mediawiki} may need to rebuild *linux-hardened*
    with `{{ic|1=CONFIG_CHECKPOINT_RESTORE=y}}`{=mediawiki} due to `{{Pkg|mesa}}`{=mediawiki} [requiring the kcmp
    syscall](https://gitweb.gentoo.org/repo/gentoo.git/tree/media-libs/mesa/mesa-9999.ebuild). This may no longer be
    necessary due to this [bug being solved](https://bugzilla.mozilla.org/show_bug.cgi?id=1624743).
-   Wayland sometimes interferes with hardware video decoding. If video briefly flickers when you go fullscreen, you may
    need to set `{{ic|1=widget.wayland.opaque-region.enabled=false}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.
-   If you are using `{{Pkg|nvidia-open}}`{=mediawiki} or `{{Pkg|nvidia-open-dkms}}`{=mediawiki},
    `{{ic|nvidia-smi}}`{=mediawiki} may show the VRAM usage by firefox is 0MB. This is normal and can be ignored. You
    can switch driver to `{{Pkg|nvidia}}`{=mediawiki} or `{{Pkg|nvidia-dkms}}`{=mediawiki} to fix it.

}}

VA-API usage can be verified by checking Firefox\'s VA-API logs. Run Firefox with the
`{{ic|1=MOZ_LOG="FFmpegVideo:5"}}`{=mediawiki} environment variable and check in the log output that VA-API is enabled
and used (search for the \"VA-API\" string) when playing a video for example. Pay attention to these logs as they might
indicate that only one of the two possible compositors described before (WebRender or OpenGL) works with VA-API on your
particular setup.

```{=mediawiki}
{{Tip|To allow hardware decoding in YouTube, the video codec used must be supported by the hardware. The profiles supported by your GPU can be checked with [[Hardware video acceleration#Verifying VA-API]] and the YouTube codecs used can ''sometimes'' (if offered by YouTube!) be controlled with the [https://addons.mozilla.org/firefox/addon/h264ify/ h264ify], [https://addons.mozilla.org/firefox/addon/enhanced-h264ify/ enhanced-h264ify], or [https://addons.mozilla.org/firefox/addon/refined-h264ify/ refined-h264ify] extensions.}}
```
### Spell checking {#spell_checking}

Firefox can use system-wide installed [Hunspell](Hunspell "wikilink") dictionaries as well as dictionaries installed
through its own extension system.

To enable spell checking for a specific language, right click on any text field and check the *Check Spelling* box. To
select a language for spell checking, you have to right click again and select your language from the *Languages*
sub-menu.

If your default language choice does not stick, see [#Firefox does not remember default spell check
language](#Firefox_does_not_remember_default_spell_check_language "wikilink").

#### System-wide Hunspell dictionaries {#system_wide_hunspell_dictionaries}

Install [Hunspell](Hunspell "wikilink") and its dictionaries for the languages you require.

#### Dictionaries as extensions {#dictionaries_as_extensions}

To get more languages, right click on any text field, click *Add Dictionaries\...* and select the dictionary you want to
install from the [Dictionaries and Language Packs list](https://addons.mozilla.org/firefox/language-tools/).

```{=mediawiki}
{{Tip|For Russian, the extension is packaged as {{Pkg|firefox-spell-ru}}.}}
```
### XDG Desktop Portal integration {#xdg_desktop_portal_integration}

Starting with version 64, Firefox can optionally use [XDG Desktop Portals](XDG_Desktop_Portal "wikilink") to handle
various desktop features, such as opening a file picker, or handling [MIME types](Default_applications "wikilink").
Using Desktop Portals allows you to, for example, customize which program is invoked to display a dialog when you select
files to upload on a webpage or when picking a download location using *Save as\...*. See [XDG Desktop Portal#List of
backends and interfaces](XDG_Desktop_Portal#List_of_backends_and_interfaces "wikilink") for a list of available backend
options.

Firefox has a number of independent settings for specifying whether each feature should be handled with a Desktop Portal
request or whether to use the default GTK feature.

Each setting can have the following values:

-   ```{=mediawiki}
    {{ic|0}}
    ```
    -- Never

-   ```{=mediawiki}
    {{ic|1}}
    ```
    -- Always

-   ```{=mediawiki}
    {{ic|2}}
    ```
    -- Auto (typically depends on whether Firefox is run from within [Flatpak](Flatpak "wikilink") or whether the
    `{{ic|1=GDK_DEBUG=portals}}`{=mediawiki} environment is set)

The settings are:

-   ```{=mediawiki}
    {{ic|widget.use-xdg-desktop-portal.file-picker}}
    ```
    -- Whether to use XDG portal for the file picker

-   ```{=mediawiki}
    {{ic|widget.use-xdg-desktop-portal.mime-handler}}
    ```
    -- Whether to use XDG portal for the mime handler

-   ```{=mediawiki}
    {{ic|widget.use-xdg-desktop-portal.settings}}
    ```
    -- Whether to try to use XDG portal for settings/look-and-feel information

-   ```{=mediawiki}
    {{ic|widget.use-xdg-desktop-portal.location}}
    ```
    -- Whether to use XDG portal for geolocation

-   ```{=mediawiki}
    {{ic|widget.use-xdg-desktop-portal.open-uri}}
    ```
    -- Whether to use XDG portal for opening to a file

### KDE integration {#kde_integration}

-   To apply KDE styles to GTK applications, including Firefox, see [KDE#GTK application
    appearance](KDE#GTK_application_appearance "wikilink").
-   To use the KDE file picker in Firefox 64 or newer, install `{{Pkg|xdg-desktop-portal}}`{=mediawiki} and
    `{{Pkg|xdg-desktop-portal-kde}}`{=mediawiki}, then set
    `{{ic|widget.use-xdg-desktop-portal.file-picker}}`{=mediawiki} to `{{ic|1}}`{=mediawiki} in
    `{{ic|about:config}}`{=mediawiki}.
-   For integration with KDE MIME type system, proxy and file dialog, one can use
    `{{AUR|firefox-kde-opensuse}}`{=mediawiki} variant from AUR with OpenSUSE's patches applied. Alternatively,
    integration with MIME types can be achieved by creating a symbolic link to the MIME database
    `{{ic|~/.config/mimeapps.list}}`{=mediawiki} from the deprecated
    `{{ic|~/.local/share/applications/mimeapps.list}}`{=mediawiki} that is used by Firefox. See [XDG MIME
    Applications#mimeapps.list](XDG_MIME_Applications#mimeapps.list "wikilink").
-   Extensions/add-ons may provide additional integration, such as:
    -   Browser integration in [Plasma](Plasma "wikilink"): requires `{{Pkg|plasma-browser-integration}}`{=mediawiki}
        and the [Plasma Integration add-on](https://addons.mozilla.org/firefox/addon/plasma-integration/).

:   

    :   ```{=mediawiki}
        {{Tip|To prevent duplicate entries in the Media Player widget or tray icon, set {{ic|media.hardwaremediakeys.enabled}} to {{ic|false}}. This disables the media entry from Firefox and only uses the one from the Plasma integration add-on.}}
        ```

### GNOME integration {#gnome_integration}

In order to use the GNOME file picker, you will need to install `{{Pkg|xdg-desktop-portal-gnome}}`{=mediawiki} and
change `{{ic|widget.use-xdg-desktop-portal.file-picker}}`{=mediawiki} from `{{ic|2}}`{=mediawiki} to
`{{ic|1}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

### Listen (text to speech) {#listen_text_to_speech}

Firefox can perform Text to Speech synthesis for web pages.

#### Setup

TTS must be setup for the *Listen* icon to appear in the Reader view. Firefox uses [Speech
dispatcher](Speech_dispatcher "wikilink") which requires a speech synthesis engine. The currently recommended speech
synthesis engine is [Festival](Festival "wikilink").

#### Usage

See the [illustrated steps](https://support.mozilla.org/en-US/kb/firefox-reader-view-clutter-free-web-pages) on
Mozilla\'s website.

The *Listen* icon (a headphones icon) will only appear if you have performed all the configuration above, Speech
Dispatcher is working, and you have started Firefox after you started the Festival server (you cannot start Firefox then
Festival).

Furthermore, sometimes a Festival server process may linger after you have tried to kill it, but will terminate after
you shut down Firefox.

For common issues, see [#Web Speech API has no voices](#Web_Speech_API_has_no_voices "wikilink") and [#Narrate/Listen
icon missing in Reader Mode](#Narrate/Listen_icon_missing_in_Reader_Mode "wikilink").

#### Using the festival-us voices {#using_the_festival_us_voices}

The voices in the package `{{Pkg|festival-us}}`{=mediawiki} provide better quality audio than those in
`{{Pkg|festival-english}}`{=mediawiki} but they do not work in Firefox. They do not appear in the list of available
voices in Firefox and when you open Reader view you will see error messages like this in the terminal output from the
Festival server:

```{=mediawiki}
{{bc| SIOD: unknown voice cmu_us_awb_cg }}
```
To fix this you need to [edit](textedit "wikilink") the following files:

-   ```{=mediawiki}
    {{ic|/usr/share/festival/voices/us/cmu_us_awb_cg/festvox/cmu_us_awb_cg.scm}}
    ```

-   ```{=mediawiki}
    {{ic|/usr/share/festival/voices/us/cmu_us_rms_cg/festvox/cmu_us_rms_cg.scm}}
    ```

-   ```{=mediawiki}
    {{ic|/usr/share/festival/voices/us/cmu_us_slt_cg/festvox/cmu_us_slt_cg.scm}}
    ```

For each of these files you need to add some code to the second last line of code of each file, eg for
`{{ic|cmu_us_awb_cg.scm}}`{=mediawiki} add code before this line: `{{bc|(provide 'cmu_us_awb_cg)}}`{=mediawiki}

The code you need to add to `{{ic|cmu_us_awb_cg.scm}}`{=mediawiki} is below. You will need to change the voice name,
gender, dialect and description as appropriate for the other two files. `{{bc|
(proclaim_voice
 'cmu_us_awb_cg
 '((language english)
   (gender male)
   (dialect scottish)
   (description "This voice is Scottish")))
}}`{=mediawiki}

```{=mediawiki}
{{Note|To avoid re-doing those changes every time {{Pkg|festival-us}} is upgraded, see [[pacman#Skip file from being upgraded]].}}
```
## Tips and tricks {#tips_and_tricks}

For general enhancements, see [Firefox/Tweaks](Firefox/Tweaks "wikilink"), and for privacy related enhancements, see
[Firefox/Privacy](Firefox/Privacy "wikilink").

### Dark themes {#dark_themes}

Firefox should respect your GTK theme settings and your OS-wide dark appearance settings (as in the Appearance section
of GNOME\'s settings or KDE system settings). If the latter does not work, make sure to have a suitable
`{{Pkg|xdg-desktop-portal}}`{=mediawiki} package installed.

Starting with Firefox 68, you can make all the Firefox interfaces and even other websites respect dark themes,
irrespective of the system GTK theme and Firefox theme. To do this, set `{{ic|ui.systemUsesDarkTheme}}`{=mediawiki} to
`{{ic|1}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}
[12](https://bugzilla.mozilla.org/show_bug.cgi?id=1488384#c23).

As of Firefox 100, further control of the dark theme of web pages that opt-in (using the CSS media query
[prefers-color-scheme](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme)) and Firefox\'s own
in-content pages is possible with `{{ic|layout.css.prefers-color-scheme.content-override}}`{=mediawiki}. Setting this to
`{{ic|3}}`{=mediawiki} will follow the browser theme, setting this to `{{ic|2}}`{=mediawiki} will follow the system wide
dark-mode preference (`{{ic|ui.systemUsesDarkTheme}}`{=mediawiki} as above, which defaults to `{{ic|0}}`{=mediawiki} if
the user has not changed the dark-mode preference or if a system does not support a system-wide dark-mode preference),
while `{{ic|1}}`{=mediawiki} and `{{ic|0}}`{=mediawiki} will always force light-mode and dark-mode respectively. This
setting can also be accessed through the user settings of Firefox under *General \> Language and Appearance \> Website
appearance*.

### Frame rate {#frame_rate}

If Firefox is unable to automatically detect the right value, it will default to 60 fps. To manually correct this, set
`{{ic|layout.frame_rate}}`{=mediawiki} to the refresh rate of your monitor (e.g. 144 for 144 Hz).

### Memory limit {#memory_limit}

To prevent pages from abusing memory (and possible [OOM](Wikipedia:Out_of_memory "wikilink")), we can use
[Firejail](Firejail "wikilink") with the `{{ic|rlimit-as}}`{=mediawiki} option.

### New tabs position {#new_tabs_position}

To control where new tabs appears (relative or absolute), use `{{ic|browser.tabs.insertAfterCurrent}}`{=mediawiki} and
`{{ic|browser.tabs.insertRelatedAfterCurrent}}`{=mediawiki}. See [13](https://support.mozilla.org/en/questions/1229062)
for more information.

### Screenshot of webpage {#screenshot_of_webpage}

You can *Take a Screenshot* by either using the screenshots button that can be added to the toolbar from the customize
screen in the Hamburger menu at *More tools \> Customize toolbar*, by pressing `{{ic|Ctrl+Shift+s}}`{=mediawiki} or by
right-clicking on the webpage. See [Firefox screenshots](https://support.mozilla.org/en-US/kb/firefox-screenshots) for
more information, including on the telemetry data collection.

You can also use the screenshot button in the developer tools, which can be added through the developer tools *Settings*
menu, under the *Available Toolbox Buttons* section. The settings for the developer tools are accessible through the
three horizontal dots located at the top right of the developer tools pane.

### Xwayland

Starting with version 121, Firefox defaults to [Wayland](Wayland "wikilink") instead of XWayland and does not require
any configuration.

You can force [Xwayland](Xwayland "wikilink") mode via an [environment variable](environment_variable "wikilink").

`$ MOZ_ENABLE_WAYLAND=0 firefox`

To make this permanent, see [Environment variables#Graphical
environment](Environment_variables#Graphical_environment "wikilink") and start Firefox via the desktop launcher like you
normally would.

To verify that it worked, look for *Window Protocol* in `{{ic|about:support}}`{=mediawiki}. The presence of
`{{ic|x11}}`{=mediawiki} means you are running Firefox under [Xorg](Xorg "wikilink") display server, while
`{{ic|xwayland}}`{=mediawiki} means your system is running Wayland but executing Firefox as legacy X11 application.

### Window manager rules {#window_manager_rules}

You can change how your window manager groups Firefox windows using CLI options.

#### Xorg

Under [Xorg](Xorg "wikilink"), windows are grouped by their `{{ic|WM_CLASS}}`{=mediawiki} string. Set a custom value
using Firefox\'s `{{ic|--class}}`{=mediawiki} option, then update the `{{ic|StartupWMClass}}`{=mediawiki} field in the
[desktop entry](desktop_entry "wikilink") to the same value.

```{=mediawiki}
{{hc|~/.local/share/applications/firefox.desktop|2=
[Desktop Entry]
Exec=/usr/lib/firefox/firefox --class=''class-name'' %u
StartupWMClass=''class-name''
# other fields omitted"
}}
```
#### Wayland

Under [Wayland](Wayland "wikilink"), windows are grouped by their `{{ic|resourceClass}}`{=mediawiki} attribute. To set a
custom value, use Firefox\'s `{{ic|--name}}`{=mediawiki} option instead; `{{ic|WM_CLASS}}`{=mediawiki} appears to have
no effect.

On some [desktop environments](desktop_environments "wikilink") (e.g. [KDE](KDE "wikilink"); others untested), you also
have to make sure that the [desktop entry](desktop_entry "wikilink") has the same file stem as your custom
`{{ic|resourceClass}}`{=mediawiki} value if you are pinning Firefox to the task manager. This way the launched instance
of Firefox will be grouped with the pinned entry.

```{=mediawiki}
{{hc|~/.local/share/applications/''class-name''.desktop|2=
[Desktop Entry]
Exec=/usr/lib/firefox/firefox --name=''class-name'' %u
# other fields omitted"
}}
```
### Profiles

To start new Firefox instances, multiple profiles are required. To create a new profile:

`$ firefox [--new-instance] -P`

You can use profiles together with [#Window manager rules](#Window_manager_rules "wikilink") to group windows of each
profile separately.

[Firefox Profilemaker](https://ffprofile.com/) can be used to create a Firefox profile with the defaults you like.

### Touchscreen gestures and pixel-perfect trackpad scrolling {#touchscreen_gestures_and_pixel_perfect_trackpad_scrolling}

See [Firefox/Tweaks#Pixel-perfect trackpad scrolling](Firefox/Tweaks#Pixel-perfect_trackpad_scrolling "wikilink"),
[Firefox/Tweaks#Enable touchscreen gestures](Firefox/Tweaks#Enable_touchscreen_gestures "wikilink") and
[Firefox/Tweaks#Smooth scrolling](Firefox/Tweaks#Smooth_scrolling "wikilink").

### Multiple home pages {#multiple_home_pages}

To have multiple tabs opened when starting Firefox, open a new window and then open the sites you want to have as \"home
tabs\".

Now go to *Settings \> Home* and under *Homepage and new windows* click the *Use Current Pages* button.

Alternatively, go directly to *Settings \> Home* and now under *Homepage and new windows* set the first field to *Custom
URLs..* and enter the pages you want as new home pages in the following format:

`https://url1.com|https://url2.com|https://url3.com`

### View two pages side by side in the PDF viewer {#view_two_pages_side_by_side_in_the_pdf_viewer}

To display two pages at once with the integrated PDF viewer, set `{{ic|pdfjs.spreadModeOnLoad}}`{=mediawiki} to
`{{ic|1}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

### Kiosk mode {#kiosk_mode}

Firefox supports kiosk mode that shows pages in full screen without browser chrome, context menus, and other features
useful for typical desktop browsing. These can be seen on ATMs or information panels where users are not expected to
interact with the rest of the system.

To use kiosk mode, start Firefox with:

`$ firefox --kiosk `*`url`*

The startup page can be configured in the settings or supplied as a command-line parameter.

If you need printing, you can prevent Firefox from showing paper size configuration dialogs with:

`$ firefox --kiosk --kiosk-printing `*`url`*

### Compact mode {#compact_mode}

Starting with Firefox version 89, the compact mode density option was removed from the Customize panel
[14](https://support.mozilla.org/en-US/kb/compact-mode-workaround-firefox), but you can still use compact density. To do
this, set `{{ic|browser.uidensity}}`{=mediawiki} to `{{ic|1}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

The UI can be scaled down even further, see [Firefox/Tweaks#Configure the DPI
value](Firefox/Tweaks#Configure_the_DPI_value "wikilink") but use values between 0 and 1 instead.

### GNOME search provider {#gnome_search_provider}

Firefox includes a search provider for GNOME Shell which exposes Firefox bookmarks and history to GNOME Shell search
while Firefox is running. However, this provider is disabled by default; to enable it go to
`{{ic|about:config}}`{=mediawiki} and set `{{ic|browser.gnome-search-provider.enabled}}`{=mediawiki} to
`{{ic|true}}`{=mediawiki}.

### Custom date and time format in Library window {#custom_date_and_time_format_in_library_window}

The date and time format used in the *Library* window (the window showing bookmarks, history and downloads, accessible
via `{{ic|Ctrl+Shift+o}}`{=mediawiki} and `{{ic|Ctrl+Shift+h}}`{=mediawiki}) can be customized by setting
`{{ic|intl.date_time.pattern_override.date_short}}`{=mediawiki},
`{{ic|intl.date_time.pattern_override.time_short}}`{=mediawiki}, and
`{{ic|intl.date_time.pattern_override.connector_short}}`{=mediawiki} in `{{ic|user.js}}`{=mediawiki} or
`{{ic|about:config}}`{=mediawiki}. For example, to get a format similar to [RFC:3339](RFC:3339 "wikilink") (\"2022-12-31
22:49\"), set the three preferences to `{{ic|yyyy-MM-dd}}`{=mediawiki}, `{{ic|HH:mm}}`{=mediawiki}, and
`{{ic|{1} {0} }}`{=mediawiki}, respectively.

Setting the `{{ic|LC_TIME}}`{=mediawiki} environment variable to `{{ic|en_DK.UTF-8}}`{=mediawiki} only worked in old
Firefox versions (perhaps 57 and earlier). Mozilla\'s [bug report
1426907](https://bugzilla.mozilla.org/show_bug.cgi?id=1426907) contains further information.

### Disable the Ctrl+q keybinding for shutting down Firefox {#disable_the_ctrlq_keybinding_for_shutting_down_firefox}

Create and set the option `{{ic|browser.quitShortcut.disabled}}`{=mediawiki} to `{{ic|true}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}.

### Enable hybrid post-quantum key exchange {#enable_hybrid_post_quantum_key_exchange}

Firefox supports [X25519Kyber768](https://www.ietf.org/archive/id/draft-tls-westerbaan-xyber768d00-02.html), a hybrid
post-quantum key exchange for TLS 1.3. Since Firefox 132.0, it is enabled by default. To test that it is working you can
visit [this Cloudflare Research test page](https://pq.cloudflareresearch.com), which will tell you whether you are using
a PQ-safe key exchange.

### Disable cursor blinking {#disable_cursor_blinking}

By default, Firefox enables cursor blinking. To stop the cursor from blinking, set
`{{ic|ui.caretBlinkTime}}`{=mediawiki} to `{{ic|0}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}
[15](https://support.mozilla.org/en-US/questions/943469).

### Share NSS DB with Chromium {#share_nss_db_with_chromium}

By default, Chromium reads the NSS Shared DB at `{{ic|~/.pki/nssdb}}`{=mediawiki}. Firefox puts the NSS DB in the
profile directory, `{{ic|cert9.db}}`{=mediawiki} and `{{ic|key4.db}}`{=mediawiki}.

To make Firefox use the NSS Shared DB, add `{{ic|libnsssysinit.so}}`{=mediawiki}, `{{ic|moduleDBOnly,}}`{=mediawiki},
and change `{{ic|configdir{{=}}`{=mediawiki}}} [16](https://blog.xelnor.net/firefox-systemcerts/). For example, **bold**
below indicates the changes. You should leave the surrounding options intact if they differ from the below example.
`{{hc|~/.mozilla/''YOUR_PROFILE_DIRECTORY''/pkcs11.txt|<nowiki>
library=</nowiki>'''libnsssysinit.so'''<nowiki>
name=NSS Internal PKCS #11 Module
parameters=configdir='sql:</nowiki>'''/home/''YOUR_USER''/.pki/nssdb'''<nowiki>' certPrefix='' keyPrefix='' secmod='secmod.db' flags= updatedir='' updateCertPrefix='' updateKeyPrefix='' updateid='' updateTokenDescription=''
NSS=Flags=</nowiki>'''moduleDBOnly,'''<nowiki>internal,critical trustOrder=75 cipherOrder=100 slotParams=(1={slotFlags=[ECC,RSA,DSA,DH,RC2,RC4,DES,RANDOM,SHA1,MD5,MD2,SSL,TLS,AES,Camellia,SEED,SHA256,SHA512] askpw=any timeout=30})
</nowiki>}}`{=mediawiki}

You may wish to copy the database files from your Firefox profile directory to `{{ic|~/.pki/nssdb}}`{=mediawiki}, if you
have custom certificates in them.

## Troubleshooting

### Troubleshoot Mode {#troubleshoot_mode}

The command line switch `{{ic|-safe-mode}}`{=mediawiki} starts Firefox in [Troubleshoot
Mode](https://support.mozilla.org/en-US/kb/diagnose-firefox-issues-using-troubleshoot-mode), which disables extensions,
themes, hardware acceleration, the JIT and some other features for this session.

This mode can also be enabled by pressing on the hamburger menu while Firefox is open, clicking *Help*, selecting
*Troubleshoot Mode* and confirming this on the modal dialog that appears. Please note this will require a browser
restart.

This mode was previously named Safe Mode until Firefox 88.

### Firefox refresh {#firefox_refresh}

Some issues experienced by users in Firefox may be caused by profile issues, such as corruption.

If you have ruled out other causes, it may be worth trying a new Firefox profile for testing purposes to see if this
will resolve your issue. More information on how to create a new profile and switch between profiles can be found on the
[Firefox support page](https://support.mozilla.org/en-US/kb/profile-manager-create-remove-switch-firefox-profiles).

If this resolves your issue, you should switch back to your original profile and consider refreshing your Firefox.

Refreshing your profile will retain all browsing and download history, bookmarks, web form auto-fill data, cookies,
personal dictionary and passwords, and will transfer them to a brand new profile without extensions, themes, extension
data and preferences, among other data. A backup of your old profile will also be retained.

To refresh your profile, navigate to `{{ic|about:support}}`{=mediawiki}, press *Refresh Firefox* and confirm this on the
modal dialog that appears. `{{ic|about:support}}`{=mediawiki} can also be accessed by pressing the Hamburger menu,
selecting *Help* and then clicking *More troubleshooting information*.

More information on refreshing your Firefox, including further details about what is transferred to the new profile, can
be found on the [Firefox support page](https://support.mozilla.org/en-US/kb/refresh-firefox-reset-add-ons-and-settings).

### Hardware video acceleration issues {#hardware_video_acceleration_issues}

If you are having issues with hardware video acceleration in Firefox, e.g. in case of freezes or graphical corruption,
start Firefox in [Troubleshoot Mode](#Troubleshoot_Mode "wikilink") for testing purposes to confirm that this is the
issue. If this step resolves the issue, merely set `{{ic|media.ffmpeg.vaapi.enabled}}`{=mediawiki} to
`{{ic|false}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki} to disable hardware video acceleration, and restart
Firefox.

### Extension X does not work on some Mozilla owned domains {#extension_x_does_not_work_on_some_mozilla_owned_domains}

By default, extensions will not affect pages designated by
`{{ic|extensions.webextensions.restrictedDomains}}`{=mediawiki}. If this is not desired, this field can be cleared
(special pages such as `{{ic|about:*}}`{=mediawiki} will not be affected). Then create and set
`{{ic|privacy.resistFingerprinting.block_mozAddonManager}}`{=mediawiki} to true.

### Firefox startup takes very long {#firefox_startup_takes_very_long}

If Firefox takes much longer to start up than other browsers, it may be due to lacking configuration of the localhost in
`{{ic|/etc/hosts}}`{=mediawiki}. See [Network configuration#Local network hostname
resolution](Network_configuration#Local_network_hostname_resolution "wikilink") on how to set it up.

Misbehaving Firefox extensions, or too many extensions, may be another source of slow startup. This can be confirmed
through the use of [Troubleshoot Mode](#Troubleshoot_Mode "wikilink"), which will disable extensions on restart.

A further cause of slow start-up may be a profile issue, such as corruption. For more troubleshooting steps around your
Firefox profile, see [#Firefox refresh](#Firefox_refresh "wikilink").

### Font troubleshooting {#font_troubleshooting}

See [Font configuration](Font_configuration "wikilink").

Firefox has a setting which determines how many replacements it will allow from Fontconfig. To allow it to use all your
replacement rules, change `{{ic|gfx.font_rendering.fontconfig.max_generic_substitutions}}`{=mediawiki} to
`{{ic|127}}`{=mediawiki} (the highest possible value).

Firefox ships with the *Twemoji Mozilla* font. To use the system emoji font, set
`{{ic|font.name-list.emoji}}`{=mediawiki} to `{{ic|emoji}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.
Additionally, to prevent the Mozilla font interfering with your system emoji font, change
`{{ic|gfx.font_rendering.opentype_svg.enabled}}`{=mediawiki} to `{{ic|false}}`{=mediawiki} or remove
`{{ic|/usr/lib/firefox/fonts/TwemojiMozilla.ttf}}`{=mediawiki} (see also [pacman#Skip files from being installed to
system](pacman#Skip_files_from_being_installed_to_system "wikilink")).

### Setting an email client {#setting_an_email_client}

Inside the browser, `{{ic|mailto}}`{=mediawiki} links by default are opened by a web application such as Gmail or Yahoo
Mail. To set an external email program, go to *Settings \> General \> Applications* and modify the *action*
corresponding to the `{{ic|mailto}}`{=mediawiki} content type; the file path will need to be designated (e.g.
`{{ic|/usr/bin/kmail}}`{=mediawiki} for Kmail).

Outside the browser, `{{ic|mailto}}`{=mediawiki} links are handled by the `{{ic|x-scheme-handler/mailto}}`{=mediawiki}
mime type, which can be easily configured with [xdg-mime](xdg-mime "wikilink"). See [Default
applications](Default_applications "wikilink") for details and alternatives.

### File association {#file_association}

See [Default applications](Default_applications "wikilink").

### Firefox keeps creating \~/Desktop even when this is not desired {#firefox_keeps_creating_desktop_even_when_this_is_not_desired}

Firefox uses `{{ic|~/Desktop}}`{=mediawiki} as the default place for download and upload files. To change it to another
folder, set the `{{ic|XDG_DESKTOP_DIR}}`{=mediawiki} option as explained in [XDG user
directories](XDG_user_directories "wikilink").

### My downloads directory is full of files I do not remember saving {#my_downloads_directory_is_full_of_files_i_do_not_remember_saving}

In Firefox version 98, the behavior of opening files in external programs was silently changed. Instead of downloading
them into `{{ic|/tmp}}`{=mediawiki} and giving that file location to the child process, Firefox now downloads the file
as if you had chosen to *save it*, and then gives the child process the location of the file in your downloads
directory. As a result, your downloads will be littered with files you only ever intended to open for viewing. This
happens both when you select a program to use to open the file in a dialog and for file types you have configured to
automatically open in a specific program. Notably this also happens for some file types that are opened internally in
Firefox (such as PDF documents if the in-browser **PDF.js** viewer is enabled).

Due to an oversight, the dialog prompting you for what to do with the file still describes the old choices (either open
*or* save) while it is in reality always going to save the file. Since this behavior could realistically pose a security
and privacy risk to certain users who expect the files to not be saved to disk, you might want to disable the new
behavior.

To do this, create and set `{{ic|browser.download.start_downloads_in_tmp_dir}}`{=mediawiki} to `{{ic|true}}`{=mediawiki}
in `{{ic|about:config}}`{=mediawiki}.

Alternatively, to prevent Firefox from automatically saving PDFs into the downloads directory while opening them in the
in-browser viewer, set `{{ic|browser.download.open_pdf_attachments_inline}}`{=mediawiki} to `{{ic|true}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}.

```{=mediawiki}
{{Note|While the name of the option sounds as though it would only cache files in {{ic|/tmp}} while downloading them and then move them elsewhere, Mozilla has [https://www.mozilla.org/en-US/firefox/102.0a1/releasenotes/ confirmed] that this actually does restore the old behavior:
: There is now an enterprise policy ({{ic|StartDownloadsInTempDirectory}}) and an {{ic|about:config}} pref ({{ic|browser.download.start_downloads_in_tmp_dir}}) that will once again cause Firefox to initially put downloads in (a subfolder of) the OS temp folder, instead of the download folder configured in Firefox. Files opened from the "what should Firefox do with this file" dialog, or set to open in helper applications automatically, will stay in this folder. Files saved (not opened as previously mentioned) will still end up in the Firefox download folder.}}
```
#### Additional settings to consider {#additional_settings_to_consider}

-   ```{=mediawiki}
    {{ic|browser.download.forbid_open_with}}
    ```
    : `{{ic|true}}`{=mediawiki} (only ask whether to save or cancel in the file saving dialog, never ask to open with
    another program)

-   ```{=mediawiki}
    {{ic|browser.download.always_ask_before_handling_new_types}}
    ```
    : `{{ic|true}}`{=mediawiki} (same as *Settings \> General \> Files and Applications \> What should Firefox do with
    other files? \> Ask whether to open or save files*).

-   Set all known file types in *Settings \> General \> Files and Applications* to *Always ask*, with the possible
    exception of the ones set to be opened by Firefox itself.

#### Locate and change Firefox Cache storage location {#locate_and_change_firefox_cache_storage_location}

Create `{{ic|browser.cache.disk.parent_directory}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki} and set it\'s
*string* value to the desired location, for example to `{{ic|/tmp/}}`{=mediawiki} or `{{ic|/dev/shm/}}`{=mediawiki}

### Changes to userChrome.css and userContent.css are ignored {#changes_to_userchrome.css_and_usercontent.css_are_ignored}

Set `{{ic|toolkit.legacyUserProfileCustomizations.stylesheets}}`{=mediawiki} to `{{ic|true}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}

### Middle-click behavior {#middle_click_behavior}

To autoscroll on middle-click (default for Windows browsers), you have two ways to enable this feature:

-   Go to *Settings \> General*, look for the *Browsing* section and enable *Use autoscrolling* option.

```{=html}
<!-- -->
```
-   Alternatively, set `{{ic|general.autoScroll}}`{=mediawiki} to `{{ic|true}}`{=mediawiki} in
    `{{ic|about:config}}`{=mediawiki}.

To disable pasting from the clipboard ([PRIMARY selection](Clipboard#Selections "wikilink")) when the middle mouse
button is clicked, set `{{ic|middlemouse.paste}}`{=mediawiki} to `{{ic|false}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}.

To load the contents of the clipboard as a URL when the middle mouse button is clicked,
`{{ic|middlemouse.contentLoadURL}}`{=mediawiki} to `{{ic|true}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}. This
was the default behaviour prior to Firefox 57.

### Backspace does not work as the \'Back\' button {#backspace_does_not_work_as_the_back_button}

According to [MozillaZine](https://kb.mozillazine.org/Browser.backspace_action), the `{{ic|Backspace}}`{=mediawiki} key
was mapped based on which platform the browser was running on. As a compromise, this preference was created to allow the
`{{ic|Backspace}}`{=mediawiki} key to either go back/forward, scroll up/down a page, or do nothing.

To make `{{ic|Backspace}}`{=mediawiki} go back one page in the tab\'s history and `{{ic|Shift+Backspace}}`{=mediawiki}
go forward, set `{{ic|browser.backspace_action}}`{=mediawiki} to `{{ic|0}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}.

To have the `{{ic|Backspace}}`{=mediawiki} key scroll up one page and `{{ic|Shift+Backspace}}`{=mediawiki} scroll down
one page, set `{{ic|browser.backspace_action}}`{=mediawiki} to `{{ic|1}}`{=mediawiki}. Setting this property to any
other value will leave the key unmapped (Arch Linux defaults to `{{ic|2}}`{=mediawiki}; in other words, it is unmapped
by default).

### Firefox does not remember login information {#firefox_does_not_remember_login_information}

It may be due to a corrupted `{{ic|cookies.sqlite}}`{=mediawiki} file in [Firefox\'s
profile](https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data) folder. In order to fix this,
just rename or remove `{{ic|cookie.sqlite}}`{=mediawiki} while Firefox is not running.

Open a terminal of choice and type the following:

`$ rm -f ~/.mozilla/firefox/``<profile id>`{=html}`.default/cookies.sqlite`

The profile id is a random 8 character string.

Restart Firefox and see if it solved the problem.

If it did not work, check if there exists a `{{ic|cookies.sqlite.bak}}`{=mediawiki} file that you could use to manually
restore the cookies.

### Cannot enter/leave fullscreen {#cannot_enterleave_fullscreen}

If Firefox detects an [EWMH/ICCCM](https://specifications.freedesktop.org/wm-spec/latest/) compliant window manager, it
will try to send a WM_STATE message to the root window to request Firefox be made to enter (or leave) full-screen mode
(as defined by the window manager). Window managers are allowed to ignore it, but if they do, Firefox will assume the
request got denied and propagate it to the end user which results in nothing happening. This may result in not being
able to full screen a video. A general workaround is to set the `{{ic|full-screen-api.ignore-widgets}}`{=mediawiki} to
`{{ic|true}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

Related bug reports: [Bugzilla 1189622](https://bugzilla.mozilla.org/show_bug.cgi?id=1189622).

### Scrollbar is not hidden/disabled when YouTube is fullscreen {#scrollbar_is_not_hiddendisabled_when_youtube_is_fullscreen}

```{=mediawiki}
{{Accuracy|This is not supposed to happen. Adding a uBlock Origin filter is a hacky workaround something that sounds like a bug (or perhaps another extension meddling with things).}}
```
This can be fixed using a [uBlock Origin](https://ublockorigin.com/) filter. To add a filter, click the *uBlock Origin
extension icon \> Three cogwheels (Open the dashboard) \> My Filters*. Then, add the following to the text field:

`www.youtube.com##ytd-app:style(overflow: hidden !important;)`

After applying the changes and reloading the YouTube window, the filter will take effect. Note that you have to have
cosmetic filtering enabled for this to work (the middle icon with the eye).

### JavaScript context menu does not appear on some sites {#javascript_context_menu_does_not_appear_on_some_sites}

You can try setting `{{ic|dom.w3c_touch_events.enabled}}`{=mediawiki} to `{{ic|0}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}.

### Firefox does not remember default spell check language {#firefox_does_not_remember_default_spell_check_language}

The default spell checking language can be set as follows:

1.  Type `{{ic|about:config}}`{=mediawiki} in the address bar.
2.  Set `{{ic|spellchecker.dictionary}}`{=mediawiki} to your language of choice, for instance
    `{{ic|en_GB}}`{=mediawiki}.
3.  Notice that the for dictionaries installed as a Firefox plugin the notation is `{{ic|en-GB}}`{=mediawiki}, and for
    `{{Pkg|hunspell}}`{=mediawiki} dictionaries the notation is `{{ic|en_GB}}`{=mediawiki}.

When you only have system wide dictionaries installed with `{{Pkg|hunspell}}`{=mediawiki}, Firefox might not remember
your default dictionary language settings. This can be fixed by having at least one
[dictionary](https://addons.mozilla.org/firefox/language-tools/) installed as a Firefox plugin. Notice that now you will
also have a tab *Dictionaries* in *Add-ons*. You may have to change the order of *preferred language for displaying
pages* in `{{ic|about:preferences#general}}`{=mediawiki} to make the spell check default to the language of the addon
dictionary.

Related questions on the **StackExchange** platform:
[17](https://stackoverflow.com/questions/26936792/change-firefox-spell-check-default-language/29446115),
[18](https://stackoverflow.com/questions/21542515/change-default-language-on-firefox/29446353),
[19](https://askubuntu.com/questions/184300/how-can-i-change-firefoxs-default-dictionary/576877)

Related bug reports: [Bugzilla 776028](https://bugzilla.mozilla.org/show_bug.cgi?id=776028), [Ubuntu bug
1026869](https://bugs.launchpad.net/ubuntu/+source/firefox/+bug/1026869)

### Firefox does not find system-wide Hunspell spell checking dictionaries {#firefox_does_not_find_system_wide_hunspell_spell_checking_dictionaries}

Ensure that the setting `{{ic|spellchecker.dictionary_path}}`{=mediawiki} exists and is set to the path of the system\'s
Hunspell dictionaries: `{{ic|/usr/share/hunspell}}`{=mediawiki}.

### Some MathML symbols are missing {#some_mathml_symbols_are_missing}

You need some Math fonts, namely Latin Modern Math and STIX (see this MDN page:
[20](https://developer.mozilla.org/en-US/docs/Mozilla/MathML_Project/Fonts#Linux)), to display MathML correctly.

In Arch Linux, these fonts are provided by `{{Pkg|texlive-fontsextra}}`{=mediawiki}, but they are not available to
fontconfig by default. See [TeX Live#Making fonts available to
Fontconfig](TeX_Live#Making_fonts_available_to_Fontconfig "wikilink") for details. You can also try other [Math
fonts](Fonts#Math "wikilink"). In case you encounter this bug
[21](https://bugzilla.mozilla.org/show_bug.cgi?id=1208776), installing `{{Pkg|otf-latinmodern-math}}`{=mediawiki} can
help.

### Videos load but do not play {#videos_load_but_do_not_play}

This may be a PulseAudio issue. See the suggested fix in [PulseAudio/Troubleshooting#Browsers (firefox) load videos but
do no play](PulseAudio/Troubleshooting#Browsers_(firefox)_load_videos_but_do_no_play "wikilink").

### Tearing when scrolling {#tearing_when_scrolling}

Try disabling smooth scrolling in *Settings \> General \> Browsing*. Note that the pages will scroll jerkily.
Furthermore, in `{{Ic|about:config}}`{=mediawiki} setting `{{Ic|layout.frame_rate}}`{=mediawiki} to different values
(i.e. 0 or 1) can also improve scrolling smoothness.

### Firefox WebRTC module cannot detect a microphone {#firefox_webrtc_module_cannot_detect_a_microphone}

WebRTC applications for instance [Firefox WebRTC getUserMedia test
page](https://mozilla.github.io/webrtc-landing/gum_test.html) say that microphone cannot be found. Issue is reproducible
for both ALSA or PulseAudio setup. Firefox debug logs show the following error:

```{=mediawiki}
{{hc|1=$ NSPR_LOG_MODULES=MediaManager:5,GetUserMedia:5 firefox|2=
...
[Unnamed thread 0x7fd7c0654340]: D/GetUserMedia  VoEHardware:GetRecordingDeviceName: Failed 1
}}
```
You can try setting `{{ic|media.navigator.audio.full_duplex}}`{=mediawiki} property to `{{ic|false}}`{=mediawiki} at
`{{ic|about:config}}`{=mediawiki} Firefox page and restart Firefox.

This can also help if you are using the PulseAudio
[module-echo-cancel](PulseAudio#Microphone_echo/noise_cancellation "wikilink") and Firefox does not recognise the
virtual echo canceling source.

### WebRTC sharing indicator displays an XML parsing error {#webrtc_sharing_indicator_displays_an_xml_parsing_error}

After agreeing to share a microphone or web camera, you may then see a window with a tan background and a red border in
the top left corner on your primary window, displaying the following error message:

`XML Parsing Error: no root element found`\
`Location: `[`chrome://browser/content/webrtcLegacyIndicator.xhtml`](chrome://browser/content/webrtcLegacyIndicator.xhtml)\
`Line Number: 1, Column 1:`\
`^`

If this is the case for you, performing the following steps should resolve the issue:

1.  Navigate to `{{ic|about:support}}`{=mediawiki}.
2.  Click on the *Clear Startup Cache* button and agree to restart the browser.

See [Mozilla\'s bug report](https://bugzilla.mozilla.org/show_bug.cgi?id=1639821) for more information.

### Google meet {#google_meet}

When using screen sharing in Google Meet, you might notice choppy visuals and overall laggy video. A possible fix is to
change your browser's user agent to Google Chrome. You can do this with the [User agent
switcher](https://addons.mozilla.org/firefox/addon/uaswitcher/) extension.

### Cannot login with my Chinese account {#cannot_login_with_my_chinese_account}

Firefox provides a local service for Chinese users, with a local account totally different from the international one.
Firefox installed with the `{{Pkg|firefox}}`{=mediawiki} package uses the international account system by default, to
change into the Chinese local service, you should install the add-on manager on [this
page](http://mozilla.com.cn/thread-343905-1-1.html)`{{Dead link|2025|11|16|status=domain name not resolved}}`{=mediawiki},
then you can login with your Chinese account now.

### No audio on certain videos when using JACK and PulseAudio {#no_audio_on_certain_videos_when_using_jack_and_pulseaudio}

If you are using JACK in combination with PulseAudio and cannot hear any sound on some videos, it could be because those
videos have mono audio. This happens if your JACK setup uses more than just stereo, but you use normal headphones. To
fix this, you simply have to connect the `{{ic|front-center}}`{=mediawiki} port from the PulseAudio JACK Sink to both
`{{ic|playback_1}}`{=mediawiki} and `{{ic|playback_2}}`{=mediawiki} ports of the system output.

You can also do this automatically using a script:

```{=mediawiki}
{{hc|jack-mono.sh
|2=#!/bin/sh
jack_connect "PulseAudio JACK Sink:front-center" "system:playback_1"
jack_connect "PulseAudio JACK Sink:front-center" "system:playback_2"
}}
```
Keep in mind that the names for the sink and the ports might be different for you. You can check what your JACK setup
looks like with a Patchbay like Catia from `{{AUR|cadence}}`{=mediawiki}.

### Geolocation does not work {#geolocation_does_not_work}

Recently, Google limited the use of its location service with Arch Linux, which causes the following error when
geolocation is enabled on a website: `{{ic|Geolocation error: Unknown error acquiring position}}`{=mediawiki}.
Region-locked services such as [Hulu](https://www.hulu.com/) may display a similar error indicating that your location
could not be determined even though you have allowed location services for the site.

See `{{Bug|65241}}`{=mediawiki} for more details.

One work around is to navigate to `{{ic|about:config}}`{=mediawiki} and change the
`{{ic|geo.provider.network.url}}`{=mediawiki} setting to a static data value such as:

`data:application/json,{"location": {"lat": 41.8818, "lng": -87.6232}, "accuracy": 27000.0}`

Doing so will provide static coordinates for the geolocation service (in this example `{{ic|41.8818}}`{=mediawiki},
`{{ic|-87.6232}}`{=mediawiki}). The coordinates should be modified to reflect the desired location. This will allow
services such as Hulu to function properly, but will not automatically update location information when it changes.

### Right mouse button instantly clicks the first option in window managers {#right_mouse_button_instantly_clicks_the_first_option_in_window_managers}

This problem has been observed in [i3](i3 "wikilink"), [bspwm](bspwm "wikilink") and [xmonad](xmonad "wikilink").

To fix it, navigate to `{{ic|about:config}}`{=mediawiki} and change `{{ic|ui.context_menus.after_mouseup}}`{=mediawiki}
to `{{ic|true}}`{=mediawiki}.

See [22](https://www.reddit.com/r/i3wm/comments/88k0yt/right_mouse_btn_instantly_clicks_first_option_in/)

### Firefox window does not repaint after disabling or enabling compositing {#firefox_window_does_not_repaint_after_disabling_or_enabling_compositing}

Unset the environment variable `{{ic|MOZ_X11_EGL}}`{=mediawiki}.

Related bug report: [Bugzilla 1711039](https://bugzilla.mozilla.org/show_bug.cgi?id=1711039).

### Firefox continuously asks to be set as default browser upon launch {#firefox_continuously_asks_to_be_set_as_default_browser_upon_launch}

There are a couple things you can try: if you are using a [desktop environment](desktop_environment "wikilink"), check
if Firefox is set as the default browser in your system settings. If it is not, then set it, otherwise you can run the
following `{{man|1|xdg-settings}}`{=mediawiki} command, provided by the [xdg-utils](xdg-utils "wikilink") package, to
query which browser is set as default on your system:

`$ xdg-settings get default-web-browser`

If no value is returned or it is not Firefox, then run this command to set it:

`$ xdg-settings set default-web-browser firefox.desktop`

If Firefox still asks to be set as the default browser, then it may be quieted if it is set to handle *http* and *https*
URL schemes. To do so, run these `{{man|1|xdg-mime}}`{=mediawiki} commands:

`$ xdg-mime default firefox.desktop x-scheme-handler/http`\
`$ xdg-mime default firefox.desktop x-scheme-handler/https`

If those do not work either, check if you have set the environment variable `{{ic|GTK_USE_PORTAL}}`{=mediawiki} (all
values trigger the bug), in which case, unset it. Related bug report: [Bugzilla
1516290](https://bugzilla.mozilla.org/show_bug.cgi?id=1516290). If that does not work or you did not set it, navigate
Firefox to `{{ic|about:config}}`{=mediawiki}, check if the variable `{{ic|widget.use-xdg-desktop-portal}}`{=mediawiki}
is set to `{{ic|true}}`{=mediawiki} and, if so, set it to `{{ic|false}}`{=mediawiki}.

If you wish to disable default browser check entirely, navigate Firefox to `{{ic|about:config}}`{=mediawiki} and set
`{{ic|browser.shell.checkDefaultBrowser}}`{=mediawiki} to `{{ic|false}}`{=mediawiki}.

### Video stuttering {#video_stuttering}

If you experience video stuttering and you notice that Firefox is only hitting one core at 100% when watching videos
(especially higher resolution videos), this might help you.

Go into `{{ic|about:config}}`{=mediawiki} and search for `{{ic|dom.ipc.processCount}}`{=mediawiki} and change
`{{ic|dom.ipc.processCount.file}}`{=mediawiki} from 1 to a higher number. An ad hoc method to find a good number is to
increase it one at a time until you get good results, but 4 seems to be a good value.

### Bengali font broken in some pages {#bengali_font_broken_in_some_pages}

In most cases, installing the `{{Pkg|noto-fonts}}`{=mediawiki} and making **Noto Sans Bengali** as defaults in **Fonts
and Colors** settings solves it. However, in some social media sites, Bengali fonts may still be broken. In those cases,
Mozilla provides a detailed guide on how to see all the fonts gets loaded in a page. By using [Page
Inspector](https://developer.mozilla.org/en-US/docs/Tools/Page_Inspector/How_to/Open_the_Inspector), find out [all the
fonts](https://developer.mozilla.org/en-US/docs/Tools/Page_Inspector/How_to/Edit_fonts#all_fonts_on_page) that are being
loaded on that particular page. Removing fonts other than **Noto Sans** from the system will resolve the issue
permanently.

There will be some fonts that have been installed as dependency of other package. For example,
`{{Pkg|chromium}}`{=mediawiki} installs `{{Pkg|ttf-liberation}}`{=mediawiki} as dependency, which loads itself in some
Firefox pages automatically and breaks Bengali fonts on those pages. To solve this issue, use the following rule in your
[font configuration](font_configuration "wikilink"):

```{=mediawiki}
{{hc|$XDG_CONFIG_HOME/fontconfig/fonts.conf|2=
<match target="pattern">
 <test qual="any" name="family"><string>Liberation</string></test>
 <edit mode="assign" name="family" binding="same"><string>Noto Sans Bengali</string></edit>
</match>
}}
```
### Web Speech API has no voices {#web_speech_api_has_no_voices}

Firefox uses for text to speech (tts) speechd. You can use the command `{{ic|spd-say "some test sentence"}}`{=mediawiki}
to test if it reads the text or `{{ic|spd-say -L}}`{=mediawiki} to get a list of the voices. If there are no voices,
too, you can install some with the package `{{Pkg|espeak-ng}}`{=mediawiki}. If they do not work out of the box, you
maybe have to configure them. You can use the `{{ic|spd-conf}}`{=mediawiki} command or edit the config file
`{{ic|.config/speech-dispatcher/speechd.conf}}`{=mediawiki}. There should be the following lines active (without \# in
front of it):

`AddModule "espeak-ng"                "sd_espeak-ng" "espeak-ng.conf"`\
`DefaultModule espeak-ng`

### Narrate/Listen icon missing in Reader Mode {#narratelisten_icon_missing_in_reader_mode}

#### Enable Speech Synthesis {#enable_speech_synthesis}

Per <https://developer.mozilla.org/en-US/docs/Web/API/Web_Speech_API/Using_the_Web_Speech_API>, speech synthesis must be
enabled (it is enabled by default). To enable, set `{{ic|media.webspeech.synth.enabled}}`{=mediawiki} to
`{{ic|true}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

#### Disable Fingerprinting Protection {#disable_fingerprinting_protection}

Per <https://support.mozilla.org/en-US/kb/firefox-protection-against-fingerprinting>, Fingerprinting Protection disables
the WebSpeech API. If you enabled this option, you will need to disable it for the narrator to work. To disable
fingerprinting protection, set `{{ic|privacy.resistFingerprinting}}`{=mediawiki} to `{{ic|false}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}.

#### Disable filter voices {#disable_filter_voices}

If you do not see the narrator icon, try setting `{{ic|narrate.filter-voices}}`{=mediawiki} to
`{{ic|false}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

This can be used to check whether `{{ic|speech-dispatcher}}`{=mediawiki} works at all. If it helps, you may miss voices
for the language of the article opened in reader mode (check `{{ic|spd-say -L}}`{=mediawiki}). If you have voices for
the reader article language installed, there may be some incorrect settings or defaults related to
`{{ic|speech-dispatcher}}`{=mediawiki} configuration.

### File dialogs do not open when downloading files {#file_dialogs_do_not_open_when_downloading_files}

If no file chooser is shown when downloading files, even with the option \"Always ask where to save files\" enabled in
Firefox\'s settings, then you might not have both `{{Pkg|xdg-desktop-portal}}`{=mediawiki} and a suitable
implementation. Desktop environments usually provide an implementation, but if you are using a standalone window manager
such as [i3](i3 "wikilink"), then you may need to manually install one. [Install](Install "wikilink")
`{{Pkg|xdg-desktop-portal}}`{=mediawiki} and for example `{{Pkg|xdg-desktop-portal-gtk}}`{=mediawiki}.

### Notifications are not floating in tiling window managers or Wayland compositors {#notifications_are_not_floating_in_tiling_window_managers_or_wayland_compositors}

If you are using a [tiling window manager](tiling_window_manager "wikilink") or a [Wayland
compositor](Wayland_compositor "wikilink"), and the HTML notifications appear as normal Firefox windows instead of
floating pop-ups, you need to [install](install "wikilink") `{{Pkg|libnotify}}`{=mediawiki} and make sure you have a
working [Desktop notifications](Desktop_notifications "wikilink") server, such as `{{Pkg|mako}}`{=mediawiki}.

### DNIe certificate is not picked up after renewal from the card reader {#dnie_certificate_is_not_picked_up_after_renewal_from_the_card_reader}

After renewing the certificate in the card (Spanish DNIe) Firefox continues to use the previous certificate, allows to
login but won\'t authenticate the users on any service. You need to clear the card cache

`$ pkcs15-tool --clear-cache`

## See also {#see_also}

-   [Official website](https://www.mozilla.org/firefox/)
-   [Mozilla Foundation](https://www.mozilla.org/)
-   [MozillaWiki:Firefox](MozillaWiki:Firefox "wikilink")
-   [Wikipedia:Mozilla Firefox](Wikipedia:Mozilla_Firefox "wikilink")
-   [Firefox Add-ons](https://addons.mozilla.org/)
-   [Firefox themes](https://addons.mozilla.org/firefox/themes/)
-   [Mozilla\'s FTP](https://ftp.mozilla.org/pub/firefox/releases/)
-   [mozillaZine](https://forums.mozillazine.org/) unofficial forums

[Category:Web browser](Category:Web_browser "wikilink") [Category:Mozilla](Category:Mozilla "wikilink")

[ja:Firefox/設定](ja:Firefox/設定 "ja:Firefox/設定"){.wikilink}
[zh-hans:Firefox/微调](zh-hans:Firefox/微调 "zh-hans:Firefox/微调"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|Firefox}}`{=mediawiki} `{{Related|Firefox/Profile on RAM}}`{=mediawiki}
`{{Related|Firefox/Privacy}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

```{=mediawiki}
{{Merge|Firefox#Tips and tricks|Also overlaps with [[Firefox#Configuration]]; deciding if some particular topic should be here or on the main page is arbitrary. The "tweaks" are the backbone of the content related to Firefox, so they should be directly on the main page. The troubleshooting section can be split into a subpage if the result is deemed too long.}}
```
This page contains advanced Firefox configuration options and performance tweaks.

## Performance

Improving Firefox\'s performance is divided into parameters that can be inputted while running Firefox or otherwise
modifying its configuration as intended by the developers, and advanced procedures that involve foreign programs or
scripts.

```{=mediawiki}
{{Note|Listed options may only be available for the latest version of Firefox.}}
```
This section contains advanced Firefox options for performance tweaking. For additional information see [these
MozillaZine articles](https://kb.mozillazine.org/Category:Tweaking_preferences).

### Change Performance settings {#change_performance_settings}

Firefox automatically uses settings based on the computer\'s hardware specifications
[1](https://support.mozilla.org/en-US/kb/performance-settings).

Adjusting these settings can be done in Preferences or by changing the `{{ic|dom.ipc.processCount}}`{=mediawiki} value
to `{{ic|1-8}}`{=mediawiki} and `{{ic|browser.preferences.defaultPerformanceSettings.enabled}}`{=mediawiki} to
`{{ic|false}}`{=mediawiki} manually in `{{ic|about:config}}`{=mediawiki}.

However you may want to manually adjust this setting to increase performance even further or decrease memory usage on
low-end devices.

In this case the **Content process limit** for the current [user](user "user"){.wikilink} has been increased to *4*:

```{=mediawiki}
{{hc|$ ps -e {{!}}
```
grep \'Web Content\'\| 13991 tty1 00:00:04 Web Content 14027 tty1 00:00:09 Web Content 14031 tty1 00:00:20 Web Content
14040 tty1 00:00:26 Web Content }}

### WebRender

WebRender is a high-performance, GPU-accelerated 2D rendering engine written in Rust. It is the compositor that powers
Firefox and the [Servo](Wikipedia:Servo_(software) "Servo"){.wikilink} browser engine project. As of Firefox 93, it is
enabled by default for all users and uses hardware rendering by default if the hardware it is running on [supports at
least OpenGL 3.0 or OpenGL ES 3.0 (as of
2021-04)](https://searchfox.org/mozilla-central/rev/2b3f6e5bf3ed0f13a08d0efbafeca57df6616ffa/gfx/webrender_bindings/WebRenderAPI.cpp#141)
and [meets minimum driver requirements](https://searchfox.org/mozilla-central/source/widget/gtk/GfxInfo.cpp#680). If
your system does not meet these requirements it will fallback to software rendering using [Software
WebRender](https://bugzilla.mozilla.org/show_bug.cgi?id=1601053).

You can force GPU-accelerated WebRender for all tasks by setting `{{ic|gfx.webrender.all}}`{=mediawiki} preference to
`{{ic|true}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

If you are experiencing rendering issues with up-to-date drivers on your machine, you can force-enable Software
WebRender by setting the `{{ic|gfx.webrender.software}}`{=mediawiki} preference to `{{ic|true}}`{=mediawiki}.

```{=mediawiki}
{{Warning|WebRender hardware rendering is disabled on many GPUs and drivers due to [https://github.com/servo/webrender/wiki/Driver-issues critical issues with stability, rendering output and performance]. If it is disabled on your hardware, forcing hardware rendering is not recommended.}}
```
### Turn off the disk cache {#turn_off_the_disk_cache}

Every object loaded (html page, jpeg image, css stylesheet, gif banner) is saved in the Firefox cache for future use
without the need to download it again. It is estimated that only a fraction of these objects will be reused, usually
about 30%. This is because of very short object expiration time, updates or simply user behavior (loading new pages
instead of returning to the ones already visited). The Firefox cache is divided into memory and disk cache and the
latter results in frequent disk writes: newly loaded objects are written to memory and older objects are removed.

An alternative approach is to use `{{Ic|about:config}}`{=mediawiki} settings:

- Set `{{Ic|browser.cache.disk.enable}}`{=mediawiki} to `{{ic|false}}`{=mediawiki}
- Verify that `{{Ic|browser.cache.memory.enable}}`{=mediawiki} is set to `{{ic|true}}`{=mediawiki}, more information
  about this option can be found in the [browser.cache.memory Mozilla
  article](https://kb.mozillazine.org/Browser.cache.memory.enable)
- Add the entry `{{Ic|browser.cache.memory.capacity}}`{=mediawiki} and set it to the amount of KB you want to spare, or
  to `{{ic|-1}}`{=mediawiki} for [automatic](https://kb.mozillazine.org/Browser.cache.memory.capacity#-1) cache size
  selection (skipping this step has the same effect as setting the value to `{{ic|-1}}`{=mediawiki})
  - The \"automatic\" size selection is based on a decade-old table that only contains settings for systems at or below
    8GB of system memory. The following formula very closely approximates this table, and can be used to set the Firefox
    cache more dynamically: `{{ic|41297 - (41606 / (1 + ((RAM / 1.16) ^ 0.75)))}}`{=mediawiki}, where
    `{{ic|RAM}}`{=mediawiki} is in GB and the result is in KB.

This method has some drawbacks:

- The content of currently browsed webpages is lost if the browser crashes or after a reboot, this can be avoided using
  [anything-sync-daemon](anything-sync-daemon "anything-sync-daemon"){.wikilink} or any similar periodically-syncing
  script so that cache gets copied over to the drive on a regular basis
- The settings need to be configured for each user individually

### Move disk cache to RAM {#move_disk_cache_to_ram}

An alternative is to move the \"disk\" cache to a RAM disk, giving you a solution in between the two above. The cache
will now be preserved between Firefox runs (including Firefox crash recovery), but will be discarded upon reboot
(including OS crash).

To do this, go to `{{Ic|about:config}}`{=mediawiki} and set `{{Ic|browser.cache.disk.parent_directory}}`{=mediawiki} to
`{{ic|/run/user/''UID''/firefox}}`{=mediawiki}, where `{{ic|''UID''}}`{=mediawiki} is your user\'s ID which can be
obtained by running `{{ic|id -u}}`{=mediawiki}.

```{=mediawiki}
{{Note|The directory will be created after a browser restart. See also [https://kb.mozillazine.org/Browser.cache.disk.parent_directory#Caveats].}}
```
Open `{{Ic|about:cache}}`{=mediawiki} to verify the new disk cache location.

### Longer interval between session information record {#longer_interval_between_session_information_record}

Firefox stores the current session status (opened urls, cookies, history and form data) to the disk on a regular basis.
It is used to recover a previous session in case of crash. The default setting is to save the session every 15 seconds,
resulting in frequent disk access.

To increase the save interval to 10 minutes (600000 milliseconds) for example, change in
`{{ic|about:config}}`{=mediawiki} the setting of `{{ic|browser.sessionstore.interval}}`{=mediawiki} to
`{{ic|600000}}`{=mediawiki}

To disable completely this feature, change `{{ic|browser.sessionstore.resume_from_crash}}`{=mediawiki} to
`{{ic|false}}`{=mediawiki}.

### Defragment the profile\'s SQLite databases {#defragment_the_profiles_sqlite_databases}

```{=mediawiki}
{{Warning|This procedure may damage the databases in such a way that sessions are not saved properly.}}
```
Firefox keeps bookmarks, history, passwords in SQLite databases. SQLite databases become fragmented over time and empty
spaces appear all around. But, since there are no managing processes checking and optimizing the database, these factors
eventually result in a performance hit. A good way to improve start-up and some other bookmarks and history related
tasks is to defragment and trim unused space from these databases.

You can use `{{Pkg|profile-cleaner}}`{=mediawiki} to do this, while Firefox is **not** running:

  SQLite database         Size Before   Size After   \% change
  ----------------------- ------------- ------------ -----------
  urlclassifier3.sqlite   37 M          30 M         19 %
  places.sqlite           16 M          2.4 M        85 %
                                                     

  : profile-cleaner usage example:

Firefox provides a tool to defragment and optimize the places database, which is the source of most slowdowns and
profile corruptions. To access this tool, open the `{{ic|about:support}}`{=mediawiki} page, search for
`{{ic|Places Database}}`{=mediawiki} and click the `{{ic|Verify Integrity}}`{=mediawiki} button.

### Cache the entire profile into RAM via tmpfs {#cache_the_entire_profile_into_ram_via_tmpfs}

If the system has memory to spare, `{{ic|tmpfs}}`{=mediawiki} can be used to [cache the entire profile
directory](Firefox/Profile_on_RAM "cache the entire profile directory"){.wikilink}, which might result in increased
Firefox responsiveness.

### Force-enable hardware video decoding {#force_enable_hardware_video_decoding}

Although `{{ic|media.hardware-video-decoding.enabled}}`{=mediawiki} is enabled by default, one may need to force-enable
hardware video decoding by setting `{{ic|media.hardware-video-decoding.force-enabled}}`{=mediawiki} to
`{{ic|true}}`{=mediawiki}.

### Automatically unload inactive tabs {#automatically_unload_inactive_tabs}

To only unload tabs that are at least 1 hour inactive, set the following in `{{ic|about:config}}`{=mediawiki}:

- ```{=mediawiki}
  {{ic|browser.tabs.unloadOnLowMemory}}
  ```
  must be set to `{{ic|true}}`{=mediawiki}

- ```{=mediawiki}
  {{ic|browser.low_commit_space_threshold_percent}}
  ```
  to `{{ic|100}}`{=mediawiki}

- ```{=mediawiki}
  {{ic|browser.tabs.min_inactive_duration_before_unload}}
  ```
  to `{{ic|3600000}}`{=mediawiki}

## Appearance

### Fonts

See the main article: [Font configuration](Font_configuration "Font configuration"){.wikilink}

#### Configure the DPI value {#configure_the_dpi_value}

Modifying the following value can help improve the way fonts looks in Firefox if the system\'s DPI is below 96. Firefox,
by default, uses 96 and only uses the system\'s DPI if it is a higher value. To force the system\'s DPI regardless of
its value, type `{{ic|about:config}}`{=mediawiki} into the address bar and set `{{ic|layout.css.dpi}}`{=mediawiki} to
**0**.

Note that the above method only affects the Firefox user interface\'s DPI settings. Web page contents still use a DPI
value of 96, which may look ugly or, in the case of high-resolution displays, may be rendered too small to read. A
solution is to change `{{ic|layout.css.devPixelsPerPx}}`{=mediawiki} to system\'s DPI divided by 96. For example, if
your system\'s DPI is 144, then the value to add is 144/96 = 1.5. Changing
`{{ic|layout.css.devPixelsPerPx}}`{=mediawiki} to **1.5** makes web page contents use a DPI of 144, which looks much
better.

If this results in fonts that are undesirably large in releases after Firefox 103, change
`{{ic|browser.display.os-zoom-behavior}}`{=mediawiki} to zero. Then, type `{{ic|ui.textScaleFactor}}`{=mediawiki} into
the `{{ic|about:config}}`{=mediawiki} search bar, select the circle next to \'number,\' click the plus button to add the
setting key, and edit its value to 100 times your `{{ic|layout.css.devPixelsPerPx}}`{=mediawiki} value. For example, if
that was set to 1.25, `{{ic|ui.textScaleFactor}}`{=mediawiki} should be set to 125.

See also [HiDPI#Firefox](HiDPI#Firefox "HiDPI#Firefox"){.wikilink} for information about HiDPI displays and
[2](https://www.sven.de/dpi/) for calculating the DPI.

#### Default font settings from Microsoft Windows {#default_font_settings_from_microsoft_windows}

Below are the default font preferences when Firefox is installed in Microsoft Windows. Many web sites use the Microsoft
fonts.

```{=mediawiki}
{{bc|
Proportional: Serif Size (pixels): 16
Serif: Times New Roman
Sans-serif: Arial
Monospace: Courier New Size (pixels): 13
}}
```
### General user interface CSS settings {#general_user_interface_css_settings}

Firefox\'s user interface can be modified by editing the `{{ic|userChrome.css}}`{=mediawiki} and
`{{ic|userContent.css}}`{=mediawiki} files in `{{ic|~/.mozilla/firefox/''profile''/chrome/}}`{=mediawiki} (*profile_dir*
is of the form *hash.name*, where the *hash* is an 8 character, seemingly random string and the profile *name* is
usually *default*). You can find out the exact name by typing `{{ic|about:support}}`{=mediawiki} in the URL bar, and
searching for the `{{ic|Profile Directory}}`{=mediawiki} field under the `{{ic|Application Basics}}`{=mediawiki} section
as described in the [Firefox
documentation](https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data#w_how-do-i-find-my-profile).

```{=mediawiki}
{{Note|
* The {{ic|chrome/}} folder and {{ic|userChrome.css}}/{{ic|userContent.css}} files may not necessarily exist, so they may need to be created.
* {{ic|toolkit.legacyUserProfileCustomizations.stylesheets}} must be enabled in {{ic|about:config}}.
}}
```
This section only deals with the `{{ic|userChrome.css}}`{=mediawiki} file which modifies Firefox\'s user interface, and
not web pages.

#### Change the interface font {#change_the_interface_font}

The setting effectively overrides the global GTK font preferences, and does not affect webpages, only the user interface
itself:

```{=mediawiki}
{{hc|~/.mozilla/firefox/''profile''/chrome/userChrome.css|
* {
    font-family: "FONT_NAME";
}
}}
```
#### Hide button icons {#hide_button_icons}

Enables text-only buttons: `{{hc|~/.mozilla/firefox/''profile''/chrome/userChrome.css|
.button-box .button-icon {
    display: none;
}
}}`{=mediawiki}

#### Hiding various tab buttons {#hiding_various_tab_buttons}

These settings hide the arrows that appear to the horizontal edges of the tab bar, the button that toggles the \"all
tabs\" drop-down list, and the plus sign button that creates a new tab.

```{=mediawiki}
{{hc|~/.mozilla/firefox/''profile''/chrome/userChrome.css|<nowiki>
/* Tab bar */

toolbarbutton#scrollbutton-up, toolbarbutton#scrollbutton-down {
    /* Hide tab scroll buttons */
    display: none;
}

.browser-toolbar > * #alltabs-button {
    /* Hide tab drop-down list */
    display: none;
}

.browser-toolbar > * #new-tab-button {
    /* Hide new-tab button */
    display: none;
}</nowiki>
}}
```
#### Vertical/tree tabs {#verticaltree_tabs}

To place the tab bar in a sidebar/tree, use one of the following addons:

- [Tree Style Tab](https://addons.mozilla.org/firefox/addon/tree-style-tab/)
- [Sidebery](https://addons.mozilla.org/firefox/addon/sidebery/)
- [Tabby](https://addons.mozilla.org/firefox/addon/tabby-window-tab-manager/)

Firefox addons cannot hide the native tab bar through its extension APIs - to do so, follow the setup/advanced
instructions for your addon.

#### Hide title bar and window border {#hide_title_bar_and_window_border}

To replace the title bar with the tab bar, set `{{ic|browser.tabs.inTitlebar}}`{=mediawiki} to `{{ic|1}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}.

Or go to \"More tools\", then \"Customize toolbar\" and then at the bottom-left corner find checkbox named \"Title
Bar\". Uncheck it. If the checkbox is missing, make sure the `{{ic|XDG_CURRENT_DESKTOP}}`{=mediawiki} environment
variable is correctly set and/or the `{{ic|MOZ_GTK_TITLEBAR_DECORATION}}`{=mediawiki} environment variable is set to
\"client\".

#### Auto-hide Bookmarks Toolbar {#auto_hide_bookmarks_toolbar}

```{=mediawiki}
{{hc|~/.mozilla/firefox/''profile''/chrome/userChrome.css|
#PersonalToolbar {
    visibility: collapse !important;
}

#navigator-toolbox:hover > #PersonalToolbar {
    visibility: visible !important;
}
}}
```
#### Remove sidebar width restrictions {#remove_sidebar_width_restrictions}

```{=mediawiki}
{{hc|~/.mozilla/firefox/''profile''/chrome/userChrome.css|
/* remove maximum/minimum  width restriction of sidebar */
#sidebar {
    max-width: none !important;
    min-width: 0px !important;
}
}}
```
#### Unreadable input fields with dark GTK themes {#unreadable_input_fields_with_dark_gtk_themes}

When using a dark [GTK](GTK "GTK"){.wikilink} theme, one might encounter Internet pages with unreadable input and text
fields (e.g. text input field with white text on white background, or black text on dark background). This can happen
because the site only sets either background or text color, and Firefox takes the other one from the theme. To prevent
Firefox from using theme\'s colors and dark themes in web pages respectively confirm
`{{ic|browser.display.use_system_colors}}`{=mediawiki} and `{{ic|widget.content.allow-gtk-dark-theme}}`{=mediawiki} are
set to `{{ic|false}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

Otherwise, if the previous modification did not solve the issue, it is possible to launch Firefox with a light GTK theme
by adding a new string in `{{ic|about:config}}`{=mediawiki} named `{{ic|widget.content.gtk-theme-override}}`{=mediawiki}
and setting it to a light theme like `{{ic|Breeze:light}}`{=mediawiki} or `{{ic|Adwaita:light}}`{=mediawiki}.

##### Override input field color with CSS {#override_input_field_color_with_css}

```{=mediawiki}
{{Note|1=Related bug has been resolved starting with 68. [https://bugzilla.mozilla.org/show_bug.cgi?id=1527048#c44]}}
```
The extension [Text Contrast for Dark Themes](https://addons.mozilla.org/firefox/addon/text-contrast-for-dark-themes/)
sets the other color as needed to maintain contrast.

Alternatively set the standard colors explicitly for all web pages in `{{ic|userContent.css}}`{=mediawiki} or using the
[stylus add-on](https://addons.mozilla.org/firefox/addon/styl-us/). The style sheet is usually located in your profile
folder (visit `{{ic|about:profiles}}`{=mediawiki} for the path) in `{{ic|chrome/userContent.css}}`{=mediawiki}, if not
you can create it there.

The following sets input fields to standard black text / white background; both can be overridden by the displayed site,
so that colors are seen as intended:

```{=mediawiki}
{{Note|If you want {{ic|urlbar}} and {{ic|searchbar}} to be {{ic|white}} remove the two first {{ic|:not}} css selectors.}}
```
```{=mediawiki}
{{bc|1=
input:not(.urlbar-input):not(.textbox-input):not(.form-control):not([type='checkbox']):not([type='radio']), textarea, select {
    -moz-appearance: none !important;
    background-color: white;
    color: black;
}

#downloads-indicator-counter {
    color: white;
}
}}
```
##### Change the GTK theme {#change_the_gtk_theme}

To force Firefox to use a light theme (e.g. Adwaita) for both web content and UI, see
[GTK#Themes](GTK#Themes "GTK#Themes"){.wikilink}.

##### Change the GTK theme for content process only {#change_the_gtk_theme_for_content_process_only}

To force Firefox to use a light theme (e.g. Adwaita) for web content only:

1.  Open `{{ic|about:config}}`{=mediawiki} in the address bar.
2.  Create a new `{{ic|widget.content.gtk-theme-override}}`{=mediawiki} string type entry
    (`{{ic|right mouse button}}`{=mediawiki} *\> New \> String*).
3.  Set the value to the light theme to use for rendering purposes (e.g. `{{ic|Adwaita:light}}`{=mediawiki}).
4.  Restart Firefox.

### Web content CSS settings {#web_content_css_settings}

This section deals with the `{{ic|userContent.css}}`{=mediawiki} file in which you can add custom CSS rules for web
content. Changes to this file will take effect once the browser is restarted.

This file can be used for making small fixes or to apply personal styles to frequently visited websites. Custom
stylesheets for popular websites are available from sources such as [userstyles.org](https://userstyles.org/). You can
install an add-on such as
[superUserContent](https://addons.mozilla.org/firefox/addon/superusercontent/)`{{Dead link|2020|03|29|status=404}}`{=mediawiki}
to manage themes. This add-on creates the directory `{{ic|chrome/userContent.css.d}}`{=mediawiki} and applies changes to
the CSS files therein when the page is refreshed.

#### Import other CSS files {#import_other_css_files}

```{=mediawiki}
{{hc|~/.mozilla/firefox/''profile''/chrome/userContent.css|
@import url("./imports/some_file.css");
}}
```
#### Block certain parts of a domain {#block_certain_parts_of_a_domain}

```{=mediawiki}
{{hc|~/.mozilla/firefox/''profile''/chrome/userContent.css|
@-moz-document domain(example.com) {
    div#header {
        background-image: none !important;
    } 
}
}}
```
#### Add \[pdf\] after links to PDF files {#add_pdf_after_links_to_pdf_files}

```{=mediawiki}
{{hc|~/.mozilla/firefox/''profile''/chrome/userContent.css|<nowiki>
/* add '[pdf]' next to links to PDF files */
a[href$=".pdf"]:after {
    font-size: smaller;
    content: " [pdf]";
}</nowiki>
}}
```
## Mouse and keyboard {#mouse_and_keyboard}

### Mouse wheel scroll speed {#mouse_wheel_scroll_speed}

To modify the default values (i.e. speed-up) of the mouse wheel scroll speed, go to `{{ic|about:config}}`{=mediawiki}
and search for `{{ic|mousewheel.acceleration}}`{=mediawiki}. This will show the available options, modifying the
following:

- Set `{{ic|mousewheel.acceleration.start}}`{=mediawiki} to `{{ic|1}}`{=mediawiki}.
- Set `{{ic|mousewheel.acceleration.factor}}`{=mediawiki} to the desired number (`{{ic|10}}`{=mediawiki} to
  `{{ic|20}}`{=mediawiki} are common values).

Alternatively, to use system values (as how scrolling works in Chromium), set
`{{ic|mousewheel.system_scroll_override.enabled}}`{=mediawiki} to `{{ic|false}}`{=mediawiki}.

Mozilla\'s recommendation for increasing the mousewheel scroll speed is to:

- Set `{{ic|mousewheel.default.delta_multiplier_y}}`{=mediawiki} between `{{ic|200}}`{=mediawiki} and
  `{{ic|500}}`{=mediawiki} (default: `{{ic|100}}`{=mediawiki})

### Pixel-perfect trackpad scrolling {#pixel_perfect_trackpad_scrolling}

To enable one-to-one trackpad scrolling (as can be witnessed with GTK3 applications like Nautilus), set the
`{{ic|1=MOZ_USE_XINPUT2=1}}`{=mediawiki} [environment variable](environment_variable "environment variable"){.wikilink}
before starting Firefox.

If scrolling is undesirably jerky, try enabling Firefox\'s *Use smooth scrolling* option under *Preferences \> General
\> Browsing*.

### Enable touchscreen gestures {#enable_touchscreen_gestures}

On [Wayland](Wayland "Wayland"){.wikilink}, touchscreen gestures are enabled by default.

On X11, make sure `{{ic|dom.w3c_touch_events.enabled}}`{=mediawiki} is either set to 1 (*enabled*) or 2 (*default,
auto-detect*), and set the `{{ic|1=MOZ_USE_XINPUT2=1}}`{=mediawiki} [environment
variable](environment_variable "environment variable"){.wikilink}.

On some devices, it may be necessary to disable xinput\'s touchscreen gestures by running the following:

`$ xsetwacom --set `*`device`*` Gesture off`

### Mouse click on URL bar\'s behavior {#mouse_click_on_url_bars_behavior}

In older versions of Firefox it was possible to tweak the behavior of the address bar in
`{{ic|about:config}}`{=mediawiki}, but this has been [removed in March
2020](https://bugzilla.mozilla.org/show_bug.cgi?id=333714).

In order to for example disable the behavior that selects the contents of the address bar on first click, or to allow to
double click the URL to select it in full, see user contributed scripts such as
<https://github.com/SebastianSimon/firefox-omni-tweaks>

### Smooth scrolling {#smooth_scrolling}

In order to get smooth physics-based scrolling in Firefox, the `{{ic|general.smoothScroll.msdPhysics}}`{=mediawiki}
configurations can be changed to emulate a snappier behaviour like in other web browsers. For a quicker configuration,
append the following to `{{ic|~/.mozilla/firefox/''your-profile''/user.js}}`{=mediawiki} (requires restart):

`user_pref("general.smoothScroll.lines.durationMaxMS", 125);`\
`user_pref("general.smoothScroll.lines.durationMinMS", 125);`\
`user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 200);`\
`user_pref("general.smoothScroll.mouseWheel.durationMinMS", 100);`\
`user_pref("general.smoothScroll.msdPhysics.enabled", true);`\
`user_pref("general.smoothScroll.other.durationMaxMS", 125);`\
`user_pref("general.smoothScroll.other.durationMinMS", 125);`\
`user_pref("general.smoothScroll.pages.durationMaxMS", 125);`\
`user_pref("general.smoothScroll.pages.durationMinMS", 125);`

Additionally the mouse wheel scroll settings have to be changed to react in a smooth way as well:

`user_pref("mousewheel.min_line_scroll_amount", 30);`\
`user_pref("mousewheel.system_scroll_override_on_root_content.enabled", true);`\
`user_pref("mousewheel.system_scroll_override_on_root_content.horizontal.factor", 175);`\
`user_pref("mousewheel.system_scroll_override_on_root_content.vertical.factor", 175);`\
`user_pref("toolkit.scrollbox.horizontalScrollDistance", 6);`\
`user_pref("toolkit.scrollbox.verticalScrollDistance", 2);`

If you have troubles on machines with varying performance, try modifying the
`{{ic|mousewheel.min_line_scroll_amount}}`{=mediawiki} until it feels snappy enough.

For a more advanced configuration which modifies the mass-spring-damper parameters, see [AveYo\'s natural smooth
scrolling configuration](https://github.com/AveYo/fox/blob/main/Natural%20Smooth%20Scrolling%20for%20user.js).

```{=mediawiki}
{{Note|Kinetic scrolling feels loose on Wayland due to https://bugzilla.mozilla.org/show_bug.cgi?id{{=}}
```
1568722, and can be turned off by going to `{{ic|about:config}}`{=mediawiki} and turning off
`{{ic|apz.gtk.kinetic_scroll.enabled}}`{=mediawiki}. This will make it harder to scroll to the beginning and end of long
pages, however.}}

### Jerky or choppy scrolling {#jerky_or_choppy_scrolling}

Scrolling in Firefox can feel \"jerky\" or \"choppy\". A post on
[MozillaZine](https://forums.mozillazine.org/viewtopic.php?f=8&t=2749475/) gives settings that work on Gentoo, but
reportedly work on Arch Linux as well:

1.  Set `{{ic|mousewheel.min_line_scroll_amount}}`{=mediawiki} to 40
2.  Set `{{ic|general.smoothScroll}}`{=mediawiki} and `{{ic|general.smoothScroll.pages}}`{=mediawiki} to **false**
3.  Set `{{ic|image.mem.min_discard_timeout_ms}}`{=mediawiki} to something really large such as 2100000000 but no more
    than 2140000000. Above that number Firefox will not accept your entry and complain with the error code: \"The text
    you entered is not a number.\"
4.  Set `{{ic|image.mem.max_decoded_image_kb}}`{=mediawiki} to at least 512K

Now scrolling should flow smoothly.

### Set backspace\'s behavior {#set_backspaces_behavior}

See [Firefox#Backspace does not work as the \'Back\'
button](Firefox#Backspace_does_not_work_as_the_'Back'_button "Firefox#Backspace does not work as the 'Back' button"){.wikilink}.

### Disable middle mouse button clipboard paste {#disable_middle_mouse_button_clipboard_paste}

See [Firefox#Middle-click behavior](Firefox#Middle-click_behavior "Firefox#Middle-click behavior"){.wikilink}.

### Emacs key bindings {#emacs_key_bindings}

To have Emacs/Readline-like key bindings active in text fields, see [GTK#Emacs key
bindings](GTK#Emacs_key_bindings "GTK#Emacs key bindings"){.wikilink}.

## Miscellaneous

### Remove full screen warning {#remove_full_screen_warning}

Warning about video displayed in full screen mode (*... is now fullscreen*) can be disabled by setting
`{{ic|full-screen-api.warning.timeout}}`{=mediawiki} to `{{ic|0}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

### Change the order of search engines in the Firefox Search Bar {#change_the_order_of_search_engines_in_the_firefox_search_bar}

To change the order search engines are displayed in:

- Open the drop-down list of search engines and click *Manage Search Engines\...* entry.
- Highlight the engine you want to move and use *Move Up* or *Move Down* to move it. Alternatively, you can use
  drag-and-drop.

### \"I\'m Feeling Lucky\" mode {#im_feeling_lucky_mode}

Some search engines have a \"feeling lucky\" feature. For example, Google has \"I\'m Feeling Lucky\".

To activate them, search for `{{ic|keyword.url}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki} and modify its value
(if any) to the URL of the search engine.

For Google, set it to:

```{=mediawiki}
{{bc|<nowiki>https://www.google.com/search?btnI=I%27m+Feeling+Lucky&q=</nowiki>}}
```
### Secure DNS with DNSSEC validator {#secure_dns_with_dnssec_validator}

You can enable [DNSSEC](DNSSEC "DNSSEC"){.wikilink} support for safer browsing.

### Secure DNS with DNS over HTTPS {#secure_dns_with_dns_over_https}

See [Domain name resolution#Application-level
DNS](Domain_name_resolution#Application-level_DNS "Domain name resolution#Application-level DNS"){.wikilink}.

### Adding magnet protocol association {#adding_magnet_protocol_association}

In `{{ic|about:config}}`{=mediawiki} set `{{ic|network.protocol-handler.expose.magnet}}`{=mediawiki} to
`{{ic|false}}`{=mediawiki}. In case it does not exist, it needs to be created, right click on a free area and select
*New \> Boolean*, input `{{ic|network.protocol-handler.expose.magnet}}`{=mediawiki} and set it to
`{{ic|false}}`{=mediawiki}.

The next time you open a magnet link, you will be prompted with a *Launch Application* dialogue. From there simply
select your chosen [BitTorrent client](List_of_applications/Internet#BitTorrent_clients "BitTorrent client"){.wikilink}.
This technique can also be used with other protocols: `{{ic|network.protocol-handler.expose.<protocol>}}`{=mediawiki}.

### Prevent accidental closing {#prevent_accidental_closing}

There are different approaches to handle this:

This behavior can be disabled with `{{ic|browser.quitShortcut.disabled}}`{=mediawiki} property set to
`{{ic|true}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}

An alternative is to add a rule in your window manager configuration file. For example in
[Openbox](Openbox "Openbox"){.wikilink} add:

` ``<keybind key="C-q">`{=html}\
`   ``<action name="Execute">`{=html}\
`     ``<execute>`{=html}`false``</execute>`{=html}\
`   ``</action>`{=html}\
` ``</keybind>`{=html}

in the *`<keyboard>`{=html}* section of your `{{ic|~/.config/openbox/rc.xml}}`{=mediawiki} file.

```{=mediawiki}
{{Note|This will be effective for every application used under a graphic server.}}
```
The [Disable Ctrl-Q and Cmd-Q](https://addons.mozilla.org/firefox/addon/disable-ctrl-q-and-cmd-q/) extension can be
installed to prevent unwanted closing of the browser.

```{=mediawiki}
{{Note|1=This extension no longer works on Linux due to a [https://bugzilla.mozilla.org/show_bug.cgi?id=1325692 bug].}}
```
### Run Firefox inside an nspawn container {#run_firefox_inside_an_nspawn_container}

See [systemd-nspawn#Run Firefox](systemd-nspawn#Run_Firefox "systemd-nspawn#Run Firefox"){.wikilink}.

### Disable WebRTC audio post processing {#disable_webrtc_audio_post_processing}

If you are using the PulseAudio [PulseAudio#Microphone echo/noise
cancellation](PulseAudio#Microphone_echo/noise_cancellation "PulseAudio#Microphone echo/noise cancellation"){.wikilink},
you probably do not want Firefox to do additional audio post processing.

To disable audio post processing, change the value of the following preferences to `{{ic|false}}`{=mediawiki}:

- ```{=mediawiki}
  {{ic|media.getusermedia.audio.processing.aec.enabled}}
  ```
  (Acoustic Echo Cancellation)

- ```{=mediawiki}
  {{ic|media.getusermedia.audio.processing.agc.enabled}}
  ```
  (Automatic Gain Control)

- ```{=mediawiki}
  {{ic|media.getusermedia.audio.processing.noise.enabled}}
  ```
  (Noise suppression)

- ```{=mediawiki}
  {{ic|media.getusermedia.audio.processing.hpf.enabled}}
  ```
  (High-pass filter)

### Fido U2F authentication {#fido_u2f_authentication}

Firefox supports the Fido [U2F](U2F "U2F"){.wikilink} authentication protocol. Install `{{pkg|libfido2}}`{=mediawiki}
for the required udev rules.

### Get ALSA working back {#get_alsa_working_back}

```{=mediawiki}
{{Remove|If it works by default, why keep this section?}}
```
As long as Arch keeps building Firefox with *ac_add_options \--enable-alsa*, then Firefox works fine without pulse on
the system, without needing any special configurations, and without apulse (unless using pulse on the system and wanting
Firefox to avoid using it). It used to be one had to allow ioctl syscalls, blocked by default by Firefox sandboxing, and
required by ALSA setting `{{ic|security.sandbox.content.syscall_whitelist}}`{=mediawiki} in
`{{ic|about:config}}`{=mediawiki}, to the right ioctl syscall number, which is *16* for x86-64 and *54* for x86-32, but
not anymore. For reference, see:

[3](https://www.linuxquestions.org/questions/slackware-14/firefox-in-current-alsa-sound-4175622116)
[4](https://codelab.wordpress.com/2017/12/11/firefox-drops-alsa-apulse-to-the-rescue)

### Force-enable WebGL {#force_enable_webgl}

On some platforms WebGL may be [disabled](MozillaWiki:Blocklisting/Blocked_Graphics_Drivers "disabled"){.wikilink} even
when the user desires to use it. To force-enable WebGL set `{{ic|webgl.force-enabled}}`{=mediawiki} to
`{{ic|true}}`{=mediawiki}, to also force-enable WebGL anti-aliasing, set `{{ic|webgl.msaa-force}}`{=mediawiki} to
`{{ic|true}}`{=mediawiki}.

If you get an error similar to this: `{{bc|libGL error: MESA-LOADER: failed to retrieve device information
libGL error: image driver extension not found
libGL error: failed to load driver: i915
libGL error: MESA-LOADER: failed to retrieve device information
...}}`{=mediawiki} then you can try the solution explained in Firefox bug 1480755
[5](https://bugzilla.mozilla.org/show_bug.cgi?id=1480755):

Set `{{ic|security.sandbox.content.read_path_whitelist}}`{=mediawiki} to `{{ic|/sys/}}`{=mediawiki}

### Prevent the download panel from opening automatically {#prevent_the_download_panel_from_opening_automatically}

As of Firefox 98, the download panel (with ongoing/recent downloads) always opens whenever a download starts.

You can disable this behavior by setting the `{{ic|browser.download.alwaysOpenPanel}}`{=mediawiki} preference to
`{{ic|false}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

## See also {#see_also}

- [MozillaZine Wiki](https://kb.mozillazine.org/Knowledge_Base)
- [<about:config> entries MozillaZine article](https://kb.mozillazine.org/About:config_entries)
- [Firefox touch-ups that might be desired](https://linuxtidbits.wordpress.com/2009/08/01/better-fox-cat-and-weasel/)

[Category:Web browser](Category:Web_browser "Category:Web browser"){.wikilink}

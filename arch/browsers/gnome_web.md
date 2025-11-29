[de:Epiphany](de:Epiphany "wikilink") [es:GNOME (Español)/Web](es:GNOME_(Español)/Web "wikilink")
[ja:GNOME/Web](ja:GNOME/Web "wikilink") [ru:GNOME (Русский)/Web](ru:GNOME_(Русский)/Web "wikilink")
[zh-hans:GNOME/Web](zh-hans:GNOME/Web "wikilink") Web is the default web browser for [GNOME](GNOME "wikilink"). Web
provides a simple and minimalist interface for accessing the internet. Whilst it is developed primarily for GNOME, Web
works acceptably in other [desktop environments](desktop_environments "wikilink") as well.

```{=mediawiki}
{{Note|Web was known as [https://apps.gnome.org/Epiphany Epiphany] prior to version 3.4.  The application was given new descriptive names, one for each supported language. The name ''Epiphany'' is still used in numerous places such as the executable name, some package names, some desktop entries, and some GSettings schemas.}}
```
## Installation

Web can be [installed](install "wikilink") with the `{{Pkg|epiphany}}`{=mediawiki} package. If you want to save login
passwords, install `{{Pkg|gnome-keyring}}`{=mediawiki}.

## Configuration

### Blocking advertisements {#blocking_advertisements}

Enabled by default, one can disable it by unchecking *Block Advertisements* in *Preferences*. EasyList is the default
blocking list. All lists are periodically refreshed.

To get list of currently enabled filters:

`$ gsettings get org.gnome.Epiphany content-filters`

The filters can be modified using a JSON-formatted resource following examples at
<https://gitlab.com/eyeo/filterlists/contentblockerlists>:

`$ gsettings set org.gnome.Epiphany content-filters "['https://gitlab.com/eyeo/filterlists/contentblockerlists/-/raw/master/easylist_min_content_blocker.json', 'https://gitlab.com/eyeo/filterlists/contentblockerlists/-/raw/master/easylist+easylistchina-minified.json']"`

```{=mediawiki}
{{Tip|{{pkg|dconf-editor}} may be used as an GUI alternative.}}
```
### Tracking Prevention {#tracking_prevention}

Web includes *Intelligent Tracker Prevention*, which can be enabled in *Preferences*.

### Firefox Sync {#firefox_sync}

Web allows the usage of [Firefox Sync](https://www.mozilla.org/en-US/firefox/sync/) to sync bookmarks, history,
passwords and open tabs. It can be configured in the *Import and Export* dropdown menu.

### Web applications {#web_applications}

Web can create web applications out of websites and add them to desktop menu. To configure and remove them enter
`{{ic|about:applications}}`{=mediawiki} in the address bar.

### Custom stylesheet {#custom_stylesheet}

Web supports custom stylesheet you can enable under **Fonts and style** in **Preferences**.

Use example below to set new tab page layout and colors according to Adwaita dark variant:

```{=mediawiki}
{{hc|~/.config/epiphany/user-stylesheet.css|
#overview {
  background-color: #2E3436 !important;
  max-width: 100% !important;
  max-height: 100% !important;
  position: fixed !important;
}

#overview .overview-title {
  color: white !important;
}
}}
```
### Fonts

Web does not check GNOME font settings, but checks [Font configuration](Font_configuration "wikilink").

### Video

See [GStreamer](GStreamer "wikilink") for required plugin installation.

To enable hardware accelerated video decoding, see [GStreamer#Hardware video
acceleration](GStreamer#Hardware_video_acceleration "wikilink") and [#Hardware accelerated
compositing](#Hardware_accelerated_compositing "wikilink").

### Hardware accelerated compositing {#hardware_accelerated_compositing}

By default hardware accelerated compositing is only used when required (on-demand) to display 3D transforms.

To force enable hardware accelerated compositing:

`$ gsettings set org.gnome.Epiphany.web:/ hardware-acceleration-policy 'always'`

### Proxy configuration {#proxy_configuration}

Web doesn\'t respect socks_proxy, instead, you can set http_proxy to a `{{ic|socks:// URL}}`{=mediawiki} :

`export http_proxy=socks://127.0.0.1:1080`

More information: [Proxy server#Environment variables](Proxy_server#Environment_variables "wikilink")

### Spell checking {#spell_checking}

By default, Web should work with your system language if the Spell Checking option is enabled in Preferences and
relevant dictionaries are installed on your system. Additional languages have to be added to the Languages list in
Web\'s preferences from a list of available ones. That list only shows languages for which the
[Locale](Locale "wikilink") has been enabled on your system. The selection of languages in Preferences controls both
spell checking and also the Accept-Language header.

## See also {#see_also}

-   [Web - Apps for GNOME](https://apps.gnome.org/Epiphany)

[Category:GNOME](Category:GNOME "wikilink") [Category:Web browser](Category:Web_browser "wikilink")

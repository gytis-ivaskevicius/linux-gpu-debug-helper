```{=mediawiki}
{{Lowercase title}}
```
[ja:Badwolf](ja:Badwolf "ja:Badwolf"){.wikilink} [Badwolf](https://hacktivis.me/projects/badwolf) is a minimal, privacy
oriented, [WebKitGTK browser](List_of_applications/Internet#WebKitGTK-based "WebKitGTK browser"){.wikilink} for Linux
and BSD on x86(-64) and arm7&8 running on [X11](X11 "X11"){.wikilink} and [Wayland](Wayland "Wayland"){.wikilink}.
Badwolf features toggles for JavaScript and image loading, a tabbed browsing experience in a mouse-driven user
interface. It has a low memory footprint and small binary size.

## Installation

[Install](Install "Install"){.wikilink} `{{AUR|badwolf}}`{=mediawiki}.

### Video streaming {#video_streaming}

For video streaming to work make sure to install `{{Pkg|gst-plugins-good}}`{=mediawiki},
`{{Pkg|gst-plugins-bad}}`{=mediawiki} and `{{Pkg|gst-plugins-ugly}}`{=mediawiki}.

```{=mediawiki}
{{Note|Badwolf does not support DRM, so streaming websites that use it will not work.}}
```
## Configuration

### Interface

The interface can be modified using css located at `{{ic|$XDG_DATA_HOME/badwolf/interface.css}}`{=mediawiki} for a
per-user configuration or in `{{ic|/usr/local/share/badwolf/interface.css}}`{=mediawiki} for a system-wide
configuration. For a list if configurable properties see [the gtk
manual](https://developer.gnome.org/gtk3/stable/chap-css-properties.html).

### Extensions

Badwolf does not support JavaScript user extensions, but it does support WebKit extensions such as
[wyebadblock](https://github.com/jun7/wyebadblock).

### Keybindings

The default keybings can be changed in the `{{ic|keybindings.c}}`{=mediawiki} file. Custom keybinds can also be added
that run arbitrary C code.

### config.h

Certain properties can be changed in the `{{ic|config.c}}`{=mediawiki} file. Further documentation can be found in the
file itself.

### Homepage

The default homepage (for new tabs and fresh browser sessions) can be set in `{{ic|uri.c}}`{=mediawiki}.

```{=mediawiki}
{{Note|Remember to include the full URI for your homepage, including its scheme, e.g {{ic|https://}} or {{ic|file://}}.}}
```
[Category:Web browser](Category:Web_browser "Category:Web browser"){.wikilink}

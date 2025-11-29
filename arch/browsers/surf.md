```{=mediawiki}
{{Lowercase title}}
```
[fi:Surf](fi:Surf "wikilink") [ja:Surf](ja:Surf "wikilink") [pl:Surf](pl:Surf "wikilink") [uk:Surf](uk:Surf "wikilink")
[surf](https://surf.suckless.org/) is a simple web browser based on
[WebKit/GTK](List_of_applications/Internet#WebKitGTK-based "wikilink"). It is able to display websites and follow links.
It supports the XEmbed protocol which makes it possible to embed it in another application. Furthermore, one can point
surf to another URI by setting its XProperties.

## Installation

[Install](Install "wikilink") the `{{AUR|surf}}`{=mediawiki} package. Due to the absence of releases since 2021, you may
want to try the `{{AUR|surf-git}}`{=mediawiki} package for the development version.

Optionally also install the `{{Pkg|dmenu}}`{=mediawiki} package for URL-bar

## Configuration

surf is configured through its `{{ic|config.h}}`{=mediawiki} file. A sample `{{ic|config.def.h}}`{=mediawiki} file is
included with the source and should be instructive.

As with other packages such as [dwm](dwm "wikilink"), consider using the Arch Build System ([ABS](ABS "wikilink")) and
maintaining your own [PKGBUILD](PKGBUILD "wikilink") with sources and md5sums for your own configuration and source
files.

## Extended usage {#extended_usage}

### Patches & additional features {#patches_additional_features}

There are many user-created [patches](https://surf.suckless.org/patches/) available from the offical site that greatly
extend the functionality of surf. Patches can be applied to both the source `{{ic|surf.c}}`{=mediawiki} file and the
`{{ic|config.h}}`{=mediawiki} file:

`$ cd src/surf-`*`version`*`/`\
`$ patch -p1 < `*`path/to/patch.diff`*

### Tabbed browsing {#tabbed_browsing}

The `{{AUR|tabbed-git}}`{=mediawiki} program can be used with surf to create a simple tabbed browsing experience.

A basic set-up:

`$ tabbed surf -e`

Note that to achieve a similar effect to Firefox or Chromium where upon closing the last tab, the browser exits, use
instead:

`$ tabbed -c surf -e`

See man page `{{man|1|tabbed|url=https://manpages.debian.org/latest/suckless-tools/tabbed.1.en.html}}`{=mediawiki} for
more details and possibilities.

## Troubleshooting

### Fuzzy font in Github {#fuzzy_font_in_github}

Install `{{Pkg|gnu-free-fonts}}`{=mediawiki} or add this in your `{{ic|~/.config/fontconfig/fonts.conf}}`{=mediawiki}
inside the fontconfig-tags:

` ``<selectfont>`{=html}\
`   ``<rejectfont>`{=html}\
`     ``<pattern>`{=html}\
`       ``<patelt name="family">`{=html}\
`         ``<string>`{=html}`Clean``</string>`{=html}\
`       ``</patelt>`{=html}\
`     ``</pattern>`{=html}\
`   ``</rejectfont>`{=html}\
` ``</selectfont>`{=html}

## See also {#see_also}

-   [surf\'s official website](https://surf.suckless.org/)
-   [dmenu](dmenu "wikilink") - Simple application launcher from the developers of dwm
-   [Hacking surf thread](https://bbs.archlinux.org/viewtopic.php?id=167804/)

[Category:Web browser](Category:Web_browser "wikilink") [Category:Suckless](Category:Suckless "wikilink")

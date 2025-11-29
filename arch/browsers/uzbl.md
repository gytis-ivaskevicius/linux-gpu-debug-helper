[ja:Uzbl](ja:Uzbl "wikilink") [Uzbl](http://www.uzbl.org/) is a lightweight browser based on **uzbl-core**. **Uzbl**
adheres to the UNIX philosophy of \"Write programs that do one thing and do it well\". The uzbl-browser package includes
uzbl-core, uzbl-browser and uzbl-event-manager. Most users will want to use **uzbl-browser** or **uzbl-tabbed** as they
provide the fullest set of tools for browsing. Uzbl-browser allows for a single page per window (with as many windows as
you want), while uzbl-tabbed provides a wrapper for uzbl-browser and implements basic tabs with multiple pages per
window.

## Installation

[Install](Install "wikilink") the `{{AUR|uzbl-browser-next-git}}`{=mediawiki} or
`{{AUR|uzbl-tabbed-next-git}}`{=mediawiki} package.

Thanks to `{{AUR|webkitgtk}}`{=mediawiki}, uzbl can make use of NPAPI plugins: installing
`{{AUR|flashplugin}}`{=mediawiki} or `{{Pkg|icedtea-web}}`{=mediawiki} will enable their use in uzbl-browser and
uzbl-tabbed.

## Commands

One of the biggest advantages of using Uzbl is that nearly everything can be controlled by the keyboard. This is
preferable to the traditional mouse/keyboard combo because less moving around of the hands is needed.
[Vim](Vim "wikilink") users will find Uzbl much easier to pick-up, especially as the default bindings loosely resemble
Vim keystrokes. For instance, following a link requires the user to type `{{Ic|fl}}`{=mediawiki}, and then the
keystrokes in the box that appears next to each link on the page. Shortening the command to just `{{Ic|f}}`{=mediawiki}
in the configuration file allows for even faster navigation.

Below are basic, default commands that can be used with uzbl-browser and uzbl-tabbed. These commands can all be found in
`{{ic|$XDG_CONFIG_HOME/uzbl/config}}`{=mediawiki} (which is usually located in
`{{ic|~/.config/uzbl/config}}`{=mediawiki}). The default settings work well, but many users like to edit them to suit
their preferences and in fact, it is encouraged to change this file to suit your needs. More help with editing the
configuration file can be found on [the Uzbl readme](http://www.uzbl.org/readme.php).

### Navigation

  Command   Doing what
  --------- -------------------------------------------------------------------------------------------
  o         enter url
  O         edit url
  b         back
  m         forward
  S         stop
  r         reload
  R         reload ignoring cache
  fl        spawn numbers next to each hyperlink. Type the number after typing fl to follow the link.
  gh        go home

### Page Movement {#page_movement}

  Command   Doing what
  --------- ----------------------------------
  j         scroll up
  k         scroll down
  h         scroll left
  l         scroll right
  PgUp      scroll page up
  ctrl+b    scroll page up
  PgDn      scroll page down
  ctrl+f    scroll page down
  Home      vertical beginning of the page
  \<\<      vertical beginning of the page
  End       vertical end of the page
  \>\>      vertical end of the page
  Space     vertical end of the page
  \^        horizontal beginning of the page
  \$        horizontal end of the page
  /         find in page
  ?         find backwards in page
  n         repeat find forward
  N         repeat find backwards

### Zooming

  Command   Doing what
  --------- --------------------
  \+        zoom_in
  \-        zoom_out
  T         toggle_zoom_type
  1         set zoom_level = 1
  2         set zoom_level = 2

### Searching

  Command   Doing what
  --------- ---------------------------
  ddg       search term in DuckDuckGo
  gg        search term in Google
  \\wiki    search term in Wikipedia

### Inserting Text {#inserting_text}

  Command   Doing what
  --------- -------------------------------------------------------------------------
  i         toggle_insert_mode (Esc works to go back to command mode much like vim)
  fi        go to the first input field and enter insert mode

### Bookmarks and History {#bookmarks_and_history}

  Command   Doing what
  --------- ------------------------------------------------------------------------
  M         insert bookmark (bookmarks are saved in \~/.local/share/uzbl/bookmarks
  U         load url from history via dmenu
  u         load url from bookmarks via dmenu

### Tabs (when using uzbl-tabbed) {#tabs_when_using_uzbl_tabbed}

  Command   Doing what
  --------- ---------------------
  go        load uri in new tab
  gt        go to next tab
  gT        go to previous tab
  gn        open new tab
  gi+n      goto \'n\' tab
  gC        close current tab

### Other

  Command   Doing what
  --------- ----------------------
  t         show/hide status bar
  w         open new window
  ZZ        exit
  :         enter command
  Esc       back to normal mode
  ctrl+\[   back to normal mode

## Tips and tricks {#tips_and_tricks}

### Caching

Due to its lightweight nature, uzbl does NOT contain caching functionality. You can install [Squid](Squid "wikilink") to
speed up page loading.

## Troubleshooting

### Parcellite

Parcellite can cause problems at the time of selecting text under uzbl - just disable it.

### TLS certificates {#tls_certificates}

Per <https://bbs.archlinux.org/viewtopic.php?id=185014>, adjust the configuration file:

```{=mediawiki}
{{hc|~/.config/uzbl/config|
set ssl_ca_file /etc/ssl/cert.pem
set ssl_policy fail
}}
```
## See also {#see_also}

-   [Uzbl wiki with user configuration files and
    scripts](https://web.archive.org/web/20190207125844/https://www.uzbl.org/wiki/doku.php)
-   [Forum thread](https://bbs.archlinux.org/viewtopic.php?id=70700)
-   [Configuration file](https://github.com/Dieterbe/uzbl/raw/master/examples/config/config)

[Category:Web browser](Category:Web_browser "wikilink")

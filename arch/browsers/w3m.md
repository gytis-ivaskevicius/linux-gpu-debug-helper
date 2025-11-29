```{=mediawiki}
{{Lowercase title}}
```
[ja:W3m](ja:W3m "ja:W3m"){.wikilink} [pt:W3m](pt:W3m "pt:W3m"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|ELinks}}`{=mediawiki} `{{Related|Lynx}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}
[w3m](https://salsa.debian.org/debian/w3m) is a text-based web browser as well as a pager like
[more](Wikipedia:More_(command) "more"){.wikilink} or [less](less "less"){.wikilink}. With w3m you can browse web pages
through a [Terminal emulator](Terminal_emulator "Terminal emulator"){.wikilink} window. Moreover, w3m can be used as a
text formatting tool which typesets HTML into plain text.

## Installation

[Install](Install "Install"){.wikilink} the `{{Pkg|w3m}}`{=mediawiki} package.

## Usage

See `{{man|1|w3m}}`{=mediawiki}.

## Configuration

w3m can either be configured using the in-browser settings menu or by directly modifying its configuration files.

Some of the more advanced options are not available using the settings menu, so it is recommended editing the
configuration files themselves.

By default all configuration files reside in `{{ic|~/.w3m}}`{=mediawiki}.

`/etc/w3m/config` isn\'t exposed so `o` (= Option Setting Panel), `tab` until in an unselected setting (eg a `( )YES`),
`Enter` to select that, `tab` down to an `[OK]` and `Enter` on that to leave the panel. You will now have
`~/.w3m/config`.

## Tips and tricks {#tips_and_tricks}

### Vim keybinds {#vim_keybinds}

Replace `{{ic|~/.w3m/keymap}}`{=mediawiki} with a [custom
configuration](https://gist.githubusercontent.com/Lovebird-Connoisseur/a11b9dbc5c056d705d1f0e1053de35af/raw/92b30d2ca4cf67b5816146f86f5d920b4bdfc492/keymap).

### URL hints {#url_hints}

w3m supports [qutebrowser](qutebrowser "qutebrowser"){.wikilink}-like link navigation, simply navigate to your config
file and change the following line from `{{ic|display_link_number 0}}`{=mediawiki} to
`{{ic|display_link_number 1}}`{=mediawiki}.

And add `{{ic|keymap f COMMAND "RESHAPE ; LINK_BEGIN ; GOTO_LINK"}}`{=mediawiki} and
`{{ic|keymap F COMMAND "RESHAPE ; LINK_BEGIN ; TAB_LINK"}}`{=mediawiki} to `{{ic|~/.w3m/keymap}}`{=mediawiki}.

```{=mediawiki}
{{Note|While qutebrowser supports a variety of keys to select hints, in w3m you can only select links using the number keys.}}
```
### Using kittens image protocol {#using_kittens_image_protocol}

Users of the [kitty](kitty "kitty"){.wikilink} terminal emulator may chose to use its own [graphics
protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/).

To do so simply change the following lines in `{{ic|~/.w3m/config}}`{=mediawiki}:

`inline_img_protocol 0`\
`imgdisplay w3mimgdisplay`

to:

`inline_img_protocol 4`\
`imgdisplay kitty`

### Using Iterm2 image protocol {#using_iterm2_image_protocol}

Users of the [wezterm](wezterm "wezterm"){.wikilink} terminal emulator may chose to use the [Iterm2 graphics
protocol](https://wezfurlong.org/wezterm/imgcat.html)`{{Dead link|2025|03|15|status=404}}`{=mediawiki} which WezTerm
supports.

To do so simply change the following lines in `{{ic|~/.w3m/config}}`{=mediawiki}:

`inline_img_protocol 0`\
`imgdisplay w3mimgdisplay`

to:

`inline_img_protocol 3`\
`imgdisplay iterm2`

### Searching

You can set `{{ic|wrap_search}}`{=mediawiki} to 1, to allow searches to jump to the top after they have hit the bottom
of all matches within a page.

You can set `{{ic|ignorecase_search}}`{=mediawiki} to 1 to enable case insensitive searching.

```{=mediawiki}
{{Note|Unlike other browsers and text editors, w3m has no option for smartcase searching.}}
```
### Custom search engines {#custom_search_engines}

You can map keys to launch a CGI script that will capture your input and pass it onto a custom search engine, to do so
first create a keybind inside `{{ic|~/.w3m/keymap}}`{=mediawiki} to launch your script:

`keymap s COMMAND "SET_OPTION dictcommand=`[`file:///cgi-bin/omnibar_google.cgi`](file:///cgi-bin/omnibar_google.cgi)` ; DICT_WORD"`

And place
[omnibar_google.cgi](https://raw.githubusercontent.com/gotbletu/shownotes/master/w3m_omnibar/omnibar_google.cgi) inside
your `{{ic|~/.w3m/cgi-bin}}`{=mediawiki} directory and giving it execute permission.

While the above script will return a Google result, you can use these kinds of scripts to search StackOverflow, GitHub,
DuckDuckGo, Reddit and a bunch of other websites.

You can view similar scripts on [GitHub](https://github.com/gotbletu/shownotes/tree/master/w3m_omnibar).

### Reader mode {#reader_mode}

Some webpages do not work well with w3m, be it because they use a lot of javascript or CSS to display most of their
content. Very often you will have to scroll multiple pages just to get to the start of an article.

This can be mitigated by first passing the webpages through a reader mode program such as
`{{AUR|rdrview-git}}`{=mediawiki}.

To do so add the following to `{{ic|~/.w3m/keymap}}`{=mediawiki}:

`keymap R COMMAND "READ_SHELL 'rdrview $W3M_URL -H 2> /dev/null 1> /tmp/readable.html' ; LOAD /tmp/readable.html"`

### Redirect URLs {#redirect_urls}

```{=mediawiki}
{{ic|~/.w3m/siteconf}}
```
file is used to set some preferences depending on the website, such as: referrer and user agent.

It can also be used to redirect to lighter (both in terms of layout and bandwidth), more privacy respecting alternatives
to websites.

In addition to this it can also be used to run certain CGI scripts.

```{=mediawiki}
{{hc|~/.w3m/siteconf|<nowiki>
url m!^https?://([a-z]+\.)?twitter\.com/!
substitute_url "https://nitter.net/"

url m!^https?://([a-z]+\.)?reddit\.com/!
substitute_url "https://safereddit.com/"

#url m!^https?://([a-z]+\.)?google\.com/!
#substitute_url "https://duckduckgo.com/lite/"

url m!^https?://([a-z]+\.)?imgur\.com/!
substitute_url "https://rimgo.pussthecat.org/"

url m!^https?://([a-z]+\.)?wikipedia\.com/!
substitute_url "https://wl.vern.cc/"

url "https://www.youtube.com/" exact
substitute_url "file:/cgi-bin/video.cgi?"
#substitute_url "https://yewtu.be/"

url "https://stackoverflow.com/" exact
substitute_url "https://ao.bloatcat.tk/"

url "https://www.reuters.com/" exact
substitute_url "https://neuters.de/"

url "https://fandom.com/" exact
substitute_url "https://breezewiki.pussthecat.org/"

url "https://medium.com/" exact
substitute_url "https://scribe.rip/"

url "https://web.archive.org/" exact
substitute_url "https://wayback-classic.net/"
</nowiki>}}
```
### Restore closed windows {#restore_closed_windows}

Default w3m cannot reopen closed tabs, this can be added by binding the close tab button to echo the current URL of the
tab to be closed to a text file, and binding another key to restore the latest URL added to the file, using a CGI
script.

Inside `{{ic|~/.w3m/keymap}}`{=mediawiki} add:

`keymap d COMMAND "EXTERN 'echo %s >> ~/.w3m/RestoreTab.txt' ; CLOSE_TAB"`\
`keymap u COMMAND TAB_GOTO `[`file:/cgi-bin/restore_tab.cgi`](file:/cgi-bin/restore_tab.cgi)

Then place the following file inside `{{ic|~/.w3m/cgi-bin}}`{=mediawiki} and make it
[executable](executable "executable"){.wikilink}.

[restore_tab.cgi](https://raw.githubusercontent.com/felipesaa/A-vim-like-firefox-like-configuration-for-w3m/master/root-cgi-bin/restore_tab.cgi)

### Opening magnet links {#opening_magnet_links}

[magnet.cgi](https://raw.githubusercontent.com/gotbletu/shownotes/master/w3m_plugins/cgi-bin/magnet.cgi) can be used to
make w3m auto open magnet links using [Transmission](Transmission "Transmission"){.wikilink}.

### Fingerprinting

#### Using tor {#using_tor}

You can use `{{man|1|torify}}`{=mediawiki} to route w3m traffic through `{{Pkg|tor}}`{=mediawiki}.

`$ torify w3m -v`

#### User agent and headers {#user_agent_and_headers}

By default w3m uses its own user agent, meaning w3m users stand out amongst other users.

Fingerprint can be reduced by using a more generic user agent, language and http_accept header.

```{=mediawiki}
{{hc|~/.w3m/config|2=
user_agent Mozilla/5.0 (Windows NO 10.0; rev:91.0) Gecko/20100101 Firefox91.0
no_referer 1
cross_origin_referer 0
accept_language en-US,en;q=0.5
accept_encoding gzip, deflate
accept_media text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
}}
```
#### Disable cookies {#disable_cookies}

To disable cookies set `{{ic|use_cookie}}`{=mediawiki} to 0 in `{{ic|~/.w3m/config}}`{=mediawiki}.

#### Disable cache {#disable_cache}

To disable cache set `{{ic|no_cache}}`{=mediawiki} to 1 in `{{ic|~/.w3m/config}}`{=mediawiki}.

## Troubleshooting

### Images flickering/causing lag {#images_flickeringcausing_lag}

Unfortunately, sometimes w3m lags when trying to scroll past an image, to the point where the browser can become
unresponsive for multiple seconds.

A solution to this is outright disabling images, but this breaks some websites (for example, hacker news relies on GIFs
for comment indentation).

A more elegant solution would be to make a keybind to toggle images on or off, to do so add the following line to
`{{ic|~/.w3m/keymap}}`{=mediawiki}:

`keymap i COMMAND "SET_OPTION display_image=toggle ; RESHAPE"`

## See also {#see_also}

- [Homepage](https://w3m.sourceforge.net/)
- [Github repository](https://github.com/tats/w3m)
- [w3m.rocks](http://www.w3m.rocks/)
- [A vim-like configuration for w3m](https://github.com/felipesaa/A-vim-like-firefox-like-configuration-for-w3m)
- [w3m plugins](https://github.com/gotbletu/shownotes/tree/master/w3m_plugins/cgi-bin)

[Category:Web browser](Category:Web_browser "Category:Web browser"){.wikilink}

[de:Elinks](de:Elinks "de:Elinks"){.wikilink} [es:ELinks](es:ELinks "es:ELinks"){.wikilink}
[fr:ELinks](fr:ELinks "fr:ELinks"){.wikilink} [ja:ELinks](ja:ELinks "ja:ELinks"){.wikilink}
[pt:Elinks](pt:Elinks "pt:Elinks"){.wikilink} [ELinks](http://elinks.or.cz/) is an advanced and well-established
feature-rich text mode web (HTTP/FTP/\...) browser. ELinks can render both frames and tables, is highly customizable and
can be extended via Lua or Guile scripts. It features tabs and some support for CSS.

## Installation

[Install](Install "Install"){.wikilink} the `{{Pkg|elinks}}`{=mediawiki} package.

## Usage

See `{{man|1|elinks}}`{=mediawiki}.

### Navigation

Navigating the web with a text browser is more or less the same as a graphical browser, just without the
\'distractions\'. Once you have started *elinks*, you can press `{{ic|g}}`{=mediawiki} and type in the web page you
would like to request. Then you can navigate the page using arrow keys to navigate by line, the space bar to navigate by
page, or the `{{ic|j}}`{=mediawiki} and `{{ic|k}}`{=mediawiki} keys to navigate by link.

```{=mediawiki}
{{Tip|To keep the original terminal session, ''elinks'' can be run in a separate [[Wikipedia:Virtual console|Virtual console]] (switch with {{ic|Alt+arrow}}) or with a [[Wikipedia:Terminal multiplexer|Terminal multiplexer]] such as [[tmux]].}}
```
## Configuration

ELinks provides to two menus, accessible through ELinks, to customize options and keybinds respectively.

It is recommended to use these tools as opposed to hand-editing the configuration files (which are placed in
`{{ic|~/.elinks}}`{=mediawiki}). It is both much easier and safer this way.

By default, the `{{ic|o}}`{=mediawiki} key opens the option manager and the `{{ic|k}}`{=mediawiki} key the
keybind-manager.

## Tips and tricks {#tips_and_tricks}

### JavaScript (sort of) support {#javascript_sort_of_support}

```{=mediawiki}
{{Note|Users needing JavaScipt support in a terminal browser should consider using {{AUR|browsh}} instead of following this tip.}}
```
ELinks has an experimental feature called [ECMAScript](https://github.com/rkd77/elinks/blob/master/doc/ecmascript.txt)
which is a form of JavaScript. Currently, the repo package does not build with this, but a simple modification to the
PKGBUILD can provide it.

1.  Add `{{pkg|js128}}`{=mediawiki} and something that provides
    [xxd](List_of_applications/Utilities#Hex_dumpers "xxd"){.wikilink} such as `{{pkg|vim}}`{=mediawiki} to the depends
    array.
2.  Add the following to the arch-meson bit in the package function: `<nowiki>`{=html}-D spidermonkey=true \\
3.  `</nowiki>`{=html}

Once built, it must be enabled in elinks either by navigating to the options section or directly modifying
`{{ic|~/.config/elinks/elinks.conf}}`{=mediawiki} to contain: set ecmascript.enable = 1

ECMAScript is not perfect and may not provide full JavaScript functionality.

### Defining URL-handlers {#defining_url_handlers}

ELinks is capable of using external programs for various tasks,

Defining URL-handlers through the option menu can be a little confusing at first, but once you get it, it is fine.

To do this, go into the option manager and navigate to *MIME*. All the submenus have **I**nfo pages to help you.

This is one of the few cases where it might be easier just to edit the configuration file.

For example, to get ELinks to automatically launch your image-viewer when you click on a JPEG file, you can add the
following to your `{{ic|~/.elinks/elinks.conf}}`{=mediawiki} file,

```{=mediawiki}
{{hc|~/.elinks/elinks.conf|2=set mime.extension.jpg="image/jpeg"
set mime.extension.jpeg="image/jpeg"
set mime.extension.png="image/png"
set mime.extension.gif="image/gif"
set mime.extension.bmp="image/bmp"

set mime.handler.image_viewer.unix.ask = 1
set mime.handler.image_viewer.unix-xwin.ask = 0

set mime.handler.image_viewer.unix.block = 1
set mime.handler.image_viewer.unix-xwin.block = 0

set mime.handler.image_viewer.unix.program = "''pictureviewer'' %"
set mime.handler.image_viewer.unix-xwin.program = "''pictureviewer'' %"

set mime.type.image.jpg = "image_viewer"
set mime.type.image.jpeg = "image_viewer"
set mime.type.image.png = "image_viewer"
set mime.type.image.gif = "image_viewer"
set mime.type.image.bmp = "image_viewer"}}
```
### Tor usage {#tor_usage}

ELinks does not support [using a SOCKS proxy](using_a_SOCKS_proxy "using a SOCKS proxy"){.wikilink} directly.
Alternatives are to either invoke ELinks through `{{ic|[[tor#Torsocks|torsocks]] elinks}}`{=mediawiki}, or
[install](install "install"){.wikilink} the [privoxy](privoxy "privoxy"){.wikilink} package for forwarding to
[Tor](Tor "Tor"){.wikilink}\'s SOCKS proxy, first by adding the following line to your
`{{ic|/etc/privoxy/config}}`{=mediawiki}:

`forward-socks5 / localhost:9050 .`

[Restart](Restart "Restart"){.wikilink} `{{ic|privoxy.service}}`{=mediawiki}, then enter the following lines to your
`{{ic|~/.elinks/elinks.conf}}`{=mediawiki}:

`set protocol.http.proxy.host = "127.0.0.1:8118"`\
`set protocol.https.proxy.host = "127.0.0.1:8118"`

```{=mediawiki}
{{Note|The above assumes that ''Tor'' is using port '''9050''' and that ''privoxy'' is listening on port '''8118'''.}}
```
### Passing URL\'s to external commands {#passing_urls_to_external_commands}

You can define commands which ELinks will pass the current URL to.

To do this, go into the options menu, navigate under **Document**, then to **URI-passing**. Then press
`{{ic|a}}`{=mediawiki} to add a new command name. Then navigate to the new command name and press `{{ic|e}}`{=mediawiki}
to edit. Type in the name of command, enter and save.

Assuming the command \"tab-external-command\" is mapped to **KEY**, whenever you press **KEY**, a menu containing your
commands will appear. Select the one you want, and ELinks passes the current URL to that command.

```{=mediawiki}
{{Note|Elinks allows you to define your own mappings for navigating this menu.}}
```
#### Saving link to the X clipboard {#saving_link_to_the_x_clipboard}

`echo -n %c | xclip -i`

#### Passing YouTube-links through external player {#passing_youtube_links_through_external_player}

For strictly YouTube-links, `{{Pkg|mpv}}`{=mediawiki} has built-in support. Just use the following:

`mpv %c`

For a more general approach that can handle many \'tube\' sites, you will need `{{AUR|youtube-dl}}`{=mediawiki}. Then
add the following command,

`youtube-dl -o - %c | mplayer -`

## Troubleshooting

### ELinks froze and I cannot start it without it freezing again {#elinks_froze_and_i_cannot_start_it_without_it_freezing_again}

By default, every time you start ELinks you are connecting to an existing instance. Thus, if that instance freezes, all
current and future instances will freeze as well.

You can prevent ELinks from connecting to an existing instance by starting it like so:

`$ elinks -no-connect`

If this happens a lot, you might consider making this your default startup by making an alias in your shell:

`alias elinks="elinks -no-connect"`

## See also {#see_also}

- [Official web site](http://elinks.or.cz/)
- [Howto: Use elinks like a pro](https://kmandla.wordpress.com/2007/05/06/howto-use-elinks-like-a-pro/)

[Category:Web browser](Category:Web_browser "Category:Web browser"){.wikilink}

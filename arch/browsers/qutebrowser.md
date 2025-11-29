```{=mediawiki}
{{Lowercase title}}
```
[ja:Qutebrowser](ja:Qutebrowser "ja:Qutebrowser"){.wikilink}
[pl:Qutebrowser](pl:Qutebrowser "pl:Qutebrowser"){.wikilink}
[es:Qutebrowser](es:Qutebrowser "es:Qutebrowser"){.wikilink} [qutebrowser](https://github.com/qutebrowser/qutebrowser)
is a keyboard-focused web browser written in Python and Qt. It uses the chromium web engine.

## Installation

[Install](Install "Install"){.wikilink} the `{{Pkg|qutebrowser}}`{=mediawiki} package.

## Basic usage {#basic_usage}

Use `{{ic|:}}`{=mediawiki} to access the command prompt. You can use `{{ic|Tab}}`{=mediawiki} to auto-complete.

On first usage of qutebrowser, a Quickstart page appears. It is later accessible via `{{ic|:help}}`{=mediawiki}. See the
[cheatsheet](https://qutebrowser.org/img/cheatsheet-big.png) for keyboard shortcuts.

### User configuration {#user_configuration}

Qutebrowser can be configured via the UI, the command-line or a Python script. See [upstream configuration
guide](https://qutebrowser.org/doc/help/configuring.html).

Configuration done through the UI will automatically be stored in `{{ic|autoconfig.yml}}`{=mediawiki} (don\'t edit it
manually). For manual configuration, user can write a `{{ic|config.py}}`{=mediawiki}. Both files are located in
`{{ic|$XDG_CONFIG_HOME/qutebrowser}}`{=mediawiki} or fallback `{{ic|$HOME/.config/qutebrowser}}`{=mediawiki}.

#### Configuration in qutebrowser {#configuration_in_qutebrowser}

```{=mediawiki}
{{Note|Configuration done through the UI ({{ic|:set}}, {{ic|:bind}}, {{ic|:unbind}}) won't load automatically if {{ic|config.py}} exists. To load it, put {{ic|config.load_autoconfig()}} in {{ic|config.py}} [https://qutebrowser.org/doc/help/configuring.html#configpy-autoconfig].}}
```
To set a single configuration item, you can simply type `{{ic|:set}}`{=mediawiki} followed by the name of the
configuration item and the new value that you would like to set. For example, you could type

`:set auto_save.session true`

to open your previous tabs when you reopen qutebrowser.

To open qutebrowser\'s UI settings page, type

`:set`

without further arguments. There, you can edit the different settings in the UI. When you are finished, type
`{{ic|:set}}`{=mediawiki} again to store your configuration.

For example, under `{{ic|url.searchengines}}`{=mediawiki} you can configure your search engines which are stored as a
list of key-value pairs. When you have not changed this setting yet, this should look something like

`{"DEFAULT": "https://duckduckgo.com/?q={}"}`

This configures DuckDuckGo as your default search engine while the placeholder `{{ic|<nowiki>{}</nowiki>}}`{=mediawiki}
will be replaced by your search term. To add a shortcut for quickly searching the Arch Linux wiki, you could use

`{"DEFAULT": "https://duckduckgo.com/?q={}", "wa": "https://wiki.archlinux.org/?search={}"}`

Then, as described by the comment in the qutebrowser UI, you can search the Arch Linux wiki by typing
`{{ic|o wa <searchterm>}}`{=mediawiki}. Notice that the arguments required to perform a search vary across search
engines. For example, to set up Google, use
`{{ic|<nowiki>https://www.google.com/search?hl=en&q={}</nowiki>}}`{=mediawiki}. Or to set up Brave Search, use
`{{ic|<nowiki>https://search.brave.com/search?q={}</nowiki>}}`{=mediawiki}.

If Tor is installed and running on your system and you wish to use DuckDuckGo onion page instead, the setting should be
something like

`{"DEFAULT": "https://duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion/?q={}", "wa": "https://wiki.archlinux.org/?search={}"}`

#### Keybindings

You can edit the keybindings directly from the browser with the command `{{ic|:bind ''key'' ''command''}}`{=mediawiki}
or you can edit them directly from the file. Notice that there are many, many keybinds already in place. If you notice a
lag on one of your keybind it is because some other keybind is also starting with the same key.

See the [documentation](https://qutebrowser.org/doc/help/configuring.html#_binding_keys) for examples.

### Video playback {#video_playback}

You can add an option in your `{{ic|config.py}}`{=mediawiki} to open a video in *mpv*, in the following example pressing
`{{ic|Ctrl+/}}`{=mediawiki} will bring up all the available video links on the page, then simply press the corresponding
key combination for the video link you require and it will open it up in mpv

```{=mediawiki}
{{hc|config.py|
...
config.bind('<Ctrl+/>', 'hint links spawn --detach mpv {hint-url}')
...
}}
```
## Tips and tricks {#tips_and_tricks}

### Importing quickmarks/bookmarks {#importing_quickmarksbookmarks}

Qutebrowser supports importing bookmarks from several formats via the python script
`{{ic|/usr/share/qutebrowser/scripts/importer.py}}`{=mediawiki}. The default output format is qutebrowser\'s quickmarks
format. For a short explanation of the differences between bookmarks and quickmarks see the [qutebrowser
FAQ](https://qutebrowser.org/doc/faq.html).

#### From Chromium/Chrome {#from_chromiumchrome}

Run the script mentioned above specifying `{{ic|chromium}}`{=mediawiki} as the first argument and the directory
containing the bookmarks file as the second argument. For Chromium this is
`{{ic|~/.config/chromium/Default}}`{=mediawiki} and `{{ic|~/.config/google-chrome/Default}}`{=mediawiki} for Chrome. The
output of the script can be appended to `{{ic|~/.config/qutebrowser/quickmarks}}`{=mediawiki}. Some of the input formats
are explained below. Additional information can be found by supplying the `{{ic|-h}}`{=mediawiki} flag to
`{{ic|importer.py}}`{=mediawiki}.

`$ python /usr/share/qutebrowser/scripts/importer.py chromium ~/.config/chromium/Default >> ~/.config/qutebrowser/quickmarks`

#### From Firefox {#from_firefox}

Export Firefox bookmarks to an an HTML file (see
[1](https://support.mozilla.org/en-US/kb/export-firefox-bookmarks-to-backup-or-transfer)). Then, use the script to
import.

`$ python /usr/share/qutebrowser/scripts/importer.py bookmarks.html >> ~/.config/qutebrowser/quickmarks`

#### From bookmarks.html file {#from_bookmarks.html_file}

The import from a `{{ic|bookmarks.html}}`{=mediawiki} file requires the package
`{{pkg|python-beautifulsoup4}}`{=mediawiki}. To import you just supply your `{{ic|bookmarks.html}}`{=mediawiki} file to
`{{ic|importer.py}}`{=mediawiki} and append the output to `{{ic|~/.config/qutebrowser/quickmarks}}`{=mediawiki}.

`$ python /usr/share/qutebrowser/scripts/importer.py ~/.config/chromium/Default >> ~/.config/qutebrowser/quickmarks`

#### Import as bookmarks instead of quickmarks {#import_as_bookmarks_instead_of_quickmarks}

You can use any of the above mentioned methods and supply an additional `{{ic|-b}}`{=mediawiki} flag to change the
output format of the script to bookmarks. The output should then be appended to
`{{ic|~/.config/qutebrowser/bookmarks/urls}}`{=mediawiki}.

`$ python /usr/share/qutebrowser/scripts/importer.py -b chromium ~/.config/chromium/Default >> ~/.config/qutebrowser/bookmarks/urls`

Note that the flag must be added before the browser specification.

### Automatically enter login information {#automatically_enter_login_information}

You can use the [qute-pass](https://github.com/qutebrowser/qutebrowser/blob/master/misc/userscripts/qute-pass)
userscript to [automatically enter](https://i.imgur.com/KN3XuZP.gif) login information stored in your
[Pass](Pass "Pass"){.wikilink} password-store. You will need a [dmenu](dmenu "dmenu"){.wikilink}-compatible [application
launcher](List_of_applications/Other#Application_launchers "application launcher"){.wikilink} and
`{{Pkg|python-tldextract}}`{=mediawiki}. Set up a keybinding which executes
`{{ic|:spawn --userscript qute-pass}}`{=mediawiki}.

```{=mediawiki}
{{Style|The quote should be part of the userscript's {{ic|--help}} page if it is so prominent.}}
```
To quote from the script\'s description:

`The domain of the site has to appear as a segment in the pass path, for example: "github.com/cryzed" or "websites/github.com". How the username and password are determined is freely configurable using the CLI arguments. The login information is inserted by emulating key events using qutebrowser's fake-key command in this manner: [USERNAME]``<Tab>`{=html}`[PASSWORD], which is compatible with almost all login forms.`

To further clarify, the pass-structure that is used by default should look something like this:

{{ hc\| user@computer\$ pass \|

`Password Store `\
`├── example.site1.com `\
`│   └── username `\
`├── example.site2.com `\
`│   └── username1 `\
`│   └── username2 `

}}

This means is that each website is a directory in your \~/.password-store folder. Within each website-named directory is
where the files are titled username.gpg, username2.pgp, etc. and each file contains the password associated with each
username for the website. For those of you migrating from Firefox, a [modified version of
firefox_decrypt](https://github.com/johnabs/firefox_decrypt) should migrate things in this format.

The userscript provides many options to accomodate most workflows and special circumstances (such as only wanting to
insert the password or the regular method of inserting the username and password not working).

### Turn on spell checking {#turn_on_spell_checking}

First, download the appropriate dictionary using the `{{ic|dictcli.py}}`{=mediawiki} script that comes bundled with
qutebrowser.

For example, for English (US):

`$ /usr/share/qutebrowser/scripts/dictcli.py install en-US`

The script has other features too, which can be shown by using `{{ic|--help}}`{=mediawiki}.

Then set the following in qutebrowser:

`:set spellcheck.languages ["en-US"]`

### Minimize fingerprinting {#minimize_fingerprinting}

Websites may be able to identify you based on combining information on screen size, user-agent, HTTP_ACCEPT headers, and
more. See [2](https://panopticlick.eff.org/) for more information and to test the uniqueness of your browser. Below are
a few steps that can be taken to make your qutebrowser installation more \"generic\".

Additionally see
[Firefox/Privacy#Configuration](Firefox/Privacy#Configuration "Firefox/Privacy#Configuration"){.wikilink} for more
ideas.

#### Set a common user-agent {#set_a_common_user_agent}

Several user agents are available as options when using `{{ic|set content.headers.user_agent}}`{=mediawiki}. Another,
possibly more generic user-agent is:

`Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0`

```{=mediawiki}
{{Note|
* You may want to change {{ic|Windows NT 10.0}} by {{ic|X11; Linux x86_64}}, since websites can also gather your platform type via Javascript, and this setting cannot be changed in qutebrowser.
* Changing your user-agent away from the default will prevent some websites from working properly. For example, CAPTCHA will mention your browser is not supported if the user agent is listed as an out-of-date browser.}}
```
#### Set a common HTTP_ACCEPT header {#set_a_common_http_accept_header}

The following is a common HTTP_ACCEPT header (Firefox default). Simply type the following commands at the prompt

`set content.headers.accept_language en-US,en;q=0.5`\
`set content.headers.custom '{"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}'`

#### Disable reading from canvas {#disable_reading_from_canvas}

`set content.canvas_reading false`

```{=mediawiki}
{{Note|Some websites depend on canvas reading for content rendering and other functionality. Adding this option may cause them to not work properly [https://github.com/qutebrowser/qutebrowser/issues/2908].}}
```
#### Disable WebGL {#disable_webgl}

Set `{{ic|content.webgl}}`{=mediawiki} to `{{ic|false}}`{=mediawiki} to disable WebGL.

### Disable websites {#disable_websites}

Create `{{ic|~/.config/qutebrowser/blocked-hosts}}`{=mediawiki} and enter websites you want to block in each line;
`{{ic|www.youtube.com}}`{=mediawiki} for example. This will keep the built-in adblock list while adding the websites in.
Restart qutebrowser, and run `{{ic|:adblock-update}}`{=mediawiki}.

### Enable Brave browser adblocker {#enable_brave_browser_adblocker}

Install the `{{Pkg|python-adblock}}`{=mediawiki} package and enable the adblocker within qutebrowser:

`:set content.blocking.method both`

### Open some links in mpv {#open_some_links_in_mpv}

To open some specific links in mpv (like YouTube, reddit, etc) instead of loading the webpage. This can be used to
bypass ads, tracking, etc. You can of course replace mpv by the video player of your choice.

`:bind M hint links spawn mpv {hint-url}`

### Enable darktheme everywhere {#enable_darktheme_everywhere}

`:set colors.webpage.darkmode.enabled true`

### Disable javascript {#disable_javascript}

`:set content.javascript.enabled false`

### Route the traffic through tor {#route_the_traffic_through_tor}

This requires [tor](tor "tor"){.wikilink} to be enabled and running. Note this is only using the tor proxy but does not
provide you any protection from fingerprinting you might have on tor browser.

`:set content.proxy socks://localhost:9050/`

### Change the context menu theme {#change_the_context_menu_theme}

To change the context menu theme, find the relevant section of your `{{ic|config.py}}`{=mediawiki} and set the
[appropriate settings](https://www.qutebrowser.org/doc/help/settings.html#colors.contextmenu.disabled.bg). For example:

```{=mediawiki}
{{hc|config.py|2=
...
c.colors.contextmenu.disabled.fg = '#808080'
c.colors.contextmenu.menu.bg = '#353535'
c.colors.contextmenu.menu.fg = '#ffffff'
c.colors.contextmenu.selected.bg = '#909090'
...
}}
```
### Integrate with KeePassXC {#integrate_with_keepassxc}

Qutebrowser ships with
[qute-keepassxc](https://github.com/qutebrowser/qutebrowser/blob/master/misc/userscripts/qute-keepassxc) for integration
with [KeePassXC](KeePassXC "KeePassXC"){.wikilink}.

To integrate with KeePassXC:

1.  Enable KeepassXC-Browser extensions in your KeepassXC config.\
    From KeePassXC go to Tools-\>Settings-\>Browser Integration, and check \"Enable browser integration\".
2.  Make sure to have a working private-public-key-pair in your GPG keyring.\
    Find your secret keys with `{{ic|gpg --list-secret-keys --keyid-format{{=}}`{=mediawiki}long}}. The key must be
    trusted, e.g. it should contain \"\[ultimate\]\" in the \"uid\" field.\
    If it is not trusted, you can trust it with `{{ic|gpg --edit-key KEYID}}`{=mediawiki}, then
    `{{ic|trust}}`{=mediawiki}, `{{ic|5}}`{=mediawiki} (ultimate trust) and confirm.\
    Finally, copy the key id.
3.  Install the package `{{Pkg|python-pynacl}}`{=mediawiki}
4.  Adapt your qutebrowser config.\
    You can e.g. add the following lines to your `{{ic|~/.config/qutebrowser/config.py}}`{=mediawiki}. Remember to
    replace \`ABC1234\` with your actual GPG key id.

```{=mediawiki}
{{hc|config.py|
config.bind('<Alt-Shift-u>', 'spawn --userscript qute-keepassxc --key ABC1234', mode{{=}}
```
\'insert\') config.bind(\'pw\', \'spawn \--userscript qute-keepassxc \--key ABC1234\', mode{{=}}\'normal\') }} To manage
multiple accounts you also need [rofi](rofi "rofi"){.wikilink} installed.

## Troubleshooting

### Unreadable tooltips {#unreadable_tooltips}

Depending on your Qt theme, tooltips might be hard to read. In order to fix this, create a Qt Style Sheet file. For
example: `{{hc|head=~/.local/share/qutebrowser/fix-tooltips.qss|output=<nowiki>
QToolTip {
    background-color: palette(highlight);
    border: 2px solid palette(highlight);
    color: palette(text);
}</nowiki>}}`{=mediawiki}

Then load the style sheet when launching qutebrowser:

`qutebrowser --qt-arg stylesheet ~/.local/share/qutebrowser/fix-tooltips.qss`

```{=mediawiki}
{{Note|The style sheet will not be applied if there is an instance of qutebrowser already running.}}
```
```{=mediawiki}
{{Tip|You can use a [[Desktop entries#Application entry|desktop entry]] to create a convenient launcher when specifying extra arguments, such as in this instance.}}
```
See the [bug report](https://github.com/qutebrowser/qutebrowser/issues/4520) for details.

The bug report offers [another method](https://github.com/qutebrowser/qutebrowser/issues/4520#issuecomment-584115754)
using `{{ic|qt5ctl}}`{=mediawiki} that does not require arguments at launch:

1.  In qutebrowser, `{{ic|:set qt.force_platformtheme qt5ctl}}`{=mediawiki}
2.  In `{{ic|qt5ct}}`{=mediawiki}, set style: gtk2, standard dialogs: gtk2, palette: default
3.  Change to Style Sheets tab, and create a new file (I called it `{{ic|tooltip-gtk2.qss}}`{=mediawiki} but it should
    not matter)
4.  Put the following contents inside: `{{bc|<nowiki>QToolTip{
        background: QLinearGradient(x1: 0, y1: 0, x2: 0, y2: 0, stop: 0 palette(window), stop: 1 palette(alternate-window));
        border-radius: 3px;
        border: 1px solid #000000;
        padding: 1px;
        color: palette(text);
    }</nowiki>}}`{=mediawiki}
5.  Click Save then Ok
6.  Make sure to check the box next to this new file so that it will be applied to the theme
7.  Click Apply

## See also {#see_also}

- [GitHub repository](https://github.com/qutebrowser/qutebrowser)
- [Homepage](https://qutebrowser.org/)
- [BBS thread](https://bbs.archlinux.org/viewtopic.php?id=191076)
- [New configuration example](https://hg.sr.ht/~jasonwryan/shiv/browse/.config/qutebrowser/config.py)

[Category:Web browser](Category:Web_browser "Category:Web browser"){.wikilink}

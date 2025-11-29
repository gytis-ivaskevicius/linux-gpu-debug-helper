[de:Vivaldi](de:Vivaldi "de:Vivaldi"){.wikilink} [es:Vivaldi](es:Vivaldi "es:Vivaldi"){.wikilink}
[ja:Vivaldi](ja:Vivaldi "ja:Vivaldi"){.wikilink} [pl:Vivaldi](pl:Vivaldi "pl:Vivaldi"){.wikilink}
[pt:Vivaldi](pt:Vivaldi "pt:Vivaldi"){.wikilink} [ru:Vivaldi](ru:Vivaldi "ru:Vivaldi"){.wikilink}
[zh-hans:Vivaldi](zh-hans:Vivaldi "zh-hans:Vivaldi"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|Chromium}}`{=mediawiki} `{{Related|Firefox}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[Vivaldi](https://vivaldi.com/) is a proprietary web browser from former [Opera](Opera "Opera"){.wikilink} founder &
team members, based on [Chromium](Chromium "Chromium"){.wikilink} and focused on personalization aspects.

## Installation

Vivaldi can be [installed](install "install"){.wikilink} with `{{pkg|vivaldi}}`{=mediawiki} or
`{{AUR|vivaldi-snapshot}}`{=mediawiki}. Prebuilt packages can alternatively be found in the
[herecura](Unofficial_user_repositories#herecura "herecura"){.wikilink} unofficial repository. For differences between
snapshot and stable versions, see [this page](https://vivaldi.com/blog/snapshot-vs-stable/).

To use [Qt](Qt "Qt"){.wikilink} instead of [GTK](GTK "GTK"){.wikilink} dialogs for file selections just install
`{{Pkg|kdialog}}`{=mediawiki}.

## Extensions

Vivaldi is compatible with most of Chrome\'s extensions. These can be installed directly from the [Chrome Web
Store](https://chrome.google.com/webstore/category/extensions).

```{=mediawiki}
{{Tip|Vivaldi supports appending '''proxy server''' parameters to the command line with {{ic|1=--proxy-server="socks5://127.0.0.1:1080"}}. This may help to solve network connectivity problems under certain conditions.}}
```
To see which extensions are installed/enabled, type `{{ic|vivaldi://extensions}}`{=mediawiki} in the address bar.

See also [Wikipedia:Google Chrome
Extension](Wikipedia:Google_Chrome_Extension "Wikipedia:Google Chrome Extension"){.wikilink}.

## Media playback {#media_playback}

Vivaldi automatically downloads `{{ic|$HOME/.local/lib/vivaldi/media-codecs-7.6/libffmpeg.so}}`{=mediawiki} and add
support of proprietary codecs e.g. H.264, AAC, etc\...

If you don\'t believe binary downloaded from somewhere, install `{{Pkg|vivaldi-ffmpeg-codecs}}`{=mediawiki},
`{{AUR|vivaldi-snapshot-ffmpeg-codecs}}`{=mediawiki} ([chromium
source](https://chromium.googlesource.com/chromium/third_party/ffmpeg/)) or `{{AUR|chromium-ffmpeg}}`{=mediawiki}
([ffmpeg.org source](https://git.ffmpeg.org/ffmpeg.git)).

Or install `{{pkg|ffmpeg}}`{=mediawiki} and

`ln -sf /usr/lib/libavformat.so.62 .local/lib/vivaldi/media-codecs-7.6/libffmpeg.so`

This avoids crushing external media player [1](https://github.com/mpv-player/mpv/issues/9875).

```{=mediawiki}
{{Note|The later method works only on Arch's patched {{pkg|ffmpeg}} and Vivaldi. }}
```
Restart Vivaldi after downloading *libffmpeg.so* or installing those packages.

## Making flags persistent {#making_flags_persistent}

```{=mediawiki}
{{Note|The {{ic|vivaldi-stable.conf}} file usage is specific to the Arch Linux {{Pkg|vivaldi}} package.}}
```
You can put your flags in a `{{ic|vivaldi-stable.conf}}`{=mediawiki} file under `{{ic|$HOME/.config/}}`{=mediawiki} (or
under `{{ic|$XDG_CONFIG_HOME}}`{=mediawiki} if you have configured that environment variable).

No special syntax is used; flags are defined as if they were written in a terminal.

- The arguments are split on whitespace and shell quoting rules apply, but no further parsing is performed.
- Flags can be placed in separate lines for readability, but this is not required.

Below is an example `{{ic|vivaldi-stable.conf}}`{=mediawiki} file that disables hardware media keys for the browser:

```{=mediawiki}
{{hc|~/.config/vivaldi-stable.conf|
<nowiki>--disable-features=HardwareMediaKeyHandling</nowiki>
}}
```
The `{{AUR|vivaldi-snapshot}}`{=mediawiki} package can get its flags set with the
`{{ic|vivaldi-snapshot.conf}}`{=mediawiki} file.

## Modding

Vivaldi has [modding capabilities](https://forum.vivaldi.net/topic/10549/modding-vivaldi?lang=en-US) through its
`{{ic|window.html}}`{=mediawiki} (pre Vivaldi 6.2: `{{ic|browser.html}}`{=mediawiki}) file.

The file can be found at: `{{ic|/opt/vivaldi/resources/vivaldi/window.html}}`{=mediawiki}

Another way to find the `{{ic|window.html}}`{=mediawiki} path is through the *Executable Path* section at
`{{ic|vivaldi://about/}}`{=mediawiki}.

You can also use `{{AUR|vivaldi-autoinject-custom-js-ui}}`{=mediawiki}. It can help you manage mods: add or remove them
from `{{ic|window.html}}`{=mediawiki}, and redo changes at vivaldi updates. For usage, visit the project
[page](https://github.com/budlabs/vivaldi-autoinject-custom-js-ui).

## Tips and Tricks {#tips_and_tricks}

### Transfer your profile to snapshot version {#transfer_your_profile_to_snapshot_version}

If you switched to snapshot version because of lacking features of stable version, you want to also use your user
profile. Copy the `{{ic|~/.config/vivaldi/Default}}`{=mediawiki} to
`{{ic|~/.config/vivaldi-snapshot/Default}}`{=mediawiki}.

### Google search suggestions {#google_search_suggestions}

Vivaldi [cannot be shipped](https://forum.vivaldi.net/topic/28880/google-suggestions-in-address-bar/2) with enabled
suggestions for google search. The user must manually add the suggestion url
**[https://www.google.com/complete/search?client=chrome&q=%s](https://www.google.com/complete/search?client=chrome&q=%s)**
in search settings.

### Keep picture-in-picture window above other windows {#keep_picture_in_picture_window_above_other_windows}

When viewing some video, you can press the picture-in-picture button to detach it to a separate window. By default this
window is not kept above others and it is inconvenient. To fix it in KDE, create a window rule to keep it above others.
See [KDE#Using window rules](KDE#Using_window_rules "KDE#Using window rules"){.wikilink}.

## Troubleshooting

### Chromium page {#chromium_page}

Some troubleshooting is common for Vivaldi and Chromium, such as for example, force enabling hardware acceleration. For
such, consult the [Chromium#Troubleshooting](Chromium#Troubleshooting "Chromium#Troubleshooting"){.wikilink}.

### Certificates management {#certificates_management}

Currently (Vivaldi 6.2.3105.54 (Stable channel)), the certificates management setting is missing. To workaround that,
manually type the address `{{ic|chrome://settings/certificates}}`{=mediawiki}. Note, that the address will be changed to
`{{ic|vivaldi://settings/certificates}}`{=mediawiki}, but you cannot type it in the first place (otherwise you will see
vivaldi settings where cert management it is missing). See
[here](https://forum.vivaldi.net/topic/57001/import-client-certificates) for more details.

## See also {#see_also}

- [Wikipedia:Vivaldi (web browser)](Wikipedia:Vivaldi_(web_browser) "Wikipedia:Vivaldi (web browser)"){.wikilink}

[Category:Web browser](Category:Web_browser "Category:Web browser"){.wikilink}

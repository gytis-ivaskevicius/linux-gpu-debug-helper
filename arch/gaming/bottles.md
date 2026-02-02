[fr:Bottles](fr:Bottles "wikilink") [hu:Bottles](hu:Bottles "wikilink") [ja:Bottles](ja:Bottles "wikilink")
[ru:Bottles](ru:Bottles "wikilink") [zh-hans:Bottles](zh-hans:Bottles "wikilink")
`{{Related articles start}}`{=mediawiki} `{{Related|Wine}}`{=mediawiki} `{{Related|Proton}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki} Bottles is a [Wine](Wine "wikilink") prefix manager written in
[Python](Python "wikilink") using the [GTK](GTK "wikilink") framework. It can be used to create and manage Wine prefixes
as well as automatically handling the installation of various Wine runners, Windows dependencies and installation of
some Windows applications. It can also be used to override Windows DLL files inside a prefix and manage environment
variables for Wine sessions.

It can be used to run Native Windows applications and games with, in most cases, near native performance and in its
officially supported mode also supports application sandboxing.

The Bottles application makes it easy to run games originally made for Windows on Linux. We do not even need to install
the Steam client application, unless the game requires it. After installing the Bottles application on our Linux
machine, we download the game installer for the desired game from somewhere (just as if we were on Windows). Then, on
our Linux machine, we use the Bottles application to create a Wine prefix environment (create a \"bottle\"). Inside the
created environment (inside the created bottle), we install the game (just as if we were on Windows). After that, we
launch the game within the Wine prefix environment (inside the created bottle), so we end up playing a Windows game on
our Arch Linux machine.

## Installation

```{=mediawiki}
{{Note|The Bottles developers strongly recommend that users install Bottles through [[Flatpak]] as it is used for sandboxing.}}
```
Install Bottles from Flatpak using the following command

`$ flatpak install bottles`

Alternatively, Bottles is also available as `{{AUR|bottles}}`{=mediawiki} and `{{AUR|bottles-git}}`{=mediawiki}.

## Usage

Bottles has a thorough guide covering its usage at [Bottles User Documentation](https://docs.usebottles.com/)

## See also {#see_also}

-   [Project homepage](https://usebottles.com/)
-   [Project Github page](https://github.com/bottlesdevs/Bottles)
-   [Project documentation](https://docs.usebottles.com/)

[Category:Emulation](Category:Emulation "wikilink") [Category:Gaming](Category:Gaming "wikilink")

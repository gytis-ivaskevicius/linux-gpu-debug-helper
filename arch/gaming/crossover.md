[fr:CrossOver](fr:CrossOver "wikilink") [ja:CrossOver](ja:CrossOver "wikilink")
[CrossOver](https://www.codeweavers.com/crossover) is the paid, commercialized version of [Wine](Wine "wikilink") which
provides more comprehensive end-user support. It includes scripts, patches, a
[GUI](wikipedia:Graphical_user_interface "wikilink"), and third-party software which may never be accepted in the Wine
Project. This combination makes running Windows programs considerably easier for those less tech-savvy.

## Installation

In this article it is suggested that you install the trial version of crossover. [Install](Install "wikilink")
`{{AUR|crossover}}`{=mediawiki} package.

## Usage

If installed by a user in *single user mode*, Crossover binaries will be located in `{{ic|~/cxoffice}}`{=mediawiki}.
Windows applications and configuration files will be placed in `{{ic|~/.cxoffice}}`{=mediawiki}.

If installed with root privileges in *multi-user shared mode*, Crossover binaries will be located in
`{{ic|/opt/cxoffice}}`{=mediawiki}. Each user\'s bottles will be placed in `{{ic|~/.cxoffice}}`{=mediawiki}.

Some desktop environments like [KDE](KDE "wikilink") may have automatically placed menu entries as part of the
installation process.

Installed programs should be located under a new menu entry called *Window Applications*.

```{=mediawiki}
{{Tip| If you get a registration failure, try to execute {{ic|/opt/cxoffice/bin/cxregister}} as root. Registration should then complete and be valid for all users on the system.}}
```
## Troubleshooting

There is also a way to generate a log file to assist you in tracking down errors that may be preventing you from running
your desired Windows application(s). Follow the menu path *CrossOver \> Run a Windows Command \> Debug Options* and
click the \"+\" sign to expand the options. Click the \"Create log file\" checkbox. Enter the command you would use to
run your Windows application in the \"Command\" text box. You can use the browse button, if you are not sure what to
enter, to navigate to your Windows application. CrossOver will prompt you for a location to save the log file. Choose
your location and press enter to have Crossover generate the log file in it.

Although the `{{ic|libSM.so}}`{=mediawiki} library was not shown in the cxdiag list of missing libraries - it did appear
in the log file. The library belongs to the `{{Pkg|libsm}}`{=mediawiki} package. If you are having problems getting your
application to run, check its installation status.

[Category:Emulation](Category:Emulation "wikilink") [Category:Gaming](Category:Gaming "wikilink")

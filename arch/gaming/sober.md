`{{Merge|List of games|No Arch-specific content.}}`{=mediawiki}

[Sober](https://sober.vinegarhq.org/) is a closed-source application that allows running [Roblox](https://roblox.com)
under Linux. It downloads and manages the Android version of Roblox, featuring feature enhancements such as
[GameMode](GameMode "GameMode"){.wikilink}.

## Installation

Install Sober from [Flathub](https://flathub.org/apps/org.vinegarhq.Sober).

Alternatively, install Sober from [Flatpak](Flatpak "Flatpak"){.wikilink} using the following command

`$ flatpak install --user flathub org.vinegarhq.Sober `

Currently, Sober is not available on the AUR.

## Configuration

Sober is configurable with the file at `{{ic|~/.var/app/org.vinegarhq.Sober/config/sober/config.json}}`{=mediawiki}

The documentation on each option is available on the [Sober
website](https://vinegarhq.org/Sober/Configuration/index.html).

## Troubleshooting

### Bubblewrap

Having the `{{pkg|bubblewrap-suid}}`{=mediawiki} package installed causes Sober to not launch properly. To fix it,
remove the `{{pkg|bubblewrap-suid}}`{=mediawiki} package and replace it with the `{{pkg|bubblewrap}}`{=mediawiki}
package instead.

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}
[Category:Software](Category:Software "Category:Software"){.wikilink}

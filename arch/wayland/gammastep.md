`{{Related articles start}}`{=mediawiki} `{{Related|Backlight}}`{=mediawiki} `{{Related|Redshift}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

[gammastep](https://gitlab.com/chinstrap/gammastep) is a fork of [Redshift](Redshift "wikilink") for
[Wayland](Wayland "wikilink"). It adjusts the color temperature of your screen according to your surroundings.

## Installation

[Install](Install "wikilink") `{{Pkg|gammastep}}`{=mediawiki}.

## Configuration

A configuration file is not required but is useful for saving custom configurations and manually defining the location
in case of issues with the automatic location provider. An example configuration can be found in
[gammastep.conf.sample](https://gitlab.com/chinstrap/gammastep/-/blob/master/gammastep.conf.sample).

The configuration file should be saved in `{{ic|${XDG_CONFIG_HOME}/gammastep/config.ini}}`{=mediawiki}. If
`{{ic|XDG_CONFIG_HOME}}`{=mediawiki} is unset, the default of `{{ic|~/.config}}`{=mediawiki} is used.

## Usage

### Manual way {#manual_way}

Run the command:

`$ gammastep`

### systemd way {#systemd_way}

[Enable](Enable "wikilink")/[start](start "wikilink") `{{ic|gammastep.service}}`{=mediawiki} [user
unit](user_unit "wikilink").

[Category:Wayland](Category:Wayland "wikilink") [Category:Eye candy](Category:Eye_candy "wikilink")

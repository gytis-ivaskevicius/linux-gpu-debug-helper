`{{Related articles start}}`{=mediawiki} `{{Related|Hyprland}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[Hyprlock](https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/) is [Hyprland](Hyprland "wikilink")\'s screen locker. It is
highly customizable.

## Installation

[Install](Install "wikilink") the `{{Pkg|hyprlock}}`{=mediawiki} package.

## Configuration

Configuration is done through the [hyprlock.conf](https://github.com/hyprwm/hyprlock/blob/main/assets/example.conf) file
in `{{ic|~/.config/hypr}}`{=mediawiki}.

```{=mediawiki}
{{Note|Hyprlock does not generate a configuration file on installation, and will not run without one.}}
```
### Widgets

Hyprlock works on a [widget](https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/#widget-list)-based system. Widgets can be
created with the following format:

```{=mediawiki}
{{hc|~/.config/hypr/hyprlock.conf|2=
widget {
  property = value
  ...
}
}}
```
```{=mediawiki}
{{Note|As many of these can be put in the hyprlock.conf file as desired. For example:

{{hc|~/.config/hypr/hyprlock.conf|2=
label {
  ...
}
label {
  ...
}
input-field {
  ...
}
}}
}}
```
#### Examples

The background of Hyprlock:

```{=mediawiki}
{{hc|~/.config/hypr/hyprlock.conf|2=
background {
  monitor = # monitor-agnostic
  path = ~/Pictures/mountain.jpg
  blur_passes = 1
  blur_size = 7
}
}}
```
An input field for the password:

```{=mediawiki}
{{hc|~/.config/hypr/hyprlock.conf|2=
input-field {
  monitor =
  size = 20%, 5%
  font_family = Noto Sans
  dots_size = 0.08
}
}}
```
A label that displays the time:

```{=mediawiki}
{{hc|~/.config/hypr/hyprlock.conf|2=
label {
  monitor =
  text = $TIME
  font_size = 100
  position = 0, -80
}
}}
```
The `{{ic|$TIME}}`{=mediawiki} that comes after `{{ic|text}}`{=mediawiki} can be substituted for any other text,
`{{ic|$USER}}`{=mediawiki}, `{{ic|$FAIL}}`{=mediawiki}, and `{{ic|$TIME12}}`{=mediawiki}, [among
others](https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/#variable-substitution).

[Category:Wayland](Category:Wayland "wikilink")

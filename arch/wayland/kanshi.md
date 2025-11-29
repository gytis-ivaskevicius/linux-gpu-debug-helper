```{=mediawiki}
{{Lowercase title}}
```
[zh-hans:Kanshi](zh-hans:Kanshi "wikilink") `{{Related articles start}}`{=mediawiki} `{{Related|Sway}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

[kanshi](https://gitlab.freedesktop.org/emersion/kanshi) allows you to define output profiles that are automatically
enabled and disabled on hotplug. For instance, this can be used to turn a laptop\'s internal screen off when docked.

This is a Wayland equivalent for tools like [autorandr](https://github.com/phillipberndt/autorandr). kanshi can be used
on Wayland compositors supporting the wlr-output-management protocol.

## Installation

[Install](Install "wikilink") `{{Pkg|kanshi}}`{=mediawiki} or `{{AUR|kanshi-git}}`{=mediawiki}.

## Configuration

### Basic

Create kanshi configuration file:

```{=mediawiki}
{{hc|1=~/.config/kanshi/config|2=
profile {
    output LVDS-1 disable
    output "Some Company ASDF 4242" mode 1600x900 position 0,0
}

profile {
    output LVDS-1 enable scale 2
}
}}
```
Each output profile is delimited by brackets. It contains several output directives (whose syntax is similar to
`{{man|5|sway-output}}`{=mediawiki}). A profile will be enabled if all of the listed outputs are connected.

```{=mediawiki}
{{Tip|You can get a list of output names and additional information using the command {{ic|swaymsg -t get_outputs}}.
}}
```
### Advanced

For easier management of multiple setups *(e.g. Internal laptop monitor only, Docked to one monitor at home, Docked to
two work monitors, \...)* you can define defaults for the outputs used inside profiles and assign them aliases. The
defaults will apply to all profiles where the respective output is mentioned. For more see
`{{man|5|kanshi}}`{=mediawiki}).

```{=mediawiki}
{{hc|1=~/.config/kanshi/config|2=
output "Dell Inc. DELL S2721DGF G52TR83" {
  mode 2560x1440@165.08
  position 1280,0
  scale 2
  alias $HOME_1
}

output "LG Display 0x058B Unknown" {
  mode 2560x1440@59.99800
  position 0,0
  scale 2
  alias $INTERNAL
}

profile home_1 {
  output $INTERNAL disable
  output $HOME_1 enable
}
}}
```
Note that the *\$INTERNAL* output has as third segment *UNKNOWN*. This is because kanshi needs all three fields
(manufacturer, model and serial number) to be populated. If one is missing the string *UNKNOWN* has to be used.

You can find out these values with a command like [hyprctl
monitors](https://wiki.hyprland.org/Configuring/Using-hyprctl/) which will display all three of those in its output.

```{=mediawiki}
{{hc|1=hyprctl monitors|2=
make: LG Display
model: 0x058B
serial:
}}
```
It is also possible to further integrate kanshi with your workflow by using the *exec* directive to execute a command
once the profile was successfully applied.

```{=mediawiki}
{{hc|1=~/.config/kanshi/config|2=
profile home_1 {
  output $INTERNAL disable
  output $HOME_1 enable
  exec uwsm app -- $HOME/.config/hypr/scripts/move-workspaces.sh "LG Display 0x058B"
}
}}
```
## Usage

Run the command:

`$ kanshi`

See [#Manage kanshi with systemd](#Manage_kanshi_with_systemd "wikilink") for an automated usage.

## Tips and tricks {#tips_and_tricks}

### Manage kanshi with systemd {#manage_kanshi_with_systemd}

Create and start `{{ic|~/.config/systemd/user/sway-session.target}}`{=mediawiki} (if you don\'t have created yet) by
following [Sway#Manage Sway-specific daemons with systemd](Sway#Manage_Sway-specific_daemons_with_systemd "wikilink").

Create the `{{ic|kanshi.service}}`{=mediawiki} file:

```{=mediawiki}
{{hc|1=~/.config/systemd/user/kanshi.service|2=
[Unit]
Description=Dynamic output configuration for Wayland compositors
Documentation=https://gitlab.freedesktop.org/emersion/kanshi
BindsTo=sway-session.target

[Service]
Type=simple
ExecStart=/usr/bin/kanshi

[Install]
WantedBy=sway-session.target
}}
```
[Enable](Enable "wikilink") this [user unit](user_unit "wikilink"). It is only activated when Sway is running and
deactivated when Sway stops.

## Troubleshooting

### Workspace number starts from 2 in external monitor after wake up {#workspace_number_starts_from_2_in_external_monitor_after_wake_up}

If you have a configuration like [above](#Configuration "wikilink"), when you connected a second display to your
computer, the workspace in the second display should start from 1 since the first display is disabled. This should be
the case when you plugged your monitor in the first time or after starting the system. But after sleep, this number
might be 2. In this case just move the first workspace to this monitor by adding a directive to the kanshi configuration
file:

```{=mediawiki}
{{hc|1=~/.config/kanshi/config|2=
profile {
    output LVDS-1 disable
    output "Some Company ASDF 4242" mode 1600x900 position 0,0
    # We've added this directive here (do not forget to update the output name):
    exec swaymsg workspace 1, move workspace to HDMI-A-1
}

profile {
    output LVDS-1 enable scale 2
}
}}
```
## See also {#see_also}

-   [Source code and documentation](https://gitlab.freedesktop.org/emersion/kanshi)

[Category:Wayland](Category:Wayland "wikilink")

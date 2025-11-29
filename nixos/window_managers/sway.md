Sway is a tiling Wayland compositor and a drop-in replacement for the i3 window manager for X11. It works with your
existing i3 configuration and supports most of i3\'s features, plus a few extras. [i3 migration
guide](https://github.com/swaywm/sway/wiki/i3-Migration-Guide)

## Setup

You can install Sway by enabling it in NixOS directly, or by using [Home Manager](Home_Manager "wikilink"), or both.

### Using NixOS {#using_nixos}

Here is a minimal configuration:

``` nix
{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
  ];

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable Sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
```

By default, the Sway module in NixOS comes with a set of extra packages, including the `foot` terminal, `swayidle`,
`swaylock`, and `wmenu`, which can be configured under
[`programs.sway.extraPackages`](https://search.nixos.org/options?show=programs.sway.extraPackages) option. You may also
want to include `wl-clipboard` for clipboard functionality and `slurp` for screenshot region selection. Additionally,
for a more customizable bar implementation than `sway-bar`, `waybar` can be enabled with `programs.waybar.enable`.

The default Sway configuration is symlinked to `/etc/sway/config` and `/etc/sway/config.d/nixos.conf`. The latter file
contains dbus and systemd configuration that is critical to using apps that depend on XDG desktop portals with Sway, and
should be included in any custom configuration files.

A few general comments:

-   There is some friction between GTK theming and Sway. Currently the Sway developers suggest using gsettings to set
    gtk theme attributes as described here [1](https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland). There is
    currently a plan to allow GTK theme attributes to be set directly in the Sway config.
-   Running Sway as a systemd user service is not recommended
    [2](https://github.com/swaywm/sway/wiki/Systemd-integration#running-sway-itself-as-a---user-service)
    [3](https://github.com/swaywm/sway/issues/5160)

### Using Home Manager {#using_home_manager}

To set up Sway using [Home Manager](Home_Manager "wikilink"), first you must enable [Polkit](Polkit "wikilink") in your
NixOS configuration: `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
security.polkit.enable = true;
</nowiki>}}`{=mediawiki}

Then you can enable Sway in your home manager configuration. Here is a minimal example: \<syntaxhighlight lang=\"nix\>

` wayland.windowManager.sway = {`\
`   enable = true;`\
`   wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps`\
`   config = rec {`\
`     modifier = "Mod4";`\
`     # Use kitty as default terminal`\
`     terminal = "kitty"; `\
`     startup = [`\
`       # Launch Firefox on start`\
`       {command = "firefox";}`\
`     ];`\
`   };`\
` };`

```{=html}
</syntaxhighlight>
```
See [Home Manager\'s Options for
Sway](https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.enable) for a complete
list of configuration options.

You might need to active dbus manually from .zshrc to use i.e: dunst, see [Dunst crashes if run as
service](https://discourse.nixos.org/t/dunst-crashes-if-run-as-service/27671/2)

```{=mediawiki}
{{Note|
It's recommended to enable a [[Secret Service]] provider, like GNOME Keyring:
{{file|home.nix|nix|<nowiki>
services.gnome-keyring.enable = true;
</nowiki>}}
}}
```
### Systemd services {#systemd_services}

Kanshi is an output configuration daemon. As explained above, we don\'t run Sway itself as a systemd service. There are
auxiliary daemons that we do want to run as systemd services, for example Kanshi [4](https://sr.ht/~emersion/kanshi/),
which implements monitor hot swapping. It would be enabled as follows: `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY="wayland-1";
      DISPLAY = ":0";
    }; 
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };
</nowiki>}}`{=mediawiki}

```{=mediawiki}
{{file|sway config|bash|
# give Sway a little time to startup before starting kanshi.
exec sleep 5; systemctl --user start kanshi.service
}}
```
When you launch Sway, the systemd service is started.

### Using greeter {#using_greeter}

Installing a greeter based on
[greetd](https://search.nixos.org/options?channel=unstable&show=services.greetd.settings&from=0&size=50&sort=relevance&type=packages&query=greetd)
is the most straightforward way to launch Sway.

Tuigreet does not even need a separate compositor to launch.

```{=mediawiki}
{{file|||<nowiki>
services.greetd = {                                                      
  enable = true;                                                         
  settings = {                                                           
    default_session = {                                                  
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
      user = "greeter";                                                  
    };                                                                   
  };                                                                     
};                                                                       
</nowiki>|name=/etc/nixos/configuration.nix|lang=nix}}
```
### Automatic startup on boot {#automatic_startup_on_boot}

The snippet below will start Sway immediately on startup, without a greeter and **without login prompt**. Only consider
using this in conjunction with [Full Disk Encryption](Full_Disk_Encryption "wikilink")!

``` nix
services.getty = {
  autologinUser = "your_username";
  autologinOnce = true;
};
environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
'';
```

When launched directly from the TTY sway won\'t inherit the user environment. This can cause issues with systemd user
services such as application launchers or swayidle. To fix this add the following to your home-manager
configuration:`{{file|home.nix|nix|<nowiki>
 wayland.windowManager.sway.systemd.variables = ["--all"];
</nowiki>}}`{=mediawiki}

## Configuration

Sway can be configured for specific users using Home-Manager or manually through configuration files. Default is
`/etc/sway/config` and custom user configuration in `~/.config/sway/config`.

### Keyboard layout {#keyboard_layout}

Changing layout for all keyboards to German (de):

``` console
input * xkb_layout "de"
```

The same thing accomplished in Home Manager:

``` nix
wayland.windowManager.sway.input."*".xkb_layout = "de";
```

### High-DPI scaling {#high_dpi_scaling}

Changing scale for all screens to factor 1.5:

``` console
output * scale 1.5
```

### Brightness and volume {#brightness_and_volume}

You can set up brightness and volume function keys as follows by binding the key codes to their corresponding commands
in your sway config. The following configurations accomplish this using `light` and `pulseaudio`:
`{{file|/etc/nixos/configuration.nix|nix|<nowiki>
users.users.yourusername.extraGroups = [ "video" ];
programs.light.enable = true;
environment.systemPackages = [ pkgs.pulseaudio ];
</nowiki>}}`{=mediawiki}

```{=mediawiki}
{{file|sway config|bash|

# Brightness
bindsym XF86MonBrightnessDown exec light -U 10
bindsym XF86MonBrightnessUp exec light -A 10

# Volume
bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
}}
```
## Troubleshooting

### Cursor is missing icons or too tiny on HiDPI displays {#cursor_is_missing_icons_or_too_tiny_on_hidpi_displays}

#### With programs.sway {#with_programs.sway}

\<syntaxhighlight lang=\"nix\> {

` programs.sway.extraPackages = with pkgs; [`\
`   adwaita-icon-theme # mouse cursor and icons`\
`   gnome-themes-extra # dark adwaita theme`\
`   ...`\
` ];`

}

```{=html}
</syntaxhighlight>
```
In \~/.config/sway/config

    seat "*" xcursor_theme Adwaita 32

#### With Home Manager {#with_home_manager}

Using [Home Manager](Home_Manager "wikilink") try configuring a general mouse cursor size and theme. The reason that
your cursor might be missing in some applications, is because `XCURSOR_THEME`is missing, which will cause applications
relying on `XWAYLAND` to misbehave. Setting `sway.enable = true`, combined with the `name`, `package` and size will set
the correct environment variables, which sway will then use.

``` nix
home-manager.users.myUser = {
    home.pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
      sway.enable = true;
    };
};
```

Replace `myUser` with your user running the graphical environment.

### Missing fonts on Xorg applications {#missing_fonts_on_xorg_applications}

If fonts for certain languages are missing in Xorg applications (e.g. Japanese fonts don\'t appear in Discord) even
though they\'re in the system, you can set them as default fonts in your configuration file.

\<syntaxhighlight lang=\"nix\>

` fonts = {`\
`   packages = with pkgs; [`\
`     noto-fonts`\
`     noto-fonts-cjk`\
`     noto-fonts-emoji`\
`     font-awesome`\
`     source-han-sans`\
`     source-han-sans-japanese`\
`     source-han-serif-japanese`\
`   ];`\
`   fontconfig.defaultFonts = {`\
`     serif = [ "Noto Serif" "Source Han Serif" ];`\
`     sansSerif = [ "Noto Sans" "Source Han Sans" ];`\
`   };`\
` };`

```{=html}
</syntaxhighlight>
```
### Swaylock cannot be unlocked with the correct password {#swaylock_cannot_be_unlocked_with_the_correct_password}

Add the following to your NixOS configuration.

\<syntaxhighlight lang=\"nix\>

` security.pam.services.swaylock = {};`

```{=html}
</syntaxhighlight>
```
The `programs.sway.enable` option does this automatically.

### Inferior performance compared to other distributions {#inferior_performance_compared_to_other_distributions}

Enabling realtime may improve latency and reduce stuttering, specially in high load scenarios.

``` nix
security.pam.loginLimits = [
  { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
];
```

Enabling this option allows any program run by the \"users\" group to request real-time priority.

### WLR Error when trying to launch Sway {#wlr_error_when_trying_to_launch_sway}

When this happens on a new nixos system, enabling opengl in configuration.nix may fix this issue.

```{=mediawiki}
{{Note|<code>hardware.opengl</code> was renamed to <code>hardware.graphics</code> in NixOS 24.11.}}
```
``` nix
hardware.graphics.enable = true;
```

### Systemd user services missing environment variables (PATH, etc) {#systemd_user_services_missing_environment_variables_path_etc}

When sway is launched with out display manager systemd won\'t inherit the users environment variables. To fix this add
the following to your home-manager configuration:
`{{File|3=wayland.windowManager.sway.systemd.variables = ["--all"];|name=home.nix|lang=nix}}`{=mediawiki}

### Touchscreen input bound to the wrong monitor in multi-monitor setups {#touchscreen_input_bound_to_the_wrong_monitor_in_multi_monitor_setups}

See this [GitHub issue for Sway](https://github.com/swaywm/sway/issues/6590#issue-1021207180) and the solution give in
[this response](https://github.com/swaywm/sway/issues/6590#issuecomment-938724355).

Using [Home Manager](Home_Manager "wikilink") add the following to your Sway configuration:

``` nix
   wayland.windowManager.sway = {
     [...]
     config = {
       [...]
       input = {
         [...]
         "type:touch" = {
           # Replace touchscreen_output_identifier with the identifier of your touchscreen.
           map_to_output = touchscreen_output_identifier;
         };
       };
     };
   };
```

### GTK apps take an exceptionally long time to start {#gtk_apps_take_an_exceptionally_long_time_to_start}

This occurs because GTK apps make blocking calls to freedesktop portals to be displayed. If Sway is not integrated with
dbus and systemd, it will not be able to communicate via the `org.freedesktop.portal.Desktop` portal. To fix this, see
the [description](Sway#Using_NixOS "wikilink") of default Sway configurations earlier. Adding the following to your sway
configuration, if it is not already present, may resolve the issue:

`include /etc/sway/config.d/*`

## Tips and tricks {#tips_and_tricks}

### Toggle monitor modes script {#toggle_monitor_modes_script}

Following script toggles screen / monitor modes if executed. It can also be mapped to a specific key in Sway.

First add the Flake input required for the script

``` nix
{
  inputs = {
    [...]
    wl-togglescreens.url = "git+https://git.project-insanity.org/onny/wl-togglescreens.git?ref=main";
  };

  outputs = {self, nixpkgs, ...}@inputs: {
    nixosConfigurations.myhost = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      [...]
```

Map the script binary to a specific key

``` nix
{ config, pkgs, lib, inputs, ... }:{
  home-manager.users.onny = {
    programs = {
      [...]
      wayland.windowManager.sway = {
        enable = true;
        config = {
          [...]
          keybindings = lib.mkOptionDefault{
            [...]
            "XF86Display" = "exec ${inputs.wl-togglescreens.packages.x86_64-linux.wl-togglescreens}/bin/wl-togglescreens";
          };
        };
      };
    };
```

### Screen sharing with Firefox, Chromium {#screen_sharing_with_firefox_chromium}

``` nix
{ pkgs, ... }:
{
  # xdg portal + pipewire = screensharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
```

### Screen dimming with wl-gammarelay-rs {#screen_dimming_with_wl_gammarelay_rs}

Add `wl-gammarelay-rs` to programs.sway.extraPackages, then add the following to sway config:

    # start daemon
    exec wl-gammarelay-rs

    # bind shortcut to reset brightness
    bindsym $mod+Control+0 exec busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1

    # bind shortcut to dim screen for a particular output
    bindsym $mod+Control+Underscore exec busctl --user set-property rs.wl-gammarelay /outputs/DP_1 rs.wl.gammarelay Brightness d 0.5

### Inhibit swayidle/suspend when fullscreen {#inhibit_swayidlesuspend_when_fullscreen}

Add to sway config:

    # When you use `for_window` the command you give is not executed
    # immediately. It is stored in a list and the command is executed
    # every time a window opens or changes (eg. title) in a way that
    # matches the criteria.

    # inhibit idle for fullscreen apps
    for_window [app_id="^.*"] inhibit_idle fullscreen

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications](Category:Applications "wikilink")

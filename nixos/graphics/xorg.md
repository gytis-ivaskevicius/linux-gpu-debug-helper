[Xorg](https://en.wikipedia.org/wiki/X.Org_Server) is the implementation of the [X Window
System](https://en.wikipedia.org/wiki/X_Window_System). It acts as the bridge between your system\'s hardware and the
graphical user environment enabling a variety of [desktop
environments](:Category:Desktop_environment "desktop environments"){.wikilink} and [window
managers](:Category:Window_managers "window managers"){.wikilink}.

# Enabling

On NixOS, users can enable and configure Xorg through the `{{nixos:option|services.xserver}}`{=mediawiki} module in
their system configuration.

See `{{NixOS Manual|name=NixOS Manual: Chapter - X Window Syestem|anchor=#sec-x11}}`{=mediawiki} for information on
using X11 with NixOS.

# Tips and tricks {#tips_and_tricks}

## HiDPI

HiDPI (High Dots Per Inch) displays, also known by Apple\'s \"Retina Display\" marketing name, are screens with a high
resolution in a relatively small format. They are mostly found in high-end laptops and monitors.

Not all software behaves well in high-resolution mode yet. Here are listed most common tweaks which make work on a HiDPI
screen more pleasant:

``` nix
  # bigger tty fonts
  console.font =
    "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  services.xserver.dpi = 180;
  environment.variables = {
    ## Used by GTK 3
    # `GDK_SCALE` is limited to integer values
    GDK_SCALE = "2";
    # Inverse of GDK_SCALE
    GDK_DPI_SCALE = "0.5";

    # Used by Qt 5
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";

    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  # Expose variables to graphical systemd user services
  services.xserver.displayManager.importedVariables = [
    "GDK_SCALE"
    "GDK_DPI_SCALE"
    "QT_AUTO_SCREEN_SCALE_FACTOR"
  ];
```

To enable HiDPI scaling for Qt 6 applications, add the following to `.Xresources`:

    Xft.dpi: 180

## Disabling touchpad and mouse accelerations {#disabling_touchpad_and_mouse_accelerations}

To disable touchpad and mouse accelerations just add the following lines to your `configuration.nix`

``` nix
  services.xserver = {
    enable = true;

    ...

    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {
        accelProfile = "flat";
      };

      # disabling touchpad acceleration
      touchpad = {
        accelProfile = "flat";
      };
    };

    ...

  };
```

To get more information see `man configuration.nix`.

## Exclude packages {#exclude_packages}

Some packages like xterm are included when enabling Xorg. To exclude packages, edit the `configuration.nix` as the
example, but be sure to have another terminal enabled in your build before doing this.

``` nix
services.xserver.excludePackages = with pkgs; [
  xterm
];
```

# See also {#see_also}

- [Wayland](Wayland "Wayland"){.wikilink}
- [Nvidia](Nvidia "Nvidia"){.wikilink}
- [AMD GPU](AMD_GPU "AMD GPU"){.wikilink}
- [Intel Graphics](Intel_Graphics "Intel Graphics"){.wikilink}
- [:Category:Desktop environment](:Category:Desktop_environment ":Category:Desktop environment"){.wikilink}
- [:Category:Window managers](:Category:Window_managers ":Category:Window managers"){.wikilink}

[Category:Video](Category:Video "Category:Video"){.wikilink}

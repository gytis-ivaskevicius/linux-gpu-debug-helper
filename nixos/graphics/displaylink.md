### DisplayLink monitors {#displaylink_monitors}

In order to use DisplayLink monitors over USB, such as the ASUS MB16AC, the DisplayLink driver needs to be installed.

Since these drivers depend on binary unfree blobs, you will need to first add it to your Nix store.

Run `nix-shell -p displaylink --arg config '{ allowUnfree = true; }'` to get the **instructions and follow them**.

When you try to use `pkgs.displaylink` in your nixos system, you will get the same instructions printed to the stderr,
follow those to prefetch the driver. Once the blob is in the Nix store you can add the package

``` nix
environment.systemPackages = with pkgs; [
 displaylink
];
```

Then add the videoDrivers:

``` nixos
services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
```

The module `nixos/modules/hardware/video/displaylink.nix` should also work for wlroots compositors.

#### `<big>`{=html}Xserver`</big>`{=html}

##### Connecting a second external monitor {#connecting_a_second_external_monitor}

In order to add a second external monitor you can add the following to your configuration:

``` nix
services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
'';
```

#### Wayland

At first add displayLink driver to nix store as above described.

##### evdi module {#evdi_module}

You probably will need the \`evdi\` module `{{bc|<nowiki>
boot = {
  extraModulePackages = [ config.boot.kernelPackages.evdi ];
  initrd = {
    # List of modules that are always loaded by the initrd.
    kernelModules = [
      "evdi"
    ];
  };
};
</nowiki>}}`{=mediawiki}

##### **Gnome Wayland** {#gnome_wayland}

Install displayLink package

```{=mediawiki}
{{bc|<nowiki>
environment.systemPackages = with pkgs; [
  displaylink
];
</nowiki>}}
```
Define videoDrivers `{{bc|<nowiki>
services.xserver.videoDrivers = [ "displaylink" ];
</nowiki>}}`{=mediawiki}

Add dlm service `{{bc|<nowiki>
systemd.services.dlm.wantedBy = [ "multi-user.target" ];
</nowiki>}}`{=mediawiki}

##### **KDE Plasma** {#kde_plasma}

Apparently KDE Plasma (Wayland) requires a slight different approach.

Esnure you properly enabled wayland session

```{=mediawiki}
{{bc|<nowiki>
environment.variables = {
  KWIN_DRM_PREFER_COLOR_DEPTH = "24";
};

services = {
  desktopManager.plasma6 = {
    enable = true;
  };
  displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "plasma";
  };

};
</nowiki>}}
```
Install displayLink package

```{=mediawiki}
{{bc|<nowiki>
environment.systemPackages = with pkgs; [
  displaylink
];
</nowiki>}}
```
Instead of dlm setup display-link server as follows:

```{=mediawiki}
{{bc|<nowiki>
# --- THIS IS THE CRUCIAL PART FOR ENABLING THE SERVICE ---
systemd.services.displaylink-server = {
  enable = true;
  # Ensure it starts after udev has done its work
  requires = [ "systemd-udevd.service" ];
  after = [ "systemd-udevd.service" ];
  wantedBy = [ "multi-user.target" ]; # Start at boot
  # *** THIS IS THE CRITICAL 'serviceConfig' BLOCK ***
  serviceConfig = {
    Type = "simple"; # Or "forking" if it forks (simple is common for daemons)
    # The ExecStart path points to the DisplayLinkManager binary provided by the package
    ExecStart = "${pkgs.displaylink}/bin/DisplayLinkManager";
    # User and Group to run the service as (root is common for this type of daemon)
    User = "root";
    Group = "root";
    # Environment variables that the service itself might need
    # Environment = [ "DISPLAY=:0" ]; # Might be needed in some cases, but generally not for this
    Restart = "on-failure";
    RestartSec = 5; # Wait 5 seconds before restarting
  };
};
</nowiki>}}
```
## Sway

Identify which card has the render device, `evdi` is the DisplayLink interface, so it\'s not `card0`, but `card1`.

``` console
$ ls -l /dev/dri/by-path
lrwxrwxrwx - root  2 Nov 13:38 pci-0000:00:02.0-card -> ../card1
lrwxrwxrwx - root  2 Nov 13:38 pci-0000:00:02.0-render -> ../renderD128
lrwxrwxrwx - root  2 Nov 13:38 platform-evdi.0-card -> ../card0
```

``` nix
environment.variables = {    
  WLR_EVDI_RENDER_DEVICE = "/dev/dri/card1";                                                                                                   
};
nixpkgs.overlays = [
  (final: prev: {    
    wlroots_0_17 = prev.wlroots_0_17.overrideAttrs (old: { # you may need to use 0_18
      patches = (old.patches or [ ]) ++ [
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/wlroots/wlroots/uploads/bd115aa120d20f2c99084951589abf9c/DisplayLink_v2.patch";
              hash = "sha256-vWQc2e8a5/YZaaHe+BxfAR/Ni8HOs2sPJ8Nt9pfxqiE=";
            })       
          ];
        });
      })
];
services.xserver.videoDrivers = [ "displaylink" ];
systemd.services.dlm.wantedBy = [ "multi-user.target" ];
```

Note as of [2024-10-30](https://github.com/NixOS/nixpkgs/pull/351752) nixos-unstable sway uses `wlroots_0_18`. The patch
above applies correctly but you will need to invoke sway with the `--unsupported-gpu` flag.

[Source](https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/1823#note_2146862)

[Category:Video](Category:Video "wikilink") [Category:Video](Category:Video "wikilink")

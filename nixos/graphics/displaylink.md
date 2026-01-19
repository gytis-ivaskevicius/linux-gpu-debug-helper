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

``` nix
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

You probably will need the \`evdi\` module

``` nix
boot = {
  extraModulePackages = [ config.boot.kernelPackages.evdi ];
  initrd = {
    # List of modules that are always loaded by the initrd.
    kernelModules = [
      "evdi"
    ];
  };
};
```

##### **Gnome Wayland** {#gnome_wayland}

Install displayLink package

``` nix
environment.systemPackages = with pkgs; [
  displaylink
];
```

Define videoDrivers `{{bc|<nowiki>
services.xserver.videoDrivers = [ "displaylink" ];
</nowiki>}}`{=mediawiki}

Add dlm service

``` nix
systemd.services.dlm.wantedBy = [ "multi-user.target" ];
```

##### **KDE Plasma** {#kde_plasma}

Apparently KDE Plasma (Wayland) requires a slight different approach.

Esnure you properly enabled wayland session

``` nix
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
```

Install displayLink package

``` nix
environment.systemPackages = with pkgs; [
  displaylink
];
```

Instead of dlm setup display-link server as follows:

``` nix
systemd.services.displaylink-server = {
  enable = true;
  requires = [ "systemd-udevd.service" ];
  after = [ "systemd-udevd.service" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.displaylink}/bin/DisplayLinkManager";
    User = "root";
    Group = "root";
    Restart = "on-failure";
    RestartSec = 5; # Wait 5 seconds before restarting
  };
};
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

## Troubleshooting

### Suspend blocked by `pre-sleep.service` {#suspend_blocked_by_pre_sleep.service}

As of NixOS 25.05, installing `pkgs.displaylink` inserts some directives into the script referenced by
`pre-sleep.service`. If suspending does not work and causes the reboot and poweroff buttons to stop working, it may be a
symptom of [suspend being blocked by
pre-sleep.service](Power_Management#Suspend_blocked_by_pre-sleep.service "wikilink").

The script in question:

``` {.bash .numberLines}
#!/nix/store/cfqbabpc7xwg8akbcchqbq3cai6qq2vs-bash-5.2p37/bin/bash
set -e

#flush any bytes in pipe
while read -n 1 -t 1 SUSPEND_RESULT < /tmp/PmMessagesPort_out; do : ; done;

#suspend DisplayLinkManager
echo "S" > /tmp/PmMessagesPort_in

#wait until suspend of DisplayLinkManager finish
if [ -f /tmp/PmMessagesPort_out ]; then
  #wait until suspend of DisplayLinkManager finish
  read -n 1 -t 10 SUSPEND_RESULT < /tmp/PmMessagesPort_out
fi
```

Because of a stray `/tmp/PmMessagesPort_out` caused by an unclean shutdown, the suspend action was blocked by this
script trying to flush the port. A myriad of solutions can be used to unblock the script and restore suspend:

-   Start `dlm.service` so that DisplayLinkManager can clear the ports and unblock the script
-   Use `sudo DisplayLinkManager` to clear the ports and unblock the script

Untested solutions:

-   Removing the file
-   Killing the script

[Category:Video](Category:Video "wikilink") [Category:Video](Category:Video "wikilink")

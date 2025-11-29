[xmonad](https://xmonad.org/) is a tiling [window manager](https://wiki.archlinux.org/title/Window_manager) for
[X](Xorg "wikilink"). Windows are arranged automatically to tile the screen without gaps or overlap, maximizing screen
use. Window manager features are accessible from the keyboard: a mouse is optional.

xmonad is written, configured and extensible in [Haskell](Haskell "wikilink"). Custom layout algorithms, key bindings
and other extensions may be written by the user in configuration files.

Layouts are applied dynamically, and different layouts may be used on each workspace.
[Xinerama](Wikipedia:Xinerama "wikilink") is fully supported, allowing windows to be tiled on several physical screens.

## Installation

The simplest way to install Xmonad is to activate the corresponding NixOS module. You can do this by adding the
following to your NixOS configuration. You probably also want to activate the `enableContribAndExtras` option.

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|
<nowiki>
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
</nowiki>
}}
```
The second options automatically adds the `xmonad-contrib` and `xmonad-extras` packages. They are required to use the
[Xmonad Contrib](https://hackage.haskell.org/package/xmonad-contrib) extensions.

### Adding Haskell Modules {#adding_haskell_modules}

To add additional Haskell modules beyond xmonad-contrib and xmonad-extras, use the `extraPackages` option

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|
<nowiki>
  ...
  services.xserver.windowManager.xmonad = {
    ...
    extraPackages = haskellPackages: [ 
      haskellPackages.monad-logger
    ];
  };
</nowiki>
}}
```
To add Haskell modules that are not in the Haskell Nix package set, you have to tell ghc where to find them. For
example, you can use the following to add the [xmonad-contexts](https://github.com/Procrat/xmonad-contexts) module.

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|
<nowiki>
{ config, pkgs, ... }:
let
  xmonad-contexts = pkgs.fetchFromGitHub {
    owner = "Procrat";
    repo = "xmonad-contexts";
    rev = "SOME_COMMIT_HASH"; # replace with an actual commit for reproducibility
    sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
  };
in {
  ...
  services.xserver.windowManager.xmonad = {
    ...
    ghcArgs = [
      "-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
      "-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
      "-i${xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
    ];
  };
}
</nowiki>
}}
```
or if you are using Flakes

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|
<nowiki>
{ xmonad-contexts, ... }:
{
  ...
  services.xserver.windowManager.xmonad = {
    ...
    ghcArgs = [
      "-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
      "-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
      "-i${xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
    ];
  };
}
</nowiki>
}}
```
Don\'t forget to add the module to your flake inputs:

```{=mediawiki}
{{file|/etc/nixos/flake.nix|nix|
<nowiki>
inputs.xmonad-contexts = {
  url = "github:Procrat/xmonad-contexts";
  flake = false;
};
</nowiki>
}}
```
## Configuration

`$HOME/.xmonad` is the default path used for the configuration file. If your configuration is in a different location,
give Nix your Xmonad config file like this:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|
<nowiki>
services.xserver.windowManager.xmonad = {
  ...
  config = builtins.readFile ../path/to/xmonad.hs;
};
</nowiki>
}}
```
See
[services.xserver.windowManager.xmonad](https://search.nixos.org/options?query=services.xserver.windowManager.xmonad)
for a full list of available options and their descriptions.

More information on how to configure Xmonad can be found in the [Arch Wiki](https://wiki.archlinux.org/title/Xmonad),
and a list of starter configs can be found in the [Xmonad Config
Archive](https://wiki.haskell.org/Xmonad/Config_archive).

## Power management {#power_management}

Xmonad is a Window Manager (WM) and not a Desktop Environment (DE). Therefore, among other things, Xmonad does not
handle [power management](Power_Management "wikilink") related things such as sleeping. However, there are several ways
of still adding this functionality.

### Suspend system after inactivity {#suspend_system_after_inactivity}

The approach goes through the following steps:

-   Let the [XServer](Xorg "wikilink") detect idle-situation
-   Inform \"[logind](Systemd/logind "wikilink")\" (i.e. \"systemd\") about the situation
-   Let \"logind\" make the system sleep

We\'ll configure the XServers screensaver-settings to pick up inactivity:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
  services.xserver.displayManager.sessionCommands = ''
    xset -dpms  # Disable Energy Star, as we are going to suspend anyway and it may hide "success" on that
    xset s blank # `noblank` may be useful for debugging 
    xset s 300 # seconds
    ${pkgs.lightlocker}/bin/light-locker --idle-hint &
  '';
</nowiki>}}
```
You\'ll have to re-login for the settings above to be applied.

The settings above will toggle the flag \"IdleHint\" within logind through
[light-locker](https://github.com/the-cavalry/light-locker#light-locker) (will work with \"\'lightdm\'\", there are
alternatives). Next we\'ll have to pick-up the information within logindand select an [action to
take](https://www.freedesktop.org/software/systemd/man/logind.conf.d.html#IdleAction=):

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
  systemd.targets.hybrid-sleep.enable = true;
  services.logind.extraConfig = ''
    IdleAction=hybrid-sleep
    IdleActionSec=20s
  '';
</nowiki>}}
```
The configuration above will let the system go to \"hybrid-sleep\" \`20s\` after the screen-saver triggered.

#### Troubleshooting

Check if the values of \"IdleSinceHint\" and \"IdleSinceHintMonotonic\" update using the command:

``` console
$ watch "loginctl show-session | grep Idle"
```

Try setting the flag manually (also need to disable manually):

``` console
$ dbus-send --system --print-reply \
    --dest=org.freedesktop.login1 /org/freedesktop/login1/session/self \
    "org.freedesktop.login1.Session.SetIdleHint" boolean:true
```

Check if the xset-settings have been applied properly and activate the screensaver manually:

``` console
$ xset q
$ sleep 1s && xset s activate
```

## Developer Environment for XMonad {#developer_environment_for_xmonad}

When developing modules for XMonad, it can help to install the following packages

``` nix
windowManager = {
  xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
      haskellPackages.dbus
      haskellPackages.List
      haskellPackages.monad-logger
    ];
  };
};
```

More information can be found [here](https://discourse.nixos.org/t/haskell-language-server-support-for-xmonad/12348) and
[here](https://www.srid.ca/xmonad-conf-ide).

#### Create a project around `xmonad.hs` {#create_a_project_around_xmonad.hs}

``` bash
echo "xmonad" >> $HIE_BIOS_OUTPUT 
```

```{=mediawiki}
{{file|~/.config/xmonad/hie.yaml|yaml|<nowiki>
cradle:
  bios:
    program: "./hie-bios.sh"
    with-ghc: "/nix/store/waa0dlvlszwbplrz5c7j674ab6v1n5wi-ghc-8.8.4-with-packages/bin/ghc"
</nowiki>}}
```
The \"with-ghc\" should be ghc that\'s in the \"ghc-with-packages\" dependency of the \"xmonad-with-packages\". It can
be easily found with \"[nix-tree](https://github.com/utdemir/nix-tree)\", which shows dependencies between packages on
the machine.

[Category:Window managers](Category:Window_managers "wikilink")
[Category:Applications](Category:Applications "wikilink")

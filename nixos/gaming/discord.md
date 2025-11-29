```{=mediawiki}
{{Infobox application
| name = Discord
| type = instant messaging and VoIP social platform
| image = Discord-Symbol-Blurple.svg
| developer = Discord Inc.
| website = https://discord.com/
| platform = Cross-platform (Linux, macOS, Windows, Web)
| github = https://github.com/discord
}}
```
Discord is an instant messaging and VoIP application with lots of functionality. It provides a web interface, though
most users would prefer to use a client for interoperability with their system.

## Installation

```{=mediawiki}
{{tip/unfree}}
```
### Official Clients {#official_clients}

Nixpkgs provides all three of Discord\'s release channels, accessible as `pkgs.discord`, `pkgs.discord-ptb`, and
`pkgs.discord-canary` respectively. Add any of the previous derivations to your package\'s configuration. For
[NixOS](NixOS "wikilink") this will be in `environment.systemPackages` or `users.users.``<name>`{=html}`.packages`.

``` nixos
# configuration.nix
{ config, lib, pkgs, ... }: {
  # This will install Discord PTB for all users of the system
  environment.systemPackages = with pkgs; [
    discord-ptb
  ];

  # This installs Discord PTB only for the user "alice"
  users.users.alice.packages = with pkgs; [
    discord-ptb
  ];
}
```

### Unofficial Clients {#unofficial_clients}

Nixpkgs also provides a vast variety of community developed/modded Discord clients, which can usually serve as drop-in
replacements for the official discord client with an extended set of features.
`{{Warning|The usage of such client's goes against Discord's [https://discord.com/terms TOS], and can result in your account being permanently suspended from the platform!}}`{=mediawiki}

#### Legcord (formerly ArmCord)[^1] {#legcord_formerly_armcord}

Lightweight, alternative desktop client with built-in modding extensibility. Nixpkgs provides this client via
`pkgs.legcord`.

``` nixos
{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    legcord
  ];
}
```

#### BetterDiscord[^2]

Enhances Discord desktop app with new features. Nixpkgs provides the installer via `pkgs.betterdiscordctl`. This can be
added to your configuration, though users may prefer to instead run it one-off via the [Nix](Nix "wikilink") cli.

``` bash
$ nix-shell -p betterdiscordctl --command 'betterdiscordctl install' # nix-legacy
$ nix run nixpkgs#betterdiscordctl -- install # nix3

$ nix-shell -p betterdiscordctl --command 'betterdiscordctl self-upgrade' # nix-legacy
$ nix run nixpkgs#betterdiscordctl -- self-upgrade # nix3
```

#### OpenAsar[^3]

Open-source alternative to Discord\'s `app.asar`. Nixpkgs provides this via `pkgs.openasar`, though this doesn\'t
provide a usable client. Users should instead prefer overriding the official discord package and add
`withOpenASAR = true`.

``` nixos
{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      # withVencord = true; # can do this here too
    })
  ];
}
```

#### Vencord[^4]

The cutest Discord client mod. The standalone Vencord client can be installed by overriding the official Discord package
via `withVencord = true`. `{{File|3={ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (discord.override {
      # withOpenASAR = true; # can do this here too
      withVencord = true;
    })
  ];
}|name=/etc/nixos/configuration.nix|lang=nix}}`{=mediawiki}

#### Vesktop[^5]

As opposed to just Vencord, the same developers also offer an integrated solution which aims to make the Linux
experience better.

It can be neatly managed via [Home Manager](Home_Manager "wikilink"), or just installed as a regular package via
`pkgs.vesktop`. `{{File|3={ config, lib, pkgs, ... }: {
  ...
  programs.vesktop = {
    enable = true;

    vencord.settings = {
      autoUpdate = true;
      autoUpdateNotification = true;
      notifyAboutUpdates = true;

      plugins = {
        ClearURLs.enabled = true;
        FixYoutubeEmbeds.enabled = true;
      };
    };
  };
  ...
}|name=home.nix|lang=nix}}`{=mediawiki}

#### Webcord[^6]

Discord and [Spacebar](https://spacebar.chat/) client implemented without using the official Discord API. Nixpkgs
provides this client via `pkgs.webcord`.

``` nixos
{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    webcord
  ];
}
```

## Troubleshooting

### Screen sharing on Wayland {#screen_sharing_on_wayland}

Since December 2024, Discord Canary supports screen sharing on Wayland. Alternatively, you can use the web version on a
browser that supports screen sharing on Wayland, or an [unofficial client](Discord#Unofficial_Clients "wikilink") like
*Webcord* or *Vesktop*, both of which have fixed this issue in their own ways.
`{{Note|Remember to configure an [https://wiki.archlinux.org/title/XDG_Desktop_Portal#List_of_backends_and_interfaces XDG Desktop Portal] with screen cast capabilities!}}`{=mediawiki}

### Notifications causing crashes {#notifications_causing_crashes}

Discord will crash if there is no compatible notification daemon running. This issue is only prevalent in custom desktop
environments, such as [Sway](Sway "wikilink") or [Hyprland](Hyprland "wikilink"). Comprehensive documentation usually
exists for most window managers/compositors and can be found on their respective wikis. Nixpkgs provides a few
standalone notification daemons such as `pkgs.dunst` and `pkgs.mako`. You may optionally use a notification daemon from
a larger DE, such as `pkgs.lxqt.lxqt-notificationd`, however it is unclear how effective these will be outside of their
normal environment.

``` nixos
{ config, lib, pkgs, ... }: {
  # You will need to add a call for the daemon to actually function.
  # This is usually done within the configuration of your respective WM.
  # See the official wiki/documentation for your WM for more info.
  environment.systemPackages = with pkgs; [
    mako
  ];
}
```

### \"Must be your lucky day\" popup {#must_be_your_lucky_day_popup}

Although Nixpkgs is usually very fast with updates (if you use *nixos-unstable*), you may still run into this issue
intermittently. You may override the discord package with a more up-to-date source, or you may disable this popup
entirely by adding `"SKIP_HOST_UPDATE": true` to `~/.config/discord/settings.json`.
`{{File|~/.config/discord/settings.json|json|
{
  "SKIP_HOST_UPDATE": true
<nowiki>}</nowiki>
}}`{=mediawiki}

### Krisp noise suppression {#krisp_noise_suppression}

The Krisp noise suppression option will not work on NixOS because the Discord binary is patched before installation, and
there is a DRM-style integrity check in the Krisp binary which prevents Krisp from working if the Discord binary is
modified. See <https://github.com/NixOS/nixpkgs/issues/195512> for details.

#### Python Script Workaround {#python_script_workaround}

```{=mediawiki}
{{Warning|The usage of such modifications goes against Discord's [https://discord.com/terms Terms of Service] and  Krisp's [https://krisp.ai/terms-of-use/ Terms of Use] and can result in your Discord account being terminated and/or being banned from using Krisp's services!}}
```
One way to enable Krisp noise suppression is by patching the `discord_krisp.node` binary to bypass its DRM verification.
Below is a Nix configuration that creates a Python script that patches the binary by modifying specific bytes to bypass
the license check:

``` nixos
{ pkgs, ... }:
let
  krisp-patcher =
    pkgs.writers.writePython3Bin "krisp-patcher"
      {
        libraries = with pkgs.python3Packages; [
          capstone
          pyelftools
        ];
        flakeIgnore = [
          "E501" # line too long (82 > 79 characters)
          "F403" # 'from module import *' used; unable to detect undefined names
          "F405" # name may be undefined, or defined from star imports: module
        ];
      }
      (
        builtins.readFile (
          pkgs.fetchurl {
            url = "https://pastebin.com/raw/8tQDsMVd";
            sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
          }
        )
      );
in
{
  environment.systemPackages = [
    krisp-patcher
  ];
}
```

```{=mediawiki}
{{Note|As of version 0.0.76, the script works. But, future versions of Discord may break the script. Therefore, you should not rely on this script for long-term use. For the latest updates and more details, follow https://github.com/NixOS/nixpkgs/issues/195512.}}
```
After adding this to your Nix configuration and rebuilding, make sure Discord is completely closed, and then run:

    $ krisp-patcher ~/.config/discord/0.0.76/modules/discord_krisp/discord_krisp.node

Once you restart Discord and join a VC, you should see a sound wave icon to the left of the hangup icon.

### Text-to-Speech {#text_to_speech}

TTS is disabled by default; you may enable it via an override:

``` nix
(pkgs.discord.override { withTTS = true; })
```

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

[^1]: <https://github.com/Legcord/Legcord>

[^2]: <https://betterdiscord.app/>

[^3]: <https://github.com/GooseMod/OpenAsar>

[^4]: <https://vencord.dev/>

[^5]: <https://github.com/Vencord/Vesktop>

[^6]: <https://github.com/SpacingBat3/WebCord>

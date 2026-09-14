```{=mediawiki}
{{Infobox application
| name = Discord
| image = Discord.svg
| type = instant messaging and VoIP social platform
| developer = Discord Inc.
| platform = Cross-platform (Linux, macOS, Windows, Web)
| github = discord
| website = https://discord.com/
}}
```
Discord is an instant messaging and VoIP application with lots of functionality. It provides a web interface, though
most users would prefer to use a client for interoperability with their system.

## Installation

### Official Clients {#official_clients}

```{=mediawiki}
{{tip/unfree}}
```
Nixpkgs provides all three of Discord\'s release channels: `pkgs.discord`, `pkgs.discord-ptb`, and
`pkgs.discord-canary`. Add any of these packages in `environment.systemPackages` or
`users.users.``<name>`{=html}`.packages`. `{{file|configuration.nix|nix|3=
{ config, lib, pkgs, ... }: {
  ...
  # This installs Discord PTB only for the user "alice"
  users.users.alice.packages = with pkgs; [
    discord-ptb
  ];
  # This will install Discord PTB for all users of the system
  environment.systemPackages = with pkgs; [
    discord-ptb
  ];
}
}}`{=mediawiki}

### Unofficial Clients {#unofficial_clients}

```{=mediawiki}
{{Warning|Use of unofficial clients goes against Discord's [https://discord.com/terms TOS] and possesses the risk of permanently suspending your account from the platform!}}
```
Nixpkgs also provides a vast variety of community developed/modded Discord clients, which can usually serve as drop-in
replacements for the official discord client with an extended set of features.

**Legcord[^1]** is a lightweight alternative desktop client featuring built-in modding extensibility via Vencord and
Equicord. Provided via `pkgs.legcord`.

**GoofCord[^2]** is a security oriented fork of Legcord. Provided via `pkgs.goofcord`.

**BetterDiscord[^3]** enhances Discord desktop app with new features. Installer provided via `pkgs.betterdiscordctl`,
but users may prefer to instead run it one-off via cli:

``` console
$ nix-shell -p betterdiscordctl --command 'betterdiscordctl install' # nix-legacy
$ nix run nixpkgs#betterdiscordctl -- install # nix3

$ nix-shell -p betterdiscordctl --command 'betterdiscordctl self-upgrade' # nix-legacy
$ nix run nixpkgs#betterdiscordctl -- self-upgrade # nix3
```

**OpenAsar[^4]** is an open-source alternative to Discord\'s `app.asar`. Provided via `pkgs.openasar` without usable
client. Users should instead prefer to override the official discord package and add `withOpenASAR = true`:
`{{file|configuration.nix|nix|3=
{ config, lib, pkgs, ... }: {
  ...
  environment.systemPackages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      # withVencord = true; # complementary
    })
  ];
}
}}`{=mediawiki}

**Vencord[^5]**, the cutest Discord client mod. Provided via `pkgs.vencord`. Standalone can be installed by overriding
the official Discord package via `withVencord = true`: `{{file|configuration.nix|nix|3=
{ config, lib, pkgs, ... }: {
  ...
  environment.systemPackages = with pkgs; [
    (discord.override {
      # withOpenASAR = true; # complementary
      withVencord = true;
    })
  ];
}
}}`{=mediawiki}

**Vesktop[^6]** is a customizable and privacy friendly desktop app by the developers of Discord\'s cutest client mod.
Provided via `pkgs.vesktop`. Can be configured in [Home Manager](Home_Manager "wikilink"): `{{file|home.nix|nix|3=
{ config, lib, pkgs, ... }: {
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
}
}}`{=mediawiki}

**Equicord[^7]**, other cutest Discord client mod. Provided via `pkgs.equicord`.

**Equibop[^8]**, a Vesktop fork by Equicord developers. Provided via `pkgs.equibop`.

**Dissent[^9]** is a simple, practical Discord client prioritizing speed over feature completeness. Provided via
`pkgs.dissent`.

**Discordo[^10]** is a TUI Discord client provided via `pkgs.discordo`. *Development in progress, possible crashes and
breaking changes.*

**Webcord[^11]** is a Discord and [Spacebar](https://spacebar.chat/) client implemented without using official Discord
API. Provided via `pkgs.webcord`.

**Ripcord[^12]** is an unfree client for Discord and [Slack](https://slack.com/intl/) with a traditional compact
interface for power users. Provided via `pkgs.ripcord`.

## Troubleshooting

### Wayland screen sharing {#wayland_screen_sharing}

Since December 2024, Discord Canary supports screen sharing on Wayland. Alternatively, you can use the web version on a
browser that supports screen sharing on Wayland, or an [unofficial client](Discord#Unofficial_Clients "wikilink") like
*Webcord* or *Vesktop*, both of which have fixed this issue in their own ways.
`{{Note|Remember to configure an [https://wiki.archlinux.org/title/XDG_Desktop_Portal#List_of_backends_and_interfaces XDG Desktop Portal] with screen cast capabilities!}}`{=mediawiki}

### Notifications-related crash {#notifications_related_crash}

Discord will crash if there is no compatible notification daemon running. This issue is only prevalent in custom desktop
environments, such as [Sway](Sway "wikilink") or [Hyprland](Hyprland "wikilink"). Comprehensive documentation usually
exists for most window managers/compositors and can be found on their respective wikis. Nixpkgs provides a few
standalone notification daemons such as `pkgs.dunst` and `pkgs.mako`. You may optionally use a notification daemon from
a larger DE, such as `pkgs.lxqt.lxqt-notificationd`, however it is unclear how effective these will be outside of their
normal environment. `{{file|configuration.nix|nix|3=
{ config, lib, pkgs, ... }: {
  ...
  # You will need to add a call for the daemon to actually function.
  # This is usually done within the configuration of your respective WM.
  # See the official wiki/documentation for your WM for more info.
  environment.systemPackages = with pkgs; [
    mako
  ];
}
}}`{=mediawiki}

### Start-up crash {#start_up_crash}

Occasionally, Discord\'s code can become corrupted, causing it to crash on start-up. You can force it to re-download the
latest version by deleting the `~/.config/discord/1.0.138`directory, where `1.0.138` is replaced with Discord\'s current
version number (the second line of output when running `discord` from a terminal).

### \"Must be your lucky day\" {#must_be_your_lucky_day}

Although Nixpkgs is usually very fast with updates (if you use *nixos-unstable*), you may still run into this issue
intermittently. You may override the discord package with a more up-to-date source, or you may disable this popup
entirely by adding `"SKIP_HOST_UPDATE": true` to `~/.config/discord/settings.json`:
`{{file|~/.config/discord/settings.json|json|
{
  "SKIP_HOST_UPDATE": true
<nowiki>}</nowiki>
}}`{=mediawiki}

### Krisp noise suppression {#krisp_noise_suppression}

The Krisp noise suppression option will not work on NixOS because the Discord binary is patched before installation, and
there is a DRM-style integrity check in the Krisp binary which prevents Krisp from working if the Discord binary is
modified. See <https://github.com/NixOS/nixpkgs/issues/195512> for details.

#### Python script workaround {#python_script_workaround}

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

``` console
$ krisp-patcher ~/.config/discord/0.0.76/modules/discord_krisp/discord_krisp.node
```

Once you restart Discord and join a VC, you should see a sound wave icon to the left of the hangup icon.

### Text-to-Speech {#text_to_speech}

TTS is disabled by default; you may enable it via an override:

``` nix
(pkgs.discord.override { withTTS = true; })
```

### Discord RPC not functioning {#discord_rpc_not_functioning}

Install **arRPC**[^13]: `{{file|configuration.nix|nix|3=
{ pkgs, ... }: {
  ...
  enviroment.systemPackages = with pkgs; [
    arrpc
  ];
  systemd.packages = with pkgs; [
    arrpc
  ];
}
}}`{=mediawiki}

Or add the following to your Home Manager configuration: `{{file|home.nix|nix|3=
{ pkgs, ... }: {
  ...
  services.arrpc = {
    enable = true;
    package = pkgs.arrpc; # Default
    systemdTarget = "graphical-session.target"; # default
  };
}
}}`{=mediawiki}

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

[^1]: <https://github.com/Legcord/Legcord>

[^2]: <https://github.com/Milkshiift/GoofCord>

[^3]: <https://github.com/BetterDiscord/BetterDiscord>

[^4]: <https://github.com/GooseMod/OpenAsar>

[^5]: <https://github.com/Vendicated/Vencord>

[^6]: <https://github.com/Vencord/Vesktop>

[^7]: <https://github.com/equicord/equicord>

[^8]: <https://github.com/Equicord/equibop>

[^9]: <https://github.com/diamondburned/dissent>

[^10]: <https://github.com/ayn2op/discordo>

[^11]: <https://github.com/SpacingBat3/WebCord>

[^12]: <https://cancel.fm/ripcord/>

[^13]: <https://github.com/OpenAsar/arrpc>

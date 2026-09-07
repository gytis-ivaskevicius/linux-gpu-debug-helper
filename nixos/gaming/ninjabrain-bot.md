```{=mediawiki}
{{Infobox application
| name = Ninjabrain Bot
| type = Native
| image = ninjabrainbot.png
| imageSize = 250px
| github = Ninjabrain1/Ninjabrain-Bot
| documentation = [https://github.com/Ninjabrain1/Ninjabrain-Bot/wiki GitHub Wiki]
| license = GNU General Public License v3.0
| os = Linux, macOS, Windows
}}
```
[**Ninjabrain Bot**](https://github.com/Ninjabrain1/Ninjabrain-Bot) is a stronghold calculator for Minecraft
speedrunning.

## Installation

Ninjabrain Bot is available in [Nixpkgs](Nixpkgs "wikilink") as `{{ic|ninjabrain-bot}}`{=mediawiki}.

### NixOS

Add it to `{{ic|environment.systemPackages}}`{=mediawiki}:

``` nix
{
  environment.systemPackages = with pkgs; [
    ninjabrain-bot
  ];
}
```

### Home Manager {#home_manager}

[Home Manager](Home_Manager "wikilink") can install Ninjabrain Bot and manage its preferences declaratively:

``` nix
{
  programs.ninjabrain-bot = {
    enable = true;
    package = pkgs.ninjabrain-bot;

    settings = {
      language = "en-US";
      windowSize = "small";
      showNetherCoordinates = true;
      theme = 1;
    };
  };
}
```

The preferences file is managed at `{{ic|~/.java/.userPrefs/ninjabrainbot/prefs.xml}}`{=mediawiki}. Changes made through
the application\'s settings window will be replaced on the next Home Manager activation.

See the [Home Manager option reference](https://nix-community.github.io/home-manager/options.xhtml) for all available
`{{ic|programs.ninjabrain-bot.settings}}`{=mediawiki} options.

## Hyprland

Ninjabrain Bot is a Java XWayland application. When tiled, Hyprland can give it a large window while the application
only draws its interface in part of it, leaving an empty black area.

Float the main window instead. Do not set a fixed size, as Ninjabrain Bot manages its own window size.

### Hyprland 0.55 and later {#hyprland_0.55_and_later}

Add this to `{{ic|~/.config/hypr/hyprland.lua}}`{=mediawiki}:

``` lua
hl.window_rule({
  name = "ninjabrain-bot",
  match = {
    class = "^ninjabrainbot-Main$",
  },
  float = true,
  center = true,
})
```

### Older Hyprland configurations {#older_hyprland_configurations}

Add these rules to `{{ic|~/.config/hypr/hyprland.conf}}`{=mediawiki}:

``` ini
windowrule = float, match:class ^ninjabrainbot-Main$
windowrule = center, match:class ^ninjabrainbot-Main$
```

The window class is case-sensitive and uses a hyphen: `{{ic|ninjabrainbot-Main}}`{=mediawiki}.

## See also {#see_also}

-   [Ninjabrain Bot](https://github.com/Ninjabrain1/Ninjabrain-Bot)
-   [Upstream documentation](https://github.com/Ninjabrain1/Ninjabrain-Bot/wiki)

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

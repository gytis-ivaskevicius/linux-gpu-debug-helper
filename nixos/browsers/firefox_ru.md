`<languages/>`{=html} `{{infobox application
  |name=Mozilla Firefox
  |image=Firefox logo, 2019.svg
  |type=Web Browser
  |developer=Mozilla Foundation & Community
  |firstRelease=November 9, 2004
  |latestRelease=Firefox 140.0 (June 24, 2025)
  |status=Active
  |license=[https://www.mozilla.org/MPL/2.0/ Mozilla Public License 2.0]
  |os=Cross-platform (Linux, macOS, Windows, *BSD)
  |website=[https://www.mozilla.org/firefox mozilla.org/firefox]
  |github=mozilla/firefox
  |bugTracker=[https://bugzilla.mozilla.org/ Bugzilla]
  |documentation=[https://support.mozilla.org/ Official Support]
}}`{=mediawiki}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
`<strong>`{=html}Firefox`</strong>`{=html}[^1] is a free and open-source web browser developed by the Mozilla
Foundation. It is known for its focus on privacy, security, and user freedom, offering a customizable experience through
a rich ecosystem of add-ons and themes.

```{=html}
</div>
```
`<span id="Installation">`{=html}`</span>`{=html}

## Установка

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Shell

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=bash|line=no|1=$ nix-shell -p firefox}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
The command above makes `firefox` available in your current shell without modifying any configuration files.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### System setup {#system_setup}

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=# Example for /etc/nixos/configuration.nix
environment.systemPackages = [
  pkgs.firefox
];

# User-specific installation (in ~/.config/nixpkgs/home.nix)
home.packages = [
  pkgs.firefox
];}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
After rebuilding with `nixos-rebuild switch`, Firefox will be installed system-wide.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## Configuration

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Basic

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=
programs.firefox = {
  enable = true;

  languagePacks = [ "en-US" "de" "fr" ];

  preferences = {
    "browser.startup.homepage"      = "https://example.com";
    "privacy.resistFingerprinting"  = true;
  };

  policies = {
    DisableTelemetry = true;
  };
};
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
The snippet above enables Firefox for all users (or the current Home Manager profile, if placed in `home.nix`).

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Advanced

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Home Manager allows for deep customization of Firefox, including extensions, search engines, bookmarks, and themes. The
example below shows a configuration for adding custom search engines with aliases.

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=
programs.firefox = {
  enable = true;

  languagePacks = [ "en-US" ];

  policies = {
    # Updates & Background Services
    AppAutoUpdate                 = false;
    BackgroundAppUpdate           = false;

    # Feature Disabling
    DisableBuiltinPDFViewer       = true;
    DisableFirefoxStudies         = true;
    DisableFirefoxAccounts        = true;
    DisableFirefoxScreenshots     = true;
    DisableForgetButton           = true;
    DisableMasterPasswordCreation = true;
    DisableProfileImport          = true;
    DisableProfileRefresh         = true;
    DisableSetDesktopBackground   = true;
    DisablePocket                 = true;
    DisableTelemetry              = true;
    DisableFormHistory            = true;
    DisablePasswordReveal         = true;

    # Access Restrictions
    BlockAboutConfig              = false;
    BlockAboutProfiles            = true;
    BlockAboutSupport             = true;

    # UI and Behavior
    DisplayMenuBar                = "never";
    DontCheckDefaultBrowser       = true;
    HardwareAcceleration          = false;
    OfferToSaveLogins             = false;
    DefaultDownloadDirectory      = "${home}/Downloads";

    # Extensions
    ExtensionSettings = let
      moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
    in {
      "*".installation_mode = "blocked";

      "uBlock0@raymondhill.net" = {
        install_url       = moz "ublock-origin";
        installation_mode = "force_installed";
        updates_disabled  = true;
      };

      "{f3b4b962-34b4-4935-9eee-45b0bce58279}" = {
        install_url       = moz "animated-purple-moon-lake";
        installation_mode = "force_installed";
        updates_disabled  = true;
      };

      "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
        install_url       = moz "noscript";
        installation_mode = "force_installed";
        updates_disabled  = true;
      };
    };

    # Extension configuration 
    "3rdparty".Extensions = {
      "uBlock0@raymondhill.net".adminSettings = {
        userSettings = rec {
          uiTheme            = "dark";
          uiAccentCustom     = true;
          uiAccentCustom0    = "#8300ff";
          cloudStorageEnabled = mkForce false;

          importedLists = [
            "https:#filters.adtidy.org/extension/ublock/filters/3.txt"
            "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
          ];

          externalLists = lib.concatStringsSep "\n" importedLists;
        };

        selectedFilterLists = [
          "CZE-0"
          "adguard-generic"
          "adguard-annoyance"
          "adguard-social"
          "adguard-spyware-url"
          "easylist"
          "easyprivacy"
          "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
          "plowe-0"
          "ublock-abuse"
          "ublock-badware"
          "ublock-filters"
          "ublock-privacy"
          "ublock-quick-fixes"
          "ublock-unbreak"
          "urlhaus-1"
        ];
      };
    };
  };

  profiles.default.search = {
    force           = true;
    default         = "DuckDuckGo";
    privateDefault  = "DuckDuckGo";

    engines = {
      "Nix Packages" = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              { name = "channel"; value = "unstable"; }
              { name = "query";   value = "{searchTerms}"; }
            ];
          }
        ];
        icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@np" ];
      };

      "Nix Options" = {
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = [
              { name = "channel"; value = "unstable"; }
              { name = "query";   value = "{searchTerms}"; }
            ];
          }
        ];
        icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@no" ];
      };

      "NixOS Wiki" = {
        urls = [
          {
            template = "https://wiki.nixos.org/w/index.php";
            params = [
              { name = "search"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nw" ];
      };
    };
  };
};
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
[More options are available on Home Manager\'s
site.](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.enable)

```{=html}
</div>
```
`<span id="Firefox_Variants">`{=html}`</span>`{=html}

## Версии Firefox {#версии_firefox}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
There are several Firefox variants available. To choose one, set the `programs.firefox.package` option accordingly.

```{=html}
</div>
```
```{=mediawiki}
{{Note|<span lang="en" dir="ltr" class="mw-content-ltr">The packages for the variants listed below are installed ''instead'' of the normal <code>firefox</code> package.</span>}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
### Variant: Official Binaries {#variant_official_binaries}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Mozilla provides official pre-built Firefox binaries via the `firefox-bin` package, which are downloaded directly from
Mozilla\'s servers.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
### Variant: Extended Support Release (ESR) {#variant_extended_support_release_esr}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
`firefox-esr` is a variant that receives security updates for a longer period with a slower feature implementation
cadence. It also allows for more extensive policy-based configuration.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
### Variant: Nightly {#variant_nightly}

```{=html}
</div>
```
```{=html}
<div class="mw-translate-fuzzy">
```
Nightly builds - это ежедневные сборки Firefox из центрального репозитория Mozilla.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Method 1: Using nix-community/flake-firefox-nightly {#method_1_using_nix_communityflake_firefox_nightly}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
This method is reproducible but may lag behind the upstream version. First, add the input to your flake:

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=
inputs = {
  firefox.url = "github:nix-community/flake-firefox-nightly";
  firefox.inputs.nixpkgs.follows = "nixpkgs";
};
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Then, add the package to your system:

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=
# In configuration.nix, assuming use of specialArgs
environment.systemPackages = [
  inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin
];
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Method 2: Using mozilla/nixpkgs-mozilla {#method_2_using_mozillanixpkgs_mozilla}

```{=html}
</div>
```
```{=html}
<div class="mw-translate-fuzzy">
```
Использование этого метода плохо сказывается на воспроизводимости, так как ресурсы берутся с URL-адресов, не относящихся
к привязке, но это также означает, что вы всегда получаете последнюю Nightly версию, когда собираете свою систему.

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=
nixpkgs.overlays = [
  (import (builtins.fetchTarball "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz"))
];
programs.firefox.package = pkgs.latest.firefox-nightly-bin;
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Using this method requires the `--impure` flag for Nix commands, for example:

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=bash|line=no|1=$ nixos-rebuild switch --impure}}
```
`<span id="Tips_and_Tricks">`{=html}`</span>`{=html}

```{=html}
<div class="mw-translate-fuzzy">
```
## Советы

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Force XWayland (X11) instead of Wayland {#force_xwayland_x11_instead_of_wayland}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Firefox defaults to native Wayland when running under a Wayland compositor. To force it to use XWayland (X11) instead:

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=environment.sessionVariables.MOZ_ENABLE_WAYLAND = "0";}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
This is useful when troubleshooting Wayland-specific issues or when certain features work better under X11.

```{=html}
</div>
```
`<span id="Touchpad_Gestures_and_Smooth_Scrolling">`{=html}`</span>`{=html}

```{=html}
<div class="mw-translate-fuzzy">
```
### Использовать Xinput2 {#использовать_xinput2}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Enable `xinput2` to improve touchscreen support and enable additional touchpad gestures and smooth scrolling.

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=
environment.sessionVariables.MOZ_USE_XINPUT2 = "1";
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### KDE Plasma Integration {#kde_plasma_integration}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
1\. Add the native messaging host package to your configuration:

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=programs.firefox.nativeMessagingHosts.packages = [ pkgs.kdePackages.plasma-browser-integration ];}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
2\. Install the corresponding [browser add-on](https://addons.mozilla.org/en-US/firefox/addon/plasma-integration/).

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Use KDE file picker {#use_kde_file_picker}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To use the KDE file picker instead of the GTK one, set the following preference:

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=
programs.firefox.preferences = {
  "widget.use-xdg-desktop-portal.file-picker" = 1;
};
}}
```
`<span id="Troubleshooting">`{=html}`</span>`{=html}

```{=html}
<div class="mw-translate-fuzzy">
```
## Устранение неполадок {#устранение_неполадок}

```{=html}
</div>
```
`<span id="Native_Messaging_Hosts_Fail_to_Load">`{=html}`</span>`{=html}

```{=html}
<div class="mw-translate-fuzzy">
```
### `nativeMessagingHosts` не работает {#nativemessaginghosts_не_работает}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Native messaging hosts (used for extensions like Plasma Integration) do not work with the `-bin` variants of Firefox or
with Firefox installed imperatively via `nix-env`. You must use a variant built from source via your NixOS or Home
Manager configuration.

```{=html}
</div>
```
`<span id="ALSA_audio_instead_of_PulseAudio">`{=html}`</span>`{=html}

```{=html}
<div class="mw-translate-fuzzy">
```
### Как использовать ALSA в Firefox вместо PulseAudio? {#как_использовать_alsa_в_firefox_вместо_pulseaudio}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To force Firefox to use ALSA, you can override it with a wrapper:

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=programs.firefox.package = pkgs.wrapFirefox pkgs.firefox-unwrapped { libpulseaudio = pkgs.libalsa; };}}
```
`<span id="Screen_Sharing_under_Wayland">`{=html}`</span>`{=html}

```{=html}
<div class="mw-translate-fuzzy">
```
### Поделиться Экраном через Wayland {#поделиться_экраном_через_wayland}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Screen sharing on Wayland requires enabling PipeWire and the appropriate XDG Desktop Portals.

```{=html}
</div>
```
```{=mediawiki}
{{code|lang=nix|line=no|1=
services.pipewire.enable = true;
xdg.portal = {
  enable = true;
  # Add the portal for your compositor, e.g.:
  extraPortals = with pkgs; [
    xdg-desktop-portal-wlr # For Sway/wlroots
    # xdg-desktop-portal-gtk # For GNOME
    # xdg-desktop-portal-kde # For KDE
  ];
};
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## See also {#see_also}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
-   [Home Manager](Home_Manager "wikilink") -- Declarative per-user configuration
-   [NixOS options for Firefox](https://search.nixos.org/options?channel=unstable&query=programs.firefox)
-   [Firefox topics on NixOS Discourse](https://discourse.nixos.org/tag/firefox)

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## References

```{=html}
</div>
```
[Category:Applications](Category:Applications "wikilink") [Category:Web Browser](Category:Web_Browser "wikilink")

[^1]: Mozilla Foundation, \"Firefox\", Official Website, Accessed June 2025. <https://www.mozilla.org/firefox>

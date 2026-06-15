`<languages/>`{=html} `<translate>`{=html}

## Installation

### NixOS

Add `<tvar name="chromium_package">`{=html}`{{nixos:package|chromium}}`{=mediawiki}`</tvar>`{=html} to
`<tvar name="systemPackages">`{=html}`{{NixOS Manual|name=systemPackages|anchor=#sec-package-management}}`{=mediawiki}`</tvar>`{=html}.

## Updating browser policies {#updating_browser_policies}

In Chromium, policy settings are accessible via
`<tvar name="chrome_policy_link">`{=html}`{{Ic|chrome://policy}}`{=mediawiki}`</tvar>`{=html}. They allow the user to
change enterprise policies affecting things like

-   Creating webapps when the browser is installed
-   Finding and downloading browser extensions automatically
-   Enabling or disabling the dinosaur game when the device is offline
-   Disable screenshots to be taken with browser extensions
-   Block all downloads from the browser (if you want to do that for some reason)
-   and more!

A full list of policies can be found at
\[`<tvar name=1>`{=html}<https://chromeenterprise.google/policies/>`</tvar>`{=html} Chrome Enterprise Policy List &
Management\].

### Natively Supported Policies {#natively_supported_policies}

By default NixOS provides a few policies that can be enabled directly, a simple example is given below to understand how
these are implemented `</translate>`{=html}

``` {.nixos .numberLines}
  programs.chromium = {
    enable = true;
    homepageLocation = "https://www.startpage.com/";
    extensions = [
      "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx" # dark reader
      "aapbdbdomjkkjkaonfhkkikfgjllcleb;https://clients2.google.com/service/update2/crx" # google translate
    ];
    extraOpts = {
      "WebAppInstallForceList" = [
        {
          "custom_name" = "Youtube";
          "create_desktop_shortcut" = false;
          "default_launch_container" = "window";
          "url" = "https://youtube.com";
        }
      ];
    };
  };
```

`<translate>`{=html}

-   `<tvar name="homepageLocation">`{=html}`{{Ic|homepageLocation}}`{=mediawiki}`</tvar>`{=html} option allows you to
    set the site that the homepage will open on
-   `<tvar name="extensions">`{=html}`{{Ic|extensions}}`{=mediawiki}`</tvar>`{=html} allows for the download of
    extensions directly in the browser through a simple list of the extension ID\'s that can be obtained from the
    \[`<tvar name="1">`{=html}<https://chromewebstore.google.com/>`</tvar>`{=html} Chrome Web Store\] by opening an
    extension page and copying the last part of the URL
    -   In the example however there is another component, the download source from which the extensions will be
        downloaded
    -   The URL provided in the list is the link that is used by google for managing, checking and updating extensions
    -   So the method of just placing the extension ID can work like this:
        `<tvar name="ext_id">`{=html}`{{Ic|"fnpbehpgglbfnpimkachnpnecjncndgm"}}`{=mediawiki}`</tvar>`{=html}
    -   But just in case that method does not automatically function the second method is shown above, where you place
        `<tvar name="symbol">`{=html}`{{Ic|;}}`{=mediawiki}`</tvar>`{=html} and then the URL
        `<tvar name="url">`{=html}`{{Ic|https //clients2.google.com/service/update2/crx}}`{=mediawiki}`</tvar>`{=html}
        to explicitly tell NixOS where to install the extension from
-   There are many more options that are natively supported and you can learn about them through
    `<tvar name="command">`{=html}`{{Ic|man configuration.nix}}`{=mediawiki}`</tvar>`{=html}
-   But as shown above there is also an `<tvar name="extraOpts">`{=html}`{{Ic|extraOpts}}`{=mediawiki}`</tvar>`{=html}
    option and that is used for policies that are not supported for direct setup, such as the policy to install web-apps

### Non-natively Supported Policies {#non_natively_supported_policies}

There are hundreds of policies in Chromium based browsers, and not all have direct methods to set them. The
`<tvar name="extraOpts">`{=html}`{{Ic|extraOpts}}`{=mediawiki}`</tvar>`{=html} option allows for the declaration of all
the other policies.

There is no single place to find all Chromium policies, but these are some places to look;

-   Commonly used policies are present and documented within `{{Ic|man configuration.nix}}`{=mediawiki} under
    `{{Ic|programs.chromium}}`{=mediawiki}.
-   You can navigate to `<tvar name="chrome_policy_link">`{=html}`{{Ic|chrome://policy}}`{=mediawiki}`</tvar>`{=html}
    and enable \"Show policies with no value set\" to see all available keys. Clicking a policy name opens its specific
    definition and usage details.
-   The most up to date policies for Chromium are available in the
    \[`<tvar name="1">`{=html}<https://source.chromium.org/chromium/chromium/src/+/main:chrome/common/pref_names.h>`</tvar>`{=html}
    source code.\]

## Accelerated video playback {#accelerated_video_playback}

Make sure [Accelerated Video Playback](<tvar_name="1">Special:MyLanguage/Accelerated_Video_Playback</tvar> "wikilink")
is setup on the system properly. Check
`<tvar name="chrome_gpu_link">`{=html}`{{ic|chrome://gpu}}`{=mediawiki}`</tvar>`{=html} to see if Chromium has enabled
hardware acceleration.

If accelerated video playback is not working, check relevant flags at
`<tvar name="chrome_flags_link">`{=html}`{{ic|chrome://flags}}`{=mediawiki}`</tvar>`{=html}, or enable them using the
CLI: `</translate>`{=html}

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  environment.systemPackages = with pkgs; [
    (chromium.override {
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
  ];
}
</nowiki>}}
```
`<translate>`{=html} In some cases,
`<tvar name="chrome_gpu_link">`{=html}`{{ic|chrome://gpu}}`{=mediawiki}`</tvar>`{=html} will show Video Decode as
enabled, but Video Acceleration Information as blank, with
`<tvar name="chrome_media_link">`{=html}`{{ic|chrome://media-internals}}`{=mediawiki}`</tvar>`{=html} using the FFmpeg
Video Decoder (software decoding). If this happens, try to enable the following features: `</translate>`{=html}

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  environment.systemPackages = with pkgs; [
    (chromium.override {
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
        "--enable-features=UseMultiPlaneFormatForHardwareVideo"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
  ];
}
</nowiki>}}
```
`<translate>`{=html}

## Enabling native Wayland support {#enabling_native_wayland_support}

You can enable native Wayland support in all Chromium based and most Electron apps by setting the \`NIXOS_OZONE_WL\`
environment variable to \`1\`.

## Enabling DRM (Widevine support) {#enabling_drm_widevine_support}

By default, `<tvar name="chromium_package">`{=html}`{{nixos:package|chromium}}`{=mediawiki}`</tvar>`{=html} does not
support playing DRM protected media. However, there is a build time flag to include the proprietary Widevine blob from
Nixpkgs: `</translate>`{=html}

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  environment.systemPackages = with pkgs; [
    (chromium.override { enableWideVine = true; })
  ];
}
</nowiki>}}
```
`<translate>`{=html}

## KeePassXC support in Flatpak {#keepassxc_support_in_flatpak}

To enable browser integration between KeePassXC and Chromium-based browsers when running in Flatpak, configure the
following filesystem access: `</translate>`{=html}

``` toml
# NativeMessagingHost directory (browser-specific)
# Brave Browser
xdg-config/BraveSoftware/Brave-Browser/NativeMessagingHosts:ro
# Chromium
xdg-config/chromium/NativeMessagingHosts:ro
# Google Chrome
xdg-config/google-chrome/NativeMessagingHosts:ro

# KeePassXC server socket and Nix store
xdg-run/app/org.keepassxc.KeePassXC/org.keepassxc.KeePassXC.BrowserServer
/nix/store:ro
```

`<translate>`{=html}

## Using libc memory allocator {#using_libc_memory_allocator}

Chromium may not work when an alternative system-wide memory allocator like scudo is used. To use libc on Chromium, the
following firejail wrap is required: `</translate>`{=html}

``` nix
programs.firejail = {
  enable = true;
  wrappedBinaries = {
    chromium = {
      executable = "${pkgs.chromium}/bin/chromium-browser";
      profile = "${pkgs.firejail}/etc/firejail/chromium-browser.profile";
      extraArgs = [
        "--blacklist=/etc/ld-nix.so.preload"
      ];
    };
  };
};
```

`<translate>`{=html}

## Add support for Brave Browser in Profile Sync daemon {#add_support_for_brave_browser_in_profile_sync_daemon}

Adding Brave Browser support to Profile Sync daemon can be automated with an overlay. `</translate>`{=html}

``` nix
# /etc/nixos/configuration.nix
{
  nixpkgs = {
    overlays = [
      (final: prev: {
        profile-sync-daemon = prev.profile-sync-daemon.overrideAttrs (oldAttrs: {
          installPhase =
            oldAttrs.installPhase
            + ''
              cp $out/share/psd/{contrib,browsers}/brave
            '';
        });
      })
    ];
  };

  # Enable the Profile Sync daemon service.
  services.psd.enable = true;
}
```

[Category:Applications](Category:Applications "wikilink") [Category:Web
Browser{{#translation:}}](Category:Web_Browser{{#translation:}} "wikilink")

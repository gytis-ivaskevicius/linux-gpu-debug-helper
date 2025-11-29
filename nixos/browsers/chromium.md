`<languages/>`{=html} `<translate>`{=html}

## Installation

### NixOS

Add `{{nixos:package|chromium}}`{=mediawiki} to
`{{NixOS Manual|name=systemPackages|anchor=#sec-package-management}}`{=mediawiki}.

## Updating browser policies {#updating_browser_policies}

In Chromium the policy settings, which can be accessed by using `{{Ic|chrome://policy}}`{=mediawiki}, allow the user to
change a lot of settings that dont exist anywhere else such as

-   Creating webapps when the browser is installed
-   Finding and downloading browser extensions automatically
-   Enabling or disabling the dinosaur game when the device is offline
-   Disable screenshots to be taken with browser extensions
-   Block all downloads from the browser (if you want to do that for some reason)
-   and hundreds more settings

### Natively Supported Policies {#natively_supported_policies}

By default NixOS provides a few policies that can be enabled directly, a simple example is given below to understand how
these are implemented

`</translate>`{=html}

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

-   ```{=mediawiki}
    {{Ic|homepageLocation}}
    ```
    option allows you to set the site that the homepage will open on

-   ```{=mediawiki}
    {{Ic|extensions}}
    ```
    allows for the download of extensions directly in the browser through a simple list of the extension ID\'s that can
    be obtained from the [Chrome Web Store](https://chromewebstore.google.com/) by opening an extension page and copying
    the last part of the URL

    -   In the example however there is another component, the download source from which the extensions will be
        downloaded
    -   The URL provided in the list is the link that is used by google for managing, checking and updating extensions
    -   So the method of just placing the extension ID can work like this:
        `{{Ic|"fnpbehpgglbfnpimkachnpnecjncndgm"}}`{=mediawiki}
    -   But just in case that method does not automatically function the second method is shown above, where you place
        `{{Ic|;}}`{=mediawiki} and then the URL `{{Ic|https //clients2.google.com/service/update2/crx}}`{=mediawiki} to
        explicitly tell NixOS where to install the extension from

-   There are many more options that are natively supported and you can learn about them through
    `{{Ic|man configuration.nix}}`{=mediawiki}

-   But as shown above there is also an `{{Ic|extraOpts}}`{=mediawiki} option and that is used for policies that are not
    supported for direct setup, such as the policy to install web-apps

### Non-natively Supported Policies {#non_natively_supported_policies}

As stated beforehand, there are hundreds of policies that are in chromium based browsers and not all of them can be
supported directly and so the `{{Ic|extraOpts}}`{=mediawiki} option allows for the declaration of all the other policies

There is no one place to find all the policies and some places you can find a \"list\" are given below:

-   A good number of commonly used policies are present and explained within `{{Ic|man configuration.nix}}`{=mediawiki}
    under `{{Ic|programs.chromium}}`{=mediawiki}
-   If you require a more comprehensive list then you can go to `{{Ic|chrome://policy}}`{=mediawiki} and click on the
    checkbox at the top of the page that says \"Show policies with no value set\", from there you can click on any of
    the policies to go to the documentation page for that policy to get details on how to use it
-   If you just want to see the list of all policies supported by chromium then you cant really do that, unfortunately
    google does not provide documentation on every single policy in the chromium browser base and if you wish to see the
    list of every single policy then you can do so by going directly to the source code and figuring out how a policy
    works
-   To see the most up-to-date file on all policies you can go
    [here](https://source.chromium.org/chromium/chromium/src/+/main:chrome/common/pref_names.h)

## Accelerated video playback {#accelerated_video_playback}

Make sure [Accelerated Video Playback](Special:MyLanguage/Accelerated_Video_Playback "wikilink") is setup on the system
properly. Check `{{ic|chrome://gpu}}`{=mediawiki} to see if Chromium has enabled hardware acceleration.

If accelerated video playback is not working, check relevant flags at `{{ic|chrome://flags}}`{=mediawiki}, or enable
them using the cli:

`</translate>`{=html} `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
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
</nowiki>}}`{=mediawiki} `<translate>`{=html}

In some cases, `{{ic|chrome://gpu}}`{=mediawiki} will show Video Decode as enabled, but Video Acceleration Information
as blank, with `{{ic|chrome://media-internals}}`{=mediawiki} using FFmpeg Video Decoder (software decoding). If this
happens, try to enable the following features:

`</translate>`{=html} `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
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
</nowiki>}}`{=mediawiki} `<translate>`{=html}

## Enabling native Wayland support {#enabling_native_wayland_support}

You can turn on native Wayland support in all chrome and most electron apps by setting an environment variable:
`environment.sessionVariables.NIXOS_OZONE_WL = "1"`.

## Enabling ManifestV2 support {#enabling_manifestv2_support}

To enable manifest v2 support `ExtensionManifestV2Availability` can be set to `2`.[^1]

`</translate>`{=html} `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  programs.chromium = {
    extraOpts = {
    "ExtensionManifestV2Availability" = 2;
    };
  };
}
</nowiki>}}`{=mediawiki} `<translate>`{=html}

## Enabling DRM (Widevine support) {#enabling_drm_widevine_support}

By default, `{{nixos:package|chromium}}`{=mediawiki} does not support playing DRM protected media. However, there is a
build time flag to include the unfree Widevine blob from nixpkgs:

`</translate>`{=html} `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  environment.systemPackages = with pkgs; [
    (chromium.override { enableWideVine = true; })
  ];
}
</nowiki>}}`{=mediawiki} `<translate>`{=html}

## KeePassXC support in Flatpak {#keepassxc_support_in_flatpak}

To enable browser integration between KeePassXC and Chromium-based browsers when running in Flatpak, configure the
following filesystem access:

`</translate>`{=html}

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
following firejail wrap is required:

`</translate>`{=html}

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

[Category:Applications](Category:Applications "wikilink") [Category:Web
Browser{{#translation:}}](Category:Web_Browser{{#translation:}} "wikilink")

[^1]: <https://chromeenterprise.google/policies/#ExtensionManifestV2Availability>

`<languages/>`{=html} Accelerated video playback in NixOS is generally done by adding relevant packages to
`{{nixos:option|hardware.graphics.extraPackages}}`{=mediawiki}.

## Installation

### Intel

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # For older processors. LIBVA_DRIVER_NAME=i965
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Optionally, set the environment variable
}
</nowiki>}}
```
Note, `intel-vaapi-driver` still performs better for browsers (gecko/chromium based) on newer Skylake (2015)
processors.[^1]

For 32-bit support, use `{{nixos:option|hardware.graphics.extraPackages32}}`{=mediawiki}:
`{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
}
</nowiki>}}`{=mediawiki}

### AMD

AMD configuration (at least for Ryzen 5 iGPUs) works out of the box: `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.graphics.enable = true;
}
</nowiki>}}`{=mediawiki}

### NVIDIA

NVIDIA do not officially support accelerated video playback on Linux. A third-party implementation exists, but does not
support Chrome[^2], and has significant limitations compared to the other implementations[^3].

NVIDIA users with a separate iGPU should generally prefer to use their iGPU for this, and therefore look to the above
Intel and AMD sections instead.

Users with only an NVIDIA GPU can attempt to use the third party implementation; the package is added to
`hardware.graphics.extraPackages` by default, but it requires some additional setup to be useful[^4]:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{ config, lib, ...}: {
  environment.variables.LIBVA_DRIVER_NAME = "nvidia"

  # If used with Firefox
  environment.variables.MOZ_DISABLE_RDD_SANDBOX = "1";

  programs.firefox.preferences = let
    ffVersion = config.programs.firefox.package.version;
  in {
    "media.ffmpeg.vaapi.enabled" = lib.versionOlder ffVersion "137.0.0";
    "media.hardware-video-decoding.force-enabled" = lib.versionAtLeast ffVersion "137.0.0";
    "media.rdd-ffmpeg.enabled" = lib.versionOlder ffVersion "97.0.0";

    "gfx.x11-egl.force-enabled" = true;
    "widget.dmabuf.force-enabled" = true;

    # Set this to true if your GPU supports AV1.
    #
    # This can be determined by reading the output of the
    # `vainfo` command, after the driver is enabled with
    # the environment variable.
    "media.av1.enabled" = false;
  };
}
</nowiki>}}
```
## Testing your configuration {#testing_your_configuration}

You can test your configuration by running: `nix-shell -p libva-utils --run vainfo` See [Arch Linux wiki#Hardware video
acceleration](https://wiki.archlinux.org/index.php/Hardware_video_acceleration#Verification) for more information.

## Applications

### Chromium

See [Chromium#Accelerated_video_playback](Chromium#Accelerated_video_playback "wikilink").

### Firefox

See [Arch Linux wiki#Firefox](https://wiki.archlinux.org/index.php/Firefox#Hardware_video_acceleration).

### MPV

You can place the following configuration in `{{ic|~/.config/mpv/mpv.conf}}`{=mediawiki}:

``` ini
hwdec=auto
```

See [Arch Linux wiki#mpv](https://wiki.archlinux.org/title/mpv#Hardware_video_acceleration).

## Also see {#also_see}

-   [Arch Linux wiki#Hardware video acceleration](https://wiki.archlinux.org/index.php/Hardware_video_acceleration).
-   [nixos-hardware](https://github.com/NixOS/nixos-hardware) has example configurations for various types of hardware.

[Category:Video](Category:Video "wikilink")

[^1]: <https://github.com/intel/media-driver/issues/1024>

[^2]: <https://github.com/elFarto/nvidia-vaapi-driver#chrome>

[^3]: <https://github.com/elFarto/nvidia-vaapi-driver#codec-support>

[^4]: <https://github.com/elFarto/nvidia-vaapi-driver#configuration>

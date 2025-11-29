`<languages/>`{=html}

```{=html}
<div class="mw-translate-fuzzy">
```
Ускорение воспроизведения видео в NixOS обычно осуществляется путем добавления соответствующих пакетов в
`{{nixos:option|hardware.opengl.extraPackages}}`{=mediawiki}.

```{=html}
</div>
```
`<span id="Installation">`{=html}`</span>`{=html}

## Установка

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
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Note, `intel-vaapi-driver` still performs better for browsers (gecko/chromium based) on newer Skylake (2015)
processors.[^1]

```{=html}
</div>
```
Для поддержки 32-битной версии используйте `{{nixos:option|hardware.graphics.extraPackages32}}`{=mediawiki}:
`{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
}
</nowiki>}}`{=mediawiki}

### AMD

Конфигурация AMD (по крайней мере, для iGPU Ryzen 5) работает из коробки:
`{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.graphics.enable = true;
}
</nowiki>}}`{=mediawiki}

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
### NVIDIA

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
NVIDIA do not officially support accelerated video playback on Linux. A third-party implementation exists, but does not
support Chrome[^2], and has significant limitations compared to the other implementations[^3].

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
NVIDIA users with a separate iGPU should generally prefer to use their iGPU for this, and therefore look to the above
Intel and AMD sections instead.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Users with only an NVIDIA GPU can attempt to use the third party implementation; the package is added to
`hardware.graphics.extraPackages` by default, but it requires some additional setup to be useful[^4]:

```{=html}
</div>
```
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
`<span id="Testing_your_configuration">`{=html}`</span>`{=html}

## Проверьте вашу конфигурацию {#проверьте_вашу_конфигурацию}

Вы можете протестировать вашу конфигурацию выполнив: `nix-shell -p libva-utils --run vainfo`

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
See [Arch Linux wiki#Hardware video
acceleration](https://wiki.archlinux.org/index.php/Hardware_video_acceleration#Verification) for more information.

```{=html}
</div>
```
`<span id="Applications">`{=html}`</span>`{=html}

## Приложения

### Chromium

См. [Chromium#Accelerated_video_playback](Chromium#Accelerated_video_playback "wikilink").

### Firefox

```{=html}
<div class="mw-translate-fuzzy">
```
### Firefox {#firefox_1}

```{=html}
</div>
```
### MPV

Вы можете разместить следующую конфигурацию в `{{ic|~/.config/mpv/mpv.conf}}`{=mediawiki}:

``` ini
hwdec=auto
```

```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
See [Arch Linux wiki#mpv](https://wiki.archlinux.org/title/mpv#Hardware_video_acceleration).

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## Also see {#also_see}

-   [Arch Linux wiki#Hardware video acceleration](https://wiki.archlinux.org/index.php/Hardware_video_acceleration).
-   [nixos-hardware](https://github.com/NixOS/nixos-hardware) has example configurations for various types of hardware.

```{=html}
</div>
```
[Category:Video](Category:Video "wikilink")

[^1]: <https://github.com/intel/media-driver/issues/1024>

[^2]: <https://github.com/elFarto/nvidia-vaapi-driver#chrome>

[^3]: <https://github.com/elFarto/nvidia-vaapi-driver#codec-support>

[^4]: <https://github.com/elFarto/nvidia-vaapi-driver#configuration>

`<languages/>`{=html} NixOS 中的视频播放加速通常是通过向 `{{nixos:option|hardware.graphics.extraPackages}}`{=mediawiki}
添加相关包来完成的。

`<span id="Installation">`{=html}`</span>`{=html}

## 安装

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
注意，`intel-vaapi-driver` 在较新的 Skylake (2015) 处理器上对于浏览器（基于 gecko/chromium）仍然表现更好。[^1]

对于 32 位支持，请使用 `{{nixos:option|hardware.graphics.extraPackages32}}`{=mediawiki}:
`{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
}
</nowiki>}}`{=mediawiki}

### AMD

AMD 相关硬件（至少对于 Ryzen 5 iGPU 系列）支持开箱即用： `{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.graphics.enable = true;
}
</nowiki>}}`{=mediawiki}

### NVIDIA

NVIDIA 官方并未支持 Linux 上的视频播放加速。虽然存在第三方实现，但不支持
Chrome[^2]，并且与其他实现[^3]相比存在显著限制。

拥有独立 iGPU 的 NVIDIA 用户通常应该更喜欢使用他们的 iGPU 来实现此目的，因此请参考上面的 Intel 和 AMD 部分。

仅具有 NVIDIA GPU 的用户可以尝试使用第三方实现；默认情况下，添加软件包到
`hardware.graphics.extraPackages`，但之后需要进行一些额外的设置才能使用[^4]：

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

## 测试您的配置

您可以通过运行以下命令来测试您的配置：`nix-shell -p libva-utils --run vainfo` 有关更多信息，请参阅 [Arch Linux wiki
的硬件视频加速](https://wiki.archlinux.org/index.php/Hardware_video_acceleration#Verification)。
`<span id="Applications">`{=html}`</span>`{=html}

## 应用

### Chromium

请参阅 [Chromium 视频加速](Special:MyLanguage/Chromium#Accelerated_video_playback "Chromium 视频加速"){.wikilink}.

### Firefox

请参阅 [Arch Linux wiki 的 Firefox 部分](https://wiki.archlinux.org/index.php/Firefox#Hardware_video_acceleration).

### MPV

您可以将以下配置放在 `{{ic|~/.config/mpv/mpv.conf}}`{=mediawiki} 中：

``` ini
hwdec=auto
```

请参阅 [Arch Linux wiki 的 mpv 部分](https://wiki.archlinux.org/title/mpv#Hardware_video_acceleration).

## 另请参阅

- [Arch Linux wiki 的硬件视频加速](https://wiki.archlinux.org/index.php/Hardware_video_acceleration)。
- [nixos-hardware](https://github.com/NixOS/nixos-hardware) 包含各种硬件类型的示例配置。

[Category:Video](Category:Video "Category:Video"){.wikilink}

[^1]: <https://github.com/intel/media-driver/issues/1024>

[^2]: <https://github.com/elFarto/nvidia-vaapi-driver#chrome>

[^3]: <https://github.com/elFarto/nvidia-vaapi-driver#codec-support>

[^4]: <https://github.com/elFarto/nvidia-vaapi-driver#configuration>

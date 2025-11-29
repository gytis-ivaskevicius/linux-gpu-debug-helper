[ja:ハードウェアビデオアクセラレーション](ja:ハードウェアビデオアクセラレーション "wikilink") [ru:Hardware video
acceleration](ru:Hardware_video_acceleration "wikilink") [zh-hans:Hardware video
acceleration](zh-hans:Hardware_video_acceleration "wikilink")

[Hardware video acceleration](Wikipedia:Graphics_processing_unit#GPU_accelerated_video_decoding_and_encoding "wikilink")
makes it possible for the video card to decode/encode video, thus offloading the CPU and saving power.

There are several ways to achieve this on Linux:

-   [Video Acceleration API](Wikipedia:Video_Acceleration_API "wikilink") (VA-API) is a specification and open source
    library to provide both hardware accelerated video encoding and decoding, developed by Intel.
-   [Video Decode and Presentation API for Unix](Wikipedia:VDPAU "wikilink") (VDPAU) is an open source library and API
    to offload portions of the video decoding process and video post-processing to the GPU video-hardware, developed by
    NVIDIA.
-   [Advanced Media Framework SDK](https://gpuopen.com/advanced-media-framework/) (AMF) is an open source framework
    which allows \"Optimal\" access to AMD GPUs for multimedia processing using the [AMDGPU PRO](AMDGPU_PRO "wikilink")
    Stack, Developed by AMD.
-   [NVDEC](Wikipedia:Nvidia_NVDEC "wikilink")/[NVENC](Wikipedia:Nvidia_NVENC "wikilink") - NVIDIA\'s proprietary APIs
    for hardware video acceleration, used by NVIDIA GPUs from Fermi onwards.
-   [Vulkan Video](https://www.khronos.org/blog/an-introduction-to-vulkan-video) is an extension of the
    [Vulkan](Vulkan "wikilink") graphics API designed to support hardware-accelerated video encoding and decoding.

For comprehensive overview of driver and application support see [#Comparison tables](#Comparison_tables "wikilink").

## Installation

### Intel

#### VA-API {#va_api}

[Intel graphics](Intel_graphics "wikilink") open-source drivers support VA-API:

-   HD Graphics series starting from [Broadwell](https://github.com/intel/media-driver/#supported-platforms)
    [(2014)](wikipedia:Template:Intel_processor_roadmap "wikilink") and newer (e.g. Intel Arc) are supported by
    `{{Pkg|intel-media-driver}}`{=mediawiki}.
-   GMA 4500 (2008) up to [Coffee Lake](wikipedia:Coffee_Lake "wikilink") (2017) are supported by
    `{{Pkg|libva-intel-driver}}`{=mediawiki}.
-   [Haswell Refresh](Wikipedia:Haswell_(microarchitecture)#Haswell_Refresh "wikilink") to Skylake VP9 decoding and
    Broadwell to Skylake hybrid VP8 encoding is supported by `{{AUR|intel-hybrid-codec-driver-git}}`{=mediawiki}.

```{=mediawiki}
{{Note|Skylake or later also need {{Pkg|linux-firmware-intel}}.}}
```
Also see [VAAPI supported hardware and
features](https://www.intel.com/content/www/us/en/developer/articles/technical/linuxmedia-vaapi.html).

#### Vulkan Video {#vulkan_video}

ANV open-source [vulkan](vulkan "wikilink") driver provides Vulkan Video support via `{{Pkg|vulkan-intel}}`{=mediawiki}.

```{=mediawiki}
{{Note|Enabling Vulkan Video requires additional configuration, see [[#Configuring Vulkan Video]]}}
```
#### Intel Video Processing Library (Intel VPL) {#intel_video_processing_library_intel_vpl}

For [Intel VPL](https://github.com/intel/libvpl), [install](install "wikilink") the base library
`{{Pkg|libvpl}}`{=mediawiki}, and at least one of the following runtime implementations:

-   ```{=mediawiki}
    {{Pkg|vpl-gpu-rt}}
    ```
    : provides support for Tiger Lake and newer GPUs

-   ```{=mediawiki}
    {{Pkg|intel-media-sdk}}
    ```
    (Discontinued): provides support for older Intel GPUs

### NVIDIA

[Nouveau](Nouveau "wikilink") open-source driver supports both VA-API and VDPAU:

-   GeForce 8 series and newer GPUs up until GeForce GTX 750 are supported by `{{Pkg|mesa}}`{=mediawiki}.
-   [Requires](https://nouveau.freedesktop.org/wiki/VideoAcceleration/#firmware) `{{AUR|nouveau-fw}}`{=mediawiki}
    firmware package, presently extracted from the NVIDIA binary driver.

[NVIDIA](NVIDIA "wikilink") proprietary driver supports via `{{Pkg|nvidia-utils}}`{=mediawiki}:

-   VDPAU on [GeForce 8 series](Wikipedia:GeForce_8_series "wikilink") and newer GPUs;
-   NVDEC on [Fermi](Wikipedia:Fermi_(microarchitecture) "wikilink") and newer GPUs
    [1](https://developer.download.nvidia.com/assets/cuda/files/NVIDIA_Video_Decoder.pdf);
-   NVENC on [Kepler](Wikipedia:Kepler_(microarchitecture) "wikilink") and newer GPUs;
-   Vulkan Video on [Pascal](Wikipedia:Pascal_(microarchitecture) "wikilink") and newer GPUs
    [2](https://developer.nvidia.com/vulkan/video/get-started).

### AMD/ATI

[AMD](AMD "wikilink") and [ATI](ATI "wikilink") open-source drivers support VA-API via `{{Pkg|mesa}}`{=mediawiki}:

-   VA-API on Radeon HD 2000 and newer GPUs.

RADV open-source [vulkan](vulkan "wikilink") driver provides Vulkan Video support via
`{{Pkg|vulkan-radeon}}`{=mediawiki}.

[AMDGPU PRO](AMDGPU_PRO "wikilink") proprietary driver is built on top of AMDGPU driver and supports both VA-API and
VDPAU in addition to AMF.

-   AMF on [Fiji](Wikipedia:Radeon_Rx_300_series "wikilink") and newer GPUs supported by
    `{{AUR|amf-amdgpu-pro}}`{=mediawiki}.

```{=mediawiki}
{{Note|
* You may need to force your application to use [[AMDGPU PRO]] [[Vulkan]] Driver.
* [[Wikipedia:High Efficiency Video Coding|HEVC]] encoding may not be available on GPUs older than [[Wikipedia:Radeon RX 5000 series|Navi]].
}}
```
### Translation layers {#translation_layers}

-   ```{=mediawiki}
    {{App|libvdpau-va-gl|VDPAU driver with OpenGL/VAAPI backend. H.264 only.|https://github.com/i-rinat/libvdpau-va-gl|{{Pkg|libvdpau-va-gl}}}}
    ```

-   ```{=mediawiki}
    {{App|nvidia-vaapi-driver|A [[CUDA]] NVDEC based backend for VA-API.|https://github.com/elFarto/nvidia-vaapi-driver/|{{Pkg|libva-nvidia-driver}}}}
    ```

```{=mediawiki}
{{Note|While the {{Pkg|libva-nvidia-driver}} implementation does enable hardware video decoding, current limits for NVIDIA power management mean that with default settings it actually [https://github.com/elFarto/nvidia-vaapi-driver/issues/74 consumes more power than CPU video decoding].
A workaround is possible using NVIDIA driver version 580.105.08 or newer, exporting the environment variable {{ic|CUDA_DISABLE_PERF_BOOST{{=}}1}}
```
.}}

## Verification

Your system may work perfectly out-of-the-box without needing any configuration. Therefore it is a good idea to start
with this section to see that it is the case.

```{=mediawiki}
{{Tip|
* [[mpv#Hardware video acceleration|mpv]] with its command-line support is great for testing hardware acceleration. Look at the log of {{ic|1=mpv --hwdec=auto ''video_filename''}} and see [https://mpv.io/manual/stable/#options-hwdec hwdec] for more details.
* Use {{Pkg|nvtop}} to check "DEC" (decoder) usage on the top lines while playing a video, for AMD, Intel and NVIDIA.
* For Intel GPU, use {{pkg|intel-gpu-tools}} and run {{ic|intel_gpu_top}} as root to monitor the GPU activity during video playback for example. The video bar being above 0% indicates GPU video decoder/encoder usage. (If [[Intel graphics#Testing the new experimental Xe driver|new Xe driver]] is in use {{ic|intel_gpu_top}} [https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/issues/174 will throw error], so to check  run {{ic|gputop}}, [https://dri.freedesktop.org/docs/drm/gpu/i915.html#intel-gpu-basics vcs field (Video Command Streamer)] above 0% indicates GPU video decoder/encoder usage.)
* For AMD GPU, use {{Pkg|radeontop}} to monitor GPU activity. Unlike {{pkg|intel-gpu-tools}}, there is currently no way to see decode/encode usage on {{Pkg|radeontop}} [https://github.com/clbr/radeontop/issues/29].
* For any GPU, you can compare CPU usage with a tool like {{Pkg|htop}}. Especially for higher resolution videos (4k+), CPU usage when VA-API is enabled and working should be dramatically lower on laptops and other relatively low-power devices.
}}
```
### Verifying VA-API {#verifying_va_api}

Verify the settings for VA-API by running `{{ic|vainfo}}`{=mediawiki}, which is provided by
`{{Pkg|libva-utils}}`{=mediawiki}:

```{=mediawiki}
{{hc|$ vainfo|<nowiki>
libva info: VA-API version 0.39.4
libva info: va_getDriverName() returns 0
libva info: Trying to open /usr/lib/dri/i965_drv_video.so
libva info: Found init function __vaDriverInit_0_39
libva info: va_openDriver() returns 0
vainfo: VA-API version: 0.39 (libva 1.7.3)
vainfo: Driver version: Intel i965 driver for Intel(R) Skylake - 1.7.3
vainfo: Supported profile and entrypoints
      VAProfileMPEG2Simple            : VAEntrypointVLD
      VAProfileMPEG2Simple            : VAEntrypointEncSlice
      VAProfileMPEG2Main              : VAEntrypointVLD
      VAProfileMPEG2Main              : VAEntrypointEncSlice
      VAProfileH264ConstrainedBaseline: VAEntrypointVLD
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSlice
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSliceLP
      VAProfileH264Main               : VAEntrypointVLD
      VAProfileH264Main               : VAEntrypointEncSlice
      VAProfileH264Main               : VAEntrypointEncSliceLP
      VAProfileH264High               : VAEntrypointVLD
      VAProfileH264High               : VAEntrypointEncSlice
      VAProfileH264High               : VAEntrypointEncSliceLP
      VAProfileH264MultiviewHigh      : VAEntrypointVLD
      VAProfileH264MultiviewHigh      : VAEntrypointEncSlice
      VAProfileH264StereoHigh         : VAEntrypointVLD
      VAProfileH264StereoHigh         : VAEntrypointEncSlice
      VAProfileVC1Simple              : VAEntrypointVLD
      VAProfileVC1Main                : VAEntrypointVLD
      VAProfileVC1Advanced            : VAEntrypointVLD
      VAProfileNone                   : VAEntrypointVideoProc
      VAProfileJPEGBaseline           : VAEntrypointVLD
      VAProfileJPEGBaseline           : VAEntrypointEncPicture
      VAProfileVP8Version0_3          : VAEntrypointVLD
      VAProfileVP8Version0_3          : VAEntrypointEncSlice
      VAProfileHEVCMain               : VAEntrypointVLD
      VAProfileHEVCMain               : VAEntrypointEncSlice
</nowiki>}}
```
```{=mediawiki}
{{ic|VAEntrypointVLD}}
```
means that your card is capable to decode this format, `{{ic|VAEntrypointEncSlice}}`{=mediawiki} means that you can
encode to this format.

In this example the `{{ic|i965}}`{=mediawiki} driver is used, as you can see in this line:

`vainfo: Driver version: Intel `**`i965`**` driver for Intel(R) Skylake - 1.7.3`

If the following error is displayed when running `{{ic|vainfo}}`{=mediawiki}:

`libva info: va_openDriver() returns -1`\
`vaInitialize failed with error code -1 (unknown libva error),exit`

You need to configure the correct driver, see [#Configuring VA-API](#Configuring_VA-API "wikilink").

### Verifying VDPAU {#verifying_vdpau}

Install `{{pkg|vdpauinfo}}`{=mediawiki} to verify if the VDPAU driver is loaded correctly and retrieve a full report of
the configuration:

```{=mediawiki}
{{hc|$ vdpauinfo|<nowiki>
display: :0   screen: 0
API version: 1
Information string: G3DVL VDPAU Driver Shared Library version 1.0

Video surface:

name   width height types
-------------------------------------------
420    16384 16384  NV12 YV12
422    16384 16384  UYVY YUYV
444    16384 16384  Y8U8V8A8 V8U8Y8A8

Decoder capabilities:

name                        level macbs width height
----------------------------------------------------
MPEG1                          --- not supported ---
MPEG2_SIMPLE                    3  9216  2048  1152
MPEG2_MAIN                      3  9216  2048  1152
H264_BASELINE                  41  9216  2048  1152
H264_MAIN                      41  9216  2048  1152
H264_HIGH                      41  9216  2048  1152
VC1_SIMPLE                      1  9216  2048  1152
VC1_MAIN                        2  9216  2048  1152
VC1_ADVANCED                    4  9216  2048  1152
...
</nowiki>}}
```
### Verifying Vulkan Video {#verifying_vulkan_video}

Install `{{pkg|vulkan-tools}}`{=mediawiki} and use *vulkaninfo* to verify if the video processing extensions are
available:

```{=mediawiki}
{{hc|$ vulkaninfo {{!}}
```
grep VK_KHR_video\_\| VK_KHR_video_decode_av1 : extension revision 1 VK_KHR_video_decode_h264 : extension revision 9
VK_KHR_video_decode_h265 : extension revision 8 VK_KHR_video_decode_queue : extension revision 8
VK_KHR_video_encode_h264 : extension revision 14 VK_KHR_video_encode_h265 : extension revision 14
VK_KHR_video_encode_queue : extension revision 12 VK_KHR_video_maintenance1 : extension revision 1 VK_KHR_video_queue :
extension revision 8 }}

## Configuration

Although the video driver should automatically enable hardware video acceleration support for both VA-API and VDPAU, it
may be needed to configure VA-API/VDPAU manually. Only continue to this section if you went through
[#Verification](#Verification "wikilink").

The default driver names, used if there is no other configuration present, are guessed by the system. However, they are
often hacked together and may not work. The guessed value will be printed in the [Xorg](Xorg "wikilink") log file, which
is `{{ic|~/.local/share/xorg/Xorg.0.log}}`{=mediawiki} if rootless, or `{{ic|/var/log/Xorg.0.log}}`{=mediawiki} if Xorg
is running as root. To search the log file for the values of interest:

```{=mediawiki}
{{hc|$ grep -iE 'vdpau {{!}}
```
dri driver\' *xorg_log_file*\| (II) RADEON(0): \[DRI2\] DRI driver: radeonsi (II) RADEON(0): \[DRI2\] VDPAU driver:
radeonsi }}

In this case `{{ic|radeonsi}}`{=mediawiki} is the default for both VA-API and VDPAU.

```{=mediawiki}
{{Note|If you use [[GDM]], run {{ic|1=journalctl -b --grep='vdpau {{!}} dri driver'}}
```
as root instead.}}

This does not represent the *configuration* however. The values above will not change even if you override them.

### Configuring VA-API {#configuring_va_api}

You can override the driver for VA-API by using the `{{ic|LIBVA_DRIVER_NAME}}`{=mediawiki} [environment
variable](environment_variable "wikilink"):

-   [Intel graphics](Intel_graphics "wikilink"):
    -   For `{{Pkg|libva-intel-driver}}`{=mediawiki} use `{{ic|i965}}`{=mediawiki}.
    -   For `{{Pkg|intel-media-driver}}`{=mediawiki} use `{{ic|iHD}}`{=mediawiki}.
-   NVIDIA:
    -   For [Nouveau](Nouveau "wikilink") use `{{ic|nouveau}}`{=mediawiki}.
    -   For [NVIDIA](NVIDIA "wikilink") NVDEC use `{{ic|nvidia}}`{=mediawiki}.
-   AMD:
    -   For [AMDGPU](AMDGPU "wikilink") driver use `{{ic|radeonsi}}`{=mediawiki}.

```{=mediawiki}
{{Note|
* You can find the installed drivers in {{ic|/usr/lib/dri/}}. They are used as {{ic|/usr/lib/dri/'''${LIBVA_DRIVER_NAME}'''_drv_video.so}}.
* Some drivers are installed several times under different names for compatibility reasons. You can see which by running {{ic|sha1sum /usr/lib/dri/* {{!}} sort}}
```
.

-   ```{=mediawiki}
    {{ic|LIBVA_DRIVERS_PATH}}
    ```
    can be used to overrule the VA-API drivers location.

-   Since version 12.0.1 Mesa provides `{{ic|radeonsi}}`{=mediawiki} instead of `{{ic|gallium}}`{=mediawiki}.

}}

### Configuring VDPAU {#configuring_vdpau}

You can override the driver for VDPAU by using the `{{ic|VDPAU_DRIVER}}`{=mediawiki} [environment
variable](environment_variable "wikilink").

The correct driver name depends on your setup:

-   For Intel graphics you [need](#Failed_to_open_VDPAU_backend "wikilink") to set it to `{{ic|va_gl}}`{=mediawiki}.
-   For the open source AMD driver set it to `{{ic|radeonsi}}`{=mediawiki}.
-   For the open source Nouveau driver set it to `{{ic|nouveau}}`{=mediawiki}.
-   For NVIDIA\'s proprietary version set it to `{{ic|nvidia}}`{=mediawiki}.

```{=mediawiki}
{{Note|
* You can find the installed drivers in {{ic|/usr/lib/vdpau/}}. They are used as {{ic|/usr/lib/vdpau/libvdpau_'''${VDPAU_DRIVER}'''.so}}.
* Some drivers are installed several times under different names for compatibility reasons. You can see which by running {{ic|sha1sum /usr/lib/vdpau/*}}.
* For hybrid setups (both NVIDIA and AMD), it may be necessary to set the {{ic|DRI_PRIME}} [[environment variable]]. For more information see [[PRIME]].
}}
```
### Configuring Vulkan Video {#configuring_vulkan_video}

-   [Intel graphics](Intel_graphics "wikilink"): Vulkan Video support in `{{Pkg|vulkan-intel}}`{=mediawiki} can be
    enabled with the `{{ic|1=ANV_DEBUG=video-decode,video-encode}}`{=mediawiki} [environment
    variable](environment_variable "wikilink").
-   [AMD](AMD "wikilink"): Vulkan Video support in `{{Pkg|vulkan-radeon}}`{=mediawiki} is enabled by default for VCN 2,
    3, and 4+ since Mesa 25. To force-enable support on older cards, set the `{{ic|RADV_PERFTEST}}`{=mediawiki}
    [environment variable](environment_variable "wikilink") to `{{ic|video_decode,video_encode}}`{=mediawiki}.

```{=mediawiki}
{{Warning|
Note that some older GPU models do not have Vulkan Video support in [[Mesa]]. Force-enabling Vulkan Video support on such GPUs may result in crashes with some applications (for example, [https://gitlab.archlinux.org/archlinux/packaging/packages/mpv/-/issues/20#note_340586 mpv]).
}}
```
### Configuring applications {#configuring_applications}

Multimedia frameworks:

-   [FFmpeg#Hardware video acceleration](FFmpeg#Hardware_video_acceleration "wikilink")
-   [GStreamer#Hardware video acceleration](GStreamer#Hardware_video_acceleration "wikilink")

Video players:

-   [Kodi#Hardware video acceleration](Kodi#Hardware_video_acceleration "wikilink")
-   [MPlayer#Hardware video acceleration](MPlayer#Hardware_video_acceleration "wikilink")
-   [mpv#Hardware video acceleration](mpv#Hardware_video_acceleration "wikilink")
-   [VLC media player#Hardware video acceleration](VLC_media_player#Hardware_video_acceleration "wikilink")

Web browsers:

-   [Chromium#Hardware video acceleration](Chromium#Hardware_video_acceleration "wikilink")
-   [Firefox#Hardware video acceleration](Firefox#Hardware_video_acceleration "wikilink")
-   [GNOME/Web#Video](GNOME/Web#Video "wikilink")

Multimedia recording/streaming:

-   [Open Broadcaster Software#Hardware video
    acceleration](Open_Broadcaster_Software#Hardware_video_acceleration "wikilink")

## Troubleshooting

### Failed to open VDPAU backend {#failed_to_open_vdpau_backend}

You need to set `{{ic|VDPAU_DRIVER}}`{=mediawiki} variable to point to correct driver. See [#Configuring
VDPAU](#Configuring_VDPAU "wikilink").

### VAAPI init failed {#vaapi_init_failed}

An error along the lines of `{{ic|libva: /usr/lib/dri/i965_drv_video.so init failed}}`{=mediawiki} is encountered. This
can happen because of improper detection of Wayland. One solution is to unset `{{ic|$DISPLAY}}`{=mediawiki} so that mpv,
MPlayer, VLC, etc. do not assume it is X11. Another mpv-specific solution is to add the parameter
`{{ic|1=--gpu-context=wayland}}`{=mediawiki}.

This error can also occur if you installed the wrong VA-API driver for your hardware.

### Video decoding corruption or distortion with AMDGPU driver {#video_decoding_corruption_or_distortion_with_amdgpu_driver}

When experiencing video decoding corruption or distortion with [AMDGPU](AMDGPU "wikilink") driver, set
`{{ic|1=allow_rgb10_configs=false}}`{=mediawiki} as an [environment variable](environment_variable "wikilink").
[3](https://bugs.freedesktop.org/show_bug.cgi?id=106490)

### vainfo fails when using iHD {#vainfo_fails_when_using_ihd}

If you encounter the following error:

```{=mediawiki}
{{hc|$ vainfo|
Trying display: wayland
Trying display: x11
error: can't connect to X server!
Trying display: drm
libva error: dlopen of /usr/lib64/dri/iHD_drv_video.so failed: /usr/lib64/dri/iHD_drv_video.so: undefined symbol: _ZN6GmmLib16GmmClientContext9GmmGetAILEv
vainfo: VA-API version: 1.22 (libva 2.22.0)
vainfo: Driver version: Intel i965 driver for Intel(R) Coffee Lake - 2.4.1
vainfo: Supported profile and entrypoints
[...]
}}
```
Try installing the `{{AUR|intel-media-driver-legacy}}`{=mediawiki} instead of the non-legacy one, which works with
`{{AUR|intel-compute-runtime-legacy}}`{=mediawiki}.
[4](https://aur.archlinux.org/packages/intel-compute-runtime-legacy-bin#comment-1024408)

## Comparison tables {#comparison_tables}

### VA-API drivers {#va_api_drivers}

+----------------------+----------------------+----------------------+----------------------+----------------------+
| Codec                | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      |
|                      | {{pkg|               | {{pkg|               | {{pkg|mesa}}         | {{Pkg|l              |
|                      | libva-intel-driver}} | intel-media-driver}} | ```                  | ibva-nvidia-driver}} |
|                      | ```                  | ```                  | [7                   | ```                  |
|                      | [5](htt              | [6](                 | ](https://www.x.org/ | \                    |
|                      | ps://github.com/01or | https://github.com/i | wiki/RadeonFeature/) | (NVDEC adapter)      |
|                      | g/intel-vaapi-driver | ntel/media-driver/bl | [8](https://nouveau. |                      |
|                      | /blob/master/README) | ob/master/README.md) | freedesktop.org/wiki |                      |
|                      |                      |                      | /VideoAcceleration/) |                      |
+======================+======================+======================+======================+======================+
| Decoding             |                      |                      |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| MPEG-2               | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      | See [#NVIDIA driver  |
|                      | {{G|                 | {{G|B                | {{G|Radeon H         | only](#NVIDIA_dri    |
|                      | GMA 4500 and newer}} | roadwell and newer}} | D 6000 - Radeon RX 6 | ver_only "wikilink") |
|                      | ```                  | ```                  | 000<br>GeForce 8 and |                      |
|                      |                      |                      |  newer<sup>1</sup>}} |                      |
|                      |                      |                      | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| H.263/MPEG-4         | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      |                      |
| Visual^3^            | {{No}}               | {{No}}               | {{G|Radeon HD 600    |                      |
|                      | ```                  | ```                  | 0 - Radeon RX 6000}} |                      |
|                      |                      |                      | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| VC-1                 | ```{=mediawiki}      | rowspan=2            | ```{=mediawiki}      |                      |
|                      | {{G|Sand             | `{{G|Broadwell and   | {{G|Radeon HD 2      |                      |
|                      | y Bridge and newer}} | newer}}`{=mediawiki} | 000 - Radeon RX 6000 |                      |
|                      | ```                  |                      | <br>GeForce 9300 and |                      |
|                      |                      |                      |  newer<sup>1</sup>}} |                      |
|                      |                      |                      | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| H.264/MPEG-4 AVC     | ```{=mediawiki}      | ```{=mediawiki}      |                      |                      |
|                      | {{G|                 | {{G|R                |                      |                      |
|                      | Ironlake and newer}} | adeon HD 2000 and ne |                      |                      |
|                      | ```                  | wer<br>GeForce 8 and |                      |                      |
|                      |                      |  newer<sup>1</sup>}} |                      |                      |
|                      |                      | ```                  |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| H.265/HEVC 8bit      | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      |                      |
|                      | {{G|Cherryview/      | {{G                  | {{G|Radeon           |                      |
|                      | Braswell and newer}} | |Skylake and newer}} |  R9 Fury and newer}} |                      |
|                      | ```                  | ```                  | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| H.265/HEVC 10bit     | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      |                      |
|                      | {{G                  | {{G|Broxton/Apo      | {{G|Ra               |                      |
|                      | |Broxton and newer}} | llo Lake and newer}} | deon 400 and newer}} |                      |
|                      | ```                  | ```                  | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| VP8                  | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      |                      |
|                      | {{G|B                | {{G|B                | {{No}}               |                      |
|                      | roadwell and newer}} | roadwell and newer}} | ```                  |                      |
|                      | ```                  | ```                  |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| VP9 8bit             | ```{=mediawiki}      | ```{=mediawiki}      | rowspan=2            |                      |
|                      | {{G|Broxton and      | {{G|Broxton/Apo      | `{{G|Raven Ridge +   |                      |
|                      |  newer <br> Hybrid:  | llo Lake and newer}} | Radeon RX 5000 and n |                      |
|                      | Haswell refresh to S | ```                  | ewer }}`{=mediawiki} |                      |
|                      | kylake<sup>2</sup>}} |                      |                      |                      |
|                      | ```                  |                      |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| VP9 10bit & 12bit    | ```{=mediawiki}      | ```{=mediawiki}      |                      |                      |
|                      | {{G|K                | {{G|K                |                      |                      |
|                      | aby Lake and newer}} | aby Lake and newer}} |                      |                      |
|                      | ```                  | ```                  |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| AV1 8bit & 10bit     | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      |                      |
|                      | {{No}}               | {{G|Ti               | {{G|Radeon RX 6600   |                      |
|                      | ```                  | ger Lake and newer}} |  and higher/newer }} |                      |
|                      |                      | ```                  | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| Encoding             |                      |                      |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| MPEG-2               | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      | rowspan=8            |
|                      | {{G|Iv               | {{G|Broadwell a      | {{No}}               | `{{                  |
|                      | y Bridge and newer}} | nd newer<br>except B | ```                  | No}}`{=mediawiki}^4^ |
|                      | ```                  | roxton/Apollo Lake}} |                      |                      |
|                      |                      | ```                  |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| H.264/MPEG-4 AVC     | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      |                      |
|                      | {{G|Sand             | {{G|B                | {{G|Radeon           |                      |
|                      | y Bridge and newer}} | roadwell and newer}} |  HD 7000 and newer}} |                      |
|                      | ```                  | ```                  | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| H.265/HEVC 8bit      | ```{=mediawiki}      | ```{=mediawiki}      | ```{=mediawiki}      |                      |
|                      | {{G                  | {{G                  | {{G|Ra               |                      |
|                      | |Skylake and newer}} | |Skylake and newer}} | deon 400 and newer}} |                      |
|                      | ```                  | ```                  | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| H.265/HEVC 10bit     | ```{=mediawiki}      | rowspan=2            | ```{=mediawiki}      |                      |
|                      | {{G|K                | `{{G|Kaby Lake and   | {{G|                 |                      |
|                      | aby Lake and newer}} | newer}}`{=mediawiki} | Raven Ridge + Radeon |                      |
|                      | ```                  |                      |  RX 5000 and newer}} |                      |
|                      |                      |                      | ```                  |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| VP8                  | ```{=mediawiki}      | rowspan=3            |                      |                      |
|                      | {{G|Cherryview/Bras  | `{{No}}`{=mediawiki} |                      |                      |
|                      | well and newer <br>  |                      |                      |                      |
|                      | Hybrid: Haswell to S |                      |                      |                      |
|                      | kylake<sup>2</sup>}} |                      |                      |                      |
|                      | ```                  |                      |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| VP9 8bit             | ```{=mediawiki}      | rowspan=2            |                      |                      |
|                      | {{G|K                | `{{G|Ice Lake and    |                      |                      |
|                      | aby Lake and newer}} | newer}}`{=mediawiki} |                      |                      |
|                      | ```                  |                      |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| VP9 10bit & 12bit    | rowspan=2            |                      |                      |                      |
|                      | `{{No}}`{=mediawiki} |                      |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+
| AV1 8bit & 10bit     | ```{=mediawiki}      | ```{=mediawiki}      |                      |                      |
|                      | {{G|A                | {{G|Radeon RX 790    |                      |                      |
|                      | lchemist and newer}} | 0 and higher/newer}} |                      |                      |
|                      | ```                  | ```                  |                      |                      |
+----------------------+----------------------+----------------------+----------------------+----------------------+

1.  Up until GeForce GTX 750.
2.  Hybrid VP8 encoder and VP9 decoder supported by `{{AUR|intel-hybrid-codec-driver-git}}`{=mediawiki}.
3.  MPEG-4 Part 2 is disabled by default due to VAAPI limitations. Set the [environment
    variable](environment_variable "wikilink") `{{ic|1=VAAPI_MPEG4_ENABLED=true}}`{=mediawiki} to try to use it anyway.
4.  NVIDIA CUDA adapter codec support is in active development and susceptible to change
    [9](https://github.com/elFarto/nvidia-vaapi-driver/issues/116).

### VDPAU drivers {#vdpau_drivers}

+---------------------+-------------+-------------------------+-------------------------+-------------------------+
| Codec               | Color\      | ```{=mediawiki}         | ```{=mediawiki}         | ```{=mediawiki}         |
|                     | depth       | {{pkg|mesa}}            | {{pkg|nvidia-utils}}    | {{pkg|libvdpau-va-gl}}  |
|                     |             | ```                     | ```                     | ```                     |
|                     |             | [10](https://www.x.o    |                         | \                       |
|                     |             | rg/wiki/RadeonFeature/) |                         | (VA-API adapter)        |
|                     |             | [11](https://no         |                         |                         |
|                     |             | uveau.freedesktop.org/w |                         |                         |
|                     |             | iki/VideoAcceleration/) |                         |                         |
+=====================+=============+=========================+=========================+=========================+
| Decoding            |             |                         |                         |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
| MPEG-2              | 8bit        | ```{=mediawiki}         | ```{=mediawiki}         | rowspan=3               |
|                     |             | {{G|Radeon R600 an      | {{                      | `{{No}}`{=mediawiki}    |
|                     |             | d newer <br> GeForce 8  | G|GeForce 8 and newer}} |                         |
|                     |             | and newer<sup>1</sup>}} | ```                     |                         |
|                     |             | ```                     |                         |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
| H.263/MPEG-4 Visual | 8bit        | ```{=mediawiki}         | ```{=mediawiki}         |                         |
|                     |             | {{G|Radeon HD 6000 and  | {{G|                    |                         |
|                     |             | newer <br> GeForce 200  | GeForce 200 and newer}} |                         |
|                     |             | and newer<sup>1</sup>}} | ```                     |                         |
|                     |             | ```                     |                         |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
| VC-1                | 8bit        | ```{=mediawiki}         | ```{=mediawiki}         |                         |
|                     |             | {                       | {{G|GeForce 8           |                         |
|                     |             | {G|Radeon HD 2000 and n | and newer<sup>2</sup>}} |                         |
|                     |             | ewer <br> GeForce 9300  | ```                     |                         |
|                     |             | and newer<sup>1</sup>}} |                         |                         |
|                     |             | ```                     |                         |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
| H.264/MPEG-4 AVC    | 8bit        | ```{=mediawiki}         | ```{=mediawiki}         | See [#VA-API            |
|                     |             | {{G|Radeon HD 2000 an   | {{                      | drivers](#VA-           |
|                     |             | d newer <br> GeForce 8  | G|GeForce 8 and newer}} | API_drivers "wikilink") |
|                     |             | and newer<sup>1</sup>}} | ```                     |                         |
|                     |             | ```                     |                         |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
| H.265/HEVC          | 8bit        | ```{=mediawiki}         | ```{=mediawiki}         | rowspan=6               |
|                     |             | {{G|Rad                 | {{G|GeForce 900         | `{{No}}`{=mediawiki}    |
|                     |             | eon R9 Fury and newer}} | and newer<sup>3</sup>}} |                         |
|                     |             | ```                     | ```                     |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
|                     | 10bit       | ```{=mediawiki}         | ```{=mediawiki}         |                         |
|                     |             | {{G                     | {{No}}                  |                         |
|                     |             | |Radeon 400 and newer}} | ```                     |                         |
|                     |             | ```                     | ^4^                     |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
| VP9                 | 8bit        | rowspan=2               | ```{=mediawiki}         |                         |
|                     |             | `{{G|Raven R            | {{G|GeForce 900         |                         |
|                     |             | idge + Radeon RX 5000 a | and newer<sup>3</sup>}} |                         |
|                     |             | nd newer}}`{=mediawiki} | ```                     |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
|                     | 10bit/12bit | ```{=mediawiki}         |                         |                         |
|                     |             | {{No}}                  |                         |                         |
|                     |             | ```                     |                         |                         |
|                     |             | ^4^                     |                         |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
| AV1                 | 8bit        | rowspan=2               | ```{=mediawiki}         |                         |
|                     |             | `{{G|                   | {{G                     |                         |
|                     |             | Radeon RX 6600 and high | |GeForce 30 and newer}} |                         |
|                     |             | er/newer}}`{=mediawiki} | ```                     |                         |
|                     |             |                         | ^5^                     |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+
|                     | 10bit       | ```{=mediawiki}         |                         |                         |
|                     |             | {{No}}                  |                         |                         |
|                     |             | ```                     |                         |                         |
|                     |             | ^4^                     |                         |                         |
+---------------------+-------------+-------------------------+-------------------------+-------------------------+

1.  Up until GeForce GTX 750.
2.  [Except](Wikipedia:Nvidia_PureVideo "wikilink") GeForce 8800 Ultra, 8800 GTX, 8800 GTS (320/640 MB).
3.  Except GeForce GTX 970 and GTX 980.
4.  NVIDIA implementation is limited to 8bit streams
    [12](https://forums.developer.nvidia.com/t/vdpau-expose-hevc-main10-support-where-available-on-die/43163)
    [13](https://us.download.nvidia.com/XFree86/Linux-x86_64/410.57/README/vdpausupport.html#vdpau-implementation-limits).
5.  Starting with driver version 510.[14](https://www.phoronix.com/scan.php?page=news_item&px=NVIDIA-510-Linux-Beta)

### NVIDIA driver only {#nvidia_driver_only}

+-------------------+-----------------------------------------------------------+
| Codec             | ```{=mediawiki}                                           |
|                   | {{Pkg|nvidia-utils}}                                      |
|                   | ```                                                       |
|                   | [15](https://developer.nvidia.com/nvidia-video-codec-sdk) |
+===================+===========================================================+
| NVDEC             | NVENC                                                     |
+-------------------+-----------------------------------------------------------+
| MPEG-2            | rowspan=3 `{{G|Fermi and newer<sup>1</sup>}}`{=mediawiki} |
+-------------------+-----------------------------------------------------------+
| VC-1              |                                                           |
+-------------------+-----------------------------------------------------------+
| H.264/MPEG-4 AVC  | ```{=mediawiki}                                           |
|                   | {{G|Kepler and newer<sup>2</sup>}}                        |
|                   | ```                                                       |
+-------------------+-----------------------------------------------------------+
| H.265/HEVC 8bit   | rowspan=2 `{{G|Maxwell (GM206) and newer}}`{=mediawiki}   |
+-------------------+-----------------------------------------------------------+
| H.265/HEVC 10bit  | ```{=mediawiki}                                           |
|                   | {{G|Pascal and newer}}                                    |
|                   | ```                                                       |
+-------------------+-----------------------------------------------------------+
| VP8               | ```{=mediawiki}                                           |
|                   | {{G|Maxwell (2nd Gen) and newer}}                         |
|                   | ```                                                       |
+-------------------+-----------------------------------------------------------+
| VP9 8bit          | ```{=mediawiki}                                           |
|                   | {{G|Maxwell (GM206) and newer}}                           |
|                   | ```                                                       |
+-------------------+-----------------------------------------------------------+
| VP9 10bit & 12bit | ```{=mediawiki}                                           |
|                   | {{G|Pascal and newer}}                                    |
|                   | ```                                                       |
+-------------------+-----------------------------------------------------------+
| AV1 8bit & 10bit  | ```{=mediawiki}                                           |
|                   | {{G|Ampere and newer<sup>3</sup>}}                        |
|                   | ```                                                       |
+-------------------+-----------------------------------------------------------+

1.  Except GM108 (not supported)
2.  Except GM108 and GP108 (not supported)
3.  Except A100 (not supported)

### Application support {#application_support}

+-------------------------------+-------------------------------+-------------------------------+-----------------+
| Application                   | Decoding                      |                               |                 |
+===============================+===============================+===============================+=================+
| VA-API                        | VDPAU                         | NVDEC                         | Vulkan          |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [FFmpeg](FFmpeg "wikilink")   | ```{=mediawiki}               | ```{=mediawiki}               | ```{=mediawiki} |
|                               | {{Yes}}                       | {{Yes}}                       | {{Yes}}         |
|                               | ```                           | ```                           | ```             |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [GSt                          | ```{=mediawiki}               | ```{=mediawiki}               | ```{=mediawiki} |
| reamer](GStreamer "wikilink") | {{Yes}}                       | {{No|1=https://gitlab.freede  | {{Yes}}         |
|                               | ```                           | sktop.org/gstreamer/gst-plugi | ```             |
|                               |                               | ns-bad/-/merge_requests/393}} |                 |
|                               |                               | ```                           |                 |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [Kodi](Kodi "wikilink")       | ```{=mediawiki}               | ```{=mediawiki}               | ```{=mediawiki} |
|                               | {{Yes}}                       | {{Yes}}                       | {{No}}          |
|                               | ```                           | ```                           | ```             |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [mpv](mpv "wikilink")         | ```{=mediawiki}               | ```{=mediawiki}               | ```{=mediawiki} |
|                               | {{Yes}}                       | {{Yes}}                       | {{Yes}}         |
|                               | ```                           | ```                           | ```             |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [VLC media                    | ```{=mediawiki}               | ```{=mediawiki}               | ```{=mediawiki} |
| player]                       | {{Yes}}                       | {{Yes}}                       | {{No}}          |
| (VLC_media_player "wikilink") | ```                           | ```                           | ```             |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [MPlayer](MPlayer "wikilink") | ```{=mediawiki}               | ```{=mediawiki}               | ```{=mediawiki} |
|                               | {{No}}                        | {{Yes}}                       | {{No}}          |
|                               | ```                           | ```                           | ```             |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [C                            | ```{=mediawiki}               | ```{=mediawiki}               | ```{=mediawiki} |
| hromium](Chromium "wikilink") | {{Yes}}                       | {{No}}                        | {{No}}          |
|                               | ```                           | ```                           | ```             |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [Firefox](Firefox "wikilink") | ```{=mediawiki}               | ```{=mediawiki}               | ```{=mediawiki} |
|                               | {{Yes}}                       | {{No}}                        | {{No}}          |
|                               | ```                           | ```                           | ```             |
+-------------------------------+-------------------------------+-------------------------------+-----------------+
| [GNO                          | colspan=4                     | ```{=mediawiki}               | ```{=mediawiki} |
| ME/Web](GNOME/Web "wikilink") | `{{C|GStreamer}}`{=mediawiki} | {{C|?}}                       | {{C|?}}         |
|                               |                               | ```                           | ```             |
+-------------------------------+-------------------------------+-------------------------------+-----------------+

[Category:Graphics](Category:Graphics "wikilink") [Category:X server](Category:X_server "wikilink")

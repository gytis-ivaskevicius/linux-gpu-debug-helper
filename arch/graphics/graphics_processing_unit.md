[ja:画像処理装置](ja:画像処理装置 "wikilink") [zh-hans:Graphics processing
unit](zh-hans:Graphics_processing_unit "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|NVIDIA}}`{=mediawiki} `{{Related|AMDGPU}}`{=mediawiki} `{{Related|Intel}}`{=mediawiki}
`{{Related|Wayland}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki} `{{Related|OpenGL}}`{=mediawiki}
`{{Related|Vulkan}}`{=mediawiki} `{{Related|Hardware video acceleration}}`{=mediawiki}
`{{Related|External GPU}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

A [graphics processing unit](Wikipedia:Graphics_processing_unit "wikilink") (GPU) is the hardware in your computer that
generates the video feed that appears on your display. They are present in two device types: [Integrated Graphics
Processors](Wikipedia:Graphics_processing_unit#Integrated_graphics_processing_unit "wikilink") (IGP) and dedicated (or
discrete) graphics, also known as [graphics cards](Wikipedia:Graphics_card "wikilink"). The acronym is often abused to
refer to the graphics card as a whole.

Their ease to perform parallel calculation has given birth to [general-purpose computing on graphics processing
units](general-purpose_computing_on_graphics_processing_units "wikilink") (GPGPU).

## Installation

The Linux kernel includes open-source video drivers and support for hardware accelerated framebuffers. However, userland
support is required for [OpenGL](OpenGL "wikilink"), [Vulkan](Vulkan "wikilink"), 2D acceleration in
[Xorg](Xorg "wikilink") and [hardware video acceleration](hardware_video_acceleration "wikilink").

First, identify the graphics card (the *Subsystem* output shows the specific model):

`$ lspci -vnnd ::03xx`

```{=mediawiki}
{{Tip|{{ic|::03}} here means "[https://admin.pci-ids.ucw.cz/read/PD/03 Display controller] PCI device class", and {{ic|xx}} stands for "any subclass of the class".}}
```
Then, installing its video driver is required. See the tables below for the three major vendors.

For 32-bit software, enable the [multilib](multilib "wikilink") repository and install *lib32-* prefixed userspace
drivers, such as `{{Pkg|lib32-mesa}}`{=mediawiki}, `{{Pkg|lib32-vulkan-radeon}}`{=mediawiki},
`{{Pkg|lib32-nvidia-utils}}`{=mediawiki}, etc.

For X11, other [Device Dependent X (DDX)](https://dri.freedesktop.org/wiki/DDX/) drivers can be found in the
`{{Grp|xorg-drivers}}`{=mediawiki} group or searching for [xf86-video](https://aur.archlinux.org/packages?K=xf86-video).
In most cases, you do not need to install any DDX drivers; see [Xorg#Drivers](Xorg#Drivers "wikilink") for details.

### AMD

AMD supports the open source driver. A proprietary driver was provided before but it is no longer packaged.
[1](https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-UNIFIED-LINUX-25-10-1.html)[2](https://lists.archlinux.org/archives/list/aur-requests@lists.archlinux.org/thread/P5XHCIBVBY7PBPUC7AV3QD4CTROCRYSG/#KPTEHMZ2GPTRMXR37D25HJ4HY2KYPVKJ)

```{=mediawiki}
{{Tip|For a translation of model names (e.g. ''Radeon RX 6600'') to GPU family (e.g. ''RDNA 2''), see [[Wikipedia:List of AMD graphics processing units#Features overview]].}}
```
See [Hardware video acceleration#Comparison tables](Hardware_video_acceleration#Comparison_tables "wikilink") for
details on [VA-API](VA-API "wikilink") support per GPU family.

+------------------+------------------+------------------+------------------+------------------+-----------------+
| Documentation    | GPU family       | DRM driver       | OpenGL           | Vulkan           | VA-API          |
+==================+==================+==================+==================+==================+=================+
| [AMDGPU](AM      | GCN 3 and later  | Included in      | ```{=mediawiki}  | ```{=mediawiki}  | ```{=mediawiki} |
| DGPU "wikilink") | (e.g. RDNA 1-4)  | [Linux](L        | {{Pkg|mesa}}     | {{Pkg            | {{Pkg|mesa}}    |
|                  |                  | inux "wikilink") | ```              | |vulkan-radeon}} | ```             |
|                  |                  |                  |                  | ```              |                 |
+------------------+------------------+------------------+------------------+------------------+-----------------+
| [AMDGPU](AMDGP   | GCN 1&2          |                  |                  | Depends on the   |                 |
| U "wikilink")^1^ |                  |                  |                  | chosen driver    |                 |
| /                |                  |                  |                  |                  |                 |
| [ATI]            |                  |                  |                  |                  |                 |
| (ATI "wikilink") |                  |                  |                  |                  |                 |
+------------------+------------------+------------------+------------------+------------------+-----------------+
| [ATI]            | TeraScale 1-3    |                  |                  | None             |                 |
| (ATI "wikilink") |                  |                  |                  |                  |                 |
+------------------+------------------+------------------+------------------+------------------+-----------------+
|                  | R300 through     |                  |                  |                  | None            |
|                  | R500             |                  |                  |                  |                 |
+------------------+------------------+------------------+------------------+------------------+-----------------+
|                  | R100 & R200      |                  | ```{=mediawiki}  |                  |                 |
|                  |                  |                  | {{               |                  |                 |
|                  |                  |                  | Pkg|mesa-amber}} |                  |                 |
|                  |                  |                  | ```              |                  |                 |
+------------------+------------------+------------------+------------------+------------------+-----------------+
|                  | Rage 4 and older | Not available    |                  |                  |                 |
|                  |                  | [3](htt          |                  |                  |                 |
|                  |                  | ps://www.x.org/w |                  |                  |                 |
|                  |                  | iki/RadeonFeatur |                  |                  |                 |
|                  |                  | e/)[4](https://w |                  |                  |                 |
|                  |                  | ww.phoronix.com/ |                  |                  |                 |
|                  |                  | news/Linux-6.3-D |                  |                  |                 |
|                  |                  | ropping-Old-DRM) |                  |                  |                 |
+------------------+------------------+------------------+------------------+------------------+-----------------+

1.  Enabled by default since `{{Pkg|linux}}`{=mediawiki}≥6.19, can be manually chosen otherwise.

### Intel

Intel provides and supports open source drivers, except for PowerVR-based graphics (GMA 3600 series) which are not
supported.

```{=mediawiki}
{{Tip|Intel's Gen ''N'' hardware does not refer to the generation of the CPU, it refers to the [[Wikipedia:List of Intel graphics processing units|generation of the GPU]], which is different from the generation of the CPU.}}
```
See [Hardware video acceleration#Comparison tables](Hardware_video_acceleration#Comparison_tables "wikilink") for more
details on [VA-API](VA-API "wikilink") support per GPU family, only the packages are listed below.

+------------------+------------------+------------------+------------------+------------------+------------------+
| Documentation    | GPU family       | DRM driver       | OpenGL           | Vulkan           | VA-API           |
+==================+==================+==================+==================+==================+==================+
| [Intel           | Gen 12.1 and     | Included in      | ```{=mediawiki}  | ```{=mediawiki}  | ```{=mediawiki}  |
| grap             | later            | [Linux](L        | {{Pkg|mesa}}     | {{Pk             | {{pkg|inte       |
| hics](Intel_grap |                  | inux "wikilink") | ```              | g|vulkan-intel}} | l-media-driver}} |
| hics "wikilink") |                  |                  |                  | ```              | ```              |
|                  |                  |                  |                  | ^1^              |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  | Gen 8 through 11 |                  |                  |                  | ```{=mediawiki}  |
|                  |                  |                  |                  |                  | {{pkg|inte       |
|                  |                  |                  |                  |                  | l-media-driver}} |
|                  |                  |                  |                  |                  | ```              |
|                  |                  |                  |                  |                  | \                |
|                  |                  |                  |                  |                  | or legacy        |
|                  |                  |                  |                  |                  | `{{pkg|l         |
|                  |                  |                  |                  |                  | ibva-intel-drive |
|                  |                  |                  |                  |                  | r}}`{=mediawiki} |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  | Gen 7 & 7.5      |                  |                  |                  | ```{=mediawiki}  |
|                  |                  |                  |                  |                  | {{pkg|libv       |
|                  |                  |                  |                  |                  | a-intel-driver}} |
|                  |                  |                  |                  |                  | ```              |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  | Gen 5 & 6        |                  |                  | None             |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  | Gen 3 through    |                  |                  |                  | None             |
|                  | 4.5              |                  |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  | Gen 2            |                  | ```{=mediawiki}  |                  |                  |
|                  |                  |                  | {{               |                  |                  |
|                  |                  |                  | Pkg|mesa-amber}} |                  |                  |
|                  |                  |                  | ```              |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  | Gen 1            | Not available    |                  |                  |                  |
|                  |                  | [5](https://w    |                  |                  |                  |
|                  |                  | ww.phoronix.com/ |                  |                  |                  |
|                  |                  | news/Linux-6.3-D |                  |                  |                  |
|                  |                  | ropping-Old-DRM) |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+

1.  Gen 7 and 7.5 have [incomplete
    support](https://gitlab.freedesktop.org/mesa/mesa/-/blob/d067d6e16335c5f2697f14f396c9f62fee649fdc/src/intel/vulkan_hasvk/anv_device.c#L1614),
    Gen 8 is limited to Vulkan 1.3.

### NVIDIA

NVIDIA does not support the fully open driver. They switched to a hybrid approach (with an open DRM driver and closed
userland) in 2022.

```{=mediawiki}
{{Tip|For a translation of model names (e.g. ''RTX 4060'') to GPU family (e.g. ''NV190''), see [https://nouveau.freedesktop.org/CodeNames.html nouveau wiki's code names page].}}
```
See [Hardware video acceleration#NVIDIA](Hardware_video_acceleration#NVIDIA "wikilink") for details on which APIs are
supported, and [Hardware video acceleration#VDPAU drivers](Hardware_video_acceleration#VDPAU_drivers "wikilink") for
details per GPU family.

+------------------+------------------+------------------+------------------+------------------+------------------+
| License          | Documentation    | GPU family       | DRM driver       | OpenGL           | Vulkan           |
+==================+==================+==================+==================+==================+==================+
| Open             | [Nouveau](Nouvea | [Kepler          | Included in      | ```{=mediawiki}  | ```{=mediawiki}  |
|                  | u "wikilink")^1^ | (N               | [Linux](L        | {{Pkg|mesa}}     | {{Pkg|           |
|                  |                  | VE0/GKXXX)](http | inux "wikilink") | ```              | vulkan-nouveau}} |
|                  |                  | s://nouveau.free |                  |                  | ```              |
|                  |                  | desktop.org/Code |                  |                  |                  |
|                  |                  | Names.html#NVE0) |                  |                  |                  |
|                  |                  | and newer        |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  |                  | [Rankine         |                  |                  | None             |
|                  |                  | (NV30)](http     |                  |                  |                  |
|                  |                  | s://nouveau.free |                  |                  |                  |
|                  |                  | desktop.org/Code |                  |                  |                  |
|                  |                  | Names.html#NV30) |                  |                  |                  |
|                  |                  | through [Fermi   |                  |                  |                  |
|                  |                  | (N               |                  |                  |                  |
|                  |                  | VC0/GF1XX)](http |                  |                  |                  |
|                  |                  | s://nouveau.free |                  |                  |                  |
|                  |                  | desktop.org/Code |                  |                  |                  |
|                  |                  | Names.html#NVC0) |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  |                  | [Fahrenheit      |                  | ```{=mediawiki}  |                  |
|                  |                  | (NV04/05)](http  |                  | {{               |                  |
|                  |                  | s://nouveau.free |                  | Pkg|mesa-amber}} |                  |
|                  |                  | desktop.org/Code |                  | ```              |                  |
|                  |                  | Names.html#NV04) |                  |                  |                  |
|                  |                  | through [Kelvin  |                  |                  |                  |
|                  |                  | (NV20)](http     |                  |                  |                  |
|                  |                  | s://nouveau.free |                  |                  |                  |
|                  |                  | desktop.org/Code |                  |                  |                  |
|                  |                  | Names.html#NV20) |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
| Open DRM driver, | [NVIDIA](NVIDI   | [Turing          | ```{=mediawiki}  | ```{=mediawiki}  |                  |
| proprietary      | A "wikilink")^1^ | (NV1             | {{P              | {{Pk             |                  |
| userland         |                  | 60/TUXXX)](https | kg|nvidia-open}} | g|nvidia-utils}} |                  |
|                  |                  | ://nouveau.freed | ```              | ```              |                  |
|                  |                  | esktop.org/CodeN |                  |                  |                  |
|                  |                  | ames.html#NV160) |                  |                  |                  |
|                  |                  | and newer        |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
| Proprietary      |                  | [Maxwell         | ```{=mediawiki}  | ```{=mediawiki}  |                  |
|                  |                  | (NV1             | {{AUR|nvi        | {{AUR|nvid       |                  |
|                  |                  | 10/GMXXX)](https | dia-580xx-dkms}} | ia-580xx-utils}} |                  |
|                  |                  | ://nouveau.freed | ```              | ```              |                  |
|                  |                  | esktop.org/CodeN |                  |                  |                  |
|                  |                  | ames.html#NV110) |                  |                  |                  |
|                  |                  | through\         |                  |                  |                  |
|                  |                  | [Ada Lovelace    |                  |                  |                  |
|                  |                  | (NV1             |                  |                  |                  |
|                  |                  | 90/ADXXX)](https |                  |                  |                  |
|                  |                  | ://nouveau.freed |                  |                  |                  |
|                  |                  | esktop.org/CodeN |                  |                  |                  |
|                  |                  | ames.html#NV190) |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  |                  | [Kepler          | ```{=mediawiki}  | ```{=mediawiki}  |                  |
|                  |                  | (N               | {{AUR|nvi        | {{AUR|nvid       |                  |
|                  |                  | VE0/GKXXX)](http | dia-470xx-dkms}} | ia-470xx-utils}} |                  |
|                  |                  | s://nouveau.free | ```              | ```              |                  |
|                  |                  | desktop.org/Code |                  |                  |                  |
|                  |                  | Names.html#NVE0) |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  |                  | [Fermi           | ```{=mediawiki}  | ```{=mediawiki}  | None             |
|                  |                  | (N               | {{AUR|nvi        | {{AUR|nvid       |                  |
|                  |                  | VC0/GF1XX)](http | dia-390xx-dkms}} | ia-390xx-utils}} |                  |
|                  |                  | s://nouveau.free | ```              | ```              |                  |
|                  |                  | desktop.org/Code |                  |                  |                  |
|                  |                  | Names.html#NVC0) |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  |                  | [Tesla           | ```{=mediawiki}  | ```{=mediawiki}  |                  |
|                  |                  | (NV50/G80        | {{AUR|nvi        | {{AUR|nvid       |                  |
|                  |                  | -90-GT2XX)](http | dia-340xx-dkms}} | ia-340xx-utils}} |                  |
|                  |                  | s://nouveau.free | ```              | ```              |                  |
|                  |                  | desktop.org/Code |                  |                  |                  |
|                  |                  | Names.html#NV50) |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+
|                  |                  | [Curie           | No longer        |                  |                  |
|                  |                  | (NV40/G70)](http | packaged         |                  |                  |
|                  |                  | s://nouveau.free |                  |                  |                  |
|                  |                  | desktop.org/Code |                  |                  |                  |
|                  |                  | Names.html#NV40) |                  |                  |                  |
|                  |                  | and older        |                  |                  |                  |
+------------------+------------------+------------------+------------------+------------------+------------------+

1.  For NVIDIA Optimus enabled laptop which uses an integrated video card combined with a dedicated GPU, see [NVIDIA
    Optimus](NVIDIA_Optimus "wikilink").

## Loading

Most driver kernel modules should load automatically on system boot.

If it does not happen, then:

-   Make sure you do **not** have `{{ic|nomodeset}}`{=mediawiki} or `{{ic|1=vga=}}`{=mediawiki} as a [kernel
    parameter](kernel_parameter "wikilink"), since they require [KMS](KMS "wikilink").
-   Also, check that you have not disabled the driver by using any [kernel module
    blacklisting](Kernel_modules#Blacklisting "wikilink").

## Monitoring

Monitoring your GPU is often used to check the temperature, core and VRAM utilization, and the P-states of your GPU.

#### CLI

-   ```{=mediawiki}
    {{App|amdgpu_top|Tool to display AMDGPU usage|https://github.com/Umio-Yasuno/amdgpu_top|{{Pkg|amdgpu_top}}}}
    ```

-   ```{=mediawiki}
    {{App|nvtop|GPUs process monitoring for AMD, Intel and NVIDIA|https://github.com/Syllo/nvtop|{{Pkg|nvtop}}}}
    ```

-   ```{=mediawiki}
    {{App|radeontop|A GPU utilization viewer, both for the total activity percent and individual blocks. Works with ATI's R600 and newer GPUs as well as cards using the [[AMDGPU]] driver|https://github.com/clbr/radeontop|{{Pkg|radeontop}}}}
    ```

-   ```{=mediawiki}
    {{App|nvidia-smi|CLI monitoring tool for Fermi and newer [[NVIDIA]] GPUs bundled in with NVIDIA's proprietary drivers|https://docs.nvidia.com/deploy/nvidia-smi/index.html|{{pkg|nvidia-utils}}}}
    ```

#### GUI

-   ```{=mediawiki}
    {{App|amdgpu_top|Tool to display AMDGPU usage|https://github.com/Umio-Yasuno/amdgpu_top|{{Pkg|amdgpu_top}}}}
    ```

-   ```{=mediawiki}
    {{App|AmdGuid|A basic fan control GUI fully written in Rust.|https://github.com/Eraden/amdgpud|{{AUR|amdguid-wayland-bin}}, {{AUR|amdguid-glow-bin}}}}
    ```

-   ```{=mediawiki}
    {{App|Radeon Profile|A Qt5 tool to read and change current clocks of AMD Radeon cards.|https://github.com/emerge-e-world/radeon-profile|{{AUR|radeon-profile-git}}}}
    ```

-   ```{=mediawiki}
    {{App|TuxClocker|A Qt5 monitoring and overclocking tool.|https://github.com/Lurkki14/tuxclocker|{{AUR|tuxclocker}}}}
    ```

-   ```{=mediawiki}
    {{App|Plasma System Monitor|An interface for monitoring system sensors, process information and other system resources. Bundled in with [[KDE|KDE Plasma]].|https://apps.kde.org/plasma-systemmonitor/|{{pkg|plasma-systemmonitor}}}}
    ```

-   ```{=mediawiki}
    {{App|LACT|Control your AMD, Nvidia or Intel GPU on a Linux system.|https://github.com/ilya-zlobintsev/LACT|{{pkg|lact}}}}
    ```

[Category:Graphics](Category:Graphics "wikilink")

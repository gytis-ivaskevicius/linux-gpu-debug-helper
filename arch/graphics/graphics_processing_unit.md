`{{Related articles start}}`{=mediawiki} `{{Related|NVIDIA}}`{=mediawiki} `{{Related|AMDGPU}}`{=mediawiki}
`{{Related|Intel}}`{=mediawiki} `{{Related|Wayland}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki}
`{{Related|OpenGL}}`{=mediawiki} `{{Related|Vulkan}}`{=mediawiki} `{{Related|Hardware video acceleration}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

A [graphics processing unit](Wikipedia:Graphics_processing_unit "wikilink") (GPU) is the hardware in your computer that
generates the video feed that appears on your display. They are present in two device types: [Integrated Graphics
Processors](Wikipedia:Graphics_processing_unit#Integrated_graphics_processing_unit "wikilink") (IGP) and dedicated (or
discrete) graphics, also known as [graphics cards](Wikipedia:Graphics_card "wikilink"). The acronym is often abused to
refer to the graphics card as a whole.

Their ease to perform parallel calculation has given birth to [general-purpose computing on graphics processing
units](general-purpose_computing_on_graphics_processing_units "wikilink") (GPGPU).

## Installation

The Linux kernel includes open-source video drivers and support for hardware accelerated framebuffers. However, userland
support is required for [OpenGL](OpenGL "wikilink"), [Vulkan](Vulkan "wikilink") and 2D acceleration in
[Xorg](Xorg "wikilink").

First, identify the graphics card (the *Subsystem* output shows the specific model):

`$ lspci -v -nn -d ::03xx`

```{=mediawiki}
{{Tip|{{ic|::03}} here means "[https://admin.pci-ids.ucw.cz/read/PD/03 Display controller] PCI device class", and {{ic|xx}} stands for "any subclass of the class".}}
```
Then, installing its video driver is required. See the tables below for the three major vendors.

For X11, other [Device Dependent X (DDX)](https://dri.freedesktop.org/wiki/DDX/) drivers can be found in the
`{{Grp|xorg-drivers}}`{=mediawiki} group or searching for [xf86-video](https://aur.archlinux.org/packages?K=xf86-video).
In most cases, you do not need to install any DDX drivers; see [Xorg#Drivers](Xorg#Drivers "wikilink") for details.

### AMD (ex-ATI) {#amd_ex_ati}

AMD supports the open source driver. A proprietary driver was provided before but it is no longer packaged.
[1](https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-UNIFIED-LINUX-25-10-1.html)[2](https://lists.archlinux.org/archives/list/aur-requests@lists.archlinux.org/thread/P5XHCIBVBY7PBPUC7AV3QD4CTROCRYSG/#KPTEHMZ2GPTRMXR37D25HJ4HY2KYPVKJ)

For a translation of model names (e.g. *Radeon RX 6800*) to GPU family (e.g. *RDNA 2*), see [Wikipedia:List of AMD
graphics processing units#Features
overview](Wikipedia:List_of_AMD_graphics_processing_units#Features_overview "wikilink").

+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
| Do          | GPU family  | DRM driver  | OpenGL      | OpenGL      | Vulkan      | Vulkan      | DDX driver  |
| cumentation |             |             |             | ([multilib] |             | ([multilib] |             |
|             |             |             |             | (multilib " |             | (multilib " |             |
|             |             |             |             | wikilink")) |             | wikilink")) |             |
+=============+=============+=============+=============+=============+=============+=============+=============+
| [AMDG       | GCN 3 and   | included in | ```{        | ```{        | ```{        | ```{        | ```{        |
| PU](AMDGPU  | later (e.g. | [Li         | =mediawiki} | =mediawiki} | =mediawiki} | =mediawiki} | =mediawiki} |
| "wikilink") | RDNA 1-4,   | nux](Linux  | {           | {{Pkg|l     | {{Pkg|vulk  | {{Pkg       | {{P         |
|             | CDNA 1-4)   | "wikilink") | {Pkg|mesa}} | ib32-mesa}} | an-radeon}} | |lib32-vulk | kg|xf86-vid |
|             |             |             | ```         | ```         | ```         | an-radeon}} | eo-amdgpu}} |
|             |             |             |             |             |             | ```         | ```         |
|             |             |             |             |             |             |             | ^2^         |
+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
| [AMDGPU]    | GCN 1&2     |             |             |             | Depends on  |             |             |
| (AMDGPU "wi |             |             |             |             | the chosen  |             |             |
| kilink")^1^ |             |             |             |             | driver      |             |             |
| /           |             |             |             |             |             |             |             |
| [ATI](ATI   |             |             |             |             |             |             |             |
| "wikilink") |             |             |             |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
| [ATI](ATI   | R300        |             |             |             | None        |             | ```{        |
| "wikilink") | through     |             |             |             |             |             | =mediawiki} |
|             | TeraScale   |             |             |             |             |             | {{Pkg|xf86- |
|             |             |             |             |             |             |             | video-ati}} |
|             |             |             |             |             |             |             | ```         |
|             |             |             |             |             |             |             | ^2^         |
+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
|             | R100 & R200 |             | ```{        | ```{        |             |             |             |
|             |             |             | =mediawiki} | =mediawiki} |             |             |             |
|             |             |             | {{Pkg|m     | {{          |             |             |             |
|             |             |             | esa-amber}} | Pkg|lib32-m |             |             |             |
|             |             |             | ```         | esa-amber}} |             |             |             |
|             |             |             |             | ```         |             |             |             |
+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
|             | Rage 4 and  | [not        |             |             |             |             |             |
|             | older       | available   |             |             |             |             |             |
|             |             | ](https://w |             |             |             |             |             |
|             |             | ww.x.org/wi |             |             |             |             |             |
|             |             | ki/RadeonFe |             |             |             |             |             |
|             |             | ature/)`<su |             |             |             |             |             |
|             |             | p>`{=html}3 |             |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+

1.  Enabled by default since `{{Pkg|linux}}`{=mediawiki}≥6.19, can be manually chosen otherwise
2.  Using the modesetting driver is reported to work without issues
3.  r128 DRM driver was removed in `{{Pkg|linux}}`{=mediawiki}
    6.3[3](https://www.phoronix.com/news/Linux-6.3-Dropping-Old-DRM)

### Intel

Intel provides and supports open source drivers, except for PowerVR-based graphics (GMA 3600 series) which are not
supported.

Intel\'s Gen*N* hardware does not refer to the generation of the CPU, it refers to the [generation of the
GPU](Wikipedia:List_of_Intel_graphics_processing_units "wikilink"), which is different from the generation of the CPU.

+------------+------------+------------+------------+------------+------------+------------+------------+------------+
| Doc        | GPU family | DRM driver | OpenGL     | OpenGL     | Vulkan     | Vulkan     | DDX driver | VA-API     |
| umentation |            |            |            | ([m        |            | ([m        |            |            |
|            |            |            |            | ultilib](m |            | ultilib](m |            |            |
|            |            |            |            | ultilib "w |            | ultilib "w |            |            |
|            |            |            |            | ikilink")) |            | ikilink")) |            |            |
+============+============+============+============+============+============+============+============+============+
| [Intel     | Gen 12.1   | included   | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      |
| graphi     | and later  | in         | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} |
| cs](Intel_ |            | [Linu      | {{         | {{Pkg|li   | {{Pkg|vulk | {{Pkg|     | {{Pk       | {{pkg|     |
| graphics " |            | x](Linux " | Pkg|mesa}} | b32-mesa}} | an-intel}} | lib32-vulk | g|xf86-vid | intel-medi |
| wikilink") |            | wikilink") | ```        | ```        | ```        | an-intel}} | eo-intel}} | a-driver}} |
|            |            |            |            |            | ^1^        | ```        | ```        | ```        |
|            |            |            |            |            |            | ^1^        | ^2^        |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            | Gen 8      |            |            |            |            |            |            | ```{=      |
|            | through 11 |            |            |            |            |            |            | mediawiki} |
|            |            |            |            |            |            |            |            | {{pkg|     |
|            |            |            |            |            |            |            |            | intel-medi |
|            |            |            |            |            |            |            |            | a-driver}} |
|            |            |            |            |            |            |            |            | ```        |
|            |            |            |            |            |            |            |            | \          |
|            |            |            |            |            |            |            |            | `{{pkg|lib |
|            |            |            |            |            |            |            |            | va-intel-d |
|            |            |            |            |            |            |            |            | river}}`{= |
|            |            |            |            |            |            |            |            | mediawiki} |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            | Gen 7 &    |            |            |            |            |            |            | ```{=      |
|            | 7.5        |            |            |            |            |            |            | mediawiki} |
|            |            |            |            |            |            |            |            | {{pkg|     |
|            |            |            |            |            |            |            |            | libva-inte |
|            |            |            |            |            |            |            |            | l-driver}} |
|            |            |            |            |            |            |            |            | ```        |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            | Gen 5 & 6  |            |            |            | None       |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            | Gen 3      |            |            |            |            |            |            | None       |
|            | through    |            |            |            |            |            |            |            |
|            | 4.5        |            |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            | Gen2       |            | ```{=      | ```{=      |            |            |            |            |
|            |            |            | mediawiki} | mediawiki} |            |            |            |            |
|            |            |            | {{Pkg|me   | {{Pk       |            |            |            |            |
|            |            |            | sa-amber}} | g|lib32-me |            |            |            |            |
|            |            |            | ```        | sa-amber}} |            |            |            |            |
|            |            |            |            | ```        |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+

1.  Gen7 and 7.5 have [incomplete
    support](https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/src/intel/vulkan_hasvk/anv_device.c#L1600), Gen8 is
    limited to Vulkan 1.3.
2.  The *modesetting* DDX driver is recommended for Gen 3 hardware and later. See [Intel
    graphics#Installation](Intel_graphics#Installation "wikilink") for details.

### NVIDIA

+------------+------------+------------+------------+------------+------------+------------+------------+------------+
| License    | Doc        | GPU family | DRM driver | OpenGL     | OpenGL     | Vulkan     | Vulkan     | DDX driver |
|            | umentation |            |            |            | ([m        |            | ([m        |            |
|            |            |            |            |            | ultilib](m |            | ultilib](m |            |
|            |            |            |            |            | ultilib "w |            | ultilib "w |            |
|            |            |            |            |            | ikilink")) |            | ikilink")) |            |
+============+============+============+============+============+============+============+============+============+
| Open       | [N         | [Kepler    | included   | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      |
|            | ouveau](No | (NVE0/     | in         | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} |
|            | uveau "wik | GKXXX)](ht | [Linu      | {{         | {{Pkg|li   | {{         | {{Pkg|li   | {{Pkg|     |
|            | ilink")^1^ | tps://nouv | x](Linux " | Pkg|mesa}} | b32-mesa}} | Pkg|vulkan | b32-vulkan | xf86-video |
|            |            | eau.freede | wikilink") | ```        | ```        | -nouveau}} | -nouveau}} | -nouveau}} |
|            |            | sktop.org/ |            |            |            | ```        | ```        | ```        |
|            |            | CodeNames. |            |            |            |            |            | ^2^        |
|            |            | html#NVE0) |            |            |            |            |            |            |
|            |            | and newer  |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            |            | [          |            |            |            | None       |            |            |
|            |            | Fahrenheit |            |            |            |            |            |            |
|            |            | (NV        |            |            |            |            |            |            |
|            |            | 04/05)](ht |            |            |            |            |            |            |
|            |            | tps://nouv |            |            |            |            |            |            |
|            |            | eau.freede |            |            |            |            |            |            |
|            |            | sktop.org/ |            |            |            |            |            |            |
|            |            | CodeNames. |            |            |            |            |            |            |
|            |            | html#NV04) |            |            |            |            |            |            |
|            |            | through    |            |            |            |            |            |            |
|            |            | [Fermi     |            |            |            |            |            |            |
|            |            | (NVC0/     |            |            |            |            |            |            |
|            |            | GF1XX)](ht |            |            |            |            |            |            |
|            |            | tps://nouv |            |            |            |            |            |            |
|            |            | eau.freede |            |            |            |            |            |            |
|            |            | sktop.org/ |            |            |            |            |            |            |
|            |            | CodeNames. |            |            |            |            |            |            |
|            |            | html#NVC0) |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
| Open DRM   | [NVIDIA](N | [Turing    | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      |
| driver,    | VIDIA "wik | (NV160/T   | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} |
| p          | ilink")^1^ | UXXX)](htt | {{Pkg|nvi  | {{Pkg|nvid | {{Pkg|     | {{Pkg|nvid | {{Pkg|     | {{Pkg|nvid |
| roprietary |            | ps://nouve | dia-open}} | ia-utils}} | lib32-nvid | ia-utils}} | lib32-nvid | ia-utils}} |
| userland   |            | au.freedes | ```        | ```        | ia-utils}} | ```        | ia-utils}} | ```        |
|            |            | ktop.org/C |            |            | ```        |            | ```        |            |
|            |            | odeNames.h |            |            |            |            |            |            |
|            |            | tml#NV160) |            |            |            |            |            |            |
|            |            | and newer  |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
| P          |            | [Maxwell   | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      |
| roprietary |            | (NV110/G   | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} |
|            |            | MXXX)](htt | {{AUR      | {{AUR|     | {{         | {{AUR|     | {{         | {{AUR|     |
|            |            | ps://nouve | |nvidia-58 | nvidia-580 | AUR|lib32- | nvidia-580 | AUR|lib32- | nvidia-580 |
|            |            | au.freedes | 0xx-dkms}} | xx-utils}} | nvidia-580 | xx-utils}} | nvidia-580 | xx-utils}} |
|            |            | ktop.org/C | ```        | ```        | xx-utils}} | ```        | xx-utils}} | ```        |
|            |            | odeNames.h |            |            | ```        |            | ```        |            |
|            |            | tml#NV110) |            |            |            |            |            |            |
|            |            | through\   |            |            |            |            |            |            |
|            |            | [Volta     |            |            |            |            |            |            |
|            |            | (NV140/G   |            |            |            |            |            |            |
|            |            | VXXX)](htt |            |            |            |            |            |            |
|            |            | ps://nouve |            |            |            |            |            |            |
|            |            | au.freedes |            |            |            |            |            |            |
|            |            | ktop.org/C |            |            |            |            |            |            |
|            |            | odeNames.h |            |            |            |            |            |            |
|            |            | tml#NV140) |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            |            | [Kepler    | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      | ```{=      |
|            |            | (NVE0/     | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} | mediawiki} |
|            |            | GKXXX)](ht | {{AUR      | {{AUR|     | {{         | {{AUR|     | {{         | {{AUR|     |
|            |            | tps://nouv | |nvidia-47 | nvidia-470 | AUR|lib32- | nvidia-470 | AUR|lib32- | nvidia-470 |
|            |            | eau.freede | 0xx-dkms}} | xx-utils}} | nvidia-470 | xx-utils}} | nvidia-470 | xx-utils}} |
|            |            | sktop.org/ | ```        | ```        | xx-utils}} | ```        | xx-utils}} | ```        |
|            |            | CodeNames. |            |            | ```        |            | ```        |            |
|            |            | html#NVE0) |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            |            | [Fermi     | ```{=      | ```{=      | ```{=      | None       |            | ```{=      |
|            |            | (NVC0/     | mediawiki} | mediawiki} | mediawiki} |            |            | mediawiki} |
|            |            | GF1XX)](ht | {{AUR      | {{AUR|     | {{         |            |            | {{AUR|     |
|            |            | tps://nouv | |nvidia-39 | nvidia-390 | AUR|lib32- |            |            | nvidia-390 |
|            |            | eau.freede | 0xx-dkms}} | xx-utils}} | nvidia-390 |            |            | xx-utils}} |
|            |            | sktop.org/ | ```        | ```        | xx-utils}} |            |            | ```        |
|            |            | CodeNames. |            |            | ```        |            |            |            |
|            |            | html#NVC0) |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            |            | [Tesla     | ```{=      | ```{=      | ```{=      |            |            | ```{=      |
|            |            | (NV        | mediawiki} | mediawiki} | mediawiki} |            |            | mediawiki} |
|            |            | 50/G80-90- | {{AUR      | {{AUR|     | {{         |            |            | {{AUR|     |
|            |            | GT2XX)](ht | |nvidia-34 | nvidia-340 | AUR|lib32- |            |            | nvidia-340 |
|            |            | tps://nouv | 0xx-dkms}} | xx-utils}} | nvidia-340 |            |            | xx-utils}} |
|            |            | eau.freede | ```        | ```        | xx-utils}} |            |            | ```        |
|            |            | sktop.org/ |            |            | ```        |            |            |            |
|            |            | CodeNames. |            |            |            |            |            |            |
|            |            | html#NV50) |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+
|            |            | [Curie     | No longer  |            |            |            |            |            |
|            |            | (NV4       | packaged   |            |            |            |            |            |
|            |            | 0/G70)](ht |            |            |            |            |            |            |
|            |            | tps://nouv |            |            |            |            |            |            |
|            |            | eau.freede |            |            |            |            |            |            |
|            |            | sktop.org/ |            |            |            |            |            |            |
|            |            | CodeNames. |            |            |            |            |            |            |
|            |            | html#NV40) |            |            |            |            |            |            |
|            |            | and older  |            |            |            |            |            |            |
+------------+------------+------------+------------+------------+------------+------------+------------+------------+

1.  For NVIDIA Optimus enabled laptop which uses an integrated video card combined with a dedicated GPU, see [NVIDIA
    Optimus](NVIDIA_Optimus "wikilink").
2.  The *modesetting* DDX driver is recommended for for [NV50
    (G80)](https://nouveau.freedesktop.org/CodeNames.html#NV50) and later. See
    [Nouveau#Installation](Nouveau#Installation "wikilink") for details.

## Loading

Most driver kernel modules should load fine automatically on system boot.

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

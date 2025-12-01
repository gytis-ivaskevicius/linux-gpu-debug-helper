[ja:AMDGPU PRO](ja:AMDGPU_PRO "wikilink") [ru:AMDGPU PRO](ru:AMDGPU_PRO "wikilink") [zh-hans:AMDGPU
PRO](zh-hans:AMDGPU_PRO "wikilink") `{{Related articles start}}`{=mediawiki} `{{Related|AMDGPU}}`{=mediawiki}
`{{Related|Vulkan}}`{=mediawiki} `{{Related|General-purpose computing on graphics processing units}}`{=mediawiki}
`{{Related|DaVinci Resolve}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}
`{{Archive|AMD has stopped releasing their proprietary components. See [https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-UNIFIED-LINUX-25-10-1.html announcement]. [https://aur.archlinux.org/pkgbase/amdgpu-pro-installer amdgpu-pro-installer] is going to be deleted from AUR.}}`{=mediawiki}

This page describes close source drivers for AMD GPUs.

```{=mediawiki}
{{Tip|Most users do not need these proprietary drivers.}}
```
## Purpose of proprietary components {#purpose_of_proprietary_components}

AMD releases their open source drivers via standard distribution channels. And they also periodically do releases of
their *Radeon Software for Linux* suite, which includes both open and proprietary components. Open source components are
not needed from there, and proprietary components are repacked from the latest Ubuntu LTS version. They are published in
AUR in the [amdgpu-pro-installer](https://aur.archlinux.org/pkgbase/amdgpu-pro-installer) package base.

[Comment](https://www.phoronix.com/forums/forum/phoronix/latest-phoronix-articles/1316628-radeon-software-for-linux-22-10-driver-being-prepared-for-release?p=1316713#post1316713)
by John Bridgman from AMD explaining why they still package close source drivers:

:   These days our packaged drivers are mostly intended for:
    -   customers using slower moving enterprise/LTS distros which do not automatically pick up the latest graphics
        drivers - we offer them both open source and proprietary/workstation options
    -   customers using workstation apps who need the extra performance/certification from a workstation-oriented driver
        (although Marek has done a lot of great work over the last year to improve Mesa performance on workstation apps)
    -   The third target audience is customers looking for ready-to-go OpenCL, either for use with the packaged
        open/closed drivers or with the upstream-based stack in a recent distro.

There are several proprietary components: OpenGL, OpenCL, Vulkan and AMF. Sometimes you may want to use these components
due to specific features that open source components may lack.

AMDGPU PRO OpenGL is a proprietary, binary userland driver, which works on top of the open-source amdgpu kernel driver.
From [Radeon Software 18.50 vs Mesa 19 benchmarks](https://www.phoronix.com/vr.php?view=27266) article: When it comes to
OpenGL games, the RadeonSI Gallium3D driver simply dominates the proprietary AMD OpenGL driver. Users of graphic cards
other than Radeon Pro are [advised to use the amdgpu graphics
stack](https://www.amd.com/en/support/kb/release-notes/amdgpu-installation). Mostly used because of lacking
compatibility layers that some software relies on. See gentoo wiki linked below.

AMDGPU PRO Vulkan - required dependency for AMF.

AMDGPU PRO OpenCL - used because Mesa OpenCL is not fully complete. Proprietary component only for Polaris GPUs. The
onward GPUs use the open ROCm OpenCL.

AMDGPU AMF - used for GPU encoding/decoding.

## Installation

For proprietary OpenGL implementation, use the
[amdgpu-pro-installer](https://aur.archlinux.org/pkgbase/amdgpu-pro-installer) package base. It contains all the
following packages:

-   ```{=mediawiki}
    {{AUR|amdgpu-pro-oglp}}
    ```
    : For proprietary OpenGL implementation

-   ```{=mediawiki}
    {{AUR|lib32-amdgpu-pro-oglp}}
    ```
    : For proprietary OpenGL implementation 32 bit applications support

-   ```{=mediawiki}
    {{AUR|vulkan-amdgpu-pro}}
    ```
    : For proprietary Vulkan implementation

-   ```{=mediawiki}
    {{AUR|lib32-vulkan-amdgpu-pro}}
    ```
    : For proprietary Vulkan implementation 32 bit applications support

-   ```{=mediawiki}
    {{AUR|amf-amdgpu-pro}}
    ```
    : For Advanced Media Framework implementation

```{=mediawiki}
{{Note|OGLP is not a performance optimization of OpenGL, it is an all-new GL driver codebase written from scratch, based on the PAL architecture. in version > 22.20.5 it replaces the libgl.}}
```
For available OpenCL implementations see [General-purpose computing on graphics processing units#OpenCL on AMD/ATI
GPU](General-purpose_computing_on_graphics_processing_units#OpenCL_on_AMD/ATI_GPU "wikilink").

## Usage

### Using proprietary OpenGL {#using_proprietary_opengl}

Launch your application with *progl*, for example:

`$ progl glmark2`

#### How to ensure you are using AMDGPU-PRO driver {#how_to_ensure_you_are_using_amdgpu_pro_driver}

Run the following command:

`$ glxinfo | grep "OpenGL vendor string" | cut -f2 -d":" | xargs`

If it returns `{{ic|AMD}}`{=mediawiki}, then you are running open source driver. If it returns
`{{ic|Advanced Micro Devices, Inc.}}`{=mediawiki} or `{{ic|ATI Technologies Inc.}}`{=mediawiki}, then you are running
proprietary driver.

Alternatively, run [glmark2](Benchmarking#glmark2 "wikilink"). When using open driver, in OpenGL Information you will
see:

`   GL_VENDOR:     AMD`\
`   GL_RENDERER:   Radeon RX 580 Series (POLARIS10, DRM 3.40.0, 5.10.7-arch1-1, LLVM 11.0.1)`\
`   GL_VERSION:    4.6 (Compatibility Profile) Mesa 20.3.3`

But when using closed driver, you will see:

`   GL_VENDOR:     ATI Technologies Inc.`\
`   GL_RENDERER:   Radeon RX 580 Series`\
`   GL_VERSION:    4.6.14756 Compatibility Profile Context`

### Using proprietary Vulkan {#using_proprietary_vulkan}

[AMD Vulkan Prefixes](https://gitlab.com/AndrewShark/amd-vulkan-prefixes) is a script for switching between different
Vulkan implementations. [Install](Install "wikilink") `{{AUR|amd-vulkan-prefixes}}`{=mediawiki} and prepend your
application with the prefix you want. The executables provided are `{{ic|vk_radv}}`{=mediawiki} and
`{{ic|vk_pro}}`{=mediawiki}. For example, to use the proprietary Vulkan implementation:

`$ vk_pro vkmark`

### Using Advanced Multimedia Framework {#using_advanced_multimedia_framework}

See [FFmpeg#AMD AMF](FFmpeg#AMD_AMF "wikilink").

## Troubleshooting

### Intel + AMD hybrid graphics {#intel_amd_hybrid_graphics}

For users of a hybrid setup with both an Intel GPU and an AMD GPU, usage of the proprietary AMDGPU Pro Workstation
Driver might not work as expected due to different MESA implementations.

The symptom is the following: when you boot your machine, you get a black screen, but with your mouse cursor is moving
normally.

Unfortunately, [Reverse PRIME](PRIME#Reverse_PRIME "wikilink") is not a solution. See the [developer
response](https://gitlab.freedesktop.org/drm/amd/-/issues/985#note_359417).

### Uninstalling packages {#uninstalling_packages}

If you are in trouble, for example, you cannot login to your system due to black screen, you can revert all back by
uninstalling all packages related to AMDGPU PRO.

Switch a [virtual console](virtual_console "wikilink") (with e.g. `{{ic|Ctrl+Alt+F2}}`{=mediawiki}), login and run:

`# pacman -R $(pacman -Qg Radeon_Software_for_Linux | cut -f2 -d" ")`

then reboot.

### Southern Islands (SI) or Sea Islands (CIK) GPUs {#southern_islands_si_or_sea_islands_cik_gpus}

If using Southern Islands (SI) or Sea Islands (CIK) GPU, when running `{{ic|clinfo}}`{=mediawiki}, you get:

`amdgpu_device_initialize: DRM version is 2.50.0 but this driver is only compatible with 3.x.x.`

then ensure you are using the `{{ic|amdgpu}}`{=mediawiki} driver, but not `{{ic|radeon}}`{=mediawiki}.

Check which driver is currently in use:

```{=mediawiki}
{{hc|$ lspci -k|
03:00.0 Display controller: Advanced Micro Devices, Inc. [AMD/ATI] Opal XT [Radeon R7 M265/M365X/M465]
        Subsystem: Acer Incorporated [ALI] Aspire V5 Radeon R7 M265
        '''Kernel driver in use: radeon'''
        Kernel modules: radeon, amdgpu
}}
```
See [AMDGPU#Enable Southern Islands (SI) and Sea Islands (CIK)
support](AMDGPU#Enable_Southern_Islands_(SI)_and_Sea_Islands_(CIK)_support "wikilink") for more information.

### Firmware and AMD drivers {#firmware_and_amd_drivers}

AMD drivers and firmware (especially recent firmware) can get out of sync and create issues or not work at all. You can
search in the [journal](journal "wikilink") for `{{ic|VCN}}`{=mediawiki}:

`system VCN FW Encode interface version=1.9, expected version=1.8`

[Downgrading](Downgrading "wikilink") the firmware seems to fix the problem.

```{=mediawiki}
{{Tip|As of 2024-01-29 {{AUR|linux-firmware-git}} version 20240126.8fa621d2-1 works with 23.40 (6.0.1) driver.}}
```
## See also {#see_also}

-   [Gentoo:AMDGPU-PRO](Gentoo:AMDGPU-PRO "wikilink")

[Category:Graphics](Category:Graphics "wikilink") [Category:X server](Category:X_server "wikilink")

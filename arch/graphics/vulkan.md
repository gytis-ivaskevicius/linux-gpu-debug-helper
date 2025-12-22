[es:Vulkan](es:Vulkan "wikilink") [hu:Vulkan](hu:Vulkan "wikilink") [ja:Vulkan](ja:Vulkan "wikilink")
[pt:Vulkan](pt:Vulkan "wikilink") [ru:Vulkan](ru:Vulkan "wikilink") [zh-hans:Vulkan](zh-hans:Vulkan "wikilink") From
[Wikipedia](Wikipedia:Vulkan_(API) "wikilink"):

:   Vulkan is a low-overhead, cross-platform 3D graphics and compute API. First released in 2016, it is a successor to
    [OpenGL](OpenGL "wikilink").

Learn more on [Vulkan\'s website](https://www.vulkan.org/learn).

## Installation

```{=mediawiki}
{{Note|1=
On hybrid graphics ([[NVIDIA Optimus]]/AMD Dynamic Switchable Graphics):

* Vulkan is not currently officially supported by [[Bumblebee]] [https://github.com/Bumblebee-Project/Bumblebee/issues/769] but does work with {{Pkg|primus_vk}}.
* The Radeon Vulkan driver now supports [[PRIME]] [https://www.phoronix.com/scan.php?page=news_item&px=RADV-PRIME-Lands].
}}
```
To run a Vulkan application, you will need to [install](install "wikilink") the `{{Pkg|vulkan-icd-loader}}`{=mediawiki}
package (and `{{Pkg|lib32-vulkan-icd-loader}}`{=mediawiki} from the [multilib](multilib "wikilink") repository if you
also want to run 32-bit applications), as well as Vulkan drivers for your graphics card(s). There are several packages
[providing](PKGBUILD#provides "wikilink") a *vulkan-driver* and *lib32-vulkan-driver*:

-   [AMD](AMD "wikilink"): `{{Pkg|vulkan-radeon}}`{=mediawiki} (or `{{Pkg|lib32-vulkan-radeon}}`{=mediawiki})
-   [Intel](Intel "wikilink"): `{{Pkg|vulkan-intel}}`{=mediawiki} (or `{{Pkg|lib32-vulkan-intel}}`{=mediawiki})
-   [NVIDIA](NVIDIA "wikilink"): there are two implementations:
    -   ```{=mediawiki}
        {{Pkg|nvidia-utils}}
        ```
        (or `{{Pkg|lib32-nvidia-utils}}`{=mediawiki}) - NVIDIA proprietary

    -   ```{=mediawiki}
        {{Pkg|vulkan-nouveau}}
        ```
        (or `{{Pkg|lib32-vulkan-nouveau}}`{=mediawiki}) - NVK (part of Mesa project)
        `{{Note|Enabling NVK also requires additional system configuration, see [[Nouveau#Using the Mesa NVK Vulkan Driver]] for details.}}`{=mediawiki}

The following are software rasterizers, so that you can use it on devices that do not provide Vulkan support.

-   **Lavapipe**: `{{Pkg|vulkan-swrast}}`{=mediawiki} (or `{{Pkg|lib32-vulkan-swrast}}`{=mediawiki})
-   **SwiftShader**: `{{AUR|swiftshader-git}}`{=mediawiki}

For Vulkan application development, [install](install "wikilink") `{{Pkg|vulkan-headers}}`{=mediawiki}, and optionally
`{{Pkg|vulkan-validation-layers}}`{=mediawiki}, `{{AUR|vulkan-man-pages}}`{=mediawiki} and
`{{Pkg|vulkan-tools}}`{=mediawiki} (you can find the vulkaninfo, and vkcube tools in there).

## Verification

To see which Vulkan implementations are currently installed on your system, use the following command:

`$ ls /usr/share/vulkan/icd.d/`

To ensure that Vulkan is working with your hardware, [install](install "wikilink") `{{Pkg|vulkan-tools}}`{=mediawiki}
and use the `{{ic|vulkaninfo}}`{=mediawiki} command to pull up relevant information about your system. If you get info
about your graphics card, you will know that Vulkan is working.

`$ vulkaninfo`

## Switching

### Switching between devices {#switching_between_devices}

On systems with multiple GPUs you may need to force the usage of a specific GPU.
`{{Pkg|vulkan-mesa-implicit-layers}}`{=mediawiki} is required for this to work. By setting
`{{ic|MESA_VK_DEVICE_SELECT}}`{=mediawiki} to `{{ic|''vendorID:deviceID''}}`{=mediawiki}, you can choose the desired
GPU.

To list the candidates, use:

`$ MESA_VK_DEVICE_SELECT=list vulkaninfo`

Appending an `{{ic|!}}`{=mediawiki} at the end of the specified value enforces this behavior. See [Vulkan mesa device
select layer environment
variables](https://docs.mesa3d.org/envvars.html#vulkan-mesa-device-select-layer-environment-variables) for more
information.

## Software rendering {#software_rendering}

You can install the software Vulkan rasterizer known as lavapipe, for example to debug hardware issues:
`{{Pkg|vulkan-swrast}}`{=mediawiki} (or `{{Pkg|lib32-vulkan-swrast}}`{=mediawiki} for the 32-bit version).

The following example shows running *vulkaninfo* with the required environment variables to force a full software
rendering for Vulkan and [OpenGL](OpenGL#Mesa "wikilink") (with `{{ic|1=__GLX_VENDOR_LIBRARY_NAME=mesa}}`{=mediawiki}
ensuring the command also works for [PRIME](PRIME "wikilink") users):

`$ LIBGL_ALWAYS_SOFTWARE=1 __GLX_VENDOR_LIBRARY_NAME=mesa VK_DRIVER_FILES=/usr/share/vulkan/icd.d/lvp_icd.i686.json:/usr/share/vulkan/icd.d/lvp_icd.x86_64.json vulkaninfo`

## Vulkan hardware database {#vulkan_hardware_database}

The [Vulkan Hardware Database](https://vulkan.gpuinfo.org/) provides user reported GPU/driver combinations. Supplying
own information is possible by using `{{AUR|vulkan-caps-viewer-wayland}}`{=mediawiki} or
`{{AUR|vulkan-caps-viewer-x11}}`{=mediawiki}.

## Troubleshooting

### NVIDIA - vulkan is not working and can not initialize {#nvidia___vulkan_is_not_working_and_can_not_initialize}

#### Environment variables {#environment_variables}

Invalid or contradictory [environment variable](environment_variable "wikilink") values might cause Vulkan to fail, and
inappropriate values can result in the use of a different GPU than intended on machines with multiple GPUs. Properly
setting the variables can also help [keep a secondary GPU powered down when it is not
needed](https://bbs.archlinux.org/viewtopic.php?pid=2152232#p2152232).

#### GPU switching {#gpu_switching}

If your machine has multiple GPUs and Vulkan cannot see or use one of them, make sure it is not currently disabled by
the BIOS/UEFI or in the kernel. See [NVIDIA Optimus](NVIDIA_Optimus "wikilink") for an overview of the different methods
of switching between GPUs.

```{=mediawiki}
{{Expansion|Is there a simpler way to check this information without installing an AUR package?}}
```
Example command to check the current status with `{{aur|optimus-manager-git}}`{=mediawiki}:

```{=mediawiki}
{{hc|$ optimus-manager --status|
Optimus Manager (Client) version 1.4

Current GPU mode : nvidia
GPU mode requested for next login : no change
GPU at startup : integrated
Temporary config path: no
}}
```
#### GSP firmware {#gsp_firmware}

See [NVIDIA/Troubleshooting#GSP firmware](NVIDIA/Troubleshooting#GSP_firmware "wikilink").

### No device for the display GPU found. Are the intel-mesa drivers installed? {#no_device_for_the_display_gpu_found._are_the_intel_mesa_drivers_installed}

Try to list both the intel_icd and primus_vk_wrapper configurations in VK_DRIVER_FILES

`export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json:/usr/share/vulkan/icd.d/nv_vulkan_wrapper.json`

### AMDGPU - ERROR_INITIALIZATION_FAILED after vulkaninfo {#amdgpu___error_initialization_failed_after_vulkaninfo}

If after running `{{ic|vulkaninfo}}`{=mediawiki} on AMD card from GCN1 or GCN2 family you got error message like:

```{=mediawiki}
{{bc|ERROR at /build/vulkan-tools/src/Vulkan-Tools-1.2.135/vulkaninfo/vulkaninfo.h:240:vkEnumerateInstanceExtensionProperties failed with ERROR_INITIALIZATION_FAILED}}
```
Then check if you have correctly enable support for this models of graphics cards ([AMDGPU#Enable Southern Islands (SI)
and Sea Islands (CIK) support](AMDGPU#Enable_Southern_Islands_(SI)_and_Sea_Islands_(CIK)_support "wikilink")).

One of possibility to check if gpu drivers are correctly loaded is `{{ic|lspci -k}}`{=mediawiki}, after running this
command check kernel driver of your gpu. It should be `{{ic|amdgpu}}`{=mediawiki}.

```{=mediawiki}
{{hc|$ lspci -k|
...
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Curacao PRO [Radeon R7 370 / R9 270/370 OEM]
    Subsystem: Gigabyte Technology Co., Ltd Device 226c
    Kernel driver in use: amdgpu
    Kernel modules: radeon, amdgpu
...
}}
```
Some forum threads about this problem: [1](https://bbs.archlinux.org/viewtopic.php?id=254015)
[2](https://bbs.archlinux.org/viewtopic.php?id=253843)

### AMDGPU - Vulkan applications launch slowly {#amdgpu___vulkan_applications_launch_slowly}

If you install `{{Pkg|cuda}}`{=mediawiki}, you might find Vulkan applications, for example, Chromium, launch slowly.
It\'s because `{{Pkg|nvidia-utils}}`{=mediawiki} provides an Vulkan driver and Vulkan would try nvidia drivers before
radeon drivers. To solve it, set the [environment variable](environment_variable "wikilink")
`{{ic|VK_DRIVER_FILES}}`{=mediawiki} to
`{{ic|/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json}}`{=mediawiki}.

[Category:Graphics](Category:Graphics "wikilink") [Category:Development](Category:Development "wikilink")

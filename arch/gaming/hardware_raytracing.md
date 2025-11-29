[fr:Hardware raytracing](fr:Hardware_raytracing "wikilink") [pl:Hardware raytracing](pl:Hardware_raytracing "wikilink")
[ja:ハードウェア レイトレーシング](ja:ハードウェア_レイトレーシング "wikilink")
`{{Expansion|This article needs feedback from users with compatible Intel & AMD hardware to expand its scope and accuracy}}`{=mediawiki}

This page will serve as a guide to the current state of Hardware raytracing support on Linux as well as provide
information on how to set everything up.

In all cases it is assumed you will be running the game through Proton, VKD3D is required, DXVK will not work.

```{=mediawiki}
{{Note|Using raytracing requires that you set some [[environment variables]], these can be set [[Environment variables#Globally|globally]] or [[Environment variables#Per user|per user]].}}
```
## AMD

AMD RDNA2 GPUs offer hardware raytracing support through onboard compute units, current performance is mixed. Since mesa
23, raytracing is enabled on a per game basis, and from [mesa](mesa "wikilink") 23.2 raytracing will be enabled by
default for all applications.

-   **GPU** - AMD RDNA2 series or newer
-   **Driver** - `{{Pkg|mesa}}`{=mediawiki} 23 or newer, `{{Pkg|vulkan-radeon}}`{=mediawiki}

### Usage

For mesa versions below 23.2, use the following [environment variables](environment_variables "wikilink"):

`RADV_PERFTEST='rt'`

## Intel

Intel ARC GPUs offer hardware raytracing support through onboard TSUs, current performance is mixed.

-   **GPU** - Intel ARC GD/2 series or newer
-   **Driver** - `{{Pkg|mesa}}`{=mediawiki} 22.3 or newer, `{{Pkg|vulkan-intel}}`{=mediawiki}
-   **Kernel** - `{{Pkg|linux-firmware-intel}}`{=mediawiki} (firmware is needed for [GuC
    support](Intel_graphics#Enable_GuC_/_HuC_firmware_loading "wikilink"))

### Usage {#usage_1}

Use the following [environment variables](environment_variables "wikilink"):

`VKD3D_CONFIG=dxr11,dxr`

## NVIDIA

NVIDIA\'s raytracing implementation for Linux is pretty much on par with Windows, that is to say, with supported
hardware and the correct drivers RTX works well on Linux.

-   **GPU** - Any card with the RTX moniker (RTX 2060+, RTX 3050+, RTX 4050+)
-   **Driver** - `{{Pkg|nvidia}}`{=mediawiki} 510.60.02 or newer with `{{Pkg|nvidia-utils}}`{=mediawiki} and
    `{{Pkg|nvidia-settings}}`{=mediawiki} (with their lib32 variants)

### Usage {#usage_2}

Some outdated guides still recommend setting the following [environment variables](environment_variables "wikilink")
manually:

`VKD3D_CONFIG=dxr11,dxr`\
`PROTON_ENABLE_NVAPI=1`\
`PROTON_ENABLE_NGX_UPDATER=1`

Starting with Proton 8/9 and vkd3d-proton ≥ 2.11, these flags are no longer required: everything is now enabled by
default.

To use ray tracing or DLSS in compatible games:

-   Use a recent Proton version (8.x, 9.x, or Proton Experimental).
-   Ensure your system has an RTX 20/30/40 series GPU with appropriate NVIDIA drivers (≥ 510.60.02).
-   No additional environment variables are necessary.

```{=mediawiki}
{{Note|This configuration will enable support for both Deep Learning Super Sampling and RTX.}}
```
## Testing

[Install](Install "wikilink") the package `{{aur|raytracinginvulkan-git}}`{=mediawiki} then from a terminal run:

`$ cd /opt/raytracinginvulkan/bin/`\
`$ ./RayTracer`

[Category:Gaming](Category:Gaming "wikilink") [Category:Hardware](Category:Hardware "wikilink")

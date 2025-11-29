[hu:OpenGL](hu:OpenGL "hu:OpenGL"){.wikilink} [ja:OpenGL](ja:OpenGL "ja:OpenGL"){.wikilink}
[ru:OpenGL](ru:OpenGL "ru:OpenGL"){.wikilink} [zh-hans:OpenGL](zh-hans:OpenGL "zh-hans:OpenGL"){.wikilink} From
[Wikipedia:OpenGL](Wikipedia:OpenGL "Wikipedia:OpenGL"){.wikilink}:

:   OpenGL (Open Graphics Library) is a cross-language, cross-platform application programming interface (API) for
    rendering 2D and 3D vector graphics.

Learn more at [Khronos](https://www.khronos.org/opengl/).

Development of OpenGL ceased in 2017 in favour of [Vulkan](Vulkan "Vulkan"){.wikilink}, the \"next generation\" API
which offers higher performance on newer hardware.

## Installation

To run applications that use OpenGL, you will need to [install](install "install"){.wikilink} the correct driver(s) for
your hardware (either GPUs or CPUs).

```{=mediawiki}
{{Tip|
* For AMD (and ATI) it is recommended to use the open-source drivers unless you have a strong reason to use the proprietary ones.
* For NVIDIA, the proprietary driver is recommended for cards newer than the [https://nouveau.freedesktop.org/CodeNames.html#NVE0 Kepler (NVE0/GK''XXX'')] series, and for better performance in general.}}
```
```{=mediawiki}
{{Note|
* Intel's Gen''N'' hardware does not refer to the generation of the CPU, it refers to the [[Wikipedia:List of Intel graphics processing units|generation of the GPU]], which is different from the generation of the CPU.
* To find the family of an AMD (and ATI) GPU, check [[Wikipedia:List of AMD graphics processing units#Features overview]]
* To find the code-name of an NVIDIA GPU, check the [https://nouveau.freedesktop.org/CodeNames.html code-name list from the Nouveau project]}}
```
[Mesa](https://mesa3d.org/) is an open-source OpenGL implementation, continually updated to support the latest OpenGL
specification. It has a collection of open-source drivers for [Intel
graphics](Intel_graphics "Intel graphics"){.wikilink}, [AMD](AMD "AMD"){.wikilink} (formerly
[ATI](ATI "ATI"){.wikilink}) and [NVIDIA](NVIDIA "NVIDIA"){.wikilink} GPUs. Mesa also provides software
[rasterizers](Wikipedia:Rasterisation "rasterizers"){.wikilink}, such as llvmpipe.

There are two Mesa packages, each with a distinct set of drivers:

- ```{=mediawiki}
  {{Pkg|mesa}}
  ```
  is the up-to-date Mesa package which includes most of the modern drivers for newer hardware:

  - ```{=mediawiki}
    {{ic|r300}}
    ```
    : for AMD\'s Radeon R300, R400, and R500 GPUs.

  - ```{=mediawiki}
    {{ic|r600}}
    ```
    : for AMD\'s Radeon R600 GPUs up to Northern Islands. Officially supported by AMD.

  - ```{=mediawiki}
    {{ic|radeonsi}}
    ```
    : for AMD\'s Southern Island GPUs and later. Officially supported by AMD.

  - ```{=mediawiki}
    {{ic|nouveau}}
    ```
    : [Nouveau](Nouveau "Nouveau"){.wikilink} is the open-source driver for NVIDIA GPUs.

  - ```{=mediawiki}
    {{ic|virtio_gpu}}
    ```
    : a virtual GPU driver for virtio, can be used with [QEMU](QEMU "QEMU"){.wikilink} based VMMs (like
    [KVM](KVM "KVM"){.wikilink} or [Xen](Xen "Xen"){.wikilink}).

  - ```{=mediawiki}
    {{ic|vmwgfx}}
    ```
    : for [VMware](VMware "VMware"){.wikilink} virtual GPUs.

  - ```{=mediawiki}
    {{ic|i915}}
    ```
    : for Intel\'s Gen 3 hardware.

  - ```{=mediawiki}
    {{ic|crocus}}
    ```
    : for Intel\'s Gen 4 to Gen 7 hardware.

  - ```{=mediawiki}
    {{ic|iris}}
    ```
    : for Intel\'s Gen 8 hardware and later. Officially supported by Intel.

  - ```{=mediawiki}
    {{ic|zink}}
    ```
    : a Gallium driver used to run OpenGL on top of [Vulkan](Vulkan "Vulkan"){.wikilink}.

  - ```{=mediawiki}
    {{ic|d3d12}}
    ```
    : for OpenGL 3.3 support on devices that only support D3D12 (i.e. [WSL](WSL "WSL"){.wikilink}).

  - ```{=mediawiki}
    {{ic|softpipe}}
    ```
    : a software rasterizer and a reference Gallium driver.

  - ```{=mediawiki}
    {{ic|llvmpipe}}
    ```
    : a software rasterizer which uses LLVM for x86 JIT code generation and is multi-threaded.

<!-- -->

- ```{=mediawiki}
  {{Pkg|mesa-amber}}
  ```
  is the legacy Mesa package which includes the classic (non-Gallium3D) drivers for older hardware:

  - ```{=mediawiki}
    {{ic|i830}}
    ```
    : for Intel\'s Gen 2 hardware. Same binary as `{{ic|i965}}`{=mediawiki}.

  - ```{=mediawiki}
    {{ic|i915}}
    ```
    : for Intel\'s Gen 3 hardware. Same binary as `{{ic|i965}}`{=mediawiki}.

  - ```{=mediawiki}
    {{ic|i965}}
    ```
    : for Intel\'s Gen 4 to Gen 11 hardware. Officially supported by Intel.

  - ```{=mediawiki}
    {{ic|radeon}}
    ```
    : for AMD\'s Radeon R100 GPUs. Same binary as `{{ic|r200}}`{=mediawiki}.

  - ```{=mediawiki}
    {{ic|r200}}
    ```
    : for AMD\'s Radeon R200 GPUs.

  - ```{=mediawiki}
    {{ic|nouveau_vieux}}
    ```
    : for NVIDIA NV04 (Fahrenheit) to NV20 (Kelvin) GPUs.

  - ```{=mediawiki}
    {{ic|swrast}}
    ```
    : a legacy software rasterizer.

:   ```{=mediawiki}
    {{Note|When using Mesa, the correct driver should be selected automatically, thus no configuration is needed once the package is installed.}}
    ```

- ```{=mediawiki}
  {{Pkg|nvidia-utils}}
  ```
  is the proprietary driver for [NVIDIA](NVIDIA "NVIDIA"){.wikilink} GPUs, which includes an OpenGL implementation.

## Verification

To verify your OpenGL installation, you can use `{{Pkg|mesa-utils}}`{=mediawiki} `{{ic|eglinfo}}`{=mediawiki}, which
should display output like this (with different values depending on your setup, of course):

```{=mediawiki}
{{hc|$ eglinfo -B|
Wayland platform:
EGL API version: 1.5
EGL vendor string: Mesa Project
EGL version string: 1.5
EGL client APIs: OpenGL OpenGL_ES
OpenGL core profile vendor: Intel
OpenGL core profile renderer: Mesa Intel(R) UHD Graphics (CML GT2)
OpenGL core profile version: 4.6 (Core Profile) Mesa 25.1.3-arch1.3
OpenGL core profile shading language version: 4.60
OpenGL compatibility profile vendor: Intel
OpenGL compatibility profile renderer: Mesa Intel(R) UHD Graphics (CML GT2)
OpenGL compatibility profile version: 4.6 (Compatibility Profile) Mesa 25.1.3-arch1.3
OpenGL compatibility profile shading language version: 4.60
OpenGL ES profile vendor: Intel
OpenGL ES profile renderer: Mesa Intel(R) UHD Graphics (CML GT2)
OpenGL ES profile version: OpenGL ES 3.2 Mesa 25.1.3-arch1.3
OpenGL ES profile shading language version: OpenGL ES GLSL ES 3.20

X11 platform:
EGL API version: 1.5
EGL vendor string: Mesa Project
EGL version string: 1.5
EGL client APIs: OpenGL OpenGL_ES
OpenGL core profile vendor: Intel
OpenGL core profile renderer: Mesa Intel(R) UHD Graphics (CML GT2)
OpenGL core profile version: 4.6 (Core Profile) Mesa 25.1.3-arch1.3
OpenGL core profile shading language version: 4.60
OpenGL compatibility profile vendor: Intel
OpenGL compatibility profile renderer: Mesa Intel(R) UHD Graphics (CML GT2)
OpenGL compatibility profile version: 4.6 (Compatibility Profile) Mesa 25.1.3-arch1.3
OpenGL compatibility profile shading language version: 4.60
OpenGL ES profile vendor: Intel
OpenGL ES profile renderer: Mesa Intel(R) UHD Graphics (CML GT2)
OpenGL ES profile version: OpenGL ES 3.2 Mesa 25.1.3-arch1.3
OpenGL ES profile shading language version: OpenGL ES GLSL ES 3.20
}}
```
On X11 platform, `{{ic|glxinfo}}`{=mediawiki} works as well.

From the same package, you can also use `{{ic|eglgears_x11}}`{=mediawiki} or `{{ic|glxgears}}`{=mediawiki} (on X11) or
`{{ic|eglgears_wayland}}`{=mediawiki} (on Wayland) as a basic OpenGL test. You should see 3 rotating gears when running
the program.

## Switching between drivers {#switching_between_drivers}

For [Hybrid graphics](Hybrid_graphics "Hybrid graphics"){.wikilink}, see [PRIME](PRIME "PRIME"){.wikilink}.

```{=mediawiki}
{{Note|According to this [https://www.reddit.com/r/linuxhardware/comments/he9nhe/amd_and_nvidia_gpus_in_the_same_machine_it_works/ Reddit post], you can use 2 GPUs from different vendors working at the same time using [[PRIME]] without any problems.}}
```
### Mesa

You can override the driver used for an application with the following [environment
variable](environment_variable "environment variable"){.wikilink}:

`MESA_LOADER_DRIVER_OVERRIDE=`*`driver`*

By default, Mesa searches for drivers in `{{ic|/lib/dri/}}`{=mediawiki}. You can view the list of installed drivers with

`$ ls /lib/dri/`

```{=mediawiki}
{{ic|''driver''}}
```
in `{{ic|''driver''_dri.so}}`{=mediawiki} is the actual name of the driver. If Mesa failed to find the specified driver,
it will fall back to `{{ic|llvmpipe}}`{=mediawiki}.

You can also use an OpenGL software rasterizer by setting the following [environment
variables](environment_variables "environment variables"){.wikilink}:

`LIBGL_ALWAYS_SOFTWARE=true`\
`GALLIUM_DRIVER=`*`driver`*

```{=mediawiki}
{{ic|''driver''}}
```
can be either `{{ic|softpipe}}`{=mediawiki}, `{{ic|llvmpipe}}`{=mediawiki}, or `{{ic|swr}}`{=mediawiki}.

```{=mediawiki}
{{Tip|In most use-cases, {{ic|llvmpipe}} and {{ic|swr}} are faster than {{ic|softpipe}}.}}
```
## OpenGL over Vulkan (Zink) {#opengl_over_vulkan_zink}

From the [Mesa documentation](https://docs.mesa3d.org/drivers/zink.html):

:   The Zink driver is a Gallium driver that emits Vulkan API calls instead of targeting a specific GPU architecture.
    This can be used to get full desktop OpenGL support on devices that only support Vulkan.

If you are experiencing issues in your default OpenGL drivers (a bug in RadeonSI, Iris, etc.), you could try using the
Zink driver.

According to [this Phoronix benchmark](https://www.phoronix.com/review/radeon-zink-summer23), the average FPS might be
lower in some applications compared to RadeonSI.

Note that Zink no longer works out-of-the-box on X systems that use the AMD or Intel DDX drivers
(`{{pkg|xf86-video-amdgpu}}`{=mediawiki} and `{{pkg|xf86-video-intel}}`{=mediawiki}, respectively). Upstream developers
recommend use of the generic `{{man|4|modesetting}}`{=mediawiki} [DDX
driver](Xorg#Driver_installation "DDX driver"){.wikilink}. [1](https://gitlab.freedesktop.org/mesa/mesa/-/issues/10093)
Alternatively, to bypass this issue, you can use the following environment variables:

`$ LIBGL_KOPPER_DRI2=1 MESA_LOADER_DRIVER_OVERRIDE=zink`

To use Zink on the proprietary NVIDIA driver, use this command or similar:

`$ env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink LIBGL_KOPPER_DRI2=1 `*`application`*

## Troubleshooting

### Lenovo GPU Graphics Mesa Error {#lenovo_gpu_graphics_mesa_error}

Mesa was using CPU (llvmpipe) for rendering, which crashed some GUI software. Fixed this by going to BIOS settings and
choosing Dynamic Graphics over Discrete Graphics (If using another computer, choose the option that lets you switch
between GPUs than disabling the integrated GPU). This will happen if main GPU driver is not installed but you expect the
integrated one to work. [2](https://download.lenovo.com/pccbbs/pubs/legion_s7_16_7/html/en-us/explore_GPUMode.html)

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink}
[Category:Development](Category:Development "Category:Development"){.wikilink}

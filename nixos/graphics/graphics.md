This is intended to be an overview of how setting up graphics on NixOS works.

## Hardware-Specific Pages {#hardware_specific_pages}

- [Intel Graphics](Intel_Graphics "Intel Graphics"){.wikilink}
- [AMD GPU](AMD_GPU "AMD GPU"){.wikilink}
- [Nvidia](Nvidia "Nvidia"){.wikilink}

## Kernel-Level {#kernel_level}

Kernel-level GPU support is provided by a kernel module. E.g. for AMD GPUs (including iGPUs) that\'s `amdgpu`. The
module is loaded automatically based on the detected hardware. On x86 devices, detection is done automatically through
ACPI. On ARM devices such as the Raspberry Pi, information about hardware is provided through a devicetree, normally by
the bootloader.

When loading the module, the kernel uses \*Kernel Mode Setting\* (KMS) to configure the video mode. This allows native
resolution during boot and in tty\'s. See also [the Arch Wiki](https://wiki.archlinux.org/title/Kernel_mode_setting).

Normally, the kernel module is loaded and KMS is performed after the initrd stage (\"late KMS\"), i.e. *after* entering
the encryption password if you use full disk encryption. This will produce some flickering.

The kernel module can also be added to the initrd itself (\"early KMS\") by adding the kernel module for your hardware
to `boot.initrd.kernelModules`. Early KMS is especially desirable when using something like Plymouth for flicker-free
fancy graphics during boot. If you don\'t use Plymouth, early KMS might actually make the boot sequence worse, because
the flicker might heppen during encryption password entry.

## OpenGL

```{=mediawiki}
{{Note|<code>hardware.opengl</code> was renamed to <code>hardware.graphics</code> in NixOS 24.11.}}
```
Userspace-level graphics support is provided through OpenGL. The kernel module is used just for interfacing with the
hardware, the OpenGL driver is what Wayland (or the X server) actually uses for rendering.

The OpenGL implementation used on Linux is the [Mesa graphics library](Mesa "Mesa graphics library"){.wikilink}. Mesa
contains drivers for various hardware, the exact driver is selected automatically. Note that Mesa also supports software
rendering if no compatible hardware driver is available, but this is very slow.

Mesa can installed using the option `hardware.graphics.enable`, but note that most desktop environment modules set this
themselves anyway. This option writes the driver files to `/run/opengl-driver`. Additional graphics drivers packages can
be added using `hardware.graphics.extraPackages`.

To verify which Mesa driver is used: `nix shell nixpkgs#mesa-demos -c glxinfo`

## Vulkan

Apart from the OpenGL API, there\'s also the more modern Vulkan API. Vulkan drivers are also included in Mesa (e.g., for
AMD hardware that\'s RADV). See also [the Arch Wiki](https://wiki.archlinux.org/title/Vulkan).

For the installed Vulkan drivers, see `/run/opengl-driver/share/vulkan/icd.d/`. To verify which driver is used:
`nix shell nixpkgs#vulkan-tools -c vulkaninfo`

## OpenCL

Computing things on the GPU is supported through the OpenCL API. To enable OpenCL support, add the right packages for
your hardware to `hardware.graphics.extraPackages`. See also [the Arch Wiki](https://wiki.archlinux.org/title/GPGPU).

To verify OpenCL support: `nix shell nixpkgs#clinfo -c clinfo`

## Hardware Video Acceleration {#hardware_video_acceleration}

GPUs have built-in hardware for decoding / encoding video. Using this is much more efficient than using the CPU. See
also [the Arch Wiki](https://wiki.archlinux.org/title/Hardware_video_acceleration).

There are two main APIs for video accel on Linux.

### VA-API {#va_api}

Developed by Intel, open spec, FOSS library. Seems to be generally broader supported than VDPAU.

Many VA-API drivers are also included in Mesa.

For available drivers, see `/run/opengl-driver/lib/dri`. The file names are `{DRIVER_NAME}_drv_video.so`.

The driver used for VA-API can be overridden with the env var `LIBVA_DRIVER_NAME`. E.g. for AMD, it\'s `radeonsi`.

To verify VA-API support and view supported codecs: `nix shell nixpkgs#libva-utils -c vainfo`

### VDPAU

Authored by Nvidia, developed by freedesktop.org, open spec, FOSS library.

Many VDPAU drivers are also included in Mesa.

For available drivers, see `/run/opengl-driver/lib/vdpau`. The file names are `libvdpau_{DRIVER_NAME}.so`.

The driver used for VDPAU can be overridden with the env var `VDPAU_DRIVER`. E.g. for AMD, it\'s `radeonsi`.

To verify VDPAU support and view supported codecs: `nix shell nixpkgs#vdpauinfo -c vdpauinfo`

Note that VDPAU will not be able to detect the correct drive to use in most Wayland enviroments, as there is no DRI2
support. The driver will always fall back to `nvidia` if it wasn\'t set using `VDPAU_DRIVER`.[^1]

## See also {#see_also}

- The Arch Wiki has good articles on a lot of these topics, which are linked above.
- [writeup about setting up graphics](https://git.eisfunke.com/config/nixos/-/blob/main/docs/graphics.md?ref_type=heads)
  in Eisfunke\'s NixOS config repo (this article was originally based on that)

[Category:Video](Category:Video "Category:Video"){.wikilink}

[^1]: [1](https://gitlab.freedesktop.org/vdpau/libvdpau/-/blob/2afa3f989af24a922692ac719fae23c321776cdb/src/vdpau_wrapper.c#L129)

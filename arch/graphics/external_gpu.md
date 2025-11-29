[ja:外付け GPU](ja:外付け_GPU "wikilink") [zh-hans:外接显卡](zh-hans:外接显卡 "wikilink")
`{{Related articles start}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki} `{{Related|PRIME}}`{=mediawiki}
`{{Related|Thunderbolt}}`{=mediawiki} `{{Related|NVIDIA Optimus}}`{=mediawiki}
`{{Related|NVIDIA/Tips and tricks}}`{=mediawiki} `{{Related|Docks}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

On computers equipped with [Thunderbolt 3+](Wikipedia:Thunderbolt_(interface)#Thunderbolt_3 "wikilink") or
[USB4](Wikipedia:USB4 "wikilink"), it is possible to attach a desktop-grade external graphics card (eGPU) using a GPU
enclosure. [eGPU.io](https://egpu.io/) is a good resource with buyer\'s guide and a community forum. While some manual
configuration (shown below) is needed for most modes of operation, Linux support for eGPUs is generally good.

```{=mediawiki}
{{Note|For USB4 laptops the data rate is specified to be at minimum 20 Gbit/s and optionally superior (40, 80, or more ). When using a Thunderbolt enclosure it is a good idea to ensure the laptop USB4 implementation supports the same data rate.}}
```
## Installation

### Thunderbolt

The eGPU enclosure Thunderbolt device may need to be authorized first after plugging in (based on your BIOS/UEFI
Firmware configuration). Follow [Thunderbolt#User device
authorization](Thunderbolt#User_device_authorization "wikilink"). If successful, the external graphics card should show
up in `{{ic|lspci}}`{=mediawiki}:

```{=mediawiki}
{{hc|$ lspci -d ::03xx|
00:02.0 VGA compatible controller: Intel Corporation UHD Graphics 620 (rev 07)             # internal GPU
1a:10.3 VGA compatible controller: NVIDIA Corporation GP107 [GeForce GTX 1050] (rev a1)    # external GPU
}}
```
Depending on your computer, its firmware and enclosure firmware, Thunderbolt will limit host \<-\> eGPU bandwidth to
some extent due to [the number of PCIe lanes and OPI Mode](https://egpu.io/best-laptops-external-gpu/#pcie):

```{=mediawiki}
{{hc|# dmesg {{!}}
```
grep PCIe\| \[19888.928225\] pci 0000:1a:10.3: 8.000 Gb/s available PCIe bandwidth, limited by 2.5 GT/s PCIe x4 link at
0000:05:01.0 (capable of 126.016 Gb/s with 8.0 GT/s PCIe x16 link) }}

### Drivers

A driver compatible with your GPU model should be installed:

-   [AMDGPU](AMDGPU "wikilink")
-   [NVIDIA](NVIDIA "wikilink") proprietary NVIDIA drivers
-   [Nouveau](Nouveau "wikilink") open-source NVIDIA drivers

If installed successfully, `{{ic|lspci -k}}`{=mediawiki} should show that a driver has been associated with your card:

```{=mediawiki}
{{hc|$ lspci -k -d ::03xx|
1a:10.3 VGA compatible controller: NVIDIA Corporation GP107 [GeForce GTX 1050] (rev a1)
        Subsystem: NVIDIA Corporation GP107 [GeForce GTX 1050]
        Kernel driver in use: nvidia
        Kernel modules: nouveau, nvidia_drm, nvidia
}}
```
#### AMDGPU

Note that the AMDGPU driver (with either Thunderbolt or USB4) might in some cases set the wrong *pcie_gen_cap* option
and fall back to PCIe gen 1.1 speed, with possibly serious performance issues. In this case the proper value can be set
as module option (see [Kernel module#Using modprobe.d](Kernel_module#Using_modprobe.d "wikilink")) or even passed as
[kernel parameters](kernel_parameters "wikilink"):

```{=mediawiki}
{{hc|/etc/modprobe.d/amd-egpu-pcie-speed.conf|
options amdgpu pcie_gen_cap{{=}}
```
0x40000 }}

This will set PCIe gen 3 speed. A full list of options can be found in
[amd_pcie.h](https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/amd/include/amd_pcie.h#L26).

#### NVIDIA

For NVIDIA eGPUs on some systems you may need to early load the thunderbolt kernel module to ensure it is loaded before
`{{ic|nvidia_drm}}`{=mediawiki}.

-   If you use [mkinitcpio](mkinitcpio "wikilink") initramfs, follow [mkinitcpio#MODULES](mkinitcpio#MODULES "wikilink")
    to add modules.
-   If you use [Booster](Booster "wikilink"), follow [Booster#Early module
    loading](Booster#Early_module_loading "wikilink").
-   If you use [dracut](dracut "wikilink"), follow [dracut#Early kernel module
    loading](dracut#Early_kernel_module_loading "wikilink").

## Compute-only workloads {#compute_only_workloads}

Right after completing [installation steps](#Installation "wikilink"), compute-only workloads like
[GPGPU#CUDA](GPGPU#CUDA "wikilink") that do not need to display anything should work without any extra configuration.
The *nvidia-smi* utility (provided by the `{{Pkg|nvidia-utils}}`{=mediawiki} package) should work with the proprietary
NVIDIA driver. Proprietary [NVENC/NVDEC](Wikipedia:Nvidia_NVENC "wikilink") should work (without OpenGL interop).

This use-case should also support full hotplug. Hot-unplug should be also possible (probably depending on drivers used).
On NVIDIA, active `{{ic|nvidia-persistenced}}`{=mediawiki} is expected to prevent clean hot-unplug.

## Xorg

Multiple setups combining internal (iGPU) and external (eGPU) cards are possible, each with own advantages and
disadvantages.

### Xorg rendered on eGPU, PRIME display offload to iGPU {#xorg_rendered_on_egpu_prime_display_offload_to_igpu}

-   Most programs that make use of GPU run out-of-the-box on eGPU:
    `{{ic|glxinfo}}`{=mediawiki}/`{{ic|glxgears}}`{=mediawiki},
    `{{ic|eglinfo}}`{=mediawiki}/`{{ic|eglgears_x11}}`{=mediawiki},
    `{{ic|NVENC}}`{=mediawiki}/`{{ic|NVDEC}}`{=mediawiki} (including OpenGL interop).
-   Xorg only starts with the eGPU plugged in.
-   Monitors attached to eGPU work out-of-the-box, PRIME *display* offload can be used for monitors attached to iGPU
    (i.e. internal laptop screen).

Main article is [PRIME#Reverse PRIME](PRIME#Reverse_PRIME "wikilink"). Also documented in NVIDIA driver docs [Chapter
34. Offloading Graphics Display with RandR
1.4](https://download.nvidia.com/XFree86/Linux-x86_64/565.77/README/randr14.html).

Use Xorg configuration snippet like this one:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/80-egpu-primary-igpu-offload.conf|
Section "Device"
    Identifier "Device0"
    Driver     "nvidia"
    BusID      "PCI:26:16:3"                 # Edit according to lspci, translate from hex to decimal.
    Option     "AllowExternalGpus" "True"    # Required for proprietary NVIDIA driver.
EndSection

Section "Module"
    # Load modesetting module for the iGPU, which should show up in XrandR 1.4 as a provider.
    Load "modesetting"
EndSection
}}
```
```{=mediawiki}
{{Note|Xorg uses decimal bus IDs, while most other tools use hexadecimal. We had to convert {{ic|1a:10.3}} to {{ic|26:16:3}} for {{ic|xorg.conf}} snippet.}}
```
```{=mediawiki}
{{Tip|With modern Xorg, it is not needed to specify {{ic|ServerLayout}} and {{ic|Screen}} sections, as these are inferred automatically. First {{ic|Device}} defined will be considered primary.}}
```
To **validate** this setup, use `{{ic|xrandr --listproviders}}`{=mediawiki}, which should display

```{=mediawiki}
{{bc|
Providers: number : 2
Provider 0: id: 0x1b8 cap: 0x1, Source Output crtcs: 4 outputs: 4 associated providers: 0 name:NVIDIA-0
Provider 1: id: 0x1f3 cap: 0xf, Source Output, Sink Output, Source Offload, Sink Offload crtcs: 3 outputs: 5 associated providers: 0 name:modesetting
}}
```
To **output to internal laptop screen and/or other monitors attached to iGPU**, RandR 1.4 PRIME *display* offload can be
used, using names from above `{{ic|xrandr --listproviders}}`{=mediawiki} output:

```{=mediawiki}
{{bc|xrandr --setprovideroutputsource modesetting NVIDIA-0 && xrandr --auto}}
```
```{=mediawiki}
{{Note|The {{ic|xrandr --auto}} is optional and may be substituted by any RandR-based display configuration tool. Its presence prevents all-screens-black situation.}}
```
You may want to run this command before a display manager shows login prompt or before desktop environment starts, see
[xrandr#Configuration](xrandr#Configuration "wikilink") and [xinit](xinit "wikilink").

[Vulkan](Vulkan "wikilink") may enumerate GPUs independently of Xorg, so in order to run for example
`{{ic|vkcube}}`{=mediawiki} in this setup, one may need to pass `{{ic|--gpu_number 1}}`{=mediawiki} option.
Alternatively, a layer to reorder GPUs during enumeration can be activated with the same effect:
`{{ic|1=__NV_PRIME_RENDER_OFFLOAD=1 vkcube}}`{=mediawiki} or equivalently `{{ic|prime-run vkcube}}`{=mediawiki}.

```{=mediawiki}
{{Tip|If using ''optimus-manager'' on a laptop, you can render on eGPU by adding the {{ic|BusId}} of the eGPU in the appropriate file for your mode and graphics card in {{ic|/etc/optimus-manager/xorg/}}.}}
```
### Xorg rendered on iGPU, PRIME render offload to eGPU {#xorg_rendered_on_igpu_prime_render_offload_to_egpu}

-   Programs are rendered on iGPU by default, but PRIME *render* offload can be used to render them on eGPU.
-   Xorg starts even with eGPU disconnected, but render/display offload will not work until it is restarted.
-   Monitors attached to iGPU (i.e. internal laptop screen) work out-of-the-box, PRIME *display* offload can be used for
    monitors attached to eGPU.

Main article is [PRIME#PRIME GPU offloading](PRIME#PRIME_GPU_offloading "wikilink"). Also documented in NVIDIA driver
docs [Chapter 35. PRIME Render
Offload](https://download.nvidia.com/XFree86/Linux-x86_64/565.77/README/primerenderoffload.html).

With many discrete GPU drivers, this mode should be the default without any manual Xorg configuration. If that does not
work, or if you use proprietary NVIDIA drivers, use the following:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/80-igpu-primary-egpu-offload.conf|
Section "Device"
    Identifier "Device0"
    Driver     "modesetting"
EndSection

Section "Device"
    Identifier "Device1"
    Driver     "nvidia"
    BusID      "PCI:26:16:3"                 # Edit according to lspci, translate from hex to decimal.
    Option     "AllowExternalGpus" "True"    # Required for proprietary NVIDIA driver.
EndSection
}}
```
To **validate** this setup, use `{{ic|xrandr --listproviders}}`{=mediawiki}, which should display

```{=mediawiki}
{{hc|$ xrandr --listproviders|
Providers: number : 2
Provider 0: id: 0x47 cap: 0xf, Source Output, Sink Output, Source Offload, Sink Offload crtcs: 3 outputs: 5 associated providers: 0 name:modesetting
Provider 1: id: 0x24a cap: 0x2, Sink Output crtcs: 4 outputs: 4 associated providers: 0 name:NVIDIA-G0
}}
```
```{=mediawiki}
{{Merge|PRIME#Configure applications to render using GPU|We should link to the dedicated page for these variables instead of duplicating them here.}}
```
To **render** `{{ic|''some_program''}}`{=mediawiki} **on the eGPU**, PRIME *render* offload can be used:

-   for proprietary NVIDIA drivers:
    `{{bc|1=$ __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia ''some_program''}}`{=mediawiki}
-   for proprietary NVIDIA drivers (convenience wrapper): `{{bc|1=$ prime-run ''some_program''}}`{=mediawiki}
-   for open-source drivers: `{{bc|1=$ DRI_PRIME=1 ''some_program''}}`{=mediawiki}

To **output to monitors connected to eGPU**, RandR 1.4 PRIME *display* offload can be again used:

`$ xrandr --setprovideroutputsource NVIDIA-G0 modesetting && xrandr --auto`

```{=mediawiki}
{{Tip|The order of providers is different, and the NVIDIA the has a slightly different name this time.}}
```
NVIDIA drivers 460.27.04+ [implement an optimization for a special case of combined render and display
offloads](https://forums.developer.nvidia.com/t/linux-solaris-and-freebsd-driver-460-27-04-beta/163730):

:   Added support for "Reverse PRIME Bypass", an optimization that bypasses the bandwidth overhead of PRIME Render
    Offload and PRIME Display Offload in conditions where a render offload application is fullscreen, unredirected, and
    visible only on a given NVIDIA-driven PRIME Display Offload output. Use of the optimization is reported in the X log
    when verbose logging is enabled in the X server.

### Separate Xorg instance for eGPU {#separate_xorg_instance_for_egpu}

Main article is [nvidia-xrun#External GPU setup](nvidia-xrun#External_GPU_setup "wikilink").

### Known issues with eGPUs on Xorg {#known_issues_with_egpus_on_xorg}

-   hotplug is not supported with most discrete GPU Xorg drivers: the eGPU needs to be plugged in when Xorg starts.
    Logging out and in again should suffice to restart Xorg.
-   hot-unplug is not supported at all: doing so leads to system instability or outright freezes (as acknowledged in the
    [NVIDIA documentation](https://download.nvidia.com/XFree86/Linux-x86_64/565.77/README/egpu.html)).

## Wayland

Wayland support for eGPUs (or multiple GPUs in general) is much less tested, but should work with even less manual
configuration.

Note that there need to be explicit GPU hotplug support by the Wayland compositor, but most already have some level of
support:

-   KDE\'s kwin: <https://invent.kde.org/plasma/kwin/-/merge_requests/811>
-   GNOME\'s Mutter: <https://gitlab.gnome.org/GNOME/mutter/-/issues/17>,
    <https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1562>
-   wlroots: <https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/1278>

For open-source drivers, DRI offloading works fine:

`$ DRI_PRIME=1 `*`some_program`*

Some projects, such as [all-ways-egpu](https://github.com/ewagner12/all-ways-egpu/wiki), are trying to provide more
efficient methods for GPU selection under Wayland.

### Hotplugging NVIDIA eGPU {#hotplugging_nvidia_egpu}

It is possible to hotplug eGPU when using Wayland, and use PRIME feature. NVIDIA already has great implementation of
PRIME for dGPUs, and it is working same way for eGPU.

First you need to make sure that no program uses NVIDIA modules. EGL programs tend to use 1MB dGPU memory per program,
even if they run on iGPU, and it can be seen in `{{ic|nvidia-smi}}`{=mediawiki}. To avoid this, add
`{{ic|1=__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json}}`{=mediawiki} as [environment
variable](environment_variable "wikilink"). Best place for that is `{{ic|/etc/environment.d/50_mesa.conf}}`{=mediawiki}.

Then you unload NVIDIA modules:

`# rmmod nvidia_uvm`\
`# rmmod nvidia_drm`\
`# rmmod nvidia_modeset`\
`# rmmod nvidia`

When NVIDIA modules is no longer loaded, you can connect external GPU. When GPU is initialized, load NVIDIA modules
again with `{{ic|modprobe nvidia-drm}}`{=mediawiki} command or `{{ic|modprobe nvidia-current-drm}}`{=mediawiki}. Naming
depends on source of modules, either it is drivers from NVIDIA website or from package manager. In some cases (for
example, for GIGABYTE AORUS GAMING BOX) eGPU does not work with proprietary modules, so you might need to load
open-source ones: `{{ic|modprobe nvidia-current-open-drm}}`{=mediawiki}.

When modules successfully loaded, prime feature will work, but since we set
`{{ic|__EGL_VENDOR_LIBRARY_FILENAMES}}`{=mediawiki} variable to use MESA, we need to add
`{{ic|1=__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json}}`{=mediawiki} before starting
program. Full string will look like:

`__GLX_VENDOR_LIBRARY_NAME=nvidia __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json %command%`

For GNOME users, you might need to patch `{{Pkg|switcheroo-control}}`{=mediawiki} to include
`{{ic|__EGL_VENDOR_LIBRARY_FILENAMES}}`{=mediawiki} into list of environment variables. This will allow programs to run
on eGPU naturally with right click and \"Launch using Dedicated Graphics Card\". But this is beyond scope of this
article.

### Hotplugging NVIDIA eGPU and temporarily disabling NVIDIA dGPU {#hotplugging_nvidia_egpu_and_temporarily_disabling_nvidia_dgpu}

In case you have iGPU, NVIDIA dGPU and want to connect NVIDIA eGPU, you will encounter a conflict, where graphics
renders only on dGPU, no matter what you do. To solve this, you need to temporarily disable dGPU, so NVIDIA driver will
not notice it. Best way to do that is to override its driver.

First, you need to unload NVIDIA driver:

`# rmmod nvidia_uvm`\
`# rmmod nvidia_drm`\
`# rmmod nvidia_modeset`\
`# rmmod nvidia`

Then, you need to override dGPU driver with `{{AUR|driverctl}}`{=mediawiki} utility. In this example, 0000:01:00.0 is
address of dGPU. It can be found with `{{ic|lspci}}`{=mediawiki} utility.

`# driverctl --nosave set-override 0000:01:00.0 vfio-pci`

It is important to use `{{ic|--nosave}}`{=mediawiki} parameter, to prevent driverctl to override driver on boot. It is
useful in case something goes wrong, simple reboot cleans everything.

When dGPU is disabled, you can load kernel modules with `{{ic|modprobe nvidia-drm}}`{=mediawiki} and then check if
`{{ic|nvidia-smi}}`{=mediawiki} shows 1 or 2 GPUs.

Bringing dGPU back is tricky, because it is unintuitive. First, unload NVIDIA modules, unplug eGPU and then run this
series of commands:

`# modprobe nvidia-current`\
`# driverctl --nosave unset-override 0000:01:00.0`\
`# modprobe nvidia-current`\
`# driverctl --nosave unset-override 0000:01:00.0`\
`# modprobe nvidia-current-modeset`\
`# modprobe nvidia-current-drm`

It is strange that we need to run first 2 commands twice, but otherwise it will not bring back dGPU. Command will error
once, but it is not critical.

[Category:Graphics](Category:Graphics "wikilink") [Category:X server](Category:X_server "wikilink")

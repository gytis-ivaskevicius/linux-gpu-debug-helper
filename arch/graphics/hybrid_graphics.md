[es:Hybrid graphics](es:Hybrid_graphics "es:Hybrid graphics"){.wikilink}
[ja:ハイブリッドグラフィックス](ja:ハイブリッドグラフィックス "ja:ハイブリッドグラフィックス"){.wikilink} [ru:Hybrid
graphics](ru:Hybrid_graphics "ru:Hybrid graphics"){.wikilink}
[zh-hans:混合图形技术](zh-hans:混合图形技术 "zh-hans:混合图形技术"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|NVIDIA Optimus}}`{=mediawiki} `{{Related|PRIME}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki}
`{{Related|External GPU}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

Hybrid-graphics is a concept involving two graphics cards on same computer. Laptop manufacturers have developed
technologies involving two graphics cards with different abilities and power consumption on a single computer.
Hybrid-graphics has been developed to support both high performance and power saving use cases by keeping the
Dedicated/Discrete Graphics Processor inactive unless its 3D rendering performance is needed over the Integrated
Graphics Processor.

There are a variety of technologies and each manufacturer developed its own solution to this problem. This technology is
well supported on Windows but it is still rough around the edges with Linux distributions. This article will try to
explain a little about each approach and describe some community solutions to the lack of GNU/Linux systems support by
vendors.

```{=mediawiki}
{{Note|Unless your setup is from before 2010, it likely is using a dynamic switching model. Previous hybrid graphics solutions involved either a reboot for the crudest or a full graphical stack restart which needed a re-log for taking effect.}}
```
## Dynamic switching {#dynamic_switching}

Most of the new Hybrid-graphics technologies involve two graphics cards: the dedicated and integrated cards are plugged
to a framebuffer and there is no hardware multiplexer. The integrated card is always on and the dedicated card is
switched on/off when there is a need in power-save or performance-rendering. In most cases there is no way to use *only*
the dedicated card and all the switching and rendering is controlled by software. At startup, the Linux kernel starts
using a video mode and setting up low-level graphic drivers which will be used by the applications. Most of the Linux
distributions then use X.org to create a graphical environment. Finally, a few other softwares are launched, first a
login manager and then a window manager, and so on. This hierarchical system has been designed to be used in most of
cases on a single graphics card.

```{=mediawiki}
{{Note|Read [[NVIDIA Optimus]] and [[Bumblebee]] for details about NVIDIA using hybrid graphics with NVIDIA’s proprietary driver. Read [[PRIME]] for basically everything else (like AMD or NVIDIA GPUs with the [[nouveau]] driver).}}
```
### Fully power down discrete GPU {#fully_power_down_discrete_gpu}

You may want to turn off the high-performance graphics processor to save battery power.

#### Using BIOS/UEFI {#using_biosuefi}

Some laptop manufacturers provide a toggle in the BIOS or UEFI to fully deactivate the dedicated card.

#### Using udev rules {#using_udev_rules}

Ensure any display manager config for NVIDIA is removed.

Blacklist the nouveau drivers by creating

```{=mediawiki}
{{hc|/etc/modprobe.d/blacklist-nouveau.conf|2=
blacklist nouveau
options nouveau modeset=0
}}
```
Then create

```{=mediawiki}
{{hc|/etc/udev/rules.d/00-remove-nvidia.rules|2=
# Remove NVIDIA USB xHCI Host Controller devices, if present
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

# Remove NVIDIA USB Type-C UCSI devices, if present
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

# Remove NVIDIA Audio devices, if present
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

# Remove NVIDIA VGA/3D controller devices
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
}}
```
Reboot and run `{{ic|lspci}}`{=mediawiki} to see if your NVIDIA GPU is still listed.

Check power usage to ensure your GPU is not drawing power, if it does [#Using
acpi_call](#Using_acpi_call "#Using acpi_call"){.wikilink} may be another option to fully power it down.

#### Using bbswitch {#using_bbswitch}

With an NVIDIA GPU, this can be more safely done using [bbswitch](bbswitch "bbswitch"){.wikilink}, which consists of a
kernel package that automatically issues the correct ACPI calls to disable the discrete GPU when not needed, or
automatically at boot.

```{=mediawiki}
{{Note|bbswitch does not work with the PCI-E port power management method since kernel 4.8. See [[Bumblebee#Broken power management with kernel 4.8]] for details.}}
```
#### Using acpi_call {#using_acpi_call}

Otherwise, and for GPUs not supported by bbswitch, the same can be done manually installing the
`{{pkg|acpi_call}}`{=mediawiki} package.

```{=mediawiki}
{{Tip|For kernels not in the [[official repositories]], the {{Pkg|acpi_call-dkms}} is an alternative. See also [[DKMS]].}}
```
Once installed load the kernel module:

`# modprobe acpi_call`

With the kernel module loaded, execute the script at `{{ic|/usr/share/acpi_call/examples/turn_off_gpu.sh}}`{=mediawiki}

The script will go through all the known data buses and attempt to turn them off. You will get an output similar to the
following:

```{=mediawiki}
{{hc|# /usr/share/acpi_call/examples/turn_off_gpu.sh|
Trying \_SB.PCI0.P0P1.VGA._OFF: failed
Trying \_SB.PCI0.P0P2.VGA._OFF: failed
Trying \_SB_.PCI0.OVGA.ATPX: failed
Trying \_SB_.PCI0.OVGA.XTPX: failed
Trying \_SB.PCI0.P0P3.PEGP._OFF: failed
Trying \_SB.PCI0.P0P2.PEGP._OFF: failed
Trying \_SB.PCI0.P0P1.PEGP._OFF: failed
Trying \_SB.PCI0.MXR0.MXM0._OFF: failed
Trying \_SB.PCI0.PEG1.GFX0._OFF: failed
Trying \_SB.PCI0.PEG0.GFX0.DOFF: failed
Trying \_SB.PCI0.PEG1.GFX0.DOFF: failed
'''Trying \_SB.PCI0.PEG0.PEGP._OFF: works!'''
Trying \_SB.PCI0.XVR0.Z01I.DGOF: failed
Trying \_SB.PCI0.PEGR.GFX0._OFF: failed
Trying \_SB.PCI0.PEG.VID._OFF: failed
Trying \_SB.PCI0.PEG0.VID._OFF: failed
Trying \_SB.PCI0.P0P2.DGPU._OFF: failed
Trying \_SB.PCI0.P0P4.DGPU.DOFF: failed
Trying \_SB.PCI0.IXVE.IGPU.DGOF: failed
Trying \_SB.PCI0.RP00.VGA._PS3: failed
Trying \_SB.PCI0.RP00.VGA.P3MO: failed
Trying \_SB.PCI0.GFX0.DSM._T_0: failed
Trying \_SB.PCI0.LPC.EC.PUBS._OFF: failed
Trying \_SB.PCI0.P0P2.NVID._OFF: failed
Trying \_SB.PCI0.P0P2.VGA.PX02: failed
Trying \_SB_.PCI0.PEGP.DGFX._OFF: failed
Trying \_SB_.PCI0.VGA.PX02: failed}}
```
See the \"works\"? This means the script found a bus which your GPU sits on and it has now turned off the chip. To
confirm this, your battery time remaining should have increased.

```{=mediawiki}
{{Tip|If you are experiencing trouble hibernating or suspending the system after disabling the GPU, try to enable it again by sending the corresponding acpi_call. See also [[Power management/Suspend and hibernate#Custom systemd units]].}}
```
##### Turning off the GPU automatically {#turning_off_the_gpu_automatically}

Currently, the chip will turn back on with the next reboot. To get around this, [load the module at
boot](load_the_module_at_boot "load the module at boot"){.wikilink}:

```{=mediawiki}
{{hc|/etc/modules-load.d/acpi_call.conf|
#Load 'acpi_call.ko' at boot.
acpi_call
}}
```
###### At boot {#at_boot}

To turn off the GPU at boot it is possible to use [systemd-tmpfiles](systemd-tmpfiles "systemd-tmpfiles"){.wikilink}.

```{=mediawiki}
{{hc|/etc/tmpfiles.d/acpi_call.conf|

w /proc/acpi/call - - - - ''\\_SB.PCI0.PEG0.PEGP._OFF''}}
```
The configuration above will be loaded at boot by systemd. What it does is write the specific OFF signal to the
`{{ic|/proc/acpi/call}}`{=mediawiki} file. Obviously, replace the `{{ic|\_SB.PCI0.PEG0.PEGP._OFF}}`{=mediawiki} with the
one which works on your system (please note that you need to escape the backslash).

###### After X server initialization {#after_x_server_initialization}

On some systems, turning off the discrete GPU before the X server is initialized may hang the system. In such cases, it
may be better to disable the GPU after X server initialization, which is possible with some display managers. In
[LightDM](LightDM "LightDM"){.wikilink}, for instance, the *display-setup-script* seat configuration parameter could be
used to execute a script as root that disables the GPU. If you use [SDDM](SDDM "SDDM"){.wikilink} then you can add the
line `{{ic|echo "\_SB.PCI0.PEG0.PEGP._OFF" > /proc/acpi/call}}`{=mediawiki} to either
`{{ic|/usr/share/sddm/scripts/wayland-session}}`{=mediawiki} or `{{ic|/usr/share/sddm/scripts/Xsession}}`{=mediawiki}
depending if you use [Wayland](Wayland "Wayland"){.wikilink} or [Xorg](Xorg "Xorg"){.wikilink}, replacing
`{{ic|\_SB.PCI0.PEG0.PEGP._OFF}}`{=mediawiki} with the one which works on your system.

### System76

Some System76 laptops (like the [Oryx Pro](System76_Oryx_Pro "Oryx Pro"){.wikilink}) have their own unique hybrid
graphics option. To make use of it, install `{{AUR|system76-power}}`{=mediawiki}, [enable](enable "enable"){.wikilink}
`{{ic|system76-power.service}}`{=mediawiki}, and run `{{ic|system76-power graphics hybrid}}`{=mediawiki}.

#### Fully power down discrete GPU {#fully_power_down_discrete_gpu_1}

First ensure you are using integrated graphics mode by running `{{ic|system76-power graphics integrated}}`{=mediawiki}
and rebooting. Once in integrated mode, to power down the discrete graphics card run
`{{ic|system76-power graphics power off}}`{=mediawiki}. This command is not persistent and will need to be run after
each boot.

## Troubleshooting

### The startup time for certain applications is delayed by 30 seconds {#the_startup_time_for_certain_applications_is_delayed_by_30_seconds}

```{=mediawiki}
{{Merge|Vulkan|This seems very similar to [[Vulkan#AMDGPU - Vulkan applications launch slowly]], except it completely unsets the variable instead of passing it the proper value depending on the iGPU used.}}
```
When invoked, [Vulkan](Vulkan "Vulkan"){.wikilink} attempts to initialize the Installable Client Driver (ICD) specified
in `{{ic|/usr/share/vulkan/icd.d/nvidia_icd.json}}`{=mediawiki}. The package `{{Pkg|nvidia-utils}}`{=mediawiki}
configures this file to reference the `{{ic|libGLX_nvidia}}`{=mediawiki} driver, providing Vulkan with information about
the GPU driver\'s path. However, if the GPU is disabled, initialization of this driver will fail, causing certain
applications (e.g., those based on
[Chromium](Chromium "Chromium"){.wikilink}/[Electron](Electron "Electron"){.wikilink}) to undergo delayed startup until
a 30-second timeout is reached. To prevent Vulkan from attempting to load the driver in the first place and thus
mitigate this timeout, you can override the location of the ICD JSON file using the `{{ic|VK_DRIVER_FILES}}`{=mediawiki}
[environment variable](environment_variable "environment variable"){.wikilink}. To unset it, use:

`$ export VK_DRIVER_FILES=`

### High power draw even after disabling NVIDIA discrete GPU {#high_power_draw_even_after_disabling_nvidia_discrete_gpu}

If after disabling the dedicated GPU bus [#Using acpi_call](#Using_acpi_call "#Using acpi_call"){.wikilink} the power
draw is still high, check if the [nouveau](nouveau "nouveau"){.wikilink} kernel module is loaded with
`{{ic|lsmod}}`{=mediawiki}. If it is not then make sure it is installed, that any entries in .conf files that blacklist
Nouveau in `{{ic|/etc/modprobe.d/}}`{=mediawiki} are removed and that the Nouveau kernel module is [automatically
loaded](Kernel_module#Automatic_module_loading "automatically loaded"){.wikilink} at boot. After rebooting the power
draw should be lower.

```{=mediawiki}
{{Tip|See also [[kernel module]] for more details about kernel module loading and blacklisting.}}
```
```{=mediawiki}
{{Note|If after rebooting you have issues with brightness control and have multiple directories in {{ic|/sys/class/backlight}}, add line {{ic|acpi_backlight{{=}}native}}
```
to your [kernel parameters](kernel_parameters "kernel parameters"){.wikilink}.}}

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink}

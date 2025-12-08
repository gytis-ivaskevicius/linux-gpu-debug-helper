[es:PRIME](es:PRIME "wikilink") [ja:PRIME](ja:PRIME "wikilink") [zh-hans:PRIME](zh-hans:PRIME "wikilink")
`{{Related articles start}}`{=mediawiki} `{{Related|NVIDIA Optimus}}`{=mediawiki} `{{Related|External GPU}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

PRIME is a technology used to manage [hybrid graphics](hybrid_graphics "wikilink") found on recent desktops and laptops
([Optimus for NVIDIA](NVIDIA_Optimus "wikilink"), AMD Dynamic Switchable Graphics for Radeon). **PRIME GPU offloading**
and **Reverse PRIME** are an attempt to support muxless hybrid graphics in the Linux kernel.

## PRIME GPU offloading {#prime_gpu_offloading}

We want to render applications on the more powerful card and send the result to the card which has display connected.

The command `{{ic|xrandr --setprovideroffloadsink provider sink}}`{=mediawiki} can be used to make a render offload
provider send its output to the sink provider (the provider which has a display connected). The provider and sink
identifiers can be numeric (0x7d, 0x56) or a case-sensitive name (Intel, radeon).

```{=mediawiki}
{{Note|This setting is no longer necessary when using most default Xorg DDX (the {{ic|xf86-video-*}} or built-in modesetting) drivers from the official repositories, as they have DRI3 enabled by default and will therefore automatically make these assignments. Explicitly setting them again does no harm, though.}}
```
Example:

`$ xrandr --setprovideroffloadsink radeon Intel`

You may also use provider index instead of provider name:

`$ xrandr --setprovideroffloadsink 1 0`

```{=mediawiki}
{{Style|The following subsections are a messy, we name a subsection PRIME render offload without stating it's NVIDIA-centric, we shove generic PCI-E power management for the open source drivers inside, the merge flag from [[External GPU#Xorg rendered on iGPU, PRIME render offload to eGPU]] should probably be addressed on the other page, once this has cleaned up and we can link to here for the environment variables to use.}}
```
### For open source drivers - PRIME {#for_open_source_drivers___prime}

To use your discrete card for the applications who need it the most (for example games, 3D modellers\...), prepend the
`{{ic|1=DRI_PRIME=1}}`{=mediawiki} environment variable:

```{=mediawiki}
{{hc|1=$ DRI_PRIME=1 glxinfo {{!}}
```
grep \"OpenGL renderer\"\|2= OpenGL renderer string: Gallium 0.4 on AMD TURKS }}

```{=mediawiki}
{{Note|Instead of numerical value, you can also specify a PCI device name. Format used is similar to {{ic|/sys/bus/pci/devices/}}, but prefix with {{ic|pci-}} and replace semicolons and dots by underscores, e.g. {{ic|1=DRI_PRIME=pci-0000_01_00_0}}.}}
```
Other applications will still use the less power-hungry integrated card. These settings are lost once the X server
restarts, you may want to make a script and auto-run it at the startup of your desktop environment (alternatively, put
it in `{{ic|/etc/X11/xinit/xinitrc.d/}}`{=mediawiki}). This may reduce your battery life and increase heat though.

See
[Gentoo:AMDGPU#Identifying_which_graphics_card_is_in_use](Gentoo:AMDGPU#Identifying_which_graphics_card_is_in_use "wikilink")
for more information.

For `{{ic|DRI_PRIME}}`{=mediawiki} to work on Vulkan applications `{{Pkg|vulkan-mesa-layers}}`{=mediawiki} needs to be
installed, as well as `{{Pkg|lib32-vulkan-mesa-layers}}`{=mediawiki} for 32 bit applications.

### Note about Windows games {#note_about_windows_games}

```{=mediawiki}
{{Merge|DXVK|Gaming is not the primary topic of this page.}}
```
When running Windows DirectX games under Wine or Proton, you need to instruct [DXVK](DXVK "wikilink") directly using:

`DXVK_FILTER_DEVICE_NAME "[your preferred card name]"`

Get the card name from `{{ic|vulkaninfo}}`{=mediawiki}; DXVK uses substring match.

### PRIME render offload {#prime_render_offload}

NVIDIA driver since [version
435.17](https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/primerenderoffload.html) supports this method.
The modesetting, `{{Pkg|xf86-video-amdgpu}}`{=mediawiki} (450.57), and `{{Pkg|xf86-video-intel}}`{=mediawiki} (455.38)
are officially supported as iGPU drivers.

To run a program on the NVIDIA card you can use the `{{ic|prime-run}}`{=mediawiki} script provided by
`{{Pkg|nvidia-prime}}`{=mediawiki}:

`$ prime-run glxinfo | grep "OpenGL renderer"`\
`$ prime-run vulkaninfo`

#### PCI-Express Runtime D3 (RTD3) Power Management {#pci_express_runtime_d3_rtd3_power_management}

##### Open-source drivers {#open_source_drivers}

Kernel PCI power management turns off the GPU when not used with PRIME offloading or reverse PRIME. This feature is
supported by modesetting, `{{Pkg|xf86-video-amdgpu}}`{=mediawiki}, `{{Pkg|xf86-video-intel}}`{=mediawiki},
`{{Pkg|xf86-video-nouveau}}`{=mediawiki} drivers.

The following command can be used to check current
[1](https://docs.kernel.org/power/pci.html#native-pci-power-management) power state of each GPU:

`$ cat /sys/class/drm/card*/device/power_state`

##### NVIDIA

```{=mediawiki}
{{Note|1=<nowiki/>
* No configuration is generally needed for Ampere as this is enabled by default. For some Ampere users, udev rules may be necessary.
* Some users with hybrid graphics are reporting that their discrete NVIDIA Ampere GPUs are failing to remain in the D3Cold power state after upgrading to newer NVIDIA drivers (seemingly >525) [https://forums.developer.nvidia.com/t/nvidia-gpu-fails-to-power-off-prime-razer-blade-14-2022/250023].
* Some users with pre-Ampere card and broken D3 support on newer drivers reported a workaround to disable the GSP firmware with {{ic | 1=NVreg_EnableGpuFirmware=0}}[https://bbs.archlinux.org/viewtopic.php?pid=2182638].
}}
```
For Turing generation cards with Intel Coffee Lake or above CPUs as well as some Ryzen CPUs like the 5800H, it is
possible to fully [power down the GPU when not in
use](https://us.download.nvidia.com/XFree86/Linux-x86_64/575.64.05/README/dynamicpowermanagement.html).

```{=mediawiki}
{{Note|If you plan to use suspend or hibernate, see [[NVIDIA/Tips and tricks#Preserve video memory after suspend]].}}
```
The following [udev](udev "wikilink") rules are needed, as recommended by NVIDIA:

```{=mediawiki}
{{hc|/etc/udev/rules.d/80-nvidia-pm.rules|2=
# Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"

# Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
}}
```
Some users also [reported](https://aur.archlinux.org/packages/nvidia-prime-rtd3pm#comment-920182) that the following
additional lines are necessary too:

```{=mediawiki}
{{hc|/etc/udev/rules.d/80-nvidia-pm.rules|2=
# Enable runtime PM for NVIDIA VGA/3D controller devices on adding device
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
}}
```
Also, add the following [module parameters](module_parameter "wikilink"):

```{=mediawiki}
{{hc|/etc/modprobe.d/nvidia-pm.conf|2=
options nvidia "NVreg_DynamicPowerManagement=0x02"
}}
```
```{=mediawiki}
{{Note|For Ampere or later notebooks with supported configurations, you need to use {{ic|1=NVreg_DynamicPowerManagement=0x03}} instead.}}
```
Alternatively, you can install `{{AUR|nvidia-prime-rtd3pm}}`{=mediawiki} which provides these two configuration files.

After you setup the [udev](udev "wikilink") rules and the [module parameter](module_parameter "wikilink") either
manually or using the AUR package, you will need to restart your Laptop.

To check if the NVIDIA GPU is turned off you can use this command:

`$ cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status`

You will see either `{{ic|suspended}}`{=mediawiki} or `{{ic|running}}`{=mediawiki}, if `{{ic|suspended}}`{=mediawiki} is
displayed, the GPU is turned off. Now the power draw will be 0 Watts, making the battery last longer.

In some cases, such as the NVIDIA RTX A1000, none of the options above might be listed and instead the result will be
`{{ic|active}}`{=mediawiki}. This alone does not mean that the GPU is in the `{{ic|running}}`{=mediawiki} state. In this
case you can check the state using this command:

`$ cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_suspended_time`

While the GPU is in `{{ic|suspended}}`{=mediawiki} state, the counter will be incrementing every time you run the
command. When the GPU\'s state becomes `{{ic|running}}`{=mediawiki} it will stop incrementing.

If you notice that the `{{ic|runtime_suspended_time}}`{=mediawiki} is not incrementing, you can check your D3 Status
with this command.

`$ cat /proc/driver/nvidia/gpus/0000:01:00.0/power`

If it says `{{ic|Runtime D3 status: Not supported}}`{=mediawiki}, you may need to follow the steps [in this forum
post](https://bbs.archlinux.org/viewtopic.php?pid=2181317#p2181317) to disable. [One user
noted](https://bbs.archlinux.org/viewtopic.php?pid=2187680#p2187680) disabling the `{{ic|GpuFirmware}}`{=mediawiki} only
works on the closed source driver, not on `{{Pkg|nvidia-open}}`{=mediawiki}.

We also need to [enable](enable "wikilink") `{{ic|nvidia-persistenced.service}}`{=mediawiki} to avoid the kernel tearing
down the device state whenever the NVIDIA device resources are no longer in use.
[2](https://us.download.nvidia.com/XFree86/Linux-x86_64/550.54.14/README/nvidia-persistenced.html)

#### Configure applications to render using GPU {#configure_applications_to_render_using_gpu}

```{=mediawiki}
{{Merge|External GPU#Xorg rendered on iGPU, PRIME render offload to eGPU|Target section mentions these variables. Perhaps this can be merged with the target section to avoid duplication?}}
```
Even without enabling Dynamic Power Management, offload rendering of applications is required
[3](https://web.archive.org/web/20211203072304/https://jeansenvaars.wordpress.com/2021/12/02/endeavouros-hybrid-gpu-benchmarks/).

To run an application offloaded to the NVIDIA GPU with Dynamic Power Management enabled, add the following [environment
variables](environment_variables "wikilink"):
[4](https://download.nvidia.com/XFree86/Linux-x86_64/550.54.14/README/primerenderoffload.html)

`__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia `*`command`*

When using on a [Steam](Steam "wikilink") game, the launcher command line can be set to:

`__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%`

```{=mediawiki}
{{Note|The value of __NV_PRIME_RENDER_OFFLOAD may need to be set to 0 depending on the system. It is recommended to check which GPU is 0 and which is 1 since this variable specifies which GPU will be used.}}
```
#### Desktop environment integration {#desktop_environment_integration}

[Install](Install "wikilink") `{{Pkg|switcheroo-control}}`{=mediawiki} and [enable](enable "wikilink")
`{{ic|switcheroo-control.service}}`{=mediawiki}.

The GNOME, KDE Plasma, Cinnamon, COSMIC and Budgie desktop environments will respect the
`{{ic|PrefersNonDefaultGPU}}`{=mediawiki} property in the [desktop entry](desktop_entry "wikilink"), and automatically
launch apps on the specified GPU.

Alternatively, on GNOME and Cinnamon, you can launch applications with GPU by right-clicking on the icon and choosing
*Launch using Discrete Graphics Card* or *Run with dedicated GPU*, respectively.

#### Troubleshooting

If you have `{{Pkg|bumblebee}}`{=mediawiki} installed, you should remove it because it blacklists the
`{{ic|nvidia_drm}}`{=mediawiki} driver which is required to load the NVIDIA driver by X server for offloading.

### PRIME synchronization {#prime_synchronization}

When using PRIME, the primary GPU renders the screen content / applications, and passes it to the secondary GPU for
display. Quoting [an NVIDIA thread](https://forums.developer.nvidia.com/t/prime-and-prime-synchronization/44423),
\"Traditional vsync can synchronize the rendering of the application with the copy into system memory, but there needs
to be an additional mechanism to synchronize the copy into system memory with the iGPU's display engine. Such a
mechanism would have to involve communication between the dGPU's and the iGPU's drivers, unlike traditional vsync.\"

This synchronization is achieved using PRIME sync. To check if PRIME synchronization is enabled for your display, check
the output of `{{ic|xrandr --prop}}`{=mediawiki}.

To enable it run:

`$ xrandr --output ``<output-name>`{=html}` --set "PRIME Synchronization" 1`

```{=mediawiki}
{{Note|
* A pre-requisite for PRIME synchronization with the NVIDIA driver is to [[NVIDIA#DRM kernel mode setting|enable modesetting]].
* PRIME synchronization is not available with the [[AMDGPU]] DDX driver ({{Pkg|xf86-video-amdgpu}}).
}}
```
## Reverse PRIME {#reverse_prime}

```{=mediawiki}
{{Expansion|Missing info about configuring Intel + AMD reverse prime for both open and closed amdgpu drivers}}
```
```{=mediawiki}
{{Note|
* Reverse PRIME is not supported for AMDGPU + NVIDIA on NVIDIA driver prior to 470 beta. See [https://forums.developer.nvidia.com/t/hp-omen-15-ryzen-4600h-nvidia-1660ti-no-display-over-hdmi/165265/2] for more details.
* Currently when only external display is enabled, you will only get 1 FPS. See [https://gitlab.freedesktop.org/xorg/xserver/-/issues/1028] for more details, but a workaround is most likely to export "LIBGL_DRI3_DISABLE{{=}}
```
true\" }}

If the second GPU has outputs that are not accessible by the primary GPU, you can use **Reverse PRIME** to make use of
them. This will involve using the primary GPU to render the images, and then pass them off to the second GPU.

It may work out of the box, however if not, please go through the following steps.

### Configuration

```{=mediawiki}
{{Style|First half of the section has Intel + NVIDIA, the second half has Intel + Radeon. Identifying the GPU bus IDs should be delegated to a general section.}}
```
First, identify integrated GPU BusID `{{hc|lspci -d ::03xx|
00:02.0 VGA compatible controller: Intel Corporation UHD Graphics 630 (Mobile)
01:00.0 VGA compatible controller: NVIDIA Corporation TU117M [GeForce GTX 1650 Mobile / Max-Q] (rev a1)
}}`{=mediawiki}

In the above example Intel card has 00:02.0 which translates to PCI:0:2:0.

Set up your xorg.conf as follows and adjust BusID. `{{hc|/etc/X11/xorg.conf|
Section "ServerLayout"
        Identifier "layout"
        Screen 0 "intel"
        Inactive "nvidia"
        Option "AllowNVIDIAGPUScreens"
EndSection

Section "Device"
        Identifier "nvidia"
        Driver "nvidia"
EndSection

Section "Screen"
        Identifier "nvidia"
        Device "nvidia"
EndSection

Section "Device"
        Identifier "intel"
        Driver "modesetting"
        BusID "PCI:0:2:0"
EndSection

Section "Screen"
        Identifier "intel"
        Device "intel"
EndSection
}}`{=mediawiki}

The command `{{ic|xrandr --setprovideroutputsource provider source}}`{=mediawiki} sets the provider as output for the
source. For example:

`$ xrandr --setprovideroutputsource radeon Intel`

When this is done, the discrete card\'s outputs should be available in xrandr, and you could do something like:

`$ xrandr --output HDMI-1 --auto --above LVDS1`

to configure both internal as well as external displays.

### Known issues {#known_issues}

If after reboot you only have one provider, it might be because when Xorg starts, the `{{ic|nvidia}}`{=mediawiki} module
is not loaded yet. You need to enable early module loading. See [NVIDIA#Early loading](NVIDIA#Early_loading "wikilink")
for details.

## Troubleshooting {#troubleshooting_1}

```{=mediawiki}
{{Accuracy|No sources to motivate the workarounds in this section}}
```
### XRandR specifies only 1 output provider {#xrandr_specifies_only_1_output_provider}

Delete/move /etc/X11/xorg.conf file and any other files relating to GPUs in /etc/X11/xorg.conf.d/. Restart the X server
after this change.

If the video driver is blacklisted in `{{ic|/etc/modprobe.d/}}`{=mediawiki} or
`{{ic|/usr/lib/modprobe.d/}}`{=mediawiki}, load the module and restart X. This may be the case if you use the bbswitch
module for NVIDIA GPUs.

Another possible problem is that Xorg might try to automatically assign monitors to your second GPU. Check the logs:

```{=mediawiki}
{{hc|<nowiki>$ grep "No modes" ~/.local/share/xorg/Xorg.0.log</nowiki>|
AMDGPU(0): No modes.
}}
```
To solve this add the ServerLayout section with inactive device to your xorg.conf:

```{=mediawiki}
{{hc|<nowiki>/etc/X11/xorg.conf</nowiki>|
Section "ServerLayout"
  Identifier     "X.org Configured"
  Screen      0  "Screen0" 0 0 # Screen for your primary GPU
  Inactive       "Card1"       # Device for your second GPU
EndSection
}}
```
### When an application is rendered with the discrete card, it only renders a black screen {#when_an_application_is_rendered_with_the_discrete_card_it_only_renders_a_black_screen}

In some cases PRIME needs a composite manager to properly work. If your window manager does not handle compositing, you
can use a [compositor](Xorg#List_of_composite_managers "wikilink") on top of it.

If you use Xfce, you can go to *Menu \> Settings \> Window Manager Tweaks \> Compositor* and enable compositing, then
try again your application.

#### Black screen with GL-based compositors {#black_screen_with_gl_based_compositors}

Currently there are issues with GL-based compositors and PRIME offloading. While Xrender-based compositors (xcompmgr,
xfwm, compton\'s default backend, cairo-compmgr, and a few others) will work without issue, GL-based compositors
(Mutter/muffin, Compiz, compton with GLX backend, Kwin\'s OpenGL backend, etc) will initially show a black screen, as if
there was no compositor running. While you can force an image to appear by resizing the offloaded window, this is not a
practical solution as it will not work for things such as full screen Wine applications. This means that desktop
environments such as GNOME3 and Cinnamon have issues with using PRIME offloading.

Additionally if you are using an Intel IGP you might be able to fix the GL Compositing issue by running the IGP as UXA
instead of SNA, however this may cause issues with the offloading process (ie,
`{{ic|xrandr --listproviders}}`{=mediawiki} may not list the discrete GPU).

For details see [FDO Bug #69101](https://bugs.freedesktop.org/show_bug.cgi?id=69101).

One other way to approach this issue is by enabling DRI3 in the Intel driver. See the below issue for a sample
configuration.

##### GNOME

You may find that [disabling fullscreen
undirect](GNOME/Troubleshooting#Tear-free_video_with_Intel_HD_Graphics "wikilink") allows PRIME offloading to work
correctly for full-screen applications.

### Kernel crash/oops when using PRIME and switching windows/workspaces {#kernel_crashoops_when_using_prime_and_switching_windowsworkspaces}

```{=mediawiki}
{{Note|This has been tested on a system with Intel+AMD}}
```
Using DRI3 WITH a configuration file for the integrated card seems to fix this issue.

To enable DRI3, you need to create a configuration for the integrated card adding the DRI3 option:

`Section "Device"`\
`    Identifier "Intel Graphics"`\
`    Driver "intel"`\
`    Option "DRI" "3"`\
`EndSection`

After this you can use `{{ic|1=DRI_PRIME=1}}`{=mediawiki} WITHOUT having to run
`{{ic|xrandr --setprovideroffloadsink radeon Intel}}`{=mediawiki} as DRI3 will take care of the offloading.

### Glitches/Ghosting synchronization problem on second monitor when using reverse PRIME {#glitchesghosting_synchronization_problem_on_second_monitor_when_using_reverse_prime}

This problem can affect users when not using a [composite manager](composite_manager "wikilink"), such as with
[i3](i3 "wikilink"). [5](https://bugs.freedesktop.org/show_bug.cgi?id=75579)

If you experience this problem under Gnome, then a possible fix is to set some environment variables in
`{{ic|/etc/environment}}`{=mediawiki} [6](https://bbs.archlinux.org/viewtopic.php?id=177925)

`CLUTTER_PAINT=disable-clipped-redraws:disable-culling`\
`CLUTTER_VBLANK=True`

### Error \"radeon: Failed to allocate virtual address for buffer:\" when launching GL application {#error_radeon_failed_to_allocate_virtual_address_for_buffer_when_launching_gl_application}

This error is given when the power management in the kernel driver is running. You can overcome this error by appending
`{{ic|1=radeon.runpm=0}}`{=mediawiki} to the kernel parameters in the [boot loader](boot_loader "wikilink").

### Constant hangs/freezes with Vulkan applications/games using VSync with closed-source drivers and reverse PRIME {#constant_hangsfreezes_with_vulkan_applicationsgames_using_vsync_with_closed_source_drivers_and_reverse_prime}

Some Vulkan applications (particularly ones using VK_PRESENT_MODE_FIFO_KHR and/or VK_PRESENT_MODE_FIFO_RELAXED_KHR,
including Windows games ran with DXVK) will cause the GPU to lockup constantly (\~5-10 seconds freezed, \~1 second
working
fine)[7](https://devtalk.nvidia.com/default/topic/1044496/linux/hangs-freezes-when-vulkan-v-sync-vk_present_mode_fifo_khr-is-enabled/)
when ran on a system using **reverse PRIME**.

A GPU lockup will render any input unusable (this includes switching TTYs and using SysRq functions).

There is no known fix for this NVIDIA bug, but a few workarounds exist:

-   Turning Vsync off (not possible for some applications)
-   Turning PRIME
    Synchronization[8](https://devtalk.nvidia.com/default/topic/957814/linux/prime-and-prime-synchronization/) off (will
    introduce screen tearing):

`xrandr --output HDMI-0 --set "PRIME Synchronization" 0 #replace HDMI-0 with your xrandr output ID`

You can verify if your configuration is affected by the issue simply by running `{{ic|vkcube}}`{=mediawiki} from the
`{{Pkg|vulkan-tools}}`{=mediawiki} package.

### Some programs have a delay when opening under Wayland {#some_programs_have_a_delay_when_opening_under_wayland}

If you have RTD3 working (from [#NVIDIA](#NVIDIA "wikilink")), when using Wayland you will experience some delay when
some programs open. Depending on the application, this can be caused by two sources: Vulkan, or OpenGL, but the
mechanism causing the delay is the same. Both will have to determine which device to defer to. This decision is made
based on configuration files. For OpenGL, the configurations are located in
`{{ic|/usr/share/glvnd/egl_vendor.d/}}`{=mediawiki}, while for Vulkan they are located in
`{{ic|/usr/share/vulkan/icd.d/}}`{=mediawiki}. The actual delay itself is caused by the determination of a candidate
requiring iteration over all potential rendering configurations. Even if the preferred configuration appears before the
other (i.e. has a lower number, igpu before external), it will still iterate through all available options. While trying
the configuration for the sleeping (external) GPU, it is woken up (which it takes \~1 second or more) before deferring
to open the program, wasting time and battery life. This is an NVIDIA driver problem. [More details
here.](https://bbs.archlinux.org/viewtopic.php?pid=2094847#p2094847)

One solution is to make sure the dedicated GPU is not started is to make sure it is not iterated. This can be done by
explicitly setting the configurations as environment variables. These can be passed either directly when running a
program, or set globally (for example in your `{{ic|/etc/environment}}`{=mediawiki} file). Do note that setting it
globally requires you to un-set this variable (or set it to the nvidia files respectively) when deliberately trying to
run a program with the external GPU.

```{=mediawiki}
{{hc|<nowiki>/etc/environment</nowiki>|2=
__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json
__GLX_VENDOR_LIBRARY_NAME=mesa
}}
```
### Error when running Wine games with DXVK {#error_when_running_wine_games_with_dxvk}

When using PRIME offload, encountering the `{{ic|Major opcode of failed request: 156 (NV-GLX)}}`{=mediawiki} is a known
problem. The only known workaround is to start X session [entirely on NVIDIA
GPU](NVIDIA_Optimus#Use_NVIDIA_graphics_only "wikilink"). A user friendly way to switching between NVIDIA only and PRIME
offload method is the [optimus-manager](NVIDIA_Optimus#Using_optimus-manager "wikilink") utility or write some
automation scripts yourself.

### Vulkan/OpenGL applications segfault on Wayland {#vulkanopengl_applications_segfault_on_wayland}

```{=mediawiki}
{{ic|VK_KHR_wayland_surface}}
```
requires Kernel modesetting. If you are using a Wayland compositor and unable to start applications on the dGPU without
having to force them to run under Xwayland, make sure modesetting is enabled.

This means removing `{{ic|nvidia_drm.modeset{{=}}`{=mediawiki}0}} from Kernel parameters if present.

## See also {#see_also}

-   [Nouveau Optimus](https://wiki.freedesktop.org/nouveau/Optimus/)

[Category:Graphics](Category:Graphics "wikilink")

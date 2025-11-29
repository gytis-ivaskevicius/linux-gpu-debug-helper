[de:Nouveau](de:Nouveau "de:Nouveau"){.wikilink} [es:Nouveau](es:Nouveau "es:Nouveau"){.wikilink}
[fr:Nouveau](fr:Nouveau "fr:Nouveau"){.wikilink} [ja:Nouveau](ja:Nouveau "ja:Nouveau"){.wikilink}
[ru:Nouveau](ru:Nouveau "ru:Nouveau"){.wikilink} [uk:Nouveau](uk:Nouveau "uk:Nouveau"){.wikilink}
[zh-hans:Nouveau](zh-hans:Nouveau "zh-hans:Nouveau"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|NVIDIA}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki} `{{Related|Bumblebee}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

This article covers the reverse-engineered open-source [Nouveau](https://nouveau.freedesktop.org/) driver for NVIDIA
graphics cards. For information about the upstream proprietary `{{Pkg|nvidia}}`{=mediawiki} and open-source
`{{Pkg|nvidia-open}}`{=mediawiki} drivers, see [NVIDIA](NVIDIA "NVIDIA"){.wikilink}.

Find your card\'s [code name](https://nouveau.freedesktop.org/wiki/CodeNames) (a more detailed list is available on
[Wikipedia](Wikipedia:Comparison_of_Nvidia_Graphics_Processing_Units "Wikipedia"){.wikilink}), and compare it with the
[feature matrix](https://nouveau.freedesktop.org/wiki/FeatureMatrix/) for supported features.

## Installation

```{=mediawiki}
{{Out of date|Recent cards (GTX 16xx and all RTX cards) will also need the {{Pkg|vulkan-nouveau}} package.}}
```
[Install](Install "Install"){.wikilink} the `{{Pkg|mesa}}`{=mediawiki} package, which provides the DRI driver for 3D
acceleration.

- For 32-bit application support, also install the `{{Pkg|lib32-mesa}}`{=mediawiki} package from the
  [multilib](multilib "multilib"){.wikilink} repository.
- For the DDX driver (which provides 2D acceleration in [Xorg](Xorg "Xorg"){.wikilink}),
  [install](install "install"){.wikilink} the `{{Pkg|xf86-video-nouveau}}`{=mediawiki} package.

```{=mediawiki}
{{Note|1=It has [https://bugs.freedesktop.org/show_bug.cgi?id=94844#c3 been suggested] that not installing the {{Pkg|xf86-video-nouveau}} driver, and instead falling back on the modesetting driver for [https://nouveau.freedesktop.org/CodeNames.html#NV50 NV50 (G80)] and newer hardware is beneficial. For example see a [https://bbs.archlinux.org/viewtopic.php?id=263498 user report] from 2021.}}
```
See also [Hardware video acceleration](Hardware_video_acceleration "Hardware video acceleration"){.wikilink}.

### Using the Mesa NVK Vulkan Driver {#using_the_mesa_nvk_vulkan_driver}

```{=mediawiki}
{{Warning|This driver is still a work in progress and as such, regressions should be expected. Some stuff (mostly games) that worked on the open-source and proprietary drivers will probably not work as well (or even at all) using NVK. If playing games is an important workload then you should probably avoid using NVK until it matures a little.}}
```
[NVK](https://docs.mesa3d.org/drivers/nvk.html) is an open-source Vulkan driver based on Nouveau for
[Kepler](https://nouveau.freedesktop.org/CodeNames.html#NVE0) and newer NVIDIA cards.

Using NVK requires [Kernel](Kernel "Kernel"){.wikilink} version 6.7 or newer and `{{Pkg|mesa}}`{=mediawiki} version 24.1
or newer.

Before enabling NVK you must [uninstall](uninstall "uninstall"){.wikilink} any of the following packages (and/or their
`{{ic|lib32}}`{=mediawiki} and [DKMS](DKMS "DKMS"){.wikilink} variants):

- ```{=mediawiki}
  {{Pkg|nvidia}}
  ```
  , `{{Pkg|nvidia-open}}`{=mediawiki}, `{{Pkg|nvidia-lts}}`{=mediawiki}, `{{AUR|nvidia-beta}}`{=mediawiki}

- ```{=mediawiki}
  {{Pkg|nvidia-settings}}
  ```
  , `{{Pkg|nvidia-utils}}`{=mediawiki}

- ```{=mediawiki}
  {{Pkg|egl-wayland}}
  ```

If you are using a hybrid laptop or a dual GPU system ensure you do not have Nouveau blacklisted by a GPU manager in
`{{ic|/etc/modprobe.d/}}`{=mediawiki}.

```{=mediawiki}
{{Note|You should also probably [[uninstall]] any GPU managers on your system as most of them work by blacklisting modules which might interfere with NVK.}}
```
Then [install](install "install"){.wikilink} `{{Pkg|vulkan-nouveau}}`{=mediawiki} (and if it is required,
`{{Pkg|lib32-vulkan-nouveau}}`{=mediawiki}).

Add `{{ic|1=nouveau.config=NvGspRm=1}}`{=mediawiki} as a [kernel
parameter](kernel_parameter "kernel parameter"){.wikilink} if required. It is enabled by default on Ada Lovelace and
newer cards. See note in the [documentation](https://nouveau.freedesktop.org/PowerManagement.html).

Finally reboot your system.

To verify everything is working `{{ic|vulkaninfo}}`{=mediawiki} from `{{Pkg|vulkan-tools}}`{=mediawiki} can be used. It
should report the NVIDIA GPU in your system as using the NVK driver.

```{=mediawiki}
{{hc|$ vulkaninfo|2=
...
GPU id : 0 (NVIDIA GeForce RTX 3050 Ti Laptop GPU ('''NVK GA107''')):
       Surface type = VK_KHR_wayland_surface
       Formats: count = 8
...
}}
```
## Loading

The Nouveau kernel module should load automatically on system boot. If it does not happen, then:

- Make sure you do **not** have `{{ic|nomodeset}}`{=mediawiki} or `{{ic|1=vga=}}`{=mediawiki} as a [kernel
  parameter](kernel_parameter "kernel parameter"){.wikilink}, since Nouveau requires kernel mode-setting.
- Also, check that you do not have Nouveau disabled using any modprobe blacklisting technique within
  `{{ic|/etc/modprobe.d/}}`{=mediawiki} or `{{ic|/usr/lib/modprobe.d/}}`{=mediawiki}.
- If everything above still fails to load nouveau, check [dmesg](dmesg "dmesg"){.wikilink} for an opcode error. Add
  `{{ic|1=nouveau.config=NvBios=PRAMIN}}`{=mediawiki} to your [kernel
  parameters](kernel_parameters "kernel parameters"){.wikilink} to prevent module
  unloading.[1](https://nouveau.freedesktop.org/wiki/TroubleShooting/#index10h3)
- Check if `{{ic|/etc/X11/xorg.conf}}`{=mediawiki} or any file in `{{ic|/etc/X11/xorg.conf.d/}}`{=mediawiki} exists and
  is referencing the `{{ic|nvidia}}`{=mediawiki} driver. It is probably a good idea to rename the file.

### Early KMS {#early_kms}

[Kernel mode setting](Kernel_mode_setting "Kernel mode setting"){.wikilink} (KMS) is supported by the
`{{ic|nouveau}}`{=mediawiki} driver and is enabled early since [mkinitcpio](mkinitcpio "mkinitcpio"){.wikilink} v32, as
the `{{ic|kms}}`{=mediawiki} hook is included by default. For other setups, see [Kernel mode setting#Early KMS
start](Kernel_mode_setting#Early_KMS_start "Kernel mode setting#Early KMS start"){.wikilink} for instructions on how to
enable KMS as soon as possible at the boot process.

```{=mediawiki}
{{Tip|If you have problems with the resolution, check [[Kernel mode setting#Forcing modes and EDID]].}}
```
## Tips and tricks {#tips_and_tricks}

### Keep NVIDIA driver installed {#keep_nvidia_driver_installed}

```{=mediawiki}
{{Accuracy|Editing files in {{ic|/usr/lib/}} is not persistent, they will be overwritten when a package gets upgraded.}}
```
If you want to keep the proprietary NVIDIA driver installed (and are not using OpenGL), but want to use the Nouveau
driver, follow the steps below:

Comment out nouveau blacklisting in `{{ic|/etc/modprobe.d/nouveau_blacklist.conf}}`{=mediawiki} or
`{{ic|/usr/lib/modprobe.d/nvidia-utils.conf}}`{=mediawiki}, modifying it as follows:

`#blacklist nouveau`

You may also need to comment out other configuration files that prioritize the proprietary driver, e.g.
[systemd-modules-load](https://man.archlinux.org/man/systemd-modules-load.service.8.en)\'s
`{{ic|/usr/lib/modules-load.d/nvidia-utils.conf}}`{=mediawiki} and [udev](udev "udev"){.wikilink}\'s
`{{ic|/usr/lib/udev/rules.d/60-nvidia.rules}}`{=mediawiki}. Check what files the driver has installed with the following
command:

`$ pacman -Ql nvidia-utils | grep conf`

Then, ensure that you have disabled `{{ic|nvidia-}}`{=mediawiki}-prefixed services that might call
`{{ic|nvidia-modprobe}}`{=mediawiki} to load the module on boot. For example:

`$ systemctl status nvidia-persistenced.service`

And if you are using [Xorg](Xorg "Xorg"){.wikilink}, tell Xorg to load nouveau instead of NVIDIA:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-nouveau.conf|
Section "Device"
    Identifier "Nvidia card"
    Driver "nouveau"
EndSection
}}
```
Reboot to make effects. And check that it loaded fine by looking at kernel messages:

`# dmesg`

### Installing the latest development packages {#installing_the_latest_development_packages}

To get the latest Nouveau improvements

- ```{=mediawiki}
  {{AUR|linux-git}}
  ```

- ```{=mediawiki}
  {{AUR|libdrm-git}}
  ```

- ```{=mediawiki}
  {{AUR|lib32-libdrm-git}}
  ```

- ```{=mediawiki}
  {{AUR|lib32-mesa-git}}
  ```

- ```{=mediawiki}
  {{AUR|mesa-git}}
  ```

- ```{=mediawiki}
  {{AUR|xf86-video-nouveau-git}}
  ```

```{=mediawiki}
{{Note|As mentioned in [[#Installation]], installing xf86-video-nouveau is no longer required nor recommended and in most cases, your GPU will function better without it installed.}}
```
### Dual head {#dual_head}

Multiple monitors can be setup with [RandR](Wikipedia:RandR "RandR"){.wikilink}, see
[Multihead#RandR](Multihead#RandR "Multihead#RandR"){.wikilink}.

### Setting console resolution {#setting_console_resolution}

You can pass the resolution to nouveau with the `{{ic|1=video=}}`{=mediawiki} kernel line option (see
[KMS](KMS "KMS"){.wikilink}).

### Power management {#power_management}

The lack of proper power management in the nouveau driver is one of the most important causes of performance issues,
since most cards will remain in their lower power state with lower clocks during their use. Experimental support for GPU
reclocking is available for some cards (see the [Nouveau PowerManagement
page](https://nouveau.freedesktop.org/wiki/PowerManagement)) and since kernel 4.5 can be controlled through a debugfs
interface located at `{{ic|/sys/kernel/debug/dri/*/pstate}}`{=mediawiki}.

```{=mediawiki}
{{Note|As [https://gitlab.freedesktop.org/mesa/mesa/-/issues/10933#note_2357592 upstream explained], this debugfs interface is not available on Turing and later cards, but only for Kepler and earlier.}}
```
For example, to check the available power states and the current setting for the first card in your system, run:

`# cat /sys/kernel/debug/dri/0/pstate`

It is also possible to manually set/force a certain power state by writing to said interface:

`# echo `*`pstate`*` > /sys/kernel/debug/dri/0/pstate`

```{=mediawiki}
{{Warning|The support for reclocking is highly experimental. Manually setting the power state may hang your system, cause corruption or overheat your card.}}
```
#### Fan control {#fan_control}

If it is implemented for your card, you can configure fan control via `{{ic|/sys}}`{=mediawiki}.

`$ find /sys -name pwm1_enable`\
`/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/hwmon/hwmon1/pwm1_enable`\
`$ readlink /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/driver`\
`../../../../bus/pci/drivers/nouveau`

```{=mediawiki}
{{ic|pwm1_enable}}
```
can be set to 0, 1 or 2 meaning NONE, MANUAL and AUTO fan control. If set to manual fan control, you can set
`{{ic|pwm1}}`{=mediawiki} manually, for example to 40 for 40%.

```{=mediawiki}
{{Warning|Use at your own risk! Do not overheat your card!}}
```
You can also set it by an [udev](udev "udev"){.wikilink} rule:

```{=mediawiki}
{{hc|/etc/udev/rules.d/50-nouveau-hwmon.rules|2=
ACTION=="add", SUBSYSTEM=="hwmon", DRIVERS=="nouveau", ATTR{pwm1_enable}="2"
}}
```
Sources:

- <https://floppym.blogspot.de/2013/07/fan-control-with-nouveau.html>
- <https://web.archive.org/web/20141031191559/https://kalgan.cc/blog/posts/Controlling_nVidia_cards_fans_with_nouveau_in_Debian/>

### Optimus

You have two solutions to use [Optimus](Optimus "Optimus"){.wikilink} on a laptop (aka hybrid graphics, when you have
two GPUs on your laptop): [bumblebee](bumblebee "bumblebee"){.wikilink} and [PRIME](PRIME "PRIME"){.wikilink}

### Vertical synchronization {#vertical_synchronization}

```{=mediawiki}
{{Out of date|{{ic|xr_glx_hybrid}} is a legacy backend (and seems to be broken).}}
```
Xorg compositors are prone to show issues with Nouveau. Unlike most of them, [Picom](Picom "Picom"){.wikilink} offers
lots of options to tweak for a smoother and tearing free result. A configuration which is expected to deliver a good
result would be the following:

`$ picom -b --unredir-if-possible --backend xr_glx_hybrid --vsync --use-damage --glx-no-stencil`

```{=mediawiki}
{{Tip|Do not forget to turn off compositing of your DE's window manager like KWin when using a different compositor.}}
```
## Troubleshooting

Add `{{ic|1=drm.debug=14}}`{=mediawiki} and `{{ic|1=log_buf_len=16M}}`{=mediawiki} to your [kernel
parameters](kernel_parameters "kernel parameters"){.wikilink} to turn on video debugging:

Create verbose Xorg log:

`$ startx -- -logverbose 9 -verbose 9`

View loaded video module parameters and values:

`$ modinfo -p video`

### Disable MSI {#disable_msi}

If you are still having problems loading the module or starting the X server, append
`{{ic|1=nouveau.config=NvMSI=0}}`{=mediawiki} to your [Kernel
parameters](Kernel_parameters "Kernel parameters"){.wikilink}.

Source: <https://bugs.freedesktop.org/show_bug.cgi?id=78441>

### Phantom output issue {#phantom_output_issue}

It is possible for the nouveau driver to detect \"phantom\" outputs. For example, both VGA-1 and LVDS-1 are shown as
connected but only LVDS-1 is present.

This causes display problems and/or prevent suspending on lid closure.

#### Kernel parameters {#kernel_parameters}

The problem can be overcome by disabling the phantom output (VGA-1 in the examples given) with [Kernel
parameters](Kernel_parameters "Kernel parameters"){.wikilink}:

`video=VGA-1:d`

Where `{{ic|d}}`{=mediawiki} = disable.

The nouveau kernel module also has an option to disable TV-out detection
[2](https://nouveau.freedesktop.org/wiki/KernelModuleParameters/#tv_disable):

`tv_disable=1`

#### Xorg configuration {#xorg_configuration}

The phantom output can be disabled in [Xorg](Xorg "Xorg"){.wikilink} by adding the following to
`{{ic|/etc/X11/xorg.conf.d/20-nouveau.conf}}`{=mediawiki}:

`Section "Monitor"`\
`Identifier "VGA-1"`\
`Option "Ignore" "1"`\
`EndSection`

Source:
<https://web.archive.org/web/20170118202740/http://gentoo-en.vfose.ru/wiki/Nouveau#Phantom_and_unpopulated_output_connector_issues>

#### Xrandr

[Xrandr](Xrandr "Xrandr"){.wikilink} can disable the output:

`$ xrandr --output VGA-1 --off`

This can be added to the [xinit](xinit "xinit"){.wikilink} configuration.

### Random lockups with kernel error messages {#random_lockups_with_kernel_error_messages}

Specific NVIDIA chips with Nouveau may give random system lockups and more commonly throw many kernel messages, seen
with *dmesg*. Try adding the `{{ic|1=nouveau.noaccel=1}}`{=mediawiki} [kernel
parameter](kernel_parameter "kernel parameter"){.wikilink}. See [Fedora:Common kernel problems#Systems with nVidia
adapters using the nouveau driver lock up
randomly](Fedora:Common_kernel_problems#Systems_with_nVidia_adapters_using_the_nouveau_driver_lock_up_randomly "Fedora:Common kernel problems#Systems with nVidia adapters using the nouveau driver lock up randomly"){.wikilink}
for more information.

Note that using `{{ic|1=nouveau.noaccel=1}}`{=mediawiki} kernel parameter might cause [\~%100 CPU usage on
Wayland](https://bugs.kde.org/show_bug.cgi?id=485429) when there is no iGPU or [disabled iGPU by
factory](https://h30434.www3.hp.com/t5/Notebook-Video-Display-and-Touch/Integrated-Intel-Graphics-GPU-disabled-by-factory/td-p/7178220).
You can switch to X11 session or prefer adding `{{ic|1=LIBGL_ALWAYS_SOFTWARE=1}}`{=mediawiki} [environment
variable](environment_variable "environment variable"){.wikilink} for wayland to disable OpenGL hardware acceleration
completely.

As an alternative, you can also use the `{{ic|1=QT_XCB_FORCE_SOFTWARE_OPENGL=1}}`{=mediawiki} [environment
variable](environment_variable "environment variable"){.wikilink} to disable OpenGL acceleration in Qt applications.

### Pointer to flat panel table invalid {#pointer_to_flat_panel_table_invalid}

NVIDIA graphics cards with recent chipsets can cause startup issues - this includes X11 being unable to start and
*lspci* freezing
indefinitely[3](https://bugzilla.redhat.com/show_bug.cgi?id=1425253)[4](https://bbs.archlinux.org/viewtopic.php?id=192532)[5](https://stackoverflow.com/questions/28062458/nouveau-error-while-booting-arch)[6](https://bbs.archlinux.org/viewtopic.php?id=207602)[7](https://unix.stackexchange.com/questions/207895/how-do-i-install-antergos-with-a-gtx-970).

This can break live distributions/installation media. This can be detected either by running *lspci*, or checking the
systemd [journal](journal "journal"){.wikilink} for the error:

`nouveau E[     DRM]Pointer to flat panel table invalid`

The system may start if the Nouveau driver is disabled by passing the following [kernel
parameters](kernel_parameters "kernel parameters"){.wikilink}:

`modprobe.blacklist=nouveau`

The Nouveau driver can then be loaded using

`# modprobe nouveau`

The system should then function correctly. If you have another NVIDIA graphics card, or just want to be safe, you can
disable the offending card using:

`# echo 1 > /sys/bus/pci/devices/`*`card-device-id`*`/remove`

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink} [Category:X
server](Category:X_server "Category:X server"){.wikilink}

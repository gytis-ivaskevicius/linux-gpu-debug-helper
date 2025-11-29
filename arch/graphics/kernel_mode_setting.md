[de:KMS](de:KMS "de:KMS"){.wikilink} [es:Kernel mode
setting](es:Kernel_mode_setting "es:Kernel mode setting"){.wikilink} [fr:Kernel mode
setting](fr:Kernel_mode_setting "fr:Kernel mode setting"){.wikilink}
[ja:カーネルモード設定](ja:カーネルモード設定 "ja:カーネルモード設定"){.wikilink} [ru:Kernel mode
setting](ru:Kernel_mode_setting "ru:Kernel mode setting"){.wikilink} [zh-hans:Kernel mode
setting](zh-hans:Kernel_mode_setting "zh-hans:Kernel mode setting"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|ATI}}`{=mediawiki} `{{Related|Intel graphics}}`{=mediawiki} `{{Related|Nouveau}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

```{=mediawiki}
{{Expansion|KMS and rootless X (1.16), see [[Talk:Kernel mode setting]] and [[Xorg#Rootless Xorg]].}}
```
Kernel [Mode Setting](Wikipedia:Mode-setting "Mode Setting"){.wikilink} (KMS) is a method for setting display resolution
and depth in the kernel space rather than user space.

The Linux kernel\'s implementation of KMS enables native resolution in the framebuffer and allows for instant console
(tty) switching. KMS also enables newer technologies (such as
[DRI2](wikipedia:Direct_Rendering_Infrastructure#DRI2 "DRI2"){.wikilink}) which will help reduce artifacts and increase
3D performance, even kernel space power-saving.

```{=mediawiki}
{{Note|The proprietary [[NVIDIA]] driver (since 364.12) also implements kernel mode-setting, but it does not use the built-in kernel implementation and a fbdev driver for the high-resolution console is only present as an opt-in experimental feature (since 545.29)}}
```
## Background

Previously, setting up the video card was the job of the X server. Because of this, it was not easily possible to have
fancy graphics in [virtual consoles](virtual_console "virtual console"){.wikilink}. Also, each time a switch from X to a
virtual console was made (`{{ic|Ctrl+Alt+F2}}`{=mediawiki}), the server had to give control over the video card to the
kernel, which was slow and caused flickering. The same \"painful\" process happened when the control was given back to
the X server (`{{ic|Alt+F7}}`{=mediawiki} when X runs in VT7).

With Kernel Mode Setting (KMS), the kernel is now able to set the mode of the video card. This makes fancy graphics
during bootup, virtual console and X fast switching possible, among other things.

## Configuration

At first, note that for *any* method you use, you should *always* disable:

- Any `{{ic|<nowiki>vga=</nowiki>}}`{=mediawiki} options in your [boot loader](boot_loader "boot loader"){.wikilink} as
  these will conflict with the native resolution enabled by KMS.
- Any `{{ic|<nowiki>video=</nowiki>}}`{=mediawiki} lines that enable a framebuffer that conflicts with the driver.
- Any other framebuffer drivers (such as [uvesafb](uvesafb "uvesafb"){.wikilink}).

```{=mediawiki}
{{Out of date|Arch [[Kernel#Officially supported kernels|officially supported kernels]] have ''simpledrm'' KMS driver inbuilt [https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/blob/88ea405f03782d77b9cb30f54efa1f52280e53aa/config#L6955] for years now. Which means Arch users '''always''' have early KMS start. So this section is more about "when ''simpledrm'' transfers control to another driver".}}
```
```{=mediawiki}
{{Expansion|Mention ''simpledrm'' and its ability to work as a generic graphics driver.}}
```
### Late KMS start {#late_kms_start}

[Intel](Intel "Intel"){.wikilink}, [Nouveau](Nouveau "Nouveau"){.wikilink}, [ATI](ATI "ATI"){.wikilink} and
[AMDGPU](AMDGPU "AMDGPU"){.wikilink} drivers already enable KMS automatically for all chipsets, so you do not need to do
anything.

The proprietary [NVIDIA](NVIDIA "NVIDIA"){.wikilink} driver supports KMS (since 364.12), which has to be [manually
enabled](NVIDIA#DRM_kernel_mode_setting "manually enabled"){.wikilink}.

### Early KMS start {#early_kms_start}

```{=mediawiki}
{{Tip|If you encounter problems with the resolution, you can check whether [[#Forcing modes and EDID|enforcing the mode]] helps.}}
```
KMS is typically initialized after the [initramfs stage](Arch_boot_process#initramfs "initramfs stage"){.wikilink}.
However, it is possible to enable KMS already during the initramfs stage. Add the required module for the [video
driver](Xorg#Driver_installation "video driver"){.wikilink} to the initramfs configuration file:

- ```{=mediawiki}
  {{ic|amdgpu}}
  ```
  for [AMDGPU](AMDGPU "AMDGPU"){.wikilink}, or `{{ic|radeon}}`{=mediawiki} when using the legacy
  [ATI](ATI "ATI"){.wikilink} driver.

- ```{=mediawiki}
  {{ic|i915}}
  ```
  for [Intel graphics](Intel_graphics "Intel graphics"){.wikilink}.

- ```{=mediawiki}
  {{ic|nouveau}}
  ```
  for the open-source [Nouveau](Nouveau "Nouveau"){.wikilink} driver.

- ```{=mediawiki}
  {{ic|nvidia nvidia_modeset nvidia_uvm nvidia_drm}}
  ```
  for the out-of-tree `{{Pkg|nvidia}}`{=mediawiki} and `{{Pkg|nvidia-open}}`{=mediawiki} drivers. See [NVIDIA#DRM kernel
  mode setting](NVIDIA#DRM_kernel_mode_setting "NVIDIA#DRM kernel mode setting"){.wikilink} for details.

<!-- -->

- ```{=mediawiki}
  {{ic|mgag200}}
  ```
  for Matrox graphics.

- Depending on [QEMU](QEMU "QEMU"){.wikilink} graphics in use (*qemu* option `{{ic|-vga ''type''}}`{=mediawiki} or
  [libvirt](libvirt "libvirt"){.wikilink}
  `{{ic|1=<video><model type='''type''<nowiki/>'>}}`{=mediawiki}[1](https://libvirt.org/formatdomain.html#video-devices)):
  - ```{=mediawiki}
    {{ic|bochs}}
    ```
    for `{{ic|std}}`{=mediawiki} (*qemu*) and `{{ic|vga}}`{=mediawiki}/`{{ic|bochs}}`{=mediawiki} (*libvirt*),

  - ```{=mediawiki}
    {{ic|virtio-gpu}}
    ```
    for `{{ic|virtio}}`{=mediawiki},

  - ```{=mediawiki}
    {{ic|qxl}}
    ```
    for `{{ic|qxl}}`{=mediawiki},

  - ```{=mediawiki}
    {{ic|vmwgfx}}
    ```
    for `{{ic|vmware}}`{=mediawiki} (*qemu*) and `{{ic|vmvga}}`{=mediawiki} (*libvirt*),

  - ```{=mediawiki}
    {{ic|cirrus}}
    ```
    for `{{ic|cirrus}}`{=mediawiki}.

- Depending on [VirtualBox](VirtualBox "VirtualBox"){.wikilink} graphics controller:
  - ```{=mediawiki}
    {{ic|vmwgfx}}
    ```
    for VMSVGA,

  - ```{=mediawiki}
    {{ic|vboxvideo}}
    ```
    for VBoxVGA or VBoxSVGA.

Initramfs configuration instructions are slightly different depending on the initramfs generator you use.

#### mkinitcpio

For in-tree modules, make sure `{{ic|kms}}`{=mediawiki} is included in the HOOKS array in
`{{ic|/etc/mkinitcpio.conf}}`{=mediawiki} (this is the default since [mkinitcpio
v33](https://gitlab.archlinux.org/archlinux/mkinitcpio/mkinitcpio/-/merge_requests/126/diffs#57ac3bb5162944ca1d6c5fa29ff4d7cc886e04bb_53_52)).

For out-of-tree modules, place the module names in the MODULES array. For example, to enable early KMS for the NVIDIA
graphics driver:

```{=mediawiki}
{{hc|/etc/mkinitcpio.conf|2=
MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm ...)
}}
```
```{=mediawiki}
{{Note|1=If you use [[PRIME]] Graphics Processing Unit (GPU) with Intel Integrated Graphics Processors (IGP) being your primary GPU and AMD as the discrete one, {{ic|intel_agp}} may lead to troubles when resuming from hibernation (monitor gets no signal). See [https://bbs.archlinux.org/viewtopic.php?id=262043] for details.}}
```
If you are using the [#Forcing modes and EDID](#Forcing_modes_and_EDID "#Forcing modes and EDID"){.wikilink} method, you
should embed the custom file into [initramfs](initramfs "initramfs"){.wikilink} as well:

```{=mediawiki}
{{hc|/etc/mkinitcpio.conf|2=
FILES=(/usr/lib/firmware/edid/''your_edid''.bin)
}}
```
Then [regenerate the initramfs](regenerate_the_initramfs "regenerate the initramfs"){.wikilink}.

#### Booster

If you use [Booster](Booster "Booster"){.wikilink}, you can load required modules with this config change:

```{=mediawiki}
{{hc|/etc/booster.yaml|
modules_force_load: i915
}}
```
If you are using the [#Forcing modes and EDID](#Forcing_modes_and_EDID "#Forcing modes and EDID"){.wikilink} method, you
should embed the custom file into your booster images as well:

```{=mediawiki}
{{hc|/etc/booster.yaml|
extra_files: /usr/lib/firmware/edid/''your_edid''.bin
}}
```
Then [regenerate the booster images](Booster#Usage "regenerate the booster images"){.wikilink}.

#### Dracut

[Dracut](Dracut "Dracut"){.wikilink} enables early loading (at the initramfs stage, via `{{ic|modprobe}}`{=mediawiki})
through its `{{ic|--force_drivers}}`{=mediawiki} command or `{{ic|force_drivers+{{=}}`{=mediawiki}\"\"}} config entry
line. For example:

```{=mediawiki}
{{hc|/etc/dracut.conf.d/myflags.conf|
# ...
force_drivers+{{=}}
```
\" amdgpu \"

1.  \...

}}

## Troubleshooting

### My fonts are too tiny {#my_fonts_are_too_tiny}

See [Linux console#Fonts](Linux_console#Fonts "Linux console#Fonts"){.wikilink} for how to change your console font to a
large font. The Terminus font (`{{Pkg|terminus-font}}`{=mediawiki}) is available in many sizes, such as
`{{ic|ter-132b}}`{=mediawiki} which is larger.

Alternatively, [disabling modesetting](#Disabling_modesetting "disabling modesetting"){.wikilink} might switch to lower
resolution and make fonts appear larger.

## Forcing modes and EDID {#forcing_modes_and_edid}

If your native resolution is not automatically configured or no display at all is detected, then your monitor might send
none or just a skewed [EDID](Wikipedia:EDID "EDID"){.wikilink} file. The kernel will try to catch this case and will set
one of the most typical resolutions.

In case you have the EDID file for your monitor, you merely need to explicitly enforce it (see below). However, most
often one does not have direct access to a sane file and it is necessary to either extract an existing one and fix it or
to generate a new one.

Generating new EDID binaries for various resolutions and configurations is possible during kernel compilation by
following the [upstream documentation](https://docs.kernel.org/admin-guide/edid.html) (also see
[here](https://www.osadl.org/Single-View.111+M5315d29dd12.0.html) for a short guide). Other solutions are outlined in
details in this [article](https://kodi.wiki/view/Archive:Creating_and_using_edid.bin_via_xorg.conf). Extracting an
existing one is in most cases easier, e.g. if your monitor works fine under Windows, you might have luck extracting the
EDID from the corresponding driver, or if a similar monitor works which has the same settings, you may use
`{{man|1|get-edid}}`{=mediawiki} from the `{{Pkg|read-edid}}`{=mediawiki} package. You can also try looking in
`{{ic|/sys/class/drm/*/edid}}`{=mediawiki}.

After having prepared your EDID, place it in a directory, e.g. called `{{ic|edid}}`{=mediawiki} under
`{{ic|/usr/lib/firmware/}}`{=mediawiki} and copy your binary into it.

To load it at boot, specify the following in the [kernel command
line](kernel_command_line "kernel command line"){.wikilink}:

`drm.edid_firmware=edid/your_edid.bin`

In order to apply it only to a specific connector, use:

`drm.edid_firmware=VGA-1:edid/your_edid.bin`

If you want to set multiple edid files, use:

`drm.edid_firmware=VGA-1:edid/your_edid.bin,VGA-2:edid/your_other_edid.bin`

If you are doing [early KMS](#Early_KMS_start "early KMS"){.wikilink}, you must [include the custom EDID file in the
initramfs](Mkinitcpio#BINARIES_and_FILES "include the custom EDID file in the initramfs"){.wikilink}, otherwise you will
run into problems.

The value of the `{{ic|drm.edid_firmware}}`{=mediawiki} parameter may also be altered after boot by writing to
`{{ic|/sys/module/drm/parameters/edid_firmware}}`{=mediawiki}:

`# echo edid/your_edid.bin > /sys/module/drm/parameters/edid_firmware`

This will only take effect for newly plugged in displays, already plugged-in screens will continue to use their existing
EDID settings. For external displays, replugging them is sufficient to see the effect however.

To load an EDID after boot, you can use debugfs instead of a kernel command line parameter if the kernel is not in
[lockdown mode](Security#Kernel_lockdown_mode "lockdown mode"){.wikilink}. This is very useful if you swap the monitors
on a connector or just for testing. Once you have an EDID file as above, run:

`# cat correct-edid.bin > /sys/kernel/debug/dri/0/HDMI-A-2/edid_override`

And to disable:

`# echo -n reset > /sys/kernel/debug/dri/0/HDMI-A-2/edid_override`

If your monitor supports hotplugging, you can also trigger a hotplug to make the monitor use the new EDID you just
loaded (e.g. into `{{ic|edid_override}}`{=mediawiki}), so you don\'t have to physically replug the monitor nor reboot:

`# echo 1 > /sys/kernel/debug/dri/0/HDMI-A-2/trigger_hotplug`

### Forcing modes {#forcing_modes}

```{=mediawiki}
{{Warning|The method described below is somehow incomplete because e.g. [[Xorg]] does not take into account the resolution specified, so users are encouraged to use the method described above. However, specifying resolution with {{ic|1=video=}} command line may be useful in some scenarios.}}
```
From [the nouveau wiki](https://nouveau.freedesktop.org/wiki/KernelModeSetting):

:   A mode can be forced on the kernel command line. Unfortunately, the command line option video is poorly documented
    in the DRM case. Bits and pieces on how to use it can be found in
    - <https://docs.kernel.org/fb/modedb.html>
    - <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/drm_fb_helper.c>

The format is:

`video=``<driver>`{=html}`:``<conn>`{=html}`:``<xres>`{=html}`x``<yres>`{=html}`[M][R][-``<bpp>`{=html}`][@``<refresh>`{=html}`][i][m][eDd]`

- ```{=mediawiki}
  {{ic|<driver>}}
  ```

  :   Specify a video mode at bootup.

- ```{=mediawiki}
  {{ic|<conn>}}
  ```

  :   Specifies the video connection type, such as VGA, DVI, HDMI, etc., see `{{ic|/sys/class/drm/}}`{=mediawiki} for
      available connectors

- ```{=mediawiki}
  {{ic|<xres>}}
  ```

  :   The horizontal resolution in pixels.

- ```{=mediawiki}
  {{ic|<yres>}}
  ```

  :   The vertical resolution in pixels.

- ```{=mediawiki}
  {{ic|[M]}}
  ```

  :   Enables the use of VESA Coordinated Video Timings (CVT) to calculate the video mode timings instead of looking up
      the mode from a database

- ```{=mediawiki}
  {{ic|[R]}}
  ```

  :   Enables reduced blanking calculations for digital displays when using CVT. This reduces the horizontal and
      vertical blanking intervals to save bandwidth.

- ```{=mediawiki}
  {{ic|[-<bpp>]}}
  ```

  :   Specifies the color depth or bits per pixel (e.g., -24 for 24-bit color).

- ```{=mediawiki}
  {{ic|[@<refresh>]}}
  ```

  :   Specifies the refresh rate in Hz.

- ```{=mediawiki}
  {{ic|[i]}}
  ```

  :   Enables interlaced mode.

- ```{=mediawiki}
  {{ic|[m]}}
  ```

  :   Adds margins to the CVT calculation (1.8% of xres rounded down to 8 pixels and 1.8% of yres)

- ```{=mediawiki}
  {{ic|[e]}}
  ```

  :   output forced to on

- ```{=mediawiki}
  {{ic|[D]}}
  ```

  :   digital output forced to on (e.g. DVI-I connector)

- ```{=mediawiki}
  {{ic|[d]}}
  ```

  :   output forced to off

You can override the modes of several outputs using `{{ic|<nowiki>video=</nowiki>}}`{=mediawiki} several times, for
instance, to force `{{ic|DVI}}`{=mediawiki} to *1024x768* at *85 Hz* and `{{ic|TV-out}}`{=mediawiki} off:

`video=DVI-I-1:1024x768@85 video=TV-1:d`

To get the name and current status of connectors, you can use the following shell oneliner:

```{=mediawiki}
{{hc|<nowiki>$ for p in /sys/class/drm/*/status; do con=${p%/status}; echo -n "${con#*/card?-}: "; cat $p; done</nowiki>|
DVI-I-1: connected
HDMI-A-1: disconnected
VGA-1: disconnected
}}
```
## Disabling modesetting {#disabling_modesetting}

You may want to disable KMS for various reasons. To disable KMS, add `{{ic|nomodeset}}`{=mediawiki} as a kernel
parameter. See [Kernel parameters](Kernel_parameters "Kernel parameters"){.wikilink} for more info.

Along with the `{{ic|nomodeset}}`{=mediawiki} kernel parameter, for an Intel graphics card, you need to add
`{{ic|1=i915.modeset=0}}`{=mediawiki}, and for an Nvidia graphics card, you need to add
`{{ic|1=nouveau.modeset=0}}`{=mediawiki}. For Nvidia Optimus dual-graphics system, you need to add all the three kernel
parameters (i.e. `{{ic|1="nomodeset i915.modeset=0 nouveau.modeset=0"}}`{=mediawiki}).

```{=mediawiki}
{{Note|Some [[Xorg]] drivers will not work with KMS disabled. See the wiki page on your specific driver for details.}}
```
[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink}
[Category:Kernel](Category:Kernel "Category:Kernel"){.wikilink}

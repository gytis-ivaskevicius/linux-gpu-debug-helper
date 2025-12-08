[de:Nvidia](de:Nvidia "wikilink") [es:NVIDIA](es:NVIDIA "wikilink") [hu:NVIDIA](hu:NVIDIA "wikilink")
[ja:NVIDIA](ja:NVIDIA "wikilink") [pt:NVIDIA](pt:NVIDIA "wikilink") [ru:NVIDIA](ru:NVIDIA "wikilink")
[zh-hans:NVIDIA](zh-hans:NVIDIA "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|NVIDIA/Tips and tricks}}`{=mediawiki} `{{Related|NVIDIA/Troubleshooting}}`{=mediawiki}
`{{Related|Nouveau}}`{=mediawiki} `{{Related|NVIDIA Optimus}}`{=mediawiki} `{{Related|PRIME}}`{=mediawiki}
`{{Related|Bumblebee}}`{=mediawiki} `{{Related|nvidia-xrun}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki}
`{{Related|Vulkan}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

This article covers the official [NVIDIA](https://www.nvidia.com) graphics card drivers. For the community open-source
driver, see [Nouveau](Nouveau "wikilink"). If you have a laptop with hybrid graphics, see also [NVIDIA
Optimus](NVIDIA_Optimus "wikilink").

## Installation

```{=mediawiki}
{{Warning|Avoid installing the NVIDIA driver through the package provided from the NVIDIA website. Installation through [[pacman]] allows upgrading the driver together with the rest of the system.}}
```
```{=mediawiki}
{{Note|When dual booting on a system with [[hybrid graphics]], enabling Windows or third-party apps ''Eco mode'' (like [https://www.asus.com/support/faq/1043747/#a14 ASUS Eco mode]) may fully disable the NVIDIA discrete GPU, making it undetectable.}}
```
First, find the family of your card (e.g. NV110, NVC0, etc.) on [nouveau wiki\'s code names
page](https://nouveau.freedesktop.org/CodeNames.html) corresponding to its model/official name obtained with:

`$ lspci -k -d ::03xx`

Then, install the appropriate driver for your card:

+--------------------------------------+--------------------------------------+--------------------------------------+
| GPU family                           | Driver                               | Status                               |
+======================================+======================================+======================================+
| [Turing                              | ```{=mediawiki}                      | [Recommended by                      |
| (NV160/TUXXX)](https://nouveau.f     | {{Pkg|nvidia-open}}                  | up                                   |
| reedesktop.org/CodeNames.html#NV160) | ```                                  | stream](https://developer.nvidia.com |
| and newer                            | for `{{Pkg|linux}}`{=mediawiki}\     | /blog/nvidia-transitions-fully-towar |
|                                      | `                                    | ds-open-source-gpu-kernel-modules/)\ |
|                                      | {{Pkg|nvidia-open-lts}}`{=mediawiki} | Current, supported^1^\               |
|                                      | for `{{Pkg|linux-lts}}`{=mediawiki}\ | Possible power management issue on   |
|                                      | `{                                   | Turing^2^                            |
|                                      | {Pkg|nvidia-open-dkms}}`{=mediawiki} |                                      |
|                                      | for any kernel(s)                    |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [Maxwell                             | ```{=mediawiki}                      | Current, supported^1^                |
| (NV110/GMXXX)](https://nouveau.f     | {{Pkg|nvidia}}                       |                                      |
| reedesktop.org/CodeNames.html#NV110) | ```                                  |                                      |
| through\                             | for `{{Pkg|linux}}`{=mediawiki}\     |                                      |
| [Ada Lovelace                        | `{{Pkg|nvidia-lts}}`{=mediawiki} for |                                      |
| (NV190/ADXXX)](https://nouveau.f     | `{{Pkg|linux-lts}}`{=mediawiki}\     |                                      |
| reedesktop.org/CodeNames.html#NV190) | `{{Pkg|nvidia-dkms}}`{=mediawiki}    |                                      |
|                                      | for any kernel(s)                    |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [Kepler                              | ```{=mediawiki}                      | Legacy, unsupported^3,4^             |
| (NVE0/GKXXX)](https://nouveau.       | {{AUR|nvidia-470xx-dkms}}            |                                      |
| freedesktop.org/CodeNames.html#NVE0) | ```                                  |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [Fermi                               | ```{=mediawiki}                      |                                      |
| (NVC0/GF1XX)](https://nouveau.       | {{AUR|nvidia-390xx-dkms}}            |                                      |
| freedesktop.org/CodeNames.html#NVC0) | ```                                  |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [Tesla                               | ```{=mediawiki}                      |                                      |
| (                                    | {{AUR|nvidia-340xx-dkms}}            |                                      |
| NV50/G80-90-GT2XX)](https://nouveau. | ```                                  |                                      |
| freedesktop.org/CodeNames.html#NV50) |                                      |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+
| [Curie                               | No longer packaged                   |                                      |
| (NV40/G70)](https://nouveau.         |                                      |                                      |
| freedesktop.org/CodeNames.html#NV40) |                                      |                                      |
| and older                            |                                      |                                      |
+--------------------------------------+--------------------------------------+--------------------------------------+

1.  If these packages do not work, it is usually due to new hardware releases. `{{AUR|nvidia-open-beta}}`{=mediawiki}
    may have a newer driver version that offers support.
2.  NVIDIA\'s open kernel modules cannot enable [D3 Power
    Management](PRIME#PCI-Express_Runtime_D3_(RTD3)_Power_Management "wikilink") on Turing. This reduces battery life on
    notebooks with Turing in an [NVIDIA Optimus](NVIDIA_Optimus "wikilink") configuration. Use the proprietary module
    (e.g. `{{Pkg|nvidia}}`{=mediawiki}) with [module parameter](module_parameter "wikilink")
    `{{ic|1=NVreg_EnableGpuFirmware=0}}`{=mediawiki} instead. [More information about this
    issue](https://github.com/NVIDIA/open-gpu-kernel-modules/issues/640#issuecomment-2188114679).
3.  May not function correctly on Linux 5.18 (or later) on systems with Intel CPUs [11th Gen and
    newer](https://web.archive.org/web/20250209200337/https://www.intel.com/content/www/us/en/newsroom/opinion/intel-cet-answers-call-protect-common-malware-threats.html)
    due an incompatibility with [Indirect Branch
    Tracking](https://edc.intel.com/content/www/us/en/design/ipla/software-development-platforms/client/platforms/alder-lake-desktop/12th-generation-intel-core-processors-datasheet-volume-1-of-2/007/indirect-branch-tracking/).
    You can disable it by setting the `{{ic|1=ibt=off}}`{=mediawiki} [kernel parameter](kernel_parameter "wikilink")
    from the [boot loader](boot_loader "wikilink"). Be aware, this security feature is responsible for [mitigating a
    class of exploit techniques](https://lwn.net/Articles/889475/).
4.  NVIDIA no longer actively supports these cards and their drivers [may not officially support the current Xorg
    version](https://nvidia.custhelp.com/app/answers/detail/a_id/3142/). It might be easier to use the
    [nouveau](nouveau "wikilink") driver; however, NVIDIA\'s legacy drivers are still available and might provide better
    3D performance/stability.

:   ```{=mediawiki}
    {{Note|
    :* When installing {{Pkg|dkms}}, read [[Dynamic Kernel Module Support#Installation]].
    :* The [[DKMS]] variants are not tied to a specific kernel, as they recompile the NVIDIA kernel module for each kernel for which header files are installed.
    }}
    ```

For 32-bit application support, also install the corresponding *lib32* package from the [multilib](multilib "wikilink")
repository (e.g. `{{Pkg|lib32-nvidia-utils}}`{=mediawiki}).

The `{{Pkg|nvidia-utils}}`{=mediawiki} package contains a file which blacklists the `{{ic|nouveau}}`{=mediawiki} module
once you reboot. Optionally, you can also remove `{{ic|kms}}`{=mediawiki} from the `{{ic|HOOKS}}`{=mediawiki} array in
`{{ic|/etc/mkinitcpio.conf}}`{=mediawiki} and [regenerate the initramfs](regenerate_the_initramfs "wikilink"). This will
prevent the initramfs from containing the `{{ic|nouveau}}`{=mediawiki} module making sure the kernel cannot load it
during early boot.

```{=mediawiki}
{{Note|If you are using [[#Wayland configuration|Wayland]] you should not restart until after following [[#DRM kernel mode setting]] or you may end up with a black screen.}}
```
Once the driver has been installed, continue to [#Xorg configuration](#Xorg_configuration "wikilink") or [#Wayland
configuration](#Wayland_configuration "wikilink").

### Custom kernel {#custom_kernel}

Ensure your kernel has `{{ic|1=CONFIG_DRM_SIMPLEDRM=y}}`{=mediawiki}, and if using
`{{ic|CONFIG_DEBUG_INFO_BTF}}`{=mediawiki} then this is needed in the PKGBUILD (since kernel 5.16):

`install -Dt "$builddir/tools/bpf/resolve_btfids" tools/bpf/resolve_btfids/resolve_btfids`

If your kernel is compiled with `{{ic|CONFIG_NOVA_CORE}}`{=mediawiki} enabled, you may need to prevent the new NVIDIA
GPU driver [Nova](https://docs.kernel.org/gpu/nova/index.html) from loading. `{{Pkg|nvidia-utils}}`{=mediawiki} adds it
to the blacklist by default. You can check this [by running systemd-analyze](Kernel_module#Using_modprobe.d "wikilink").
If you have installed a different version of the driver, you may need to [blacklist](blacklist "wikilink") the
`{{ic|nova_core}}`{=mediawiki} and `{{ic|nova_drm}}`{=mediawiki} modules manually.

### DRM kernel mode setting {#drm_kernel_mode_setting}

Since NVIDIA does not support [automatic KMS late loading](Kernel_mode_setting#Late_KMS_start "wikilink"), enabling DRM
([Direct Rendering Manager](Wikipedia:Direct_Rendering_Manager "wikilink")) [kernel mode
setting](kernel_mode_setting "wikilink") is required to make Wayland compositors function properly. KMS is also required
for native Wayland rendering on NVIDIA dGPUs for dual-GPU setups.

Starting from `{{Pkg|nvidia-utils}}`{=mediawiki} 560.35.03-5, DRM defaults to
enabled.[1](https://gitlab.archlinux.org/archlinux/packaging/packages/nvidia-utils/-/commit/1b02daa2ccca6a69fa4355fb5a369c2115ec3e22)
For older drivers, set the `{{ic|1=modeset=1}}`{=mediawiki} [kernel module
parameter](kernel_module_parameter "wikilink") for the `{{ic|nvidia_drm}}`{=mediawiki} module.

To verify that DRM is actually enabled, execute the following:

`# cat /sys/module/nvidia_drm/parameters/modeset`

Which should now return `{{ic|Y}}`{=mediawiki}, and not `{{ic|N}}`{=mediawiki}.

```{=mediawiki}
{{Note|Kernels [[Kernel#Officially supported kernels|officially supported by Arch]] enable {{ic|simpledrm}}, while NVIDIA driver requires {{ic|efifb}} or {{ic|vesafb}} when {{ic|1=nvidia_drm.fbdev}} is disabled/unavailable (version < 545).}}
```
#### Early loading {#early_loading}

For basic functionality, just adding the kernel parameter should suffice. If you want to ensure it is loaded as early as
possible, or you are noticing startup issues (such as the `{{ic|nvidia}}`{=mediawiki} kernel module being loaded after
the [display manager](display_manager "wikilink")), you can add `{{ic|nvidia}}`{=mediawiki},
`{{ic|nvidia_modeset}}`{=mediawiki}, `{{ic|nvidia_uvm}}`{=mediawiki} and `{{ic|nvidia_drm}}`{=mediawiki} to the
initramfs. See [Kernel module#Early module loading](Kernel_module#Early_module_loading "wikilink") to learn how to
configure your initramfs generator. [mkinitcpio](mkinitcpio "wikilink") users after v40 version does not need to perform
manual initramfs regeneration as built-in hook will already do this automatically.

### Hardware accelerated video decoding {#hardware_accelerated_video_decoding}

Accelerated video decoding with VDPAU is supported on GeForce 8 series cards and newer. Accelerated video decoding with
NVDEC is supported on Fermi (\~400 series) cards and newer. See [Hardware video
acceleration](Hardware_video_acceleration "wikilink") for details.

### Hardware accelerated video encoding with NVENC {#hardware_accelerated_video_encoding_with_nvenc}

NVENC requires the `{{ic|nvidia_uvm}}`{=mediawiki} module and the creation of related device nodes under
`{{ic|/dev}}`{=mediawiki}.

The latest driver package provides a [udev rule](udev_rule "wikilink") which creates device nodes automatically, so no
further action is required.

If you are using an old driver (e.g. `{{AUR|nvidia-340xx-dkms}}`{=mediawiki}), you need to create device nodes. Invoking
the `{{ic|nvidia-modprobe}}`{=mediawiki} utility automatically creates them. You can create
`{{ic|/etc/udev/rules.d/70-nvidia.rules}}`{=mediawiki} to run it automatically:

```{=mediawiki}
{{hc|/etc/udev/rules.d/70-nvidia.rules|2=
ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", RUN+="/usr/bin/nvidia-modprobe -c 0 -u"}}
```
## Wayland configuration {#wayland_configuration}

Regarding Xwayland take a look at [Wayland#Xwayland](Wayland#Xwayland "wikilink").

For further configuration options, take a look at the wiki pages or documentation of the respective
[compositor](Wayland#Compositors "wikilink").

```{=mediawiki}
{{Note|Prior to driver version 555.xx, or when using a Wayland compositor that does not support Explicit Sync via the {{ic|linux-drm-syncobj-v1}} protocol, the NVIDIA driver can have major issues manifesting as flickering, out of order frames, and more, in both native Wayland and Xwayland applications.}}
```
### Basic support {#basic_support}

There are two kernel parameters for the `{{ic|nvidia_drm}}`{=mediawiki} module to be considered:
`{{ic|modeset}}`{=mediawiki} and `{{ic|fbdev}}`{=mediawiki}. Both are [enabled by
default](https://gitlab.archlinux.org/archlinux/packaging/packages/nvidia-utils/-/blob/3b439109/PKGBUILD#L60) when using
the `{{Pkg|nvidia-utils}}`{=mediawiki} package. NVIDIA also [plans to enable them by default in a future
release](https://indico.freedesktop.org/event/6/contributions/287/attachments/210/288/NVIDIA%20Wayland%20Roadmap.pdf).

#### modeset

Enabling `{{ic|modeset}}`{=mediawiki} is necessary for all Wayland configurations to function properly.

For unsupported drivers, where `{{ic|modeset}}`{=mediawiki} needs to be enabled manually, see [#DRM kernel mode
setting](#DRM_kernel_mode_setting "wikilink"), and [Wayland#Requirements](Wayland#Requirements "wikilink") for more
information.

#### fbdev

```{=mediawiki}
{{Out of date|As of {{Pkg|linux}} 6.14.2 and {{Pkg|nvidia}} 570.133.07 Wayland seems to work well with fbdev disabled and the {{ic|cat}} command can return {{ic|N}}, so this section is probably only relevant for older versions of the driver.}}
```
Enabling `{{ic|fbdev}}`{=mediawiki} is necessary for some Wayland configurations.

It is specifically a hard requirement on Linux 6.11 and later, but it is currently unclear whether this is intended
behavior or a bug, see
[2](https://forums.developer.nvidia.com/t/drm-fbdev-wayland-presentation-support-with-linux-kernel-6-11-and-above/307920)
for more details.

It can be set the same way as the [modesetting parameter](#DRM_kernel_mode_setting "wikilink"), with the difference that
executing:

`# cat /sys/module/nvidia_drm/parameters/fbdev`

Will return a missing file error if it is not set at all, instead of `{{ic|N}}`{=mediawiki}.

### Suspend support {#suspend_support}

Wayland suspend can suffer from the defaults more than X does, see [/Tips and tricks#Preserve video memory after
suspend](/Tips_and_tricks#Preserve_video_memory_after_suspend "wikilink") for details.

If you use GDM, also see [GDM#Wayland and the proprietary NVIDIA
driver](GDM#Wayland_and_the_proprietary_NVIDIA_driver "wikilink").

### nvidia-application-profiles-rc.d {#nvidia_application_profiles_rc.d}

Some wayland compositors will consume a large quantity of VRAM by default if the
[GLVidHeapReuseRatio](https://www.nvidia.com/en-us/drivers/details/237587/) application profile key is not [applied
against their process name](https://github.com/NVIDIA/egl-wayland/issues/126#issuecomment-2379945259). For example,
[niri](niri "wikilink") users can free up to \~2.5GiB of idle vram consumption with the following:

```{=mediawiki}
{{hc|/etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json|2=
{
    "rules": [
        {
            "pattern": {
                "feature": "procname",
                "matches": "niri"
            },
            "profile": "Limit free buffer pool on Wayland compositors"
        }
    ],
    "profiles": [
        {
            "name": "Limit free buffer pool on Wayland compositors",
            "settings": [
                {
                    "key": "GLVidHeapReuseRatio",
                    "value": 0
                }
            ]
        }
    ]
}
}}
```
## Xorg configuration {#xorg_configuration}

The proprietary NVIDIA graphics card driver does not need any Xorg server configuration file. You can [start
X](Xorg#Running "wikilink") to see if the Xorg server will function correctly without a configuration file. However, it
may be required to create a configuration file (prefer `{{ic|/etc/X11/xorg.conf.d/20-nvidia.conf}}`{=mediawiki} over
`{{ic|/etc/X11/xorg.conf}}`{=mediawiki}) in order to adjust various settings. This configuration can be generated by the
NVIDIA Xorg configuration tool, or it can be created manually. If created manually, it can be a minimal configuration
(in the sense that it will only pass the basic options to the [Xorg](Xorg "wikilink") server), or it can include a
number of settings that can bypass Xorg\'s auto-discovered or pre-configured options.

```{=mediawiki}
{{Tip|For more configuration options, see [[NVIDIA/Troubleshooting]].}}
```
### Automatic configuration {#automatic_configuration}

The NVIDIA package includes an automatic configuration tool to create an Xorg server configuration file
(`{{ic|xorg.conf}}`{=mediawiki}) and can be run by:

`# nvidia-xconfig`

This command will auto-detect and create (or edit, if already present) the `{{ic|/etc/X11/xorg.conf}}`{=mediawiki}
configuration according to present hardware.

Double-check your `{{ic|/etc/X11/xorg.conf}}`{=mediawiki} to make sure your default depth, horizontal sync, vertical
refresh, and resolutions are acceptable.

### nvidia-settings {#nvidia_settings}

The `{{Pkg|nvidia-settings}}`{=mediawiki} tool lets you configure many options using either CLI or GUI. Running
`{{ic|nvidia-settings}}`{=mediawiki} without any options launches the GUI, for CLI options see
`{{man|1|nvidia-settings}}`{=mediawiki}.

You can run the CLI/GUI as a non-root user and save the settings to `{{ic|~/.nvidia-settings-rc}}`{=mediawiki} by using
the option *Save Current Configuration* under *nvidia-settings Configuration* tab.

To load the `{{ic|~/.nvidia-settings-rc}}`{=mediawiki} for the current user:

`$ nvidia-settings --load-config-only`

See [Autostarting](Autostarting "wikilink") to start this command on every boot.

```{=mediawiki}
{{Note|[[Xorg]] may not start or crash on startup after saving {{ic|nvidia-settings}} changes. Adjusting or deleting the generated {{ic|~/.nvidia-settings-rc}} and/or [[Xorg]] file(s) should recover normal startup.}}
```
### Manual configuration {#manual_configuration}

Several tweaks (which cannot be enabled [automatically](#Automatic_configuration "wikilink") or with
[nvidia-settings](#nvidia-settings "wikilink")) can be performed by editing your configuration file. The Xorg server
will need to be restarted before any changes are applied.

See [NVIDIA Accelerated Linux Graphics Driver README and Installation
Guide](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/) for additional details and options.

#### Minimal configuration {#minimal_configuration}

A basic configuration block in `{{ic|20-nvidia.conf}}`{=mediawiki} (or deprecated in `{{ic|xorg.conf}}`{=mediawiki})
would look like this:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-nvidia.conf|
Section "Device"
        Identifier "NVIDIA Card"
        Driver "nvidia"
        VendorName "NVIDIA Corporation"
        BoardName "GeForce GTX 1050 Ti"
EndSection
}}
```
#### Disabling the logo on startup {#disabling_the_logo_on_startup}

If you are using an old driver (`{{AUR|nvidia-340xx-dkms}}`{=mediawiki}), you may want to disable the NVIDIA logo splash
screen that is displayed at X startup. Add the `{{ic|"NoLogo"}}`{=mediawiki} option under section
`{{ic|Device}}`{=mediawiki}:

`Option "NoLogo" "1"`

#### Overriding monitor detection {#overriding_monitor_detection}

The `{{ic|"ConnectedMonitor"}}`{=mediawiki} option under section `{{ic|Device}}`{=mediawiki} allows overriding monitor
detection when X server starts, which may save a significant amount of time at start up. The available options are:
`{{ic|"CRT"}}`{=mediawiki} for analog connections, `{{ic|"DFP"}}`{=mediawiki} for digital monitors and
`{{ic|"TV"}}`{=mediawiki} for televisions.

The following statement forces the NVIDIA driver to bypass startup checks and recognize the monitor as DFP:

`Option "ConnectedMonitor" "DFP"`

```{=mediawiki}
{{Note|Use "CRT" for all analog 15 pin VGA connections, even if the display is a flat panel. "DFP" is intended for DVI, HDMI, or DisplayPort digital connections only.}}
```
#### Enabling brightness control {#enabling_brightness_control}

```{=mediawiki}
{{Out of date|Potentially obsolete[https://lists.archlinux.org/archives/list/aur-requests@lists.archlinux.org/thread/GXJG7D3ALUQKOE2DT4XCL4UXQUFDDSEC/], upstream package also seems to be ancient.}}
```
Add to kernel parameters:

`nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1`

Alternatively, add the following under section `{{ic|Device}}`{=mediawiki}:

`Option "RegistryDwords" "EnableBrightnessControl=1"`

If brightness control still does not work with this option, try installing `{{AUR|nvidia-bl-dkms}}`{=mediawiki}.

```{=mediawiki}
{{Note|Installing {{AUR|nvidia-bl-dkms}} will provide a {{ic|/sys/class/backlight/nvidia_backlight/}} interface to backlight brightness control, but your system may continue to issue backlight control changes on {{ic|/sys/class/backlight/acpi_video0/}}. One solution in this case is to watch for changes on, e.g. {{ic|acpi_video0/brightness}} with ''inotifywait'' and to translate and write to {{ic|nvidia_backlight/brightness}} accordingly. See [[Backlight#sysfs modified but no brightness change]].}}
```
#### Enabling SLI {#enabling_sli}

```{=mediawiki}
{{Out of date|Since version 455.23.04, some SLI modes are no longer supported.}}
```
```{=mediawiki}
{{Warning|Since the GTX 10xx Series (1080, 1070, 1060, etc) only 2-way SLI is supported. 3-way and 4-way SLI may work for CUDA/OpenCL applications, but will most likely break all OpenGL applications.}}
```
Taken from the NVIDIA driver\'s
[README](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/xconfigoptions.html#SLI) Appendix B: *This
option controls the configuration of SLI rendering in supported configurations.* A \"supported configuration\" is a
computer equipped with an SLI-Certified Motherboard and 2 or 3 SLI-Certified GeForce GPUs.

Find the first GPU\'s PCI Bus ID using `{{ic|lspci}}`{=mediawiki}:

```{=mediawiki}
{{hc|# lspci -d ::03xx|
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
03:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GTX 650] (rev a1)
04:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GTX 650] (rev a1)
08:00.0 3D controller: NVIDIA Corporation GM108GLM [Quadro K620M / Quadro M500M] (rev a2)
}}
```
Add the BusID (3 in the previous example) under section `{{ic|Device}}`{=mediawiki}:

`BusID "PCI:3:0:0"`

```{=mediawiki}
{{Note|The format is important. The BusID value must be specified as {{ic|"PCI:<BusID>:0:0"}}}}
```
Add the desired SLI rendering mode value under section `{{ic|Screen}}`{=mediawiki}:

`Option "SLI" "AA"`

The following table presents the available rendering modes.

  Value                       Behavior
  --------------------------- ----------------------------------------------------------------------------------------------------------------------
  0, no, off, false, Single   Use only a single GPU when rendering.
  1, yes, on, true, Auto      Enable SLI and allow the driver to automatically select the appropriate rendering mode.
  AFR                         Enable SLI and use the alternate frame rendering mode.
  SFR                         Enable SLI and use the split frame rendering mode.
  AA                          Enable SLI and use SLI antialiasing. Use this in conjunction with full scene antialiasing to improve visual quality.

Alternatively, you can use the *nvidia-xconfig* utility to insert these changes into `{{ic|xorg.conf}}`{=mediawiki} with
a single command:

`# nvidia-xconfig --busid=PCI:3:0:0 --sli=AA`

To verify that SLI mode is enabled from a shell:

```{=mediawiki}
{{hc|$ nvidia-settings -q all {{!}}
```
grep SLIMode\|

` Attribute 'SLIMode' (arch:0.0): AA`\
`   'SLIMode' is a string attribute.`\
`   'SLIMode' is a read-only attribute.`\
`   'SLIMode' can use the following target types: X Screen.`

}}

```{=mediawiki}
{{Warning|After enabling SLI, your system may become frozen/non-responsive upon starting xorg. It is advisable that you disable your display manager before restarting.}}
```
If this configuration does not work, you may need to use the PCI Bus ID provided by
`{{ic|nvidia-settings}}`{=mediawiki},

```{=mediawiki}
{{hc|$ nvidia-settings -q all {{!}}
```
grep -i pcibus\| Attribute \'PCIBus\' (host:0\[gpu:0\]): 101.

` 'PCIBus' is an integer attribute.`\
` 'PCIBus' is a read-only attribute.`\
` 'PCIBus' can use the following target types: GPU, SDI Input Device.`

Attribute \'PCIBus\' (host:0\[gpu:1\]): 23.

` 'PCIBus' is an integer attribute.`\
` 'PCIBus' is a read-only attribute.`\
` 'PCIBus' can use the following target types: GPU, SDI Input Device.`

}}

and comment out the PrimaryGPU option in your xorg.d configuration,

```{=mediawiki}
{{hc|/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf|
...

Section "OutputClass"
...
    # Option "PrimaryGPU" "yes"
...
}}
```
Using this configuration may also solve any graphical boot issues.

### Multiple monitors {#multiple_monitors}

See [Multihead](Multihead "wikilink") for more general information.

#### Using nvidia-settings {#using_nvidia_settings}

The [nvidia-settings](#nvidia-settings "wikilink") tool can configure multiple monitors.

For CLI configuration, first get the `{{ic|CurrentMetaMode}}`{=mediawiki} by running:

```{=mediawiki}
{{hc|$ nvidia-settings -q CurrentMetaMode|2=
Attribute 'CurrentMetaMode' (hostnmae:0.0): id=50, switchable=no, source=nv-control :: DPY-1: 2880x1620 @2880x1620 +0+0 {ViewPortIn=2880x1620, ViewPortOut=2880x1620+0+0}
}}
```
Save everything after the `{{ic|::}}`{=mediawiki} to the end of the attribute (in this case:
`{{ic|1=DPY-1: 2880x1620 @2880x1620 +0+0 {ViewPortIn=2880x1620, ViewPortOut=2880x1620+0+0}<nowiki/>}}`{=mediawiki}) and
use to reconfigure your displays with
`{{ic|1=nvidia-settings --assign "CurrentMetaMode=''your_meta_mode''"}}`{=mediawiki}.

```{=mediawiki}
{{Tip|You can create shell aliases for the different monitor and resolution configurations you use.}}
```
#### ConnectedMonitor

```{=mediawiki}
{{Out of date|{{ic|Option "TwinView"}} is removed in 302.07, and TwinView is always enabled, this configuration needs to be rewritten.}}
```
If the driver does not properly detect a second monitor, you can force it to do so with ConnectedMonitor.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf|

Section "Monitor"
    Identifier     "Monitor1"
    VendorName     "Panasonic"
    ModelName      "Panasonic MICRON 2100Ex"
    HorizSync       30.0 - 121.0 # this monitor has incorrect EDID, hence Option "UseEDIDFreqs" "false"
    VertRefresh     50.0 - 160.0
    Option         "DPMS"
EndSection

Section "Monitor"
    Identifier     "Monitor2"
    VendorName     "Gateway"
    ModelName      "GatewayVX1120"
    HorizSync       30.0 - 121.0
    VertRefresh     50.0 - 160.0
    Option         "DPMS"
EndSection

Section "Device"
    Identifier     "Device1"
    Driver         "nvidia"
    Option         "NoLogo"
    Option         "UseEDIDFreqs" "false"
    Option         "ConnectedMonitor" "CRT,CRT"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce 6200 LE"
    BusID          "PCI:3:0:0"
    Screen          0
EndSection

Section "Device"
    Identifier     "Device2"
    Driver         "nvidia"
    Option         "NoLogo"
    Option         "UseEDIDFreqs" "false"
    Option         "ConnectedMonitor" "CRT,CRT"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce 6200 LE"
    BusID          "PCI:3:0:0"
    Screen          1
EndSection

}}
```
The duplicated device with `{{ic|Screen}}`{=mediawiki} is how you get X to use two monitors on one card without
`{{ic|TwinView}}`{=mediawiki}. Note that `{{ic|nvidia-settings}}`{=mediawiki} will strip out any
`{{ic|ConnectedMonitor}}`{=mediawiki} options you have added.

#### TwinView

```{=mediawiki}
{{Out of date|{{ic|Option "TwinView"}} is removed in 302.07, and TwinView is always enabled.}}
```
You want only one big screen instead of two. Set the `{{ic|TwinView}}`{=mediawiki} argument to `{{ic|1}}`{=mediawiki}.
This option should be used if you desire compositing. TwinView only works on a per-card basis, when all participating
monitors are connected to the same card.

`Option "TwinView" "1"`

Example configuration:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-monitor.conf|
Section "ServerLayout"
    Identifier     "TwinLayout"
    Screen         0 "metaScreen" 0 0
EndSection

Section "Monitor"
    Identifier     "Monitor0"
    Option         "Enable" "true"
EndSection

Section "Monitor"
    Identifier     "Monitor1"
    Option         "Enable" "true"
EndSection

Section "Device"
    Identifier     "Card0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"

    #refer to the link below for more information on each of the following options.
    Option         "HorizSync"          "DFP-0: 28-33; DFP-1: 28-33"
    Option         "VertRefresh"        "DFP-0: 43-73; DFP-1: 43-73"
    Option         "MetaModes"          "1920x1080, 1920x1080"
    Option         "ConnectedMonitor"   "DFP-0, DFP-1"
    Option         "MetaModeOrientation" "DFP-1 LeftOf DFP-0"
EndSection

Section "Screen"
    Identifier     "metaScreen"
    Device         "Card0"
    Monitor        "Monitor0"
    DefaultDepth    24
    Option         "TwinView" "True"
    SubSection "Display"
        Modes          "1920x1080"
    EndSubSection
EndSection
}}
```
[Device option information](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/configtwinview.html).

If you have multiple cards that are SLI capable, it is possible to run more than one monitor attached to separate cards
(for example: two cards in SLI with one monitor attached to each). The \"MetaModes\" option in conjunction with SLI
Mosaic mode enables this. Below is a configuration which works for the aforementioned example and runs
[GNOME](GNOME "wikilink") flawlessly.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-monitor.conf|
Section "Device"
        Identifier      "Card A"
        Driver          "nvidia"
        BusID           "PCI:1:00:0"
EndSection

Section "Device"
        Identifier      "Card B"
        Driver          "nvidia"
        BusID           "PCI:2:00:0"
EndSection

Section "Monitor"
        Identifier      "Right Monitor"
EndSection

Section "Monitor"
        Identifier      "Left Monitor"
EndSection

Section "Screen"
        Identifier      "Right Screen"
        Device          "Card A"
        Monitor         "Right Monitor"
        DefaultDepth    24
        Option          "SLI" "Mosaic"
        Option          "Stereo" "0"
        Option          "BaseMosaic" "True"
        Option          "MetaModes" "GPU-0.DFP-0: 1920x1200+4480+0, GPU-1.DFP-0:1920x1200+0+0"
        SubSection      "Display"
                        Depth           24
        EndSubSection
EndSection

Section "Screen"
        Identifier      "Left Screen"
        Device          "Card B"
        Monitor         "Left Monitor"
        DefaultDepth    24
        Option          "SLI" "Mosaic"
        Option          "Stereo" "0"
        Option          "BaseMosaic" "True"
        Option          "MetaModes" "GPU-0.DFP-0: 1920x1200+4480+0, GPU-1.DFP-0:1920x1200+0+0"
        SubSection      "Display"
                        Depth           24
        EndSubSection
EndSection

Section "ServerLayout"
        Identifier      "Default"
        Screen 0        "Right Screen" 0 0
        Option          "Xinerama" "0"
EndSection
}}
```
##### Vertical sync using TwinView {#vertical_sync_using_twinview}

If you are using TwinView and vertical sync (the *Sync to VBlank* option in `{{ic|nvidia-settings}}`{=mediawiki}), you
will notice that only one screen is being properly synced, unless you have two identical monitors. Although
`{{ic|nvidia-settings}}`{=mediawiki} does offer an option to change which screen is being synced (the *Sync to this
display device* option), this does not always work. A solution is to add the following environment variables at startup,
for example append in `{{ic|/etc/profile}}`{=mediawiki}:

`export __GL_SYNC_TO_VBLANK=1`\
`export __GL_SYNC_DISPLAY_DEVICE=DFP-0`\
`export VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE=DFP-0`

You can change `{{ic|DFP-0}}`{=mediawiki} with your preferred screen (`{{ic|DFP-0}}`{=mediawiki} is the DVI port and
`{{ic|CRT-0}}`{=mediawiki} is the VGA port). You can find the identifier for your display from
`{{ic|nvidia-settings}}`{=mediawiki} in the *X Server XVideoSettings* section.

##### Gaming using TwinView {#gaming_using_twinview}

In case you want to play full-screen games when using TwinView, you will notice that games recognize the two screens as
being one big screen. While this is technically correct (the virtual X screen really is the size of your screens
combined), you probably do not want to play on both screens at the same time.

To correct this behavior for SDL 1.2, try:

`export SDL_VIDEO_FULLSCREEN_HEAD=1`

For OpenGL, add the appropriate Metamodes to your xorg.conf in section `{{ic|Device}}`{=mediawiki} and restart X:

`Option "Metamodes" "1680x1050,1680x1050; 1280x1024,1280x1024; 1680x1050,NULL; 1280x1024,NULL;"`

Another method that may either work alone or in conjunction with those mentioned above is [starting games in a separate
X server](Gaming#Starting_games_in_a_separate_X_server "wikilink").

#### Mosaic mode {#mosaic_mode}

Mosaic mode is the only way to use more than 2 monitors across multiple graphics cards with compositing. Your window
manager may or may not recognize the distinction between each monitor. Mosaic mode requires a valid SLI configuration.
Even if using Base mode without SLI, the GPUs must still be SLI capable/compatible.

##### Base Mosaic {#base_mosaic}

Base Mosaic mode works on any set of Geforce 8000 series or higher GPUs. It cannot be enabled from within the
nvidia-setting GUI. You must either use the *nvidia-xconfig* command line program or edit `{{ic|xorg.conf}}`{=mediawiki}
by hand. Metamodes must be specified. The following is an example for four DFPs in a 2x2 configuration, each running at
1920x1024, with two DFPs connected to two cards:

`# nvidia-xconfig --base-mosaic --metamodes="GPU-0.DFP-0: 1920x1024+0+0, GPU-0.DFP-1: 1920x1024+1920+0, GPU-1.DFP-0: 1920x1024+0+1024, GPU-1.DFP-1: 1920x1024+1920+1024"`

```{=mediawiki}
{{Note|While the documentation lists a 2x2 configuration of monitors, [https://forums.developer.nvidia.com/t/basemosaic-v295-vs-v310-vs-v325-only-up-to-three-screens/30583#3954733 GeForce cards are artificially limited to 3 monitors] in Base Mosaic mode. Quadro cards support more than 3 monitors. As of September 2014, the Windows driver has dropped this artificial restriction, but it remains in the Linux driver.}}
```
##### SLI Mosaic {#sli_mosaic}

If you have an SLI configuration and each GPU is a Quadro FX 5800, Quadro Fermi or newer, then you can use SLI Mosaic
mode. It can be enabled from within the nvidia-settings GUI or from the command line with:

`# nvidia-xconfig --sli=Mosaic --metamodes="GPU-0.DFP-0: 1920x1024+0+0, GPU-0.DFP-1: 1920x1024+1920+0, GPU-1.DFP-0: 1920x1024+0+1024, GPU-1.DFP-1: 1920x1024+1920+1024"`

## NVswitch

```{=mediawiki}
{{Style|Multiple little fixes needed, the instructions about fabric manager should be made into an AUR package.}}
```
For systems with NVswitch, like H100x8 on AWS, the following is need.

-   install nvidia-fabricmanager
-   install matching kernel module needed by the fabric manager

With the fabricmanager, pytorch would report no GPU is found.

To install the fabric manager:

1.  download the tarball from nvidia.
    [here](https://developer.download.nvidia.com/compute/cuda/redist/fabricmanager/linux-x86_64/)
2.  version 555.42.02 works well
3.  modify the install script in sbin/fm_run_package_installer.sh to fix the installed file path

To get the matching kernel driver:

1.  git clone the AUR for nvidia-beta-dkms and nvidia-utils-beta
2.  change the PKGBUILD to use version 555.42.02
3.  build and install them
4.  reboot

finally, `{{ic|systemctl enable nvidia-fabricmanager}}`{=mediawiki} and
`{{ic|systemctl start nvidia-fabricmanager}}`{=mediawiki}, then pytorch should work.

## Tips and tricks {#tips_and_tricks}

See [NVIDIA/Tips and tricks](NVIDIA/Tips_and_tricks "wikilink").

## Troubleshooting

See [NVIDIA/Troubleshooting](NVIDIA/Troubleshooting "wikilink").

## See also {#see_also}

-   [Current graphics driver releases in official NVIDIA
    Forum](https://forums.developer.nvidia.com/t/current-graphics-driver-releases/28500)
-   [NVIDIA Developers Forum - Linux Subforum](https://forums.developer.nvidia.com/c/gpu-graphics/linux/148)

[Category:Graphics](Category:Graphics "wikilink") [Category:X server](Category:X_server "wikilink")

[de:Intel](de:Intel "wikilink") [es:Intel graphics](es:Intel_graphics "wikilink") [ja:Intel
graphics](ja:Intel_graphics "wikilink") [ru:Intel graphics](ru:Intel_graphics "wikilink") [zh-hans:Intel
graphics](zh-hans:Intel_graphics "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|Intel GMA 3600}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki} `{{Related|Kernel mode setting}}`{=mediawiki}
`{{Related|Xrandr}}`{=mediawiki} `{{Related|Hybrid graphics}}`{=mediawiki} `{{Related|Vulkan}}`{=mediawiki}
`{{Related|General-purpose computing on graphics processing units}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

Since Intel provides and supports open source drivers, Intel graphics are essentially plug-and-play.

For a comprehensive list of Intel GPU models and corresponding chipsets and CPUs, see [Wikipedia:Intel Graphics
Technology](Wikipedia:Intel_Graphics_Technology "wikilink") and [Gentoo:Intel#Feature
support](Gentoo:Intel#Feature_support "wikilink").

```{=mediawiki}
{{Note|
* PowerVR-based graphics ([[Intel GMA 3600|GMA 3600]] series) are not supported by open source drivers.
* Intel's Gen''N'' hardware does not refer to the generation of the CPU, it refers to the [[Wikipedia:List of Intel graphics processing units|generation of the GPU]], which is different from the generation of the CPU. 
* See [[Xorg#Driver installation]] to identify your card. 
}}
```
## Installation

-   [Install](Install "wikilink") one of the following packages, which provide the
    [DRI](wikipedia:Direct_Rendering_Infrastructure "wikilink") driver for 3D acceleration.
    -   ```{=mediawiki}
        {{Pkg|mesa}}
        ```
        is the up-to-date [Mesa](Mesa "wikilink") package which includes the modern Gallium3D drivers for Gen 3 hardware
        and later. This is the recommended choice.

    -   ```{=mediawiki}
        {{Pkg|mesa-amber}}
        ```
        is the legacy Mesa package which includes the classic (non-Gallium3D) drivers from Gen 2 to Gen 11 hardware.
        This driver might have better performance or stability for Gen 7 and older hardware, but is unmaintained.
-   For 32-bit application support, also install the `{{Pkg|lib32-mesa}}`{=mediawiki} or
    `{{Pkg|lib32-mesa-amber}}`{=mediawiki} package from the [multilib](multilib "wikilink") repository.
-   For the [DDX](wikipedia:X.Org_Server#DDX "wikilink") driver which provides 2D acceleration in
    [Xorg](Xorg "wikilink"), use one of the following drivers:
    -   The *modesetting* driver included in the `{{Pkg|xorg-server}}`{=mediawiki} package is the recommended choice for
        Gen 3 hardware and later. It uses the DRI driver for acceleration via *glamor*.
    -   The `{{Pkg|xf86-video-intel}}`{=mediawiki} package provides the legacy intel DDX driver from Gen 2 to Gen 9
        hardware. This package is generally not recommended, see note below.
-   For [Vulkan](Vulkan "wikilink") support (Broadwell and newer; support for earlier chips is [incomplete or
    missing](https://gitlab.freedesktop.org/mesa/mesa/-/issues/8249#note_1758622)), install the
    `{{Pkg|vulkan-intel}}`{=mediawiki} package. For 32-bit [Vulkan](Vulkan "wikilink") support, install the
    `{{Pkg|lib32-vulkan-intel}}`{=mediawiki} package.

Also see [Hardware video acceleration](Hardware_video_acceleration "wikilink").

```{=mediawiki}
{{Note|1=<nowiki/>
* Some ([https://www.phoronix.com/scan.php?page=news_item&px=Ubuntu-Debian-Abandon-Intel-DDX Debian & Ubuntu], [https://www.phoronix.com/scan.php?page=news_item&px=Fedora-Xorg-Intel-DDX-Switch Fedora], [https://community.kde.org/Plasma/5.9_Errata#Intel_GPUs KDE], [https://bugzilla.mozilla.org/show_bug.cgi?id=1710400 Mozilla]) recommend not installing the {{Pkg|xf86-video-intel}} driver, and instead falling back on the modesetting driver. See [https://web.archive.org/web/20160714232204/https://www.reddit.com/r/archlinux/comments/4cojj9/it_is_probably_time_to_ditch_xf86videointel/], [https://www.phoronix.com/scan.php?page=article&item=intel-modesetting-2017&num=1], [[Xorg#Installation]], and {{man|4|modesetting}}. However, the modesetting driver can cause problems such as [https://gitlab.freedesktop.org/xorg/xserver/-/issues/1364 screen tearing and mouse jittering on XFCE], [https://bugs.chromium.org/p/chromium/issues/detail?id=370022 artifacts when switching virtual desktops in Chromium], and [https://gitlab.freedesktop.org/xorg/xserver/-/issues/928 vsync jitter/video stutter in mpv].
* The {{Pkg|xf86-video-intel}} driver does not have proper support for Gen 11 and newer hardware, causing lack of acceleration and rendering issues that make Plasma Desktop almost unusable. See [https://gitlab.freedesktop.org/xorg/driver/xf86-video-intel/-/commit/7181c5a41c3f00eaf996caa156523c708a18081e].
* There have been a couple of reports [https://bbs.archlinux.org/viewtopic.php?id=263323] [https://github.com/qutebrowser/qutebrowser/issues/4641] where the whole graphics stack hard freezes when {{Pkg|xf86-video-intel}} is installed, not even switching to a different virtual console works (by pressing {{ic|Ctrl+Alt+F''n''}}), only killing the user processes with [[SysRq]] works.
}}
```
## Loading

The Intel kernel module should load fine automatically on system boot.

If it does not happen, then:

-   Make sure you do **not** have `{{ic|nomodeset}}`{=mediawiki} as a [kernel parameter](kernel_parameter "wikilink"),
    since Intel requires kernel mode-setting.
-   Also, check that you have not disabled Intel by using any modprobe blacklisting within
    `{{ic|/etc/modprobe.d/}}`{=mediawiki} or `{{ic|/usr/lib/modprobe.d/}}`{=mediawiki}.

### Early KMS {#early_kms}

[Kernel mode setting](Kernel_mode_setting "wikilink") (KMS) is supported by the `{{ic|i915}}`{=mediawiki} and
`{{ic|xe}}`{=mediawiki} drivers, and is enabled early since [mkinitcpio](mkinitcpio "wikilink") v32, as the
`{{ic|kms}}`{=mediawiki} [hook](Mkinitcpio#Common_hooks "wikilink") is included by default. For other setups, see
[Kernel mode setting#Early KMS start](Kernel_mode_setting#Early_KMS_start "wikilink") for instructions on how to enable
KMS as soon as possible at the boot process.

### Enable GuC / HuC firmware loading {#enable_guc_huc_firmware_loading}

Starting with Gen9 (Skylake and onwards), Intel GPUs include a *Graphics micro (μ) Controller* (GuC) which provides the
following functionality:

-   Offloading some media decoding functionality from the CPU to the *HEVC/H.265 micro (µ) Controller* (HuC). Only
    applicable if using `{{Pkg|intel-media-driver}}`{=mediawiki} for [hardware video
    acceleration](hardware_video_acceleration "wikilink"). Introduced with Gen9.
-   Using the GuC for scheduling, context submission, and power management. Introduced with Alder Lake-P (Mobile),
    within Gen12.

To use this functionality, first ensure that `{{Pkg|linux-firmware-intel}}`{=mediawiki} is
[installed](install "wikilink"), as it provides the GuC and HuC firmware files.

Next, the GuC firmware must be loaded. With regards to HuC support, some video features (e.g. CBR rate control on SKL
low-power encoding mode) require loading the HuC firmware as well
[1](https://github.com/intel/media-driver#known-issues-and-limitations).

The [new experimental](#Testing_the_new_experimental_Xe_driver "wikilink") `{{ic|xe}}`{=mediawiki} driver enables Guc
and Huc functionality by default.

For the `{{ic|i915}}`{=mediawiki} driver, GuC functionality is controlled by the `{{ic|enable_guc}}`{=mediawiki} [kernel
module parameter](kernel_module_parameter "wikilink"). Its usage is as follows:

```{=mediawiki}
{{Accuracy|Despite Intel's documentation, Tiger Lake and Rocket Lake GPUs may actually support {{ic|1=enable_guc=3}}, and have a default of {{ic|1=enable_guc=1}}.|Talk:Intel graphics#TGL/RKL GuC Submission}}
```
+------------------+-----------------+----------------------+-------------------------+-------------------------+
| enable_guc value | GuC Submission  | HuC Firmware Loading | Default for platforms   | Supported on platforms  |
+==================+=================+======================+=========================+=========================+
| 0                | ```{=mediawiki} | ```{=mediawiki}      | Tiger Lake, Rocket      | All                     |
|                  | {{No}}          | {{No}}               | Lake, and Pre-Gen12     |                         |
|                  | ```             | ```                  | [2](https://git         |                         |
|                  |                 |                      | hub.com/torvalds/linux/ |                         |
|                  |                 |                      | blob/b3454ce0b2c8a56e76 |                         |
|                  |                 |                      | 0e6baa88ed10278585072b/ |                         |
|                  |                 |                      | drivers/gpu/drm/i915/gt |                         |
|                  |                 |                      | /uc/intel_uc.c#L26-L36) |                         |
+------------------+-----------------+----------------------+-------------------------+-------------------------+
| 1                | ```{=mediawiki} | ```{=mediawiki}      | {{-}}                   | Alder Lake-P (Mobile)   |
|                  | {{Yes}}         | {{No}}               |                         | and newer               |
|                  | ```             | ```                  |                         |                         |
+------------------+-----------------+----------------------+-------------------------+-------------------------+
| 2                | ```{=mediawiki} | ```{=mediawiki}      | Alder Lake-S (Desktop)  | Gen9 and newer          |
|                  | {{No}}          | {{Yes}}              | [3](https://git         |                         |
|                  | ```             | ```                  | hub.com/torvalds/linux/ |                         |
|                  |                 |                      | blob/b3454ce0b2c8a56e76 |                         |
|                  |                 |                      | 0e6baa88ed10278585072b/ |                         |
|                  |                 |                      | drivers/gpu/drm/i915/gt |                         |
|                  |                 |                      | /uc/intel_uc.c#L38-L42) |                         |
|                  |                 |                      | [4](https://lo          |                         |
|                  |                 |                      | re.kernel.org/all/87ee6 |                         |
|                  |                 |                      | wit2r.fsf@intel.com/T/) |                         |
+------------------+-----------------+----------------------+-------------------------+-------------------------+
| 3                | ```{=mediawiki} | ```{=mediawiki}      | Alder Lake-P (Mobile)   | Gen 9.5 and newer       |
|                  | {{Yes}}         | {{Yes}}              | and newer               | (better for some)       |
|                  | ```             | ```                  |                         |                         |
+------------------+-----------------+----------------------+-------------------------+-------------------------+

If GuC submission or HuC firmware loading is not enabled by default for your GPU, you can manually enable it.

```{=mediawiki}
{{Warning|1=Manually enabling GuC / HuC firmware loading taints the kernel [https://bugs.freedesktop.org/show_bug.cgi?id=111918 even when the feature is not supported]. Moreover, enabling GuC/HuC firmware loading can cause issues on some systems; disable it if you experience freezing (for example, after resuming from hibernation).}}
```
Set the `{{ic|1=enable_guc=}}`{=mediawiki} [kernel module parameter](kernel_module_parameter "wikilink"). For example,
with:

```{=mediawiki}
{{hc|/etc/modprobe.d/i915.conf|2=
options i915 enable_guc=3
}}
```
[Regenerate the initramfs](Regenerate_the_initramfs "wikilink"), on next boot you can verify both GuC and HuC are
enabled by using [dmesg](dmesg "wikilink"):

```{=mediawiki}
{{hc|# dmesg {{!}}
```
grep -i -e \'huc\' -e \'guc\'\|2= \[30130.586970\] i915 0000:00:02.0: \[drm\] GuC firmware i915/icl_guc_33.0.0.bin
version 33.0 submission:disabled \[30130.586973\] i915 0000:00:02.0: \[drm\] HuC firmware i915/icl_huc_9.0.0.bin version
9.0 authenticated:yes }}

If they are not supported by your graphics adapter you will see:

```{=mediawiki}
{{hc|# dmesg {{!}}
```
grep -i -e \'huc\' -e \'guc\'\|2= \[ 0.571339\] i915 0000:00:02.0: \[drm\] Incompatible option enable_guc=2 - GuC is not
supported! \[ 0.571340\] i915 0000:00:02.0: \[drm\] Incompatible option enable_guc=2 - HuC is not supported! }}

Alternatively, check using:

`# less /sys/kernel/debug/dri/*/gt0/uc/guc_info`\
`# less /sys/kernel/debug/dri/*/gt0/uc/huc_info`

```{=mediawiki}
{{Note|1=Using [[Intel GVT-g|GVT-g graphics virtualization]] by setting {{ic|1=enable_gvt=1}} is not supported as of Linux 4.20.11 when GuC/HuC is also enabled. The i915 module would fail to initialize as shown in system journal.

{{hc|# journalctl|
... kernel: [drm:intel_gvt_init [i915]] *ERROR* i915 GVT-g loading failed due to Graphics virtualization is not yet supported with GuC submission
... kernel: i915 0000:00:02.0: [drm:i915_driver_load [i915]] Device initialization failed (-5)
... kernel: i915: probe of 0000:00:02.0 failed with error -5
... kernel: snd_hda_intel 0000:00:1f.3: failed to add i915 component master (-19)
}}

Note that the related warning  is not fatal, as explained in [https://github.com/intel/gvt-linux/issues/77#issuecomment-707541069]:

{{hc|# journalctl -b |
... kernel: i915 0000:00:02.0: Direct firmware load for i915/gvt/vid_0x8086_did_0x5916_rid_0x02.golden_hw_state failed with error -2
}}
}}
```
## Xorg configuration {#xorg_configuration}

There is generally no need for any configuration to run [Xorg](Xorg "wikilink").

However, to take advantage of some driver options or if [Xorg](Xorg "wikilink") does not start, you can create an Xorg
configuration file.

### With the modesetting driver {#with_the_modesetting_driver}

If you have installed `{{Pkg|xf86-video-intel}}`{=mediawiki} but want to load the modesetting driver explicitly instead
of letting the DDX driver take priority, for example when trying to compare them:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-intel.conf|
Section "Device"
  Identifier "Intel Graphics"
  Driver "modesetting"
EndSection
}}
```
### With the Intel driver {#with_the_intel_driver}

```{=mediawiki}
{{Note|The following requires {{Pkg|xf86-video-intel}}.}}
```
Create an Xorg configuration file similar to the one below:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-intel.conf|
Section "Device"
  Identifier "Intel Graphics"
  Driver "intel"
EndSection
}}
```
Additional options are added by the user on new lines below `{{ic|Driver}}`{=mediawiki}. For the full list of options,
see the `{{man|4|intel}}`{=mediawiki} man page.

```{=mediawiki}
{{Note|You might need to add more device sections than the one listed above. This will be indicated where necessary.}}
```
#### AccelMethod

You may need to indicate `{{ic|Option "AccelMethod"}}`{=mediawiki} when creating a configuration file, the classical
options are `{{ic|UXA}}`{=mediawiki}, `{{ic|SNA}}`{=mediawiki} (default) and `{{ic|BLT}}`{=mediawiki}.

If you experience issues with default `{{ic|SNA}}`{=mediawiki} (e.g. pixelated graphics, corrupt text, etc.), try using
`{{ic|UXA}}`{=mediawiki} instead, which can be done by adding the following line to your [configuration
file](#Xorg_configuration "wikilink"):

`Option      "AccelMethod"  "uxa"`

See the \"AccelMethod\" option under `{{man|4|intel|CONFIGURATION DETAILS}}`{=mediawiki}.

#### Using Intel DDX driver with recent GPUs {#using_intel_ddx_driver_with_recent_gpus}

For Intel GPUs starting from Gen8 (Broadwell), the Iris Mesa driver is needed:

`Option      "DRI"  "iris"`

#### Disabling TearFree, TripleBuffer, SwapbuffersWait {#disabling_tearfree_triplebuffer_swapbufferswait}

If you use a compositor (the default in modern desktop environment like GNOME, KDE Plasma, Xfce, etc.), then TearFree,
TripleBuffer and SwapbuffersWait can usually be disabled to improve performance and decrease power consumption.

`Option      "TearFree"        "false"`\
`Option      "TripleBuffer"    "false"`\
`Option      "SwapbuffersWait" "false"`

## Module-based options {#module_based_options}

The `{{ic|i915}}`{=mediawiki} kernel module allows for configuration via [module
options](Kernel_modules#Setting_module_options "wikilink"). Some of the module options impact power saving.

A list of all options along with short descriptions and default values can be generated with the following command:

`$ modinfo -p i915`

To check which options are currently enabled, run

`# systool -m i915 -av`

You will note that many options default to -1, resulting in per-chip powersaving defaults. It is however possible to
configure more aggressive powersaving by using [module options](Kernel_modules#Setting_module_options "wikilink").

```{=mediawiki}
{{Note|1=Diverting from the defaults will mark the kernel as [https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=fc9740cebc3ab7c65f3c5f6ce0caf3e4969013ca tainted] from Linux 3.18 onwards. This basically implies using other options than the per-chip defaults is considered experimental and not supported by the developers. }}
```
### Framebuffer compression (enable_fbc) {#framebuffer_compression_enable_fbc}

Framebuffer compression (FBC) is a feature that can reduce power consumption and memory bandwidth during screen
refreshes.

The feature will be automatically enabled if supported by the hardware. You can use the command below to verify whether
it is enabled:

```{=mediawiki}
{{hc|$ modinfo i915 {{!}}
```
grep enable_fbc\| parm: enable_fbc:Enable frame buffer compression for power savings (default: -1 (use per-chip
default)) (int) }}

If the parm is set to `{{ic|-1}}`{=mediawiki}, you do not need to do anything. Otherwise, to force-enable FBC, use
`{{ic|1=i915.enable_fbc=1}}`{=mediawiki} as [kernel parameter](kernel_parameter "wikilink") or set in
`{{ic|/etc/modprobe.d/i915.conf}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/modprobe.d/i915.conf|2=
options i915 enable_fbc=1
}}
```
```{=mediawiki}
{{Note|Framebuffer compression may be unreliable or unavailable on Intel GPU generations before Sandy Bridge (generation 6). This results in messages logged to the system journal similar to this one:

 kernel: drm: not enough stolen space for compressed buffer, disabling.

Enabling frame buffer compression on pre-Sandy Bridge CPUs results in endless error messages:

{{hc|# dmesg|
[ 2360.475430] [drm] not enough stolen space for compressed buffer (need 4325376 bytes), disabling
[ 2360.475437] [drm] hint: you may be able to increase stolen memory size in the BIOS to avoid this
}}

The solution is to disable frame buffer compression which will imperceptibly increase power consumption (around 0.06 W). In order to disable it add {{ic|1=i915.enable_fbc=0}} to the kernel line parameters. More information on the results of disabled compression can be found [https://web.archive.org/web/20200228230053/https://kernel.ubuntu.com/~cking/power-benchmarking/background-colour-and-framebuffer-compression/ here].}}
```
### Fastboot

```{=mediawiki}
{{Note|1=This parameter is enabled by default for Skylake and newer[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d6535cbed4a4b029602ff83efb2adec7cb8d28b] as well as Bay- and Cherry-Trail (VLV/CHV)[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7360c9f6b857e22a48e545f4e99c79630994e932] since Linux 5.1[https://kernelnewbies.org/Linux_5.1#Graphics],
has subsequently been removed completely since Linux 6.7[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=58883680a8416661b48a800e5530e2efcea64a4a], and fastboot has finally been enabled for all GPU generations (including those older than Skylake) since Linux 6.9.[https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1b923307a1b0067a302b394e73311aeaebc06f65]}}
```
The goal of Intel Fastboot is to preserve the frame-buffer as setup by the BIOS or [boot loader](boot_loader "wikilink")
to avoid any flickering until [Xorg](Xorg "wikilink") has
started.[5](https://lists.freedesktop.org/archives/intel-gfx/2012-May/017653.html)[6](https://www.phoronix.com/scan.php?page=news_item&px=MTEwNzc)

To force enable fastboot on platforms where it is not the default already, set `{{ic|1=i915.fastboot=1}}`{=mediawiki} as
[kernel parameter](kernel_parameter "wikilink") or set in `{{ic|/etc/modprobe.d/i915.conf}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/modprobe.d/i915.conf|2=
options i915 fastboot=1
}}
```
### Intel GVT-g graphics virtualization support {#intel_gvt_g_graphics_virtualization_support}

See [Intel GVT-g](Intel_GVT-g "wikilink") for details.

### Enable performance support {#enable_performance_support}

Starting with Gen6 (Sandy Bridge and onwards), Intel GPUs provide performance counters used for exposing internal
performance data to drivers. The drivers and hardware registers refer to this infrastructure as the *Observation
Architecture* (internally \"OA\") [7](https://www.phoronix.com/scan.php?page=news_item&px=Intel-HSW-Observation-Arch),
but Intel\'s documentation also more generally refers to this functionality as providing *Observability Performance
Counters*
[8](https://01.org/sites/default/files/documentation/observability_performance_counters_haswell.pdf)`{{Dead link|2023|09|16|status=404}}`{=mediawiki}
[9](https://01.org/sites/default/files/documentation/intel-gfx-prm-osrc-skl-vol14-observability.pdf)`{{Dead link|2023|09|16|status=404}}`{=mediawiki}.

By default, only programs running with the [CAP_SYS_ADMIN](https://lwn.net/Articles/486306/) (equivalent to root) or
[CAP_PERFMON](https://lwn.net/Articles/812719/) [capabilities](capabilities "wikilink") can utilize the observation
architecture
[10](https://github.com/torvalds/linux/blob/b14ffae378aa1db993e62b01392e70d1e585fb23/drivers/gpu/drm/i915/i915_perf.c#L267)
[11](https://github.com/torvalds/linux/blob/b14ffae378aa1db993e62b01392e70d1e585fb23/drivers/gpu/drm/i915/i915_perf.c#L3481-L3484).
Most applications will be running without either of these, resulting in the following warning:

`MESA-INTEL: warning: Performance support disabled, consider sysctl dev.i915.perf_stream_paranoid=0`

To enable performance support without using the capabilities (or root), set the kernel parameter as described in
[sysctl](sysctl "wikilink").

```{=mediawiki}
{{Warning|The restrictive defaults of the {{ic|perf_event_paranoid}} family of options exists because there is risk associated with allowing applications to access performance data [https://docs.kernel.org/admin-guide/perf-security.html]. With this being said, {{ic|dev.i915.perf_stream_paranoid}} only influences access to GPU performance counters, which carry less risk than e.g. CPU architectural execution context registers.}}
```
## Tips and tricks {#tips_and_tricks}

### Setting scaling mode {#setting_scaling_mode}

This can be useful for some full screen applications:

`$ xrandr --output LVDS1 --set PANEL_FITTING `*`param`*

where `{{ic|''param''}}`{=mediawiki} can be:

-   ```{=mediawiki}
    {{ic|center}}
    ```
    : resolution will be kept exactly as defined, no scaling will be made,

-   ```{=mediawiki}
    {{ic|full}}
    ```
    : scale the resolution so it uses the entire screen or

-   ```{=mediawiki}
    {{ic|full_aspect}}
    ```
    : scale the resolution to the maximum possible but keep the aspect ratio.

If it does not work, try:

`$ xrandr --output LVDS1 --set "scaling mode" `*`param`*

where `{{ic|''param''}}`{=mediawiki} is one of `{{ic|"Full"}}`{=mediawiki}, `{{ic|"Center"}}`{=mediawiki} or
`{{ic|"Full aspect"}}`{=mediawiki}.

```{=mediawiki}
{{Note|1=This option currently does not work for external displays (e.g. VGA, DVI, HDMI, DP). [https://bugs.freedesktop.org/show_bug.cgi?id=90989]}}
```
### Overriding reported OpenGL version {#overriding_reported_opengl_version}

The `{{ic|MESA_GL_VERSION_OVERRIDE}}`{=mediawiki} [environment variable](environment_variable "wikilink") can be used to
override the reported OpenGL version to any application. For example, setting
`{{ic|1=MESA_GL_VERSION_OVERRIDE=4.5}}`{=mediawiki} will report OpenGL 4.5.

```{=mediawiki}
{{Note|You can use this variable to report any known OpenGL version, even if it is not supported by the GPU. Some applications might no longer crash, some may start crashing - you probably do not want to set this variable globally.}}
```
### Monitoring

See [Hardware video acceleration#Verification](Hardware_video_acceleration#Verification "wikilink").

### Setting brightness and gamma {#setting_brightness_and_gamma}

See [Backlight](Backlight "wikilink").

### Testing the new experimental Xe driver {#testing_the_new_experimental_xe_driver}

To try the (experimental) [new Xe driver](https://docs.kernel.org/gpu/xe/index.html), you need:

-   ```{=mediawiki}
    {{pkg|linux}}
    ```
    6.8 or above

-   [Tiger Lake](Wikipedia:Tiger_Lake "wikilink") integrated graphics and newer, or a discrete graphics card.

-   ```{=mediawiki}
    {{Pkg|mesa}}
    ```
    .

Note your PCI ID with:

```{=mediawiki}
{{hc|$ lspci -nnd ::03xx|
00:02.0 VGA compatible controller [0300]: Intel Corporation TigerLake-LP GT2 [Iris Xe Graphics] [8086:'''9a49'''] (rev 01)
}}
```
Then add the following to your [Kernel parameters](Kernel_parameter "wikilink") with the appropriate PCI ID:

`... i915.force_probe=!`**`9a49`**` xe.force_probe=`**`9a49`**

Make sure you have an alternate solution to boot in order to revert if necessary.

## Troubleshooting

### Tearing

#### With the Intel driver {#with_the_intel_driver_1}

The SNA acceleration method causes tearing on some machines. To fix this, enable the `{{ic|TearFree}}`{=mediawiki}
option in the `{{Pkg|xf86-video-intel}}`{=mediawiki} driver by adding the following line to your [configuration
file](#Xorg_configuration "wikilink"):

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-intel.conf|
Section "Device"
  Identifier "Intel Graphics"
  Driver "intel"
  Option "TearFree" "true"
EndSection}}
```
See the [original bug report](https://bugs.freedesktop.org/show_bug.cgi?id=37686) for more info.

```{=mediawiki}
{{Note|1=<nowiki/>
* This option may not work when {{ic|SwapbuffersWait}} is {{ic|false}}.
* This option may increase memory allocation considerably and reduce performance. [https://bugs.freedesktop.org/show_bug.cgi?id=37686#c123]
* This option is problematic for applications that are very picky about vsync timing, like [[Wikipedia:Super Meat Boy|Super Meat Boy]].
* This option does not work with UXA acceleration method, only with SNA.
* For Intel UHD 620 or 630 you will need to add {{ic|Option "TripleBuffer" "true"}} in order for {{ic|TearFree}} to work.
* It might be necessary to disable DRI3 by adding {{ic|Option "DRI" "2"}}, otherwise any full screen app (such as video playback) can break TearFree. [https://bugs.freedesktop.org/show_bug.cgi?id=96847#c7]
}}
```
#### With the modesetting driver {#with_the_modesetting_driver_1}

TearFree support [was added](https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/1006) to the modesetting
driver
[12](https://www.phoronix.com/news/xf86-video-modesetting-TearFree)[13](https://www.phoronix.com/news/Modesetting-TearFree-Merged).
As the last release for the non-XWayland servers was the 21.1 release in 2021, this patch has not reached a stable
release, so you will need `{{AUR|xorg-server-git}}`{=mediawiki} until then.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-intel.conf|
Section "Device"
  Identifier "Intel Graphics"
  Driver "modesetting"
  Option "TearFree" "true"
EndSection}}
```
### Disable Vertical Synchronization (VSYNC) {#disable_vertical_synchronization_vsync}

Useful when:

-   Chromium/Chrome has lags and slow performance due to GPU and runs smoothly with \--disable-gpu switch
-   glxgears test does not show desired performance

The intel-driver uses [Triple
Buffering](https://www.intel.com/content/www/us/en/support/articles/000006930/graphics.html) for vertical
synchronization; this allows for full performance and avoids tearing. To turn vertical synchronization off (e.g. for
benchmarking) use this `{{ic|.drirc}}`{=mediawiki} in your home directory:

```{=mediawiki}
{{hc|~/.drirc|2=
<device screen="0" driver="dri2">
    <application name="Default">
        <option name="vblank_mode" value="0"/>
    </application>
</device>
}}
```
### DRI3 issues {#dri3_issues}

*DRI3* is the default DRI version in `{{Pkg|xf86-video-intel}}`{=mediawiki}. On some systems this can cause issues such
as [this](https://bugs.chromium.org/p/chromium/issues/detail?id=370022). To switch back to *DRI2* add the following line
to your [configuration file](#Xorg_configuration "wikilink"):

`Option "DRI" "2"`

For the `{{ic|modesetting}}`{=mediawiki} driver, this method of disabling DRI3 does not work. Instead, one can set the
environment variable `{{ic|1=LIBGL_DRI3_DISABLE=1}}`{=mediawiki}.

### Missing glyphs in GTK applications {#missing_glyphs_in_gtk_applications}

Should you experience missing font glyphs in GTK applications, the following workaround might help.
[Edit](textedit "wikilink") `{{ic|/etc/environment}}`{=mediawiki} to add the following line:

```{=mediawiki}
{{hc|/etc/environment|output=
COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer
}}
```
See also [FreeDesktop bug 88584](https://bugs.freedesktop.org/show_bug.cgi?id=88584).

### Corrupted and frozen graphics {#corrupted_and_frozen_graphics}

If you experience corrupted and/or frozen graphics in some applications (such as random colors filling the application
window, extreme unreasonable blurriness, an application failing to update its graphics at all while performing other
tasks without lag, etc), try running the application with [OpenGL](OpenGL "wikilink") instead of
[Vulkan](Vulkan "wikilink"). This has occurred on some configurations with Intel Arc GPUs.

### X freeze/crash with intel driver {#x_freezecrash_with_intel_driver}

Some issues with X crashing, GPU hanging, or problems with X freezing, can be fixed by disabling the GPU usage with the
`{{ic|NoAccel}}`{=mediawiki} option - add the following lines to your [configuration
file](#Xorg_configuration "wikilink"):

`  Option "NoAccel" "True"`

Alternatively, try to disable the 3D acceleration only with the `{{ic|DRI}}`{=mediawiki} option:

`  Option "DRI" "False"`

### Adding undetected resolutions {#adding_undetected_resolutions}

This issue is covered on the [Xrandr page](Xrandr#Adding_undetected_resolutions "wikilink").

### Backlight is not adjustable {#backlight_is_not_adjustable}

If after resuming from suspend, the hotkeys for changing the screen brightness do not take effect, check your
configuration against the [Backlight](Backlight "wikilink") article.

If the problem persists, try one of the following [kernel parameters](kernel_parameters "wikilink"):

`acpi_osi=Linux`\
`acpi_osi="!Windows 2012"`\
`acpi_osi=`

Also make sure you are not using fastboot mode (`{{ic|i915.fastboot}}`{=mediawiki} kernel parameter), it is
[known](https://www.phoronix.com/forums/forum/software/mobile-linux/1066447-arch-linux-users-with-intel-graphics-can-begin-enjoying-a-flicker-free-boot)
for breaking backlight controls.

### Corruption or unresponsiveness in Chromium and Firefox {#corruption_or_unresponsiveness_in_chromium_and_firefox}

If you experience corruption, unresponsiveness, lags or slow performance in Chromium and/or Firefox some possible
solutions are:

-   [Set the AccelMethod to \"uxa\"](#AccelMethod "wikilink")
-   [Disable VSYNC](#Disable_Vertical_Synchronization_(VSYNC) "wikilink")
-   [Enable the TearFree option](#Tearing "wikilink")
-   Disable \"DRI\" and acceleration method (tested on Intel Iris 10th generation): `{{bc|<nowiki>
    Option "NoAccel" "True"
    Option "DRI" "False"
    </nowiki>}}`{=mediawiki}

### Kernel crashing w/kernels 4.0+ on Broadwell/Core-M chips {#kernel_crashing_wkernels_4.0_on_broadwellcore_m_chips}

A few seconds after X/Wayland loads the machine will freeze and [journalctl](journalctl "wikilink") will log a kernel
crash referencing the Intel graphics as below:

`Jun 16 17:54:03 hostname kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)`\
`Jun 16 17:54:03 hostname kernel: IP: [<          (null)>]           (null)`\
`...`\
`Jun 16 17:54:03 hostname kernel: CPU: 0 PID: 733 Comm: gnome-shell Tainted: G     U     O    4.0.5-1-ARCH #1`\
`...`\
`Jun 16 17:54:03 hostname kernel: Call Trace:`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffffa055cc27>`{=html}`] ? i915_gem_object_sync+0xe7/0x190 [i915]`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffffa0579634>`{=html}`] intel_execlists_submission+0x294/0x4c0 [i915]`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffffa05539fc>`{=html}`] i915_gem_do_execbuffer.isra.12+0xabc/0x1230 [i915]`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffffa055d349>`{=html}`] ? i915_gem_object_set_to_cpu_domain+0xa9/0x1f0 [i915]`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffff811ba2ae>`{=html}`] ? __kmalloc+0x2e/0x2a0`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffffa0555471>`{=html}`] i915_gem_execbuffer2+0x141/0x2b0 [i915]`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffffa042fcab>`{=html}`] drm_ioctl+0x1db/0x640 [drm]`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffffa0555330>`{=html}`] ? i915_gem_execbuffer+0x450/0x450 [i915]`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffff8122339b>`{=html}`] ? eventfd_ctx_read+0x16b/0x200`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffff811ebc36>`{=html}`] do_vfs_ioctl+0x2c6/0x4d0`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffff811f6452>`{=html}`] ? __fget+0x72/0xb0`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffff811ebec1>`{=html}`] SyS_ioctl+0x81/0xa0`\
`Jun 16 17:54:03 hostname kernel:  [``<ffffffff8157a589>`{=html}`] system_call_fastpath+0x12/0x17`\
`Jun 16 17:54:03 hostname kernel: Code:  Bad RIP value.`\
`Jun 16 17:54:03 hostname kernel: RIP  [<          (null)>]           (null)`

This can be fixed by disabling execlist support which was changed to default on with kernel 4.0. Add the following
[kernel parameter](kernel_parameter "wikilink"):

`i915.enable_execlists=0`

This is known to be broken to at least kernel 4.0.5.

### Lag in Windows guests {#lag_in_windows_guests}

The video output of a Windows guest in VirtualBox sometimes hangs until the host forces a screen update (e.g. by moving
the mouse cursor). Removing the `{{ic|1=enable_fbc=1}}`{=mediawiki} option fixes this issue.

### Screen flickering {#screen_flickering}

Panel Self Refresh (PSR), a power saving feature used by Intel iGPUs is known to cause flickering in some instances
`{{Bug|49628}}`{=mediawiki} `{{Bug|49371}}`{=mediawiki} `{{Bug|50605}}`{=mediawiki}. A temporary solution is to disable
this feature using the [kernel parameter](kernel_parameter "wikilink") `{{ic|1=i915.enable_psr=0}}`{=mediawiki} or
`{{ic|1=xe.enable_psr=0}}`{=mediawiki}.

This can solve error messages like `{{ic|[i915] *ERROR* CPU pipe A FIFO underrun}}`{=mediawiki}.

### OpenGL 2.1 with i915 driver {#opengl_2.1_with_i915_driver}

The classic mesa driver for Gen 3 GPUs included in the `{{Pkg|mesa-amber}}`{=mediawiki} package reports OpenGL 2.0 by
default, because the hardware is not fully compatible with OpenGL
2.1.[14](https://www.phoronix.com/scan.php?page=news_item&px=Mesa-i915-OpenGL-2-Drop) OpenGL 2.1 support can be enabled
manually by setting `{{ic|/etc/drirc}}`{=mediawiki} or `{{ic|~/.drirc}}`{=mediawiki} options like:

```{=mediawiki}
{{hc|/etc/drirc|output=
<driconf>
...
    <device driver="i915">
        <application name="Default">
            <option name="'''stub_occlusion_query'''" value="'''true'''" />
            <option name="'''fragment_shader'''" value="'''true'''" />
        </application>
    </device>
...
</driconf>
}}
```
```{=mediawiki}
{{Note|
* The reason of this step back was Chromium and other applications' bad experience. If needed, you might edit the drirc file in a "app-specific" style, see [https://dri.freedesktop.org/wiki/ConfigurationInfrastructure/ here], to disable OpenGL 2.1 on executable {{ic|chromium}} for instance.
* The new Gallium based i915 driver included in {{Pkg|mesa}} package always reports OpenGL 2.1, so this setting is not needed for that driver.}}
```
### KMS Issue: console is limited to small area {#kms_issue_console_is_limited_to_small_area}

One of the low-resolution video ports may be enabled on boot which is causing the terminal to utilize a small area of
the screen. To fix, explicitly disable the port with an i915 module setting with `{{ic|1=video=SVIDEO-1:d}}`{=mediawiki}
in the kernel command line parameter in the boot loader. See [Kernel parameters](Kernel_parameters "wikilink") for more
info.

If that does not work, try disabling TV1 or VGA1 instead of SVIDEO-1. Video port names can be listed with
[xrandr](xrandr "wikilink").

### No sound through HDMI on a Haswell CPU {#no_sound_through_hdmi_on_a_haswell_cpu}

According to a [Linux kernel issue](https://bugzilla.kernel.org/show_bug.cgi?id=60769), sound will not be output through
HDMI if `{{ic|1=intel_iommu=on}}`{=mediawiki}. To fix this problem, use the following [kernel
parameter](kernel_parameter "wikilink"):

`intel_iommu=on,igfx_off`

Or alternatively, disable IOMMU:

`intel_iommu=off`

### Crash/freeze on low power Intel CPUs {#crashfreeze_on_low_power_intel_cpus}

```{=mediawiki}
{{Accuracy|{{ic|1=enable_dc=0}} may not impede on power management to the extent claimed here.|section=Incorrect statements regarding power usage penalty of enable_dc=0}}
```
Low-powered Intel processors and/or laptop processors have a tendency to randomly hang or crash due to the problems with
the power management features found in low-power Intel chips. If such a crash happens, you will not see any logs
reporting this problem. Adding the following [Kernel parameters](Kernel_parameters "wikilink") may help to resolve the
problem.

```{=mediawiki}
{{Note|It is not advised to use all three of the below kernel parameters together.}}
```
`intel_idle.max_cstate=1 i915.enable_dc=0 ahci.mobile_lpm_policy=1`

```{=mediawiki}
{{ic|1=ahci.mobile_lpm_policy=1}}
```
fixes a hang on several Lenovo laptops and some Acer notebooks due to problematic SATA controller power management. That
workaround is strictly not related to Intel graphics but it does solve related issues. Adding this kernel parameter sets
the *l*ink *p*ower *m*anagement from firmware default to maximum performance and will also solve hangs when you change
display brightness on certain Lenovo machines but increases idle power consumption by 1-1.5 W on modern ultrabooks. For
further information, especially about the other states, see the [Linux kernel mailing
list](https://lore.kernel.org/lkml/20171211165216.5604-1-hdegoede@redhat.com/) and [Red Hat
documentation](https://access.redhat.com/documentation/en-en/red_hat_enterprise_linux/6/html/power_management_guide/alpm).

```{=mediawiki}
{{ic|1=i915.enable_dc=0}}
```
disables GPU power management. This does solve random hangs on certain Intel systems, notably Goldmount and Kaby Lake
Refresh chips. Using this parameter does result in higher power use and shorter battery life on laptops/notebooks. If
this helps, you can try finer-grained DC limitations as documented in `{{ic|1=modinfo i915 {{!}}`{=mediawiki} grep
enable_dc}}.

```{=mediawiki}
{{ic|1=intel_idle.max_cstate=1}}
```
limits the processors sleep states, it prevents the processor from going into deep sleep states. That is absolutely not
ideal and does result in higher power use and lower battery life. However, it does solve random hangs on many Intel
systems. Use this if you have a Intel Baytrail or a Kaby Lake Refresh chip. Intel \"Baytrail\" chips were known to
randomly hang without this kernel parameter due to a [hardware
flaw](https://bugzilla.kernel.org/show_bug.cgi?id=109051#c752), theoretically fixed
[2019-04-26](https://gitlab.freedesktop.org/drm/i915/kernel/-/commit/a75d035fedbdecf83f86767aa2e4d05c8c4ffd95). More
information about the max_cstate parameter can be found in the [kernel
documentation](https://docs.kernel.org/admin-guide/pm/intel_idle.html#kernel-command-line-options-and-module-parameters)
and about the cstates in general on a [writeup on GitHub](https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7).

If you try adding `{{ic|1=intel_idle.max_cstate=1 i915.enable_dc=0 ahci.mobile_lpm_policy=1}}`{=mediawiki} in the hope
of fixing frequent hangs and that solves the issue you should later remove one by one to see which of them actually
helped you solve the issue. Running with cstates and display power management disabled is not advisable if the actual
problem is related to SATA power management and `{{ic|1=ahci.mobile_lpm_policy=1}}`{=mediawiki} is the one that actually
solves it.

Check [Linux Reviews](https://linuxreviews.org/Intel_graphics#Kernel_Parameters) for more details.

#### Higher C-states prevent wakeup from S3 {#higher_c_states_prevent_wakeup_from_s3}

In case you infrequently wake up to a black screen, but the system otherwise properly resumes with
`{{ic|CPU pipe A FIFO underrun}}`{=mediawiki} messages in the journal and limiting
`{{ic|1=intel_idle.max_cstate=1}}`{=mediawiki} reliably prevents that, [you
can](https://bbs.archlinux.org/viewtopic.php?pid=2175597#p2175597) use [Suspend and hibernate#Sleep
hooks](Suspend_and_hibernate#Sleep_hooks "wikilink") and `{{man|1|cpupower-idle-set}}`{=mediawiki} to effectively
control the C-state around the suspend cycle with `{{ic|-D0}}`{=mediawiki} and `{{ic|-E}}`{=mediawiki} to not
permanently run the CPU in the lowest C-state.

### Add support for 165Hz monitor {#add_support_for_165hz_monitor}

```{=mediawiki}
{{Merge|Kernel mode setting#Forcing modes and EDID|This technique does not appear to be specific to i915. Before merging, one should verify that the install script is necessary, and that there is not an easier way to add the EDID BIN to the initramfs.}}
```
For some 165Hz monitors, *xrandr* might not display the 165Hz option, and the fix in [#Adding undetected
resolutions](#Adding_undetected_resolutions "wikilink") does not solve this. In this case, see
[i915-driver-stuck-at-40hz-on-165hz-screen](https://unix.stackexchange.com/questions/680356/i915-driver-stuck-at-40hz-on-165hz-screen).

```{=mediawiki}
{{Note|Other than creating {{ic|/etc/initramfs-tools/hooks/edid}}, a [[mkinitcpio]] hook should be made:

{{hc|/etc/initcpio/install/edid|
#!/bin/bash

build() {
    add_file /lib/firmware/edid/edid.bin
}

help() {
    cat <<HELPEOF
This hook add support for 165Hz
HELPEOF
}
}}

Then append ''edid'' in HOOKS of {{ic|/etc/mkinitcpio.conf}}, Just like this:

{{hc|/etc/mkinitcpio.conf|2=
HOOKS=(... fsck edid)
}}

Then [[regenerate the initramfs]]. 
}}
```
### Freeze after wake from sleep/suspend with Raptor Lake and Alder Lake-P {#freeze_after_wake_from_sleepsuspend_with_raptor_lake_and_alder_lake_p}

Users with Raptor Lake and Alder Lake-P 12th gen mobile processor laptops from various vendors experienced freeze and
black-screen after waking up from suspending. It is because many laptop vendors ship an incorrect VBT (Video BIOS
Table), as described in freedesktop issues [5531](https://gitlab.freedesktop.org/drm/intel/-/issues/5531)
[6401](https://gitlab.freedesktop.org/drm/intel/-/issues/6401), that wrongly describe the actual ports connected to the
iGPU. In this case, all of the documented cases concern duplicate eDP entries.

Considering most vendors [will not](https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/7402) publish a BIOS update
for a laptop with a properly working Windows OS, Linux users could only address the issue on the kernel side. There are
two methods for a user to prevent the duplicate eDP entries from affecting the kernel: [patching the
kernel](https://bbs.archlinux.org/viewtopic.php?id=284176) or [loading a modified
VBT](https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/7709).

For patching the kernel, the duplicate eDP entry needs to be identified by analyzing the output of:

```{=mediawiki}
{{hc|# intel_vbt_decode /sys/kernel/debug/dri/1/i915_vbt|
 Child device info:
        Device handle: 0x0008 (LFP 1 (eDP))
        Device type: 0x1806 (unknown)
 ...
 Child device info:
        Device handle: 0x0080 (LFP 2 (eDP))
        Device type: 0x1806 (unknown)
}}
```
This shows that there is in fact a duplicate eDP, and the kernel should ignore the second entry, but the user is still
encouraged to check this. This can then be patched with the following kernel patch in which the index of the duplicate
screen can be substituted for `{{ic|ignoreEntry {{=}}`{=mediawiki} 1}} if it needs be.

`--- a/drivers/gpu/drm/i915/display/intel_bios.c`\
`+++ b/drivers/gpu/drm/i915/display/intel_bios.c`\
`@@ -3688,6 +3688,14 @@`\
`{`\
`       struct intel_bios_encoder_data *devdata;`\
\
`+       int ignoreEntry = 0;`\
`+`\
`       list_for_each_entry(devdata, &i915->display.vbt.display_devices, node)`\
`-               func(i915, devdata);`\
`+       {`\
`+               if (ignoreEntry != 1)`\
`+               {`\
`+                       func(i915, devdata);`\
`+                       ignoreEntry++;`\
`+               }`\
`+       }`\
`}`

A second way to solve this is to edit the VBT by directly [erasing the duplicate entry from the
VBT](https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/7709).

This works by copying the VBT and editing it with a hex editor and changing the device type corresponding with the
duplicate device handle to `{{ic|00 00}}`{=mediawiki}:

`$ cat /sys/kernel/debug/dri/0/i915_vbt > vbt`

`--- vbt`\
`+++ modified_vbt`\
`@@ -22,10 +22,10 @@`\
` 00000150  00 08 00 20 00 08 00 10  00 08 00 02 00 08 00 01  |... ............|`\
` 00000160  00 08 00 00 01 08 00 00  00 04 00 00 00 40 00 00  |.............@..|`\
` 00000170  00 20 00 00 00 10 00 00  00 02 00 00 00 01 00 00  |. ..............|`\
`-00000180  00 00 01 00 00 02 8b 01  02 04 00 00 27 08 00 06  |............'...|`\
`-00000190  18 00 00 00 00 00 00 00  00 00 00 00 00 0a 00 00  |................|`\
`+00000180  00 00 01 00 00 02 8b 01  02 04 00 00 27 08 00 00  |............'...|`\
`+00000190  00 00 00 00 00 00 00 00  00 00 00 00 00 0a 00 00  |................|`\
` 000001a0  03 00 00 00 c0 00 40 00  20 00 00 00 00 00 00 00  |......@. .......|`\
`-000001b0  00 00 20 00 80 00 06 18  00 00 00 00 00 00 00 00  |.. .............|`\
`+000001b0  00 00 20 00 80 00 00 00  00 00 00 00 00 00 00 00  |.. .............|`\
` 000001c0  00 00 00 00 07 00 00 00  00 00 00 c0 00 10 00 20  |............... |`\
``  000001d0  00 00 00 00 00 00 00 00  00 20 00 04 00 d2 60 00  |......... ....`.| ``\
` 000001e0  10 10 00 23 21 10 00 00  00 00 00 07 00 00 02 00  |...#!...........|`

The modified VBT can then be loaded by copying it to `{{ic|/lib/firmware/modified_vbt}}`{=mediawiki} passing
`{{ic|i915.vbt_firmware{{=}}`{=mediawiki}modified_vbt}} as a kernel parameter and, if required, [regenerate the
initramfs](regenerate_the_initramfs "wikilink").

### Washed out colors {#washed_out_colors}

By default some monitors might not be recognized properly by the Intel GPU and have washed out colors because it\'s not
in full-range RGB mode.

#### Fix colors for Wayland {#fix_colors_for_wayland}

```{=mediawiki}
{{hc|/etc/udev/rules.d/80-i915.rules|
ACTION{{=}}
```
{{=}}\"add\", SUBSYSTEM{{=}}{{=}}\"module\", KERNEL{{=}}{{=}}\"i915\",
RUN+{{=}}\"/usr/local/bin/intel-wayland-fix-full-color\" }}

```{=mediawiki}
{{hc|/usr/local/bin/intel-wayland-fix-full-color|<nowiki>
#!/bin/bash

readarray -t proptest_result <<<"$(/usr/bin/proptest -M i915 -D /dev/dri/card0 | grep -E 'Broadcast|Connector')"

for ((i = 0; i < ${#proptest_result[*]}; i += 2)); do
    connector=$(echo ${proptest_result[i]} | awk '{print $2}')
    connector_id=$(echo ${proptest_result[i + 1]} | awk '{print $1}')

    /usr/bin/proptest -M i915 $connector connector $connector_id 1
done
</nowiki>}}
```
If you are using [GNOME](GNOME "wikilink"), [an
alternative](https://gitlab.gnome.org/GNOME/mutter/-/issues/1871#note_2090262) is to add
`{{ic|<rgbrange>full</rgbrange>}}`{=mediawiki} to the `{{ic|~/.config/monitors.xml}}`{=mediawiki} configuration. For
example:

```{=mediawiki}
{{hc|~/.config/monitors.xml|<nowiki>
<monitors version="2">
  <configuration>
    <layoutmode>logical</layoutmode>
    <logicalmonitor>
      <x>0</x>
      <y>0</y>
      <primary>yes</primary>
      <monitor>
        <monitorspec>
          <connector>HDMI-1</connector>
          <vendor>MetaProduct&apos;s Inc.</vendor>
          <product>MetaMonitor</product>
          <serial>0x123456</serial>
        </monitorspec>
        <mode>
          <width>1920</width>
          <height>1080</height>
          <rate>60.000</rate>
        </mode>
        <rgbrange>full</rgbrange>
      </monitor>
    </logicalmonitor>
  </configuration>
</monitors>
</nowiki>}}
```
```{=mediawiki}
{{Note|
* If displays are rearranged or display settings changed in any other way, a new layout might be added to {{ic|monitors.xml}} file without the {{ic|<rgbrange>full</rgbrange>}} tag. To ensure the RGB range is consistently set across different layouts, consider adding the tag to every duplicated entry of the logical monitor.
* If GDM login screen is not using full RGB range, copy user's {{ic|monitors.xml}} to gdm's home directory. See [[GDM#Setup default monitor settings]]
}}
```
#### Fix colors for X11/Xorg {#fix_colors_for_x11xorg}

`# xrandr --output NAME_OF_YOUR_OUTPUT --set "Broadcast RGB" "Full"`

### Unable to run some programs, \"bus error\" with B580 {#unable_to_run_some_programs_bus_error_with_b580}

When getting an error like this when running some programs (eg. vainfo, falkon, mpv\...):

`1234 bus error : vaapi`

The probable cause could be disabled ReBar (Resizable BAR) in BIOS/UEFI. Some motherboards may allow to enable ReBar
only when UEFI mode is active, without legacy support.

## See also {#see_also}

-   [linux
    graphics](https://www.intel.com/content/www/us/en/support/articles/000005520/graphics.html?wapkw=linux%20graphics)
    (includes a list of 106 related products)
-   [Intel® Processor
    Graphics](https://www.intel.com/content/www/us/en/developer/articles/guide/intel-graphics-developers-guides.html?wapkw=linux%20graphics)
    (includes a table of processor series, former code name, launch date and graphics technology)

[Category:Graphics](Category:Graphics "wikilink") [Category:X server](Category:X_server "wikilink")

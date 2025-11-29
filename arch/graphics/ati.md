[de:ATI](de:ATI "de:ATI"){.wikilink} [ja:ATI](ja:ATI "ja:ATI"){.wikilink} [ru:ATI](ru:ATI "ru:ATI"){.wikilink}
[zh-hans:ATI](zh-hans:ATI "zh-hans:ATI"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|AMDGPU}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

This article covers the [radeon](https://wiki.freedesktop.org/xorg/radeon/) open source driver which supports older AMD
(previously ATI) GPUs.

## Selecting the right driver {#selecting_the_right_driver}

Depending on the card you have, find the right driver in [Xorg#AMD](Xorg#AMD "Xorg#AMD"){.wikilink}. This page has
instructions for **ATI**.

If unsure, try the [AMDGPU](AMDGPU "AMDGPU"){.wikilink} driver first, it will suit most needs for cards released since
2015. See the [feature matrix](https://www.x.org/wiki/RadeonFeature) to know what is supported by this driver and the
[decoding table](Wikipedia:List_of_AMD_graphics_processing_units#Features_overview "decoding table"){.wikilink} to
translate marketing names (e.g. Radeon HD4330) to chip names (e.g. R700).

## Installation

[Install](Install "Install"){.wikilink} the `{{Pkg|mesa}}`{=mediawiki} package, which provides both the DRI driver for
3D acceleration and VA-API/VDPAU drivers for [accelerated video
decoding](Hardware_video_acceleration#AMD/ATI "accelerated video decoding"){.wikilink}. Or
`{{Pkg|mesa-amber}}`{=mediawiki} for very old GPUs ([R200](Wikipedia:Radeon_R200_series "R200"){.wikilink} and prior).

```{=mediawiki}
{{Accuracy|The modesetting driver may not work in all cases, this section should be worded more carefully. See the related note in [[Intel graphics#Installation]].}}
```
- For 32-bit application support, also install the `{{Pkg|lib32-mesa}}`{=mediawiki}
  (`{{Pkg|lib32-mesa-amber}}`{=mediawiki}) package from the [multilib](multilib "multilib"){.wikilink} repository.
- For the DDX driver (which provides 2D acceleration in [Xorg](Xorg "Xorg"){.wikilink}), you can install the
  `{{Pkg|xf86-video-ati}}`{=mediawiki} package. However, it is not required since default modesetting driver exists.

## Loading

The radeon kernel module should load fine automatically on system boot.

If it does not happen, then:

- Make sure you do **not** have `{{ic|nomodeset}}`{=mediawiki} or `{{ic|1=vga=}}`{=mediawiki} as a [kernel
  parameter](kernel_parameter "kernel parameter"){.wikilink}, since radeon requires [KMS](KMS "KMS"){.wikilink}.
- Also, check that you have not disabled radeon by using any [kernel module
  blacklisting](Kernel_modules#Blacklisting "kernel module blacklisting"){.wikilink}.

## Xorg configuration {#xorg_configuration}

Xorg will automatically load the driver and it will use your monitor\'s EDID to set the native resolution. Configuration
is only required for tuning the driver.

If you want manual configuration, create `{{ic|/etc/X11/xorg.conf.d/20-radeon.conf}}`{=mediawiki}, and add the
following:

`Section "OutputClass"`\
`    Identifier "Radeon"`\
`    MatchDriver "radeon"`\
`    Driver "radeon"`\
`EndSection`

Using this section, you can enable features and tweak the driver settings.

## Performance tuning {#performance_tuning}

### Enabling video acceleration {#enabling_video_acceleration}

See [Hardware video
acceleration#AMD/ATI](Hardware_video_acceleration#AMD/ATI "Hardware video acceleration#AMD/ATI"){.wikilink}.

### Graphical tools {#graphical_tools}

- ```{=mediawiki}
  {{App|radeon-profile|Qt application for displaying info about a Radeon card.|https://github.com/marazmista/radeon-profile|{{AUR|radeon-profile-git}}}}
  ```

- ```{=mediawiki}
  {{App|CoreCtrl|Popular general purpose GPU/CPU controller. See their [https://gitlab.com/corectrl/corectrl/-/wikis/Setup Setup] page for advanced usage.|https://gitlab.com/corectrl/corectrl|{{Pkg|corectrl}}}}
  ```

### Driver options {#driver_options}

The following options apply to `{{ic|/etc/X11/xorg.conf.d/'''20-radeon.conf'''}}`{=mediawiki}.

Please read `{{man|4|radeon}}`{=mediawiki} and [RadeonFeature](https://www.x.org/wiki/RadeonFeature/#index4h2) first
before applying driver options.

**Acceleration architecture**; Glamor is available as a 2D acceleration method implemented through OpenGL, and it [is
the
default](https://gitlab.freedesktop.org/xorg/driver/xf86-video-ati/-/commit/f11531c99fcd6473f58b4d10efaf3efd84304d8e)
for R600 (Radeon HD2000 series) and newer graphic cards. Older cards use EXA.

`Option "AccelMethod" "glamor"`

**DRI3** is enabled by default [since xf86-video-ati
7.8.0](https://www.phoronix.com/scan.php?page=news_item&px=Radeon-AMDGPU-1.19-Updates).

**TearFree** is a tearing prevention option which prevents tearing by using the hardware page flipping mechanism:

`Option "TearFree" "on"`

**ColorTiling** and **ColorTiling2D** are supposed to be enabled by default. Tiled mode can provide significant
performance benefits with 3D applications. It is disabled if the DRM module is too old or if the current display
configuration does not support it. KMS ColorTiling2D is only supported on R600 (Radeon HD2000 series) and newer chips:

`Option "ColorTiling" "on"`\
`Option "ColorTiling2D" "on"`

When using Glamor as acceleration architecture, it is possible to enable the **ShadowPrimary** option, which enables a
so-called \"shadow primary\" buffer for fast CPU access to pixel data, and separate scanout buffers for each display
controller (CRTC). This may improve performance for some 2D workloads, potentially at the expense of other (e.g. 3D,
video) workloads. Note that enabling this option currently disables Option \"EnablePageFlip\":

`Option "ShadowPrimary" "on"`

**EXAVSync** is only available when using EXA and can be enabled to avoid tearing by stalling the engine until the
display controller has passed the destination region. It reduces tearing at the cost of performance and has been known
to cause instability on some chips:

`Option "EXAVSync" "yes"`

Below is a sample configuration file of `{{ic|/etc/X11/xorg.conf.d/'''20-radeon.conf'''}}`{=mediawiki}:

`Section "OutputClass"`\
`  Identifier "Radeon"`\
`  MatchDriver "radeon"`\
`  Driver "radeon"`\
`  Option "AccelMethod" "glamor"`\
`  Option "DRI" "3"`\
`  Option "TearFree" "on"`\
`  Option "ColorTiling" "on"`\
`  Option "ColorTiling2D" "on"`\
`EndSection`

### Kernel parameters {#kernel_parameters}

```{=mediawiki}
{{Tip|You may want to debug the new parameters with {{ic|systool}} as stated in [[Kernel modules#Obtaining information]].}}
```
Defining the **gartsize**, if not autodetected, can be done by adding `{{ic|1=radeon.gartsize=32}}`{=mediawiki} as a
[kernel parameter](kernel_parameter "kernel parameter"){.wikilink}.

```{=mediawiki}
{{Note|Setting this parameter should not be needed anymore with modern AMD video cards:
{{bc|1=
[drm] Detected VRAM RAM=2048M, BAR=256M
[drm] radeon: 2048M of VRAM memory ready
[drm] radeon: 2048M of GTT memory ready.
}}
}}
```
The changes take effect at the next reboot.

#### Deactivating PCIe 2.0 {#deactivating_pcie_2.0}

Since kernel 3.6, PCI Express 2.0 in **radeon** is turned on by default.

It may be unstable with some motherboards. It can be deactivated by adding `{{ic|1=radeon.pcie_gen2=0}}`{=mediawiki} as
a [kernel parameter](kernel_parameter "kernel parameter"){.wikilink}.

See [Phoronix article](https://www.phoronix.com/scan.php?page=article&item=amd_pcie_gen2&num=1) for more information.

### Gallium Heads-Up Display {#gallium_heads_up_display}

The radeon driver supports the activation of a heads-up display (HUD) which can draw transparent graphs and text on top
of applications that are rendering, such as games. These can show values such as the current frame rate or the CPU load
for each CPU core or an average of all of them. The HUD is controlled by the GALLIUM_HUD environment variable, and can
be passed the following list of parameters among others:

- \"fps\" - displays current frames per second
- \"cpu\" - displays the average CPU load
- \"cpu0\" - displays the CPU load for the first CPU core
- \"cpu0+cpu1\" - displays the CPU load for the first two CPU cores
- \"draw-calls\" - displays how many times each material in an object is drawn to the screen
- \"requested-VRAM\" - displays how much VRAM is being used on the GPU
- \"samples-passed\" - displays how many pixels are being displayed

To see a full list of parameters, as well as some notes on operating GALLIUM_HUD, you can also pass the \"help\"
parameter to a simple application such as glxgears and see the corresponding terminal output:

`# GALLIUM_HUD="help" glxgears`

More information can be found from this [mailing list
post](https://lists.freedesktop.org/archives/mesa-dev/2013-March/036586.html) or [this blog
post](https://kparal.wordpress.com/2014/03/03/fraps-like-fps-overlay-for-linux/).

## Hybrid graphics/AMD Dynamic Switchable Graphics {#hybrid_graphicsamd_dynamic_switchable_graphics}

It is the technology used on recent laptops equiped with two GPUs, one power-efficent (generally Intel integrated card)
and one more powerful and more power-hungry (generally Radeon or Nvidia). There are two ways to get it work:

- If it is not required to run \'GPU-hungry\' applications, it is possible to disable the discrete card (see [Ubuntu
  wiki](https://help.ubuntu.com/community/HybridGraphics#Using_vga_switcheroo)):
  `{{bc|# echo OFF > /sys/kernel/debug/vgaswitcheroo/switch}}`{=mediawiki}
- [PRIME](PRIME "PRIME"){.wikilink}: Is a proper way to use hybrid graphics on Linux, but still requires a bit of manual
  intervention from the user.

## Powersaving

```{=mediawiki}
{{Note|Power management is supported on all chips that include the appropriate power state tables in the vbios (R1xx and newer). "dpm" is only supported on R6xx and newer chips.}}
```
You can choose between three different methods:

1.  [dpm](#Dynamic_power_management "dpm"){.wikilink} (enabled by default since kernel 3.13)
2.  [dynpm](#Dynamic_frequency_switching "dynpm"){.wikilink}
3.  [profile](#Profile-based_frequency_switching "profile"){.wikilink}

See <https://www.x.org/wiki/RadeonFeature/#index3h2> for more details.

### Dynamic power management {#dynamic_power_management}

Since kernel 3.13, DPM is enabled by default for [lots of AMD Radeon
hardware](https://kernelnewbies.org/Linux_3.13#head-f95c198f6fdc7defe36f470dc8369cf0e16898df). If you want to disable it
and use another method instead, add the parameter `{{ic|1=radeon.dpm=0}}`{=mediawiki} to the [kernel
parameters](kernel_parameters "kernel parameters"){.wikilink}.

```{=mediawiki}
{{Tip|DPM works on R6xx gpus, but is not enabled by default in the kernel (only R7xx and up). Setting the {{ic|1=radeon.dpm=1}} kernel parameter will enable dpm.}}
```
Unlike [dynpm](#Dynamic_frequency_switching "dynpm"){.wikilink}, the \"dpm\" method uses hardware on the GPU to
dynamically change the clocks and voltage based on GPU load. It also enables clock and power gating.

There are 3 operation modes to choose from:

- ```{=mediawiki}
  {{ic|battery}}
  ```
  lowest power consumption

- ```{=mediawiki}
  {{ic|balanced}}
  ```
  sane default

- ```{=mediawiki}
  {{ic|performance}}
  ```
  highest performance

They can be changed via sysfs:

`# echo battery > /sys/class/drm/card0/device/power_dpm_state`

For testing or debugging purposes, you can force the card to run in a set performance mode:

- ```{=mediawiki}
  {{ic|auto}}
  ```
  default; uses all levels in the power state

- ```{=mediawiki}
  {{ic|low}}
  ```
  enforces the lowest performance level

- ```{=mediawiki}
  {{ic|high}}
  ```
  enforces the highest performance level

`# echo low > /sys/class/drm/card0/device/power_dpm_force_performance_level`

#### Command-line tools {#command_line_tools}

- [radcard](https://github.com/superjamie/snippets/blob/master/sh/radcard) - A script to get and set DPM power states
  and levels

### Old methods {#old_methods}

#### Dynamic frequency switching {#dynamic_frequency_switching}

This method dynamically changes the frequency depending on GPU load, so performance is ramped up when running GPU
intensive applications, and ramped down when the GPU is idle. The re-clocking is attempted during vertical blanking
periods, but due to the timing of the re-clocking functions, does not always complete in the blanking period, which can
lead to flicker in the display. Due to this, dynamic power management only works when a single head is active.

It can be activated by simply running the following command:

`# echo dynpm > /sys/class/drm/card0/device/power_method`

#### Profile-based frequency switching {#profile_based_frequency_switching}

This method will allow you to select one of the five profiles (described below). Different profiles, for the most part,
end up changing the frequency/voltage of the GPU. This method is not as aggressive, but is more stable and flicker free
and works with multiple heads active.

To activate the method, run the following command:

`# echo profile > /sys/class/drm/card0/device/power_method`

Select one of the available profiles:

- ```{=mediawiki}
  {{ic|default}}
  ```
  uses the default clocks and does not change the power state. This is the default behaviour.

- ```{=mediawiki}
  {{ic|auto}}
  ```
  selects between `{{ic|mid}}`{=mediawiki} and `{{ic|high}}`{=mediawiki} power states based on the whether the system is
  on battery power or not.

- ```{=mediawiki}
  {{ic|low}}
  ```
  forces the gpu to be in the `{{ic|low}}`{=mediawiki} power state all the time. Note that `{{ic|low}}`{=mediawiki} can
  cause display problems on some laptops, which is why `{{ic|auto}}`{=mediawiki} only uses `{{ic|low}}`{=mediawiki} when
  monitors are off. Selected on other profiles when the monitors are in the [DPMS](DPMS "DPMS"){.wikilink}-off state.

- ```{=mediawiki}
  {{ic|mid}}
  ```
  forces the gpu to be in the `{{ic|mid}}`{=mediawiki} power state all the time.

- ```{=mediawiki}
  {{ic|high}}
  ```
  forces the gpu to be in the `{{ic|high}}`{=mediawiki} power state all the time.

As an example, we will activate the `{{ic|low}}`{=mediawiki} profile (replace `{{ic|low}}`{=mediawiki} with any of the
aforementioned profiles as necessary):

`# echo low > /sys/class/drm/card0/device/power_profile`

### Persistent configuration {#persistent_configuration}

The methods described above are not persistent. To make them persistent, you may create a [udev](udev "udev"){.wikilink}
rule (example for [#Profile-based frequency
switching](#Profile-based_frequency_switching "#Profile-based frequency switching"){.wikilink}):

```{=mediawiki}
{{hc|/etc/udev/rules.d/30-radeon-pm.rules|2=
KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="radeon", ATTR{device/power_method}="profile", ATTR{device/power_profile}="low"
}}
```
As another example, [dynamic power management](#Dynamic_power_management "dynamic power management"){.wikilink} can be
permanently forced to a certain performance level:

```{=mediawiki}
{{hc|/etc/udev/rules.d/30-radeon-pm.rules|2=
KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="radeon", ATTR{device/power_dpm_force_performance_level}="high"
}}
```
### Other notes {#other_notes}

To view the speed that the GPU is running at, perform the following command and you will get something like this output:

```{=mediawiki}
{{hc|# cat /sys/kernel/debug/dri/0/radeon_pm_info|
state: PM_STATE_ENABLED
default engine clock: 300000 kHz
current engine clock: 300720 kHz
default memory clock: 200000 kHz
}}
```
It depends on which GPU line yours is, however. Along with the radeon driver versions, kernel versions, etc. So it may
not have much/any voltage regulation at all.

Thermal sensors are implemented via external i2c chips or via the internal thermal sensor (rv6xx-evergreen only). To get
the temperature on asics that use i2c chips, you need to load the appropriate hwmon driver for the sensor used on your
board (lm63, lm64, etc.). The drm will attempt to load the appropriate hwmon driver. On boards that use the internal
thermal sensor, the drm will set up the hwmon interface automatically. When the appropriate driver is loaded, the
temperatures can be accessed via [lm_sensors](lm_sensors "lm_sensors"){.wikilink} tools or via sysfs in
`{{ic|/sys/class/hwmon}}`{=mediawiki}.

## Fan speed {#fan_speed}

While the power saving features above should handle fan speeds quite well, some cards may still be too noisy in their
idle state. In this case, and when your card supports it, you can change the fan speed manually.

```{=mediawiki}
{{Warning|
* Keep in mind that the following method sets the fan speed to a fixed value, hence it will not adjust with the stress of the GPU, which can lead to overheating under heavy load.
* Check GPU temperature when applying lower than standard values.
}}
```
To control the GPU fan, see [Fan speed control#AMDGPU sysfs fan
control](Fan_speed_control#AMDGPU_sysfs_fan_control "Fan speed control#AMDGPU sysfs fan control"){.wikilink} (amdgpu and
radeon share the same controls for this).

For persistence, see the example in [#Persistent
configuration](#Persistent_configuration "#Persistent configuration"){.wikilink}.

If a fixed value is not desired, there are possibilities to define a custom fan curve manually by, for example, writing
a script in which fan speeds are set depending on the current temperature (current value in
`{{ic|/sys/class/drm/card0/device/hwmon/hwmon0/temp1_input}}`{=mediawiki}).

A GUI solution is available by installing `{{AUR|radeon-profile-git}}`{=mediawiki}.

## TV out {#tv_out}

First, check that you have an S-video output: `{{ic|xrandr}}`{=mediawiki} should give you something like

`Screen 0: minimum 320x200, current 1024x768, maximum 1280x1200`\
`...`\
`S-video disconnected (normal left inverted right x axis y axis)`

Now we should tell Xorg that it is actually connected (it *is*, right?)

`xrandr --output S-video --set "load detection" 1`

Setting TV standard to use:

`xrandr --output S-video --set "tv standard" ntsc`

Adding a mode for it (currently supports only 800x600):

`xrandr --addmode S-video 800x600`

Clone mode:

`xrandr --output S-video --same-as VGA-0`

Now let us try to see what we have:

`xrandr --output S-video --mode 800x600`

At this point, you should see a 800x600 version of your desktop on your TV.

To disable the output, do

`xrandr --output S-video --off`

### Force TV-out in KMS {#force_tv_out_in_kms}

The kernel can recognize `{{ic|1=video=}}`{=mediawiki} parameter in following form (see [KMS](KMS "KMS"){.wikilink} for
more details):

`video=``<conn>`{=html}`:``<xres>`{=html}`x``<yres>`{=html}`[M][R][-``<bpp>`{=html}`][@``<refresh>`{=html}`][i][m][eDd]`

For example:

`video=DVI-I-1:1280x1024-24@60e`

Parameters with whitespaces must be quoted:

`"video=9-pin DIN-1:1024x768-24@60e"`

You can get list of your video outputs with following command:

```{=mediawiki}
{{bc|<nowiki>$ ls -1 /sys/class/drm/ | grep -E '^card[[:digit:]]+-' | cut -d- -f2-</nowiki>}}
```
## HDMI audio {#hdmi_audio}

HDMI audio is supported in the `{{Pkg|xf86-video-ati}}`{=mediawiki} video driver. To disable HDMI audio add
`{{ic|1=radeon.audio=0}}`{=mediawiki} to your [kernel parameters](kernel_parameters "kernel parameters"){.wikilink}.

If there is no video after boot up, the driver option has to be disabled.

```{=mediawiki}
{{Note|
* If HDMI audio does not work after installing the driver, test your setup with the procedure at [[Advanced Linux Sound Architecture/Troubleshooting#HDMI output does not work]].
* If the sound is distorted in PulseAudio, try setting {{ic|1=tsched=0}} as described in [[PulseAudio/Troubleshooting#Troubleshooting buffer underruns (glitches, skips, crackling)]] and make sure {{ic|rtkit}} daemon is running.
* Your sound card might use the same module, since HDA compliant hardware is pretty common. [[Advanced Linux Sound Architecture#Set the default sound card]] using one of the suggested methods, which include using the {{ic|defaults}} node in ALSA configuration.
}}
```
## Multihead setup {#multihead_setup}

### Using the RandR extension {#using_the_randr_extension}

See [Multihead#RandR](Multihead#RandR "Multihead#RandR"){.wikilink} how to setup multiple monitors by using
[RandR](Wikipedia:RandR "RandR"){.wikilink}.

### Independent X screens {#independent_x_screens}

Independent dual-headed setups can be configured the usual way. However you might want to know that the radeon driver
has a `{{ic|"ZaphodHeads"}}`{=mediawiki} option which allows you to bind a specific device section to an output of your
choice:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-radeon.conf|
Section "Device"
  Identifier "Device0"
  Driver "radeon"
  Option "ZaphodHeads" "VGA-0"
  VendorName "ATI"
  BusID "PCI:1:0:0"
  Screen 0
EndSection
}}
```
This can be a life-saver, when using videocards that have more than two outputs. For instance one HDMI out, one DVI, one
VGA, will only select and use HDMI+DVI outputs for the dual-head setup, unless you explicitly specify
`{{ic|"ZaphodHeads" "VGA-0"}}`{=mediawiki}.

## Turn vsync off {#turn_vsync_off}

The radeon driver will probably enable vsync by default, which is perfectly fine except for benchmarking. To turn it
off, try the `{{ic|1=vblank_mode=0}}`{=mediawiki} [environment
variable](environment_variable "environment variable"){.wikilink} or create `{{ic|~/.drirc}}`{=mediawiki} (edit it if it
already exists) and add the following:

```{=mediawiki}
{{hc|~/.drirc|2=
<driconf>
    <device screen="0" driver="dri2">
        <application name="Default">
            <option name="vblank_mode" value="0" />
        </application>
    </device>
    ...
</driconf>
}}
```
```{=mediawiki}
{{Note|Make sure the driver is '''dri2''', not your video card code (like r600).}}
```
If vsync is still enabled, you can disable it by editing `{{ic|/etc/X11/xorg.conf.d/20-radeon.conf}}`{=mediawiki}. See
[#Driver options](#Driver_options "#Driver options"){.wikilink}.

## Troubleshooting

### Performance and/or artifacts issues when using EXA {#performance_andor_artifacts_issues_when_using_exa}

```{=mediawiki}
{{Note|This only applies to cards older than R600 (Radeon X1000 series and older). Newer cards you should use Glamor instead of EXA.}}
```
If having 2D performance issues, like slow scrolling in a terminal or webbrowser, adding
`{{ic|Option "MigrationHeuristic" "greedy"}}`{=mediawiki} as device option may solve the issue.

In addition disabling EXAPixmaps may solve artifacts issues, although this is generally not recommended and may cause
other issues.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-radeon.conf|
Section "OutputClass"
    Identifier "Radeon"
    MatchDriver "radeon"
    Option "AccelMethod" "exa"
    Option "MigrationHeuristic" "greedy"
    #Option "EXAPixmaps" "off"
EndSection
}}
```
### Adding undetected/unsupported resolutions {#adding_undetectedunsupported_resolutions}

See [Xrandr#Adding undetected
resolutions](Xrandr#Adding_undetected_resolutions "Xrandr#Adding undetected resolutions"){.wikilink}.

### TV showing a black border around the screen {#tv_showing_a_black_border_around_the_screen}

```{=mediawiki}
{{Note|Make sure the TV has been setup correctly (see manual) before attempting the following solution.}}
```
When connecting a TV using the HDMI port, the TV may show a blurry picture with a 2-3cm border around it. This protects
against overscanning (see [Wikipedia:Overscan](Wikipedia:Overscan "Wikipedia:Overscan"){.wikilink}), but can be turned
off using xrandr:

`xrandr --output HDMI-0 --set underscan off`

### Black screen and no console, but X works in KMS {#black_screen_and_no_console_but_x_works_in_kms}

This is a solution to the no-console problem that might come up, when using two or more ATI cards on the same PC.
Fujitsu Siemens Amilo PA 3553 laptop for example has this problem. This is due to fbcon console driver mapping itself to
the wrong framebuffer device that exists on the wrong card. This can be fixed by using the following [kernel
parameter](kernel_parameter "kernel parameter"){.wikilink}:

`fbcon=map:1`

This will tell the fbcon to map itself to the `{{ic|/dev/fb1}}`{=mediawiki} framebuffer and not the
`{{ic|/dev/fb0}}`{=mediawiki}, that in our case exists on the wrong graphics card. If that does not fix your problem,
try booting with

`fbcon=map:0`

instead.

### ATI X1600 (RV530 series) 3D application show black windows {#ati_x1600_rv530_series_3d_application_show_black_windows}

There are three possible solutions:

- Try adding `{{ic|1=pci=nomsi}}`{=mediawiki} to your boot loader [Kernel
  parameters](Kernel_parameters "Kernel parameters"){.wikilink}.
- If this does not work, you can try adding `{{ic|noapic}}`{=mediawiki} instead of `{{ic|1=pci=nomsi}}`{=mediawiki}.
- If none of the above work, then you can try running `{{ic|1=vblank_mode=0 glxgears}}`{=mediawiki} or
  `{{ic|1=vblank_mode=1 glxgears}}`{=mediawiki} to see which one works for you, then [set the option
  permanently](#Turn_vsync_off "set the option permanently"){.wikilink}.

### Cursor corruption after coming out of sleep {#cursor_corruption_after_coming_out_of_sleep}

If the cursor becomes corrupted (e.g. repeating itself vertically after the monitor(s) comes out of sleep) set
`{{ic|"SWCursor" "True"}}`{=mediawiki} in the `{{ic|"OutputClass"}}`{=mediawiki} section of the
`{{ic|/etc/X11/xorg.conf.d/20-radeon.conf}}`{=mediawiki} configuration file.

### DisplayPort stays black on multimonitor mode {#displayport_stays_black_on_multimonitor_mode}

Try booting with the [kernel parameter](kernel_parameter "kernel parameter"){.wikilink}
`{{ic|1=radeon.audio=0}}`{=mediawiki}.

### R9-390 Poor Performance and/or Instability {#r9_390_poor_performance_andor_instability}

Firmware issues with R9-390 series cards include poor performance and crashes (frequently caused by gaming or using
Google Maps) possibly related DPM. There has been a
[comment](https://gitlab.freedesktop.org/mesa/mesa/-/issues/1222#note_240698) on a bug report with instructions for a
fix.

### QHD / UHD / 4k support over HDMI for older Radeon cards {#qhd_uhd_4k_support_over_hdmi_for_older_radeon_cards}

Older cards have their pixel clock limited to 165MHz for HDMI. Hence, they do not support QHD or 4k only via dual-link
DVI but not over HDMI.

One possibility to work around this is to use [custom modes with lower refresh
rate](https://www.elstel.org/software/hunt-for-4K-UHD-2160p.html.en), e.g. 30Hz.

Another one is a kernel patch removing the pixel clock limit, but this may damage the card!

Official kernel bug ticket with patch for 4.8: <https://bugzilla.kernel.org/show_bug.cgi?id=172421>

The patch introduces a new kernel parameter `{{ic|radeon.hdmimhz}}`{=mediawiki} which alters the pixel clock limit.

Be sure to use a high speed HDMI cable for this.

### Horizontal flickering occasionally when using 4k DP output on 390X {#horizontal_flickering_occasionally_when_using_4k_dp_output_on_390x}

If you use 390X (or perhaps similar models) and the 4k output from DP, you may experiencing occasional horizontal
artifacts / flickering (i.e. every half an hour or so, a horizontal strip of pixels with a height of \~100 pixels across
the whole screen\'s width shaking up and down for a few seconds). This might be a bug of the radeon driver. Changing to
[AMDGPU](AMDGPU "AMDGPU"){.wikilink} seems to fix it.

## See also {#see_also}

[Benchmark](https://www.phoronix.com/scan.php?page=article&item=radeonsi-cat-wow&num=1) showing the open source driver
is on par performance-wise with the proprietary driver for many cards.

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink} [Category:X
server](Category:X_server "Category:X server"){.wikilink}

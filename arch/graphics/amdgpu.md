[de:AMDGPU](de:AMDGPU "wikilink") [hu:AMDGPU](hu:AMDGPU "wikilink") [ja:AMDGPU](ja:AMDGPU "wikilink")
[ru:AMDGPU](ru:AMDGPU "wikilink") [zh-hans:AMDGPU](zh-hans:AMDGPU "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|ATI}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki} `{{Related|Vulkan}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

[AMDGPU](Wikipedia:AMDGPU "wikilink") is the open source graphics driver for AMD Radeon graphics cards since the
[Graphics Core Next](wikipedia:Graphics_Core_Next "wikilink") family.

## Selecting the right driver {#selecting_the_right_driver}

Identify your hardware and find the right driver by reading [Graphics processing
unit#Installation](Graphics_processing_unit#Installation "wikilink"). This driver supports [Southern
Islands](https://www.x.org/wiki/RadeonFeature/) (GCN 1, released in 2012) cards and later. AMD has no plans to support
pre-GCN GPUs.

Owners of unsupported GPUs may use the open source [ATI](ATI "wikilink") driver.

## Installation

[Install](Install "wikilink") the `{{Pkg|mesa}}`{=mediawiki} package, which provides both the DRI driver for 3D
acceleration and VA-API/VDPAU drivers for [accelerated video decoding](#Video_acceleration "wikilink").

-   For 32-bit application support, also install the `{{Pkg|lib32-mesa}}`{=mediawiki} package from the
    [multilib](multilib "wikilink") repository.
-   For 2D acceleration under [Xorg](Xorg "wikilink"), you may optionally install the
    `{{Pkg|xf86-video-amdgpu}}`{=mediawiki} package, which provides the AMD-specific DDX driver. Most Xorg systems using
    the `{{ic|amdgpu}}`{=mediawiki} kernel driver will work correctly with the generic *modesetting* DDX built into
    `{{Pkg|xorg-server}}`{=mediawiki}. However, `{{Pkg|xf86-video-amdgpu}}`{=mediawiki} could be required for features
    such as `{{ic|TearFree}}`{=mediawiki} or to resolve hardware-specific issues on some AMD hardware, like *Southern
    Islands*. Read the Note at [Intel graphics#Installation](Intel_graphics#Installation "wikilink").
-   For [Vulkan](Vulkan "wikilink") support install `{{Pkg|vulkan-radeon}}`{=mediawiki}
    (`{{Pkg|lib32-vulkan-radeon}}`{=mediawiki} for 32-bit applications).

### Experimental

It may be worthwhile for some users to use the upstream experimental build of mesa.

Install the `{{AUR|mesa-git}}`{=mediawiki} package, which provides the DRI driver for 3D acceleration.

-   For 32-bit application support, also install the `{{AUR|lib32-mesa-git}}`{=mediawiki} package from the *mesa-git*
    repository or the [AUR](AUR "wikilink").
-   For the DDX driver (which provides 2D acceleration in [Xorg](Xorg "wikilink")), install the
    `{{AUR|xf86-video-amdgpu-git}}`{=mediawiki} package.
-   For [Vulkan](Vulkan "wikilink") support using the *mesa-git* repository, install the *vulkan-radeon-git* package.
    Optionally install the *lib32-vulkan-radeon-git* package for 32-bit application support. This should not be required
    if building `{{AUR|mesa-git}}`{=mediawiki} from the AUR.

```{=mediawiki}
{{Tip|Users who do not wish to go through the process of compiling the {{AUR|mesa-git}} package can use the [[Unofficial user repositories#mesa-git|mesa-git]] unofficial repository.}}
```
### Enable Southern Islands (SI) and Sea Islands (CIK) support {#enable_southern_islands_si_and_sea_islands_cik_support}

```{=mediawiki}
{{Remove|When [https://lists.freedesktop.org/archives/amd-gfx/2025-November/133749.html upstream changes] making AMDGPU the default reach {{Pkg|linux-lts}}, this will no longer need to be documented.}}
```
[Officially supported kernels](Kernel#Officially_supported_kernels "wikilink") enable AMDGPU support for cards of the
Southern Islands (GCN 1, released in 2012) and Sea Islands (GCN 2, released in 2013). The `{{ic|amdgpu}}`{=mediawiki}
kernel driver needs to be loaded before the [radeon](ATI "wikilink") one. You can check which kernel driver is loaded by
running `{{ic|lspci -k}}`{=mediawiki}. It should be like this:

```{=mediawiki}
{{hc|$ lspci -k -d ::03xx|
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Curacao PRO [Radeon R7 370 / R9 270/370 OEM]
    Subsystem: Gigabyte Technology Co., Ltd Device 226c
    Kernel driver in use: amdgpu
    Kernel modules: radeon, amdgpu
}}
```
If the `{{ic|amdgpu}}`{=mediawiki} driver is not in use, follow instructions in the next section.

#### Load amdgpu driver {#load_amdgpu_driver}

The [module parameters](module_parameter "wikilink") of both `{{ic|amdgpu}}`{=mediawiki} and `{{ic|radeon}}`{=mediawiki}
modules are `{{ic|1=cik_support=}}`{=mediawiki} and `{{ic|1=si_support=}}`{=mediawiki}.

They need to be set as kernel parameters or in a *modprobe* configuration file, and depend on the cards GCN version.

You can use both parameters if you are unsure which kernel card you have.

```{=mediawiki}
{{Tip|[[dmesg]] may indicate the correct kernel parameter to use: {{ic|1=[..] amdgpu 0000:01:00.0: Use radeon.cik_support=0 amdgpu.cik_support=1 to override}}.}}
```
##### Set module parameters in kernel command line {#set_module_parameters_in_kernel_command_line}

Set one of the following [kernel parameters](kernel_parameters "wikilink"):

-   Southern Islands (SI): `{{ic|1=radeon.si_support=0 amdgpu.si_support=1}}`{=mediawiki}
-   Sea Islands (CIK): `{{ic|1=radeon.cik_support=0 amdgpu.cik_support=1}}`{=mediawiki}

Furthermore, if you are using an AMD A10 APU with an integrated Sea Island (GCN 1.1) card, you may have to disable
Radeon Dynamic Power Management to get a proper boot. This is a feature that dynamically re-clocks the graphics core in
order to keep the APU cooler and quieter, however this feature may put you in an infinite restart loop. To disable it,
following the instructions above, add `{{ic|1=radeon.dpm=0}}`{=mediawiki} to the boot options.

#### Specify the correct module order {#specify_the_correct_module_order}

Make sure `{{ic|amdgpu}}`{=mediawiki} has been set as first module in the
[Mkinitcpio#MODULES](Mkinitcpio#MODULES "wikilink") array, e.g. `{{ic|1=MODULES=(amdgpu radeon)}}`{=mediawiki}.

##### Set kernel module parameters {#set_kernel_module_parameters}

```{=mediawiki}
{{Remove|When [https://lists.freedesktop.org/archives/dri-devel/2025-November/536754.html upstream changes] making AMDGPU enabled for SI and CIK, this section will be valid only for pre 6.19 kernels. Add a note about it when 6.19 released.}}
```
For Southern Islands (SI) use the `{{ic|1=si_support=1}}`{=mediawiki} [kernel module
parameter](kernel_module_parameter "wikilink"), for Sea Islands (CIK) use `{{ic|1=cik_support=1}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/modprobe.d/amdgpu.conf|2=
options amdgpu si_support=1
options amdgpu cik_support=1
}}
```
```{=mediawiki}
{{hc|/etc/modprobe.d/radeon.conf|2=
options radeon si_support=0
options radeon cik_support=0
}}
```
Make sure `{{ic|modconf}}`{=mediawiki} is in the `{{ic|HOOKS}}`{=mediawiki} array in
`{{ic|/etc/mkinitcpio.conf}}`{=mediawiki} and [regenerate the initramfs](regenerate_the_initramfs "wikilink").

##### Compile kernel which supports amdgpu driver {#compile_kernel_which_supports_amdgpu_driver}

When building or compiling a [kernel](kernel "wikilink"), `{{ic|1=CONFIG_DRM_AMDGPU_SI=Y}}`{=mediawiki} and/or
`{{ic|1=CONFIG_DRM_AMDGPU_CIK=Y}}`{=mediawiki} should be set in the config.

### ACO compiler {#aco_compiler}

The [ACO compiler](https://steamcommunity.com/games/221410/announcements/detail/1602634609636894200) is an open source
shader compiler created and developed by [Valve Corporation](wikipedia:Valve_Corporation "wikilink") to directly compete
with the [LLVM compiler](https://llvm.org/), as well as [Windows 10](wikipedia:Windows_10 "wikilink"). It offers lesser
compilation time and also performs better while gaming than LLVM.

Some benchmarks can be seen on [GitHub](https://gist.github.com/pendingchaos/aba1e4c238cf039d17089f29a8c6aa63) and
Phoronix [1](https://www.phoronix.com/scan.php?page=article&item=radv-aco-llvm&num=1)
[2](https://www.phoronix.com/scan.php?page=article&item=radv-aco-gcn10&num=1).

Since `{{Pkg|mesa}}`{=mediawiki} version [20.2](https://docs.mesa3d.org/relnotes/20.2.0.html#new-features) ACO is the
default shader compiler.

## Loading

The `{{ic|amdgpu}}`{=mediawiki} kernel module is supposed to load automatically on system boot.

If it does not:

-   Make sure to [#Enable Southern Islands (SI) and Sea Islands (CIK)
    support](#Enable_Southern_Islands_(SI)_and_Sea_Islands_(CIK)_support "wikilink") when needed.
-   Make sure you have the latest `{{Pkg|linux-firmware-amdgpu}}`{=mediawiki} package installed. This driver requires
    the latest firmware for each model to successfully boot.
-   Make sure you do **not** have `{{ic|nomodeset}}`{=mediawiki} or `{{ic|1=vga=}}`{=mediawiki} as a [kernel
    parameter](kernel_parameter "wikilink"), since `{{ic|amdgpu}}`{=mediawiki} requires [KMS](KMS "wikilink").
-   Check that you have not disabled `{{ic|amdgpu}}`{=mediawiki} by using any [kernel module
    blacklisting](Kernel_modules#Blacklisting "wikilink").

It is possible it loads, but late, after the X server requires it. In this case see [Kernel mode setting#Early KMS
start](Kernel_mode_setting#Early_KMS_start "wikilink").

## Xorg configuration {#xorg_configuration}

[Xorg](Xorg "wikilink") will automatically load the driver and it will use your monitor\'s EDID to set the native
resolution. Configuration is only required for tuning the driver.

If you want manual configuration, create `{{ic|/etc/X11/xorg.conf.d/20-amdgpu.conf}}`{=mediawiki}, and add the
following:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-amdgpu.conf|2=
Section "OutputClass"
     Identifier "AMD"
     MatchDriver "amdgpu"
     Driver "amdgpu"
EndSection
}}
```
Using this section, you can enable features and tweak the driver settings, see `{{man|4|amdgpu}}`{=mediawiki} first
before setting driver options.

### Tear free rendering {#tear_free_rendering}

*TearFree* controls tearing prevention using the hardware page flipping mechanism. By default, TearFree will be on for
rotated outputs, outputs with RandR transforms applied, and for RandR 1.4 slave outputs, and off for everything else. Or
you can configure it to be always on or always off with `{{ic|true}}`{=mediawiki} or `{{ic|false}}`{=mediawiki}
respectively.

`Option "TearFree" "true"`

You can also enable TearFree temporarily with [xrandr](xrandr "wikilink"):

`$ xrandr --output `*`output`*` --set TearFree on`

Where `{{ic|''output''}}`{=mediawiki} should look like `{{ic|DisplayPort-0}}`{=mediawiki} or
`{{ic|HDMI-A-0}}`{=mediawiki} and can be acquired by running `{{ic|xrandr -q}}`{=mediawiki}.

### DRI level {#dri_level}

*DRI* sets the maximum level of DRI to enable. Valid values are *2* for DRI2 or *3* for DRI3. The default is *3* for
DRI3 if the [Xorg](Xorg "wikilink") version is \>= 1.18.3, otherwise DRI2 is used:

`Option "DRI" "3"`

### Variable refresh rate {#variable_refresh_rate}

See [Variable refresh rate](Variable_refresh_rate "wikilink").

### 10-bit color {#bit_color}

```{=mediawiki}
{{Warning|Many applications may have graphical artifacts or crash when 10-bit color is enabled. This notably includes [[Steam/Troubleshooting#Steam: An X Error occurred|Steam]], which crashes with an X Error.}}
```
Newer AMD cards support 10bpc color, but the default is 24-bit color and 30-bit color must be explicitly enabled.
Enabling it can reduce visible banding/artifacts in gradients, if the applications support this too. To check if your
monitor supports it search for \"EDID\" in your [Xorg log file](Xorg#General "wikilink") (e.g.
`{{ic|/var/log/Xorg.0.log}}`{=mediawiki} or `{{ic|~/.local/share/xorg/Xorg.0.log}}`{=mediawiki}):

`[   336.695] (II) AMDGPU(0): EDID for output DisplayPort-0`\
`[   336.695] (II) AMDGPU(0): EDID for output DisplayPort-1`\
`[   336.695] (II) AMDGPU(0): Manufacturer: DEL  Model: a0ec  Serial#: 123456789`\
`[   336.695] (II) AMDGPU(0): Year: 2018  Week: 23`\
`[   336.695] (II) AMDGPU(0): EDID Version: 1.4`\
`[   336.695] (II) AMDGPU(0): Digital Display Input`\
**`[ 336.695] (II) AMDGPU(0): 10 bits per channel`**

To check whether it is currently enabled search for \"Depth\"):

`[   336.618] (**) AMDGPU(0): Depth 30, (--) framebuffer bpp 32`\
`[   336.618] (II) AMDGPU(0): Pixel depth = 30 bits stored in 4 bytes (32 bpp pixmaps)`

With the default configuration it will instead say the depth is 24, with 24 bits stored in 4 bytes.

To check whether 10-bit works, exit Xorg if you have it running and run `{{ic|Xorg -retro}}`{=mediawiki} which will
display a black and white grid, then press `{{ic|Ctrl-Alt-F1}}`{=mediawiki} and `{{ic|Ctrl-C}}`{=mediawiki} to exit X,
and run `{{ic|Xorg -depth 30 -retro}}`{=mediawiki}. If this works fine, then 10-bit is working.

To launch in 10-bit via `{{ic|startx}}`{=mediawiki}, use `{{ic|startx -- -depth 30}}`{=mediawiki}. To permanently enable
it, create or add to:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-amdgpu.conf|2=
Section "Screen"
    Identifier "asdf"
    DefaultDepth 30
EndSection
}}
```
### Reduce output latency {#reduce_output_latency}

If you want to minimize latency you can disable page flipping and tear free:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-amdgpu.conf|2=
Section "OutputClass"
     Identifier "AMD"
     MatchDriver "amdgpu"
     Driver "amdgpu"
     Option "EnablePageFlip" "off"
     Option "TearFree" "false"
EndSection
}}
```
See [Gaming#Reducing DRI latency](Gaming#Reducing_DRI_latency "wikilink") to further reduce latency.

```{=mediawiki}
{{Note|Setting these options may cause tearing and short-lived artifacts to appear.}}
```
## Features

### Video acceleration {#video_acceleration}

See [Hardware video acceleration#AMD/ATI](Hardware_video_acceleration#AMD/ATI "wikilink").

### Monitoring

Monitoring your GPU is often used to check the temperature and also the P-states of your GPU.

#### CLI

-   ```{=mediawiki}
    {{App|amdgpu_top|Tool to display AMDGPU usage|https://github.com/Umio-Yasuno/amdgpu_top|{{Pkg|amdgpu_top}}}}
    ```

-   ```{=mediawiki}
    {{App|nvtop|GPUs process monitoring for AMD, Intel and NVIDIA|https://github.com/Syllo/nvtop|{{Pkg|nvtop}}}}
    ```

-   ```{=mediawiki}
    {{App|radeontop|A GPU utilization viewer, both for the total activity percent and individual blocks|https://github.com/clbr/radeontop|{{Pkg|radeontop}}}}
    ```

#### GUI

-   ```{=mediawiki}
    {{App|amdgpu_top|Tool to display AMDGPU usage|https://github.com/Umio-Yasuno/amdgpu_top|{{Pkg|amdgpu_top}}}}
    ```

-   ```{=mediawiki}
    {{App|AmdGuid|A basic fan control GUI fully written in Rust.|https://github.com/Eraden/amdgpud|{{AUR|amdguid-wayland-bin}}, {{AUR|amdguid-glow-bin}}}}
    ```

-   ```{=mediawiki}
    {{App|Radeon Profile|A Qt5 tool to read and change current clocks of AMD Radeon cards.|https://github.com/emerge-e-world/radeon-profile|{{AUR|radeon-profile-git}}}}
    ```

-   ```{=mediawiki}
    {{App|TuxClocker|A Qt5 monitoring and overclocking tool.|https://github.com/Lurkki14/tuxclocker|{{AUR|tuxclocker}}}}
    ```

#### Manually

To check your GPU\'s P-states, execute:

`$ cat /sys/class/drm/card0/device/pp_od_clk_voltage`

To monitor your GPU, execute:

`# watch -n 0.5 cat /sys/kernel/debug/dri/0/amdgpu_pm_info`

To check your GPU utilization, execute:

`$ cat /sys/class/drm/card0/device/gpu_busy_percent`

To check your GPU frequency, execute:

`$ cat /sys/class/drm/card0/device/pp_dpm_sclk`

To check your GPU temperature, execute:

`$ cat /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input`

To check your VRAM frequency, execute:

`$ cat /sys/class/drm/card0/device/pp_dpm_mclk`

To check your VRAM usage, execute:

`$ cat /sys/class/drm/card0/device/mem_info_vram_used`

To check your VRAM size, execute:

`$ cat /sys/class/drm/card0/device/mem_info_vram_total`

### Overclocking

Since Linux 4.17, once you have enabled the features at boot below, it is possible to adjust clocks and voltages of the
graphics card via `{{ic|/sys/class/drm/card0/device/pp_od_clk_voltage}}`{=mediawiki}.

#### Boot parameter {#boot_parameter}

It is required to unlock access to adjust clocks and voltages in sysfs by appending the [Kernel
parameter](Kernel_parameter "wikilink") `{{ic|1=amdgpu.ppfeaturemask=0xffffffff}}`{=mediawiki}.

Not all bits are defined, and new features may be added over time. Setting all 32 bits may enable unstable features that
cause problems such as screen flicker or broken resume from suspend. It should be sufficient to set the
PP_OVERDRIVE_MASK bit, 0x4000, in combination with the default ppfeaturemask. To compute a reasonable parameter for your
system, execute:

`$ printf 'amdgpu.ppfeaturemask=0x%x\n' "$(($(cat /sys/module/amdgpu/parameters/ppfeaturemask) | 0x4000))"`

#### Manual

```{=mediawiki}
{{Note|In sysfs, paths like {{ic|/sys/class/drm/...}} are just symlinks and may change between reboots. Persistent locations can be found in {{ic|/sys/devices/}}, e.g. {{ic|/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/}}. Adjust the commands accordingly for a reliable result.}}
```
For in-depth information on all possible options, read the kernel documentation for [amdgpu thermal
control](https://docs.kernel.org/gpu/amdgpu/thermal.html#pp-od-clk-voltage).

To enable manual overclocking, select the `{{ic|manual}}`{=mediawiki} performance level as described in [#Performance
levels](#Performance_levels "wikilink").

To set the GPU clock for the maximum P-state 7 on e.g. a Polaris GPU to 1209MHz and 900mV voltage, run:

`# echo "s 7 1209 900" > /sys/class/drm/card0/device/pp_od_clk_voltage`

The same procedure can be applied to the VRAM, e.g. maximum P-state 2 on Polaris 5xx series cards:

`# echo "m 2 1850 850" > /sys/class/drm/card0/device/pp_od_clk_voltage`

```{=mediawiki}
{{Warning|Double check the entered values, as mistakes might instantly cause fatal hardware damage!}}
```
To apply, run:

`# echo "c" > /sys/class/drm/card0/device/pp_od_clk_voltage`

To check if it worked out, read out clocks and voltage under 3D load:

`# watch -n 0.5 cat /sys/kernel/debug/dri/0/amdgpu_pm_info`

You can reset to the default values using:

`# echo "r" > /sys/class/drm/card0/device/pp_od_clk_voltage`

It is also possible to forbid the driver from switching to certain P-states, e.g. to workaround problems with deep
powersaving P-states, such as flickering artifacts or stutter. To force the highest VRAM P-state on a card, while still
allowing the GPU itself to run with lower clocks, first find the highest possible P-state, then set it:

```{=mediawiki}
{{hc|$ cat /sys/class/drm/card0/device/pp_dpm_mclk|
0: 96Mhz *
1: 456Mhz
2: 675Mhz
3: 1000Mhz
}}
```
`# echo "manual" > /sys/class/drm/card0/device/power_dpm_force_performance_level`\
`# echo "3" >  /sys/class/drm/card0/device/pp_dpm_mclk`

Allow only the three highest GPU P-states:

`# echo "5 6 7" > /sys/class/drm/card0/device/pp_dpm_sclk`

To set the allowed maximum power consumption of the GPU to e.g. 50 Watts, run:

`# echo `**`50`**`000000 > /sys/class/drm/card0/device/hwmon/hwmon0/power1_cap`

```{=mediawiki}
{{Note|The above procedure was tested with a Polaris RX 560 card. There may be different behavior or bugs with different GPUs.}}
```
#### Assisted

If you are not inclined to fully manually overclock your GPU, there are some overclocking tools that are offered by the
community to assist you to overclock and monitor your AMD GPU.

##### CLI tools {#cli_tools}

-   ```{=mediawiki}
    {{App|amdgpu-clocks|A script that can be used to monitor and set custom power states for AMD GPUs. It also offers a Systemd service to apply the settings automatically upon boot.|https://github.com/sibradzic/amdgpu-clocks|{{AUR|amdgpu-clocks-git}}}}
    ```

-   ```{=mediawiki}
    {{App|ruby-amdgpu_fan|A CLI for interacting with the amdgpu Linux driver written in Ruby.|https://github.com/HarlemSquirrel/amdgpu-fan-rb|{{AUR|ruby-amdgpu_fan}}}}
    ```

##### GUI tools {#gui_tools}

-   ```{=mediawiki}
    {{App|TuxClocker|A Qt5 monitoring and overclocking tool.|https://github.com/Lurkki14/tuxclocker|{{AUR|tuxclocker}}}}
    ```

-   ```{=mediawiki}
    {{App|CoreCtrl|A GUI overclocking tool with a WattMan-like UI that supports per-application profiles.|https://gitlab.com/corectrl/corectrl|{{Pkg|corectrl}}}}
    ```

-   ```{=mediawiki}
    {{App|LACT|A GTK tool to view information and control your AMD GPU.|https://github.com/ilya-zlobintsev/LACT|{{Pkg|lact}}}}
    ```

-   ```{=mediawiki}
    {{App|Radeon Profile|A Qt5 tool to read and change current clocks of AMD Radeon cards.|https://github.com/emerge-e-world/radeon-profile|{{AUR|radeon-profile-git}}}}
    ```

#### Startup on boot {#startup_on_boot}

One way is to use systemd units, if you want your settings to apply automatically upon boot, consider looking at this
[Reddit thread](https://www.reddit.com/r/Amd/comments/agwroj/how_to_overclock_your_amd_gpu_on_linux/) to configure and
apply your settings on boot.

Another way is to use udev rules for some of the values, for example, to set a low performance level to save energy:

```{=mediawiki}
{{hc|/etc/udev/rules.d/30-amdgpu-low-power.rules|2=
ACTION=="add", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="low"
}}
```
### Performance levels {#performance_levels}

AMDGPU offers several performance levels, the file power_dpm_force_performance_level is used for this, it is possible to
select between these levels:

-   **auto**: dynamically select the optimal power profile for current conditions in the driver.
-   **low**: clocks are forced to the lowest power state.
-   **high**: clocks are forced to the highest power state.
-   **manual**: user can manually adjust which power states are enabled for each clock domain (used for setting [#Power
    profiles](#Power_profiles "wikilink"))
-   **profile_standard**, **profile_min_sclk**, **profile_min_mclk**, **profile_peak**: clock and power gating are
    disabled and the clocks are set for different profiling cases. This mode is recommended for profiling specific work
    loads

To set the AMDGPU device to use a low performance level, the following command can be executed:

`# echo "low" > /sys/class/drm/card0/device/power_dpm_force_performance_level`

```{=mediawiki}
{{Note|Performance levels changes should be reapplied at every boot, see [[#Startup on boot]] to automate this.}}
```
### Power profiles {#power_profiles}

AMDGPU offers several optimizations via power profiles, one of the most commonly used is the compute mode for OpenCL
intensive applications. Available power profiles can be listed with:

```{=mediawiki}
{{hc|$ cat /sys/class/drm/card0/device/pp_power_profile_mode|
NUM        MODE_NAME     SCLK_UP_HYST   SCLK_DOWN_HYST SCLK_ACTIVE_LEVEL     MCLK_UP_HYST   MCLK_DOWN_HYST MCLK_ACTIVE_LEVEL
  0   BOOTUP_DEFAULT:        -                -                -                -                -                -
  1   3D_FULL_SCREEN:        0              100               30                0              100               10
  2     POWER_SAVING:       10                0               30                -                -                -
  3            VIDEO:        -                -                -               10               16               31
  4               VR:        0               11               50                0              100               10
  5        COMPUTE *:        0                5               30               10               60               25
  6           CUSTOM:        -                -                -                -                -                -
}}
```
```{=mediawiki}
{{Note|{{ic|card0}} identifies a specific GPU in your machine, in case of multiple GPUs be sure to address the right one.}}
```
To use a specific power profile you should first enable manual control over them with:

`# echo "manual" > /sys/class/drm/card0/device/power_dpm_force_performance_level`

Then to select a power profile by writing the NUM field associated with it, e.g. to enable COMPUTE run:

`# echo "5" > /sys/class/drm/card0/device/pp_power_profile_mode`

The exact values and limits of power profiles is managed through the *powerplay table* system. Use
`{{AUR|upliftpowerplay}}`{=mediawiki} to modify the table for supported models (Polaris to Navi2x; Navi3x and Navi4x are
bugged on kernel side).

```{=mediawiki}
{{Note|Power profile changes should be reapplied at every boot, see [[#Startup on boot]] to automate this.}}
```
### Enable GPU display scaling {#enable_gpu_display_scaling}

```{=mediawiki}
{{Merge|xrandr|Not specific to AMDGPU.|section=Moving "Enable GPU display scaling" to xrandr}}
```
To avoid the usage of the scaler which is built in the display, and use the GPU own scaler instead, when not using the
native resolution of the monitor, execute:

`$ xrandr --output `*`output`*` --set "scaling mode" `*`scaling_mode`*

Possible values for `{{ic|"scaling mode"}}`{=mediawiki} are: `{{ic|None}}`{=mediawiki}, `{{ic|Full}}`{=mediawiki},
`{{ic|Center}}`{=mediawiki}, `{{ic|Full aspect}}`{=mediawiki}.

-   To show the available outputs and settings, execute: `{{bc|$ xrandr --prop}}`{=mediawiki}
-   To set `{{ic|1=scaling mode = Full aspect}}`{=mediawiki} for just every available output, execute:
    `{{bc|$ for output in $(xrandr --prop {{!}}`{=mediawiki} grep -E -o -i \"\^\[A-Z\\-\]+-\[0-9\]+\"); do xrandr
    \--output \"\$output\" \--set \"scaling mode\" \"Full aspect\"; done}}

### Virtual display on headless setups {#virtual_display_on_headless_setups}

AMDGPU offers GPU accelerated virtual monitors for headless setups without the use of a dummy plug. This is useful for
RDP and game streaming software such as `{{AUR|sunshine}}`{=mediawiki}.

Choose the AMD GPU to use:

```{=mediawiki}
{{hc|$ lspci -Dd ::03xx|
'''1234:56:78.9''' VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] ''CommercialModelName''
}}
```
Add the `{{ic|1=virtual_display=''1234:56:78.9'',''x''}}`{=mediawiki} [kernel module
parameter](kernel_module_parameter "wikilink") for the `{{ic|amdgpu}}`{=mediawiki} module, where
`{{ic|''1234:56:78.9''}}`{=mediawiki} is the PCI address of the GPU and `{{ic|''x''}}`{=mediawiki} is the number of crtc
(virtual monitors) to expose. Using this parameter also disables physical outputs.
[3](https://bugzilla.kernel.org/show_bug.cgi?id=203339)

Multiple GPUs can also be used by separating PCI address with a semicolon (;) as shown below:

`amdgpu.virtual_display=1234:56:78.9,`*`x`*`;9876:54:32.1,`*`y`*

### User queues {#user_queues}

The AMDGPU driver supports user queues, which allow job submission directly to the GPU hardware without going through
the kernel driver's command submission ioctl. Enabling this can reduce latency and improve efficiency by bypassing some
kernel driver overhead.

To enable user queues, set the following environment variable:

`export AMD_USERQ=1`

## Troubleshooting

### Module parameters {#module_parameters}

The amdgpu module stashes several config parameters (`{{ic|modinfo amdgpu {{!}}`{=mediawiki} grep mask}}) in masks that
are only documented in the [kernel
sources](https://raw.githubusercontent.com/torvalds/linux/master/drivers/gpu/drm/amd/include/amd_shared.h).

### Xorg or applications will not start {#xorg_or_applications_will_not_start}

-   \"(EE) AMDGPU(0): \[DRI2\] DRI2SwapBuffers: drawable has no back or front?\" error after opening *glxgears*, can
    open Xorg server but OpenGL applications crash.
-   \"(EE) AMDGPU(0): Given depth (32) is not supported by amdgpu driver\" error, Xorg will not start.

Setting the screen\'s depth under Xorg to 16 or 32 will cause problems/crash. To avoid that, you should use a standard
screen depth of 24 by adding this to your \"screen\" section:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-screen.conf|
Section "Screen"
       Identifier     "Screen"
       DefaultDepth    24
       SubSection      "Display"
               Depth   24
       EndSubSection
EndSection
}}
```
### Screen artifacts and frequency problem {#screen_artifacts_and_frequency_problem}

[Dynamic power management](ATI#Dynamic_power_management "wikilink") may cause screen artifacts to appear when displaying
to monitors at higher frequencies (anything above 60Hz) due to issues in the way GPU clock speeds are
managed[4](https://bugs.freedesktop.org/show_bug.cgi?id=96868)[5](https://gitlab.freedesktop.org/drm/amd/-/issues/234).

A workaround [6](https://bugs.freedesktop.org/show_bug.cgi?id=96868#c13) is to set the `{{ic|high}}`{=mediawiki} or
`{{ic|low}}`{=mediawiki} performance level as described in [#Performance levels](#Performance_levels "wikilink").

Changing the kernel version can also help eliminate this issue. For example, it appears to be fixed in 6.12.9.

#### Artifacts in Chromium {#artifacts_in_chromium}

If you see artifacts in [Chromium](Chromium "wikilink"), forcing the vulkan-based backend might help. Go to
`{{ic|chrome://flags}}`{=mediawiki} and *enable* `{{ic|#ignore-gpu-blocklist}}`{=mediawiki} and
`{{ic|#enable-vulkan}}`{=mediawiki}.

### R9 390 series poor performance and/or instability {#r9_390_series_poor_performance_andor_instability}

If you experience issues [7](https://gitlab.freedesktop.org/mesa/mesa/-/issues/1222) with a AMD R9 390 series graphics
card, set
`{{ic|1=radeon.cik_support=0 radeon.si_support=0 amdgpu.cik_support=1 amdgpu.si_support=1 amdgpu.dc=1}}`{=mediawiki} as
[kernel parameters](kernel_parameters "wikilink") to force the use of amdgpu driver instead of radeon.

If it still does not work, disabling DPM might help, add
`{{ic|1=radeon.cik_support=0 radeon.si_support=0 amdgpu.cik_support=1 amdgpu.si_support=1}}`{=mediawiki} to the [kernel
parameters](kernel_parameters "wikilink").

### Freezes with \"\[drm\] IP block:gmc_v8_0 is hung!\" kernel error {#freezes_with_drm_ip_blockgmc_v8_0_is_hung_kernel_error}

If you experience freezes and kernel crashes during a GPU intensive task with the kernel error \" \[drm\] IP
block:gmc_v8_0 is hung!\" [8](https://gitlab.freedesktop.org/drm/amd/issues/226), a workaround is to set
`{{ic|1=amdgpu.vm_update_mode=3}}`{=mediawiki} as [kernel parameters](kernel_parameters "wikilink") to force the GPUVM
page tables update to be done using the CPU. Downsides are listed here
[9](https://gitlab.freedesktop.org/drm/amd/-/issues/226#note_308665).

### Screen flickering white/gray {#screen_flickering_whitegray}

When you change resolution or connect to an external monitor, if the screen flickers or stays white, add
`{{ic|1=amdgpu.sg_display=0}}`{=mediawiki} as a [kernel parameter](kernel_parameter "wikilink").

### System freeze or crash when gaming on Vega cards {#system_freeze_or_crash_when_gaming_on_vega_cards}

[Dynamic power management](ATI#Dynamic_power_management "wikilink") may cause a complete system freeze whilst gaming due
to issues in the way GPU clock speeds are managed. [10](https://gitlab.freedesktop.org/drm/amd/-/issues/716) A
workaround is to set the `{{ic|high}}`{=mediawiki} performance level as described in [#Performance
levels](#Performance_levels "wikilink").

### WebRenderer (Firefox) corruption {#webrenderer_firefox_corruption}

Artifacts and other anomalies may present themselves (e.g. inability to select extension options) when
[WebRenderer](Firefox/Tweaks#WebRender "wikilink") is force enabled by the user. Workaround is to fall back to OpenGL
compositing.

### Double-speed or \"chipmunk\" audio, or no audio when a 4K@60Hz device is connected {#double_speed_or_chipmunk_audio_or_no_audio_when_a_4k60hz_device_is_connected}

This is sometimes caused by a communication issue between an AMDGPU device and a 4K display connected over HDMI. A
possible workaround is to enable HDR or \"Ultra HD Deep Color\" via the display\'s built-in settings. On many Android
based TVs, this means setting this to \"Standard\" instead of \"Optimal\".

### Issues with power management / dynamic re-activation of a discrete amdgpu graphics card {#issues_with_power_management_dynamic_re_activation_of_a_discrete_amdgpu_graphics_card}

If you encounter issues where the kernel driver is loaded, but the discrete graphics card still is not available for
games or becomes disabled during use (similar to [11](https://gitlab.freedesktop.org/drm/amd/-/issues/1820)), you can
workaround the issue by setting the [kernel parameter](kernel_parameter "wikilink")
`{{ic|1=amdgpu.runpm=0}}`{=mediawiki}, which prevents the dGPU from being powered down dynamically at runtime.

### Frozen or unresponsive display (flip_done timed out) {#frozen_or_unresponsive_display_flip_done_timed_out}

A bug in the amdgpu driver may stop the display from updating
[12](https://gitlab.freedesktop.org/drm/amd/-/issues/4141). It is suggested to append the
`{{ic|1=amdgpu.dcdebugmask=0x10}}`{=mediawiki} or `{{ic|1=amdgpu.dcdebugmask=0x12}}`{=mediawiki} [kernel
parameter](kernel_parameter "wikilink") as a workaround.

### kfd fails to initialize {#kfd_fails_to_initialize}

kfd can fail to initialize depending on the GPU\'s architecture. gfx803 (GCN 4) requires PCIe atomics support, while
gfx9xx (Vega) and later devices does not require PCIe atomics. kfd does not support GCN 3 or older devices.

If you are not planning to use [ROCm](GPGPU#ROCm "wikilink"), these errors can be safely ignored.

#### \"\[GPU Core Name\] not supported in kfd\" {#gpu_core_name_not_supported_in_kfd}

In the system journal or the kernel message keyring a critical level error message may appear relating to kfd:
`{{hc|# dmesg {{!}}`{=mediawiki} grep kfd\| kfd kfd: amdgpu: BONAIRE not supported in kfd }}

(Replace BONAIRE with the name of the core that\'s in your GPU, such as TOPAZ, HAWAII, etc. You can find the core name
by looking up your GPU or by using a GPU diagnostic utility such as `{{pkg|amdgpu_top}}`{=mediawiki})

This means that your GPU is not supported in kfd and will not work with
ROCm.[13](https://github.com/RadeonOpenCompute/ROCm/issues/1148#issuecomment-747849592)[14](https://www.reddit.com/r/linuxquestions/comments/yhbbiz/kfd_kfd_amdgpu_topaz_not_supported_in_kfd/)

#### \"PCI rejects atomics\" {#pci_rejects_atomics}

On GCN 4 GPUs, your CPU must support PCIe atomics and the slot that the GPU is in supports at least PCIe
3.0.[15](https://github.com/ROCm/ROCm/issues/2224#issuecomment-2299689450) If these requirements are not met, you will
encounter this message: `{{hc|# dmesg {{!}}`{=mediawiki} grep kfd\| kfd kfd: amdgpu: skipped device 1002:67e3, PCI
rejects atomics 730\<0 }}

You can check if your CPU supports PCIe atomics by running this command:

`grep flags /sys/class/kfd/kfd/topology/nodes/*/io_links/0/properties`

If your CPU supports PCIe atomics (the result being `{{ic|1}}`{=mediawiki}), change the slot that the GPU is in, it may
have lanes coming from the chipset and not the CPU.

### High idle power draw due to MCLK locked at MAX (1000MHz), or MIN (96MHz) causing low game performance (on 6.4 kernel) {#high_idle_power_draw_due_to_mclk_locked_at_max_1000mhz_or_min_96mhz_causing_low_game_performance_on_6.4_kernel}

On high resolutions and refresh rates, the MCLK (vram / memory clock) may be locked at the highest clock rate (1000MHz)
[16](https://gitlab.freedesktop.org/drm/amd/-/issues/1403) [17](https://gitlab.freedesktop.org/drm/amd/-/issues/2646)
causing higher GPU idle power draw. On Linux kernel 6.4.x, MCLK clocks at the lowest (96MHz), causing low performance in
games [18](https://gitlab.freedesktop.org/drm/amd/-/issues/2657)
[19](https://gitlab.freedesktop.org/drm/amd/-/issues/2611).

This is likely due to a monitor not using Coordinated Video Timings (CVT) with a low V-Blank value for the affected
resolutions and refresh rates, see [this gist](https://gist.github.com/Rend0e/3bddac4285dc1f4fbe303f326f36f6cc) for a
workaround.

### Failure to suspend to RAM {#failure_to_suspend_to_ram}

The `{{ic|amdgpu}}`{=mediawiki} kernel module tries to buffer VRAM in RAM when the system enters S3 to prevent memory
loss through VRAM decay which is not sufficiently refreshed.

If you are using a lot of VRAM and are short on free RAM [this can
fail](https://gitlab.freedesktop.org/drm/amd/-/issues/2125) despite sufficient SWAP memory would be available, because
the IO subsystem might have been suspended before.

You will see something like:

`kernel: systemd-sleep: page allocation failure: order:0, mode:0x100c02(GFP_NOIO|__GFP_HIGHMEM|__GFP_HARDWALL), nodemask=(null),cpuset=/,mems_allowed=0`\
`kernel: Call Trace:`\
`kernel:  `

```{=html}
<TASK>
```
`kernel:  dump_stack_lvl+0x47/0x60`\
`kernel:  warn_alloc+0x165/0x1e0`\
`kernel:  __alloc_pages_slowpath.constprop.0+0xd7d/0xde0`\
`kernel:  __alloc_pages+0x32d/0x350`\
`kernel:  ttm_pool_alloc+0x19f/0x600 [ttm 0bd92a9d9dccc3a4f19554535860aaeda76eb4f4]`

As a workaround, a [userspace service](https://git.dolansoft.org/lorenz/memreserver) can ensure to allocate enough RAM
for the VRAM to be buffered by swapping out enough RAM before the system is suspended.

### Wrong GPU clocks causing multiple issues {#wrong_gpu_clocks_causing_multiple_issues}

```{=mediawiki}
{{Accuracy|
* Users provide unreliable reports and operate under wrong assumptions. See [https://gitlab.freedesktop.org/drm/amd/-/issues/3131#note_3007563 explanation].
* If you carefully read through the related issues, the problem appear to be caused by some internal setup of GPU power profiles. Which means the shader clock frequency is not the actual issue here, lowering it is more of a workaround, and it decreases performance.
* Patches addressing the problem were already merged a few major kernel releases back.
* If you are still getting crashes with similar dmesg logs, consider disabling GFXOFF (see [https://gitlab.freedesktop.org/drm/amd/-/issues/3067#note_2959002])
}}
```
There is a bug in the amdgpu module, due to which the video core frequencies can be higher than those declared by the
manufacturer, which can cause system instability during the game, when exiting sleep, when rebooting.

The problem has been noticed on RDNA 3 GPUs (7XXX Models)
[20](https://www.reddit.com/r/linux_gaming/comments/1dyhizb/fyi_for_amd_card_owners_the_linux_kernel_is/)
[21](https://wiki.gentoo.org/wiki/AMDGPU#Frequent_and_Sporadic_Crashes)
[22](https://gitlab.freedesktop.org/drm/amd/-/issues/3131).

In dmesg you can see logs like theese:

`amdgpu: [gfxhub] page fault (src_id:0 ring:40 vmid:6 pasid:32830)`\
`amdgpu:  in process GameThread pid 100056 thread vkd3d_queue pid 100468)`\
`amdgpu:   in page starting at address 0x0000000218a36000 from client 10`\
`amdgpu: GCVM_L2_PROTECTION_FAULT_STATUS:0x00641051`\
`amdgpu:          Faulty UTCL2 client ID: TCP (0x8)`\
`amdgpu:          MORE_FAULTS: 0x1`\
`amdgpu:          WALKER_ERROR: 0x0`\
`amdgpu:          PERMISSION_FAULTS: 0x5`\
`amdgpu:          MAPPING_ERROR: 0x0`\
`amdgpu:          RW: 0x1`

If you have similar problems, check the maximum frequency of the video core in the system with what is stated by the
manufacturer. To decrease maximum frequency, refer to [#Overclocking](#Overclocking "wikilink").

### AMD dedicated GPU HDMI freezing issue on Wayland {#amd_dedicated_gpu_hdmi_freezing_issue_on_wayland}

```{=mediawiki}
{{Style|Unstructured rambling with no clear explanation of what is done nor why. No bug report or forum thread linked. If this is a model-specific issue, it should be documented in a dedicated laptop page like [[ASUS ROG Zephyrus G14 (2022) GA402]].}}
```
As an example, the ASUS G14 2022 laptop which as has AMD CPU and dedicated AMD GPU. The most successful approach
requires to use armor crate on Windows to enforce dGPU Ultimate power options. It\'s switching GPU order and laptop
internal power policies. Since that change HDMI should be working but user is going to experience separate rendering for
integrated GPU (which SDDM and Wayland somehow pick by default) and dedicated GPU. User can obviously add
`{{ic|1=DRI_PRIME=0}}`{=mediawiki} it this case before launching any application but its not convenient. Extending
configuration to presented one allows flawless experience in expense of shorter battery life when running on battery.

```{=mediawiki}
{{hc|/etc/sddm.conf.d/hardware.conf|2=
[General]
DisplayServer=wayland
[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts
Environment=DRI_PRIME=0
}}
```
Additionally kernel command line should be extended with

`amdgpu.runpm=0 amdgpu.modeset=1`

### Colors appear washed out and dim on laptops {#colors_appear_washed_out_and_dim_on_laptops}

Power-saving applications such as `{{Pkg|power-profiles-daemon}}`{=mediawiki} and `{{Pkg|tuned}}`{=mediawiki} have
started to [enable](https://www.phoronix.com/news/Power-Profiles-Daemon-0.20) a feature known as Panel Power Savings
(PPS).

PPS is a featured supported on Laptops in which the laptop\'s GPU is instructed to have a lower color accuracy in the
name of saving power. This, however, leads to washed out colors whenever selecting more aggressive power-saving modes on
the aforementioned power-profiles-daemon and tuned. Therefore, there is interest in disabling this feature entirely.

It can be done by setting the following [kernel parameter](kernel_parameter "wikilink") to zero:

`amdgpu.abmlevel=0`

### System freezes or reboots when idle {#system_freezes_or_reboots_when_idle}

Issues with some PowerPlay features, such as [GFXOFF](https://www.phoronix.com/news/AMDGPU-GFXOFF-Patches) can cause
frequent, unrecoverable driver crashes[23](https://forum.endeavouros.com/t/random-crashes-amdgpu/70453). They coincide
with idle GPU usage on a multi-monitor setup, and especially waking up from sleep mode.

A well-known solution is appending a kernel parameter (as described in [#Boot parameter](#Boot_parameter "wikilink"))
that disables PP_GFXOFF_MASK, for example `{{ic|1=amdgpu.ppfeaturemask=0xffff7fff}}`{=mediawiki} - this particular one
leaves all other (implemented and unimplemented) PowerPlay features enabled.

Alternative solutions rely on disabling more features than just GFXOFF:

-   Disable [PP_GFXOFF_MASK and PP_STUTTER_MODE](https://www.reddit.com/r/linux4noobs/comments/1ahb8pf/comment/koppio6/)
    with `{{ic|0xfffd7fff}}`{=mediawiki},
-   Disable [PP_GFXOFF_MASK, PP_STUTTER_MODE and
    PP_OVERDRIVE_MASK](https://forum.endeavouros.com/t/random-crashes-amdgpu/70453/7?u=krzeszny) with
    `{{ic|0xfffd3fff}}`{=mediawiki},
-   Disable [PP_GFXOFF_MASK, PP_GFX_DCS_MASK and
    PP_OVERDRIVE_MASK](https://forum.endeavouros.com/t/random-crashes-amdgpu/70453/15?u=krzeszny) with
    `{{ic|0xfff73fff}}`{=mediawiki},
-   Disable every feature with `{{ic|0}}`{=mediawiki} (or `{{ic|0x0}}`{=mediawiki}). This can be used if the cause of
    driver crashes is unknown.

You can create your own feature mask from `{{ic|1=amdgpu.ppfeaturemask=0x}}`{=mediawiki} followed by an 8-character mask
calculated with a [hexadecimal bitwise
calculator](https://miniwebtool.com/bitwise-calculator/?data_type=16&number1=ffffffff&number2=8000&operator=XOR)
(example included). Start the mask with `{{ic|ffffffff}}`{=mediawiki} (all bits enabled) **XOR** [the feature to
mask](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/amd/include/amd_shared.h#n185).
You can keep \"XORing\" more features to the result. You can skip zeroes before the first non-zero character: for
example, 0x8000 is equivalent to 0x00008000.

Make sure the parameter does not get removed during kernel updates.

### HDMI 4K capped at 120hz {#hdmi_4k_capped_at_120hz}

Due to [licensing issues](https://www.phoronix.com/news/HDMI-2.1-OSS-Rejected) the `{{pkg|mesa}}`{=mediawiki} driver
cannot support HDMI 2.1. You must use DisplayPort. If your display does not support DisplayPort, some users have
[reported success with converter
devices](https://www.reddit.com/r/linux_gaming/comments/1nh5y0f/hdmi_21_works_on_amd_gpu_with_this_converter/) that take
DisplayPort input and output HDMI 2.1 signals.

## See also {#see_also}

-   [Gentoo:AMDGPU](Gentoo:AMDGPU "wikilink")
-   [AMDGPU issue tracker](https://gitlab.freedesktop.org/drm/amd)

[Category:Graphics](Category:Graphics "wikilink") [Category:X server](Category:X_server "wikilink")

[ja:NVIDIA/ヒントとテクニック](ja:NVIDIA/ヒントとテクニック "ja:NVIDIA/ヒントとテクニック"){.wikilink} [ru:NVIDIA
(Русский)/Tips and tricks](ru:NVIDIA_(Русский)/Tips_and_tricks "ru:NVIDIA (Русский)/Tips and tricks"){.wikilink}
[zh-hans:NVIDIA/提示和技巧](zh-hans:NVIDIA/提示和技巧 "zh-hans:NVIDIA/提示和技巧"){.wikilink}

## Fixing terminal resolution {#fixing_terminal_resolution}

Since [NVIDIA#fbdev](NVIDIA#fbdev "NVIDIA#fbdev"){.wikilink} is enabled by default, the [Linux
console](Linux_console "Linux console"){.wikilink} should use the native monitor resolution without additional
configuration.

If you have disabled `{{ic|fbdev}}`{=mediawiki} or use an older version of the driver, the resolution may be lower than
expected. As a workaround, you can set the resolution in your [boot loader](boot_loader "boot loader"){.wikilink}
configuration.

For GRUB, see [GRUB/Tips and tricks#Setting the framebuffer
resolution](GRUB/Tips_and_tricks#Setting_the_framebuffer_resolution "GRUB/Tips and tricks#Setting the framebuffer resolution"){.wikilink}
for details. [1](https://forums.fedoraforum.org/showthread.php?t=306271)
[2](https://web.archive.org/web/20170405115954/https://www.reddit.com/r/archlinux/comments/4gwukx/nvidia_drivers_and_high_resolution_tty_possible/)

For [systemd-boot](systemd-boot "systemd-boot"){.wikilink}, set `{{ic|console-mode}}`{=mediawiki} in
`{{ic|''esp''/loader/loader.conf}}`{=mediawiki}. See [systemd-boot#Loader
configuration](systemd-boot#Loader_configuration "systemd-boot#Loader configuration"){.wikilink} for details.

For [rEFInd](rEFInd "rEFInd"){.wikilink}, set `{{ic|use_graphics_for +,linux}}`{=mediawiki} in
`{{ic|''esp''/EFI/refind/refind.conf}}`{=mediawiki}.[3](https://www.reddit.com/r/archlinux/comments/86lqc5/tty_resolution_nvidia_psaish/)
A small caveat is that this will hide the kernel parameters from being shown during boot.

```{=mediawiki}
{{Tip|If the above methods do not fix your terminal resolution, it may be necessary to disable Legacy BIOS mode entirely (often referred to as Compatibility Support Module, CSM, or Legacy Boot) in your UEFI settings. Before proceeding, make sure that all of your devices are configured to use UEFI boot.}}
```
## Using TV-out {#using_tv_out}

See [Wikibooks:NVIDIA/TV-OUT](Wikibooks:NVIDIA/TV-OUT "Wikibooks:NVIDIA/TV-OUT"){.wikilink}.

## X with a TV (DFP) as the only display {#x_with_a_tv_dfp_as_the_only_display}

The X server falls back to some \"default\" screen resolution (usually 640x480) if no monitor is automatically detected.
This can be a problem when using a DVI/HDMI/DisplayPort connected TV as the main display, and X is started while the TV
is turned off or otherwise disconnected.

To force NVIDIA to use the correct resolution, store a copy of the EDID somewhere in the file system so that X can parse
the file instead of reading EDID from the display.

To acquire the EDID, start `{{ic|nvidia-settings}}`{=mediawiki}. It will show some information in tree format, ignore
the rest of the settings for now and select the GPU (the corresponding entry should be titled *GPU-0* or similar), click
the *DFP* section (again, *DFP-0* or similar), click on the *Acquire EDID\...* button and store it somewhere, for
example, `{{ic|/etc/X11/dfp0.edid}}`{=mediawiki}.

If in the front-end mouse and keyboard are not attached, the EDID can be acquired using only the command line. Run an X
server with enough verbosity to print out the EDID block:

`$ startx -- -logverbose 6`

After the X server has finished initializing, close it and extract the EDID block from the [Xorg log
file](Xorg#General "Xorg log file"){.wikilink} using *nvidia-xconfig*:

`$ nvidia-xconfig --extract-edids-from-file ~/.local/share/xorg/Xorg.0.log --extract-edids-output-file ./dfp0.bin`

Edit the Xorg configuration by adding to the `{{ic|Device}}`{=mediawiki} section:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-nvidia.conf|
Option "ConnectedMonitor" "DFP"
Option "CustomEDID" "DFP-0:/etc/X11/dfp0.bin"
}}
```
The `{{ic|ConnectedMonitor}}`{=mediawiki} option forces the driver to recognize the DFP as if it were connected. The
`{{ic|CustomEDID}}`{=mediawiki} provides EDID data for the device, meaning that it will start up just as if the TV/DFP
was connected during the X process.

This way, one can automatically start a display manager at boot time and still have a working and properly configured X
screen by the time the TV gets powered on.

## Headless (no monitor) resolution {#headless_no_monitor_resolution}

In headless mode, resolution falls back to 640x480, which is used by VNC or Steam Link. To start in a higher resolution
*e.g.* 1920x1080, specify a `{{ic|Virtual}}`{=mediawiki} entry under the `{{ic|Screen}}`{=mediawiki} subsection in
`{{ic|xorg.conf}}`{=mediawiki}:

`Section "Screen"`\
`   [...]`\
`   SubSection     "Display"`\
`       Depth       24`\
`       Virtual     1920 1080`\
`   EndSubSection`\
`EndSection`

```{=mediawiki}
{{Tip|Using headless mode may be tricky and prone to error. For instance, in headless mode, desktop environments and {{Pkg|nvidia-utils}} do not provide a graphical way to change resolution. To facilitate setting up resolution one can use a DP or an HDMI dummy adapter which simulates the presence of a monitor attached to that port. Then resolution change can be done normally using a remote session such as VNC or Steam Link.}}
```
## Check the power source {#check_the_power_source}

The NVIDIA X.org driver can also be used to detect the GPU\'s current source of power. To see the current power source,
check the \'GPUPowerSource\' read-only parameter (0 - AC, 1 - battery):

```{=mediawiki}
{{hc|$ nvidia-settings -q GPUPowerSource -t|1}}
```
## Listening to ACPI events {#listening_to_acpi_events}

NVIDIA drivers automatically try to connect to the [acpid](acpid "acpid"){.wikilink} daemon and listen to ACPI events
such as battery power, docking, some hotkeys, etc. If connection fails, X.org will output the following warning:

```{=mediawiki}
{{hc|~/.local/share/xorg/Xorg.0.log|
NVIDIA(0): ACPI: failed to connect to the ACPI event daemon; the daemon
NVIDIA(0):     may not be running or the "AcpidSocketPath" X
NVIDIA(0):     configuration option may not be set correctly.  When the
NVIDIA(0):     ACPI event daemon is available, the NVIDIA X driver will
NVIDIA(0):     try to use it to receive ACPI event notifications.  For
NVIDIA(0):     details, please see the "ConnectToAcpid" and
NVIDIA(0):     "AcpidSocketPath" X configuration options in Appendix B: X
NVIDIA(0):     Config Options in the README.
}}
```
While completely harmless, you may get rid of this message by disabling the `{{ic|ConnectToAcpid}}`{=mediawiki} option
in your `{{ic|/etc/X11/xorg.conf.d/20-nvidia.conf}}`{=mediawiki}:

`Section "Device"`\
`  ...`\
`  Driver "nvidia"`\
`  Option "ConnectToAcpid" "0"`\
`  ...`\
`EndSection`

If you are on laptop, it might be a good idea to install and enable the [acpid](acpid "acpid"){.wikilink} daemon
instead.

## Displaying GPU temperature in the shell {#displaying_gpu_temperature_in_the_shell}

There are three methods to query the GPU temperature. *nvidia-settings* requires that you are using X, *nvidia-smi* or
*nvclock* do not. Also note that *nvclock* currently does not work with newer NVIDIA cards such as GeForce 200 series
cards as well as embedded GPUs such as the Zotac IONITX\'s 8800GS.

### nvidia-settings {#nvidia_settings}

To display the GPU temp in the shell, use *nvidia-settings* as follows:

```{=mediawiki}
{{hc|$ nvidia-settings -q gpucoretemp|
  Attribute 'GPUCoreTemp' (hostname:0[gpu:0]): 49.
    'GPUCoreTemp' is an integer attribute.
    'GPUCoreTemp' is a read-only attribute.
    'GPUCoreTemp' can use the following target types: GPU.
}}
```
The GPU temps of this board is 49 °C.

In order to get just the temperature for use in utilities such as *rrdtool* or *conky*:

```{=mediawiki}
{{hc|$ nvidia-settings -q gpucoretemp -t|49}}
```
### nvidia-smi {#nvidia_smi}

Use *nvidia-smi* which can read temps directly from the GPU without the need to use X at all, e.g. when running Wayland
or on a headless server.

To display the GPU temperature in the shell, use *nvidia-smi*:

```{=mediawiki}
{{hc|$ nvidia-smi|<nowiki>
Wed Feb 28 14:27:35 2024
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 550.54.14              Driver Version: 550.54.14      CUDA Version: 12.4     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce GTX 1660 Ti     Off |   00000000:01:00.0  On |                  N/A |
|  0%   49C    P8              9W /  120W |     138MiB /   6144MiB |      2%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A    223179      G   weston                                        120MiB |
+-----------------------------------------------------------------------------------------+
</nowiki>}}
```
Only for temperature:

```{=mediawiki}
{{hc|$ nvidia-smi -q -d TEMPERATURE|2=
==============NVSMI LOG==============

Timestamp                                 : Wed Feb 28 14:27:35 2024
Driver Version                            : 550.54.14
CUDA Version                              : 12.4

Attached GPUs                             : 1
GPU 00000000:01:00.0
    Temperature
        GPU Current Temp                  : 49 C
        GPU T.Limit Temp                  : N/A
        GPU Shutdown Temp                 : 95 C
        GPU Slowdown Temp                 : 92 C
        GPU Max Operating Temp            : 90 C
        GPU Target Temperature            : 83 C
        Memory Current Temp               : N/A
        Memory Max Operating Temp         : N/A
}}
```
In order to get just the temperature for use in utilities such as *rrdtool* or *conky*:

```{=mediawiki}
{{hc|1=$ nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits|2=49}}
```
### nvclock

[Install](Install "Install"){.wikilink} the `{{AUR|nvclock}}`{=mediawiki} package.

```{=mediawiki}
{{Note|''nvclock'' cannot access thermal sensors on newer NVIDIA cards such as Geforce 200 series cards.}}
```
There can be significant differences between the temperatures reported by *nvclock* and *nvidia-settings*/*nv-control*.
According to [this post](https://sourceforge.net/projects/nvclock/forums/forum/67426/topic/1906899) by the author
(thunderbird) of *nvclock*, the *nvclock* values should be more accurate.

## Overclocking and cooling {#overclocking_and_cooling}

```{=mediawiki}
{{Warning|Overclocking might permanently damage your hardware. You have been warned.}}
```
### Enabling overclocking in nvidia-settings {#enabling_overclocking_in_nvidia_settings}

```{=mediawiki}
{{Note|
* Some overclocking settings cannot be applied if the Xorg server is running in rootless mode. Consider [[Xorg#Xorg as Root|running Xorg as root]].
* You may also need to run ''nvidia-settings'' as root.
* Enabling DRM kernel mode setting may cause overclocking to become unavailable, regardless of the Coolbits value.
}}
```
Depending on the driver version, some overclocking features are enabled by default. Some unsupported overclocking
features need to be enabled via the *Coolbits* option in the `{{ic|Device}}`{=mediawiki} section:

`Option "Coolbits" "`*`value`*`"`

```{=mediawiki}
{{Tip|The ''Coolbits'' option can be easily controlled with the ''nvidia-xconfig'', which manipulates the Xorg configuration files: {{bc|1=# nvidia-xconfig --cool-bits=''value''}}}}
```
The *Coolbits* value is the sum of its component bits in the binary numeral system. The component bits are:

- ```{=mediawiki}
  {{ic|8}}
  ```
  (bit 3) - Enables additional overclocking settings on the *PowerMizer* page in *nvidia-settings*. Available since
  version 337.12 for the Fermi architecture and newer. [4](https://www.phoronix.com/scan.php?px=MTY1OTM&page=news_item)

- ```{=mediawiki}
  {{ic|16}}
  ```
  (bit 4) - Enables overvoltage using *nvidia-settings* CLI options. Available since version 346.16 for the Fermi
  architecture and newer. [5](https://www.phoronix.com/scan.php?page=news_item&px=MTg0MDI)

If you use an unsupported version of the driver, you may also need to use these bits:

- ```{=mediawiki}
  {{ic|1}}
  ```
  (bit 0) - Enables overclocking of older (pre-Fermi) cores on the *Clock Frequencies* page in *nvidia-settings*.
  Removed in version 343.13.

- ```{=mediawiki}
  {{ic|2}}
  ```
  (bit 1) - When this bit is set, the driver will \"attempt to initialize SLI when using GPUs with different amounts of
  video memory\". Removed in version 470.42.01.

- ```{=mediawiki}
  {{ic|4}}
  ```
  (bit 2) - Enables manual configuration of GPU fan speed on the *Thermal Monitor* page in *nvidia-settings*. Removed in
  version 470.42.01.

To enable multiple features, add the *Coolbits* values together. For example, to enable overclocking and overvoltage of
Fermi cores, set `{{ic|Option "Coolbits" "24"}}`{=mediawiki}.

The documentation of *Coolbits* can be found in `{{ic|/usr/share/doc/nvidia/html/xconfigoptions.html}}`{=mediawiki} and
[here](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/xconfigoptions.html#Coolbits).

```{=mediawiki}
{{Note|An alternative is to edit and reflash the GPU BIOS either under DOS (preferred), or within a Win32 environment by way of [https://www.techpowerup.com/download/nvidia-nvflash/ nvflash] and [https://www.guru3d.com/files-details/nvidia-bios-editor-download-nibitor.html NiBiTor 6.0]. The advantage of BIOS flashing is that not only can voltage limits be raised, but stability is generally improved over software overclocking methods such as Coolbits. [https://ivanvojtko.blogspot.sk/2014/03/how-to-overclock-geforce-460gtx-fermi.html Fermi BIOS modification tutorial]}}
```
### Setting static 2D/3D clocks {#setting_static_2d3d_clocks}

Use [kernel module parameters](kernel_module_parameter "kernel module parameter"){.wikilink} to enable PowerMizer at its
maximum performance level (VSync will not work without this):

```{=mediawiki}
{{hc|/etc/modprobe.d/nvidia.conf|2=
options nvidia NVreg_RegistryDwords="PerfLevelSrc=0x2222"
}}
```
### Lowering GPU boost clocks {#lowering_gpu_boost_clocks}

With [Volta (NV140/GVXXX)](https://nouveau.freedesktop.org/CodeNames.html#NV140) GPUs and later, clock boost works in a
different way, and maximum clocks are set to the highest supported limit at boot. If that is what you want, then no
further configuration is necessary.

The drawback is the lower power efficiency. As the clocks go up, increased voltage is needed for stability, resulting in
a nonlinear increase in power consumption, heating, and fan noise. Lowering the boost clock limit will thus increase
efficiency.

Boost clock limits can be changed using *nvidia-smi*, running as root:

- List supported clock rates: `{{bc|$ nvidia-smi -q -d SUPPORTED_CLOCKS}}`{=mediawiki}
- Set GPU boost clock limit to 1695 MHz: `{{bc|# nvidia-smi --lock-gpu-clocks{{=}}`{=mediawiki}0,1695 \--mode{{=}}1}}
- Set Memory boost clock limit to 5001 MHz: `{{bc|# nvidia-smi --lock-memory-clocks{{=}}`{=mediawiki}0,5001}}

To optimize for efficiency, use *nvidia-smi* to check the GPU utilization while running your favorite game. VSync should
be on. Lowering the boost clock limit will increase GPU utilization, because a slower GPU will use more time to render
each frame. Best efficiency is achieved with the lowest clocks that do not cause the stutter that results when the
utilization hits 100%. Then, each frame can be rendered just quickly enough to keep up with the refresh rate.

As an example, using the above settings instead of default on an RTX 3090 Ti, while playing Hitman 3 at 4K@60, reduces
power consumption by 30%, temperature from 75 to 63 degrees, and fan speed from 73% to 57%.

### Saving overclocking settings {#saving_overclocking_settings}

Typically, clock and voltage offsets inserted in the *nvidia-settings* interface are not saved, being lost after a
reboot. Fortunately, there are tools that offer an interface for overclocking under the proprietary driver, able to save
the user\'s overclocking preferences and automatically applying them on boot. Some of them are:

- ```{=mediawiki}
  {{AUR|gwe}}
  ```
  \- graphical, applies settings on desktop session start

- ```{=mediawiki}
  {{AUR|nvclock}}
  ```
  and `{{AUR|systemd-nvclock-unit}}`{=mediawiki} - graphical, applies settings on system boot

- ```{=mediawiki}
  {{AUR|nvoc}}
  ```
  \- text based, profiles are configuration files in `{{ic|/etc/nvoc.d/}}`{=mediawiki}, applies settings on desktop
  session start

Otherwise, `{{ic|GPUGraphicsClockOffset}}`{=mediawiki} and `{{ic|GPUMemoryTransferRateOffset}}`{=mediawiki} attributes
can be set in the command-line interface of *nvidia-settings* on [startup](Autostarting "startup"){.wikilink}. For
example:

`$ nvidia-settings -a "GPUGraphicsClockOffset[`*`performance_level`*`]=`*`offset`*`"`\
`$ nvidia-settings -a "GPUMemoryTransferRateOffset[`*`performance_level`*`]=`*`offset`*`"`

Where `{{ic|''performance_level''}}`{=mediawiki} is the number of the highest performance level. If there are multiple
GPUs on the machine, the GPU ID should be specified:
`{{ic|1=[gpu:''gpu_id'']GPUGraphicsClockOffset[''performance_level'']=''offset''}}`{=mediawiki}.

### Custom TDP limit {#custom_tdp_limit}

```{=mediawiki}
{{Accuracy|It seems that not all cards support this. Among the 3 cards available to me: a desktop 3080 Ti, a mobile 1650 MaxQ, and a mobile 500 Ada, this only worked on the 3080 Ti; on the two laptops I got "not supported for GPU" warnings. Is this feature unavailable for mobile GPUs?}}
```
Modern NVIDIA graphics cards throttle frequency to stay in their TDP and temperature limits. To increase performance it
is possible to change the TDP limit, which will result in higher temperatures and higher power consumption.

For example, to set the power limit to 160.30W:

`# nvidia-smi -pl 160.30`

To set the power limit on boot (without driver persistence):

```{=mediawiki}
{{hc|/etc/systemd/system/nvidia-tdp.timer|2=
[Unit]
Description=Set NVIDIA power limit on boot

[Timer]
OnBootSec=5

[Install]
WantedBy=timers.target
}}
```
```{=mediawiki}
{{hc|/etc/systemd/system/nvidia-tdp.service|2=
[Unit]
Description=Set NVIDIA power limit

[Service]
Type=oneshot
ExecStart=/usr/bin/nvidia-smi -pl 160.30
}}
```
Now [enable](enable "enable"){.wikilink} the `{{ic|nvidia-tdp.timer}}`{=mediawiki}.

### Set fan speed at login {#set_fan_speed_at_login}

```{=mediawiki}
{{Accuracy|This will not work because manual configuration of GPU fan speed requires running ''nvidia-settings'' as root (even if Xorg itself is running as root).}}
```
You can adjust the fan speed on your graphics card with *nvidia-settings* console interface. First ensure that your Xorg
configuration has enabled the bit 2 in the [Coolbits](#Enabling_overclocking_in_nvidia-settings "Coolbits"){.wikilink}
option.

```{=mediawiki}
{{Note|GeForce 400/500 series cards cannot currently set fan speeds at login using this method. This method only allows for the setting of fan speeds within the current X session by way of ''nvidia-settings''.}}
```
Place the following line in your [xinitrc](xinitrc "xinitrc"){.wikilink} file to adjust the fan when you launch Xorg.
Replace `{{ic|''n''}}`{=mediawiki} with the fan speed percentage you want to set.

`nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=`*`n`*`"`

You can also configure a second GPU by incrementing the GPU and fan number.

`nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=`*`n`*`" \`\
`                -a "[gpu:1]/GPUFanControlState=1" -a  [fan:1]/GPUTargetFanSpeed=`*`n`*`" &`

If you use a login manager such as [GDM](GDM "GDM"){.wikilink} or [SDDM](SDDM "SDDM"){.wikilink}, you can create a
desktop entry file to process this setting. Create `{{ic|~/.config/autostart/nvidia-fan-speed.desktop}}`{=mediawiki} and
place this text inside it. Again, change `{{ic|''n''}}`{=mediawiki} to the speed percentage you want.

`[Desktop Entry]`\
`Type=Application`\
`Exec=nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=`*`n`*`"`\
`X-GNOME-Autostart-enabled=true`\
`Name=nvidia-fan-speed`

```{=mediawiki}
{{Note|Before driver version 349.16, {{ic|GPUCurrentFanSpeed}} was used instead of {{ic|GPUTargetFanSpeed}}.[https://devtalk.nvidia.com/default/topic/821563/linux/can-t-control-fan-speed-with-beta-driver-349-12/post/4526208/#4526208]}}
```
To make it possible to adjust the fanspeed of more than one graphics card, run:

`$ nvidia-xconfig --enable-all-gpus`\
`$ nvidia-xconfig --cool-bits=4`

```{=mediawiki}
{{Note|On some laptops (including the ThinkPad [https://devtalk.nvidia.com/default/topic/1052110/linux/can-t-control-gtx-1050-ti-max-q-fan-on-thinkpad-x1-extreme-laptop/post/5340658/#5340658 X1 Extreme] and [https://devtalk.nvidia.com/default/topic/1048624/linux/how-to-set-gpu-fan-speed/post/5321818/#5321818 P51/P52]), there are two fans, but neither are controlled by nvidia.}}
```
### Simple overclocking script using NVML {#simple_overclocking_script_using_nvml}

The Nvidia Management Library (NVML) provides an API that can manage the GPU\'s core and memory clock offsets and power
limit. To utilise this, you can install `{{AUR|python-nvidia-ml-py}}`{=mediawiki} and then use the following Python
script with your desired settings. This script needs to be run as root after every restart to re-apply the overclock /
undervolt.

```{=mediawiki}
{{bc|1=
#!/usr/bin/env python

from pynvml import *

nvmlInit()

# This sets the GPU to adjust - if this gives you errors or you have multiple GPUs, set to 1 or try other values
myGPU = nvmlDeviceGetHandleByIndex(0)

# The GPU clock offset value should replace "000" in the line below.
nvmlDeviceSetGpcClkVfOffset(myGPU, 000)

# The memory clock offset should be **multiplied by 2** to replace the "000" below
# For example, an offset of 500 means inserting a value of 1000 in the next line
nvmlDeviceSetMemClkVfOffset(myGPU, 000)

# The power limit can be set below in mW - 216W becomes 216000, etc. Remove the below line if you don't want to adjust power limits.
nvmlDeviceSetPowerManagementLimit(myGPU, 000000)
}}
```
## Kernel module parameters {#kernel_module_parameters}

Some options can be set as kernel module parameters, a full list can be obtained by running
`{{ic|modinfo nvidia}}`{=mediawiki} or looking at `{{ic|nv-reg.h}}`{=mediawiki}. See
[Gentoo:NVidia/nvidia-drivers#Kernel module
parameters](Gentoo:NVidia/nvidia-drivers#Kernel_module_parameters "Gentoo:NVidia/nvidia-drivers#Kernel module parameters"){.wikilink}
as well.

For example, enabling the following will enable the PAT feature [6](https://docs.kernel.org/arch/x86/pat.html), which
affects how memory is allocated. PAT was first introduced in Pentium III
[7](https://www.kernel.org/doc/ols/2008/ols2008v2-pages-135-144.pdf) and is supported by most newer CPUs (see
[wikipedia:Page attribute
table#Processors](wikipedia:Page_attribute_table#Processors "wikipedia:Page attribute table#Processors"){.wikilink}). If
your system can support this feature, it should improve performance.

```{=mediawiki}
{{hc|/etc/modprobe.d/nvidia.conf|2=
options nvidia NVreg_UsePageAttributeTable=1
}}
```
On some notebooks, to enable any NVIDIA settings tweaking you must include this option, otherwise it responds with
\"Setting applications clocks is not supported\" etc.

```{=mediawiki}
{{hc|/etc/modprobe.d/nvidia.conf|2=
options nvidia NVreg_RegistryDwords="OverrideMaxPerf=0x1"
}}
```
```{=mediawiki}
{{Note|As per [[Kernel module#Using modprobe.d]], you will need to [[regenerate the initramfs]] if using [[NVIDIA#DRM kernel mode setting|early KMS]].}}
```
## Preserve video memory after suspend {#preserve_video_memory_after_suspend}

By default the NVIDIA Linux drivers save and restore only essential video memory allocations on system suspend and
resume. Quoting NVIDIA:

:   The resulting loss of video memory contents is partially compensated for by the user-space NVIDIA drivers, and by
    some applications, but can lead to failures such as rendering corruption and application crashes upon exit from
    power management cycles.

The \"still experimental\" interface enables saving all video memory (given enough space on disk or RAM).

To save and restore all video memory contents, `{{ic|1=NVreg_PreserveVideoMemoryAllocations=1}}`{=mediawiki} [kernel
module parameter](kernel_module_parameter "kernel module parameter"){.wikilink} for the `{{ic|nvidia}}`{=mediawiki}
kernel module needs to be set. While NVIDIA does not set this by default, Arch Linux does so for the supported drivers,
making preserve work out of the box.

To verify that `{{ic|NVreg_PreserveVideoMemoryAllocations}}`{=mediawiki} is enabled, execute the following:

`# sort /proc/driver/nvidia/params`

Which should have a line `{{ic|PreserveVideoMemoryAllocations: 1}}`{=mediawiki}, and also
`{{ic|TemporaryFilePath: "/var/tmp"}}`{=mediawiki}, which you can read about below.

Necessary services `{{ic|nvidia-suspend.service}}`{=mediawiki}, `{{ic|nvidia-hibernate.service}}`{=mediawiki}, and
`{{ic|nvidia-resume.service}}`{=mediawiki} are [enabled](enabled "enabled"){.wikilink} by default on supported drivers,
as per upstream requirements.

See [NVIDIA\'s documentation](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/powermanagement.html) for
more details.

```{=mediawiki}
{{Note|
* When using [[NVIDIA#DRM kernel mode setting|early KMS]], i.e. when the loading of {{ic|nvidia}} module happens in the initramfs, it has no access to {{ic|NVreg_TemporaryFilePath}} which stores the previous video memory: early KMS should not be used if hibernation is desired.
* As per [[Kernel module#Using modprobe.d]], you will need to [[regenerate the initramfs]] if using early KMS.
* The video memory contents are by upstream default saved to {{ic|/tmp}}, which is a [[tmpfs]]. [https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/powermanagement.html#PreserveAllVide719f0 NVIDIA recommends] using an other filesystem to achieve the best performance. This is also required if the size is not sufficient for the amount of memory. Arch Linux thus sets {{ic|1=nvidia.NVreg_TemporaryFilePath=/var/tmp}} by default on supported drivers.
* The chosen file system containing the file needs to support unnamed temporary files (e.g. ext4 or XFS) and have sufficient capacity for storing the video memory allocations (i.e. at least 5 percent more than the sum of the memory capacities of all NVIDIA GPUs). Use the command {{ic|1=nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits}} to list the memory capacities of all GPUs in the system.
* While {{ic|nvidia-resume.service}} is marked as required by NVIDIA, it can be optional, as its functionality is also provided by a {{man|8|systemd-sleep}} hook ({{ic|/usr/lib/systemd/system-sleep/nvidia}}) and the latter is invoked automatically. Note that [https://gitlab.gnome.org/GNOME/gdm/-/issues/784 GDM with Wayland] however explicitly requires {{ic|nvidia-resume.service}} to be enabled.
}}
```
## Dynamic Boost {#dynamic_boost}

Dynamic Boost is a system-wide power controller which manages GPU and CPU power, according to the workload on the
system. [8](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/dynamicboost.html). It can particularly
improve performance in GPU-bound applications by raising the power limit accordingly.

The main requirement is laptops with Ampere (or newer) GPUs.

See [CPU frequency
scaling#nvidia-powerd](CPU_frequency_scaling#nvidia-powerd "CPU frequency scaling#nvidia-powerd"){.wikilink} for
detailed instructions.

```{=mediawiki}
{{Tip|It would especially help those unable to manually set power limit, see [[NVIDIA Optimus#Low power usage (TDP)]].}}
```
## Driver persistence {#driver_persistence}

NVIDIA has a daemon that can be optionally run at boot. In a standard single-GPU X desktop environment the persistence
daemon is not needed and can actually create issues
[9](https://devtalk.nvidia.com/default/topic/1044421/linux/nvidia-persistenced-causing-60-second-reboot-delays). See the
[Driver Persistence](https://docs.nvidia.com/deploy/driver-persistence/index.html#persistence-daemon) section of the
NVIDIA documentation for more details.

To start the persistence daemon at boot, [enable](enable "enable"){.wikilink} the
`{{ic|nvidia-persistenced.service}}`{=mediawiki}. For manual usage see the [upstream
documentation](https://docs.nvidia.com/deploy/driver-persistence/index.html#usage).

## Forcing YCbCr with 4:2:0 subsampling {#forcing_ycbcr_with_420_subsampling}

If you are facing [limitations of older output
standards](Wikipedia:HDMI#Refresh_frequency_limits_for_standard_video "limitations of older output standards"){.wikilink}
that can still be mitigated by using YUV 4:2:0, the NVIDIA driver has an undocumented X11 option to enforce that:

`Option "ForceYUV420" "True"`

This will allow higher resolutions or refresh rates but have detrimental impact on the image quality.

## Configure applications to render using GPU {#configure_applications_to_render_using_gpu}

See [PRIME#Configure applications to render using
GPU](PRIME#Configure_applications_to_render_using_GPU "PRIME#Configure applications to render using GPU"){.wikilink}.

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink} [Category:X
server](Category:X_server "Category:X server"){.wikilink}

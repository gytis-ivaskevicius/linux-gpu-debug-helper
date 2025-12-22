[ja:NVIDIA/トラブルシューティング](ja:NVIDIA/トラブルシューティング "wikilink") [ru:NVIDIA
(Русский)/Troubleshooting](ru:NVIDIA_(Русский)/Troubleshooting "wikilink")
[zh-hans:NVIDIA/Troubleshooting](zh-hans:NVIDIA/Troubleshooting "wikilink")

## Failure to start {#failure_to_start}

### System will not boot after driver was installed {#system_will_not_boot_after_driver_was_installed}

If after installing the [NVIDIA](NVIDIA "wikilink") driver your system becomes stuck before reaching the display
manager, try to [disable kernel mode setting](Kernel_mode_setting#Disabling_modesetting "wikilink").

### Xorg fails to load or Red Screen of Death {#xorg_fails_to_load_or_red_screen_of_death}

If you get a red screen and use GRUB, disable the GRUB framebuffer by editing `{{ic|/etc/default/grub}}`{=mediawiki} and
uncomment `{{ic|1=GRUB_TERMINAL_OUTPUT=console}}`{=mediawiki}. For more information see [GRUB/Tips and tricks#Disable
framebuffer](GRUB/Tips_and_tricks#Disable_framebuffer "wikilink").

### Black screen at X startup / Machine poweroff at X shutdown {#black_screen_at_x_startup_machine_poweroff_at_x_shutdown}

If you have installed an update of NVIDIA and your screen stays black after launching Xorg, or if shutting down Xorg
causes a machine poweroff, try the below workarounds:

-   Prepend `{{ic|xrandr --auto}}`{=mediawiki} to your [xinitrc](xinitrc "wikilink")
-   Use the `{{ic|1=rcutree.gp_init_delay=1}}`{=mediawiki} [kernel parameter](kernel_parameter "wikilink").
-   You can also try to add the `{{ic|nvidia}}`{=mediawiki} module directly to your
    [mkinitcpio.conf](mkinitcpio.conf "wikilink").

### Screen(s) found, but none have a usable configuration {#screens_found_but_none_have_a_usable_configuration}

Sometimes NVIDIA and X have trouble finding the active screen. If your graphics card has multiple outputs try plugging
your monitor into the other ones. On a laptop it may be because your graphics card has VGA/TV out. Xorg.0.log will
provide more info.

Another thing to try is adding an invalid `{{ic|Option "ConnectedMonitor"}}`{=mediawiki} to
`{{ic|Section "Device"}}`{=mediawiki} to force Xorg throw an error and show you how to correct it. See [the
documentation](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/xconfigoptions.html#ConnectedMonitor) for
more information about the ConnectedMonitor setting.

After re-run X see Xorg.0.log to get valid CRT-x,DFP-x,TV-x values.

```{=mediawiki}
{{ic|nvidia-xconfig --query-gpu-info}}
```
could be helpful.

### X fails with \"Failing initialization of X screen\" {#x_fails_with_failing_initialization_of_x_screen}

If `{{ic|/var/log/Xorg.0.log}}`{=mediawiki} says X server fails to initialize screen

`(EE) NVIDIA(G0): GPU screens are not yet supported by the NVIDIA driver`\
`(EE) NVIDIA(G0): Failing initialization of X screen`

and *nvidia-smi* says `{{ic|No running processes found}}`{=mediawiki}

The solution is at first reinstall latest `{{Pkg|nvidia-utils}}`{=mediawiki}, and then copy
`{{ic|/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf}}`{=mediawiki} to
`{{ic|/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf}}`{=mediawiki}, and then edit
`{{ic|/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf}}`{=mediawiki} and add the line
`{{ic|Option "PrimaryGPU" "yes"}}`{=mediawiki}. Restart the computer. The problem will be fixed.

### Xorg fails during boot, but otherwise starts fine {#xorg_fails_during_boot_but_otherwise_starts_fine}

On very fast booting systems, systemd may attempt to start the display manager before the NVIDIA driver has fully
initialized. You will see a message like the following in your logs only when Xorg runs during boot.

```{=mediawiki}
{{hc|/var/log/Xorg.0.log|output=
[     1.807] (EE) NVIDIA(0): Failed to initialize the NVIDIA kernel module. Please see the
[     1.807] (EE) NVIDIA(0):     system's kernel log for additional error messages and
[     1.808] (EE) NVIDIA(0):     consult the NVIDIA README for details.
[     1.808] (EE) NVIDIA(0):  *** Aborting ***
}}
```
In this case you will need to establish an ordering dependency from the display manager to the DRI device. First create
device units for DRI devices by creating a new udev rules file.

```{=mediawiki}
{{hc|/etc/udev/rules.d/99-systemd-dri-devices.rules|output=
ACTION=="add", KERNEL=="card*", SUBSYSTEM=="drm", TAG+="systemd"
}}
```
Then create dependencies from the display manager to the device(s).

```{=mediawiki}
{{hc|/etc/systemd/system/display-manager.service.d/10-wait-for-dri-devices.conf|output=
[Unit]
Wants=dev-dri-card0.device
After=dev-dri-card0.device
}}
```
If you have additional cards needed for the desktop then list them in Wants and After seperated by spaces.

### Black screen on systems with integrated GPU {#black_screen_on_systems_with_integrated_gpu}

If you have a system with an integrated GPU (e.g. Intel HD 4000, VIA VX820 Chrome 9 or AMD Cezanne) and have installed
the `{{AUR|nvidia-580xx-dkms}}`{=mediawiki} or earlier package, you may experience a black screen on boot, when changing
virtual terminal, or when exiting an X session. This may be caused by a conflict between the graphics modules. This is
solved by blacklisting the relevant GPU modules. Create the file `{{ic|/etc/modprobe.d/blacklist.conf}}`{=mediawiki} and
prevent the relevant modules from loading on boot:

```{=mediawiki}
{{hc|/etc/modprobe.d/blacklist.conf|
install i915 /usr/bin/false
install intel_agp /usr/bin/false
install viafb /usr/bin/false
install radeon /usr/bin/false
install amdgpu /usr/bin/false
}}
```
### X fails with \"no screens found\" when using Multiple GPUs {#x_fails_with_no_screens_found_when_using_multiple_gpus}

In situations where you might have multiple GPUs on a system and X fails to start with:

`[ 76.633] (EE) No devices detected.`\
`[ 76.633] Fatal server error:`\
`[ 76.633] no screens found`

then you need to add your discrete card\'s BusID to your X configuration. This can happen on systems with an Intel CPU
and an integrated GPU or if you have more than one NVIDIA card connected. Find your BusID:

```{=mediawiki}
{{hc|# lspci -d ::03xx|
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
01:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GTX 650] (rev a1)
08:00.0 3D controller: NVIDIA Corporation GM108GLM [Quadro K620M / Quadro M500M] (rev a2)
}}
```
Then you fix it by adding it to the card\'s Device section in your X configuration. In my case:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-nvidia.conf|
Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BusID          "PCI:1:0:0"
EndSection
}}
```
```{=mediawiki}
{{Note|BusID formatting is important!}}
```
In the example above `{{ic|01:00.0}}`{=mediawiki} is stripped to be written as `{{ic|1:0:0}}`{=mediawiki}, however some
conversions can be more complicated. `{{ic|lspci}}`{=mediawiki} output is in hex format, but in configuration files the
BusID\'s are in decimal format! This means that in cases where the BusID is greater than 9 you will need to convert it
to decimal!

ie: `{{ic|5e:00.0}}`{=mediawiki} from lspci becomes `{{ic|PCI:94:0:0}}`{=mediawiki}.

=== Modprobe Error: \"Could not insert \'nvidia\': No such device\" on linux \>=4.8 ===

With linux 4.8, one can get the following errors when trying to use the discrete card:

```{=mediawiki}
{{hc|# modprobe nvidia -vv|
modprobe: INFO: custom logging function 0x409c10 registered
modprobe: INFO: Failed to insert module '/lib/modules/4.8.6-1-ARCH/extramodules/nvidia.ko.gz': No such device
modprobe: ERROR: could not insert 'nvidia': No such device
modprobe: INFO: context 0x24481e0 released
insmod /lib/modules/4.8.6-1-ARCH/extramodules/nvidia.ko.gz
}}
```
```{=mediawiki}
{{hc|# dmesg|
...
NVRM: The NVIDIA GPU 0000:01:00.0 (PCI ID: 10de:139b)
NVRM: installed in this system is not supported by the 370.28
NVRM: NVIDIA Linux driver release.  Please see 'Appendix
NVRM: A - Supported NVIDIA GPU Products' in this release's
NVRM: README, available on the Linux driver download page
NVRM: at www.nvidia.com.
...
}}
```
This problem is caused by bad commits pertaining to PCIe power management in the Linux Kernel (as documented in [this
NVIDIA DevTalk
thread](https://devtalk.nvidia.com/default/topic/971733/-370-28-with-kernel-4-8-on-gt-2015-machines-driver-claims-card-not-supported-if-nvidia-is-not-primary-card/)).

The workaround is to add `{{ic|1=pcie_port_pm=off}}`{=mediawiki} to your [kernel
parameters](kernel_parameters "wikilink"). Note that this disables PCIe power management for all devices.

### System does not return from suspend {#system_does_not_return_from_suspend}

What you see in the log:

`kernel: nvidia-modeset: ERROR: GPU:0: Failed detecting connected display devices`\
`kernel: nvidia-modeset: ERROR: GPU:0: Failed detecting connected display devices`\
`kernel: nvidia-modeset: WARNING: GPU:0: Failure processing EDID for display device DELL U2412M (DP-0).`\
`kernel: nvidia-modeset: WARNING: GPU:0: Unable to read EDID for display device DELL U2412M (DP-0)`\
`kernel: nvidia-modeset: ERROR: GPU:0: Failure reading maximum pixel clock value for display device DELL U2412M (DP-0).`

A possible solution based on
[1](https://forums.developer.nvidia.com/t/solution-for-nvidia-sleep-wake-issue-in-linux/110911):

Run this command to get the `{{ic|''version''}}`{=mediawiki} string:

`# strings /sys/firmware/acpi/tables/DSDT | grep -i 'windows ' | sort | tail -1`

Add the `{{ic|1=acpi_osi=! "acpi_osi=''version''"}}`{=mediawiki} [kernel parameter](kernel_parameter "wikilink") to your
[boot loader](boot_loader "wikilink") configuration.

Another possible cause to the issue could be the use of the `{{Pkg|nvidia-open}}`{=mediawiki} package, as described
here:

-   <https://bbs.archlinux.org/viewtopic.php?pid=2047692>
-   <https://github.com/NVIDIA/open-gpu-kernel-modules/issues/450>
-   <https://github.com/NVIDIA/open-gpu-kernel-modules/issues/223>
-   <https://github.com/NVIDIA/open-gpu-kernel-modules/issues/94>

### Black screen returning from suspend {#black_screen_returning_from_suspend}

If experiencing black screen issues and logs containing:

`archlinux kernel: NVRM: GPU at PCI:0000:08:00: GPU-926ecdb0-adb1-6ee9-2fad-52e7214c5011`\
`archlinux kernel: NVRM: Xid (PCI:0000:08:00): 13, pid='``<unknown>`{=html}`', name=``<unknown>`{=html}`, Graphi>`\
`archlinux kernel: NVRM: Xid (PCI:0000:08:00): 13, pid='``<unknown>`{=html}`', name=``<unknown>`{=html}`, Graphi>`\
`archlinux kernel: NVRM: Xid (PCI:0000:08:00): 13, pid='``<unknown>`{=html}`', name=``<unknown>`{=html}`, Graphi>`\
`archlinux kernel: NVRM: Xid (PCI:0000:08:00): 13, pid='``<unknown>`{=html}`', name=``<unknown>`{=html}`, Graphi>`\
`archlinux kernel: NVRM: Xid (PCI:0000:08:00): 13, pid='``<unknown>`{=html}`', name=``<unknown>`{=html}`, Graphi>`

You need to enable the NVIDIA suspend, hibernate and sleep services as explained in [NVIDIA/Tips and tricks#Preserve
video memory after suspend](NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend "wikilink").

## Crashes and hangs {#crashes_and_hangs}

### Crashing in general {#crashing_in_general}

-   Try [disabling the GSP firmware](#GSP_firmware "wikilink").
-   Try disabling `{{ic|RenderAccel}}`{=mediawiki} in xorg.conf.
-   If Xorg outputs an error about `{{ic|"conflicting memory type"}}`{=mediawiki} or
    `{{ic|"failed to allocate primary buffer: out of memory"}}`{=mediawiki}, or crashes with a \"Signal 11\" while using
    nvidia-96xx drivers, add `{{ic|nopat}}`{=mediawiki} to your [kernel parameters](kernel_parameters "wikilink").
-   If the NVIDIA compiler complains about different versions of GCC between the current one and the one used for
    compiling the kernel, add in `{{ic|/etc/profile}}`{=mediawiki}:

`export IGNORE_CC_MISMATCH=1`

-   If fullscreen applications are freezing or crashing, try enabling `{{ic|Display Compositing}}`{=mediawiki} and
    `{{ic|Direct fullscreen rendering}}`{=mediawiki} options in your desktop environment\'s settings.

### Bad support of mesh shaders {#bad_support_of_mesh_shaders}

This bug is present only for new games that depend on them, like Final Fantasy VII Rebirth. This is reflected in the
absence of environments when using NVIDIA GPUs even with latest beta drivers.
[2](https://github.com/ValveSoftware/Proton/issues/8408)

However, [pyroveil](https://github.com/ValveSoftware/Proton/issues/8408#issuecomment-2657340142), recently developed,
allows you to get around the problem with SPIR-V, while waiting for a fix from NVIDIA.

You need to compile and install the tool by following [the tutorial on
GitHub](https://github.com/HansKristian-Work/pyroveil#pyroveil), then run the game with the
`{{ic|1=PYROVEIL=1}}`{=mediawiki} and
`{{ic|1=PYROVEIL_CONFIG=''/path/to/pyroveil''/hacks/''ffvii-rebirth-nvidia''/pyroveil.json}}`{=mediawiki} [environment
variables](environment_variables "wikilink").

### Visual glitches, hangs and errors in OpenGL applications {#visual_glitches_hangs_and_errors_in_opengl_applications}

If you are using a recent CPU (Intel Sandy Bridge (2011) and later or AMD Zen (2017) and later) it has a micro
operations cache. Using a micro op cache can lead to problems with NVIDIA\'s driver in OpenGL due to Cache Aliasing
[3](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/knownissues.html). You usually are able to disable
the micro op cache in your systems BIOS, but this comes at the cost of performance
[4](https://chipsandcheese.com/2021/07/03/how-zen-2s-op-cache-affects-performance/). Disabling the micro op cache also
helps with the most severe graphical glitches in Xwayland applications, although it does not solve the problem fully
[5](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/wayland-issues.html).

### Kernel panic when updating and/or rebooting the system {#kernel_panic_when_updating_andor_rebooting_the_system}

This is a known bug that is present in the NVIDIA 550 series drivers.
[6](https://forums.developer.nvidia.com/t/series-550-freezes-laptop/284772) As of yet the cause is unknown however it
only appears to affect laptops. See [BBS#293400](https://bbs.archlinux.org/viewtopic.php?id=293400&p=3) for more
details.

To workaround this issue, switch to `{{Pkg|nvidia-open-dkms}}`{=mediawiki} if supported by the hardware, otherwise use
`{{AUR|nvidia-535xx-dkms}}`{=mediawiki} instead.

### GSP firmware {#gsp_firmware}

The use of the [GSP firmware](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/gsp.html), enabled by
default since version 555 of the NVIDIA driver released in June 2024, is known to cause [a range of
issues](https://bbs.archlinux.org/viewtopic.php?pid=2181317) including [Vulkan](Vulkan "wikilink") failures and system
crashes.

To disable it, use the `{{ic|1=NVreg_EnableGpuFirmware=0}}`{=mediawiki} [module parameter](module_parameter "wikilink")
for the `{{ic|nvidia}}`{=mediawiki} kernel module. This only works with the proprietary NVIDIA driver: see
[NVIDIA#Installation](NVIDIA#Installation "wikilink") if switching from the open source driver.

Do not forget to [regenerate the initramfs](regenerate_the_initramfs "wikilink") if needed. To have this new kernel
module option take effect, reboot.

## Visual issues {#visual_issues}

### Avoid screen tearing {#avoid_screen_tearing}

```{=mediawiki}
{{Note|
* This has been reported to reduce the performance of some OpenGL applications and may produce issues in WebGL. It also drastically increases the time the driver needs to clock down after load ([https://forums.developer.nvidia.com/t/if-you-have-gpu-clock-boost-problems-please-try-gl-experimentalperfstrategy-1/71762 NVIDIA Support Thread]).
* {{ic|ForceFullCompositionPipeline}} is known [https://github.com/ValveSoftware/Proton/issues/6869 to break some games] using Vulkan under Proton with NVIDIA driver 535.
}}
```
Tearing can be avoided by forcing a full composition pipeline, regardless of the compositor you are using. To test
whether this option will work, run:

`$ nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"`

Or click on the *Advanced* button that is available on the *X Server Display Configuration* menu option. Select either
*Force Composition Pipeline* or *Force Full Composition Pipeline* and click on *Apply*.

In order to make the change permanent, it must be added to the `{{ic|"Screen"}}`{=mediawiki} section of the
[Xorg](Xorg "wikilink") configuration file. When making this change, `{{ic|TripleBuffering}}`{=mediawiki} should be
enabled and `{{ic|AllowIndirectGLXProtocol}}`{=mediawiki} should be disabled in the driver configuration as well. See
example configuration below:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-nvidia.conf|2=
Section "Device"
        Identifier "NVIDIA Card"
        Driver     "nvidia"
        VendorName "NVIDIA Corporation"
        BoardName  "GeForce GTX 1050 Ti"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Device0"
    Monitor        "Monitor0"
    Option         "ForceFullCompositionPipeline" "on"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
EndSection
}}
```
If you do not have an Xorg configuration file, you can create one for your present hardware using
`{{ic|nvidia-xconfig}}`{=mediawiki} (see [NVIDIA#Automatic configuration](NVIDIA#Automatic_configuration "wikilink"))
and move it from `{{ic|/etc/X11/xorg.conf}}`{=mediawiki} to the preferred location
`{{ic|/etc/X11/xorg.conf.d/20-nvidia.conf}}`{=mediawiki}.

```{=mediawiki}
{{Note|Many of the configuration options produced in {{ic|20-nvidia.conf}} by using {{ic|nvidia-xconfig}} are set automatically by the driver and are not needed. To only use this file for enabling composition pipeline, only the section {{ic|"Screen"}} containing lines with values for {{ic|Identifier}} and {{ic|Option}} are necessary. Other sections may be removed from this file.}}
```
#### Multi-monitor {#multi_monitor}

For multi-monitor setup you will need to specify `{{ic|1=ForceCompositionPipeline=On}}`{=mediawiki} for each display.
For example:

`$ nvidia-settings --assign CurrentMetaMode="DP-2: nvidia-auto-select +0+0 {ForceCompositionPipeline=On}, DP-4: nvidia-auto-select +3840+0 {ForceCompositionPipeline=On}"`

Without doing this, the `{{ic|nvidia-settings}}`{=mediawiki} command will disable your secondary display.

You can get the current screen names and offsets using `{{ic|--query}}`{=mediawiki}:

`$ nvidia-settings --query CurrentMetaMode`

The above line is for two 3840x2160 monitors connected to DP-2 and DP-4. You will need to read the correct
`{{ic|CurrentMetaMode}}`{=mediawiki} by exporting `{{ic|xorg.conf}}`{=mediawiki} and append
`{{ic|ForceCompositionPipeline}}`{=mediawiki} to each of your displays. Setting
`{{ic|ForceCompositionPipeline}}`{=mediawiki} only affects the targeted display.

```{=mediawiki}
{{Tip|Multi monitor setups using different model monitors may have slightly different refresh rates. If vsync is enabled by the driver it will sync to only one of these refresh rates which can cause the appearance of screen tearing on incorrectly synced monitors. Select to sync the display device which is the primarily used monitor as others will not sync properly. This is configurable in {{ic|~/.nvidia-settings-rc}} as {{ic|1=0/XVideoSyncToDisplayID=}} or by installing {{pkg|nvidia-settings}} and using the graphical configuration options.}}
```
### Screen corruption after resuming from suspend or hibernation {#screen_corruption_after_resuming_from_suspend_or_hibernation}

This also applies if an external monitor does not wake up after suspend or hibernation.

See [NVIDIA/Tips and tricks#Preserve video memory after
suspend](NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend "wikilink")

A corruption after suspend bug when using [GDM](GDM "wikilink") service was solved as of driver version 515.43.04
[7](https://forums.developer.nvidia.com/t/corrupted-graphics-upon-resume-gnome-41-x-org-495-44-driver/194565/18).

### Corrupted screen: \"Six screens\" Problem {#corrupted_screen_six_screens_problem}

For some users, using GeForce GT 100M\'s, the screen gets corrupted after X starts, divided into 6 sections with a
resolution limited to 640x480. The same problem has been reported with Quadro 2000 and hi-res displays.

To solve this problem, enable the Validation Mode `{{ic|NoTotalSizeCheck}}`{=mediawiki} in section
`{{ic|Device}}`{=mediawiki}:

`Section "Device"`\
` ...`\
` Option "ModeValidation" "NoTotalSizeCheck"`\
` ...`\
`EndSection`

### Invisible text and icons with nvidia-470 {#invisible_text_and_icons_with_nvidia_470}

An update of GTK4 brought an issue for users relying on the nvidia-470 driver for legacy cards. After the update text
and icons randomly disappear and re-appear only after hovering with the mouse over the
windows.[8](https://forums.developer.nvidia.com/t/multiple-apps-do-not-invalidate-repaint-screen-correctly-with-geforce-gt-730-and-v470-driver-on-ubuntu-24-04/291106/2)

See [the forum](https://bbs.archlinux.org/viewtopic.php?pid=2159644#p2159644) for work-arounds.

### Fix graphical corruption in GNOME Shell when resuming from sleep {#fix_graphical_corruption_in_gnome_shell_when_resuming_from_sleep}

If you are facing strange fonts and/or having weird graphical glitches in [GNOME Shell](GNOME_Shell "wikilink") when
resuming from sleep, try setting the following [kernel parameter](kernel_parameter "wikilink") to enable power
management:

`nvidia.NVreg_DynamicPowerManagement=0x02`

More info: <https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/dynamicpowermanagement.html>

### System freeze when the display powers off or on resume {#system_freeze_when_the_display_powers_off_or_on_resume}

If the system freezes or crashes right after the desktop environment turns off the display (DPMS) or when resuming from
suspend, and dmesg/journal shows a GSP timeout like:

`NVRM: _kgspLogXid119: ********************************* GSP Timeout **********************************`\
`NVRM: Xid (PCI:0000:01:00): 119, Timeout after 6s of waiting for RPC response from GPU0 GSP! Expected function 76 (GSP_RM_CONTROL) sequence 1321 `

the GPU may be dropping to an unstable low clock state during these power transitions.

Workaround: lock a higher minimum GPU/memory clock with nvidia-smi.

Prerequisites:

[Enable](Enable "wikilink")/[start](start "wikilink") the `{{ic|nvidia-persistenced.service}}`{=mediawiki}.

Find supported clock values (use these to pick valid min/max pairs):

`nvidia-smi -q -d SUPPORTED_CLOCKS`\
`nvidia-smi -q -d CLOCK`

Temporary test

Set minimum clocks (example values; adjust to your GPU's max supported clocks):

`nvidia-smi -lgc 800,2100`\
`nvidia-smi -lmc 800,10000`\
`Test DPMS and suspend/resume to see if the issue is resolved.`\
`   To revert:`\
`nvidia-smi -rgc`\
`nvidia-smi -rmc`

Permanent configuration (systemd) Create a unit such as `{{ic|nvidia-clocks.service}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/systemd/system/nvidia-clocks.service|2=
[Unit]
Description=Set NVIDIA GPU minimum clocks to avoid  GSP timeouts
Requires=nvidia-persistenced.service
After=nvidia-persistenced.service 

[Service]
Type=oneshot
ExecStart=/usr/bin/nvidia-smi -lgc 500,2100
ExecStart=/usr/bin/nvidia-smi -lmc 500,10000
RemainAfterExit=yes 

[Install]
WantedBy=multi-user.target 
}}
```
You can adjust the minimum clock so they are lower than the 800 mentioned earlier to lower idle power consumption; just
be aware that setting them to low will cause the issue to occur again.

Then [enable](enable "wikilink")/[start](start "wikilink") `{{ic|nvidia-clocks.service}}`{=mediawiki}.

## Performance issues {#performance_issues}

### Bad performance after installing a new driver version {#bad_performance_after_installing_a_new_driver_version}

```{=mediawiki}
{{Accuracy|We should be trying to find the root cause (read dmesg, dkms logs etc.), not mindlessly downgrading the driver.}}
```
If FPS have dropped in comparison with older drivers, check if direct rendering is enabled (`{{ic|glxinfo}}`{=mediawiki}
is included in `{{Pkg|mesa-utils}}`{=mediawiki}):

`$ glxinfo | grep direct`

If the command prints:

`direct rendering: No`

A possible solution could be to regress to the previously installed driver version and rebooting afterwards.

### Extreme lag on Xorg {#extreme_lag_on_xorg}

```{=mediawiki}
{{Accuracy|According to [https://gitlab.gnome.org/GNOME/mutter/-/issues/2233#note_1538392 an NVIDIA developer] this issue is not specific to GNOME and the rest of the comments on the issue do not mention multi-monitor setups.}}
```
A common issue with Mutter is that [animations, video playback and gaming cause extreme desktop lag on
Xorg](https://gitlab.gnome.org/GNOME/mutter/-/issues/2233).

See [NVIDIA/Tips and tricks#Preserve video memory after
suspend](NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend "wikilink").

This should resolve this issue, however if it did not, you are most likely out of luck. One way you can remedy this
issue is by adding these options:

```{=mediawiki}
{{hc|/etc/environment|2=
CLUTTER_DEFAULT_FPS=''YOUR_MAIN_DISPLAY_REFRESHRATE''
__GL_SYNC_DISPLAY_DEVICE=''YOUR_MAIN_DISPLAY_OUTPUT_NAME''
}}
```
turning *Sync to VBlank* and *Allow flipping* off within NVIDIA Settings, and configuring NVIDIA Settings to launch on
startup using the flag `{{ic|--load-config-only}}`{=mediawiki}. This will still result in a laggy desktop behavior, in
particular on an eventual second (or third) monitor, but it should be much better.

### CPU spikes with 400 series cards {#cpu_spikes_with_400_series_cards}

If you are experiencing intermittent CPU spikes with a 400 series card, it may be caused by PowerMizer constantly
changing the GPU\'s clock frequency. Switching PowerMizer\'s setting from Adaptive to Performance, add the following to
the `{{ic|Device}}`{=mediawiki} section of your Xorg configuration:

` Option "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x3322; PowerMizerDefaultAC=0x1"`

## Other issues {#other_issues}

### Vulkan error on applications start {#vulkan_error_on_applications_start}

```{=mediawiki}
{{Accuracy|Need confirmation by other users}}
```
On executing an application that require Vulkan acceleration, if you get this error

`Vulkan call failed: -4`

try to delete the `{{ic|~/.nv}}`{=mediawiki} or `{{ic|~/.cache/nvidia}}`{=mediawiki} directory.

### No audio over HDMI {#no_audio_over_hdmi}

Sometimes NVIDIA HDMI audio devices are not shown when you do

`$ aplay -l`

On some new machines, the audio chip on the NVIDIA GPU is disabled at boot. Read more on [NVIDIA\'s
website](https://devtalk.nvidia.com/default/topic/1024022/linux/gtx-1060-no-audio-over-hdmi-only-hda-intel-detected-azalia/?offset=4)
and a [forum post](https://bbs.archlinux.org/viewtopic.php?id=230125).

You need to reload the NVIDIA device with audio enabled. In order to do that make sure that your GPU is on (in case of
laptops/Bumblebee) and that you are not running X on it, because it is going to reset:

`# setpci -s 01:00.0 0x488.l=0x2000000:0x2000000`\
`# rmmod nvidia-drm nvidia-modeset nvidia`\
`# echo 1 > /sys/bus/pci/devices/0000:01:00.0/remove`\
`# echo 1 > /sys/bus/pci/devices/0000:00:01.0/rescan`\
`# modprobe nvidia-drm`\
`# xinit -- -retro`

If you are running your TTY on NVIDIA, put the lines in a script so you do not end up with no screen.

### Backlight is not turning off in some occasions {#backlight_is_not_turning_off_in_some_occasions}

By default, DPMS should turn off backlight with the timeouts set or by running xset. However, probably due to a bug in
the proprietary NVIDIA drivers the result is a blank screen with no powersaving whatsoever. To workaround it, until the
bug has been fixed you can use the `{{ic|vbetool}}`{=mediawiki} as root.

Install the `{{Pkg|vbetool}}`{=mediawiki} package.

Turn off your screen on demand and then by pressing a random key backlight turns on again:

`vbetool dpms off && read -n1; vbetool dpms on`

Alternatively, xrandr is able to disable and re-enable monitor outputs without requiring root.

`xrandr --output DP-1 --off; read -n1; xrandr --output DP-1 --auto`

#### HardDPMS

```{=mediawiki}
{{Expansion|Add references for the "user reports".}}
```
Proprietary driver 415 includes a new feature called
[HardDPMS](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/xconfigoptions.html#HardDPMS). This is
reported by some users to solve the issues with suspending monitors connected over DisplayPort. It is enabled by default
since 440.26. If you are using an older driver, the `{{ic|HardDPMS}}`{=mediawiki} option can be set in the
`{{ic|Device}}`{=mediawiki} or `{{ic|Screen}}`{=mediawiki} sections. For example:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-nvidia.conf|
Section "Device"
    ...
    Option         "HardDPMS" "true"
    ...
EndSection

Section "Screen"
    ...
    Option         "HardDPMS" "true"
    ...
EndSection
}}
```
```{=mediawiki}
{{ic|HardDPMS}}
```
will trigger on screensaver settings like `{{ic|BlankTime}}`{=mediawiki}. The following `{{ic|ServerFlags}}`{=mediawiki}
will set your monitor(s) to suspend after 10 minutes of inactivity:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-nvidia.conf|
Section "ServerFlags"
    Option     "BlankTime" "10"
EndSection
}}
```
### xrandr BadMatch {#xrandr_badmatch}

If you are trying to configure a WQHD monitor such as DELL U2515H using [xrandr](xrandr "wikilink") and
`{{ic|xrandr --addmode}}`{=mediawiki} gives you the error `{{ic|X Error of failed request: BadMatch}}`{=mediawiki}, it
might be because the proprietary NVIDIA driver clips the pixel clock maximum frequency of HDMI output to 225 MHz or
lower. To set the monitor to maximum resolution you have to install [nouveau](nouveau "wikilink") drivers. You can force
nouveau to use a specific pixel clock frequency by setting `{{ic|1=nouveau.hdmimhz=297}}`{=mediawiki} (or
`{{ic|330}}`{=mediawiki}) in your [Kernel parameters](Kernel_parameters "wikilink").

Alternatively, it may be that your monitor\'s EDID is incorrect. See [#Override EDID](#Override_EDID "wikilink").

Another reason could be that by default current NVIDIA drivers will only allow modes explicitly reported by EDID, but
sometimes refresh rates and/or resolutions are desired which are not reported by the monitor (although the EDID
information is correct; it is just that current NVIDIA drivers are too restrictive).

If this happens, you may want to add an option to `{{ic|xorg.conf}}`{=mediawiki} to allow non-EDID modes:

```{=mediawiki}
{{bc|
Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
...
    Option         "ModeValidation" "AllowNonEdidModes"
...
EndSection
}}
```
This can be set per-output. See [README - Appendix B. X Config
Options](https://download.nvidia.com/XFree86/Linux-x86_64/575.64/README/xconfigoptions.html#ModeValidation) for more
information.

### Override EDID {#override_edid}

See [Kernel mode setting#Forcing modes and EDID](Kernel_mode_setting#Forcing_modes_and_EDID "wikilink"),
[Xrandr#Troubleshooting](Xrandr#Troubleshooting "wikilink") and [Qnix QX2710#Fixing X11 with
Nvidia](Qnix_QX2710#Fixing_X11_with_Nvidia "wikilink").

### Overclocking with nvidia-settings GUI not working {#overclocking_with_nvidia_settings_gui_not_working}

```{=mediawiki}
{{Style|Duplication, vague "not working"}}
```
Workaround is to use nvidia-settings CLI to query and set certain variables after enabling overclocking (as explained in
[NVIDIA/Tips and tricks#Enabling overclocking in
nvidia-settings](NVIDIA/Tips_and_tricks#Enabling_overclocking_in_nvidia-settings "wikilink"), see
`{{man|1|nvidia-settings}}`{=mediawiki} for more information).

Example to query all variables:

` nvidia-settings -q all`

Example to set PowerMizerMode to prefer performance mode:

` nvidia-settings -a [gpu:0]/GPUPowerMizerMode=1`

Example to set fan speed to fixed 21%:

`nvidia-settings -a [gpu:0]/GPUFanControlState=1 -a [fan:0]/GPUTargetFanSpeed=21`

Example to set multiple variables at once (overclock GPU by 50MHz, overclock video memory by 50MHz, increase GPU voltage
by 100mV):

` nvidia-settings -a GPUGraphicsClockOffsetAllPerformanceLevels=50 -a GPUMemoryTransferRateOffsetGPUGraphicsClockOffsetAllPerformanceLevels=50 -a GPUOverVoltageOffset=100`

### Overclocking not working with Unknown Error {#overclocking_not_working_with_unknown_error}

If you are running Xorg as a non-root user and trying to overclock your NVIDIA GPU, you will get an error similar to
this one:

```{=mediawiki}
{{hc|1=$ nvidia-settings -a "[gpu:0]/GPUGraphicsClockOffset[3]=10"|2=
ERROR: Error assigning value 10 to attribute 'GPUGraphicsClockOffset' (trinity-zero:1[gpu:0]) as specified in assignment
        '[gpu:0]/GPUGraphicsClockOffset[3]=10' (Unknown Error).
}}
```
To avoid this issue, Xorg has to be run as the root user. See [Xorg#Rootless Xorg](Xorg#Rootless_Xorg "wikilink") for
details.

### Power draw {#power_draw}

```{=mediawiki}
{{Expansion|What is the point of this section?}}
```
Check driver usage:

```{=mediawiki}
{{hc|# lsof /dev/nvidia*|
kwin_wayl  867      user   17u   CHR   195,0      0t0  418 /dev/nvidia
kwin_wayl  867      user   18u   CHR   195,0      0t0  418 /dev/nvidiactl
}}
```
If power save is configured on the kernel module:

```{=mediawiki}
{{hc|$ grep . /sys/bus/pci/devices/0000:01:00.0/power/*|
/sys/bus/pci/devices/0000:01:00.0/power/control:auto
/sys/bus/pci/devices/0000:01:00.0/power/runtime_active_time:445933
/sys/bus/pci/devices/0000:01:00.0/power/runtime_status:active
/sys/bus/pci/devices/0000:01:00.0/power/runtime_suspended_time:1266
/sys/bus/pci/devices/0000:01:00.0/power/wakeup:disabled
}}
```
`# rmmod nvidia_drm`

```{=mediawiki}
{{hc|$ grep . /sys/bus/pci/devices/0000:01:00.0/power/*|
/sys/bus/pci/devices/0000:01:00.0/power/control:auto
/sys/bus/pci/devices/0000:01:00.0/power/runtime_active_time:461023
/sys/bus/pci/devices/0000:01:00.0/power/runtime_status:suspended
/sys/bus/pci/devices/0000:01:00.0/power/runtime_suspended_time:1064192
/sys/bus/pci/devices/0000:01:00.0/power/wakeup:disabled
}}
```
### Test software GL {#test_software_gl}

The binary NVIDIA driver will not adhere to the Mesa environment variable
`{{ic|LIBGL_ALWAYS_SOFTWARE{{=}}`{=mediawiki}1}} but you can direct libglvnd and EGL to use Mesa by setting the
following [environment variables](environment_variables "wikilink"):

`__GLX_VENDOR_LIBRARY_NAME=mesa`\
`__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json`

which will result in the Mesa libgl being used for GLX and EGL and result in software GL to see whether a bug is related
to the NVIDIA GL library.

### Refresh-rate limited to 120Hz {#refresh_rate_limited_to_120hz}

Newer versions of the driver (after 550xx) [seem to](https://bbs.archlinux.org/viewtopic.php?id=302969) waste bandwidth
on 8bpc outputs, likely pushing the signal above specification limits and the result is a failure to apply modes with
higher refresh rates that otherwise would be within the specification of the output. Add
`{{ic|nvidia-modeset.hdmi_deepcolor{{=}}`{=mediawiki}0}} to the [kernel parameters](kernel_parameters "wikilink") or set
the option via [modprobe](modprobe "wikilink") Notice that deep color will however be required for HDR monitors.

### Wrong color space on 60hz on Wayland with HDMI {#wrong_color_space_on_60hz_on_wayland_with_hdmi}

In some cases (like using a HDMI cable with a 1660 Super Graphics Card with 60hz), the driver seems to wrongly assume
the color space for the output. This leads to the colors looking darker than normal. Because of there being no easy way
to explicitly set the color space on Wayland, as a workaround you can add
`{{ic|nvidia-modeset.debug_force_color_space{{=}}`{=mediawiki}2}} to the [kernel
parameters](kernel_parameters "wikilink") or set the option via [modprobe](modprobe "wikilink").

[Category:Graphics](Category:Graphics "wikilink") [Category:X server](Category:X_server "wikilink")

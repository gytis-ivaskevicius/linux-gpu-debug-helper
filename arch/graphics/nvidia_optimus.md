[es:NVIDIA Optimus](es:NVIDIA_Optimus "wikilink") [fr:NVIDIA Optimus](fr:NVIDIA_Optimus "wikilink") [ja:NVIDIA
Optimus](ja:NVIDIA_Optimus "wikilink") [ru:NVIDIA Optimus](ru:NVIDIA_Optimus "wikilink") [zh-hans:NVIDIA
Optimus](zh-hans:NVIDIA_Optimus "wikilink") `{{Related articles start}}`{=mediawiki} `{{Related|PRIME}}`{=mediawiki}
`{{Related|Bumblebee}}`{=mediawiki} `{{Related|Nouveau}}`{=mediawiki} `{{Related|NVIDIA}}`{=mediawiki}
`{{Related|nvidia-xrun}}`{=mediawiki} `{{Related|External GPU}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

```{=mediawiki}
{{Expansion|
* Make clear what's specific to X and what is usable on Wayland.
* Remove the leftover mentions of "Intel" instead of "integrated": Optimus also works with AMD iGPUs.
}}
```
[NVIDIA Optimus](Wikipedia:NVIDIA_Optimus "wikilink") is a technology that allows an integrated GPU and discrete NVIDIA
GPU to be built into and accessed by a laptop. As a prerequisite, install the relevant [GPU
driver](Xorg#Driver_installation "wikilink") for both cards.

## Available methods {#available_methods}

There are several methods available:

-   [#Use integrated graphics only](#Use_integrated_graphics_only "wikilink") - saves power, because NVIDIA GPU will be
    completely powered off.
-   [#Use NVIDIA graphics only](#Use_NVIDIA_graphics_only "wikilink") - gives more performance than integrated graphics,
    but drains more battery (which is not welcome for mobile devices). This utilizes the same underlying process as the
    [optimus-manager](#Using_optimus-manager "wikilink") and [nvidia-xrun](#Using_nvidia-xrun "wikilink") options, it
    should be utilized for troubleshooting and verifying general functionality, before opting for one of the more
    automated approaches.
-   Using both (use NVIDIA GPU when needed and keep it powered off to save power):
    -   [#Using PRIME render offload](#Using_PRIME_render_offload "wikilink") - official method supported by NVIDIA.
    -   [#Using switcheroo-control](#Using_switcheroo-control "wikilink") - Similar to PRIME render offload, but has
        desktop environment integration, and also works with AMD and Intel GPUs. Allows applications to specify if they
        prefer the dedicated GPU in their [desktop entry](desktop_entry "wikilink") file, and lets you manually run any
        application on the dedicated GPU from the right-click menu.
    -   [#Using optimus-manager](#Using_optimus-manager "wikilink") - switches graphics with a single command (logout
        and login required to take effect). Also supports hybrid mode with PRIME render offload. It achieves maximum
        performance out of NVIDIA GPU and switches it off if not in use. Since the 1.4 release AMD+NVIDIA combination is
        also supported.
    -   [#Using nvidia-xrun](#Using_nvidia-xrun "wikilink") - run separate X session on different TTY with NVIDIA
        graphics. It achieves maximum performance out of NVIDIA GPU and switches it off if not in use.
    -   [#Using Bumblebee](#Using_Bumblebee "wikilink") - provides Windows-like functionality by allowing to run
        selected applications with NVIDIA graphics while using Intel graphics for everything else. Has significant
        performance issues.
    -   [#Using nouveau](#Using_nouveau "wikilink") - offers poorer performance (compared to the proprietary NVIDIA
        driver) and may cause issues with sleep and hibernate. Does not work with latest NVIDIA GPUs.
    -   [#Using EnvyControl](#Using_EnvyControl "wikilink") - Similar to optimus-manager but does not require extensive
        configuration or having a daemon running in the background as well as having to install a patched version of GDM
        if you are a GNOME user.
    -   [#Using NVidia-eXec](#Using_NVidia-eXec "wikilink") - Similar to Bumblebee, but without the performance impact.
        It works on both Xorg and Wayland. This package is experimental, and is currently being tested only under
        GNOME/GDM.
    -   [#Using nvidia-switch](#Using_nvidia-switch "wikilink") - Similar to nvidia-xrun, but not needing to change TTY,
        the switches will be done by login and logouts in your display manager. This package is being tested on Debian
        based system, but, like nvidia-xrun, it must work in all Linux systems.

```{=mediawiki}
{{Note|All of these options are mutually exclusive, if you test one approach and decide for another, you must ensure to revert any configuration changes done by following one approach before attempting another method, otherwise file conflicts and undefined behaviours may arise.}}
```
## Use integrated graphics only {#use_integrated_graphics_only}

If you only care to use a certain GPU without switching, check the options in your system\'s BIOS. There should be an
option to disable one of the cards. Some laptops only allow disabling of the discrete card, or vice-versa, but it is
worth checking if you only plan to use just one of the cards.

If your BIOS does not allow to disable Nvidia graphics, you can disable it from the Linux kernel itself. See [Hybrid
graphics#Fully power down discrete GPU](Hybrid_graphics#Fully_power_down_discrete_GPU "wikilink").

### Use CUDA without switching the rendering provider {#use_cuda_without_switching_the_rendering_provider}

You can use CUDA without switching rendering to the Nvidia graphics. All you need to do is ensure that the Nvidia card
is powered on before starting a CUDA application, see [Hybrid graphics#Fully power down discrete
GPU](Hybrid_graphics#Fully_power_down_discrete_GPU "wikilink") for details.

Now when you start a CUDA application, it will automatically load all necessary kernel modules. Before turning off the
Nvidia card after using CUDA, the `{{ic|nvidia}}`{=mediawiki} kernel modules have to be unloaded first:

`# rmmod nvidia_uvm`\
`# rmmod nvidia`

## Use NVIDIA graphics only {#use_nvidia_graphics_only}

The proprietary NVIDIA driver can be configured to be the primary rendering provider. It also has notable screen-tearing
issues unless you enable prime sync by enabling [NVIDIA#DRM kernel mode
setting](NVIDIA#DRM_kernel_mode_setting "wikilink"), see
[1](https://devtalk.nvidia.com/default/topic/957814/linux/prime-and-prime-synchronization/) for further information. It
does allow use of the discrete GPU and has (as of [January
2017](https://www.phoronix.com/scan.php?page=article&item=nouveau-410-blob&num=1)) a marked edge in performance over the
nouveau driver.

First, [install](install "wikilink") the [NVIDIA](NVIDIA "wikilink") driver and `{{Pkg|xorg-xrandr}}`{=mediawiki}. Then,
configure `{{ic|/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf}}`{=mediawiki} the options of which will be combined
with the package provided `{{ic|/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf}}`{=mediawiki} to provide
compatibility with this setup.

```{=mediawiki}
{{Note|On some setups this setup breaks automatic detection of the values of the display by the nvidia driver through the EDID file. As a work-around see [[#Resolution, screen scan wrong. EDID errors in Xorg.log]]. }}
```
```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf|
Section "OutputClass"
    Identifier "intel"
    MatchDriver "i915"
    Driver "modesetting"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "PrimaryGPU" "yes"
    ModulePath "/usr/lib/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndSection
}}
```
Next, add the following two lines to the beginning of your `{{ic|~/.xinitrc}}`{=mediawiki}:

```{=mediawiki}
{{hc|~/.xinitrc|
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
}}
```
Now reboot to load the drivers, and X should start.

If your display dpi is not correct add the following line:

`xrandr --dpi 96`

If you get a black screen when starting X, make sure that there are no ampersands after the two
`{{ic|xrandr}}`{=mediawiki} commands in `{{ic|~/.xinitrc}}`{=mediawiki}. If there are ampersands, it seems that the
window manager can run before the `{{ic|xrandr}}`{=mediawiki} commands finish executing, leading to a black screen.

### Display managers {#display_managers}

If you are using a [display manager](display_manager "wikilink") then you will need to create or edit a display setup
script for your display manager instead of using `{{ic|~/.xinitrc}}`{=mediawiki}.

#### LightDM

For the [LightDM](LightDM "wikilink") display manager:

```{=mediawiki}
{{hc|/etc/lightdm/display_setup.sh|
#!/bin/sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
}}
```
Make the script [executable](executable "wikilink").

Now configure lightdm to run the script by editing the `{{ic|[Seat:*]}}`{=mediawiki} section in
`{{ic|/etc/lightdm/lightdm.conf}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/lightdm/lightdm.conf|output=
[Seat:*]
display-setup-script=/etc/lightdm/display_setup.sh
}}
```
Now reboot and your display manager should start.

#### SDDM

For the [SDDM](SDDM "wikilink") display manager (SDDM is the default DM for [KDE](KDE "wikilink")):

```{=mediawiki}
{{hc|/usr/share/sddm/scripts/Xsetup|
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
}}
```
#### GDM

For the [GDM](GDM "wikilink") display manager create two new .desktop files:

```{=mediawiki}
{{hc|/usr/share/gdm/greeter/autostart/optimus.desktop
/etc/xdg/autostart/optimus.desktop|
<nowiki>[Desktop Entry]
Type=Application
Name=Optimus
Exec=sh -c "xrandr --setprovideroutputsource modesetting NVIDIA-0; xrandr --auto"
NoDisplay=true
X-GNOME-Autostart-Phase=DisplayServer</nowiki>
}}
```
Make sure that GDM use [X as default backend](GDM#Use_Xorg_backend "wikilink").

### Checking 3D {#checking_3d}

You can check if the NVIDIA graphics are being used by installing `{{Pkg|mesa-utils}}`{=mediawiki} and running

`$ glxinfo | grep NVIDIA`

### Further information {#further_information}

For more information, look at NVIDIA\'s official page on the topic
[2](http://us.download.nvidia.com/XFree86/Linux-x86/370.28/README/randr14.html).

## Use switchable graphics {#use_switchable_graphics}

### Using PRIME render offload {#using_prime_render_offload}

This is the official NVIDIA method to support switchable graphics.

See [PRIME#PRIME render offload](PRIME#PRIME_render_offload "wikilink") for details.

### Using switcheroo-control {#using_switcheroo_control}

See [PRIME#Desktop environment integration](PRIME#Desktop_environment_integration "wikilink").

### Using optimus-manager {#using_optimus_manager}

See [Optimus-manager](https://github.com/Askannz/optimus-manager) upstream documentation. It covers both installation
and configuration in Arch Linux systems.

### Using nvidia-xrun {#using_nvidia_xrun}

See [nvidia-xrun](nvidia-xrun "wikilink").

### Using Bumblebee {#using_bumblebee}

See [Bumblebee](Bumblebee "wikilink").

### Using nouveau {#using_nouveau}

See [PRIME](PRIME "wikilink") for graphics switching and [nouveau](nouveau "wikilink") for open-source NVIDIA driver.

### Using EnvyControl {#using_envycontrol}

See [EnvyControl](https://github.com/geminis3/envycontrol) upstream documentation. It covers both installation and usage
instructions.

### Using NVidia-eXec {#using_nvidia_exec}

See [NVidia-eXec](https://github.com/pedro00dk/nvidia-exec) upstream documentation. It covers both installation and
usage instructions.

### Using nvidia-switch {#using_nvidia_switch}

See [nvidia-switch](https://github.com/nvidiaswitch/nvidia-switch) upstream documentation. It covers both installation
and usage instructions.

## Troubleshooting

```{=mediawiki}
{{Style|This section is meaningless without specifying which solution is used in each subsection: integrated-only, NVIDIA-only, or switchable. In case of [[#Use switchable graphics]], the troubleshooting belongs to one of the linked pages.}}
```
### Tearing/Broken VSync {#tearingbroken_vsync}

Enable [DRM kernel mode setting](NVIDIA#DRM_kernel_mode_setting "wikilink"), which will in turn enable the PRIME
synchronization and fix the tearing.

You can read the official [forum
thread](https://devtalk.nvidia.com/default/topic/957814/linux/prime-and-prime-synchronization/) for details.

### Failed to initialize the NVIDIA GPU at PCI:1:0:0 (GPU fallen off the bus / RmInitAdapter failed!) {#failed_to_initialize_the_nvidia_gpu_at_pci100_gpu_fallen_off_the_bus_rminitadapter_failed}

Add `{{ic|1=rcutree.gp_init_delay=1}}`{=mediawiki} to the kernel parameters. Original topic can be found in
[3](https://github.com/Bumblebee-Project/Bumblebee/issues/455#issuecomment-22497464) and
[4](https://bbs.archlinux.org/viewtopic.php?id=169742).

### Resolution, screen scan wrong. EDID errors in Xorg.log {#resolution_screen_scan_wrong._edid_errors_in_xorg.log}

This is due to the NVIDIA driver not detecting the EDID for the display. You need to manually specify the path to an
EDID file or provide the same information in a similar way.

To provide the path to the EDID file edit the Device Section for the NVIDIA card in Xorg.conf, adding these lines and
changing parts to reflect your own system:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf|
Section "Device"
        Option      "ConnectedMonitor" "CRT-0"
        Option      "CustomEDID" "CRT-0:/sys/class/drm/card0-LVDS-1/edid"
    Option      "IgnoreEDID" "false"
    Option      "UseEDID" "true"
EndSection
}}
```
If Xorg will not start try swapping out all references of CRT to DFB. `{{ic|card0}}`{=mediawiki} is the identifier for
the Intel card to which the display is connected via LVDS. The edid binary is in this directory. If the hardware
arrangement is different, the value for CustomEDID might vary but yet this has to be confirmed. The path will start in
any case with `{{ic|/sys/class/drm}}`{=mediawiki}.

Alternatively you can generate your edid with tools like `{{Pkg|read-edid}}`{=mediawiki} and point the driver to this
file. Even modelines can be used, but then be sure to change `{{ic|UseEDID}}`{=mediawiki} and
`{{ic|IgnoreEDID}}`{=mediawiki}.

### Wrong resolution without EDID errors {#wrong_resolution_without_edid_errors}

Using *nvidia-xconfig*, incorrect information might be generated in `{{ic|xorg.conf}}`{=mediawiki} and in particular
wrong monitor refresh rates that restrict the possible resolutions. Try commenting out the
`{{ic|HorizSync}}`{=mediawiki}/`{{ic|VertRefresh}}`{=mediawiki} lines. If this helps, you can probably also remove
everything else not mentioned in this article.

### Lockup issue (lspci hangs) {#lockup_issue_lspci_hangs}

Symptoms: lspci hangs, system suspend fails, shutdown hangs, optirun hangs.

Applies to: newer laptops with GTX 965M or alike when bbswitch (e.g. via Bumblebee) or nouveau is in use.

When the dGPU power resource is turned on, it may fail to do so and hang in ACPI code ([kernel bug
156341](https://bugzilla.kernel.org/show_bug.cgi?id=156341)).

When using nouveau, disabling runtime power-management stops it from changing the power state, thus avoiding this issue.
To disable runtime power-management, add `{{ic|1=nouveau.runpm=0}}`{=mediawiki} to the kernel parameters.

For known model-specific workarounds, see [this
issue](https://github.com/Bumblebee-Project/Bumblebee/issues/764#issuecomment-234494238). In other cases you can try to
boot with `{{ic|1=acpi_osi="!Windows 2015"}}`{=mediawiki} or `{{ic|1=acpi_osi=! acpi_osi="Windows 2009"}}`{=mediawiki}
added to your [Kernel parameters](Kernel_parameters "wikilink"). (Consider reporting your laptop to that issue.)

### No screens found on a laptop/NVIDIA Optimus {#no_screens_found_on_a_laptopnvidia_optimus}

Check if the output is something similar to:

```{=mediawiki}
{{hc|$ lspci -nnd ::03xx|
00:02.0 VGA compatible controller [0300]: Intel Corporation Core Processor Integrated Graphics Controller [8086:0042] 
(rev 18)
01:00.0 VGA compatible controller [0300]: nVidia Corporation Device 0df4 [10de:0df4] (rev a1)
}}
```
NVIDIA drivers now offer Optimus support since 319.12 Beta
[5](https://www.nvidia.com/object/linux-display-amd64-319.12-driver.html) with kernels above and including 3.9.

Another solution is to install the [Intel](Intel "wikilink") driver to handle the screens, then if you want 3D software
you should run them through [Bumblebee](Bumblebee "wikilink") to tell them to use the NVIDIA card.

### Random freezes \"(EE) NVIDIA(GPU-0): WAIT\" {#random_freezes_ee_nvidiagpu_0_wait}

Using the proprietary drivers on a setup with an integrated AMD card and with the dedicated NVIDIA card set as the only
one in use, users report freezes for up to 10 seconds, with the following errors in the Xorg logs:

`[   219.796] (EE) NVIDIA(GPU-0): WAIT (2, 8, 0x8000, 0x0002e1c4, 0x0002e1cc)`\
`[   226.796] (EE) NVIDIA(GPU-0): WAIT (1, 8, 0x8000, 0x0002e1c4, 0x0002e1cc)`

While this is not root-caused yet, it seems linked to a conflict in how the integrated and dedicated cards interact with
Xorg.

The workaround is to use switchable graphics, see [PRIME#PRIME render offload](PRIME#PRIME_render_offload "wikilink")
for details.

### \"No Devices detected\" with optimus-manager {#no_devices_detected_with_optimus_manager}

There are cases where *lspci* will show the PCI domain as first output column, making *optimus-manager* generated files
break while trying to map `{{ic|BusID}}`{=mediawiki} on multiple laptop models.

If you face a black screen that never ends to load your GUI, GUI partially loading with console artifacts or Xorg
crashing with `{{ic|(EE) - No Devices detected}}`{=mediawiki}, the workaround and bug reports are available at the
[upstream GitHub](https://github.com/Askannz/optimus-manager/issues/471#issuecomment-1315628537).

### Xorg: external monitor updates only when the mouse is moving {#xorg_external_monitor_updates_only_when_the_mouse_is_moving}

A workaround for the issue is to uninstall the Xorg driver of the iGPU (e.g. `{{Pkg|xf86-video-amdgpu}}`{=mediawiki} or
`{{Pkg|xf86-video-intel}}`{=mediawiki}) [6](https://bbs.archlinux.org/viewtopic.php?id=284651). This should work as long
as the external monitor port (HDMI/DP/USB-C) is connected directly to the Nvidia dGPU.

```{=mediawiki}
{{Tip|The desktop behavior may become quirky (e.g. switching virtual desktops or Alt-Tab'ing freezes the image on the external monitor), which can be also worked around by disabling the laptop's monitor.}}
```
### Low power usage (TDP) {#low_power_usage_tdp}

Since the 530.41 driver version, cases of cards locked at low power consumption limits appeared (see [GitHub issue
483](https://github.com/NVIDIA/open-gpu-kernel-modules/issues/483)). The NVIDIA driver has disabled the ability to
manually set the power limit using `{{ic|nvidia-smi}}`{=mediawiki} command, so many laptops are stuck with low power
usage and bad performance.

To workaround this problem (for the Ampere generation or newer), see [NVIDIA/Tips and tricks#Dynamic
Boost](NVIDIA/Tips_and_tricks#Dynamic_Boost "wikilink").

### NVIDIA GPU will not turn off or stay deactivated {#nvidia_gpu_will_not_turn_off_or_stay_deactivated}

Some processes may keep your NVIDIA GPU on due to their way of interacting with the GPU. This causes significantly
increased power usage, lower battery life, and higher temperatures.

You can check if your GPU is in an active state or suspended by running the following command:

`$ cat /sys/bus/pci/devices/0000\:01\:00.0/power/runtime_status`

If the state is `{{ic|active}}`{=mediawiki}, you are probably running a process that keeps your GPU alive.

If you use a thermal monitor that is probing your GPU temperature, it typically calls `{{ic|nvidia-smi}}`{=mediawiki} to
get this temperature, which will wake up your GPU and keep it in an active state.

You can use `{{Pkg|nvtop}}`{=mediawiki} to check if a process (such as Xorg) is using the NVIDIA GPU, but this method
does not work in all cases. For example, if you have a [Ollama](Ollama "wikilink") server running, it will always keep
your GPU on but will not show in `{{ic|nvtop}}`{=mediawiki} or invoke `{{ic|nvidia-smi}}`{=mediawiki}.

Remember to check the articles related to your specific chosen method for troubleshooting as well.

[Category:Graphics](Category:Graphics "wikilink")

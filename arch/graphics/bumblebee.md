[ja:Bumblebee](ja:Bumblebee "ja:Bumblebee"){.wikilink} [ru:Bumblebee](ru:Bumblebee "ru:Bumblebee"){.wikilink}
[zh-hans:Bumblebee](zh-hans:Bumblebee "zh-hans:Bumblebee"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|PRIME}}`{=mediawiki} `{{Related|Nvidia-xrun}}`{=mediawiki} `{{Related|NVIDIA Optimus}}`{=mediawiki}
`{{Related|Nouveau}}`{=mediawiki} `{{Related|NVIDIA}}`{=mediawiki} `{{Related|Intel graphics}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

From Bumblebee\'s [FAQ](https://github.com/Bumblebee-Project/Bumblebee/wiki/FAQ):

:   Bumblebee is an effort to make NVIDIA Optimus enabled laptops work in GNU/Linux systems. Such feature involves two
    graphics cards with two different power consumption profiles plugged in a layered way sharing a single framebuffer.

```{=mediawiki}
{{Note|1=<nowiki/>
* Bumblebee has significant performance issues[https://github.com/Witko/nvidia-xrun/issues/4#issuecomment-153386837][https://bbs.archlinux.org/viewtopic.php?pid=1822926]. See [[NVIDIA Optimus]] for alternative solutions.
* NVIDIA has implemented [[PRIME]] in their Linux driver already, which makes Bumblebee and alternative solutions obsolete.
}}
```
## Bumblebee: Optimus for Linux {#bumblebee_optimus_for_linux}

[Optimus Technology](https://www.nvidia.com/object/optimus_technology.html) is a [hybrid
graphics](https://hybrid-graphics-linux.tuxfamily.org/index.php?title=Hybrid_graphics) implementation without a hardware
multiplexer. The integrated GPU manages the display while the dedicated GPU manages the most demanding rendering and
ships the work to the integrated GPU to be displayed. When the laptop is running on battery supply, the dedicated GPU is
turned off to save power and prolong the battery life. It has also been tested successfully with desktop machines with
Intel integrated graphics and an nVidia dedicated graphics card.

Bumblebee is a software implementation comprising two parts:

- Render programs off-screen on the dedicated video card and display it on the screen using the integrated video card.
  This bridge is provided by VirtualGL or primus (read further) and connects to a X server started for the discrete
  video card.
- Disable the dedicated video card when it is not in use (see the [#Power
  management](#Power_management "#Power management"){.wikilink} section)

It tries to mimic the Optimus technology behavior; using the dedicated GPU for rendering when needed and power it down
when not in use. The present releases only support rendering on-demand, automatically starting a program with the
discrete video card based on workload is not implemented.

## Installation

Before installing Bumblebee, check your BIOS and activate Optimus (older laptops call it \"switchable graphics\") if
possible (BIOS does not have to provide this option). If neither \"Optimus\" or \"switchable\" is in the BIOS, still
make sure both GPUs will be enabled and that the integrated graphics (igfx) is initial display (primary display). The
display should be connected to the onboard integrated graphics, not the discrete graphics card. If integrated graphics
had previously been disabled and discrete graphics drivers installed, be sure to remove
`{{ic|/etc/X11/xorg.conf}}`{=mediawiki} or the conf file in `{{ic|/etc/X11/xorg.conf.d}}`{=mediawiki} related to the
discrete graphics card.

[Install](Install "Install"){.wikilink}:

- ```{=mediawiki}
  {{Pkg|bumblebee}}
  ```
  \- The main package providing the daemon and client programs.

- ```{=mediawiki}
  {{Pkg|mesa}}
  ```
  \- An open-source implementation of the **OpenGL** specification.

- An appropriate version of the NVIDIA driver, see
  [NVIDIA#Installation](NVIDIA#Installation "NVIDIA#Installation"){.wikilink}.

- Optionally install `{{Pkg|xf86-video-intel}}`{=mediawiki} - Intel [Xorg](Xorg "Xorg"){.wikilink} driver.

For 32-bit application support, enable the [multilib](multilib "multilib"){.wikilink} repository and install:

- ```{=mediawiki}
  {{Pkg|lib32-virtualgl}}
  ```
  \- A render/display bridge for 32 bit applications.

- ```{=mediawiki}
  {{Pkg|lib32-nvidia-utils}}
  ```
  or `{{AUR|lib32-nvidia-340xx-utils}}`{=mediawiki} (match the version of the regular NVIDIA driver).

In order to use Bumblebee, it is necessary to add your regular *user* to the `{{ic|bumblebee}}`{=mediawiki} group:

`# gpasswd -a `*`user`*` bumblebee`

Also [enable](enable "enable"){.wikilink} `{{ic|bumblebeed.service}}`{=mediawiki}. Reboot your system and follow
[#Usage](#Usage "#Usage"){.wikilink}.

```{=mediawiki}
{{Note|
* The {{Pkg|bumblebee}} package will install a kernel module blacklist file that prevents the {{ic|nvidia-drm}} module from loading on boot. Remember to uninstall this if you later switch away to other solutions.
* The package does not blacklist the {{ic|nvidiafb}} module. You probably do not have it installed, because the default kernels do not ship it. However, with other kernels you must explicitly blacklist it too, otherwise ''optirun'' and ''primusrun'' will not run. See {{Bug|69018}}.
}}
```
## Usage

### Test

Install `{{Pkg|mesa-utils}}`{=mediawiki} and use `{{ic|glxgears}}`{=mediawiki} to test if Bumblebee works with your
Optimus system:

`$ optirun glxgears -info`

If it fails, try the following command (from `{{Pkg|virtualgl}}`{=mediawiki}):

`$ optirun glxspheres64`

If the window with animation shows up, Optimus with Bumblebee is working.

```{=mediawiki}
{{Note|If {{ic|glxgears}} failed, but {{ic|glxspheres64}} worked, always replace {{ic|glxgears}} with {{ic|glxspheres64}} in all cases.}}
```
### General usage {#general_usage}

`$ optirun [options] `*`application`*` [application-parameters]`

For example, start Windows applications with Optimus:

`$ optirun wine application.exe`

For another example, open NVIDIA Settings panel with Optimus:

`$ optirun -b none nvidia-settings -c :8`

```{=mediawiki}
{{Note|A patched version of {{AUR|nvdock}} is available in the package {{AUR|nvdock-bumblebee}}.}}
```
For a list of all available options, see `{{man|1|optirun}}`{=mediawiki}.

## Configuration

You can configure the behaviour of Bumblebee to fit your needs. Fine tuning like speed optimization, power management
and other stuff can be configured in `{{ic|/etc/bumblebee/bumblebee.conf}}`{=mediawiki}

### Optimizing speed {#optimizing_speed}

One disadvantage of the offscreen rendering methods is performance. The following table gives a raw overview of a
[Lenovo ThinkPad T480](Lenovo_ThinkPad_T480 "Lenovo ThinkPad T480"){.wikilink} in an eGPU setup with NVIDIA GTX 1060 6GB
and `{{AUR|unigine-heaven}}`{=mediawiki} benchmark (1920x1080, max settings, 8x AA):

  Command                    Display                                                           FPS    Score   Min FPS   Max FPS
  -------------------------- ----------------------------------------------------------------- ------ ------- --------- ---------
  optirun unigine-heaven     internal                                                          20.7   521     6.9       26.6
  primusrun unigine-heaven   internal                                                          36.9   930     15.3      44.1
  unigine-heaven             internal in [Nvidia-xrun](Nvidia-xrun "Nvidia-xrun"){.wikilink}   51.3   1293    8.4       95.6
  unigine-heaven             external in [Nvidia-xrun](Nvidia-xrun "Nvidia-xrun"){.wikilink}   56.1   1414    8.4       111.9

#### Using VirtualGL as bridge {#using_virtualgl_as_bridge}

Bumblebee renders frames for your Optimus NVIDIA card in an invisible X Server with VirtualGL and transports them back
to your visible X Server. Frames will be compressed before they are transported - this saves bandwidth and can be used
for speed-up optimization of bumblebee:

To use another compression method for a single application:

`$ optirun -c `*`compress-method`*` application`

The method of compress will affect performance in the GPU/CPU usage. Compressed methods will mostly load the CPU.
However, uncompressed methods will mostly load the GPU.

Compressed methods:

:\* `{{ic|jpeg}}`{=mediawiki}

:\* `{{ic|rgb}}`{=mediawiki}

:\* `{{ic|yuv}}`{=mediawiki}

Uncompressed methods:

:\* `{{ic|proxy}}`{=mediawiki}

:\* `{{ic|xv}}`{=mediawiki}

Here is a performance table tested with [ASUS N550JV](ASUS_N550JV "ASUS N550JV"){.wikilink} laptop and benchmark app
`{{AUR|unigine-heaven}}`{=mediawiki}:

  Command                           FPS    Score   Min FPS   Max FPS
  --------------------------------- ------ ------- --------- ---------
  optirun unigine-heaven            25.0   630     16.4      36.1
  optirun -c jpeg unigine-heaven    24.2   610     9.5       36.8
  optirun -c rgb unigine-heaven     25.1   632     16.6      35.5
  optirun -c yuv unigine-heaven     24.9   626     16.5      35.8
  optirun -c proxy unigine-heaven   25.0   629     16.0      36.1
  optirun -c xv unigine-heaven      22.9   577     15.4      32.2

```{=mediawiki}
{{Note|Lag spikes occurred when {{ic|jpeg}} compression method was used.}}
```
To use a standard compression for all applications, set the `{{ic|VGLTransport}}`{=mediawiki} to
`{{ic|''compress-method''}}`{=mediawiki} in `{{ic|/etc/bumblebee/bumblebee.conf}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/bumblebee/bumblebee.conf|2=
[...]
[optirun]
VGLTransport=proxy
[...]
}}
```
You can also play with the way VirtualGL reads back the pixels from your graphics card. Setting
`{{ic|VGL_READBACK}}`{=mediawiki} [environment variable](environment_variable "environment variable"){.wikilink} to
`{{ic|pbo}}`{=mediawiki} should increase the performance. Compare the following:

PBO should be faster:

`VGL_READBACK=pbo optirun glxgears`

The default value is sync:

`VGL_READBACK=sync optirun glxgears`

```{=mediawiki}
{{Note|CPU frequency scaling will affect directly on render performance.}}
```
#### Primusrun

```{=mediawiki}
{{Note|Since compositing hurts performance, invoking primus when a compositing WM is active is not recommended. See [[#Primus issues under compositing window managers]].}}
```
*primusrun* (from `{{Pkg|primus}}`{=mediawiki}) is becoming the default choice, because it consumes less power and
sometimes provides better performance than `{{ic|optirun}}`{=mediawiki}/`{{ic|virtualgl}}`{=mediawiki}. It may be run
separately, but it does not accept options as `{{ic|optirun}}`{=mediawiki} does. Setting `{{ic|primus}}`{=mediawiki} as
the bridge for `{{ic|optirun}}`{=mediawiki} provides more flexibility.

For 32-bit applications support on 64-bit machines, install `{{Pkg|lib32-primus}}`{=mediawiki}
([multilib](multilib "multilib"){.wikilink} must be enabled).

You can either run it separately:

`$ primusrun glxgears`

Or as a bridge for *optirun*. The default configuration sets `{{ic|virtualgl}}`{=mediawiki} as the bridge. Override that
on the command line:

`$ optirun -b primus glxgears`

Alternatively, set `{{ic|1=Bridge=primus}}`{=mediawiki} in `{{ic|/etc/bumblebee/bumblebee.conf}}`{=mediawiki} and you
will not have to specify it on the command line.

```{=mediawiki}
{{Tip|Refer to [[#Primusrun mouse delay (disable VSYNC)]] if you want to disable {{ic|VSYNC}}. It can also remove mouse input delay lag and slightly increase the performance.}}
```
#### Pvkrun

```{=mediawiki}
{{ic|pvkrun}}
```
from the package `{{Pkg|primus_vk}}`{=mediawiki} is a drop-in replacement for `{{ic|primusrun}}`{=mediawiki} that
enables to run [Vulkan](Vulkan "Vulkan"){.wikilink}-based applications. A quick check can be done with
`{{ic|vulkaninfo}}`{=mediawiki} from `{{Pkg|vulkan-tools}}`{=mediawiki}.

`$ pvkrun vulkaninfo`

### Power management {#power_management}

```{=mediawiki}
{{Merge|Hybrid graphics#Using bbswitch|This section talks only about bbswitch which is not specific to Bumblebee.}}
```
The goal of the power management feature is to turn off the NVIDIA card when it is not used by Bumblebee any more. If
`{{Pkg|bbswitch}}`{=mediawiki} (for `{{Pkg|linux}}`{=mediawiki}) or `{{Pkg|bbswitch-dkms}}`{=mediawiki} (for
`{{Pkg|linux-lts}}`{=mediawiki} or custom kernels) is installed, it will be detected automatically when the Bumblebee
daemon starts. No additional configuration is necessary. However, `{{Pkg|bbswitch}}`{=mediawiki} is for [Optimus laptops
only and will not work on desktop
computers](https://bugs.launchpad.net/ubuntu/+source/bbswitch/+bug/1338404/comments/6). So, Bumblebee power management
is not available for desktop computers, and there is no reason to install `{{Pkg|bbswitch}}`{=mediawiki} on a desktop.
(Nevertheless, the other features of Bumblebee do work on some desktop computers.)

To manually turn the card on or off using bbswitch, write into
[/proc/acpi/bbswitch](https://github.com/Bumblebee-Project/bbswitch#turn-the-card-off-respectively-on):

`# echo OFF > /proc/acpi/bbswitch`\
`# echo ON > /proc/acpi/bbswitch`

#### Default power state of NVIDIA card using bbswitch {#default_power_state_of_nvidia_card_using_bbswitch}

The default behavior of bbswitch is to leave the card power state unchanged. `{{ic|bumblebeed}}`{=mediawiki} does
disable the card when started, so the following is only necessary if you use bbswitch without bumblebeed.

Set `{{ic|load_state}}`{=mediawiki} and `{{ic|unload_state}}`{=mediawiki} [kernel module
parameters](kernel_module_parameter "kernel module parameter"){.wikilink} according to your needs (see [bbswitch
documentation](https://github.com/Bumblebee-Project/bbswitch)).

```{=mediawiki}
{{hc|/etc/modprobe.d/bbswitch.conf|2=
options bbswitch load_state=0 unload_state=1
}}
```
To run bbswitch without bumblebeed on system startup, do not forget to add `{{ic|bbswitch}}`{=mediawiki} to
`{{ic|/etc/modules-load.d}}`{=mediawiki}, as explained in [Kernel
module#systemd](Kernel_module#systemd "Kernel module#systemd"){.wikilink}.

#### Enable NVIDIA card during shutdown {#enable_nvidia_card_during_shutdown}

On some laptops, the NVIDIA card may not correctly initialize during boot if the card was powered off when the system
was last shutdown. Therefore the Bumblebee daemon will power on the GPU when stopping the daemon (e.g. on shutdown) due
to the (default) setting `{{ic|1=TurnCardOffAtExit=false}}`{=mediawiki} in
`{{ic|/etc/bumblebee/bumblebee.conf}}`{=mediawiki}. Note that this setting does not influence power state while the
daemon is running, so if all `{{ic|optirun}}`{=mediawiki} or `{{ic|primusrun}}`{=mediawiki} programs have exited, the
GPU will still be powered off.

When you stop the daemon manually, you might want to keep the card powered off while still powering it on on shutdown.
To achieve the latter, add the following [systemd](systemd "systemd"){.wikilink} service (if using
`{{pkg|bbswitch}}`{=mediawiki}):

```{=mediawiki}
{{hc|/etc/systemd/system/nvidia-enable.service|2=
[Unit]
Description=Enable NVIDIA card
DefaultDependencies=no

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo ON > /proc/acpi/bbswitch'

[Install]
WantedBy=shutdown.target
}}
```
Then [enable](enable "enable"){.wikilink} the `{{ic|nvidia-enable.service}}`{=mediawiki} unit.

#### Enable NVIDIA card after waking from suspend {#enable_nvidia_card_after_waking_from_suspend}

The bumblebee daemon may fail to activate the graphics card after suspending. A possible fix involves setting
`{{Pkg|bbswitch}}`{=mediawiki} as the default method for power management:

```{=mediawiki}
{{hc|/etc/bumblebee/bumblebee.conf|2=
[driver-nvidia]
PMMethod=bbswitch

[driver-nouveau]
PMMethod=bbswitch
}}
```
```{=mediawiki}
{{Note|This fix seems to work only after rebooting the system. Restarting the bumblebee service is not enough.}}
```
If the above fix fails, try the following command:

`# echo 1 > /sys/bus/pci/rescan`

To rescan the PCI bus automatically after a suspend, create a script as described in [Power management/Suspend and
hibernate#Hooks in
/usr/lib/systemd/system-sleep](Power_management/Suspend_and_hibernate#Hooks_in_/usr/lib/systemd/system-sleep "Power management/Suspend and hibernate#Hooks in /usr/lib/systemd/system-sleep"){.wikilink}.

### Multiple monitors {#multiple_monitors}

#### Outputs wired to the Intel chip {#outputs_wired_to_the_intel_chip}

If the port (DisplayPort/HDMI/VGA) is wired to the Intel chip, you can set up multiple monitors with
[xorg.conf](xorg.conf "xorg.conf"){.wikilink}. Set them to use the Intel card, but Bumblebee can still use the NVIDIA
card. One example configuration is below for two identical screens with 1080p resolution and using the HDMI out.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf|2=
Section "Screen"
    Identifier     "Screen0"
    Device         "intelgpu0"
    Monitor        "Monitor0"
    DefaultDepth    24
    Option         "TwinView" "0"
    SubSection "Display"
        Depth          24
        Modes          "1920x1080_60.00"
    EndSubSection
EndSection

Section "Screen"
    Identifier     "Screen1"
    Device         "intelgpu1"
    Monitor        "Monitor1"
    DefaultDepth   24
    Option         "TwinView" "0"
    SubSection "Display"
        Depth          24
        Modes          "1920x1080_60.00"
    EndSubSection
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
    Identifier     "intelgpu0"
    Driver         "intel"
    Option         "UseEvents" "true"
    Option         "AccelMethod" "UXA"
    BusID          "PCI:0:2:0"
EndSection

Section "Device"
    Identifier     "intelgpu1"
    Driver         "intel"
    Option         "UseEvents" "true"
    Option         "AccelMethod" "UXA"
    BusID          "PCI:0:2:0"
EndSection

Section "Device"
    Identifier     "nvidiagpu1"
    Driver         "nvidia"
    BusID          "PCI:0:1:0"
EndSection
}}
```
You need to probably change the BusID for both the Intel and the NVIDIA card.

```{=mediawiki}
{{hc|$ lspci -nnd ::03xx|
00:02.0 VGA compatible controller [0300]: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller [8086:0126] (rev 09)
}}
```
The BusID is 0:2:0. Note that *lspci* outputs hexadecimal values, but Xorg expects decimal values.

#### Output wired to the NVIDIA chip {#output_wired_to_the_nvidia_chip}

On some notebooks, the digital Video Output (HDMI or DisplayPort) is hardwired to the NVIDIA chip. If you want to use
all the displays on such a system simultaneously, the easiest solution is to use *intel-virtual-output*, a tool provided
in the `{{Pkg|xf86-video-intel}}`{=mediawiki} driver set, as of v2.99. It will allow you to extend the existing X
session onto other screens, leveraging virtual outputs to work with the discrete graphics card. Usage is as follows:

```{=mediawiki}
{{hc|$ intel-virtual-output [OPTION]... [TARGET_DISPLAY]...|
-d <source display>  source display
-f                   keep in foreground (do not detach from console and daemonize)
-b                   start bumblebee
-a                   connect to all local displays (e.g. :1, :2, etc)
-S                   disable use of a singleton and launch a fresh intel-virtual-output process
-v                   all verbose output, implies -f
-V <category>        specific verbose output, implies -f
-h                   this help
}}
```
If this command alone does not work, you can try running it with optirun to enable the discrete graphics and allow it to
detect the outputs accordingly. This is known to be necessary on Lenovo\'s Legion Y720.

`$ optirun intel-virtual-output`

If no target displays are parsed on the commandline, *intel-virtual-output* will attempt to connect to any local
display. The detected displays will be manageable via any desktop display manager such as xrandr or KDE Display. The
tool will also start bumblebee (which may be left as default install). See the [Bumblebee wiki
page](https://github.com/Bumblebee-Project/Bumblebee/wiki/Multi-monitor-setup) for more information.

When run in a terminal, *intel-virtual-output* will daemonize itself unless the `{{ic|-f}}`{=mediawiki} switch is used.
Games can be run on the external screen by first exporting the display `{{ic|1=export DISPLAY=:8}}`{=mediawiki}, and
then running the game with `{{ic|optirun ''game_bin''}}`{=mediawiki}, however, cursor and keyboard are not fully
captured. Use `{{ic|1=export DISPLAY=:0}}`{=mediawiki} to revert back to standard operation.

If *intel-virtual-output* does not detect displays, or if a `{{ic|no VIRTUAL outputs on ":0"}}`{=mediawiki} message is
obtained, then [create](create "create"){.wikilink}:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-intel.conf|
Section "Device"
    Identifier     "intelgpu0"
    Driver         "intel"
EndSection
}}
```
which does exist by default, and:

```{=mediawiki}
{{hc|/etc/bumblebee/xorg.conf.nvidia|
Section "ServerLayout"
    Identifier     "Layout0"
    Option         "AutoAddDevices" "'''true'''"
    Option         "AutoAddGPU" "false"
EndSection

Section "Device"
    Identifier     "DiscreteNvidia"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    Option         "ProbeAllGpus" "false"
    Option         "NoLogo" "true"
    Option         "UseEDID" "'''true'''"
'''    Option         "AllowEmptyInitialConfiguration"'''
'''#'''    Option         "UseDisplayDevice" "none"
EndSection

'''Section "Screen"'''
'''    Identifier     "Screen0"'''
'''    Device         "DiscreteNvidia"'''
'''EndSection'''
}}
```
See
[1](https://unix.stackexchange.com/questions/321151/do-not-manage-to-activate-hdmi-on-a-laptop-that-has-optimus-bumblebee)
for further configurations to try. If the laptop screen is stretched and the cursor is misplaced while the external
monitor shows only the cursor, try killing any running compositing managers.

If you do not want to use *intel-virtual-output*, another option is to configure Bumblebee to leave the discrete GPU on
and directly configure X to use both the screens, as it will be able to detect them.

As a last resort, you can run 2 X Servers. The first will be using the Intel driver for the notebook\'s screen. The
second will be started through optirun on the NVIDIA card, to show on the external display. Make sure to disable any
display/session manager before manually starting your desktop environment with optirun. Then, you can log in the
integrated-graphics powered one.

##### Disabling screen blanking {#disabling_screen_blanking}

You can disable screen blanking when using *intel-virtual-output* with `{{ic|xset}}`{=mediawiki} by setting the
`{{ic|DISPLAY}}`{=mediawiki} environment variable appropriately (see [DPMS](DPMS "DPMS"){.wikilink} for more info):

`$ DISPLAY=:8 xset -dpms s off`

### Multiple NVIDIA graphics cards or NVIDIA Optimus {#multiple_nvidia_graphics_cards_or_nvidia_optimus}

If you have multiple NVIDIA graphics cards (eg. when using an eGPU with a laptop with another built in NVIDIA graphics
card) or NVIDIA Optimus, you need to make a minor edit to `{{ic|/etc/bumblebee/xorg.conf.nvidia}}`{=mediawiki}. If this
change is not made the daemon may default to using the internal NVIDIA card.

First, determine the BusID of the external card:

```{=mediawiki}
{{hc|$ lspci -ndd ::03xx|
00:02.0 VGA compatible controller [0300]: Intel Corporation HD Graphics 530 [8086:191b] (rev 06) (prog-if 00 [VGA controller])
01:00.0 3D controller [0302]: NVIDIA Corporation GM107M [GeForce GTX 960M] [10de:139b] (rev ff) (prog-if ff)
0b:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP104 [GeForce GTX 1070] [10de:1b81] (rev a1)
}}
```
In this case, the BusID is `{{ic|0b:00.0}}`{=mediawiki}.

Now edit `{{ic|/etc/bumblebee/xorg.conf.nvidia}}`{=mediawiki} and add the following line to
`{{ic|Section "Device"}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/bumblebee/xorg.conf.nvidia|
Section "Device"
    ...
    BusID          "PCI:11:00:0"
    Option         "AllowExternalGpus" "true"  # If the GPU is external
    ...
EndSection
}}
```
```{=mediawiki}
{{Note|Notice that the hex {{ic|0b}} became a base10 {{ic|11}}.}}
```
## Troubleshooting

```{=mediawiki}
{{Note|Please report bugs at [https://github.com/Bumblebee-Project/Bumblebee Bumblebee-Project]'s GitHub tracker as described in its [https://github.com/Bumblebee-Project/Bumblebee/wiki/Reporting-Issues wiki].}}
```
### \[VGL\] ERROR: Could not open display :8 {#vgl_error_could_not_open_display_8}

There is a known problem with some wine applications that fork and kill the parent process without keeping track of it
(for example the free to play online game \"Runes of Magic\").

This is a known problem with VirtualGL. As of bumblebee 3.1, so long as you have it installed, you can use Primus as
your render bridge:

`$ optirun -b primus wine `*`windows program`*`.exe`

If this does not work, an alternative walkaround for this problem is:

`$ optirun bash`\
`$ optirun wine `*`windows program`*`.exe`

If using NVIDIA drivers a fix for this problem is to edit `{{ic|/etc/bumblebee/xorg.conf.nvidia}}`{=mediawiki} and
change Option `{{ic|ConnectedMonitor}}`{=mediawiki} to `{{ic|CRT-0}}`{=mediawiki}.

### Xlib: extension \"GLX\" missing on display \":0.0\" {#xlib_extension_glx_missing_on_display_0.0}

If you tried to install the NVIDIA driver from NVIDIA website, this is not going to work.

1.  Uninstall that driver in the similar way: `{{bc|# ./NVIDIA-Linux-*.run --uninstall}}`{=mediawiki}
2.  Remove the Xorg configuration file generated by NVIDIA: `{{bc|# rm /etc/X11/xorg.conf}}`{=mediawiki}
3.  (Re)install the correct NVIDIA driver: See [#Installation](#Installation "#Installation"){.wikilink}.

### \[ERROR\]Cannot access secondary GPU: No devices detected {#errorcannot_access_secondary_gpu_no_devices_detected}

In some instances, running `{{ic|optirun}}`{=mediawiki} will return:

`[ERROR]Cannot access secondary GPU - error: [XORG] (EE) No devices detected.`\
`[ERROR]Aborting because fallback start is disabled.`

In this case, you will need to move the file `{{ic|/etc/X11/xorg.conf.d/20-intel.conf}}`{=mediawiki} to somewhere else,
[restart](restart "restart"){.wikilink} the bumblebeed daemon and it should work. If you do need to change some features
for the Intel module, a workaround is to merge `{{ic|/etc/X11/xorg.conf.d/20-intel.conf}}`{=mediawiki} to
`{{ic|/etc/X11/xorg.conf}}`{=mediawiki}.

It could be also necessary to comment the driver line in `{{ic|/etc/X11/xorg.conf.d/10-monitor.conf}}`{=mediawiki}.

If you are using the `{{ic|nouveau}}`{=mediawiki} driver you could try switching to the `{{ic|nvidia}}`{=mediawiki}
driver.

You might need to define the NVIDIA card somewhere (e.g. file `{{ic|/etc/bumblebee/xorg.conf.nvidia}}`{=mediawiki}),
using the correct `{{ic|BusID}}`{=mediawiki} according to `{{ic|lspci}}`{=mediawiki} output:

```{=mediawiki}
{{bc|
Section "Device"
    Identifier     "nvidiagpu1"
    Driver         "nvidia"
    BusID          "PCI:0:1:0"
EndSection
}}
```
Observe that the format of `{{ic|lspci}}`{=mediawiki} output is in HEX, while in xorg it is in decimals. So if the
output of `{{ic|lspci}}`{=mediawiki} is, for example, `{{ic|0a:00.0}}`{=mediawiki} the `{{ic|BusID}}`{=mediawiki} should
be `{{ic|PCI:10:0:0}}`{=mediawiki}.

#### NVIDIA(0): Failed to assign any connected display devices to X screen 0 {#nvidia0_failed_to_assign_any_connected_display_devices_to_x_screen_0}

If the console output is:

`[ERROR]Cannot access secondary GPU - error: [XORG] (EE) NVIDIA(0): Failed to assign any connected display devices to X screen 0`\
`[ERROR]Aborting because fallback start is disabled.`

If the following line in `{{ic|/etc/bumblebee/xorg.conf.nvidia}}`{=mediawiki} does not exist, you can add it to the
\"Device\" section:

`Option "ConnectedMonitor" "DFP"`

If it does already exist, you can try changing it to:

`Option "ConnectedMonitor" "CRT"`

After that, restart the Bumblebee service to apply these changes.

#### Failed to initialize the NVIDIA GPU at PCI:1:0:0 (GPU fallen off the bus / RmInitAdapter failed!) {#failed_to_initialize_the_nvidia_gpu_at_pci100_gpu_fallen_off_the_bus_rminitadapter_failed}

Add `{{ic|1=rcutree.rcu_idle_gp_delay=1}}`{=mediawiki} to the [kernel
parameters](kernel_parameters "kernel parameters"){.wikilink} of the [boot loader](boot_loader "boot loader"){.wikilink}
configuration (see also the original [BBS post](https://bbs.archlinux.org/viewtopic.php?id=169742) for a configuration
example).

#### Failed to initialize the NVIDIA GPU at PCI:1:0:0 (Bumblebee daemon reported: error: \[XORG\] (EE) NVIDIA(GPU-0)) {#failed_to_initialize_the_nvidia_gpu_at_pci100_bumblebee_daemon_reported_error_xorg_ee_nvidiagpu_0}

You might encounter an issue when after resume from sleep, `{{ic|primusrun}}`{=mediawiki} or
`{{ic|optirun}}`{=mediawiki} command does not work anymore. there are two ways to fix this issue - reboot your system or
execute the following command:

`# echo 1 > /sys/bus/pci/rescan`

And try to test if `{{ic|primusrun}}`{=mediawiki} or `{{ic|optirun}}`{=mediawiki} works.

If the above command did not help, try finding your NVIDIA card\'s bus ID:

```{=mediawiki}
{{hc|$ lspci -nnd ::03xx|
00:02.0 VGA compatible controller [0300]: Intel Corporation Core Processor Integrated Graphics Controller [8086:0042] 
(rev 18)
'''01:00.0''' VGA compatible controller [0300]: nVidia Corporation Device 0df4 [10de:0df4] (rev a1)
}}
```
For example, above command showed `{{ic|01:00.0}}`{=mediawiki} so we use following commands with this bus ID:

`# echo 1 > /sys/bus/pci/devices/0000:`**`01:00.0`**`/remove`\
`# echo 1 > /sys/bus/pci/rescan`

#### Could not load GPU driver {#could_not_load_gpu_driver}

If the console output is:

`[ERROR]Cannot access secondary GPU - error: Could not load GPU driver`

and if you try to load the nvidia module:

```{=mediawiki}
{{hc|# modprobe nvidia|
modprobe: ERROR: could not insert 'nvidia': Exec format error
}}
```
This could be because the nvidia driver is out of sync with the Linux kernel, for example if you installed the latest
nvidia driver and have not updated the kernel in a while. A full system update , followed by a reboot into the updated
kernel, might resolve the issue. If the problem persists you should try manually compiling the nvidia packages against
your current kernel, for example with `{{Pkg|nvidia-dkms}}`{=mediawiki} or by compiling `{{pkg|nvidia}}`{=mediawiki}
from the [ABS](ABS "ABS"){.wikilink}.

#### NOUVEAU(0): \[drm\] failed to set drm interface version {#nouveau0_drm_failed_to_set_drm_interface_version}

Consider switching to the official nvidia driver. As commented
[here](https://github.com/Bumblebee-Project/Bumblebee/issues/438#issuecomment-22005923), nouveau driver has some issues
with some cards and bumblebee.

### \[ERROR\]Cannot access secondary GPU - error: X did not start properly {#errorcannot_access_secondary_gpu___error_x_did_not_start_properly}

Set the `{{ic|"AutoAddDevices"}}`{=mediawiki} option to `{{ic|"true"}}`{=mediawiki} in
`{{ic|/etc/bumblebee/xorg.conf.nvidia}}`{=mediawiki} (see
[here](https://github.com/Bumblebee-Project/Bumblebee/issues/88)):

```{=mediawiki}
{{bc|
Section "ServerLayout"
    Identifier     "Layout0"
    Option         "AutoAddDevices" "true"
    Option         "AutoAddGPU" "false"
EndSection
}}
```
### /dev/dri/card0: failed to set DRM interface version 1.4: Permission denied {#devdricard0_failed_to_set_drm_interface_version_1.4_permission_denied}

This could be worked around by appending following lines in `{{ic|/etc/bumblebee/xorg.conf.nvidia}}`{=mediawiki} (see
[here](https://github.com/Bumblebee-Project/Bumblebee/issues/580)):

```{=mediawiki}
{{bc|
Section "Screen"
    Identifier     "Default Screen"
    Device         "DiscreteNvidia"
EndSection
}}
```
### ERROR: ld.so: object \'libdlfaker.so\' from LD_PRELOAD cannot be preloaded: ignored {#error_ld.so_object_libdlfaker.so_from_ld_preload_cannot_be_preloaded_ignored}

You probably want to start a 32-bit application with bumblebee on a 64-bit system. See the \"For 32-bit\...\" section in
[#Installation](#Installation "#Installation"){.wikilink}. If the problem persists or if it is a 64-bit application, try
using the [primus bridge](#Primusrun "primus bridge"){.wikilink}.

### Fatal IO error 11 (Resource temporarily unavailable) on X server {#fatal_io_error_11_resource_temporarily_unavailable_on_x_server}

Change `{{ic|KeepUnusedXServer}}`{=mediawiki} in `{{ic|/etc/bumblebee/bumblebee.conf}}`{=mediawiki} from
`{{ic|false}}`{=mediawiki} to `{{ic|true}}`{=mediawiki}. Your program forks into background and bumblebee do not know
anything about it.

### Video tearing {#video_tearing}

Video tearing is a somewhat common problem on Bumblebee. To fix it, you need to enable vsync. It should be enabled by
default on the Intel card, but verify that from Xorg logs. To check whether or not it is enabled for NVIDIA, make sure
`{{Pkg|nvidia-settings}}`{=mediawiki} is installed and run:

`$ optirun nvidia-settings -c :8`

```{=mediawiki}
{{ic|1=X Server XVideo Settings -> Sync to VBlank}}
```
and `{{ic|1=OpenGL Settings -> Sync to VBlank}}`{=mediawiki} should both be enabled. The Intel card has in general less
tearing, so use it for video playback. Especially use VA-API for video decoding (e.g. `{{ic|mplayer-vaapi}}`{=mediawiki}
and with `{{ic|-vsync}}`{=mediawiki} parameter).

Refer to [Intel graphics#Tearing](Intel_graphics#Tearing "Intel graphics#Tearing"){.wikilink} on how to fix tearing on
the Intel card.

If it is still not fixed, try to disable compositing from your desktop environment. Try also disabling triple buffering.

### Bumblebee cannot connect to socket {#bumblebee_cannot_connect_to_socket}

You might get something like:

`$ optirun glxspheres64`

or (for 32 bit):

```{=mediawiki}
{{hc|$ optirun glxspheres32|
[ 1648.179533] [ERROR]You have no permission to communicate with the Bumblebee daemon. Try adding yourself to the 'bumblebee' group
[ 1648.179628] [ERROR]Could not connect to bumblebee daemon - is it running?
}}
```
If you are already in the `{{ic|bumblebee}}`{=mediawiki} group (`{{ic|groups {{!}}`{=mediawiki} grep bumblebee}}), you
may try [removing the socket](https://bbs.archlinux.org/viewtopic.php?pid=1178729#p1178729)
`{{ic|/var/run/bumblebeed.socket}}`{=mediawiki}.

Another reason for this error could be that you have not actually turned on both GPUs in your BIOS, and as a result, the
Bumblebee daemon is in fact not running. Check the BIOS settings carefully and be sure Intel graphics (integrated
graphics - may be abbreviated in BIOS as something like igfx) has been enabled or set to auto, and that it is the
primary GPU. Your display should be connected to the onboard integrated graphics, not the discrete graphics card.

If you mistakenly had the display connected to the discrete graphics card and Intel graphics was disabled, you probably
installed Bumblebee after first trying to run NVIDIA alone. In this case, be sure to remove the
`{{ic|/etc/X11/xorg.conf}}`{=mediawiki} or `{{ic|/etc/X11/xorg.conf.d/20-nvidia.conf}}`{=mediawiki} configuration files.
If Xorg is instructed to use NVIDIA in a configuration file, X will fail.

### Running X.org from console after login (rootless X.org) {#running_x.org_from_console_after_login_rootless_x.org}

See [Xorg#Rootless Xorg](Xorg#Rootless_Xorg "Xorg#Rootless Xorg"){.wikilink}.

### Using Primus causes a segmentation fault {#using_primus_causes_a_segmentation_fault}

In some instances, using primusrun instead of optirun will result in a segfault. This is caused by an issue in code
auto-detecting faster upload method, see `{{Bug|58933}}`{=mediawiki}.

The workaround is skipping auto-detection by manually setting `{{ic|PRIMUS_UPLOAD}}`{=mediawiki} [environment
variable](environment_variable "environment variable"){.wikilink} to either 1 or 2, depending on which one is faster on
your setup.

`$ PRIMUS_UPLOAD=1 primusrun ...`

### Primusrun mouse delay (disable VSYNC) {#primusrun_mouse_delay_disable_vsync}

For `{{ic|primusrun}}`{=mediawiki}, `{{ic|VSYNC}}`{=mediawiki} is enabled by default and as a result, it could make
mouse input delay lag or even slightly decrease performance. Test `{{ic|primusrun}}`{=mediawiki} with
`{{ic|VSYNC}}`{=mediawiki} disabled:

`$ vblank_mode=0 primusrun glxgears`

If you are satisfied with the above setting, create an [alias](alias "alias"){.wikilink} (e.g.
`{{ic|1=alias primusrun="vblank_mode=0 primusrun"}}`{=mediawiki}).

Performance comparison:

  VSYNC enabled   FPS    Score   Min FPS   Max FPS
  --------------- ------ ------- --------- ---------
  FALSE           31.5   793     22.3      54.8
  TRUE            31.4   792     18.7      54.2

*Tested with [ASUS N550JV](ASUS_N550JV "ASUS N550JV"){.wikilink} notebook and benchmark app
`{{AUR|unigine-heaven}}`{=mediawiki}.*

```{=mediawiki}
{{Note|To disable vertical synchronization system-wide, see [[Intel graphics#Disable Vertical Synchronization (VSYNC)]].}}
```
### Primus issues under compositing window managers {#primus_issues_under_compositing_window_managers}

Since compositing hurts performance, invoking primus when a compositing WM is active is not
recommended.[2](https://github.com/amonakov/primus#issues-under-compositing-wms) If you need to use primus with
compositing and see flickering or bad performance, synchronizing primus\' display thread with the application\'s
rendering thread may help:

`$ PRIMUS_SYNC=1 primusrun ...`

This makes primus display the previously rendered frame.

### Problems with bumblebee after resuming from standby {#problems_with_bumblebee_after_resuming_from_standby}

In some systems, it can happens that the nvidia module is loaded after resuming from standby. One possible solution for
this is to install the `{{pkg|acpi_call}}`{=mediawiki} and `{{pkg|acpi}}`{=mediawiki} package.

### Optirun does not work, no debug output {#optirun_does_not_work_no_debug_output}

Users are reporting that in some cases, even though Bumblebee was installed correctly, running

`$ optirun glxgears -info`

gives no output at all, and the glxgears window does not appear. Any programs that need 3d acceleration crashes:

`$ optirun bash`\
`$ glxgears`\
`Segmentation fault (core dumped)`

Apparently it is a bug of some versions of virtualgl. So a workaround is to use
[#Primusrun](#Primusrun "#Primusrun"){.wikilink} instead. See [this forum
post](https://bbs.archlinux.org/viewtopic.php?pid=1643609) for more information.

### Broken power management with kernel 4.8 {#broken_power_management_with_kernel_4.8}

```{=mediawiki}
{{Merge|Hybrid graphics#Using bbswitch|Keep all info about bbswitch in one place.}}
```
If you have a newer laptop (BIOS date 2015 or newer), then Linux 4.8 might break bbswitch ([bbswitch issue
140](https://github.com/Bumblebee-Project/bbswitch/issues/140)) since bbswitch does not support the newer, recommended
power management method. As a result, the GPU may fail to power on, fail to power off or worse.

As a workaround, add `{{ic|1=pcie_port_pm=off}}`{=mediawiki} to your [Kernel
parameters](Kernel_parameters "Kernel parameters"){.wikilink}.

Alternatively, if you are only interested in power saving (and perhaps use of external monitors), remove bbswitch and
rely on [Nouveau](Nouveau "Nouveau"){.wikilink} runtime power-management (which supports the new method).

```{=mediawiki}
{{Note|Some tools such as {{ic|powertop --auto-tune}} automatically enable power management on PCI devices, which leads to the same problem [https://github.com/Bumblebee-Project/bbswitch/issues/159]. Use the same workaround or do not use the all-in-one power management tools.}}
```
### Lockup issue (lspci hangs) {#lockup_issue_lspci_hangs}

See [NVIDIA Optimus#Lockup issue (lspci
hangs)](NVIDIA_Optimus#Lockup_issue_(lspci_hangs) "NVIDIA Optimus#Lockup issue (lspci hangs)"){.wikilink} for an issue
that affects new laptops with a GTX 965M (or alike).

### Discrete card always on and acpi warnings {#discrete_card_always_on_and_acpi_warnings}

Add `{{ic|1=acpi_osi=Linux}}`{=mediawiki} to your [Kernel parameters](Kernel_parameters "Kernel parameters"){.wikilink}.
See [3](https://github.com/Bumblebee-Project/Bumblebee/issues/592) and
[4](https://github.com/Bumblebee-Project/bbswitch/issues/112) for more information.

### Screen 0 deleted because of no matching config section {#screen_0_deleted_because_of_no_matching_config_section}

Modify the configuration as follows:

```{=mediawiki}
{{hc|/etc/bumblebee/xorg.conf.nvidia|
...
Section "ServerLayout"
...
    Screen 0       "nvidia"
...
EndSection
...
Section "Screen"
    Identifier     "nvidia"
    Device         "DiscreteNvidia"
EndSection
...
}}
```
### Erratic, unpredictable behaviour {#erratic_unpredictable_behaviour}

If Bumblebee starts/works in a random manner, check that you have set your [Network configuration#Local network hostname
resolution](Network_configuration#Local_network_hostname_resolution "Network configuration#Local network hostname resolution"){.wikilink}
(details [here](https://github.com/Bumblebee-Project/Bumblebee/pull/939)).

### Discrete card always on and nvidia driver cannot be unloaded {#discrete_card_always_on_and_nvidia_driver_cannot_be_unloaded}

Make sure `{{ic|nvidia-persistenced.service}}`{=mediawiki} is disabled and not currently active. It is intended to keep
the `{{ic|nvidia}}`{=mediawiki} driver running at all times
[5](https://us.download.nvidia.com/XFree86/Linux-x86_64/367.57/README/nvidia-persistenced.html), which prevents the card
being turned off.

### Discrete card is silently activated when EGL is requested by some application {#discrete_card_is_silently_activated_when_egl_is_requested_by_some_application}

If the discrete card is activated by some program (e.g. `{{Pkg|mpv}}`{=mediawiki} with its GPU backend), it might stays
on. The problem might be `{{ic|libglvnd}}`{=mediawiki} which is loading the `{{Pkg|nvidia}}`{=mediawiki} drivers and
activating the card.

To disable this set environment variable `{{ic|__EGL_VENDOR_LIBRARY_FILENAMES}}`{=mediawiki} (see
[documentation](https://github.com/NVIDIA/libglvnd/blob/master/src/EGL/icd_enumeration.md)) to only load mesa
configuration file:

`__EGL_VENDOR_LIBRARY_FILENAMES="/usr/share/glvnd/egl_vendor.d/50_mesa.json"`

```{=mediawiki}
{{Pkg|nvidia-utils}}
```
(and its branches) is installing the configuration file at
`{{ic|/usr/share/glvnd/egl_vendor.d/10_nvidia.json}}`{=mediawiki} which has priority and causes libglvnd to load the
`{{Pkg|nvidia}}`{=mediawiki} drivers and enable the card.

The other solution is to [avoid
installing](Pacman#Skip_files_from_being_installed_to_system "avoid installing"){.wikilink} the configuration file
provided by `{{Pkg|nvidia-utils}}`{=mediawiki}.

### Framerate drops to 1 FPS after a fixed period of time {#framerate_drops_to_1_fps_after_a_fixed_period_of_time}

With the nvidia 440.36 driver, the [DPMS setting is enabled by
default](https://devtalk.nvidia.com/default/topic/1067676/linux/440-36-with-bumblebee-drops-to-1-fps-after-running-for-10-minutes/post/5409047/#5409047)
resulting in a timeout after a fixed period of time (e.g. 10 minutes) which causes the frame rate to throttle down to 1
FPS. To work around this, add the following line to the \"Device\" section in
`{{ic|/etc/bumblebee/xorg.conf.nvidia}}`{=mediawiki}

```{=mediawiki}
{{bc|Option "HardDPMS" "false"}}
```
### Application cannot record screen {#application_cannot_record_screen}

Using Bumblebee, applications cannot access the screen to identify and record it. This happens, for example, using
`{{Pkg|obs-studio}}`{=mediawiki} with NVENC activated. To solve this, disable the bridging mode with
`{{ic|optirun -b none command}}`{=mediawiki}.

## See also {#see_also}

- [Bumblebee project repository](https://github.com/Bumblebee-Project/Bumblebee)
- [Bumblebee project wiki](https://github.com/Bumblebee-Project/Bumblebee/wiki)
- [Bumblebee project bbswitch repository](https://github.com/Bumblebee-Project/bbswitch)

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink} [Category:X
server](Category:X_server "Category:X server"){.wikilink}

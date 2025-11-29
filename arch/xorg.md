[de:X](de:X "de:X"){.wikilink} [fr:Xorg](fr:Xorg "fr:Xorg"){.wikilink} [hu:Xorg](hu:Xorg "hu:Xorg"){.wikilink}
[ja:Xorg](ja:Xorg "ja:Xorg"){.wikilink} [pt:Xorg](pt:Xorg "pt:Xorg"){.wikilink} [ru:Xorg](ru:Xorg "ru:Xorg"){.wikilink}
[uk:Xorg](uk:Xorg "uk:Xorg"){.wikilink} [zh-hans:Xorg](zh-hans:Xorg "zh-hans:Xorg"){.wikilink}
`{{Related articles start}}`{=mediawiki} `{{Related|Autostarting}}`{=mediawiki} `{{Related|Cursor themes}}`{=mediawiki}
`{{Related|Desktop environment}}`{=mediawiki} `{{Related|Display manager}}`{=mediawiki}
`{{Related|Font configuration}}`{=mediawiki} `{{Related|Window manager}}`{=mediawiki} `{{Related|XDMCP}}`{=mediawiki}
`{{Related|xinit}}`{=mediawiki} `{{Related|xrandr}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[X.Org Server](Wikipedia:X.Org_Server "X.Org Server"){.wikilink} --- commonly referred to as simply **X** --- is the
[X.Org Foundation](Wikipedia:X.Org_Foundation "X.Org Foundation"){.wikilink} implementation of the [X Window
System](Wikipedia:X_Window_System "X Window System"){.wikilink} (**X11**) display server, and it is the most popular
display server among Linux users. Its ubiquity has led to making it an ever-present requisite for GUI applications,
resulting in massive adoption from most distributions.

For the alternative and successor, see [Wayland](Wayland "Wayland"){.wikilink}.

## Installation

Xorg can be [installed](install "install"){.wikilink} with the `{{Pkg|xorg-server}}`{=mediawiki} package.

Additionally, some packages from the `{{Grp|xorg-apps}}`{=mediawiki} group are necessary for certain configuration
tasks. They are pointed out in the relevant sections.

Finally, an `{{Grp|xorg}}`{=mediawiki} group is also available, which includes Xorg server packages, packages from the
`{{Grp|xorg-apps}}`{=mediawiki} group and fonts.

### Driver installation {#driver_installation}

```{=mediawiki}
{{Move|Graphics processing unit|Except for DDX, nothing else is specific to Xorg.|ArchWiki talk:Requests#GPU article}}
```
The Linux kernel includes open-source video drivers and support for hardware accelerated framebuffers. However, userland
support is required for [OpenGL](OpenGL "OpenGL"){.wikilink}, [Vulkan](Vulkan "Vulkan"){.wikilink} and 2D acceleration
in X11.

First, identify the graphics card (the *Subsystem* output shows the specific model):

`$ lspci -v -nn -d ::03xx`

```{=mediawiki}
{{Tip|{{ic|::03}} here means "[https://admin.pci-ids.ucw.cz/read/PD/03 Display controller] PCI device class", and {{ic|xx}} stands for "any subclass of the class".}}
```
Then, install an appropriate driver. You can search the package database for a complete list of open-source [Device
Dependent X (DDX)](https://dri.freedesktop.org/wiki/DDX/) drivers:

`$ pacman -Ss xf86-video`

However, hardware-specific DDX is considered legacy nowadays. There is a generic `{{man|4|modesetting}}`{=mediawiki} DDX
driver in `{{pkg|xorg-server}}`{=mediawiki}, which uses [kernel mode
setting](kernel_mode_setting "kernel mode setting"){.wikilink} and works well on modern hardware. The modesetting DDX
driver uses
[Glamor](https://www.freedesktop.org/wiki/Software/Glamor/)[1](https://gitlab.freedesktop.org/xorg/xserver/-/tree/server-21.1-branch/glamor)
for 2D acceleration, which requires OpenGL.

If you want to install another DDX driver, note that Xorg searches for installed DDX drivers automatically:

- If it cannot find the specific driver installed for the hardware (listed below), it first searches for *fbdev*
  (`{{pkg|xf86-video-fbdev}}`{=mediawiki}), which does not include any 2D or 3D acceleration.
- If that is not found, it searches for *vesa* (`{{pkg|xf86-video-vesa}}`{=mediawiki}), the generic driver, which
  handles a large number of chipsets but does not include any 2D or 3D acceleration.
- If *vesa* is not found, Xorg will fall back to `{{man|4|modesetting}}`{=mediawiki} DDX driver.

In order for video acceleration to work, and often to expose all the modes that the GPU can set, a proper video driver
is required:

+------------+-------------+-------------------------------------------------------+--------------------------------------+----------------------------+----------------------------------------------+----------------------------+----------------------------------------------+----------------------------+
| Brand      | Type        | Documentation                                         | DRM driver                           | OpenGL                     | OpenGL                                       | Vulkan                     | Vulkan                                       | DDX driver                 |
|            |             |                                                       |                                      |                            | ([multilib](multilib "multilib"){.wikilink}) |                            | ([multilib](multilib "multilib"){.wikilink}) |                            |
+============+=============+=======================================================+======================================+============================+==============================================+============================+==============================================+============================+
| AMD        | Open source | [AMDGPU](AMDGPU "AMDGPU"){.wikilink}                  | included in                          | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            |
| (ex-ATI)   |             |                                                       | [Linux](Linux "Linux"){.wikilink}    | {{Pkg|mesa}}               | {{Pkg|lib32-mesa}}                           | {{Pkg|vulkan-radeon}}      | {{Pkg|lib32-vulkan-radeon}}                  | {{Pkg|xf86-video-amdgpu}}  |
|            |             |                                                       |                                      | ```                        | ```                                          | ```                        | ```                                          | ```                        |
|            |             |                                                       |                                      | ^3^                        | ^3^                                          |                            |                                              |                            |
|            |             +-------------------------------------------------------+                                      |                            |                                              +----------------------------+----------------------------------------------+----------------------------+
|            |             | [ATI](ATI "ATI"){.wikilink}                           |                                      |                            |                                              | None                                                                      | ```{=mediawiki}            |
|            |             |                                                       |                                      |                            |                                              |                                                                           | {{Pkg|xf86-video-ati}}     |
|            |             |                                                       |                                      |                            |                                              |                                                                           | ```                        |
+------------+-------------+-------------------------------------------------------+                                      +----------------------------+----------------------------------------------+----------------------------+----------------------------------------------+----------------------------+
| Intel      | Open source | [Intel                                                |                                      | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            |
|            |             | graphics](Intel_graphics "Intel graphics"){.wikilink} |                                      | {{Pkg|mesa}}               | {{Pkg|lib32-mesa}}                           | {{Pkg|vulkan-intel}}       | {{Pkg|lib32-vulkan-intel}}                   | {{Pkg|xf86-video-intel}}   |
|            |             |                                                       |                                      | ```                        | ```                                          | ```                        | ```                                          | ```                        |
|            |             |                                                       |                                      | ^3^                        | ^3^                                          |                            |                                              | ^2^                        |
+------------+-------------+-------------------------------------------------------+                                      +----------------------------+----------------------------------------------+----------------------------+----------------------------------------------+----------------------------+
| NVIDIA     | Open source | [Nouveau](Nouveau "Nouveau"){.wikilink}^1^            |                                      | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            |
|            |             |                                                       |                                      | {{Pkg|mesa}}               | {{Pkg|lib32-mesa}}                           | {{Pkg|vulkan-nouveau}}     | {{Pkg|lib32-vulkan-nouveau}}                 | {{Pkg|xf86-video-nouveau}} |
|            |             |                                                       |                                      | ```                        | ```                                          | ```                        | ```                                          | ```                        |
|            |             |                                                       |                                      | ^3^                        | ^3^                                          |                            |                                              |                            |
|            +-------------+-------------------------------------------------------+--------------------------------------+----------------------------+----------------------------------------------+----------------------------+----------------------------------------------+----------------------------+
|            | Proprietary | [NVIDIA](NVIDIA "NVIDIA"){.wikilink}^1^               | ```{=mediawiki}                      | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            |
|            |             |                                                       | {{Pkg|nvidia}}                       | {{Pkg|nvidia-utils}}       | {{Pkg|lib32-nvidia-utils}}                   | {{Pkg|nvidia-utils}}       | {{Pkg|lib32-nvidia-utils}}                   | {{Pkg|nvidia-utils}}       |
|            |             |                                                       | ```                                  | ```                        | ```                                          | ```                        | ```                                          | ```                        |
|            |             |                                                       | or                                   |                            |                                              |                            |                                              |                            |
|            |             |                                                       | `{{Pkg|nvidia-open}}`{=mediawiki}^4^ |                            |                                              |                            |                                              |                            |
|            |             |                                                       +--------------------------------------+----------------------------+----------------------------------------------+----------------------------+----------------------------------------------+----------------------------+
|            |             |                                                       | ```{=mediawiki}                      | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            |
|            |             |                                                       | {{AUR|nvidia-535xx-dkms}}            | {{AUR|nvidia-535xx-utils}} | {{AUR|lib32-nvidia-535xx-utils}}             | {{AUR|nvidia-535xx-utils}} | {{AUR|lib32-nvidia-535xx-utils}}             | {{AUR|nvidia-535xx-utils}} |
|            |             |                                                       | ```                                  | ```                        | ```                                          | ```                        | ```                                          | ```                        |
|            |             |                                                       +--------------------------------------+----------------------------+----------------------------------------------+----------------------------+----------------------------------------------+----------------------------+
|            |             |                                                       | ```{=mediawiki}                      | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            |
|            |             |                                                       | {{AUR|nvidia-470xx-dkms}}            | {{AUR|nvidia-470xx-utils}} | {{AUR|lib32-nvidia-470xx-utils}}             | {{AUR|nvidia-470xx-utils}} | {{AUR|lib32-nvidia-470xx-utils}}             | {{AUR|nvidia-470xx-utils}} |
|            |             |                                                       | ```                                  | ```                        | ```                                          | ```                        | ```                                          | ```                        |
|            |             |                                                       +--------------------------------------+----------------------------+----------------------------------------------+----------------------------+----------------------------------------------+----------------------------+
|            |             |                                                       | ```{=mediawiki}                      | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            | ```{=mediawiki}                              | ```{=mediawiki}            |
|            |             |                                                       | {{AUR|nvidia-390xx-dkms}}            | {{AUR|nvidia-390xx-utils}} | {{AUR|lib32-nvidia-390xx-utils}}             | {{AUR|nvidia-390xx-utils}} | {{AUR|lib32-nvidia-390xx-utils}}             | {{AUR|nvidia-390xx-utils}} |
|            |             |                                                       | ```                                  | ```                        | ```                                          | ```                        | ```                                          | ```                        |
+------------+-------------+-------------------------------------------------------+--------------------------------------+----------------------------+----------------------------------------------+----------------------------+----------------------------------------------+----------------------------+

1.  For NVIDIA Optimus enabled laptop which uses an integrated video card combined with a dedicated GPU, see [NVIDIA
    Optimus](NVIDIA_Optimus "NVIDIA Optimus"){.wikilink}.
2.  For Intel graphics, the *modesetting* DDX driver is recommended. See [Intel
    graphics#Installation](Intel_graphics#Installation "Intel graphics#Installation"){.wikilink} for details.
3.  For older hardware, classic OpenGL (non-Gallium3D) drivers in
    `{{Pkg|mesa-amber}}`{=mediawiki}/`{{Pkg|lib32-mesa-amber}}`{=mediawiki} might be useful (Mesa 22.0 and higher have
    dropped support for non-Gallium3D classic drivers), see
    [OpenGL#Installation](OpenGL#Installation "OpenGL#Installation"){.wikilink}.
4.  For the difference between `{{Pkg|nvidia}}`{=mediawiki} and `{{Pkg|nvidia-open}}`{=mediawiki}, see
    [NVIDIA#Installation](NVIDIA#Installation "NVIDIA#Installation"){.wikilink}.

Other DDX drivers can be found in the `{{Grp|xorg-drivers}}`{=mediawiki} group.

Xorg should run smoothly without closed source drivers, which are typically needed only for advanced features such as
fast 3D-accelerated rendering for games. The exceptions to this rule are recent GPUs (especially NVIDIA GPUs) not
supported by open source drivers.

#### AMD

For a translation of model names (e.g. *Radeon RX 6800*) to GPU architectures (e.g. *RDNA 2*), see [Wikipedia:List of
AMD graphics processing units#Features
overview](Wikipedia:List_of_AMD_graphics_processing_units#Features_overview "Wikipedia:List of AMD graphics processing units#Features overview"){.wikilink}.

+------------------+-----------------------------------------------------------------------+--------------------+
| GPU architecture | Open-source driver                                                    | Proprietary driver |
+==================+=======================================================================+====================+
| RDNA and later   | [AMDGPU](AMDGPU "AMDGPU"){.wikilink}                                  | *not available*    |
+------------------+                                                                       |                    |
| GCN 3 and later  |                                                                       |                    |
+------------------+-----------------------------------------------------------------------+--------------------+
| GCN 1&2          | [AMDGPU](AMDGPU "AMDGPU"){.wikilink}^1^ / [ATI](ATI "ATI"){.wikilink} | *not available*    |
+------------------+-----------------------------------------------------------------------+--------------------+
| TeraScale\       | [ATI](ATI "ATI"){.wikilink}                                           | *not available*    |
| and older        |                                                                       |                    |
+------------------+-----------------------------------------------------------------------+--------------------+
|                  |                                                                       |                    |
+------------------+-----------------------------------------------------------------------+--------------------+

1.  Experimental.

## Running

The `{{man|1|Xorg}}`{=mediawiki} command is usually not run directly. Instead, the X server is started with either a
[display manager](display_manager "display manager"){.wikilink} or [xinit](xinit "xinit"){.wikilink}.

```{=mediawiki}
{{Tip|You will typically seek to install a [[window manager]] or a [[desktop environment]] to supplement X.}}
```
## Configuration

```{=mediawiki}
{{Note|Arch supplies default configuration files in {{ic|/usr/share/X11/xorg.conf.d/}}, and no extra configuration is necessary for most setups.}}
```
Xorg uses a configuration file called `{{ic|xorg.conf}}`{=mediawiki} and files ending in the suffix
`{{ic|.conf}}`{=mediawiki} for its initial setup: the complete list of the folders where these files are searched can be
found in `{{man|5|xorg.conf}}`{=mediawiki}, together with a detailed explanation of all the available options.

### Using .conf files {#using_.conf_files}

The `{{ic|/etc/X11/xorg.conf.d/}}`{=mediawiki} directory stores host-specific configuration. You are free to add
configuration files there, but they must have a `{{ic|.conf}}`{=mediawiki} suffix: the files are read in ASCII order,
and by convention their names start with `{{ic|''XX''-}}`{=mediawiki} (two digits and a hyphen, so that for example 10
is read before 20). These files are parsed by the X server upon startup and are treated like part of the traditional
`{{ic|xorg.conf}}`{=mediawiki} configuration file. Note that on conflicting configuration, the file read *last* will be
processed. For this reason, the most generic configuration files should be ordered first by name. The configuration
entries in the `{{ic|xorg.conf}}`{=mediawiki} file are processed at the end.

For option examples to set, see [Fedora:Input device
configuration#xorg.conf.d](Fedora:Input_device_configuration#xorg.conf.d "Fedora:Input device configuration#xorg.conf.d"){.wikilink}.

### Using xorg.conf {#using_xorg.conf}

Xorg can also be configured via `{{ic|/etc/X11/xorg.conf}}`{=mediawiki} or `{{ic|/etc/xorg.conf}}`{=mediawiki}. You can
also generate a skeleton for `{{ic|xorg.conf}}`{=mediawiki} with:

`# Xorg :0 -configure`

This should create a `{{ic|xorg.conf.new}}`{=mediawiki} file in `{{ic|/root/}}`{=mediawiki} that you can copy over to
`{{ic|/etc/X11/xorg.conf}}`{=mediawiki}.

```{=mediawiki}
{{Tip|If you are already running an X server, use a different display, for example {{ic|Xorg :2 -configure}}.}}
```
Alternatively, your proprietary video card drivers may come with a tool to automatically configure Xorg: see the article
of your video driver, [NVIDIA](NVIDIA "NVIDIA"){.wikilink}, for more details.

```{=mediawiki}
{{Note|Configuration file keywords are case insensitive, and "_" characters are ignored. Most strings (including Option names) are also case insensitive, and insensitive to white space and "_" characters.}}
```
## Input devices {#input_devices}

For input devices the X server defaults to the libinput driver (`{{Pkg|xf86-input-libinput}}`{=mediawiki}), but
`{{Pkg|xf86-input-evdev}}`{=mediawiki} and related drivers are available as
alternative.[2](https://archlinux.org/news/xorg-server-1191-is-now-in-extra/)

[Udev](Udev "Udev"){.wikilink}, which is provided as a systemd dependency, will detect hardware and both drivers will
act as hotplugging input driver for almost all devices, as defined in the default configuration files
`{{ic|10-quirks.conf}}`{=mediawiki} and `{{ic|40-libinput.conf}}`{=mediawiki} in the
`{{ic|/usr/share/X11/xorg.conf.d/}}`{=mediawiki} directory.

After starting X server, the log file will show which driver hotplugged for the individual devices (note the most recent
log file name may vary):

`$ grep -e "Using input driver " Xorg.0.log`

If both do not support a particular device, install the needed driver from the `{{Grp|xorg-drivers}}`{=mediawiki} group.
The same applies, if you want to use another driver.

To influence hotplugging, see [#Configuration](#Configuration "#Configuration"){.wikilink}.

For specific instructions, see also the [libinput](libinput "libinput"){.wikilink} article, the following pages below,
or [Fedora:Input device configuration](Fedora:Input_device_configuration "Fedora:Input device configuration"){.wikilink}
for more examples.

### Input identification {#input_identification}

See [Keyboard input#Identifying keycodes in
Xorg](Keyboard_input#Identifying_keycodes_in_Xorg "Keyboard input#Identifying keycodes in Xorg"){.wikilink}.

### Mouse acceleration {#mouse_acceleration}

See [Mouse acceleration](Mouse_acceleration "Mouse acceleration"){.wikilink}.

### Extra mouse buttons {#extra_mouse_buttons}

See [Mouse buttons](Mouse_buttons "Mouse buttons"){.wikilink}.

### Touchpad

See [libinput](libinput "libinput"){.wikilink} or [Synaptics](Synaptics "Synaptics"){.wikilink}.

### Touchscreen

See [Touchscreen](Touchscreen "Touchscreen"){.wikilink}.

### Keyboard settings {#keyboard_settings}

See [Keyboard configuration in Xorg](Keyboard_configuration_in_Xorg "Keyboard configuration in Xorg"){.wikilink}.

## Monitor settings {#monitor_settings}

### Manual configuration {#manual_configuration}

```{=mediawiki}
{{Note|
* Newer versions of Xorg are auto-configuring, so manual configuration should not be needed.
* If Xorg is unable to detect any monitor or to avoid auto-configuring, a configuration file can be used. A common case where this is necessary is a headless system, which boots without a monitor and starts Xorg automatically, either from a [[Automatic login to virtual console|virtual console]] at [[Start X at login|login]], or from a [[display manager]].
}}
```
For a headless configuration, the `{{pkg|xf86-video-dummy}}`{=mediawiki} driver is necessary;
[install](install "install"){.wikilink} it and create a configuration file, such as the following:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-headless.conf|
Section "Monitor"
        Identifier "dummy_monitor"
        HorizSync 28.0-80.0
        VertRefresh 48.0-75.0
        Modeline "1920x1080" 172.80 1920 2040 2248 2576 1080 1081 1084 1118
EndSection

Section "Device"
        Identifier "dummy_card"
        VideoRam 256000
        Driver "dummy"
EndSection

Section "Screen"
        Identifier "dummy_screen"
        Device "dummy_card"
        Monitor "dummy_monitor"
        SubSection "Display"
        EndSubSection
EndSection
}}
```
### Multiple monitors {#multiple_monitors}

See main article [Multihead](Multihead "Multihead"){.wikilink} for general information.

#### More than one graphics card {#more_than_one_graphics_card}

You must define the correct driver to use and put the bus ID of your graphic cards (in decimal notation).

```{=mediawiki}
{{bc|
Section "Device"
    Identifier             "Screen0"
    Driver                 "intel"
    BusID                  "PCI:0:2:0"
EndSection

Section "Device"
    Identifier             "Screen1"
    Driver                 "nouveau"
    BusID                  "PCI:1:0:0"
EndSection
}}
```
To get your bus IDs (in hexadecimal):

```{=mediawiki}
{{hc|$ lspci -d ::03xx|
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 630 (rev 04)
01:00.0 3D controller: NVIDIA Corporation GP107M [GeForce GTX 1050 Mobile] (rev a1)
}}
```
The bus IDs here are `{{ic|0:2:0}}`{=mediawiki} and `{{ic|1:0:0}}`{=mediawiki}.

### Display size and DPI {#display_size_and_dpi}

By default, Xorg always sets DPI to 96 since
[2009-01-30](https://gitlab.freedesktop.org/xorg/xserver/-/commit/fff00df94d7ebd18a8e24537ec96073717375a3f). A change
was made with version 21.1 to provide proper DPI auto-detection, but
[reverted](https://gitlab.freedesktop.org/xorg/xserver/-/commit/35af1299e73483eaf93d913a960e1d1738bc7de6).

The DPI of the X server can be set with the `{{ic|-dpi}}`{=mediawiki} command line option.

Having the correct DPI is helpful where fine detail is required (like font rendering). Previously, manufacturers tried
to create a standard for 96 DPI (a 10.3\" diagonal monitor would be 800x600, a 13.2\" monitor 1024x768). These days,
screen DPIs vary and may not be equal horizontally and vertically. For example, a 19\" widescreen LCD at 1440x900 may
have a DPI of 89x87.

To see if your display size and DPI are correct:

`$ xdpyinfo | grep -B2 resolution`

Check that the dimensions match your display size.

If you have specifications on the physical size of the screen, they can be entered in the Xorg configuration file so
that the proper DPI is calculated (adjust identifier to your xrandr output):

```{=mediawiki}
{{bc|
Section "Monitor"
    Identifier             "DVI-D-0"
    DisplaySize             286 179    # In millimeters
EndSection
}}
```
If you only want to enter the specification of your monitor **without** creating a full xorg.conf, create a new
configuration file. For example (`{{ic|/etc/X11/xorg.conf.d/90-monitor.conf}}`{=mediawiki}):

```{=mediawiki}
{{bc|
Section "Monitor"
    Identifier             "<default monitor>"
    DisplaySize            286 179    # In millimeters
EndSection
}}
```
```{=mediawiki}
{{Note|If you are using the proprietary NVIDIA driver, you may have to put {{ic|Option "UseEdidDpi" "FALSE"}} under {{ic|Device}} or {{ic|Screen}} section to make it take effect.}}
```
If you do not have specifications for physical screen width and height (most specifications these days only list by
diagonal size), you can use the monitor\'s native resolution (or aspect ratio) and diagonal length to calculate the
horizontal and vertical physical dimensions. Using the Pythagorean theorem on a 13.3\" diagonal length screen with a
1280x800 native resolution (or 16:10 aspect ratio):

`$ echo 'scale=5;sqrt(1280^2+800^2)' | bc  # 1509.43698`

This will give the pixel diagonal length, and with this value you can discover the physical horizontal and vertical
lengths (and convert them to millimeters):

`$ echo 'scale=5;(13.3/1509)*1280*25.4' | bc  # 286.43072`\
`$ echo 'scale=5;(13.3/1509)*800*25.4'  | bc  # 179.01920`

```{=mediawiki}
{{Note|This calculation works for monitors with square pixels; however, there is the rare monitor that may compress aspect ratio (e.g 16:10 aspect resolution to a 16:9 monitor). If this is the case, you should measure your screen size manually.}}
```
#### Setting DPI manually {#setting_dpi_manually}

```{=mediawiki}
{{Note|While you can set any DPI you like and applications using Qt and GTK will scale accordingly, it is recommended to set it to '''96''' (100%, no scaling), '''120''' (25% higher), '''144''' (50% higher), '''168''' (75% higher), '''192''' (100% higher) etc., to reduce scaling artifacts to GUIs that use bitmaps. Reducing it below 96 DPI may not reduce the size of the GUIs graphical elements, as typically the lowest DPI the icons are made for is 96.}}
```
For RandR compliant drivers (for example the open source ATI driver), you can set it by:

`$ xrandr --dpi 144`

```{=mediawiki}
{{Note|Applications that comply with the setting will not change immediately. You have to start them anew.}}
```
To make it permanent, see [Autostarting#On Xorg
startup](Autostarting#On_Xorg_startup "Autostarting#On Xorg startup"){.wikilink}.

##### Proprietary NVIDIA driver {#proprietary_nvidia_driver}

You can manually set the DPI by adding the option under the `{{ic|Device}}`{=mediawiki} or `{{ic|Screen}}`{=mediawiki}
section:

`Option              "DPI" "96 x 96"`

##### Manual DPI Setting Caveat {#manual_dpi_setting_caveat}

GTK very often overrides the server\'s DPI via the optional [X resource](X_resource "X resource"){.wikilink}
`{{ic|Xft.dpi}}`{=mediawiki}. To find out whether this is happening to you, check with:

`$ xrdb -query | grep dpi`

With GTK library versions since 3.16, when this variable is not otherwise explicitly set, GTK sets it to 96. To have GTK
apps obey the server DPI you may need to explicitly set `{{ic|Xft.dpi}}`{=mediawiki} to the same value as the server.
The `{{ic|Xft.dpi}}`{=mediawiki} resource is the method by which some desktop environments optionally force DPI to a
particular value in personal settings. Among these are [KDE](KDE "KDE"){.wikilink} and [TDE](TDE "TDE"){.wikilink}.

### Display Power Management {#display_power_management}

[DPMS](DPMS "DPMS"){.wikilink} is a technology that allows power saving behaviour of monitors when the computer is not
in use. This will allow you to have your monitors automatically go into standby after a predefined period of time.

## Composite

The Composite extension for X causes an entire sub-tree of the window hierarchy to be rendered to an off-screen buffer.
Applications can then take the contents of that buffer and do whatever they like. The off-screen buffer can be
automatically merged into the parent window, or merged by external programs called compositing managers. For more
information, see [Wikipedia:Compositing window
manager](Wikipedia:Compositing_window_manager "Wikipedia:Compositing window manager"){.wikilink}.

Some window managers (e.g. [Compiz](Compiz "Compiz"){.wikilink},
[Enlightenment](Enlightenment "Enlightenment"){.wikilink}, [KWin](KWin "KWin"){.wikilink}, `{{Pkg|marco}}`{=mediawiki},
`{{Pkg|metacity}}`{=mediawiki}, `{{Pkg|muffin}}`{=mediawiki}, `{{Pkg|mutter}}`{=mediawiki},
[Xfwm](Xfwm "Xfwm"){.wikilink}) do compositing on their own. For other window managers, a standalone composite manager
can be used.

### List of composite managers {#list_of_composite_managers}

- ```{=mediawiki}
  {{App|[[Picom]]|Lightweight compositor with shadowing, advanced blurring and fading. Forked from Compton.|https://github.com/yshui/picom|{{Pkg|picom}}}}
  ```

- ```{=mediawiki}
  {{App|[[Xcompmgr]]|Composite window-effects manager.|https://gitlab.freedesktop.org/xorg/app/xcompmgr/|{{Pkg|xcompmgr}}}}
  ```

- ```{=mediawiki}
  {{App|[[Gamescope]]|The micro-compositor from Valve, with gaming-oriented features such as FSR upscaling. Forked from steamos-compositor.|https://github.com/ValveSoftware/gamescope|{{Pkg|gamescope}}}}
  ```

- ```{=mediawiki}
  {{App|steamos-compositor-plus|Valve's compositor, with some added tweaks and fixes.|https://github.com/chimeraos/steamos-compositor-plus|{{AUR|steamos-compositor-plus}}}}
  ```

## Tips and tricks {#tips_and_tricks}

### Automation

This section lists utilities for automating keyboard / mouse input and window operations (like moving, resizing or
raising).

+-------------+-----------------------------------+-------------------------------------------------------------------+---------------------------------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------+
| Tool        | Package                           | Manual                                                            | [Keysym](Keysym "Keysym"){.wikilink}\ | Window\         | Note                                                                                                                                        |
|             |                                   |                                                                   | input                                 | operations      |                                                                                                                                             |
+=============+===================================+===================================================================+=======================================+=================+=============================================================================================================================================+
| xautomation | ```{=mediawiki}                   | ```{=mediawiki}                                                   | ```{=mediawiki}                       | ```{=mediawiki} | Also contains screen scraping tools. Cannot simulate `{{ic|F13}}`{=mediawiki} and more.                                                     |
|             | {{Pkg|xautomation}}               | {{man|1|xte}}                                                     | {{Yes}}                               | {{No}}          |                                                                                                                                             |
|             | ```                               | ```                                                               | ```                                   | ```             |                                                                                                                                             |
+-------------+-----------------------------------+-------------------------------------------------------------------+---------------------------------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------+
| xdo         | ```{=mediawiki}                   | ```{=mediawiki}                                                   | ```{=mediawiki}                       | ```{=mediawiki} | Small X utility to perform elementary actions on windows.                                                                                   |
|             | {{Pkg|xdo}}                       | {{man|1|xdo}}                                                     | {{No}}                                | {{Yes}}         |                                                                                                                                             |
|             | ```                               | ```                                                               | ```                                   | ```             |                                                                                                                                             |
+-------------+-----------------------------------+-------------------------------------------------------------------+---------------------------------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------+
| xdotool     | ```{=mediawiki}                   | ```{=mediawiki}                                                   | ```{=mediawiki}                       | ```{=mediawiki} | [Very buggy](https://github.com/jordansissel/xdotool/issues) and not in active development, e.g: has broken CLI                             |
|             | {{Pkg|xdotool}}                   | {{man|1|xdotool}}                                                 | {{Yes}}                               | {{Yes}}         | parsing.[3](https://github.com/jordansissel/xdotool/issues/14#issuecomment-327968132)[4](https://github.com/jordansissel/xdotool/issues/71) |
|             | ```                               | ```                                                               | ```                                   | ```             |                                                                                                                                             |
+-------------+-----------------------------------+-------------------------------------------------------------------+---------------------------------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------+
| xvkbd       | ```{=mediawiki}                   | ```{=mediawiki}                                                   | ```{=mediawiki}                       | ```{=mediawiki} | Virtual keyboard for Xorg, also has the `{{ic|-text}}`{=mediawiki} option for sending characters.                                           |
|             | {{AUR|xvkbd}}                     | {{man|1|xvkbd|url=http://t-sato.in.coocan.jp/xvkbd/#option}}      | {{Yes}}                               | {{No}}          |                                                                                                                                             |
|             | ```                               | ```                                                               | ```                                   | ```             |                                                                                                                                             |
+-------------+-----------------------------------+-------------------------------------------------------------------+---------------------------------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------+
| AutoKey     | ```{=mediawiki}                   | [documentation](https://github.com/autokey/autokey#documentation) | ```{=mediawiki}                       | ```{=mediawiki} | Higher-level, powerful macro and scripting utility, with both Qt and Gtk front-ends.                                                        |
|             | {{AUR|autokey-qt}}                |                                                                   | {{Yes}}                               | {{Yes}}         |                                                                                                                                             |
|             | ```                               |                                                                   | ```                                   | ```             |                                                                                                                                             |
|             | `{{AUR|autokey-gtk}}`{=mediawiki} |                                                                   |                                       |                 |                                                                                                                                             |
+-------------+-----------------------------------+-------------------------------------------------------------------+---------------------------------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------+

See also [Clipboard#Tools](Clipboard#Tools "Clipboard#Tools"){.wikilink} and [an overview of X automation
tools](https://venam.nixers.net/blog/unix/2019/01/07/win-automation.html).

### Nested X session {#nested_x_session}

```{=mediawiki}
{{Out of date|maybe tell about Xephyr before}}
```
To run a nested session of another desktop environment:

`$ /usr/bin/Xnest :1 -geometry 1024x768+0+0 -ac -name Windowmaker & wmaker -display :1`

This will launch a Window Maker session in a 1024 by 768 window within your current X session.

This needs the package `{{Pkg|xorg-server-xnest}}`{=mediawiki} to be installed.

A more modern way of doing a nested X session is with [Xephyr](Xephyr "Xephyr"){.wikilink}.

### Starting an application without a window manager {#starting_an_application_without_a_window_manager}

See [xinit#Starting applications without a window
manager](xinit#Starting_applications_without_a_window_manager "xinit#Starting applications without a window manager"){.wikilink}.

### Starting GUI programs remotely {#starting_gui_programs_remotely}

See main article: [OpenSSH#X11 forwarding](OpenSSH#X11_forwarding "OpenSSH#X11 forwarding"){.wikilink}.

### On-demand disabling and enabling of input sources {#on_demand_disabling_and_enabling_of_input_sources}

With the help of *xinput* you can temporarily disable or enable input sources. This might be useful, for example, on
systems that have more than one mouse, such as the ThinkPads and you would rather use just one to avoid unwanted mouse
clicks.

[Install](Install "Install"){.wikilink} the `{{Pkg|xorg-xinput}}`{=mediawiki} package.

Find the name or ID of the device you want to disable:

`$ xinput`

For example in a Lenovo ThinkPad T500, the output looks like this:

```{=mediawiki}
{{hc|$ xinput|<nowiki>
⎡ Virtual core pointer                          id=2    [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
⎜   ↳ TPPS/2 IBM TrackPoint                     id=11   [slave  pointer  (2)]
⎜   ↳ SynPS/2 Synaptics TouchPad                id=10   [slave  pointer  (2)]
⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
    ↳ Power Button                              id=6    [slave  keyboard (3)]
    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
    ↳ Sleep Button                              id=8    [slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard              id=9    [slave  keyboard (3)]
    ↳ ThinkPad Extra Buttons                    id=12   [slave  keyboard (3)]
</nowiki>}}
```
Disable the device with `{{ic|xinput --disable ''device''}}`{=mediawiki}, where *device* is the device ID or name of the
device you want to disable. In this example we will disable the Synaptics Touchpad, with the ID 10:

`$ xinput --disable 10`

To re-enable the device, just issue the opposite command:

`$ xinput --enable 10`

Alternatively using the device name, the command to disable the touchpad would be:

`$ xinput --disable "SynPS/2 Synaptics TouchPad"`

### Persistently disable input source {#persistently_disable_input_source}

You can disable a particular input source using a configuration snippet:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/30-disable-''device''.conf|
Section "InputClass"
       Identifier   "disable-''device''"
       Driver       "''driver_name''"
       MatchProduct "''device_name''"
       Option       "Ignore" "True"
EndSection
}}
```
```{=mediawiki}
{{ic|''device''}}
```
is an arbitrary name, and `{{ic|''driver_name''}}`{=mediawiki} is the name of the input driver, e.g.
`{{ic|libinput}}`{=mediawiki}. `{{ic|''device_name''}}`{=mediawiki} is what is actually used to match the proper device.
For alternate methods of targeting the correct device, such as [libinput](libinput "libinput"){.wikilink}\'s
`{{ic|MatchIsTouchscreen}}`{=mediawiki}, consult your input driver\'s documentation. Though this example uses libinput,
this is a driver-agnostic method which simply prevents the device from being propagated to the driver.

### Killing application with hotkey {#killing_application_with_hotkey}

Run script on hotkey:

`#!/bin/sh`\
`windowFocus=$(xdotool getwindowfocus)`\
`pid=$(xprop -id "$windowFocus" | grep PID)`\
`kill -9 "$pid"`

Dependencies: `{{Pkg|xorg-xprop}}`{=mediawiki}, `{{Pkg|xdotool}}`{=mediawiki}

See also [#Killing an application
visually](#Killing_an_application_visually "#Killing an application visually"){.wikilink}.

### Block TTY access {#block_tty_access}

To block tty access when in an X add the following to [xorg.conf](#Configuration "xorg.conf"){.wikilink}:

```{=mediawiki}
{{bc|
Section "ServerFlags"
    Option "DontVTSwitch" "True"
EndSection
}}
```
This can be used to help restrict command line access on a system accessible to non-trusted users.

### Prevent a user from killing X {#prevent_a_user_from_killing_x}

To prevent a user from killing X when it is running add the following to
[xorg.conf](#Configuration "xorg.conf"){.wikilink}:

```{=mediawiki}
{{bc|
Section "ServerFlags"
    Option "DontZap"      "True"
EndSection
}}
```
```{=mediawiki}
{{Note|The {{ic|Ctrl+Alt+Backspace}} shortcut is not directly what triggers killing the X server, but the {{ic|Terminate_Server}} action from the keyboard map. This is usually not set by default, see [[Xorg/Keyboard configuration#Terminating Xorg with Ctrl+Alt+Backspace]].}}
```
### Killing an application visually {#killing_an_application_visually}

When an application is misbehaving or stuck, instead of using `{{ic|kill}}`{=mediawiki} or `{{ic|killall}}`{=mediawiki}
from a terminal and having to find the process ID or name, `{{Pkg|xorg-xkill}}`{=mediawiki} allows to click on said
application to close its connection to the X server. Many existing applications do indeed abort when their connection to
the X server is closed, but some can choose to continue.

### Rootless Xorg {#rootless_xorg}

Xorg may run with standard user privileges instead of root (so-called \"rootless\" Xorg). This is a significant security
improvement over running as root. Note that some popular [display
managers](display_manager "display manager"){.wikilink} do not support rootless Xorg (e.g.
[LightDM](https://github.com/canonical/lightdm/issues/18) or [XDM](XDM "XDM"){.wikilink}).

You can verify which user Xorg is running as with `{{ic|1=ps -o user= -C Xorg}}`{=mediawiki}.

See also `{{man|1|Xorg.wrap}}`{=mediawiki}, `{{man|8|systemd-logind}}`{=mediawiki}, [Systemd/User#Xorg as a systemd user
service](Systemd/User#Xorg_as_a_systemd_user_service "Systemd/User#Xorg as a systemd user service"){.wikilink},
[Fedora:Changes/XorgWithoutRootRights](Fedora:Changes/XorgWithoutRootRights "Fedora:Changes/XorgWithoutRootRights"){.wikilink}
and `{{Bug|41257}}`{=mediawiki}.

#### Using xinitrc {#using_xinitrc}

To configure rootless Xorg using [xinitrc](xinitrc "xinitrc"){.wikilink}:

- Run startx as a subprocess of the login shell; run `{{ic|startx}}`{=mediawiki} directly and do not use
  `{{ic|exec startx}}`{=mediawiki}.
- Ensure that Xorg uses virtual terminal for which permissions were set, i.e. passed by logind in
  `{{ic|$XDG_VTNR}}`{=mediawiki} via [.xserverrc](xinit#xserverrc ".xserverrc"){.wikilink}.
- If using certain proprietary display drivers, [kernel mode
  setting](kernel_mode_setting "kernel mode setting"){.wikilink}
  [auto-detection](https://gitlab.freedesktop.org/xorg/xserver/-/blob/master/hw/xfree86/xorg-wrapper.c#L222) will fail.
  In such cases, you must set `{{ic|1=needs_root_rights = no}}`{=mediawiki} in
  `{{ic|/etc/X11/Xwrapper.config}}`{=mediawiki}.

Note that executing `{{ic|startx}}`{=mediawiki} directly without `{{ic|exec }}`{=mediawiki} leaves the shell open in the
case of a xorg crash. Since some lock screens are executed inside xorg, this can lead to full access to the executing
user.

#### Using GDM {#using_gdm}

[GDM](GDM "GDM"){.wikilink} will run Xorg without root privileges by default when [kernel mode
setting](kernel_mode_setting "kernel mode setting"){.wikilink} is used.

#### Session log redirection {#session_log_redirection}

When Xorg is run in rootless mode, Xorg logs are saved to `{{ic|~/.local/share/xorg/Xorg.log}}`{=mediawiki}. However,
the stdout and stderr output from the Xorg session is not redirected to this log. To re-enable redirection, start Xorg
with the `{{ic|-keeptty}}`{=mediawiki} flag and redirect the stdout and stderr output to a file:

`startx -- -keeptty >~/.xorg.log 2>&1`

Alternatively, copy `{{ic|/etc/X11/xinit/xserverrc}}`{=mediawiki} to `{{ic|~/.xserverrc}}`{=mediawiki}, and append
`{{ic|-keeptty}}`{=mediawiki}. See [5](https://bbs.archlinux.org/viewtopic.php?pid=1446402#p1446402).

### Xorg as Root {#xorg_as_root}

As explained above, there are circumstances in which rootless Xorg is defaulted to. If this is the case for your
configuration, and you have a need to run Xorg as root, you can configure `{{man|1|Xorg.wrap}}`{=mediawiki} to require
root:

```{=mediawiki}
{{Warning|Running Xorg as root poses security issues. See [[#Rootless Xorg]] for further discussion.}}
```
```{=mediawiki}
{{hc|1=/etc/X11/Xwrapper.config|2=
needs_root_rights = yes
}}
```
### Wayback

Wayback is an X11 compatibility layer which allows for running full X11 desktop environments (and window managers) using
Wayland components. It\'s available from the AUR as `{{AUR|wayback-x11}}`{=mediawiki} package.

## Troubleshooting

### General

If a problem occurs, view the log stored in either `{{ic|/var/log/}}`{=mediawiki} or, for the rootless X default since
v1.16, in `{{ic|~/.local/share/xorg/}}`{=mediawiki}. [GDM](GDM "GDM"){.wikilink} users should check the [systemd
journal](systemd_journal "systemd journal"){.wikilink}. [6](https://bbs.archlinux.org/viewtopic.php?id=184639)

The logfiles are of the form `{{ic|Xorg.n.log}}`{=mediawiki} with `{{ic|n}}`{=mediawiki} being the display number. For a
single user machine with default configuration the applicable log is frequently `{{ic|Xorg.0.log}}`{=mediawiki}, but
otherwise it may vary. To make sure to pick the right file it may help to look at the timestamp of the X server session
start and from which console it was started. For example:

```{=mediawiki}
{{hc|$ grep -e Log -e tty Xorg.0.log|2=
[    40.623] (==) Log file: "/home/archuser/.local/share/xorg/Xorg.0.log", Time: Thu Aug 28 12:36:44 2014
[    40.704] (--) controlling tty is VT number 1, auto-enabling KeepTty
}}
```
```{=mediawiki}
{{Tip|To monitor the log with human-readable timestamps, {{man|1|tail}}'s output can be piped to {{man|1|ts}} (provided by the {{Pkg|moreutils}} package). This will give correct timestamps only for lines added to the log while the command is running. For example:
 $ tail -f ~/.local/share/xorg/Xorg.0.log {{!}}
```
ts }}

- In the logfile then be on the lookout for any lines beginning with `{{ic|(EE)}}`{=mediawiki}, which represent errors,
  and also `{{ic|(WW)}}`{=mediawiki}, which are warnings that could indicate other issues.
- If there is an *empty* `{{ic|.xinitrc}}`{=mediawiki} file in your `{{ic|$HOME}}`{=mediawiki}, either delete or edit it
  in order for X to start properly. If you do not do this X will show a blank screen with what appears to be no errors
  in your `{{ic|Xorg.0.log}}`{=mediawiki}. Simply deleting it will get it running with a default X environment.
- If the screen goes black, you may still attempt to switch to a different virtual console (e.g.
  `{{ic|Ctrl+Alt+F6}}`{=mediawiki}), and blindly log in as root. You can do this by typing `{{ic|root}}`{=mediawiki}
  (press `{{ic|Enter}}`{=mediawiki} after typing it) and entering the root password (again, press
  `{{ic|Enter}}`{=mediawiki} after typing it).

:   You may also attempt to kill the X server with:
:   ```{=mediawiki}
    {{bc|# pkill -x X}}
    ```
:   If this does not work, reboot blindly with:
:   ```{=mediawiki}
    {{bc|# reboot}}
    ```

- Check specific pages in [:Category:Input devices](:Category:Input_devices ":Category:Input devices"){.wikilink} if you
  have issues with keyboard, mouse, touchpad etc.
- Search for common problems in [AMDGPU](AMDGPU "AMDGPU"){.wikilink}, [Intel](Intel "Intel"){.wikilink} and
  [NVIDIA](NVIDIA "NVIDIA"){.wikilink} articles.

### Black screen, No protocol specified, Resource temporarily unavailable for all or some users {#black_screen_no_protocol_specified_resource_temporarily_unavailable_for_all_or_some_users}

X creates configuration and temporary files in current user\'s home directory. Make sure there is free disk space
available on the partition your home directory resides in. Unfortunately, X server does not provide any more obvious
information about lack of disk space in this case.

### DRI with Matrox cards stopped working {#dri_with_matrox_cards_stopped_working}

If you use a Matrox card and DRI stopped working after upgrading to Xorg, try adding the line:

`Option "OldDmaInit" "On"`

to the `{{ic|Device}}`{=mediawiki} section that references the video card in `{{ic|xorg.conf}}`{=mediawiki}.

### Frame-buffer mode problems {#frame_buffer_mode_problems}

X fails to start with the following log messages:

```{=mediawiki}
{{bc|<nowiki>
(WW) Falling back to old probe method for fbdev
(II) Loading sub module "fbdevhw"
(II) LoadModule: "fbdevhw"
(II) Loading /usr/lib/xorg/modules/linux//libfbdevhw.so
(II) Module fbdevhw: vendor="X.Org Foundation"
       compiled for 1.6.1, module version=0.0.2
       ABI class: X.Org Video Driver, version 5.0
(II) FBDEV(1): using default device

Fatal server error:
Cannot run in framebuffer mode. Please specify busIDs for all framebuffer devices
</nowiki>}}
```
To correct, [uninstall](uninstall "uninstall"){.wikilink} the `{{pkg|xf86-video-fbdev}}`{=mediawiki} package.

### Program requests \"font \'(null)\'\" {#program_requests_font_null}

Error message: ``{{ic|unable to load font `(null)'}}``{=mediawiki}.

Some programs only work with bitmap fonts. Two major packages with bitmap fonts are available,
`{{Pkg|xorg-fonts-75dpi}}`{=mediawiki} and `{{Pkg|xorg-fonts-100dpi}}`{=mediawiki}. You do not need both; one should be
enough. To find out which one would be better in your case, try `{{ic|xdpyinfo}}`{=mediawiki} from
`{{Pkg|xorg-xdpyinfo}}`{=mediawiki}, like this:

`$ xdpyinfo | grep resolution`

and use what is closer to the shown value.

### Recovery: disabling Xorg before GUI login {#recovery_disabling_xorg_before_gui_login}

If Xorg is set to boot up automatically and for some reason you need to prevent it from starting up before the
login/display manager appears (if the system is wrongly configured and Xorg does not recognize your mouse or keyboard
input, for instance), you can accomplish this task with two methods.

- Change default target to `{{ic|rescue.target}}`{=mediawiki}. See [systemd#Change default target to boot
  into](systemd#Change_default_target_to_boot_into "systemd#Change default target to boot into"){.wikilink}.
- If you have not only a faulty system that makes Xorg unusable, but you have also set the GRUB menu wait time to zero,
  or cannot otherwise use GRUB to prevent Xorg from booting, you can use the Arch Linux live CD. Follow the
  [installation guide](Installation_guide#Format_the_partitions "installation guide"){.wikilink} about how to mount and
  chroot into the installed Arch Linux. Alternatively try to switch into another [tty](tty "tty"){.wikilink} with
  `{{ic|Ctrl+Alt}}`{=mediawiki} + function key (usually from `{{ic|F1}}`{=mediawiki} to `{{ic|F7}}`{=mediawiki}
  depending on which is not used by X), login as root and follow steps below.

Depending on setup, you will need to do one or more of these steps:

- [Disable](Disable "Disable"){.wikilink} the [display manager](display_manager "display manager"){.wikilink}.
- Disable the [automatic start of X](start_X_at_login "automatic start of X"){.wikilink}.
- Rename the `{{ic|~/.xinitrc}}`{=mediawiki} or comment out the `{{ic|exec}}`{=mediawiki} line in it.

### X clients started with \"su\" fail {#x_clients_started_with_su_fail}

If you are getting `{{ic|Client is not authorized to connect to server}}`{=mediawiki}, try adding the line:

`session        optional        pam_xauth.so`

to `{{ic|/etc/pam.d/su}}`{=mediawiki} and `{{ic|/etc/pam.d/su-l}}`{=mediawiki}. `{{ic|pam_xauth}}`{=mediawiki} will then
properly set environment variables and handle `{{ic|xauth}}`{=mediawiki} keys.

### X failed to start: Keyboard initialization failed {#x_failed_to_start_keyboard_initialization_failed}

If the filesystem (specifically `{{ic|/tmp}}`{=mediawiki}) is full, `{{ic|startx}}`{=mediawiki} will fail. The log file
will contain:

```{=mediawiki}
{{bc|
(EE) Error compiling keymap (server-0)
(EE) XKB: Could not compile keymap
(EE) XKB: Failed to load keymap. Loading default keymap instead.
(EE) Error compiling keymap (server-0)
(EE) XKB: Could not compile keymap
XKB: Failed to compile keymap
Keyboard initialization failed. This could be a missing or incorrect setup of xkeyboard-config.
Fatal server error:
Failed to activate core devices.
...
}}
```
Make some free space on the relevant filesystem and X will start.

### A green screen whenever trying to watch a video {#a_green_screen_whenever_trying_to_watch_a_video}

Your color depth is set wrong. It may need to be 24 instead of 16, for example.

### SocketCreateListener error {#socketcreatelistener_error}

If X terminates with error message `{{ic|SocketCreateListener() failed}}`{=mediawiki}, you may need to delete socket
files in `{{ic|/tmp/.X11-unix}}`{=mediawiki}. This may happen if you have previously run Xorg as root (e.g. to generate
an `{{ic|xorg.conf}}`{=mediawiki}).

### Invalid MIT-MAGIC-COOKIE-1 key when trying to run a program as root {#invalid_mit_magic_cookie_1_key_when_trying_to_run_a_program_as_root}

That error means that only the current user has access to the X server. The solution is to give access to root:

`$ xhost +si:localuser:root`

That line can also be used to give access to X to a different user than root.

## See also {#see_also}

- [Xplain](https://magcius.github.io/xplain/article/) - In-depth explanation of the X Window System

- ```{=mediawiki}
  {{man|1|Xorg}}
  ```

- [Prepare for LPIC-1 exam 2 - topic 106.1: X11](https://developer.ibm.com/tutorials/l-lpic1-106-1/) - briefly covers
  architecture, [#Configuration](#Configuration "#Configuration"){.wikilink}, [desktop
  environments](desktop_environments "desktop environments"){.wikilink}, remote usage,
  [Wayland](Wayland "Wayland"){.wikilink}.

- ```{=mediawiki}
  {{man|5|xorg.conf}}
  ```

- [Gentoo:Xorg/Guide#Configuration](Gentoo:Xorg/Guide#Configuration "Gentoo:Xorg/Guide#Configuration"){.wikilink}

[Category:X server](Category:X_server "Category:X server"){.wikilink}




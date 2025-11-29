[ja:マルチディスプレイ](ja:マルチディスプレイ "ja:マルチディスプレイ"){.wikilink}
[zh-hans:Multihead](zh-hans:Multihead "zh-hans:Multihead"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|Xorg}}`{=mediawiki} `{{Related|xrandr}}`{=mediawiki} `{{Related|NVIDIA#Multiple monitors}}`{=mediawiki}
`{{Related|Extreme Multihead}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

**Multi-head**, **multi-screen**, **multi-display** or **multi-monitor** represent setups with multiple display devices
attached to a single computer. This article provides a general description for several multi-head setup methods, and
provides some configuration examples.

```{=mediawiki}
{{Note|The terms used in this article are very specific to avoid confusion:
* '''Monitor''' refers to a physical display device, such as an LCD panel.
* '''Screen''' refers to an X-Window screen (that is: a '''monitor''' attached to a '''display''').
* '''Display''' refers to a collection of '''screens''' that are in use at the same time showing parts of a single desktop (you can drag windows among all '''screens''' in a single '''display''').
}}
```
## Historical background {#historical_background}

X Window System (X, X11) is the underlying graphical user interface (GUI) for most Unix/Linux computers that provide
one. It was developed in 1984 at MIT. After about 35 years of development, tweaks, new features and ideas, it is
generally acknowledged to be a bit of a beast. During the time of early development, the common configuration was a
single running X that provided individual views to Xterminals on a
[time-sharing](Wikipedia:_Time-sharing "time-sharing"){.wikilink} system. Today, X typically provides a single screen on
a desktop or laptop.

```{=mediawiki}
{{Note|There is still a rare configuration often called [[Xorg multiseat|Zaphod display]], which allows multiple users of a single computer to each have an independent set of display, mouse, and keyboard, as though they were using separate computers, but at a lower per-seat cost.}}
```
In short, there are many ways to configure GUIs using X. When using modern versions, sometimes you can even get away
with limited or no configuration. In the last few years, the boast is that X is self-configuring. Certainly, a good rule
of thumb is that less configuration is better - that is, *only configure what the defaults got wrong*.

## RandR

[RandR](Wikipedia:RandR "RandR"){.wikilink} (**R**otate **and** **R**esize) is an [X Window
System](Wikipedia:X_Window_System "X Window System"){.wikilink} extension, which allows clients to dynamically change
(e.g. resize, rotate, reflect) screens. In most cases, it can fully replace the old Xinerama setup. See [an
explanation](https://i3wm.org/docs/multi-monitor.html#_the_explanation) why RandR is better than Xinerama.

RandR can be configured for the current session via the [xrandr](xrandr "xrandr"){.wikilink} tool, arandr or
persistently via an [xorg.conf](xorg.conf "xorg.conf"){.wikilink} file.

```{=mediawiki}
{{Note|There are multiple ways to configure the same thing, you might have to experiment a little before you find the best configuration.}}
```
### Configuration using xrandr {#configuration_using_xrandr}

```{=mediawiki}
{{Note|This section assumes that you have read the [[xrandr]] page for basic info about ''xrandr''.}}
```
You may arrange your screens either relatively to each other (using the `{{ic|--right-of}}`{=mediawiki},
`{{ic|--left-of}}`{=mediawiki}, `{{ic|--above}}`{=mediawiki}, `{{ic|--below}}`{=mediawiki} options), or by absolute
coordinates (using the `{{ic|--pos}}`{=mediawiki} option; note that in this case you usually need to know resolutions of
your monitors). See `{{man|1|xrandr}}`{=mediawiki} for details. Some frequently used settings are described below.

#### VGA1 left of HDMI1 at their preferred resolutions {#vga1_left_of_hdmi1_at_their_preferred_resolutions}

`$ xrandr --output VGA1 --auto --output HDMI1 --auto --right-of VGA1`

```{=mediawiki}
{{ic|--right-of}}
```
places the previous screen (`{{ic|HDMI1}}`{=mediawiki}) to the right of the specified screen
(`{{ic|VGA1}}`{=mediawiki}).

#### VGA1 right of HDMI1 at fixed resolutions {#vga1_right_of_hdmi1_at_fixed_resolutions}

`$ xrandr --output VGA1 --mode 1024x768 --pos 1920x0 --output HDMI1 --mode 1920x1080 --pos 0x0`

or

`$ xrandr --output VGA1 --mode 1024x768 --output HDMI1 --mode 1920x1080 --left-of VGA1`

```{=mediawiki}
{{ic|--left-of}}
```
places the previous screen (`{{ic|HDMI1}}`{=mediawiki}) to the left of the specified screen (`{{ic|VGA1}}`{=mediawiki}).

#### Combine screens into virtual display {#combine_screens_into_virtual_display}

Since randr version 1.5, it has been possible to combine monitors into one virtual display. This is an updated version
of what was possible with Xinerama and works with open source drivers and does not require an Xorg restart. Some desktop
environments do not support this feature yet. [Openbox](Openbox "Openbox"){.wikilink} has been tested and works with
this feature.

Get monitor list by doing `{{ic|xrandr --listmonitors}}`{=mediawiki}

`0: +*DisplayPort-4 1920/518x1200/324+1920+0  DisplayPort-4`\
`1: +DisplayPort-3 1920/518x1200/324+0+0  DisplayPort-3`\
`2: +HDMI-A-0 1920/518x1200/324+3840+0  HDMI-A-0`

Create virtual display `{{ic|xrandr --setmonitor SomeName auto DisplayPort-4,DisplayPort-3,HDMI-A-0}}`{=mediawiki}.
`{{ic|auto}}`{=mediawiki} determines the size of the virtual display, setting this to auto will automatically create the
correct size of the display array. Monitor order in this command does not matter and the monitors need to be rearranged
correctly after or before this command is executed.

For a more detailed explanation see [this page](http://www.straightrunning.com/tools/xrandr.html#sect3).

### Configuration using xorg.conf {#configuration_using_xorg.conf}

This is similar to using *xrandr*, separate `{{ic|Monitor}}`{=mediawiki} section is needed for each screen. As an
`{{ic|Identifier}}`{=mediawiki}, the same value as reported by `{{ic|xrandr -q}}`{=mediawiki} is used (i.e.
`{{ic|Identifier "VGA1"}}`{=mediawiki} is used instead of `{{ic|--output VGA1}}`{=mediawiki}).

#### Example: dualhead configuration using relative coordinates {#example_dualhead_configuration_using_relative_coordinates}

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-monitor.conf|
Section "Monitor"
    Identifier  "VGA1"
    Option      "Primary" "true"
EndSection

Section "Monitor"
    Identifier  "HDMI1"
    Option      "LeftOf" "VGA1"
EndSection
}}
```
#### Example: dualhead configuration using relative coordinates with custom resolutions {#example_dualhead_configuration_using_relative_coordinates_with_custom_resolutions}

The ID for each monitor can be found by running the `{{ic|$ xrandr -q}}`{=mediawiki} command and should be defined as
`{{ic|Monitor-<ID>}}`{=mediawiki} inside the `{{ic|Device}}`{=mediawiki} section.

See [Xrandr#Adding undetected
resolutions](Xrandr#Adding_undetected_resolutions "Xrandr#Adding undetected resolutions"){.wikilink}.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-monitor.conf|
Section "Monitor"
  Identifier "DVI"
  Modeline "1680x1050_60.00"  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync
  Option "PreferredMode" "1680x1050_60.00"
  Option "LeftOf" "DP"
  Option "DPMS" "true"
EndSection

Section "Monitor"
  Identifier "DP"
  Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
  Option "PreferredMode" "1920x1080_60.00"
  Option "RightOf" "DVI"
  Option "DPMS" "true"
EndSection

Section "Screen"
  Identifier "Screen0"
  Device "Radeon" # e.g. Radeon, Intel, nvidia
  Monitor "DP"
  DefaultDepth 24
  SubSection "Display"
    Depth 24
    Virtual 3600 2130 # 1920 + 1680 (3600), 1080 + 1050 (2130)
  EndSubSection
EndSection
}}
```
```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-radeon.conf|
Section "Device"
  Identifier "Radeon"
  Driver "radeon"
  Option "Monitor-DVI-0" "DVI" # use DVI-0 as DVI
  Option "Monitor-DisplayPort-0" "DP"
EndSection
}}
```
#### Example: dualhead configuration using absolute coordinates {#example_dualhead_configuration_using_absolute_coordinates}

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/10-monitor.conf|
Section "Monitor"
    Identifier  "VGA1"
    Option      "PreferredMode" "1024x768"
    Option      "Position" "1920 312"
EndSection

Section "Monitor"
    Identifier  "HDMI1"
    Option      "PreferredMode" "1920x1080"
    Option      "Position" "0 0"
EndSection
}}
```
There are no negative coordinates, the setup\'s leftmost and highest possibly targeted point is at 0,0

```{=mediawiki}
{{Text art|<nowiki>
(0,0)-----------------+ 
|                     |(1920,312)---+
|     1920 x 1080     ||            |
|        HDMI1        || 1024 x 768 |
|                     ||    VGA1    |
+---------------------++------------+
</nowiki>}}
```
## Dynamic display configuration {#dynamic_display_configuration}

The following options allow you to automatically detect when a new display is connected and then change the layout based
on that. This can be useful for laptop users who frequently work in multiple different environments that require
different setups.

- ```{=mediawiki}
  {{Pkg|autorandr}}
  ```
  allows you to save your current [xrandr](xrandr "xrandr"){.wikilink} configuration as profiles based on what display
  hardware is connected.

- ```{=mediawiki}
  {{AUR|mons}}
  ```
  or `{{AUR|mons-git}}`{=mediawiki} is a shell script to quickly manage 2-monitors display using
  [xrandr](xrandr "xrandr"){.wikilink}.

## Separate screens {#separate_screens}

```{=mediawiki}
{{Expansion|There's no information on how to set up X server to behave the way described.}}
```
This is the original way of configuring multiple monitors with X, and it has been around for decades. Each physical
monitor is assigned as an X screen, and while you can move the mouse between them, they are more or less independent.

Normally the X display has a single identifier such as `{{ic|:0}}`{=mediawiki}, set in the `{{ic|DISPLAY}}`{=mediawiki}
environment variable; but in this configuration, each screen has a different `{{ic|$DISPLAY}}`{=mediawiki} value. The
first screen is `{{ic|:0.0}}`{=mediawiki}, the second is `{{ic|:0.1}}`{=mediawiki} and so on.

With this configuration, it is not possible to move windows between screens, apart from a few special programs like GIMP
and Emacs, which have multi-screen support. For most programs, you must change the `{{ic|DISPLAY}}`{=mediawiki}
environment variable when launching to have the program appear on another screen:

`# Launch a terminal on the second screen`\
`$ DISPLAY=:0.1 urxvt &`

Alternatively, if you have a terminal on each screen, launching programs will inherit the `{{ic|DISPLAY}}`{=mediawiki}
value and appear on the same screen they were launched on. But, moving an application between screens involves closing
it and reopening it again on the other screen.

Working this way does have certain advantages. For example, windows popping up on one screen will not steal the focus
away from you if you are working on another screen - each screen is quite independent.

## TwinView

TwinView is [NVIDIA](NVIDIA "NVIDIA"){.wikilink}\'s extension which makes two monitors attached to a video card appear
as a single screen. TwinView provides Xinerama extensions so that applications are aware there are two monitors
connected, and thus it is incompatible with Xinerama. However, if you only have two monitors and they are both connected
to the same NVIDIA card, there is little difference between TwinView and Xinerama (although in this situation TwinView
may offer slightly better performance.)

If you wish to attach more than two monitors or monitors attached to other video cards, you will need to use Xinerama
instead of TwinView. Likewise, as of April 2012, both monitors must be in the same orientation - you cannot have one in
landscape and the other in portrait mode.

In the past, TwinView was the only way to get OpenGL acceleration with NVIDIA cards while being able to drag windows
between screens. However modern versions of the NVIDIA closed-source driver are able to provide OpenGL acceleration even
when using Xinerama.

See [NVIDIA#TwinView](NVIDIA#TwinView "NVIDIA#TwinView"){.wikilink} for an example configuration.

## Xinerama

[Xinerama](Wikipedia:Xinerama "Xinerama"){.wikilink} is the old way of doing genuine multihead X. Xinerama combines all
monitors into a single screen (`{{ic|:0}}`{=mediawiki}) making it possible to drag windows between screens.

Xinerama is configured via custom [X configuration files](Xorg#Configuration "X configuration files"){.wikilink}. There
is also a GUI tool named [WideGuy](https://openapplibrary.org/project/wideguy) to make toggling Xinerama easier. Note
that to use WideGuy you still need an Xorg configuration with a ServerLayout section.

Here are some [X configuration](Xorg#Configuration "X configuration"){.wikilink} examples:

This is a ServerLayout section which controls where each monitor sits relative to the others.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/90-serverlayout.conf|
Section "ServerLayout"
  Identifier   "Main"
  Screen       0 "Primary"
  Screen       1 "DellPortraitLeft" RightOf "Primary"
  Screen       2 "Wacom" RightOf "DellPortraitLeft"
  Screen       3 "U2412" LeftOf "Primary"
  Option         "Xinerama" "1"  # enable XINERAMA extension.  Default is disabled.
EndSection
}}
```
Each Screen in the above section is defined in a separate file, such as this one:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/30-screen-dell2001.conf|
# Define the monitor's physical specs
Section "Monitor"
  Identifier   "Dell 2001FP"
  VertRefresh  60
  Option  "dpms"  "on"

  # Modelines are probably unnecessary these days, but it does give you fine-grained control

  # 1600x1200 @ 60.00 Hz (GTF) hsync: 74.52 kHz; pclk: 160.96 MHz
  Modeline "1600x1200"  160.96  1600 1704 1880 2160  1200 1201 1204 1242  -HSync +Vsync
EndSection

# Define a screen that uses the above monitor.  Note the Monitor value matches the above
# Identifier value and the Device value matches one of the video cards defined below
# (the card and connector this monitor is actually plugged in to.)
Section "Screen"
  Identifier   "DellPortraitLeft"
  Device       "GeForce 8600GTb"
  Monitor      "Dell 2001FP"
  DefaultDepth 24
  SubSection "Display"
    Depth     24
    Modes     "1600x1200"
    ViewPort  0 0
    Virtual   1600 1200
  EndSubsection

  # This screen is in portrait mode
  Option "Rotate" "left"
EndSection
}}
```
You will need to create a `{{ic|Device}}`{=mediawiki} section for each **monitor**, i.e. a dual head video card will
have two Device sections. The following example shows how to configure two video cards each providing two outputs, for a
total of four monitors.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-nvidia.conf|
# First head of first video card in the system
Section "Device"
  Identifier  "GeForce 8600GT"
  Driver      "nvidia"

  # If you have multiple video cards, the BusID controls which one this definition refers
  # to.  You can omit it if you only have one card.
  BusID       "PCI:1:0:0"

  # Need to flag this as only referring to one output on the card
  Screen      0

  # For nVidia devices, this controls which connector the monitor is connected to.
  Option      "UseDisplayDevice"   "DFP-0"

  # We want control!
  Option      "DynamicTwinView"    "FALSE"

  # Various performance and configuration options
  Option      "AddARGBGLXVisuals"  "true"
  Option      "UseEDIDDpi"         "false"
  Option      "DPI"                "96 x 96"
  Option      "Coolbits"           "1"
EndSection

# Second head of same video card (note different Identifier but same BusID.)  We can omit
# the UseDisplayDevice option this time as it will pick whichever one is remaining.
Section "Device"
  Identifier  "GeForce 8600GTb"
  Driver      "nvidia"
  BusID       "PCI:1:0:0"
  # This is the second output on this card
  Screen      1

  # Same config options for all cards
  Option      "AddARGBGLXVisuals"  "true"
  Option      "UseEDIDDpi"         "false"
  Option      "DPI"                "96 x 96"
  Option      "Coolbits"           "1"
  Option      "DynamicTwinView"    "FALSE"
EndSection

# First head of second video card, note different BusID.
Section "Device"
  Identifier  "G210"
  Driver      "nvidia"
  BusID       "PCI:2:0:0"
  Screen      0

  # Same config options for all cards
  Option      "AddARGBGLXVisuals"  "true"
  Option      "UseEDIDDpi"         "false"
  Option      "DPI"                "96 x 96"
  Option      "Coolbits"           "1"
  Option      "DynamicTwinView"    "FALSE"
EndSection

# Second head of second video card.  Output connector is set here, which means the previous
# Device will use the other connector, whatever it may be.
Section "Device"
  Identifier  "G210b"
  Driver      "nvidia"
  BusID       "PCI:2:0:0"
  Screen      1
  Option      "UseDisplayDevice"   "DFP-1"

  # Same config options for all cards
  Option      "AddARGBGLXVisuals"  "true"
  Option      "UseEDIDDpi"         "false"
  Option      "DPI"                "96 x 96"
  Option      "Coolbits"           "1"
  Option      "DynamicTwinView"    "FALSE"
EndSection
}}
```
## See also {#see_also}

- [\'How I got Dual Monitors with Nouveau Driver\' forums thread](https://bbs.archlinux.org/viewtopic.php?pid=652861)
- [Six-headed, Six-user Linux System](https://linuxgazette.net/124/smith.html)

[Category:X server](Category:X_server "Category:X server"){.wikilink}

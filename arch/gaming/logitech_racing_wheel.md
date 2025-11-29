[ja:Logicool レーシングホイール](ja:Logicool_レーシングホイール "wikilink") This article describes how to set up a
Logitech racing wheel, such as a Formula Force GP or a G27/G29 racing wheel, with Arch Linux.

## Installing

### Identifying

When the wheel is plugged in, the following commands can be used to identify the wheel:

```{=mediawiki}
{{hc|# dmesg|usb 5-2: new low speed USB device using uhci_hcd and address 6}}
```
```{=mediawiki}
{{hc|$ lsusb|Bus 005 Device 006: ID 046d:c293 Logitech, Inc. WingMan Formula Force GP}}
```
If using a Logitech Wheel, make sure it is set to PS3 mode otherwise it will not work.

### Checking input device {#checking_input_device}

```{=mediawiki}
{{hc|$ cat /proc/bus/input/devices|2=
I: Bus=0003 Vendor=046d Product=c293 Version=0100
N: Name="Logitech Inc. WingMan Formula Force GP"
P: Phys=usb-0000:00:1a.2-2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input30
U: Uniq=
H: Handlers=event15 js0 
B: EV=20001b
B: KEY=3f 0 0 0 0 0 0 0 0 0
B: ABS=3
B: MSC=10
B: FF=1 40000 0 0
}}
```
If you do not see your Logitech listed as an input device, you need to install usb_modeswitch package. Please memorize
the **Handlers**, here **event15** and **js0**, as these will be necessary to call the tools for testing and configuring
the wheel.

### Testing

For testing the wheel there are multiple tools that can be accessed via the command-line. One common tool is
`{{ic|jstest}}`{=mediawiki} which can be installed via the `{{Pkg|joyutils}}`{=mediawiki} or the
`{{Pkg|linuxconsole}}`{=mediawiki} packages. An alternative is `{{ic|evtest}}`{=mediawiki} which can be installed via
the `{{Pkg|evtest}}`{=mediawiki} package. A graphical version of `{{ic|jstest}}`{=mediawiki} is available in the AUR as
`{{AUR|jstest-gtk-git}}`{=mediawiki}.

To test the wheel with `{{ic|jstest}}`{=mediawiki} simply call it with the device handler (in this case with a G29 wheel
and **js0**):

```{=mediawiki}
{{hc|$ jstest /dev/input/js0|2=
Driver version is 2.1.0.
Joystick (Logitech G29 Driving Force Racing Wheel) has 6 axes (X, Y, Z, Rz, Hat0X, Hat0Y)
and 25 buttons (Trigger, ThumbBtn, ThumbBtn2, TopBtn, TopBtn2, PinkieBtn, BaseBtn, BaseBtn2, BaseBtn3, BaseBtn4, BaseBtn5, BaseBtn6, ?, ?, ?, BtnDead, (null), (null), (null), (null), (null), (null), (null), (null), (null)).
Testing ... (interrupt to exit)
Axes:  0:  -923  1: 32767  2: 32767  3: 32767  4:     0  5:     0 Buttons:  0:off  1:off  2:off  3:off  4:off  5:off  6:off  7:off  8:off  9:off 10:off 11:off 12:off 13:off 14:off 15:off 16:off 17:off 18:off 19:off 20:off 21:off 22:off 23:off 24:off 
}}
```
Whenever the input is changed, `{{ic|jstest}}`{=mediawiki} will print the full state of the device. In case that only
events should be displayed, `{{ic|--event}}`{=mediawiki} can be added as flag.

When using `{{ic|evtest}}`{=mediawiki} for testing, instead of the **js0** as device handler **eventX** is needed, which
in this case is **event15** for a Formula Force GP wheel. `{{ic|evtest}}`{=mediawiki} then shows the events coming from
the wheel:

```{=mediawiki}
{{hc|$ evtest /dev/input/event15|
Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0x46d product 0xc293 version 0x100
Input device name: "Logitech Inc. WingMan Formula Force GP"
Supported events:
 Event type 0 (Reset)
   Event code 0 (Reset)
   Event code 1 (Key)
   Event code 3 (Absolute)
   Event code 4 (?)
   Event code 21 (ForceFeedback)
 Event type 1 (Key)
   Event code 288 (Trigger)
   Event code 289 (ThumbBtn)
   Event code 290 (ThumbBtn2)
   Event code 291 (TopBtn)
   Event code 292 (TopBtn2)
   Event code 293 (PinkieBtn)
 Event type 3 (Absolute)
   Event code 0 (X)
     Value    438
     Min        0
     Max     1023
     Fuzz       3
     Flat      63
   Event code 1 (Y)
     Value    124
     Min        0
     Max      255
     Flat      15
 Event type 4 (?)
   Event code 4 (?)
 Event type 21 (ForceFeedback)
   Event code 82 (?)
   Event code 96 (?)
Testing ... (interrupt to exit)
Event: time 1295173625.476950, type 3 (Absolute), code 0 (X), value 439
Event: time 1295173625.476983, type 0 (Reset), code 0 (Reset), value 0
Event: time 1295173625.484827, type 3 (Absolute), code 0 (X), value 428
}}
```
```{=mediawiki}
{{ic|ffcfstress}}
```
, which is provided by `{{Pkg|joyutils}}`{=mediawiki}, can be used to test the force feedback. The wheel should start to
oscillate:

```{=mediawiki}
{{hc|# ffcfstress -d /dev/input/event15|<nowiki>
         position                   center                     force
 <-----------|****+------> <-----------|*******----> <-----------|**+-------->^C</nowiki>
}}
```
## Configuration

### Oversteer

Logitech wheels can be configured via the `{{ic|oversteer}}`{=mediawiki} tool from the `{{AUR|oversteer}}`{=mediawiki}
package. For general gamepad or joystick settings that may also apply to Logitech wheels, please refer to the
[Gamepad](Gamepad "wikilink") wiki page.

As of version 0.6.0, `{{ic|oversteer}}`{=mediawiki} contains compatibility modes for the following wheels:

-   Driving Force / Formula EX
-   Driving Force Pro
-   Driving Force GT
-   G25 Racing Wheel
-   G27 Racing Wheel
-   G29 Racing Wheel

Besides testing the wheel, `{{ic|oversteer}}`{=mediawiki} allows to configure the following aspects of the wheels:

-   Steering hardware lock (in degrees)
-   Combining pedals into one axis
-   Global force feedback strength
-   Manual auto-center force

### new-lg4ff {#new_lg4ff}

For older wheels, that use the driver lg4ff and Logitech Classic HID mode, additional settings might be enabled by
installing the `{{AUR|new-lg4ff-dkms-git}}`{=mediawiki} device driver. Especially the steering hardware lock is useful
in certain racing games such as F1 2017 and Dirt Rally to allow for a more realistic steering experience by setting the
hardware lock angle to the value of the actual vehicle (e.g. 360 for F1 cars and 540 for modern rally cars).

Recent wheels, such as the G920, and the G923 Xbox edition, use the new HID++ protocol and hid_logitech_hidpp Logitech
driver, and are not compatible with new-lg4ff.

## Wheel specific configuration {#wheel_specific_configuration}

### Logitech G923 Xbox Edition {#logitech_g923_xbox_edition}

This racing wheel requires signals to be sent to change its usb mode every time it is plugged in. To accomplish this:

-   Install `{{Pkg|usb_modeswitch}}`{=mediawiki}
-   When the wheel is plugged in run:

`# usb_modeswitch -v 046d -p c26d -M 0f00010142 -C 0x03 -m 01 -r 81`

The wheel will then reset itself to the centered position and be available as a racing wheel in games.

## Games

### Flatout 2 {#flatout_2}

The Wheel works without any wine configuration in flatout2. Just the following in-game configuration is needed:

-   Force Feedback: On
-   Force level: 100%
-   Sensitivity: 100%
-   Deadzone: 0%
-   Controller: Logitech Inc\...

```{=html}
<!-- -->
```
-   Throttle: Y-Axis left
-   Brake: Y-Axis right
-   Steer left: X-axis left
-   Steer right: X-axis right

### rFactor 2 {#rfactor_2}

rFactor 2 does not have functional force feedback with the built-in lg4ff driver (for wheels that use the
hid_logitech_hidpp driver, it works as expected). To make it work, the aforementioned
`{{AUR|new-lg4ff-dkms-git}}`{=mediawiki} driver must be installed. The driver may not load after rebooting. You can
check in the [journal](journal "wikilink"):

`logitech 0003:046D:C24F.000B: Force feedback support for Logitech Gaming Wheels (`**`0.2b`**`)`

If there is no version number written after `{{ic|Force feedback support for Logitech Gaming Wheels}}`{=mediawiki} and
the FFB still does not work, the driver likely has not loaded and you will need to [regenerate the
initramfs](regenerate_the_initramfs "wikilink").

After that, the FFB should work, but it may be inverted. You can fix this by going to
`{{ic|''path-to-game''/rFactor 2/UserData/player/}}`{=mediawiki} and editing `{{ic|Controller.JSON}}`{=mediawiki}. Find
line `{{ic|"Steering effects strength"}}`{=mediawiki} and invert its value (typically going from
`{{ic|10000}}`{=mediawiki} to `{{ic|-10000}}`{=mediawiki}).

## See also {#see_also}

[Sourceforge wiki:
CheckForceFeedback](https://web.archive.org/web/20140408031129/https://sourceforge.net/apps/mediawiki/libff/index.php?title=CheckForceFeedback)

[Category:Input devices](Category:Input_devices "wikilink") [Category:Gaming](Category:Gaming "wikilink")

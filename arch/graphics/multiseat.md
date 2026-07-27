```{=mediawiki}
{{Related articles start}}
```
```{=mediawiki}
{{Related|Xorg_multiseat}}
```
```{=mediawiki}
{{Related articles end}}
```
## Introduction

In a multiseat setup, a single machine serves multiple independent users, each with their own monitor, keyboard, and
mouse. Each set of devices is grouped into a \"seat\", and each seat gets its own independent login session.

This guide covers both X11 and Wayland sessions using the modern logind-based approach. For legacy X11 multiseat
configuration, see [Xorg_multiseat](Xorg_multiseat "wikilink").

## Requirements

Each seat needs its own graphics device - an integrated APU, a discrete GPU, or a USB graphics adapter. Preferably all
devices use the same graphics driver. A single GPU with multiple outputs cannot be split across seats.

Each seat needs its own input devices (keyboard and mouse). A USB hub can be used to connect multiple input devices.
This will make device management easier, as the hub can be assigned to a seat instead of individual devices.

Optionally, each seat can have its own audio device, such as a sound card or USB audio interface.

## Configuration

Historically, setting up a multiseat system involved writing udev rules and specialized X configurations. With
systemd-logind, the process is relatively straightforward.

Configuring multiseat is a two-step process: first, a set of devices (gpu, keyboard, mouse) needs to be assigned to each
new seat via `{{ic|loginctl attach}}`{=mediawiki}. Then a multiseat-capable display manager needs to be enabled via
`{{ic|systemctl enable}}`{=mediawiki}.

### Device assignment {#device_assignment}

Devices can be assigned to seats with

```{=mediawiki}
{{bc|# loginctl attach seat1 /sys/path/to/device}}
```
The tricky part is identifying the correct device paths - this will be described in detail for the different device
types below.

Commonly, seats are named `{{ic|seat0}}`{=mediawiki}, `{{ic|seat1}}`{=mediawiki}, `{{ic|seat2}}`{=mediawiki}, etc., but
more general names of the form `{{ic|seat[a-zA-Z0-9_-]*}}`{=mediawiki} can be used. Every device not explicitly assigned
to another seat belongs to the default seat (`{{ic|seat0}}`{=mediawiki}). Logind writes persistent udev rules under
`{{ic|/etc/udev/rules.d/}}`{=mediawiki} so seat assignments will survive reboots.

#### Graphics devices {#graphics_devices}

List all graphics devices:

```{=mediawiki}
{{bc|$ ls -l /sys/class/drm/card*/device}}
```
Each symlink target contains the card\'s PCI address, which can be used to identify it. For example:

```{=mediawiki}
{{bc|/sys/class/drm/card0/device -> ../../../0000:09:00.0}}
```
Cross-reference the PCI address with the output of

```{=mediawiki}
{{bc|$ lspci -nnk {{!}}
```
grep -A 3 -E \"VGA{{!}}3D{{!}}Display\"}}

to find out which card it is. Example output:

```{=mediawiki}
{{bc|09:00.0 VGA compatible controller: Advanced Micro Devices ... Navi 22 ... Kernel driver in use: amdgpu}}
```
```{=mediawiki}
{{ic|Navi 22}}
```
is used in the AMD Radeon RX 6000 series. This card can be assigned to seat1 with:

```{=mediawiki}
{{bc|# loginctl attach seat1 /sys/class/drm/card0}}
```
#### Input devices {#input_devices}

List all devices currently attached to the default seat:

```{=mediawiki}
{{bc|$ loginctl seat-status seat0}}
```
Scan the list for devices you want to reassign. As an example, the following snippet shows a USB mouse on root hub
`{{ic|usb7}}`{=mediawiki}, downstream of port `{{ic|7-1}}`{=mediawiki}:

```{=mediawiki}
{{bc|
  └─/sys/devices/pci0000:00/0000:00:08.3/0000:15:00.0/usb7/7-1
    usb:7-1
    └─/sys/devices/pci0000:00/0000:00:08.3/0000:15:00.0/usb7/7-1/7-1.2
      usb:7-1.2
      └─.../input/input9 "USB Optical Mouse"
}}
```
To attach the root hub (and all its downstream devices), use the `{{ic|usb7}}`{=mediawiki} path:

```{=mediawiki}
{{bc|# loginctl attach seat1 /sys/devices/pci0000:00/0000:00:08.3/0000:15:00.0/usb7}}
```
To attach only the port that has the mouse attached, include the `{{ic|7-1}}`{=mediawiki} segment:

```{=mediawiki}
{{bc|# loginctl attach seat1 /sys/devices/pci0000:00/0000:00:08.3/0000:15:00.0/usb7/7-1}}
```
#### Verify seat assignments {#verify_seat_assignments}

After assigning devices to seats, verify the assignments with

```{=mediawiki}
{{bc|
$ loginctl list-seats
$ loginctl seat-status seat0
$ loginctl seat-status seat1
}}
```
This should show two seats, with `{{ic|seat1}}`{=mediawiki} having the assigned graphics and input devices, and
`{{ic|seat0}}`{=mediawiki} having the remaining devices.

### Display manager {#display_manager}

Few display managers handle multiseat reliably. If you run into trouble with your current display manager, it is worth
trying a different one.

-   [LightDM](LightDM "wikilink") has multiseat support.
-   [Atrium](Atrium "wikilink") is built specifically for multiseat on Wayland.

See [Display manager#Graphical](Display_manager#Graphical "wikilink") for a full list of available options.

To enable a new display manager after installing, first disable the current one, then enable the new one (replace
`{{ic|lightdm}}`{=mediawiki} with your choice):

```{=mediawiki}
{{bc|
# systemctl disable display-manager
# systemctl enable lightdm
}}
```
Then reboot. Each seat should now have its own independent login screen. After logging in, each seat will run an
independent user session.

## Reverting to a single-seat setup {#reverting_to_a_single_seat_setup}

Remove all device assignments (implicitly re-assigns each device to `{{ic|seat0}}`{=mediawiki}):

```{=mediawiki}
{{bc|# loginctl flush-devices}}
```
Switch back to your old display manager (replace `{{ic|gdm}}`{=mediawiki} with your previous display manager):

```{=mediawiki}
{{bc|
# systemctl disable display-manager
# systemctl enable gdm
}}
```
Then reboot.

## See also {#see_also}

-   [loginctl(1)](https://www.freedesktop.org/software/systemd/man/latest/loginctl.html)
-   [systemd Multi-Seat](https://www.freedesktop.org/wiki/Software/systemd/multiseat/)
-   [Debian Multi-Seat HOWTO](https://wiki.debian.org/Multi_Seat_Debian_HOWTO) (mostly covers legacy X11 setups, but the
    \"Loginctl\" section is applicable)
-   [atrium multiseat setup guide](https://github.com/kavau/atrium/blob/main/doc/multiseat-setup.md) (most of the
    content is applicable to other display managers as well)

[Category:Display managers](Category:Display_managers "wikilink") [Category:Graphics](Category:Graphics "wikilink")
[Category:Wayland](Category:Wayland "wikilink") [Category:X server](Category:X_server "wikilink")

The **SoundBlasterX G6** is a Digital-to-Analog Converter (DAC) marketed for gaming audio. Creative Labs themselves
don\'t support Linux. DACs in generally are supported by the Kernel and projects like
[soundblaster-x-g6-cli](https://github.com/nils-skowasch/soundblaster-x-g6-cli) reverse engineered many of its features.

## Installing

The following commands can be used to identify the device:

```{=mediawiki}
{{hc|# dmesg|usb 3-8: Product: Sound BlasterX G6
usb 3-8: Manufacturer: Creative Technology Ltd}}
```
```{=mediawiki}
{{hc|$ lsusb|Bus 003 Device 011: ID 041e:3256 Creative Technology, Ltd Sound BlasterX G6}}
```
To [allow regular users access to the device](Udev#Allowing_regular_users_to_use_devices "wikilink") add a rule:

```{=mediawiki}
{{hc|/etc/udev/rules.d/50-soundblaster-x-g6.rules|2=
SUBSYSTEM=="usb", ATTRS{idVendor}=="041e", ATTRS{idProduct}=="3256", TAG+="uaccess"}}
```
The package `{{aur|linuxblaster-control}}`{=mediawiki} integrates one.

## Troubleshooting

### Microphone muted {#microphone_muted}

[Unmute the channels in ALSA](Advanced_Linux_Sound_Architecture#Unmuting_the_channels "wikilink"): `External Mic`. You
may also want to mute all the others to avoid cross-talk or hearing yourself. `{{aur|linuxblaster-control}}`{=mediawiki}
comes with a
[script](https://github.com/RizeCrime/linuxblaster_control/blob/master/alsa-fix/soundblasterx-g6-alsa-fix.sh) that
automates this as the workaround has to be applied on every restart.

[Category:Sound](Category:Sound "wikilink") [Category:Gaming](Category:Gaming "wikilink")

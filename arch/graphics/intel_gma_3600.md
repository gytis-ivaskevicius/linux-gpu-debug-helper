[ja:Intel GMA 3600](ja:Intel_GMA_3600 "wikilink") [zh-hans:Intel GMA 3600](zh-hans:Intel_GMA_3600 "wikilink")
`{{Related articles start}}`{=mediawiki} `{{Related|Intel graphics}}`{=mediawiki} `{{Related|Xorg}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

The **Intel GMA 3600** series is a family of integrated video adapters based on the PowerVR SGX 545 graphics core. It is
used in [Intel
Cedarview](https://ark.intel.com/content/www/us/en/ark/products/codename/37505/products-formerly-cedarview.html) CPUs
(Atom D2500, D2550, D2700, N2600 and N2800).

The Linux kernel has support since version 3.5, but since version 4.15 the relevant kernel driver, uvesafb, has not been
included in the kernel so using the [DKMS](DKMS "wikilink") version of the driver is necessary. See
[uvesafb](uvesafb "wikilink") for more information.

## Xorg driver {#xorg_driver}

At the moment there is no accelerated driver for Xorg, but some support is available using the Xorg modesetting driver
provided by package `{{Pkg|xorg-server}}`{=mediawiki}.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-gpudriver.conf|
Section "Device"
    Identifier "Intel GMA3600"
    Driver     "modesetting"
EndSection
}}
```
The modesetting driver allows disabling/enabling LVDS, VGA, etc. ports and changing resolution using xrandr.

The following can be used to disable LVDS and force enable VGA if needed.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/20-gpudriver.conf|
Section "Device"
    Identifier "Intel GMA3600"
    Driver     "modesetting"
    Option     "Monitor-LVDS-0" "Ignore"
    Option     "Monitor-VGA-0" "Monitor"
EndSection

Section "Monitor"
    Identifier "Ignore"
    Option     "Ignore"
EndSection

Section "Monitor"
    Identifier "Monitor"
    Option     "Enable"
EndSection
}}
```
## Troubleshooting

### Blank screen after resume {#blank_screen_after_resume}

If the device gets a blank screen after resuming:

`# touch /etc/pm/sleep.d/99video`

### Playing video {#playing_video}

It is unable to utilize whole chip power and play full HD videos using graphics acceleration. As workaround you could
utilize the maximum power of your Atom CPU to decode video:

`$ mplayer -lavdopts threads=4 -fs myvideo.avi`

`$ mpv --vd-lavc-threads=4 -fs myvideo.avi`

## See also {#see_also}

-   <https://www.change.org/en-GB/petitions/intel-listen-to-the-community-and-develop-gma3600-drivers-for-linux>
-   <https://ubuntuforums.org/showthread.php?t=1953734>
-   <https://community.intel.com/t5/Graphics/GMA-3650-aka-PowerVR-sgx545-and-Linux/m-p/247587>
-   <https://bbs.archlinux.org/viewtopic.php?id=144445>

[Category:Graphics](Category:Graphics "wikilink") [Category:X server](Category:X_server "wikilink")

[ja:Via](ja:Via "ja:Via"){.wikilink} The proprietary VIA drivers (*xf86-video-via*) are not available since 2008 as they
are considered unstable and insecure. The unmaintained *xf86-video-unichrome* driver is not packaged since 2012 either.

## Installation

To get the OpenChrome driver, [install](install "install"){.wikilink} the `{{AUR|xf86-video-openchrome}}`{=mediawiki}
package.

The `{{ic|xorg.conf}}`{=mediawiki} driver name is `{{ic|openchrome}}`{=mediawiki}.

## Troubleshooting

To enable any of the following options to fix issues, first create a new file `{{ic|10-openchrome.conf}}`{=mediawiki} in
`{{ic|/etc/X11/xorg.conf.d/}}`{=mediawiki}:

`Section "Device"`\
`    Identifier "`*`My Device Name`*`"`\
`    Driver "openchrome"`\
`EndSection`

### Artifacts

If your X Server shows artifacts and fails to redraw some windows, try disabling the `{{ic|EnableAGPDMA}}`{=mediawiki}
option:

`Option     "EnableAGPDMA"               "false"`

If your machine freeze at startup ([GDM](GDM "GDM"){.wikilink}) or after login ([SLiM](SLiM "SLiM"){.wikilink}), try
adding the XAA option `{{ic|XaaNoImageWriteRect}}`{=mediawiki}. Note that this only applies if you are using the XAA
acceleration method (configured by the `{{ic|AccelMethod}}`{=mediawiki} option). Since 0.2.906, the default acceleration
method is EXA.

`Option "XaaNoImageWriteRect"`

If you experience significant CPU usage and low UI framerate, try adding:

`Option "AccelMethod" "XAA"`

### Black screen when booting from LiveCD {#black_screen_when_booting_from_livecd}

If you experience a black screen when booting from Live-CD, add `{{ic|1=modprobe.blacklist=viafb}}`{=mediawiki} on the
[kernel command line](kernel_command_line "kernel command line"){.wikilink}.

```{=mediawiki}
{{Note|The {{ic|nomodeset}} option will probably not work here.}}
```
After installing the system you will need to [blacklist](blacklist "blacklist"){.wikilink} the
`{{ic|viafb}}`{=mediawiki} module.

### DPMS problems {#dpms_problems}

If you experience problems with DPMS not turning off laptop\'s backlight, try adding:

`Option "VBEModes" "true"`

to the device section of `{{ic|xorg.conf}}`{=mediawiki}.

### Hangup on exit {#hangup_on_exit}

If your computer crashes when closing X, you may try not using the vesa driver for the kernel console. Just delete the
vga-related parameters from the [kernel command line](kernel_command_line "kernel command line"){.wikilink}.

## See also {#see_also}

- [OpenChrome-project](https://www.freedesktop.org/wiki/Openchrome/)

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink} [Category:X
server](Category:X_server "Category:X server"){.wikilink}

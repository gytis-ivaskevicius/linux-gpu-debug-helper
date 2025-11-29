[ja:Uvesafb](ja:Uvesafb "ja:Uvesafb"){.wikilink} [zh-hans:Uvesafb](zh-hans:Uvesafb "zh-hans:Uvesafb"){.wikilink}
`{{Related articles start}}`{=mediawiki} `{{Related|Kernel modules}}`{=mediawiki}
`{{Related|Kernel parameters}}`{=mediawiki} `{{Related|sysctl}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}
`{{Style|Many [[Help:Style]] issues}}`{=mediawiki}
`{{Expansion|Since this is the redirect for [[framebuffer]], it should mention what a framebuffer is, what it does, why we care, etc.}}`{=mediawiki}
In contrast with other framebuffer drivers, uvesafb needs a userspace virtualizing daemon, called
`{{AUR|v86d}}`{=mediawiki}. It may seem foolish to emulate x86 code on a x86, but this is important if one wants to use
the framebuffer code on other architectures (notably non-x86 ones). It was added in kernel 2.6.24 and has many more
features than the standard vesafb, including:

1.  Proper blanking and hardware suspension after delay
2.  Support for custom resolutions as in the system BIOS.

It should support as much hardware as vesafb.

## Installation

[Install](Install "Install"){.wikilink} the `{{aur|uvesafb-dkms}}`{=mediawiki} package.

## Configuration

Remove any framebuffer-related [kernel parameter](kernel_parameter "kernel parameter"){.wikilink} from the [boot
loader](boot_loader "boot loader"){.wikilink} configuration to disable the old vesafb framebuffer from loading. The
following commands should return no result:

`$ grep vga /proc/cmdline`\
`$ grep -ir vga /etc/modprobe.d/`

If you do have a `{{ic|1=vga=}}`{=mediawiki} option somewhere, you will need to remove it.

### mkinitcpio hook {#mkinitcpio_hook}

Add the v86d hook to HOOKS in `{{ic|/etc/mkinitcpio.conf}}`{=mediawiki}. This allows uvesafb to take over at boot time.

`HOOKS=(base udev v86d ...)`

### Define a resolution {#define_a_resolution}

The settings for uvesafb are defined in `{{ic|/usr/lib/modprobe.d/uvesafb.conf}}`{=mediawiki}.

Documentation for `{{ic|mode_option}}`{=mediawiki} can be found at [1](https://docs.kernel.org/fb/modedb.html).

To prevent your customizations being overwritten when the package is updated, copy this file to
`{{ic|/etc/modprobe.d/uvesafb.conf}}`{=mediawiki}:

`# cp /usr/lib/modprobe.d/uvesafb.conf /etc/modprobe.d/uvesafb.conf`

and then make sure `{{ic|/etc/mkinitcpio.conf}}`{=mediawiki} includes `{{ic|modconf}}`{=mediawiki} in the
`{{ic|HOOKS}}`{=mediawiki} array.

To make changes take effect, [regenerate the initramfs](regenerate_the_initramfs "regenerate the initramfs"){.wikilink}
and reboot the system.

### Optimizing resolution {#optimizing_resolution}

A list of possible resolutions can be generated via the following command:

`$ cat /sys/bus/platform/drivers/uvesafb/uvesafb.0/vbe_modes`

Users can then modify `{{ic|/usr/lib/modprobe.d/uvesafb.conf}}`{=mediawiki} with any entry returned above.

### Checking current resolution {#checking_current_resolution}

Either of following commands can be used to show the current framebuffer resolution as a sanity check to see that
settings are honored:

`$ cat /sys/devices/virtual/graphics/fbcon/subsystem/fb0/virtual_size`

`$ cat /sys/class/graphics/fb0/virtual_size`

## Kernel module parameters {#kernel_module_parameters}

If you compile your own kernel then you can also compile uvesafb into the kernel and run v86d later. In this case, the
options can be passed as [kernel parameters](kernel_parameters "kernel parameters"){.wikilink} in the format
`{{ic|1=video=uvesafb:''options''}}`{=mediawiki}.

## Troubleshooting

### Uvesafb cannot reserve memory {#uvesafb_cannot_reserve_memory}

Check if you forgot to remove any `{{ic|1=vga=}}`{=mediawiki} kernel parameter − this overrides the UVESA framebuffer
with a standard VESA one.

Try to add `{{ic|1=video=vesa:off vga=normal}}`{=mediawiki} to the [kernel command
line](kernel_command_line "kernel command line"){.wikilink}.

## See also {#see_also}

- [Uvesafb Kernel Page](https://docs.kernel.org/fb/uvesafb.html)
- [Gentoos uvesafb Page](https://web.archive.org/web/20121118062504/http://dev.gentoo.org/~spock/projects/uvesafb/)
- [VESA mode numbers](wikipedia:VESA_BIOS_Extensions#VBE_mode_numbers "VESA mode numbers"){.wikilink}

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink} [Category:Eye
candy](Category:Eye_candy "Category:Eye candy"){.wikilink}

`{{Out of date|Page has seen its last content updates in 2013. While it was reported working in 2016, see talk page, some tools have been discontinued since then and whether this guide still works is questionable.}}`{=mediawiki}
Xbox 360 games come in two image formats: *.iso* and *.000*. They are burned on dual layer DVD+R discs. This requires a
dual-layer DVD burner. No specific brand or burner is needed for XGD1- or XGD2-formatted games, but XGD3-formatted games
require a LiteOn drive with either flashed iHAS firmware or the BurnerMAX payload to burn successfully and reliably. In
order to maximize the success of your burn, you should verify your disc images with
[abgx360](https://bakasurarce.github.io/abgx360/) and burn at the slowest speed your burner and media allow. The
manufacturer of your discs is also important; Verbatim DVD+R DL discs are the most reliable.

```{=mediawiki}
{{Note|Games must be burned onto DVD+R DL (Dual Layered) discs, not DVD-R DL discs.}}
```
```{=mediawiki}
{{Warning|The legality of this process may be questionable. Refer to the copyright laws in your country for clarification. Playing backup games online may result in your Xbox 360 console being banned from Xbox Live. Follow this guide at your own risk!}}
```
```{=mediawiki}
{{Tip|Backups may only be played on an Xbox 360 with a flashed firmware.}}
```
## Burning ISOs {#burning_isos}

```{=mediawiki}
{{Note|You can use [[Wine#Burning optical media|Imgburn + Wine]] to burn ISOs (yes, XGD3 burns work with BurnerMAX drives, and since Imgburn 2.5.8 the builtin "BurnerMax Payload" feature works as well).}}
```
Burning an ISO is best done through the command line with *growisofs*. This is found in the
`{{Pkg|dvd+rw-tools}}`{=mediawiki} package.

There are other applications you can use to burn the image (`{{Pkg|k3b}}`{=mediawiki} etc) but you may miss some
configuration options and end up with a dud burn. Use the following commands to burn the image to disc.

XGD1 (Xbox1):

`# growisofs -use-the-force-luke=dao -use-the-force-luke=break:1913776 -dvd-compat -speed=2 -Z /dev/sr0=rom.iso`

XGD2:

`# growisofs -use-the-force-luke=dao -use-the-force-luke=break:1913760 -dvd-compat -speed=2 -Z /dev/sr0=rom.iso`

XGD3 (iXtreme Burner Max Firmware):
`{{Note|This method requires a compatible LiteOn drive flashed with custom iHAS firmware. A list of compatible drives and XGD3-formatted games can be found [https://consolemods.org/wiki/Xbox_360:XGD3_Games here]. A Windows-based guide for flashing iHAS firmware can be found [https://www.jogimods.com/downloads/xbox360/burner_max_liteon_tutorial.pdf here]. Rebranded iHAS drives can be flashed with the appropriate firmware; check [https://web.archive.org/web/20130828102840/http://forums.xbox-scene.com/index.php?showtopic{{=}}`{=mediawiki}737081
here\] for a comparison and guide. Linux-based tools such as [binflash](https://github.com/Liggy/binflash) should also
be capable of flashing iHAS firmware, although this tool does not include a method for changing the EEPROM data on a
rebranded LiteOn drive after flashing iHAS firmware. In this scenario, using the Windows-based tools works best.}}

`# cdrecord -v speed=4 -force -sao -overburn driveropts=burnfree rom.iso`

This should determine the necessary layerbreak on its own.

XGD3 (truncated):
`{{Warning|This method is NOT recommended, as it will truncate (cut off) the last portion of the ISO to fit it on the disc with a standard burn, which may result in corrupted or unplayable games and WILL result in failed security checks.}}`{=mediawiki}

`$ truncate --size=8547991552 rom.iso`\
`# growisofs -use-the-force-luke=dao -use-the-force-luke=break:2086912 -dvd-compat -speed=2 -Z /dev/sr0=rom.iso`

Replace `{{ic|/dev/sr0}}`{=mediawiki} with the path to your dual layer drive. For most systems it will be
`{{ic|/dev/sr0}}`{=mediawiki}.

If everything has been set up correctly you should see a messages like this:

`Executing 'builtin_dd if=rom.iso of=/dev/sr0 obs=32k seek=0'`\
`/dev/sr0: splitting layers at 1913760 blocks`\
`/dev/sr0: "Current Write Speed" is 2.5x1352KBps.`\
`3538944/7835492352 ( 0.0%) @0.8x, remaining 45:39 RBU  89.7% UBU   7.1%`

The burn should take around approximately 40 minutes at 2.4x write speed, depending on the size of the iso.

## xbox360_burn

It is obviously possible to create an executable file containing the command to burn DVDs. Someone has created a bash
script to allow for a more user-friendly interface. [It has since been rewritten into
python](https://github.com/jawilson/dotfiles/blob/master/bin/xbox360_burn).

To burn, you then only have to use this command:

`# xbox360_burn -ib /dev/sr0 rom.iso`

Replace `{{ic|/dev/sr0}}`{=mediawiki} with the path to your dual layer drive. For most systems it will be
`{{ic|/dev/sr0}}`{=mediawiki}.

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

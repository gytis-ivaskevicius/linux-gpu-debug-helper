[ja:ビデオメモリにスワップ](ja:ビデオメモリにスワップ "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|Swap}}`{=mediawiki} `{{Related|Improving performance}}`{=mediawiki} `{{Related articles end}}`{=mediawiki} In
the unlikely case that you have very little RAM and a surplus of video RAM, you can use the latter as swap.

## MTD Kernel Subsystem {#mtd_kernel_subsystem}

### Potential benefits {#potential_benefits}

A graphics card with GDDR*X* SDRAM or DDR SDRAM may be used as swap by using the MTD subsystem of the kernel. Systems
with dedicated graphics memory of 256 MB or greater which also have limited amounts of system memory (DDR*X* SDRAM) may
benefit the most from this type of setup.

```{=mediawiki}
{{Warning|
* This will not work with binary drivers.
* Unless your graphics driver can be made to use less ram than is detected, Xorg may crash when you try to use the same section of RAM to store textures as swap. Using a video driver that allows you to override videoram should increase stability.}}
```
### Pre-setup {#pre_setup}

You have to load the modules specifying the PCI address ranges that correspond to the RAM on your video card.

To find the available memory ranges run the following command and look for the VGA compatible controller section (see
the example below).

```{=mediawiki}
{{hc|$ lspci -vvv|<nowiki>
01:00.0 VGA compatible controller: NVIDIA Corporation GK104 [GeForce GTX 670] (rev a1) (prog-if 00 [VGA controller])
    Subsystem: ASUSTeK Computer Inc. Device 8405
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 57
    Region 0: Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
    Region 1: Memory at e8000000 (64-bit, prefetchable) [size=128M]
    Region 3: Memory at f0000000 (64-bit, prefetchable) [size=32M]
    Region 5: I/O ports at e000 [size=128]
    [virtual] Expansion ROM at f6000000 [disabled] [size=512K]
    Capabilities: <access denied>
    Kernel driver in use: nvidia
    Kernel modules: nouveau, nvidia</nowiki>}}
```
```{=mediawiki}
{{Note|Systems with multiple GPUs will likely have multiple entries here.}}
```
Of most potential benefit is a region that is prefetchable, 64-bit, and the largest in size.
`{{Note|The graphics card used above has 2 GB of GDDR5 SDRAM, though as indicated above the full amount is not exposed or listed by the command provided above.}}`{=mediawiki}

A video card needs some of its memory to function, as such some calculations are needed. The offsets are easy to
calculate as powers of 2. The card should use the beginning of the address range as a framebuffer for textures and such.
However, if limited or as indicated in the beginning of this article, if two programs try to write to the same sectors,
stability issues are likely to occur.

As an example: For a total of 256 MB of graphics memory, the formula is 2\^28 (two to the twenty-eighth power).
Approximately 64 MB could be left for graphics memory and as such the start range for the swap usage of graphics memory
would be calculated with the formula 2\^26.

Using the numbers above, you can take the difference and determine a reasonable range for usage as swap memory. leaving
2\^24 (32M) for the normal function (less will work fine)

### Setup

Configure the phram module (3.x kernels used the slram module): `{{hc|/etc/modprobe.d/modprobe.conf|<nowiki>
options phram phram=VRAM,0xStartRange,0xUsedAmount</nowiki>}}`{=mediawiki}

Load the modules on boot: `{{hc|/etc/modules-load.d/vramswap.conf|<nowiki>
phram
mtdblock
</nowiki>}}`{=mediawiki}

Create a systemd service: `{{hc|/usr/lib/systemd/system/vramswap.service|<nowiki>
[Unit]
Description=Swap on Video RAM

[Service]
Type=oneshot
ExecStart=/usr/bin/mkswap /dev/mtdblock0
ExecStart=/usr/bin/swapon /dev/mtdblock0 -p 10
ExecStop=/usr/bin/swapoff /dev/mtdblock0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
</nowiki>}}`{=mediawiki}

```{=mediawiki}
{{Tip|If your computer has multiple {{ic|mtdblock}} devices, use {{ic|cat /proc/mtd}} to find the {{ic|mtdblock}} with name VRAM.}}
```
#### Xorg driver config {#xorg_driver_config}

To keep X stable, your video driver needs to be told to use less than the detected videoram.

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/vramswap.conf|
Section "Device"
    Driver "radeon" # or whichever other driver you use
    VideoRam 32768
    #other stuff
EndSection}}
```
The above example specifies that you use 32 MB of graphics memory.

```{=mediawiki}
{{Note|Some drivers might take the number for videoram as being in MiB. See relevant manpages.}}
```
### Troubleshooting

The following command may help you getting the used swap in the different spaces like disk partitions, flash disks and
possibly this example of the swap on video ram

```{=mediawiki}
{{bc|swapon -s}}
```
### See also {#see_also}

-   [MTD website](http://www.linux-mtd.infradead.org)

## FUSE filesystem {#fuse_filesystem}

```{=mediawiki}
{{Warning|Multiple users have reported this to cause system [https://github.com/Overv/vramfs/issues/3 freezes], even with the fix in [[#Complete system freeze under high memory pressure]]. Other GPU management processes or libraries may be swapped out, leading to nonrecoverable page faults.}}
```
This method works on hardware with OpenCL support using a [FUSE](FUSE "wikilink") filesystem backing a swapfile. See
[General-purpose computing on graphics processing
units](General-purpose_computing_on_graphics_processing_units "wikilink") for more information.

### Setup {#setup_1}

First, install `{{AUR|vramfs-git}}`{=mediawiki}. Then, create an empty directory as mount point (e.g
`{{ic|/tmp/vram}}`{=mediawiki}).

Now run the following commands to set up the *vramfs* and a swapfile.

`# vramfs /tmp/vram 256MB -f # Substitute 256M with your target vramfs size`\
`# mkswap -U clear --size 200M --file /tmp/vram/swapfile # Substitute 200 with your target swapspace size in MiB`

Your [Swap](Swap "wikilink") should now be ready. Run `{{ic|swapon}}`{=mediawiki} to check.

See [Swap#Swap file](Swap#Swap_file "wikilink") for more information.

```{=mediawiki}
{{Note| This is not persistent and will be gone after a system reboot.}}
```
```{=mediawiki}
{{Tip| You can also use {{ic|/tmp/vram}} as temporary storage, much like a [[Tmpfs]].}}
```
### Setting swappiness {#setting_swappiness}

```{=mediawiki}
{{Note|The following advice may not apply to your use case. You should always do the required due diligence and check how it applies to your particular configuration.}}
```
In the case of swap on VRAM, increasing swappiness *may* be a good idea. This is especially true when random I/O for the
VRAM swapfile is significantly faster than random disk I/O, as the benefit of caching disk reads will outweigh the cost
of swapping. For example, if your random disk I/O speed is the same as VRAM swap I/O, you should set swappiness to 100.
If VRAM swap I/O is 2x faster than disk I/O, you should set swappiness to 133. See [the kernel
documentation](https://docs.kernel.org/admin-guide/sysctl/vm.html?highlight=swappiness#swappiness) for how to calculate
the swappiness value correctly.

### Troubleshooting {#troubleshooting_1}

#### swapon: /tmp/vram/swapfile: skipping - it appears to have holes. {#swapon_tmpvramswapfile_skipping___it_appears_to_have_holes.}

The swapfile created is not contiguous. A loop device can be set up to work around this issue.

`# cd /tmp/vram`\
`# LOOPDEV=$(losetup -f)`\
`# truncate -s 4G swapfile # replace 4G with target swapspace size, has to be smaller than the allocated vramfs`\
`# losetup $LOOPDEV swapfile`\
`# mkswap $LOOPDEV`\
`# swapon $LOOPDEV`

#### Complete system freeze under high memory pressure {#complete_system_freeze_under_high_memory_pressure}

Sometimes, under very high memory pressure, the `{{ic|vramfs}}`{=mediawiki} process itself may get swapped to the VRAM
swap space. This causes a complete deadlock. A fix is to make the process unswappable via cgroups by launching it via a
systemd file:

```{=mediawiki}
{{hc|/etc/systemd/system/vramswap.service|<nowiki>
[Unit]
Description=Set up swap in VRAM
After=default.target

[Service]
Type=oneshot
RemainAfterExit=yes
# Change /root/vramswap.sh to a path to a script that performs all the necessary setup
ExecStart=/root/vramswap.sh
TimeoutStartSec=0
# Prevent swapping
MemorySwapMax=0

[Install]
WantedBy=default.target
</nowiki>}}
```
### See also {#see_also_1}

-   [*vramfs* Github Repository](https://github.com/Overv/vramfs)

[Category:Graphics](Category:Graphics "wikilink")

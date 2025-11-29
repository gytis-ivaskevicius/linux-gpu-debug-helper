Intel GVT-g is a technology that allows to \"slice\" an Intel GPU into virtualized GPUs that can be then passed into
virtual machines.

Note that Intel GVT-g only supports Intel Broadwell (5th gen) to Comet Lake (10th gen), where in 10th gen support for
IVGT-g was removed. For 11th gen, and 12th gen, there is SR-IOV coming up for virtualized GPUs, but that did not yet
arrive in Linux mainline.

## Configuring GPU {#configuring_gpu}

First, enable iGVT-g with:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
virtualisation.kvmgt.enable = true;
</nowiki>}}
```
\... then rebuild and reboot.

After rebooting, check if the driver was successfully loaded:

` $ ls /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/`

\... if you get `No such file or directory`, it means you might be using an older CPU that needs an extra configuration
option:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
boot.extraModprobeConfig = "options i915 enable_guc=2";
</nowiki>}}
```
\... then rebuild and reboot once again (unless that previous `ls` succeeded, in which case you don\'t have to modify
that `extraModprobeConfig` at all).

Now, using `ls` you can list which variants your Intel GPU is able to virtualise:

` $ ls /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/`\
` i915-GVTg_V5_4/  i915-GVTg_V5_8/`

E.g.:

` $ cat /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_8/description `\
` low_gm_size: 64MB`\
` high_gm_size: 384MB`\
` fence: 4`\
` resolution: 1024x768`\
` weight: 2`

Find some variant that matches your expectations (resolution, memory size etc.), note down its name, generate a random
UUID:

` # If you're using Nix Flakes:`\
` $ nix shell nixpkgs#libossp_uuid -c uuid`\
` a297db4a-f4c2-11e6-90f6-d3b88d6c9525`

` # If you're not using Nix Flakes:`\
` $ nix run nixpkgs.libossp_uuid -c uuid`\
` a297db4a-f4c2-11e6-90f6-d3b88d6c9525`

\... and add that variant\'s name into your configuration:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
virtualisation.kvmgt.enable = true; 
virtualisation.kvmgt.vgpus = {
  "i915-GVTg_V5_8" = {
    uuid = [ "a297db4a-f4c2-11e6-90f6-d3b88d6c9525" ];
  };
};

environment.systemPackages = with pkgs; [
  virtmanager
];

virtualisation.libvirtd.enable = true;
users.extraUsers.user.extraGroups = [ "libvirtd" ];
</nowiki>}}
```
Rebuild & voilá - your virtualized GPU is ready; now you just have to attach it to some virtual machine.

## Attaching GPU {#attaching_gpu}

### Bare Qemu {#bare_qemu}

` qemu-system-x86_64 \`\
`    -enable-kvm \`\
`    -m 1G \`\
`    -nodefaults \`\
`    -display gtk,gl=on \`\
`    -device vfio-pci,sysfsdev=/sys/bus/mdev/devices/`**`a297db4a-f4c2-11e6-90f6-d3b88d6c9525`**`,display=on,x-igd-opregion=on,driver=vfio-pci-nohotplug,ramfb=on,xres=1920,yres=1080`

### libvirt

If using virt-manager, create new or open existing VM. Change existing `<graphics>`{=html} and `<code>`{=html}

```{=html}
<video>
```
`</code>`{=html} sections.

sudo -E virsh edit win10

``` xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <devices>
    <graphics type='spice'>
      <listen type='none'/>
      <gl enable='yes'/>
    </graphics>
    <video>
      <model type='none'/>
    </video>
    <hostdev mode='subsystem' type='mdev' managed='no' model='vfio-pci' display='on'>
      <source>
        <address uuid='a297db4a-f4c2-11e6-90f6-d3b88d6c9525'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x09' function='0x0'/>
    </hostdev>
  </devices>
  <qemu:commandline>
    <qemu:arg value='-set'/>
    <qemu:arg value='device.hostdev0.x-igd-opregion=on'/>
    <qemu:arg value='-set'/>
    <qemu:arg value='device.hostdev0.ramfb=on'/>
    <qemu:arg value='-set'/>
    <qemu:arg value='device.hostdev0.driver=vfio-pci-nohotplug'/>
    <qemu:arg value='-set'/>
    <qemu:arg value='device.hostdev0.xres=1920'/>
    <qemu:arg value='-set'/>
    <qemu:arg value='device.hostdev0.yres=1080'/>
    <qemu:env name="MESA_LOADER_DRIVER_OVERRIDE" value="i965"/>
  </qemu:commandline>
</domain>
```

## FAQ

-   No video output

```{=html}
<!-- -->
```
-   -   use BIOS (SeaBIOS) machine, EFI (OVMF) is not supported. You may use the following workarounds
        <https://wiki.archlinux.org/index.php/Intel_GVT-g#Using_DMA-BUF_with_UEFI/OVMF>

```{=html}
<!-- -->
```
-   -   ensure that the recent Intel graphics driver is installed in the guest

```{=html}
<!-- -->
```
-   (libvirtd) \"Element domain has extra content: qemu:commandline\" error after editing via virsh

```{=html}
<!-- -->
```
-   -   you forgot to add xmlns:qemu=\'http://libvirt.org/schemas/domain/qemu/1.0\'

```{=html}
<!-- -->
```
-   (libvirtd) \"no drm render node available\" error in virt-manager

```{=html}
<!-- -->
```
-   -   in virt-manager change SPICE display render node from auto to available one

```{=html}
<!-- -->
```
-   \"write_loop: No space left on device\" error when creating mdev device

```{=html}
<!-- -->
```
-   -   check whether available instances are left

` $ cat /sys/bus/pci/devices/0000\:00\:02.0/mdev_supported_types/i915-GVTg_V5_4/available_instances `\
` 1`

also check dmesg output for gvt related error, most likely there is not enough VRAM

-   (libvirtd) VM stops immediately with no error other than \"internal error: process exited while connecting to
    monitor\"

```{=html}
<!-- -->
```
-   -   qemu might be exiting due to SIGSYS, which may be related to this bug:
        <https://github.com/intel/gvt-linux/issues/47>

Try disabling seccomp sandboxing in qemu like so:

``` nix
  virtualisation.libvirtd = {
    qemuVerbatimConfig = ''
      seccomp_sandbox = 0
    '';
  };
```

## Useful sources {#useful_sources}

-   <https://www.kraxel.org/blog/2019/02/ramfb-display-in-qemu/> - Info about ramfb parameter
-   <https://lists.01.org/hyperkitty/list/igvt-g@lists.01.org/thread/LAB74CANVVRKGPBJMHULMMUFX43LRH55/> - Info about
    x-igd-opregion parameter
-   <https://www.kraxel.org/blog/2019/03/edid-support-for-qemu/> - Info about xres and yres parameters

[Category:Video](Category:Video "wikilink") [Category:Virtualization](Category:Virtualization "wikilink")

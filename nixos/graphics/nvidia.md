This page attempts to cover everything related to the use of NVIDIA GPUs on NixOS.

## Enabling

### Kernel modules from NVIDIA {#kernel_modules_from_nvidia}

Kernel modules from NVIDIA offer better performance than other alternatives, but make the system unfree by requiring
proprietary userspace libraries that can interface with the kernel modules. Users that want to have a fully free and
open-source system should use [Nouveau](NVIDIA#Nouveau "Nouveau"){.wikilink} instead.

To enable them, add `"nvidia"` to the list of enabled video drivers defined by the `services.xserver.videoDrivers`
option.

```{=mediawiki}
{{Note|<code>hardware.graphics.enable</code> was named <code>hardware.opengl.enable</code> '''until NixOS 24.11'''.}}
```
```{=mediawiki}
{{Note|Since driver version 560, you also will need to decide whether to use the open-source or proprietary modules by setting the <code>hardware.nvidia.open</code> option to either <code>true</code> or <code>false</code> respectively.<br><br>Open-source kernel modules are preferred over and planned to steadily replace proprietary modules<ref>https://developer.nvidia.com/blog/nvidia-transitions-fully-towards-open-source-gpu-kernel-modules/</ref>, although they only support GPUs of the Turing architecture or newer (from GeForce RTX 20 series and GeForce GTX 16 series onwards). Data center GPUs starting from Grace Hopper or Blackwall must use open-source modules — proprietary modules are no longer supported.<br><br>Make sure to allow [[Unfree software|unfree software]] even when using the open module as the user space part of the driver is still proprietary. Other unfree NVIDIA packages include <code>nvidia-x11</code>, <code>nvidia-settings</code>, and <code>nvidia-persistenced</code>.
}}
```
```{=mediawiki}
{{Warning|If you use a laptop with both dedicated and integrated GPUs, remember to [[#Hybrid_graphics_with_PRIME|configure PRIME]] in order to make your dedicated NVIDIA GPU work properly with your integrated GPU. Your configuration '''might not work''' if you skip this step.}}
```
```{=mediawiki}
{{file|configuration.nix|nix|<nowiki>
{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;  # see the note above
}
</nowiki>}}
```
#### Legacy branches {#legacy_branches}

GPUs of the Kepler architecture or older (most GeForce 600/700/800M cards and older) are no longer supported by latest
proprietary modules. Instead, users of these GPUs must use legacy branches that may still receive updates, as long as
the GPUs themselves remain supported by NVIDIA. You can find which legacy branch you need to use by searching for your
GPU model on [NVIDIA\'s official legacy driver support list](https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/).

To use legacy branches, you need to set the `hardware.nvidia.package` option to a package set named
`config.boot.kernelPackages.nvidiaPackages.legacy_``<branch>`{=html}.`{{file|configuration.nix|nix|<nowiki>
{ config, ... }: # ← Required to get the packages used by the currently configured kernel, including drivers
{ 
  # Last version that supports Kepler GPUs
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
}
</nowiki>}}`{=mediawiki}Nixpkgs does not endeavor to support all legacy branches since older, unmaintained legacy
branches can become incompatible with newer kernel and X server versions, and at some point it becomes infeasible to
patch them to cooperate with modern software. You can find the list of supported legacy branches under [in the Nixpkgs
repository](https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix).

#### Beta/production branches {#betaproduction_branches}

By default, modules from the stable branch are used, which come from latest release available for the current
architecture --- while x86-64 and aarch64 systems follow the \"New Feature Branch\" releases as they remain actively
developed, 32-bit x86 and ARM systems remain on the 390.xx branch as that is the last branch with 32-bit support.

Instead of the stable branch, users can also switch to the beta branch, which has more new features and experimental
changes at the risk of containing more bugs, or the production branch, a more conservative, well-tested stable version
that is suitable for production use with minimum breakage, at the cost of being behind in terms of new features.

Using the beta and production branches are similar to how one would use legacy
branches:`{{file|configuration.nix|nix|<nowiki>
{ config, ... }:
{ 
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; # Default
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
}
</nowiki>}}`{=mediawiki}

### Nouveau

Nouveau is a set of free and open-source drivers for NVIDIA GPUs that provide 2D/3D acceleration for all NVIDIA GPUs.
Its use is in general not recommended due to its considerably worse performance compared to NVIDIA\'s kernel modules, as
it does not support reclocking (changing the GPU clock frequency on-demand) for many NVIDIA GPUs[^1]. Nevertheless it
remains a viable option for users who want a fully free and open-source operating system as it does not contain any
proprietary components, unlike NVIDIA\'s kernel modules and userspace libraries.

Nouveau is enabled by default whenever graphics are enabled, and does not need any extra
configuration.`{{file|configuration.nix|nix|<nowiki>
{
  hardware.graphics.enable = true;
}
</nowiki>}}`{=mediawiki}

## Configuring

### Power management {#power_management}

### Hybrid graphics with PRIME {#hybrid_graphics_with_prime}

Laptops often feature both an integrated GPU (iGPU) and a dedicated GPU (dGPU) in order to strive a balance between
performance and power consumption ­--- while the dGPU is used for performance-intensive tasks such as gaming, video
editing, 3D rendering, compute jobs, etc., the iGPU can be used to render common 2D elements like application windows
and the desktop environment.

PRIME, therefore, is a technology developed to facilitate the cooperation between the two GPUs and is critical for the
laptop\'s graphical performance. Depending on your needs, you can configure PRIME in one of three modes, which have
different tradeoffs in terms of performance and battery life.

#### Common setup {#common_setup}

All PRIME configurations require setting the PCI bus IDs of the two GPUs. One easy way to do find their IDs is by
running `lspci` from the `pciutils` package, and then finding devices that are classified as VGA controllers. After
double checking that the listed devices are indeed your integrated and dedicated GPUs, you can then find the PCI IDs at
the beginning of each line. Exact results may vary, but an example output might look like:

``` console
$ nix shell nixpkgs#pciutils -c lspci -d ::03xx
0000:00:02.0 VGA compatible controller: Intel Corporation TigerLake-H GT1 [UHD Graphics] (rev 01)
0000:01:00.0 VGA compatible controller: NVIDIA Corporation GA106M [GeForce RTX 3060 Mobile / Max-Q] (rev a1)
```

Before putting them into your configuration, however, **they must first be reformatted** --- take the last three
numbers, convert them from hexadecimal to decimal, remove the leading zeroes, concatenate them with colons, and then add
a `PCI:` prefix. Then, they can be set under `intelBusId`, `nvidiaBusId`, or `amdgpuBusId` in `hardware.nvidia.prime`,
depending on the manufacturer of the GPU:`{{file|configuration.nix|nix|<nowiki>
{
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
  };
}
</nowiki>}}`{=mediawiki}

#### Offload mode {#offload_mode}

```{=mediawiki}
{{Note|Offload mode is available '''since NixOS 20.09 and NVIDIA driver version 435.21''', and requires an NVIDIA GPU of the Turing generation, or newer and a compatible CPU — either an Intel CPU from the Coffee Lake generation or newer, or an AMD Ryzen. Offload mode is '''incompatible''' with sync mode.}}
```
Offload mode puts your dGPU to sleep and lets the iGPU handle all tasks, except if you call the dGPU specifically by
\"offloading\" an application to it. For example, you can run your laptop normally and it will use the energy-efficient
iGPU all day, and then you can offload a game from Steam onto the dGPU to make the dGPU run that game only. For many,
this is the most desirable option.

To enable offload mode, set the `hardware.nvidia.prime.offload.enable` option to `true`:

```{=mediawiki}
{{file|configuration.nix|nix|<nowiki>
{
  # For offloading, `modesetting` is needed additionally,
  # otherwise the X-server will be running permanently on nvidia,
  # thus keeping the GPU always on (see `nvidia-smi`).
  services.xserver.videoDrivers = [
    "modesetting"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  hardware.nvidia.prime = {
    offload.enable = true;
    
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
  };
}
</nowiki>}}
```
When you want to run a program on the dGPU, you only need to set a few environment variables for the driver to recognize
that offload mode should be used. If `hardware.nvidia.prime.offload.enableOffloadCmd` is set to true, NixOS will
generate a wrapper script named `nvidia-offload` that sets the right variables for
you:`{{file|nvidia-offload|bash|<nowiki>
export __NV_PRIME_RENDER_OFFLOAD=1
export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
exec "$@"
</nowiki>}}`{=mediawiki}If everything is configured correctly, then running a program like `glxgears` should use the
iGPU, while running `nvidia-offload glxgears` should only use the dGPU.

#### Sync mode {#sync_mode}

```{=mediawiki}
{{Note|Sync mode is available '''since NixOS 19.03 and NVIDIA driver version 390.67''', and is '''incompatible''' with both offload and reverse sync modes. Sync mode also requires using a desktop manager that respects the <code>services.xserver.displayManager.setupCommands</code> option, including LightDM, GDM and SDDM.}}
```
In sync mode, rendering is completely delegated to the dGPU, while the iGPU only displays the rendered framebuffers
copied from the dGPU. Sync mode offers better performance and greatly reduces screen tearing, at the expense of higher
power consumption since the dGPU will not go to sleep when not needed, as is the case in offload mode. Sync mode may
also solve some issues with connecting a display in clamshell mode directly to the GPU.

To enable sync mode, set the `hardware.nvidia.prime.sync.enable` option to `true`:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.nvidia.prime = {
    sync.enable = true;
    
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
  };
}
</nowiki>}}
```
#### Reverse sync mode {#reverse_sync_mode}

```{=mediawiki}
{{Note|Reverse sync mode is available '''since NixOS 23.05 and NVIDIA driver version 460.39''' and is still an experimental, buggy feature<ref>https://forums.developer.nvidia.com/t/the-all-new-outputsink-feature-aka-reverse-prime/129828/67</ref>. '''Your mileage may vary.''' Reverse sync mode is '''incompatible''' with sync mode and requires using a desktop manager that respects the <code>services.xserver.displayManager.setupCommands</code> option, including LightDM, GDM and SDDM.}}
```
The difference between regular sync mode and reverse sync mode is that the **dGPU** is configured as the primary output
device, allowing displaying to external displays wired to it and not the iGPU (more common).

To enable reverse sync mode, set the `hardware.nvidia.prime.reverseSync.enable` option to `true`:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  hardware.nvidia.prime = {
    reverseSync.enable = true;

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
  };
}
</nowiki>}}
```
## Tips and tricks {#tips_and_tricks}

### Check nixos-hardware {#check_nixos_hardware}

The [nixos-hardware](https://github.com/NixOS/nixos-hardware) project attempts to provide configurations that address
specific hardware quirks for different devices. It is possible that someone already wrote a hardware configuration for
your device and that usually takes care of drivers. If so, follow the upstream documentation to enable the required
modules.

### Multiple boot configurations {#multiple_boot_configurations}

Imagine you have a laptop that you mostly use in clamshell mode (docked, connected to an external display and plugged
into a charger) but that you sometimes use on the go.

In clamshell mode, using PRIME Sync is likely to lead to better performance, external display support, etc., at the cost
of potentially (but not always) lower battery life. However, when using the laptop on the go, you may prefer to use
offload mode.

NixOS supports \"specialisations\", which allow you to automatically generate different boot profiles when rebuilding
your system. We can, for example, enable PRIME sync by default, but also create a \"on-the-go\" specialization that
disables PRIME sync and instead enables offload mode:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{
  specialisation.on-the-go.configuration = {
    system.nixos.tags = [ "on-the-go" ];
    hardware.nvidia.prime = {
      offload = {
        enable = lib.mkForce true;
        enableOffloadCmd = lib.mkForce true;
      };
      sync.enable = lib.mkForce false;    
    };
  };
}
</nowiki>}}
```
(You can also add other settings here totally unrelated to NVIDIA, such as power profiles, etc.)

After rebuilding and rebooting, you\'ll see in your boot menu under each Generation an \"on-the-go\" option, which will
let you boot into the on-to-go specialisation for that generation.

### Using GPUs on non-NixOS {#using_gpus_on_non_nixos}

If you\'re using Nix-packaged software on a non-NixOS system, you\'ll need a workaround to get everything
up-and-running. The [nixGL project](https://github.com/guibou/nixGL) provides wrapper to use GL drivers on non-NixOS
systems. You need to have GPU drivers installed on your distro (for kernel modules). With nixGL installed, you\'ll run
`nixGL foobar` instead of `foobar`.

Note that nixGL is not specific to NVIDIA GPUs, and should work with just about any GPU.

### CUDA and using your GPU for compute {#cuda_and_using_your_gpu_for_compute}

See the [CUDA](CUDA "CUDA"){.wikilink} wiki page.

### Running Specific NVIDIA Driver Versions {#running_specific_nvidia_driver_versions}

To run a specific version of the NVIDIA driver in NixOS, you can customize your configuration by specifying the desired
version along with the corresponding SHA256 hashes. Below is an example configuration for using NVIDIA driver version
`555.58.02`:

```{=mediawiki}
{{file|/etc/nixos/nvidia.nix|nix|<nowiki>
{ config, ... }:
{
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "555.58.02";
    sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
    sha256_aarch64 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
    openSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
    settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
    persistencedSha256 = lib.fakeSha256;
  };
};
</nowiki>}}
```
In this configuration:

- Replace `version` with the desired driver version.
- Update the SHA256 hashes to match the new version you want to use.
- After updating the configuration, run `sudo nixos-rebuild switch` to apply the changes and load the specified NVIDIA
  driver version.

This allows you to pin the specific driver version being used in your NixOS installation. You might want to do this if
you are running the newest kernel, as the packaged drivers may fail to build otherwise[^2].

## Troubleshooting

### Booting to text mode {#booting_to_text_mode}

If you encounter the problem of booting to text mode you might try adding the NVIDIA kernel module manually with:

``` nix
boot.initrd.kernelModules = [ "nvidia" ];
boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
```

### Screen tearing issues {#screen_tearing_issues}

First, try to switch to PRIME sync mode, as described above. If that doesn\'t work, try forcing a composition pipeline.

```{=mediawiki}
{{note|Forcing a full composition pipeline has been reported to reduce the performance of some OpenGL applications and may produce issues in WebGL. It also drastically increases the time the driver needs to clock down after load.}}
```
```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
hardware.nvidia.forceFullCompositionPipeline = true;
</nowiki>}}
```
### Flickering with Picom {#flickering_with_picom}

```{=mediawiki}
{{file|~/.config/picom/picom.conf|conf|<nowiki>
unredir-if-possible = false;
backend = "xrender"; # try "glx" if xrender doesn't help
vsync = true;
</nowiki>}}
```
### Graphical corruption and system crashes on suspend/resume {#graphical_corruption_and_system_crashes_on_suspendresume}

`powerManagement.enable = true` can sometimes fix this, but is itself unstable and is known to cause suspend issues.

`hardware.nvidia.powerManagement.enable = true` can also sometimes fix this issue; it is `false` by default.

If you have a modern NVIDIA GPU (Turing
[1](https://en.wikipedia.org/wiki/Turing_(microarchitecture)#Products_using_Turing) or later), you may also want to
investigate the `hardware.nvidia.powerManagement.finegrained` option:
[2](https://download.nvidia.com/XFree86/Linux-x86_64/460.73.01/README/dynamicpowermanagement.html)

[A potential fix](https://discourse.nixos.org/t/suspend-resume-cycling-on-system-resume/32322/12) that Interrupts the
gnome-shell in time so it's not trying to access the graphics hardware. [^3] The entire purpose is to manually \"pause\"
the GNOME Shell process just before the system sleeps and \"un-pause\" it just after the system wakes up.

### Black screen or \'nothing works\' on laptops {#black_screen_or_nothing_works_on_laptops}

The kernel module`i915`for Intel or`amdgpu`for AMD may interfere with the NVIDIA driver. This may result in a black
screen when switching to the virtual terminal, or when exiting the X session. A possible workaround is to disable the
integrated GPU by blacklisting the module, using the following configuration option (see also
[3](https://discourse.nixos.org/t/nvidia-gpu-and-i915-kernel-module/21307/3)):

``` nix
# intel
boot.kernelParams = [ "module_blacklist=i915" ];
# AMD
boot.kernelParams = [ "module_blacklist=amdgpu" ];
```

## Disabling

### Kernel modules from NVIDIA {#kernel_modules_from_nvidia_1}

Normally, NVIDIA\'s kernel modules should be completely disabled by removing `"nvidia"` from
`services.xserver.videoDrivers`. If that fails to work, you can also manually blacklist the corresponding kernel
modules:

``` nix
{ 
  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidiafb"
    "nvidia-drm"
    "nvidia-uvm"
    "nvidia-modeset"
  ];
}
```

### Nouveau {#nouveau_1}

Nouveau can be disabled by blacklisting the `nouveau` kernel module:

Note: This is done by default when using proprietary drivers

``` nix
{ 
  boot.blacklistedKernelModules = [ "nouveau" ];
}
```

Note that disabling both NVIDIA kernel modules and Nouveau effectively disables the GPU entirely.

## Footnotes

<references />

4\. <https://discourse.nixos.org/t/nvidia-open-breaks-hardware-acceleration/58770/1>

[Category:Video](Category:Video "Category:Video"){.wikilink}

[^1]: <https://www.phoronix.com/forums/forum/linux-graphics-x-org-drivers/open-source-nvidia-linux-nouveau/998310-nouveau-persevered-in-2017-for-open-source-nvidia-but-2018-could-be-much-better#post998316>

[^2]: <https://github.com/NixOS/nixpkgs/issues/429624#issuecomment-3189861599>

[^3]: <https://discourse.nixos.org/t/suspend-resume-cycling-on-system-resume/32322/12>

This guide is about setting up NixOS to correctly use your AMD Graphics card if it is relatively new (aka, after the GCN
architecture).

## Basic Setup {#basic_setup}

For ordinary desktop / gaming usage, AMD GPUs are expected to work out of the box. As with any desktop configuration
though, graphics acceleration does need to be enabled.

``` nix
hardware.graphics = {
  enable = true;
  enable32Bit = true;
};
```

There is also the [amdgpu nixos module available for common configuration
options](https://search.nixos.org/options?channel=unstable&query=hardware.amdgpu), such as enabling opencl, legacy
support, overdrive/overclocking and loading during initrd.

## Problems

### Low resolution during initramfs phase {#low_resolution_during_initramfs_phase}

If you encounter a low resolution output during early boot phases, you can load the amdgpu module in the initial ramdisk

``` nix
hardware.amdgpu.initrd.enable = true; # sets boot.initrd.kernelModules = ["amdgpu"];
```

### Dual Monitors {#dual_monitors}

If you encounter problems having multiple monitors connected to your GPU, adding \`video\` parameters for each connector
to the kernel command line sometimes helps.

For example:

``` nix
boot.kernelParams = [
  "video=DP-1:2560x1440@144"
  "video=DP-2:2560x1440@144"
];
```

With the connector names (like \`DP-1\`), the resolution and frame rate adjusted accordingly.

To figure out the connector names, execute the following command while your monitors are connected:

``` bash
head /sys/class/drm/*/status
```

### System Hang with Vega Graphics (and select GPUs) {#system_hang_with_vega_graphics_and_select_gpus}

Currently on the latest kernel/mesa (currently 6.13 and 24.3.4 respectively), Vega integrated graphics (and other GPUs
like the RX 6600[^1]) will have a possibility to hang due to context-switching between Graphics and Compute.[^2] There
are currently two sets of patches to choose between stability or speed that can be applied:
[amdgpu-stable](https://github.com/SeryogaBrigada/linux/commits/v6.13-amdgpu) and
[amdgpu-testing](https://github.com/SeryogaBrigada/linux/commits/v6.13-amdgpu-testing).

See [Linux Kernel#Patching a single In-tree kernel
module](Linux_Kernel#Patching_a_single_In-tree_kernel_module "Linux Kernel#Patching a single In-tree kernel module"){.wikilink},
keep in mind how to make [patch diffs from commits from GitHub](https://stackoverflow.com/a/23525893), and consider this
example configuration:

``` nix
{ config, pkgs, ... }:
let
  amdgpu-kernel-module = pkgs.callPackage ./packages/amdgpu-kernel-module.nix {
    # Make sure the module targets the same kernel as your system is using.
    kernel = config.boot.kernelPackages.kernel;
  };
  # linuxPackages_latest 6.13 (or linuxPackages_zen 6.13)
  amdgpu-stability-patch = pkgs.fetchpatch {
    name = "amdgpu-stability-patch";
    url = "https://github.com/torvalds/linux/compare/ffd294d346d185b70e28b1a28abe367bbfe53c04...SeryogaBrigada:linux:4c55a12d64d769f925ef049dd6a92166f7841453.diff";
    hash = "sha256-q/gWUPmKHFBHp7V15BW4ixfUn1kaeJhgDs0okeOGG9c=";
  };
  /*
  # linuxPackages_zen 6.12
  amdgpu-stability-patch = pkgs.fetchpatch {
    name = "amdgpu-stability-patch-zen";
    url = "https://github.com/zen-kernel/zen-kernel/compare/fd00d197bb0a82b25e28d26d4937f917969012aa...WhiteHusky:zen-kernel:f4c32ca166ad55d7e2bbf9adf121113500f3b42b.diff";
    hash = "sha256-bMT5OqBCyILwspWJyZk0j0c8gbxtcsEI53cQMbhbkL8=";
  };
  */
in
{
  # amdgpu instability with context switching between compute and graphics
  # https://bbs.archlinux.org/viewtopic.php?id=301798
  # side-effects: plymouth fails to show at boot, but does not interfere with booting
  boot.extraModulePackages = [
    (amdgpu-kernel-module.overrideAttrs (_: {
      patches = [
        amdgpu-stability-patch
      ];
    }))
  ];
}
```

### Sporadic Crashes {#sporadic_crashes}

If getting error messages in `dmesg` with `page fault` or `GCVM_L2_PROTECTION_FAULT_STATUS` it might be from AMD GPU
boosting too high without enough voltage

Use a tool like LACT to increase power usage limit to 15%, undervolt by moderate amount (e.g. -50mV for 7900 XTX) and
optionally decrease maximum GPU clock.

- <https://wiki.gentoo.org/wiki/AMDGPU#Frequent_and_Sporadic_Crashes>
- <https://gitlab.freedesktop.org/mesa/mesa/-/issues/11532>
- <https://gitlab.freedesktop.org/drm/amd/-/issues/3067>

## Special Configuration {#special_configuration}

The following configurations are only required if you have a specific reason for needing them. They are not expected to
be necessary for a typical desktop / gaming setup.

### Enable Southern Islands (SI) and Sea Islands (CIK) support (eg. HD 7000/8000) {#enable_southern_islands_si_and_sea_islands_cik_support_eg._hd_70008000}

The oldest architectures that AMDGPU supports are [Southern Islands (SI, i.e. GCN
1)](wikipedia:Radeon_HD_7000_series "Southern Islands (SI, i.e. GCN 1)"){.wikilink} and [Sea Islands (CIK, i.e. GCN
2)](wikipedia:Radeon_HD_8000_series "Sea Islands (CIK, i.e. GCN 2)"){.wikilink}, but support for them is disabled by
default. To use AMDGPU instead of the `radeon` driver, you can set the legacySupport option in the amdgpu module.

``` nix
hardware.amdgpu.legacySupport.enable = true;
```

This will set the kernel parameters as follows (this is redundant if you set the above option)

``` nix
boot.kernelParams = [
    # For Southern Islands (SI i.e. GCN 1) cards
    "amdgpu.si_support=1"
    "radeon.si_support=0"
    # For Sea Islands (CIK i.e. GCN 2) cards
    "amdgpu.cik_support=1"
    "radeon.cik_support=0"
];
```

Doing this is required to use [Vulkan](#Vulkan "Vulkan"){.wikilink} on these cards, as the `radeon` driver doesn\'t
support it.

Please note this also removes support for analog video outputs, which is only available with the `radeon` driver.

### HIP

Most software has the HIP libraries hard-coded. You can work around it on NixOS by using:

``` nix
  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];
```

#### Blender

Hardware accelerated rendering can be achieved by using the package

``` nix
blender-hip
```

.

Currently, you need to [use the latest kernel](Linux_kernel "use the latest kernel"){.wikilink} for

``` nix
blender-hip
```

to work.

### OpenCL

OpenCL support using the ROCM runtime library can be enabled via the amdgpu module.

``` nix
hardware.amdgpu.opencl.enable = true;
```

You should also install the `clinfo` package to verify that OpenCL is correctly setup (or check in the program you use
to see if it is now available, such as in Darktable).

#### Radeon 500 series (aka Polaris) {#radeon_500_series_aka_polaris}

As of [ROCm 4.5](https://github.com/ROCm/ROCm/issues/1659), AMD has disabled OpenCL on Polaris-based cards. This can be
re-enabled by setting the environment variable `ROC_ENABLE_PRE_VEGA=1`

``` nix
environment.variables = {
  ROC_ENABLE_PRE_VEGA = "1";
};
```

#### Older GPUs (TeraScale) {#older_gpus_terascale}

For graphics cards older than GCN 1 --- or for any GCN using the \"radeon\" driver --- enable OpenCL by adding Clover
*instead of* the ROCm ICD:

``` nix
hardware.opengl.extraPackages = with pkgs; [
  # OpenCL support for the older Radeon R300, R400, R500,
  # R600, R700, Evergreen, Northern Islands,
  # Southern Islands (radeon), and Sea Islands (radeon)
  # GPU families
  mesa.opencl
  # NOTE: at some point GPUs in the R600 family and newer
  # may need to replace this with the "rusticl" ICD;
  # and GPUs in the R500-family and older may need to
  # pin the package version or backport Clover
  # - https://www.phoronix.com/news/Mesa-Delete-Clover-Discussion
  # - https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/19385
];
```

Merely installing `mesa.opencl` with `nix-shell -p` will not work; it needs to be present at build-time for the OpenCL
ICD loader, which only searches static paths.

### Vulkan

Vulkan is already enabled by default (using Mesa RADV) on 64 bit applications. The settings to control it are now the
same as those shown in the basic setup:

``` nix
hardware.graphics.enable = true;
hardware.graphics.enable32Bit = true; # Replaced 'driSupport32Bit'
```

#### AMDVLK

```{=mediawiki}
{{Warning|1=AMDVLK is being discontinued, so the only reason you may want to use it is if you have issues with RADV. See: https://github.com/GPUOpen-Drivers/AMDVLK/discussions/416.}}
```
The AMDVLK drivers can be used in addition to the Mesa RADV drivers. The program will choose which one to use (mostly
defaulting to AMDVLK):

``` nix
#24.11 
hardware.graphics.extraPackages = with pkgs; [
  amdvlk
];
# For 32 bit applications 
hardware.graphics.extraPackages32 = with pkgs; [
  driversi686Linux.amdvlk
];

#24.05 and below
hardware.opengl.extraPackages = with pkgs; [
  amdvlk
];
# For 32 bit applications 
hardware.opengl.extraPackages32 = with pkgs; [
  driversi686Linux.amdvlk
];
```

More information can be found here: <https://nixos.org/manual/nixos/unstable/index.html#sec-gpu-accel-vulkan>

One way to avoid installing it system-wide, is creating a wrapper like this:

``` nix
with pkgs; writeShellScriptBin "amdvlk-run" ''
  export VK_DRIVER_FILES="${amdvlk}/share/vulkan/icd.d/amd_icd64.json:${pkgsi686Linux.amdvlk}/share/vulkan/icd.d/amd_icd32.json"
  exec "$@"
'';
```

This wrapper can be used per-game inside Steam (

``` sh
amdvlk-run %command%
```

) and lets RADV to be the system\'s default.

##### Performance Issues with AMDVLK {#performance_issues_with_amdvlk}

Some games choose AMDVLK over RADV, which can cause noticeable performance issues (e.g. \<50% less FPS in games)

To force RADV

``` nix
environment.variables.AMD_VULKAN_ICD = "RADV";
```

### GUI tools {#gui_tools}

#### LACT - Linux AMDGPU Controller {#lact___linux_amdgpu_controller}

This application allows you to overclock, undervolt, set fans curves of AMD GPUs on a Linux system.

In order to install the daemon service you need to add the package to `systemd.packages`. Also the `wantedBy` field
should be set to `multi-user.target` to start the service during boot.

``` nix
environment.systemPackages = with pkgs; [ lact ];
systemd.packages = with pkgs; [ lact ];
systemd.services.lactd.wantedBy = ["multi-user.target"];
```

Simple version is:

``` nix
services.lact.enable = true;
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/hardware/lact.nix
```

## Troubleshooting

#### Error: `amdgpu: Failed to get gpu_info firmware` {#error_amdgpu_failed_to_get_gpu_info_firmware}

Solution:

`hardware.firmware = [ pkgs.linux-firmware ];`

### Links

- <https://wiki.archlinux.org/title/AMDGPU>
- <https://wiki.gentoo.org/wiki/AMDGPU>

### References

[Category:Video](Category:Video "Category:Video"){.wikilink}

[^1]: <https://bbs.archlinux.org/viewtopic.php?pid=2224147#p2224147>

[^2]: <https://bbs.archlinux.org/viewtopic.php?id=301798>

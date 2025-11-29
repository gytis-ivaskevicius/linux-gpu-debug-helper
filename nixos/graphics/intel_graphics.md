Example configuration with Hardware Acceleration & Quick Sync Video enabled on a modern Intel Graphics (Including ARC)

``` nix
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Required for modern Intel GPUs (Xe iGPU and ARC)
      intel-media-driver     # VA-API (iHD) userspace
      vpl-gpu-rt             # oneVPL (QSV) runtime

      # Optional (compute / tooling):
      intel-compute-runtime  # OpenCL (NEO) + Level Zero for Arc/Xe
      # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
      # libvdpau-va-gl       # Only if you must run VDPAU-only apps
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";     # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
  };

  # May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915):
  hardware.enableRedistributableFirmware = true;
  boot.kernelParams = [ "i915.enable_guc=3" ];

  # May help services that have trouble accessing /dev/dri (e.g., jellyfin/plex):
  # users.users.<service>.extraGroups = [ "video" "render" ];
```

## Driver

Refer to the [Intel Graphics drivers](https://nixos.org/manual/nixos/stable/#sec-x11--graphics-cards-intel) section of
the NixOS manual.

## Video acceleration {#video_acceleration}

To enable hardware (GPU) accelerated video decoding and encoding you need to add additional entries in
`hardware.graphics.extraPackages` (see [accelerated video
playback](Accelerated_Video_Playback "accelerated video playback"){.wikilink}).

## Quick Sync Video {#quick_sync_video}

Intel Quick Sync Video (QSV) is a hardware accelerated media conversion framework for Intel GPUs. Applications that can
be accelerated using QSV include OBS Studio and ffmpeg.

QSV support can be used through either [Intel Media SDK](https://github.com/Intel-Media-SDK/MediaSDK) or [Intel
VPL](https://github.com/intel/libvpl). Intel VPL supersedes the now deprecated Media SDK.

Both libraries dispatch to a backing implementation that is different depending on the GPU generation at runtime. You
need to add either `intel-media-sdk` or `vpl-gpu-rt` (previously `onevpl-intel-gpu`) to
`hardware.graphics.extraPackages`. You can check the
[this](https://github.com/intel/libvpl?tab=readme-ov-file#dispatcher-behavior-when-targeting-intel-gpus) table to decide
whether you need the Media SDK or VPL GPU runtime.

Sample configuration:

``` nix
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      ... # your Open GL, Vulkan and VAAPI drivers
      vpl-gpu-rt # or intel-media-sdk for QSV
    ];
  };
```

## 12th Gen (Alder Lake) {#th_gen_alder_lake}

The X Server may fail to start with the newer 12th generation, Alder Lake, iRISxe integrated graphics chips. If this is
the case, you can give the kernel a hint as to what driver to use. First confirm the graphic chip\'s device ID by
running in a terminal:

``` console
$ nix-shell -p pciutils --run "lspci -nn | grep VGA"
00:02.0 VGA compatible controller [0300]: Intel Corporation Alder Lake-UP3 GT2 [Iris Xe Graphics] [8086:46a8] (rev 0c)
```

In this example, \"46a8\" is the device ID. You can then add this to your configuration and reboot:

    boot.kernelParams = [ "i915.force_probe=<device ID>" ];

[Category:Video](Category:Video "Category:Video"){.wikilink}

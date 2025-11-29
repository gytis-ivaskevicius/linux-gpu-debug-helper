[Mesa](https://www.mesa3d.org/) is an open source implementation of several graphics APIs including OpenGL and Vulkan.

You can change the Mesa version using the `hardware.graphics.package` option as of NixOS 25.05.

## Enabling Vulkan Layers {#enabling_vulkan_layers}

```{=mediawiki}
{{outdated|Vulkan layers are enabled by default since we merged {{pull|196310}}. However, this is a good example on how to properly override mesa's package attributes.}}
```
Vulkan Layers are not enabled by default in
[Nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/mesa/default.nix). You can override
the existing Mesa packages and specify them in `config.hardware.opengl`.

``` nix
hardware = {
  opengl =
    let
      fn = oa: {
        nativeBuildInputs = oa.nativeBuildInputs ++ [ pkgs.glslang ];
        mesonFlags = oa.mesonFlags ++ [ "-Dvulkan-layers=device-select,overlay" ];
#       patches = oa.patches ++ [ ./mesa-vulkan-layer-nvidia.patch ]; See below 
        postInstall = oa.postInstall + ''
            mv $out/lib/libVkLayer* $drivers/lib

            #Device Select layer
            layer=VkLayer_MESA_device_select
            substituteInPlace $drivers/share/vulkan/implicit_layer.d/''${layer}.json \
              --replace "lib''${layer}" "$drivers/lib/lib''${layer}"

            #Overlay layer
            layer=VkLayer_MESA_overlay
            substituteInPlace $drivers/share/vulkan/explicit_layer.d/''${layer}.json \
              --replace "lib''${layer}" "$drivers/lib/lib''${layer}"
          '';
      };
    in
    with pkgs; {
      enable = true;
      driSupport32Bit = true;
      package = (mesa.overrideAttrs fn).drivers;
      package32 = (pkgsi686Linux.mesa.overrideAttrs fn).drivers;
    };
```

Nvidia users may need to apply this patch for the `Device Select` layer to work.

``` diff
diff b/src/vulkan/device-select-layer/device_select_layer.c a/src/vulkan/device-select-layer/device_select_layer.c
--- b/src/vulkan/device-select-layer/device_select_layer.c
+++ a/src/vulkan/device-select-layer/device_select_layer.c
@@ -454,12 +454,8 @@
       exit(0);
    } else {
       unsigned selected_index = get_default_device(info, selection, physical_device_count, physical_devices);
-      selected_physical_device_count = physical_device_count;
+      selected_physical_device_count = 1;
       selected_physical_devices[0] = physical_devices[selected_index];
-      for (unsigned i = 0; i < physical_device_count - 1; ++i) {
-         unsigned  this_idx = i < selected_index ? i : i + 1;
-         selected_physical_devices[i + 1] = physical_devices[this_idx];
-      }
    }

    if (selected_physical_device_count == 0) {
```

## Default drivers {#default_drivers}

In case you wonder where does `["auto"]` in mesa\'s attributes lead you, this might be another way to see them (for
22.3.0[1](https://gitlab.freedesktop.org/mesa/mesa/-/blob/mesa-22.3.0/meson.build)):

``` nix
, galliumDrivers ?
  # Search for `gallium_drivers.contains('auto')` in meson.build
  if stdenv.isLinux then
    if stdenv.isi686 || stdenv.isx86_64  then ["r300" "r600" "radeonsi" "nouveau" "virgl" "svga" "swrast" "iris" "crocus" "i915"]
    else if stdenv.isAarch64 then ["v3d" "vc4" "freedreno" "etnaviv" "nouveau" "svga" "tegra" "virgl" "lima" "panfrost" "swrast"]
    else throw "Unsupported platform: this derivation only supports i686/x86_64/aarch64"
  else if stdenv.isDarwin then ["swrast"]
  else throw "Unsupported platform: this derivation only supports Linux/Darwin"
, vulkanDrivers ?
  # Search for `_vulkan_drivers.contains('auto')` in meson.build
  if stdenv.isLinux then
    if stdenv.isi686 || stdenv.isx86_64   then ["amd" "intel" "intel_hasvk" "swrast"]
    else if stdenv.isAarch64 || stdenv.isArch32 then ["swrast"]
    else throw "Unsupported platform: this derivation only supports i686/x86_64/aarch64"
  else if stdenv.isDarwin then  []
  else throw "Unsupported platform: this derivation only supports Linux/Darwin"
```

## Intel Xe Driver Warning Spam {#intel_xe_driver_warning_spam}

If you\'re using the Intel Xe driver you may end up getting a lot of
`MESA: warning: Support for this platform is experimental with Xe KMD, bug reports may be ignored.` messages spam in
your console when running various tools. You can disable this spam by setting the
[MESA_LOG_FILE](https://docs.mesa3d.org/envvars.html) environment variable to some file location (like `/dev/null`). To
make the change permanent you could add it to your `environment.variables` attribute set in your nix config. The
downside to this approach is that you won\'t see legitimate Mesa warnings or errors on your console afterwards.

Starting with [Mesa 25.1.0](https://docs.mesa3d.org/relnotes/25.1.0.html), you can suppress the warning with
`INTEL_XE_IGNORE_EXPERIMENTAL_WARNING=1`.

[Category: Video](Category:_Video "wikilink")

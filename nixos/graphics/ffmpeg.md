Building FFmpeg with extra functionality. To install the maximum amount of functionality offered by Nix binary
repositories, you may install ffmpeg like the following.

``` nix
environment.systemPackages = [
  pkgs.ffmpeg-full
];
```

### More codecs {#more_codecs}

Adding more functionality to FFmpeg is possible, but it will require compiling on your local system.

Enabling unfree dependencies allow use of Nvidia features, the FDK AAC decoder, and a lot more. Review build
informations to check which flags are enabled by this option:

``` nix
environment.systemPackages = [
  (pkgs.ffmpeg-full.override { withUnfree = true; })
];
```

It is possible to add support for more than one feature at a time. Here are some options disabled by default:

``` nix
environment.systemPackages = [
  (pkgs.ffmpeg-full.override { 
    withUnfree = false; # Allow unfree dependencies (for Nvidia features notably)
    withMetal = false; # Use Metal API on Mac. Unfree and requires manual downloading of files
    withMfx = false; # Hardware acceleration via the deprecated intel-media-sdk/libmfx. Use oneVPL instead (enabled by default) from Intel's oneAPI.
    withTensorflow = false; # Tensorflow dnn backend support (Increases closure size by ~390 MiB)
    withSmallBuild = false; # Prefer binary size to performance.
    withDebug = false; # Build using debug options
  })
];
```

For more options and overrides, check out the FFmpeg build informations :

<https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/libraries/ffmpeg/generic.nix>

### Speeding up install {#speeding_up_install}

It\'s possible to speed up the install. After compiling is finished, a series of generic checks are run. To skip these
checks, we need to set doCheck to false. Here is an example of adding FDK AAC support, and skipping post build checks.

``` nix
environment.systemPackages = [
  ((pkgs.ffmpeg-full.override { withUnfree = true; }).overrideAttrs (_: { doCheck = false; }))
];
```

[Category:Audio](Category:Audio "Category:Audio"){.wikilink}
[Category:Video](Category:Video "Category:Video"){.wikilink}

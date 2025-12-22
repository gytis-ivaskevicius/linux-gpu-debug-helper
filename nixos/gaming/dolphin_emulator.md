```{=mediawiki}
{{disambiguation|Dolphin|the [[KDE]] file manager}}
```
Dolphin is a Nintendo GameCube and Wii emulator, currently supporting the x86_64 and AArch64 architectures. Dolphin is
available for Linux, macOS, Windows, and Android. It is a free and open source, community-developed project. Dolphin was
the first GameCube and Wii emulator, and currently the only one capable of playing commercial games.

## Use with controllers {#use_with_controllers}

To use GameCube controllers NixOS udev rules are required.

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{ pkgs, ... }: 
{
  services.udev.packages = [ pkgs.dolphin-emu ];
}
</nowiki>}}
```
To enable [GCC to USB adapter
overclocking](https://docs.google.com/document/d/1cQ3pbKZm_yUtcLK9ZIXyPzVbTJkvnfxKIyvuFMwzWe0) for improved polling
rates with the Wii U or Mayflash adapter, use the `gcadapter-oc-kmod` kernel module.

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
{ config, ... }: 
{
  boot.extraModulePackages = [ 
    config.boot.kernelPackages.gcadapter-oc-kmod
  ];

  # to autoload at boot:
  boot.kernelModules = [ 
    "gcadapter_oc"
  ];
}
</nowiki>}}
```
[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

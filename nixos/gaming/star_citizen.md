Star Citizen is playable on NixOS, thanks to a few community projects. In case you have issues, over there is a good
place to start

-   [Robertsspaceindustries.com - LUG (Linux User Group)](https://robertsspaceindustries.com/orgs/LUG) &
    [wiki.starcitizen-lug.org - LUG Wiki](https://wiki.starcitizen-lug.org)
-   [GitHub - fufexan/nix-gaming](https://github.com/fufexan/nix-gaming)

## RAM, ZRAM & Swap {#ram_zram_swap}

Bad news: Star Citizen requires a lot of RAM on Linux

Good news: ZRAM & Swap count! For the correct amounts, please see [wiki.starcitizen-lug.org -
Performance-Tuning#zram\--swap](https://wiki.starcitizen-lug.org/Performance-Tuning#zram--swap)

## Example config {#example_config}

The below config is for a system with **16 GB** of **RAM**. Adjust the ZRAM & Swap values as needed.

``` nixos
{ config, pkgs, ... }:

let
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in
{
  # ...

  # See https://github.com/starcitizen-lug/knowledge-base/wiki/Manual-Installation#prerequisites
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  # See RAM, ZRAM & Swap
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8 * 1024;  # 8 GB Swap
  }];
  zramSwap = {
    enable = true;
    memoryMax = 16 * 1024 * 1024 * 1024;  # 16 GB ZRAM
  };

  # The following line was used in my setup, but I'm unsure if it is still needed
  # hardware.pulseaudio.extraConfig = "load-module module-combine-sink";

  users.users.foo = {
    isNormalUser = true;
    description = "Foo";
    packages = with pkgs; [
      # tricks override to fix audio
      # see https://github.com/fufexan/nix-gaming/issues/165#issuecomment-2002038453
      (nix-gaming.packages.${pkgs.hostPlatform.system}.star-citizen.override {
        tricks = [ "arial" "vcrun2019" "win10" "sound=alsa" ];
      })
    ];
  };

  # ...
}
```

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

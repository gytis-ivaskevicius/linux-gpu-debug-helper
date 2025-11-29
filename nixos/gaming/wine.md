Wine is an application to run Windows applications and games.

## 32-bit and 64-bit Support {#bit_and_64_bit_support}

On x86_64-linux, the wine package supports by default both 32- and 64-bit applications. On **every other platform**, the
wine package supports by default **only 32-bit** applications.

These defaults can however be overwritten like this:

``` nix
{
  environment.systemPackages = with pkgs; [
    # ...

    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # support 32-bit only
    wine

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })

    # support 64-bit only
    wine64

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
  ];
}
```

If you get the error
`wine: '/path/to/your/wineprefix' is a 64-bit installation, it cannot be used with a 32-bit wineserver.`, then you need
a 64-bit build like `wineWowPackages`.

The `override` method is mentioned in [the manual](https://nixos.org/nixos/manual/index.html#sec-customising-packages).

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

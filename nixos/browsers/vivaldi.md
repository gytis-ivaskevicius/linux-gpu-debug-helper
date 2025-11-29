[Vivaldi](https://vivaldi.com) is a web browser by the Norwegian company Vivaldi Technologies.

## Installation

add `vivaldi` to your `environment.systemPackages` and rebuild your system configuration.

## Get it working with plasma 6 {#get_it_working_with_plasma_6}

Currently, vivaldi crash at startup on plasma6 due to improper packaging[^1], a workaround to this is to override the
default package attributes by adding the following to your `environment.systemPackages` :

``` nixos
(vivaldi.overrideAttrs
      (oldAttrs: {
        dontWrapQtApps = false;
        dontPatchELF = true;
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.kdePackages.wrapQtAppsHook];
      }))
```

## Force use of password store (KWlallet, GNOME Keyring) {#force_use_of_password_store_kwlallet_gnome_keyring}

To force of specific password store you will have to modify the package according to [chromium
docs](https://chromium.googlesource.com/chromium/src/+/master/docs/linux/password_storage.md)

Use `gnome-libsecret` for GNOME Keyring and `kwallet6` for KDE Plasma 6

``` nix
(stable.vivaldi.override {
  commandLineArgs = "--password-store=kwallet6";
})
```

[Category:Applications](Category:Applications "wikilink") [Category:Web Browser](Category:Web_Browser "wikilink")

[^1]: <https://github.com/NixOS/nixpkgs/pull/292148>

    <https://github.com/NixOS/nixpkgs/issues/310755>

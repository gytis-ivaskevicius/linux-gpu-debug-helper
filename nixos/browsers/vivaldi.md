[Vivaldi](https://vivaldi.com) is a web browser by the Norwegian company Vivaldi Technologies.

## Installation

Simply [install](Adding_programs_to_PATH "wikilink") the `vivaldi` package.

## Get it working with KDE Plasma 6 {#get_it_working_with_kde_plasma_6}

Currently Vivaldi crashes at startup on KDE Plasma 6 due to improper packaging.[^1] A workaround for this is to override
the package attributes like the following.

``` nix
(vivaldi.overrideAttrs (oldAttrs: {
  dontWrapQtApps = false;
  dontPatchELF = true;
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.kdePackages.wrapQtAppsHook];
}))
```

## Force use of password store (KWallet, GNOME Keyring) {#force_use_of_password_store_kwallet_gnome_keyring}

To force of specific password store you will have to use flags according to [chromium
docs](https://chromium.googlesource.com/chromium/src/+/master/docs/linux/password_storage.md).

Below is an example that modifies the package attributes. Use `gnome-libsecret` for GNOME Keyring and `kwallet6` for KDE
Plasma 6

``` nix
(vivaldi.override {
  commandLineArgs = "--password-store=kwallet6";
})
```

[Category:Applications](Category:Applications "wikilink") [Category:Web Browser](Category:Web_Browser "wikilink")

[^1]: <https://github.com/NixOS/nixpkgs/pull/292148>

    <https://github.com/NixOS/nixpkgs/issues/310755>

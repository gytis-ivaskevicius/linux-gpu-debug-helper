[Bottles](https://usebottles.com/) is an open source application that lets you manage your [Wine](Wine "wikilink") or
Proton prefixes, and run Windows software within those prefixes.

## Installation

Simply [install](Adding_programs_to_PATH "wikilink") the `bottles` package:

``` nix
environment.systemPackages = with pkgs; [
  bottles
];
```

You will get a warning that bottles is only supported in sandboxed environments at first start of bottles. To get rid of
this warning, use the code below instead. For reasoning and explanation see [this GitHub
issue](https://github.com/NixOS/nixpkgs/issues/384555).

``` nix
environment.systemPackages = with pkgs; [
  (bottles.override { removeWarningPopup = true; })
];
```

### Home Manager {#home_manager}

Add the package to your
[`home.packages`](https://home-manager-options.extranix.com/?release=master&query=home.packages):

``` nix
home.packages = with pkgs; [      
  bottles
];
```

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

[Bottles](https://usebottles.com/) is an open source application that lets you manage your [Wine](Wine "wikilink") or
Proton prefixes, and run Windows software within those prefixes.

## Installation

Simply [install](Adding_programs_to_PATH "wikilink") the `bottles` package:

``` nix
environment.systemPackages = with pkgs; [
  bottles
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

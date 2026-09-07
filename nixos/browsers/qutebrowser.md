[Qutebrowser](https://qutebrowser.org/) is a keyboard centric web browser written in Python with vim-like keybindings.
It is available as nixpkg qutebrowser.

## Installing dictionaries {#installing_dictionaries}

As of July 2022, there isn\'t a documented way to install dictionaries systemwide. As a workaround, one can do the
following.

### Locate a copy of dictcli.py {#locate_a_copy_of_dictcli.py}

``` console
$ # Get the root of the qutebrowser package
$ nix-store --query --outputs $(which qutebrowser)
nix-store --query --outputs $(which qutebrowser)
$ # Locate dictcli.py within the qutebrowser package root
$ find /nix/store/l50mh79mykqkr6dnx4rkdihcvis9z1v8-qutebrowser-2.5.1 -name dictcli.py
/nix/store/l50mh79mykqkr6dnx4rkdihcvis9z1v8-qutebrowser-2.5.1/share/qutebrowser/scripts/dictcli.py
$ # Then run it
$ /nix/store/l50mh79mykqkr6dnx4rkdihcvis9z1v8-qutebrowser-2.5.1/share/qutebrowser/scripts/dictcli.py
usage: dictcli [-h] {list,update,remove-old,install} ...
dictcli: error: the following arguments are required: cmd
$ # Or more simply:
$ $(find $(nix-store --query --outputs $(which qutebrowser)) -name 'dictcli.py' | head -1)
usage: dictcli [-h] {list,update,remove-old,install} ...
dictcli: error: the following arguments are required: cmd
```

### List installed and available dictionaries {#list_installed_and_available_dictionaries}

Installed dictionaries will have their installed version listed under the \'installed\' column.

``` console
$ $(find $(nix-store --query --outputs $(which qutebrowser)) -iname '*dictcli.py*' | head -1) list
Code   Name                      Version Installed
af-ZA  Afrikaans (South Africa)  3.0     -    
bg-BG  Bulgarian (Bulgaria)      3.0     -    
... SNIP ...
en-US  English (United States)   10.1    -
... SNIP ...
uk-UA  Ukrainian (Ukraine)       5.0     -    
vi-VN  Vietnamese (Viet Nam)     3.0     - 
```

### Install a dictionary {#install_a_dictionary}

``` console
$ $(find $(nix-store --query --outputs $(which qutebrowser)) -iname '*dictcli.py*' | head -1) install en-US
Installing en-US: English (United States)
/home/winston/.local/share/qutebrowser/qtwebengine_dictionaries does not exist, creating the directory
Downloading https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries.git/+/main/en-US-10-1.bdic?format=TEXT
Installed to /home/winston/.local/share/qutebrowser/qtwebengine_dictionaries/en-US-10-1.bdic.
```

## Installing Widevine {#installing_widevine}

[Widevine](https://www.widevine.com/) is a proprietary digital rights management (DRM) technology from Google used by
many web browsers. Widevine is required to watch content on many subscription-based streaming services, e.g. Netflix,
Prime Video, Spotify, etc.

To install Widevine with Qutebrowser, you should configure the variable `enableWideVine` of the package to `true`. There
are different ways to configure that variable, the most common is by [overriding the package\'s
variable](https://nixos.org/manual/nixpkgs/stable/#chap-overrides) in an
[overlay](https://nixos.org/manual/nixpkgs/stable/#chap-overlays), for example:

``` nix
# /etc/nixos/configuration.nix
{
  nixpkgs.overlays = [
    (final: prev: { qutebrowser = prev.qutebrowser.override { enableWideVine = true; }; })
  ];
}
```

Qutebrowser will depend on the package
[widevine-cdm](https://search.nixos.org/packages?channel=unstable&show=widevine-cdm&from=0&size=50&sort=relevance&type=packages&query=widevine-cdm)
that is unfree. Follow the documentation on [Installing of unfree
packages](https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree) if necessary.

## See also {#see_also}

-   [Qutebrowser website](https://qutebrowser.org/)

```{=html}
<hr />
```
```{=html}
<references />
```
[Category:Applications](Category:Applications "wikilink") [Category:Web Browser](Category:Web_Browser "wikilink")

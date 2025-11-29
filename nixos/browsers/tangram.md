[Tangram](https://github.com/sonnyp/Tangram) is a unique web browser that uses a set of persistent tabs. It is intended
to be used for web applications instead of normal browsing.

## dconf

By default, Tangram will be able to run, but is entirely crippled. The window cannot be resized, tabs cannot be added,
and other major breakages occur. You will need to enable `dconf` in order to fix this.

``` nix
programs.dconf.enable = true;
```

[Category:Applications](Category:Applications "wikilink") [Category:Web Browser](Category:Web_Browser "wikilink")

```{=mediawiki}
{{Merge|Mesa|Most of the content here is related to the mesa package}}
```
\_\_FORCETOC\_\_

You can enable OpenGL by setting `hardware.graphics.enable = true;`[^1] in your `/etc/nixos/configuration.nix`.

OpenGL must break purity due to the need for hardware-specific linkage. Intel, AMD, and Nvidia have different drivers
for example. On NixOS, these libraries are symlinked under

` /run/opengl-driver/lib`

and optionally (if `hardware.graphics.enable32Bit`[^2] is enabled)

` /run/opengl-driver-32/lib`

When a program is installed in your environment, these libraries should be found automatically. However, this is not the
case in a \`nix-shell\`. To fix, add this line to your shell.nix:

``` nix
LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib";
```

## Testing Mesa updates {#testing_mesa_updates}

To avoid a lot of rebuilds there\'s an internal NixOS option to override the Mesa drivers: `hardware.opengl.package`

It can be used like this:

``` nix
hardware.opengl.package = (import /srv/nixpkgs-mesa { }).pkgs.mesa.drivers;
```

However, since Mesa 21.0.2 this doesn\'t necessarily work anymore and something like the following might be required:

``` nix
system.replaceRuntimeDependencies = [
  ({ original = pkgs.mesa; replacement = (import /srv/nixpkgs-mesa { }).pkgs.mesa; })
  ({ original = pkgs.mesa.drivers; replacement = (import /srv/nixpkgs-mesa { }).pkgs.mesa.drivers; })
];
```

**Note:** Both of these approaches are impure and only work to a certain degree (many limitations!). If you want to use
a different version of Mesa your best option is to use an overlay or a Git worktree where you use the same Nixpkgs
revision and only alter `pkgs/development/libraries/mesa/` for one of the two approaches mentioned above.

## Debugging Mesa issues {#debugging_mesa_issues}

There are a lot of useful environment variables for debugging purposes: <https://docs.mesa3d.org/envvars.html>

The most important one is `LIBGL_DEBUG=verbose` and helps with debugging error like:

    libGL error: MESA-LOADER: failed to open $DRIVER (search paths /run/opengl-driver/lib/dri)
    libGL error: failed to load driver: $DRIVER

### glxinfo

Use `glxinfo` to load 3D acceleration debug information.

If `glxinfo` returns `Error: couldn't find RGB GLX visual or fbconfig`, ensure you have
`hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];` set.

## Notes

```{=html}
<references group=note />
```
## Related

[Nixpkgs with OpenGL on non-NixOS](Nixpkgs_with_OpenGL_on_non-NixOS "wikilink")

[Category: Video](Category:_Video "wikilink")

[^1]: Renamed from `hardware.opengl.enable` in [NixOS](NixOS "wikilink") 24.11

[^2]: Renamed from `hardware.opengl.driSupport32Bit` in [NixOS](NixOS "wikilink") 24.11

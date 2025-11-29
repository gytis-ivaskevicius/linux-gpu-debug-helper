[RetroArch](https://www.retroarch.com/) is a all-in-one front-end for emulators, game engines and media players. Nix
allows for installing RetroArch cores in a declarative and customizable way.

## Installation

A RetroArch installation can be customized via different packages:

-   `retroarch-full`, contains all libretro cores.
-   `retroarch-free`, excludes unfree cores.
-   `retroarch.withCores`, a helper function for generating a retroarch package with a custom list of cores.

### Installing only certain cores {#installing_only_certain_cores}

Using `retroarch.withCores`: `{{File|3={
  environment.systemPackages = with pkgs; [
    (retroarch.withCores (cores: with cores; [
      genesis-plus-gx
      snes9x
      beetle-psx-hw
    ]))
  ];
}|name=/etc/nixos/configuration.nix|lang=nix}}`{=mediawiki}

One can browse the available cores
[here](https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/emulators/libretro)

## Troubleshooting

### Graphics

Not all the graphics settings are in the same place. You\'ll want to look under the top-level Settings (in the left
column under Main Menu) and also under `Main Menu -> Quick Menu -> Options`

### Mapping

The following way to remap a controller or map a new controller is convoluted, but works and allows you to upstream your
changes.

1.  Fork the [retroarch-joypad-autoconfig](https://github.com/libretro/retroarch-joypad-autoconfig) project and clone it
    in a folder of your choosing.
2.  With Retroarch open, go to Settings \> Directory and change Controller Profiles to point to the same folder. Note:
    Do not attempt to modify the directory in `retroarch.cfg` directly because it will be overwritten on startup.
3.  Now, saving the mapping will work but this will be ignored on next startup of Retroarch.
4.  After you are happy with the mapping, commit the changes in the folder where you cloned the
    retroarch-joypad-autoconfig project and push them to your fork.
5.  To use what you just pushed in your configuration right away, add the following overlay to your nix config by
    replacing the various fields with those corresponding to your fork:

(final: prev: {

` retroarch-joypad-autoconfig = prev.retroarch-joypad-autoconfig.overrideAttrs {`\
`   src = prev.fetchFromGitHub {`\
`     owner = "ibizaman";`\
`     repo = "retroarch-joypad-autoconfig";`\
`     rev = "420a8fa4dc7b12f7c176fa0e704e9f987f6ceabd";`\
`     hash = "sha256-yIvW9UTgc+/hhwx+93FgzrDBEBD35xFdBiVdJCKUYBc=";`\
`   };`\
` };`

})

```{=html}
</syntaxhighlight>
```
1.  After switching over to the new configuration and restarting Retroarch, you will see the mappings got updated.
2.  Now you can create a pull request from your fork to the retroarch-joypad-autoconfig project to upstream your
    changes.

### Input Reset {#input_reset}

beetle-psx-hw input (by keyboard anyway) only works if you go to `Settings -> Input -> Port 1 Controls -> Device Type`
and set it to PlayStation Controller **every time you run the emulator**.

### Missing Icons {#missing_icons}

No icons show in the GUI, including the mouse cursor. You need to go to `Online Updater > Update Assets` to download the
icons. You can navigate the GUI with only the keyboard. Press enter to open sections/pages, backspace to go back out,
arrow keys to choose between options (left/right change some values).

### Error save controller profile {#error_save_controller_profile}

This is because the location of the controller profile is in the nix store, making it read-only. To actually remap a
controller, see the [Mapping](RetroArch#Mapping "wikilink") section.

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

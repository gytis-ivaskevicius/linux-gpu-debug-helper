```{=mediawiki}
{{unfree}}
```
```{=mediawiki}
{{note|Only x86_64-linux system is supported.}}
```
[Celeste](https://www.celestegame.com) is a precision platformer game about climbing a mountain. This page explains how
to play the game, possibly with mods, on NixOS. You may seek further support about Celeste on NixOS in a
[thread](https://discord.com/channels/403698615446536203/1236055875282800741) in the Discord server for Celeste.

## Base game installation {#base_game_installation}

Celeste is not free (as in free beer) for downloading. If you own a copy only on Steam, install
[Steam](Steam "wikilink"), and then install and launch Celeste in Steam. If you own a copy on itch.io, you can either
extract it and run it using `{{nixos:package|steam-run}}`{=mediawiki}, or use the
`{{nixos:package|celestegame}}`{=mediawiki} package.

For using the `celestegame` package follow one of the 3 methodes:

### Manual Updates {#manual_updates}

First download the Linux version of Celeste on [itch.io](https://maddymakesgamesinc.itch.io/celeste), and then add it to
Nix store by running this command:

``` bash
nix-store --add-fixed sha256 celeste-linux.zip
```

You can then install Celeste by the `celestegame` package on Nixpkgs.

### Automatic Updates {#automatic_updates}

For automatic updates you need to let the nix daemon know of your itch.io API key you can get one on
[1](https://itch.io/user/settings/api-keys).

On NixOS you can do this by adding an `EnvironmentFile` to the systemd service staring the nix-daemon and adding the API
key to the `EnvironmentFile` specified you can see an example below.

``` nix
{
  systemd.services.nix-daemon.serviceConfig.EnvironmentFile = "/path/to/file/with/env/vars";
}
```

``` bash
NIX_ITCHIO_API_KEY=my_secret_api_key
```

### None itch.io version {#none_itch.io_version}

You can override the source to use something other than the itch.io version, as long as it is a Zip file containing the
DRM-free game files of Celeste. The Zip file must not contain only a single top-level directory, but should contain the
files such as the `Celeste` binary file directly at top-level. To override the source, write, for example:

``` nix
celestegame.override {
  overrideSrc = requireFile {
    name = "celeste-linux.zip";
    hash = "sha256-phNDBBHb7zwMRaBHT5D0hFEilkx9F31p6IllvLhHQb8=";
    url = "https://example.com";
  };
}
```

## Installing Olympus {#installing_olympus}

Olympus is a GUI tool that can be used to manage multiple Celeste installations and their mods. You can install Olympus
by the `{{nixos:package|olympus}}`{=mediawiki} package.

-   If you want to manage the game from Steam, the game directly extracted from itch.io, or the game installed from the
    package `celestegame.passthru.celeste-unwrapped`, install `olympus.override { celesteWrapper = "steam-run"; }`.
    Setting `celesteWrapper` is essential if you want to launch Celeste from Olympus, but other functionalities of
    Olympus work without this.
-   If you want to manage the game installed from the package `celestegame`, just install `olympus`.

If you want to manage the game installed by the `celestegame` package using Olympus, it may not be convenient because
Olympus cannot automatically discover it by default, and if you manually add the Nix store path as a Celeste
installation in Olympus, the path will probably become invalid or outdated after you update Nixpkgs. To fix this, you
can specify an absolute path where a symbolic link to the Celeste installation will be created, and instruct Olympus to
discover a Celeste installation in that path. For example, in a NixOS configuration, you can write:

``` nix
environment.systemPackages = with pkgs; [
  (celestegame.override { gameDir = "/home/madeline/Games/Celeste/game"; })
  (olympus.override { finderHints = "/home/madeline/Games/Celeste/game"; })
];
```

After switching to this NixOS configuration, you need to launch Celeste once before launch Olympus because the path
specified by `gameDir` is created the first time you launch Celeste. You can also specify multiple directories by
setting `gameDir` and `finderHints` to arrays of strings.

### Managing mods with Olympus {#managing_mods_with_olympus}

If your game is from Steam or directly extracted from itch.io downloads, then you can install Everest and manage mods in
Olympus rightaway.

If you use the `celestegame` package, you cannot install Everest using Olympus. Read [#Installing
Everest](#Installing_Everest "wikilink") for more information. A working snippet of NixOS configuration may look like
this:

``` nix
environment.systemPackages = with pkgs; [
  (celestegame.override {
    withEverest = true;
    writableDir = "/home/madeline/Games/Celeste/writable";
    gameDir = "/home/madeline/Games/Celeste/game";
  })
  (olympus.override { finderHints = "/home/madeline/Games/Celeste/game"; })
];
```

### Managing multiple installations {#managing_multiple_installations}

You can manage different installations, giving benefits of possibly having different sets of mods for each installation.
To do this, you can write something like this in your NixOS configuration:

``` nix
environment.systemPackages = with pkgs; [
  (celestegame.override {
    withEverest = true;
    writableDir = "/home/madeline/Games/Celeste/writable1";
    gameDir = "/home/madeline/Games/Celeste/game1";
  })
  (celestegame.override {
    withEverest = true;
    writableDir = "/home/madeline/Games/Celeste/writable2";
    gameDir = "/home/madeline/Games/Celeste/game2";
  })
  (olympus.override { finderHints = [
    "/home/madeline/Games/Celeste/game1"
    "/home/madeline/Games/Celeste/game2"
  ]; })
];
```

However, this may be a little inconvenient because the `gameDir` is only populated when you launch Celeste for the first
time. Having an activation script for this may be desired. TODO: write instructions about the activation scripts here.

You may also manage both the game from the `celestegame` package and the game from Steam or itch.io in Olympus. Because
of the limitation of the implementation of Celeste launch wrappers in Olympus, the same `celesteWrapper` is used for all
of the installtions that you launch through Olympus. If you set it to `"steam-run"` for launching the game from Steam,
you may have trouble launching the game from the package. This may be fixed by overriding `everest` to `everest-bin`:

``` nix
celestegame.override {
  withEverest = true;
  everest = everest-bin;
  writableDir = "/home/madeline/Games/Celeste/writable";
  gameDir = "/home/madeline/Games/Celeste/game";
}
```

If it still does not work, you can also try replacing `celestegame` with `celestegame.passthru.celeste-unwrapped`, but
this package does not support `gameDir`.

## Installing Everest {#installing_everest}

[Everest](https://everestapi.github.io) is a mod loader for Celeste.

Installing and using Everest for the game from Steam or the game directly extracted from itch.io downloads is not very
different from the upstream documentation (other than the quirk that you may need [nix-ld](nix-ld "wikilink") or an FHS
wrapper like `steam-run` to run MiniInstaller). However, different steps are needed if you use the `celestegame`
package. Because the Nix store is read-only, some further steps are needed to install mods. You need to override the
`writableDir` argument to make file writing happen there instead of in the Nix store path. Therefore, to install Celeste
with Everest using the `celestegame` package, you can write:

``` nix
celestegame.override {
  withEverest = true;
  writableDir = "/home/madeline/Games/Celeste/writable";
}
```

After that, all the file writing operations should be only done in the writable directory you set. For this specific
example, you should expect the Everest logs to be at `/home/madeline/Games/Celeste/writable/everest-log.txt`, and you
should install mods by putting them in `/home/madeline/Games/Celeste/writable/Mods`.

Notice that, while you can specify multiple paths for `gameDir`, you can only specify one path for `writableDir`.
Therefore, if you want this Celeste installation to be playable by multiple users on this machine, setting `writableDir`
to a path that is writable by all of them is advised.

## Installing Mons {#installing_mons}

[Mons](https://mons.coloursofnoise.ca) is a CLI mod manager for Celeste. It can be installed using the
`{{nixos:package|everest-mons}}`{=mediawiki} package. However, it is not advised to use Mons because it is now outdated
and does not work with the current modding ecosystem anymore.

[Category:Gaming](Category:Gaming "wikilink") [Category:Applications](Category:Applications "wikilink")

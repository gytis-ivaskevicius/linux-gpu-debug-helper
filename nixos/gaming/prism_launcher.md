[Prism Launcher](https://prismlauncher.org/) is a free and open source launcher for the game
[Minecraft](https://www.minecraft.net). It is written in C++ and uses the [Qt Toolkit](Qt "Qt Toolkit"){.wikilink}.

## Installation

#### Using nix-shell {#using_nix_shell}

``` shell
$ nix-shell -p prismlauncher
```

#### Using global configuration {#using_global_configuration}

``` nix
environment.systemPackages = with pkgs; [ prismlauncher ];
```

#### Using home configuration {#using_home_configuration}

``` nix
home.packages = with pkgs; [ prismlauncher ];
```

## Configuration

#### Basic

Configuration of the launcher itself can be done in the settings window of the launcher. Currently, there is no way to
configure Prism Launcher declaratively.

#### Advanced

You can override prismlauncher to change the environment available to the launcher and the game. This might be useful
for installing additional versions of [Java](Java "Java"){.wikilink} or providing extra binaries needed by some mods.

``` nix
environment.systemPackages = with pkgs; [
  (prismlauncher.override {
    # Add binary required by some mod
    additionalPrograms = [ ffmpeg ];

    # Change Java runtimes available to Prism Launcher
    jdks = [
      graalvm-ce
      zulu8
      zulu17
      zulu
    ];
  })
];
```

##### Useful options {#useful_options}

All options are defined in [the
derivation](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/pr/prismlauncher/package.nix).

- `additionalLibs` (default: `[ ]`) Additional libraries that will be added to `LD_LIBRARY_PATH`
- `additionalPrograms` (default: `[ ]`) Additional programs that will be added to `PATH`
- `controllerSupport` (default: `stdenv.hostPlatform.isLinux`) Turn on/off support for controllers on Linux. This option
  is not needed on macOS
- `gamemodeSupport` (default: `stdenv.hostPlatform.isLinux`) Turn on/off support for
  [GameMode](GameMode "GameMode"){.wikilink} on Linux
- `jdks` (default: `[ pkgs.jdk21 pkgs.jdk17 pkgs.jdk8 ]`) Java runtimes that will be added to `PRISMLAUNCHER_JAVA_PATHS`
  and will be available to Prism Launcher
- `msaClientID` (default: `null`) Client ID used for Microsoft Authentication. Prism Launcher\'s official ID will be
  used if set to null.
- `textToSpeechSupport` (default `stdenv.hostPlatform.isLinux`) Turn on/off support for text-to-speech on Linux. This
  option is not needed on macOS

## References

- [Prism Launcher Wiki](https://prismlauncher.org/wiki/)
- [Prism Launcher Nix documentation](https://github.com/PrismLauncher/PrismLauncher/blob/develop/nix/README.md)

[Category: Applications](Category:_Applications "Category: Applications"){.wikilink} [Category:
Gaming](Category:_Gaming "Category: Gaming"){.wikilink}

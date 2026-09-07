```{=mediawiki}
{{disambiguation|message=This page is about Minecraft <em>clients</em>, for server setup see [[Minecraft Server]].}}
```
[Minecraft](https://www.minecraft.net/about-minecraft) is a sandbox game about building, surviving, fighting, and being
creative, developed by Mojang Studios.[^1] [Minecraft](https://www.minecraft.net/about-minecraft) currently has two
supported variants known as:

-   **Minecraft: Java Edition**, which is only available on Windows, MacOS, and Linux, and is known for modding.
-   **Minecraft: Bedrock Edition**, which is available on Windows, Xbox One, Xbox Series S and X, PlayStation 4 and 5,
    Nintendo Switch, Android, and iOS. Bedrock is not playable on Linux due to UWP applications not being supported on
    Linux.[^2][^3]

## Launchers

**Official Minecraft Launcher:** [Website](https://www.minecraft.net/download) ---
`{{nixos:package|minecraft}}`{=mediawiki}
`{{warning|1.19 and higher does not work on NixOS, using alternative clients is strongly recommended.}}`{=mediawiki}

**[Prism Launcher](Prism_Launcher "wikilink"):** A free, open source launcher. [Website](https://prismlauncher.org/) ---
`{{nixos:package|prismlauncher}}`{=mediawiki}

**ATLauncher:** A simple and easy to use Minecraft launcher which contains many different modpacks for you to choose
from and play. [Website](https://atlauncher.com/about) --- `{{nixos:package|atlauncher}}`{=mediawiki}

**Badlion Client:** A closed source PvP modpack. [Website](https://www.badlion.net/) ---
`{{nixos:package|badlion-client}}`{=mediawiki}

**Lunar Client:** A free Minecraft client with mods, cosmetics, and performance boost.
[Website](https://www.lunarclient.com/) --- `{{nixos:package|lunar-client}}`{=mediawiki}

**[HMCL](HMCL "wikilink"):** A Minecraft Launcher which is multi-functional, cross-platform and popular.
[Website](https://hmcl.huangyuhui.net/) --- `{{nixos:package|hmcl}}`{=mediawiki}

## Installation

Your preferred client can be installed by adding the package to your configuration:

``` nix
environment.systemPackages = [
  pkgs.<LAUNCHER>
];
```

Alternatively, the package can be installed per-user with `users.users.``<USER>`{=html}`.packages` or
[home-manager](Home_Manager "wikilink").

For a NixOS configuration, use:

``` nix
users.users.<USER>.packages = [
  pkgs.<LAUNCHER>
];
```

For [home-manager](Home_Manager "wikilink"), use:

``` nix
home.packages = [
  pkgs.<LAUNCHER>
];
```

Alternatively, it can be imperatively installed by running `nix-env -iA nixos.``<LAUNCHER>`{=html} or
`nix profile install nixpkgs#``<LAUNCHER>`{=html} if [Flakes](Flakes "wikilink") are enabled.

## Troubleshooting

### ATlauncher can\'t start instance {#atlauncher_cant_start_instance}

By default, ATlauncher installs its own Java runtime in `**USERSDIR**/runtimes/minecraft`, which gets selected in the
settings\' `Java Path`.

To fix this, make sure to select the java version installed in the system store from the
`Settings > Java/Minecraft > Java Path` menu and also disable the `Use Java Provided By Minecraft?` option.

If your instance still doesn\'t start, check the instance settings and apply the same changes there.

### Prism Launcher doesn\'t have Java Version XX. {#prism_launcher_doesnt_have_java_version_xx.}

The [Prism Launcher](Prism_Launcher "wikilink") package can be overridden to add additional [Java](Java "wikilink")
runtimes. Check [Prism_Launcher#Advanced](Prism_Launcher#Advanced "wikilink") to see an example.

### Minecraft Launch Error with NVIDIA Graphics and System GLFW. {#minecraft_launch_error_with_nvidia_graphics_and_system_glfw.}

When using the system GLFW together with an NVIDIA graphics card in the launcher, Minecraft may fail to start and
display the following error message:
`GLFW error 65544: EGL: Failed to clear current context: An EGLDisplay argument does not name a valid EGL display connection`.

In this case, setting the environment variable `__GL_THREADED_OPTIMIZATIONS` to `0` resolves the issue.

### Minecraft can't start without Java Version XX. {#minecraft_cant_start_without_java_version_xx.}

Different Minecraft versions need different [Java](Java "wikilink") versions

  Minecraft Version   Minimum Compatible JRE Version
  ------------------- --------------------------------
  \< 1.17             8
  1.17                16
  \>= 1.18            17
  \>= 1.20.5          21

### Official Minecraft Launcher fails to start the game. {#official_minecraft_launcher_fails_to_start_the_game.}

It is possible that you are attempting to start a version of Minecraft that is 1.19 or higher. **Unfortunately, this is
broken on NixOS**. It is strongly recommended to use alternative launchers.\'\'\'

## See Also {#see_also}

-   [Minecraft on Arch Wiki](https://wiki.archlinux.org/title/Minecraft)

## References

```{=mediawiki}
{{Reflist}}
```
[Category: Applications](Category:_Applications "wikilink") [Category: Gaming](Category:_Gaming "wikilink")

[^1]: [<https://www.minecraft.net/about-minecraft>](https://www.minecraft.net/en-us/about-minecraft)

[^2]: <https://www.minecraft.net/article/java-or-bedrock-edition>

[^3]: [<https://learn.microsoft.com/windows/uwp/get-started/universal-application-platform-guide>](https://learn.microsoft.com/en-us/windows/uwp/get-started/universal-application-platform-guide)

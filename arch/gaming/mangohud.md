[fr:MangoHud](fr:MangoHud "fr:MangoHud"){.wikilink} [ja:MangoHud](ja:MangoHud "ja:MangoHud"){.wikilink}
[zh-hans:MangoHud](zh-hans:MangoHud "zh-hans:MangoHud"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|GameMode}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[MangoHud](https://github.com/flightlessmango/MangoHud) is a [Vulkan](Vulkan "Vulkan"){.wikilink} and
[OpenGL](OpenGL "OpenGL"){.wikilink} overlay for monitoring system performance while inside applications and to record
metrics for [benchmarking](benchmarking "benchmarking"){.wikilink}.

## Installation

[Install](Install "Install"){.wikilink} `{{Pkg|mangohud}}`{=mediawiki} package. Optionally, install
`{{Pkg|lib32-mangohud}}`{=mediawiki} if you need 32-bit games support.

## Configuration

MangoHud is configured via the following files, which are read in the following order:

1.  ```{=mediawiki}
    {{ic|$XDG_CONFIG_HOME/MangoHud/MangoHud.conf}}
    ```

2.  ```{=mediawiki}
    {{ic|$XDG_CONFIG_HOME/MangoHud/APPLICATION-NAME.conf}}
    ```
    (case-sensitive)

3.  ```{=mediawiki}
    {{ic|$XDG_CONFIG_HOME/MangoHud/wine-APPLICATION-NAME.conf}}
    ```
    (for [Wine](Wine "Wine"){.wikilink} applications, case-sensitive, without the `{{ic|.exe}}`{=mediawiki} extension)

4.  ```{=mediawiki}
    {{ic|./MangoHud.conf}}
    ```

5.  ```{=mediawiki}
    {{ic|$MANGOHUD_CONFIGFILE}}
    ```
    (via [environment variables](environment_variables "environment variables"){.wikilink})

```{=mediawiki}
{{Tip|An example configuration file with comments can be found [https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf in the project's repository].}}
```
### GUI for configuration {#gui_for_configuration}

A GUI for configuring MangoHud can be installed from `{{Pkg|goverlay}}`{=mediawiki} or `{{Aur|mangojuice}}`{=mediawiki}.

## Usage

### Keyboard commands {#keyboard_commands}

- ```{=mediawiki}
  {{ic|RShift+F12}}
  ```
  -- Toggle overlay

- ```{=mediawiki}
  {{ic|RShift+F11}}
  ```
  -- Change overlay position

- ```{=mediawiki}
  {{ic|RShift+F10}}
  ```
  -- Toggle preset

- ```{=mediawiki}
  {{ic|LShift+F2}}
  ```
  -- Toggle logging

- ```{=mediawiki}
  {{ic|LShift+F4}}
  ```
  -- Reload config

### Test configuration {#test_configuration}

Verify if the program has been setup correctly:

`$ mangohud glxgears`\
`$ mangohud vkcube`

### Run a single game {#run_a_single_game}

To run a game with MangoHud start it like this:

`$ mangohud `*`game`*

#### Dynamic hooking {#dynamic_hooking}

Certain applications may require a special type of hooking, which can be specified via the `{{ic|--dlsym}}`{=mediawiki}
parameter or the `{{ic|MANGOHUD_DLSYM}}`{=mediawiki} [environment
variable](environment_variable "environment variable"){.wikilink}:

`$ mangohud --dlsym `*`game`*

#### Use with GameMode {#use_with_gamemode}

To launch a game with both MangoHud and [GameMode](GameMode "GameMode"){.wikilink}, chain the two commands into a single
one, like this:

`$ mangohud gamemoderun `*`game`*

### Run a single steam game {#run_a_single_steam_game}

To make [Steam](Steam "Steam"){.wikilink} start a game with MangoHud, right click the game in the *Library*, select
*Properties\...*, then in the *Launch Options* text box enter:

`mangohud %command%`

### Run Steam with MangoHud {#run_steam_with_mangohud}

To avoid having to change launch options for all games, you may launch [Steam](Steam "Steam"){.wikilink} directly with
MangoHud:

`$ mangohud steam-runtime`

MangoHud will detect Steam and will avoid loading itself until a game is launched.

### Enable for all Vulkan games {#enable_for_all_vulkan_games}

To make MangoHud automatically launch with all [Vulkan](Vulkan "Vulkan"){.wikilink} games, it is possible to set the
following [environment variable](environment_variable "environment variable"){.wikilink}:

`MANGOHUD=1`

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

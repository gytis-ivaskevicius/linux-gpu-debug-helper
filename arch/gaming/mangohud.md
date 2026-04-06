[fr:MangoHud](fr:MangoHud "wikilink") [ja:MangoHud](ja:MangoHud "wikilink")
[zh-hans:MangoHud](zh-hans:MangoHud "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|GameMode}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[MangoHud](https://github.com/flightlessmango/MangoHud) is a [Vulkan](Vulkan "wikilink") and [OpenGL](OpenGL "wikilink")
overlay for monitoring system performance while inside applications and to record metrics for
[benchmarking](benchmarking "wikilink").

## Installation

[Install](Install "wikilink") `{{Pkg|mangohud}}`{=mediawiki} and `{{Pkg|lib32-mangohud}}`{=mediawiki} since many old
games are 32-bit-only.

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
    (for [Wine](Wine "wikilink") applications, case-sensitive, without the `{{ic|.exe}}`{=mediawiki} extension)

4.  ```{=mediawiki}
    {{ic|./MangoHud.conf}}
    ```

5.  ```{=mediawiki}
    {{ic|$MANGOHUD_CONFIGFILE}}
    ```
    (via [environment variables](environment_variables "wikilink"))

```{=mediawiki}
{{Tip|An example configuration file with comments can be found [https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf in the project's repository].}}
```
### GUI for configuration {#gui_for_configuration}

A GUI for configuring MangoHud can be installed from `{{Pkg|goverlay}}`{=mediawiki} or `{{Aur|mangojuice}}`{=mediawiki}.

## Usage

### Keyboard commands {#keyboard_commands}

The default keyboard shortcuts include:

+--------------------+-------------------------------+
| Keyboard shortcut  | Description                   |
+====================+===============================+
| ```{=mediawiki}    | Toggle overlay (HUD)          |
| {{ic|Shift_R+F12}} |                               |
| ```                |                               |
+--------------------+-------------------------------+
| ```{=mediawiki}    | Toggle overlay (HUD) position |
| {{ic|Shift_R+F11}} |                               |
| ```                |                               |
+--------------------+-------------------------------+
| ```{=mediawiki}    | Toggle preset                 |
| {{ic|Shift_R+F10}} |                               |
| ```                |                               |
+--------------------+-------------------------------+
| ```{=mediawiki}    | Toggle FPS limit              |
| {{ic|Shift_L+F1}}  |                               |
| ```                |                               |
+--------------------+-------------------------------+
| ```{=mediawiki}    | Toggle logging                |
| {{ic|Shift_L+F2}}  |                               |
| ```                |                               |
+--------------------+-------------------------------+
| ```{=mediawiki}    | Reload configuration          |
| {{ic|Shift_L+F4}}  |                               |
| ```                |                               |
+--------------------+-------------------------------+
| ```{=mediawiki}    | Upload log file               |
| {{ic|Shift_L+F3}}  |                               |
| ```                |                               |
+--------------------+-------------------------------+
| ```{=mediawiki}    | Reset FPS metrics             |
| {{ic|Shift_R+F9}}  |                               |
| ```                |                               |
+--------------------+-------------------------------+

```{=mediawiki}
{{Note|Keyboard shortcut values are transcribed as used in the [https://github.com/flightlessmango/MangoHud/blob/master/data/MangoHud.conf upstream's configuration file].}}
```
### Test configuration {#test_configuration}

Verify if the program has been setup correctly:

`$ mangohud glxgears`\
`$ mangohud vkcube`

### Run a single game {#run_a_single_game}

To run a game with MangoHud start it like this:

`$ mangohud `*`game`*

#### Dynamic hooking for OpenGL applications {#dynamic_hooking_for_opengl_applications}

The `{{ic|dlsym}}`{=mediawiki} hook is enabled by default for OpenGL applications. Set the [environment
variable](environment_variable "wikilink") `{{ic|MANGOHUD_DLSYM{{=}}`{=mediawiki}0}} to disable it in case of problems,
like so:

`$ MANGOHUD_DLSYM{{=}}0 `*`game`*

```{=mediawiki}
{{Note|For Steam launch options, use the following instead:

 MANGOHUD_DLSYM{{=}}
```
0 %command%

}}

#### Use with GameMode {#use_with_gamemode}

To launch a game with both MangoHud and [GameMode](GameMode "wikilink"), chain the two commands into a single one, like
this:

`$ mangohud gamemoderun `*`game`*

### Run a single Steam game {#run_a_single_steam_game}

To make [Steam](Steam "wikilink") start a game with MangoHud, right click the game in the *Library*, select
*Properties\...*, then in the *Launch Options* text box enter:

`mangohud %command%`

#### Run a single Steam game with GameMode enabled too {#run_a_single_steam_game_with_gamemode_enabled_too}

Same as for enabling [Steam](Steam "wikilink") game to run with Mangohud but also with option to use it alongside
GameMode

`mangohud gamemoderun %command%`

### Run Steam with MangoHud {#run_steam_with_mangohud}

To avoid having to change launch options for all games, you may launch [Steam](Steam "wikilink") directly with MangoHud:

`$ mangohud steam-runtime`

MangoHud will detect Steam and will avoid loading itself until a game is launched.

### Enable for all Vulkan games {#enable_for_all_vulkan_games}

To make MangoHud automatically launch with all [Vulkan](Vulkan "wikilink") games, it is possible to set the following
[environment variable](environment_variable "wikilink"):

`MANGOHUD=1`

## Troubleshooting

### MangoHUD does not work with native OpenGL Linux applications {#mangohud_does_not_work_with_native_opengl_linux_applications}

Some Linux native OpenGL applications override `{{ic|LD_PRELOAD}}`{=mediawiki}, preventing MangoHUD from loading.
Sometimes, it\'s possible to edit the app\'s start script to include the path to MangoHUD\'s files, like so:

`LD_PRELOAD{{=}}/usr/lib/mangohud/`

[Category:Gaming](Category:Gaming "wikilink")

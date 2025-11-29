[ja:Gamemode](ja:Gamemode "wikilink") [pl:GameMode](pl:GameMode "wikilink")
[zh-hans:GameMode](zh-hans:GameMode "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|MangoHud}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[GameMode](https://github.com/FeralInteractive/gamemode) is a daemon and library combo for Linux that allows games to
request a set of optimisations be temporarily applied to the host OS and/or a game process.

## Installation

[Install](Install "wikilink") `{{Pkg|gamemode}}`{=mediawiki} and `{{Pkg|lib32-gamemode}}`{=mediawiki}.

Add yourself to the `{{ic|gamemode}}`{=mediawiki} [user group](user_group "wikilink"). Without it, the GameMode user
daemon will not have rights to change CPU governor or the niceness of processes.

## Configuration

GameMode is configured via the following files, which are read and then merged in the following order:

1.  ```{=mediawiki}
    {{ic|/etc/gamemode.ini}}
    ```
    for system-wide configuration;

2.  ```{=mediawiki}
    {{ic|$XDG_CONFIG_HOME/gamemode.ini}}
    ```
    for user-local configuration;

3.  ```{=mediawiki}
    {{ic|./gamemode.ini}}
    ```
    for directory-local configuration.

```{=mediawiki}
{{Tip|An example configuration file with comments can be found [https://github.com/FeralInteractive/gamemode/blob/master/example/gamemode.ini on FeralInteractive's GitHub].}}
```
```{=mediawiki}
{{Note|{{ic|/usr/share/gamemode/gamemode.ini}} should not be created by users, as it's reserved for manual configuration by package maintainers. See {{man|7|file-hierarchy}} for more details.}}
```
### Renicing

GameMode can optionally adjust the priority of game processes (see `{{man|1|renice}}`{=mediawiki}) beyond the regular
user lower limit of `{{ic|0}}`{=mediawiki}.

This is controlled by the following configuration option:

```{=mediawiki}
{{bc|1=
[general]
renice=0
}}
```
Unlike renicing a process with the `{{ic|renice}}`{=mediawiki} command, GameMode uses a positive value then negates it
before applying it to the process. For example, a value of `{{ic|10}}`{=mediawiki} will renice the game process to
`{{ic|-10}}`{=mediawiki}.

### Overclocking

GameMode can optionally overclock your GPU when it is running, but requires special configuration on part of the user.

Independently of the used GPU, the `{{ic|apply_gpu_optimizations}}`{=mediawiki} and `{{ic|gpu_device}}`{=mediawiki}
configuration options must be set appropriately.

```{=mediawiki}
{{Note|Settings in {{ic|[gpu]}} will not be applied if they are specified in {{ic|$XDG_CONFIG_HOME/gamemode.ini}} or {{ic|./gamemode.ini}}, as those are considered "unsafe" config files. These settings will have to be specified in {{ic|/etc/gamemode.ini}} to take effect. See the [https://github.com/FeralInteractive/gamemode#Configuration Configuration section] on FeralInteractive's GitHub page.}}
```
#### AMD

To alter the performance level of AMD GPUs, [overclocking](AMDGPU#Overclocking "wikilink") must be manually enabled, and
the `{{ic|amd_performance_level}}`{=mediawiki} configuration option must be set.

#### NVIDIA

To alter the performance level of NVIDIA GPUs,
[overclocking](NVIDIA/Tips_and_tricks#Enabling_overclocking_in_nvidia-settings "wikilink") must be manually enabled, and
the `{{ic|nv_powermizer_mode}}`{=mediawiki}, `{{ic|nv_core_clock_mhz_offset}}`{=mediawiki}, and the
`{{ic|nv_mem_clock_mhz_offset}}`{=mediawiki} configuration options must be set.

## Usage

### Test configuration {#test_configuration}

Verify if the settings in the configuration file are working:

`$ gamemoded -t`

### Run a single game {#run_a_single_game}

To run a game with GameMode start it like this:

`$ gamemoderun ./game`

#### Use with MangoHud {#use_with_mangohud}

See [MangoHud#Use with GameMode](MangoHud#Use_with_GameMode "wikilink")

### Verify that GameMode is running {#verify_that_gamemode_is_running}

When you have started your game you can verify that GameMode is running with the command:

`$ gamemoded -s`

```{=mediawiki}
{{Note|The {{ic|gamemoded.service}} user unit is started on demand by [[dbus]] [https://github.com/FeralInteractive/gamemode/pull/62].}}
```
### Run a single Steam game {#run_a_single_steam_game}

To make [Steam](Steam "wikilink") start a game with GameMode, set its [launch command](Steam#Launch_options "wikilink"):

`gamemoderun %command% [additional launch options]`

### Run Steam with GameMode {#run_steam_with_gamemode}

To avoid having to change launch options for all Steam games, you may launch [Steam](Steam "wikilink") directly with
GameMode:

`$ gamemoderun steam-runtime`

The downside of this approach is that GameMode will be running for as long as the Steam process is open, instead of only
when a game is opened.

## Troubleshooting

### Renicing fails when set to less than -10 {#renicing_fails_when_set_to_less_than__10}

By default, GameMode provides [PAM](PAM "wikilink") limits that allow changing the scheduling priority up to a maximum
of -10. If the `{{ic|renice}}`{=mediawiki} setting in the configuration file is set to an unsupported value, renicing of
the process will fail entirely.

You can adjust the requested value or adjust the maximum scheduling priority GameMode can set by editing
`{{ic|/etc/security/limits.d/10-gamemode.conf}}`{=mediawiki}. The example below configures -19 as the maximum scheduling
priority GameMode can set:

```{=mediawiki}
{{hc|/etc/security/limits.d/10-gamemode.conf|2=
@gamemode - nice -19
}}
```
[Category:Gaming](Category:Gaming "wikilink")

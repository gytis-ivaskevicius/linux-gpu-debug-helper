[GameMode](https://github.com/FeralInteractive/gamemode) is a daemon/lib combo for Linux that allows games to request a
set of optimisations be temporarily applied to the host OS and/or a game process.

## Installation

GameMode depends on root-level capabilities that aren\'t available in a user-level Nix package installation. The easiest
way to set this up is to use the NixOS module:

``` nix
programs.gamemode.enable = true;
```

## Running

To run games with GameMode start it like this:

``` console
$ gamemoderun ./game
```

When you have started your game you can verify that GameMode is running with the command:

``` console
$ gamemoded -s
```

### Steam

To make sure Steam starts a game with GameMode, right click the game, select Properties\..., then Launch Options and
enter:

``` text
gamemoderun %command%
```

## Verifying Optimisations {#verifying_optimisations}

`gamemoded -t` can be used to verify that the optimisations for your configuration get applied:

``` console
$ gamemoded -t
: Loading config
Loading config file [/nix/store/p8dbmpdak57psrb5c0mz7crsc95nfzs6-gamemode-1.6.1/share/gamemode/gamemode.ini]
Loading config file [/etc/gamemode.ini]
: Running tests

:: Basic client tests
:: Passed

:: Dual client tests
gamemode request succeeded and is active
Quitting by request...
:: Passed

:: Gamemoderun and reaper thread tests
...Waiting for child to quit...
...Waiting for reaper thread (reaper_frequency set to 5 seconds)...
:: Passed

:: Supervisor tests
:: Passed

:: Feature tests
::: Verifying CPU governor setting
::: Passed
::: Verifying Scripts
:::: Running start script [/nix/store/ig8aqj0973jgn6mhnr7smmqb6p7alrz4-libnotify-0.7.9/bin/notify-send 'GameMode started']
:::: Passed
:::: Running end script [/nix/store/ig8aqj0973jgn6mhnr7smmqb6p7alrz4-libnotify-0.7.9/bin/notify-send 'GameMode ended']
:::: Passed
::: Passed
::: Verifying GPU Optimisations
::: Passed
::: Verifying renice
::: Passed
::: Verifying ioprio
::: Passed
:: Passed

: All Tests Passed!
```

## Known Errors {#known_errors}

```{=mediawiki}
{{Tip|The logs of the daemon service can be accessed with <code>journalctl --user -u gamemoded.service</code>.}}
```
Renice & ioprio optimisations sometimes fail. This is caused by GameMode trying to apply optimisations on processes that
exit before the optimisations can be applied. See [FeralInteractive/gamemode#167
(comment)](https://github.com/FeralInteractive/gamemode/issues/167#issuecomment-524277666).

``` text
ERROR: Could not inspect tasks for client [329118]! Skipping ioprio optimisation.
ERROR: Refused to renice client [31477,31477]: prio was (-10) but we expected (0)
```

If you don\'t have an Intel CPU, you will get errors about failing to read the energy levels. This isn\'t a real
problem. It just means that optimizations for integrated graphics cards won\'t be enabled:

``` text
ERROR: Failed to open file for read /sys/class/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:0/energy_uj
```

If you don\'t have a screensaver installed, you will get the following error:

``` text
ERROR: Could not call Inhibit on org.freedesktop.ScreenSaver: No route to host
        org.freedesktop.DBus.Error.ServiceUnknown
        The name org.freedesktop.ScreenSaver was not provided by any .service files
```

You can disable the screensaver inhibiter to get rid of those errors:

``` nix
programs.gamemode.settings.general.inhibit_screensaver = 0;
```

Setting the power scheme might result in the following error:

``` text
::: Verifying CPU governor setting
ERROR: Governor was not set to performance (was actually schedutil)!
::: Failed!
```

Adding the the user to the gamemode group resolves this error.

``` nix
extraGroups = ["gamemode"];
```

[Category:Gaming](Category:Gaming "wikilink")

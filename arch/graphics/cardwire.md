```{=mediawiki}
{{Lowercase title}}
```
`{{Related articles start}}`{=mediawiki} `{{Related|ASUS Linux}}`{=mediawiki} `{{Related|PRIME}}`{=mediawiki}
`{{Related|NVIDIA}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[cardwire](https://github.com/OpenGamingCollective/cardwire) is a GPU manager for Wayland that controls which GPUs a
process may access through [eBPF](Wikipedia:eBPF "eBPF"){.wikilink} [Linux Security
Module](Wikipedia:Linux_Security_Modules "Linux Security Module"){.wikilink} (LSM) hooks. It can block the discrete GPU
of a hybrid laptop so that the hardware can power it down at runtime, without unbinding the PCI device and without
unloading its kernel driver. Switching modes requires neither a reboot nor a new login. the *cardwire* tool works on
multi-GPU laptops and desktops and is not specific to ASUS hardware; within the [ASUS
Linux](ASUS_Linux "ASUS Linux"){.wikilink} stack it is the successor of the deprecated *supergfxctl*, whose migration
notes are kept in [ASUS Linux#Legacy tools](ASUS_Linux#Legacy_tools "ASUS Linux#Legacy tools"){.wikilink}.

```{=mediawiki}
{{Note|cardwire is in early development and upstream expects breaking changes between releases.}}
```
## Installation

[Install](Install "Install"){.wikilink} the `{{AUR|cardwire}}`{=mediawiki} package, also available in the
[ogc](Unofficial_user_repositories#ogc "ogc"){.wikilink} repository.

To start the daemon and run it at boot time, [enable/start](enable/start "enable/start"){.wikilink}
`{{ic|cardwired.service}}`{=mediawiki}. The package ships the unit without a systemd preset, so the service is not
enabled automatically upon installation.

```{=mediawiki}
{{ic|cardwired}}
```
runs as root and owns the D-Bus name `{{ic|org.opengamingcollective.cardwire}}`{=mediawiki} on the system bus; the
*cardwire* command is its client. The daemon stores its state under `{{ic|/var/lib/cardwire/}}`{=mediawiki}: the active
mode in `{{ic|mode.json}}`{=mediawiki}, the per-GPU block states of manual mode in `{{ic|gpu_state.json}}`{=mediawiki},
and application policies in `{{ic|cardwire.db}}`{=mediawiki}.

## Requirements

- A [Wayland](Wayland "Wayland"){.wikilink} session; X11 is not supported.
- The BPF LSM must be initialized. [Officially supported
  kernels](Kernel#Officially_supported_kernels "Officially supported kernels"){.wikilink} do so by default. Check the
  output of `{{ic|cat /sys/kernel/security/lsm}}`{=mediawiki} and verify that it contains `{{ic|bpf}}`{=mediawiki},
  otherwise `{{ic|cardwired}}`{=mediawiki} will refuse to start with an `{{ic|LSM not enabled}}`{=mediawiki} error. If
  `{{ic|bpf}}`{=mediawiki} is missing from the LSM list, append it to the comma-separated `{{ic|1=lsm=}}`{=mediawiki}
  [kernel parameter](kernel_parameter "kernel parameter"){.wikilink} and reboot. Do not write
  `{{ic|1=lsm=bpf}}`{=mediawiki} on its own: the parameter replaces the default list and would disable every other LSM.

```{=mediawiki}
{{Note|When [[kernel lockdown]] is active, parts of the eBPF program may fail to load. In that case, {{ic|cardwired}} logs a warning and continues running in a weakened mode instead of exiting.}}
```
```{=mediawiki}
{{Text art|<nowiki>
  +---------------------+
  | Wayland Application |
  +----------+----------+
             | open("/dev/dri/cardX")
             v
  +---------------------+
  |   Kernel BPF LSM    | <--- Enforced by cardwire
  +----------+----------+
             |
 +-----------+-----------+
 |                       |
 v (Allowed)             v (Blocked)
Normal GPU access       Returns -ENOENT
Discrete GPU powers on  Discrete GPU stays in D3cold
</nowiki>}}
```
## Modes

Blocking is enforced with eBPF LSM hooks: opening the device nodes of a blocked GPU fails with
`{{ic|-ENOENT}}`{=mediawiki}, as if the GPU were absent. Which modes are available depends on the GPU layout:

+-------------------+----------------------------------------------------------+-----------------+---------------------+
| Mode              | Behaviour                                                | Laptop          | Desktop / multi-GPU |
+===================+==========================================================+=================+=====================+
| ```{=mediawiki}   | Discrete GPU is blocked; only the default GPU remains    | ```{=mediawiki} | ```{=mediawiki}     |
| {{ic|integrated}} | usable.                                                  | {{Yes}}         | {{No}}              |
| ```               |                                                          | ```             | ```                 |
+-------------------+----------------------------------------------------------+-----------------+---------------------+
| ```{=mediawiki}   | All blocks are removed and every GPU is usable.          | ```{=mediawiki} | ```{=mediawiki}     |
| {{ic|hybrid}}     |                                                          | {{Yes}}         | {{Yes}}             |
| ```               |                                                          | ```             | ```                 |
+-------------------+----------------------------------------------------------+-----------------+---------------------+
| ```{=mediawiki}   | Discrete GPU is blocked by default and unblocked per     | ```{=mediawiki} | ```{=mediawiki}     |
| {{ic|smart}}      | application (see [#Smart                                 | {{Yes}}         | {{No}}              |
| ```               | mode](#Smart_mode "#Smart mode"){.wikilink}).            | ```             | ```                 |
+-------------------+----------------------------------------------------------+-----------------+---------------------+
| ```{=mediawiki}   | Individual GPUs are blocked or unblocked by ID; the      | ```{=mediawiki} | ```{=mediawiki}     |
| {{ic|manual}}     | default GPU cannot be blocked.                           | {{No}}          | {{Yes}}             |
| ```               |                                                          | ```             | ```                 |
+-------------------+----------------------------------------------------------+-----------------+---------------------+

```{=mediawiki}
{{ic|cardwire set integrated}}
```
and `{{ic|cardwire set smart}}`{=mediawiki} are rejected on systems where the primary display GPU is the discrete one,
and `{{ic|cardwire set manual}}`{=mediawiki} is rejected on standard dual-GPU laptops.

## Usage

The *cardwire* client communicates with `{{ic|cardwired}}`{=mediawiki} over D-Bus; all commands require the daemon to be
running.

### Switching modes {#switching_modes}

Print the active mode and switch to a target profile:

```{=mediawiki}
{{bc|
$ cardwire get
Current Mode: Smart
Available Mode: integrated, hybrid, smart

$ cardwire set integrated
Mode has been set to Integrated
}}
```
The switch takes effect immediately for newly launched processes without logging out or rebooting. The selection is
preserved across reboots.

### Managing GPUs and launching {#managing_gpus_and_launching}

Check detected adapters and their current block states:

```{=mediawiki}
{{bc|
$ cardwire list
ID  NAME                                PCI           RENDER      CARD   DEFAULT DISCRETE  BLOCKED
--  ----------------------------------  ------------  ----------  -----  -------  -------  -------
0   AMD Radeon 660M                     0000:36:00.0  renderD129  card2  (*)      ( )      false
1   NVIDIA GeForce RTX 4060 Laptop GPU  0000:01:00.0  renderD128  card1  ( )      (*)      true
}}
```
To execute a program directly on a discrete GPU in hybrid or smart mode:

```{=mediawiki}
{{bc|
$ cardwire launch --gpu 1 vkcube
}}
```
Without the `{{ic|--gpu}}`{=mediawiki} flag, cardwire picks a discrete GPU following a priority order: a non-default
discrete GPU first, then any discrete GPU, then the default GPU, and finally the first available one.

In smart mode, `{{ic|cardwire launch}}`{=mediawiki} is the approved way to execute a process on the blocked discrete
GPU: the daemon injects the appropriate environment variables for that process only, without requiring a mode switch.

### Manual blocking and power verification {#manual_blocking_and_power_verification}

In manual mode, individual cards can be blocked or unblocked by the ID reported in `{{ic|cardwire list}}`{=mediawiki}:

```{=mediawiki}
{{bc|
$ cardwire gpu 1 --block
$ cardwire gpu 1 --unblock
}}
```
To check which running processes retain open file descriptors on device nodes:

```{=mediawiki}
{{bc|
$ cardwire gpu 1 --lsof
}}
```
To inspect the hardware power management state of a card:

```{=mediawiki}
{{bc|
$ cardwire gpu 1 --power
D3cold
}}
```
If a discrete GPU reports `{{ic|D0}}`{=mediawiki} while in integrated mode, use `{{ic|--lsof}}`{=mediawiki} to inspect
holding processes, or verify kernel runtime power management settings.

## Smart mode {#smart_mode}

```{=mediawiki}
{{Note|Smart mode is actively evolving upstream; application detection heuristics are subject to changes between releases.}}
```
In smart mode, the discrete GPU remains blocked until an application launch is explicitly approved. The internal
analyzer evaluates processes as they launch and stores access decisions in
`{{ic|/var/lib/cardwire/cardwire.db}}`{=mediawiki}.

Steam titles are recognized by their `{{ic|SteamAppId}}`{=mediawiki} environment variable (values `{{ic|0}}`{=mediawiki}
and `{{ic|769}}`{=mediawiki} are ignored) and remain blocked until allowed. System services like
`{{ic|xdg-desktop-portal}}`{=mediawiki} are permanently blocked from waking the discrete GPU.

The analyzer inspects `{{ic|/proc/''pid''/environ}}`{=mediawiki} before the application initializes. Process behavior
can be forced using the following environment variables:

+----------------------------------------------------+------------+----------------------------------------------------+
| Variable                                           | Action     | Effect                                             |
+====================================================+============+====================================================+
| ```{=mediawiki}                                    | Allow      | Unblocks the GPU for the process without directing |
| {{ic|1=CARDWIRE_ALLOW=1}}                          |            | it to a specific card.                             |
| ```                                                |            |                                                    |
+----------------------------------------------------+------------+----------------------------------------------------+
| ```{=mediawiki}                                    | Block      | Blocks discrete GPU access, overriding any force   |
| {{ic|1=CARDWIRE_ALLOW=0}}                          |            | flags.                                             |
| ```                                                |            |                                                    |
+----------------------------------------------------+------------+----------------------------------------------------+
| ```{=mediawiki}                                    | Force dGPU | Unblocks the discrete GPU, runs the process on it, |
| {{ic|1=CARDWIRE_FORCE_DGPU=1}}                     |            | and hides the integrated GPU from that process.    |
| ```                                                |            |                                                    |
+----------------------------------------------------+------------+----------------------------------------------------+
| ```{=mediawiki}                                    | Force ID   | Unblocks the specified GPU ID and executes the     |
| {{ic|1=CARDWIRE_FORCE_GPU=''gpu_id''}}             |            | application on it.                                 |
| ```                                                |            |                                                    |
+----------------------------------------------------+------------+----------------------------------------------------+

## Configuration

Configuration is stored in `{{ic|/etc/cardwire/cardwire.toml}}`{=mediawiki}. The daemon reads this file at startup and
does not monitor it for live changes; [restart](restart "restart"){.wikilink} `{{ic|cardwired.service}}`{=mediawiki}
after editing it manually.

+-------------------------------------+-------------------------------------+-----------------+-----------------------------------------------+
| Key                                 | CLI key                             | Default         | Description                                   |
+=====================================+=====================================+=================+===============================================+
| ```{=mediawiki}                     | ```{=mediawiki}                     | ```{=mediawiki} | Restores per-GPU block states from the        |
| {{ic|auto_apply_gpu_state}}         | {{ic|auto-apply-gpu-state}}         | {{ic|true}}     | previous manual session when re-entering      |
| ```                                 | ```                                 | ```             | manual mode.                                  |
+-------------------------------------+-------------------------------------+-----------------+-----------------------------------------------+
| ```{=mediawiki}                     | ```{=mediawiki}                     | ```{=mediawiki} | Blocks shared NVIDIA nodes like               |
| {{ic|experimental_nvidia_block}}    | {{ic|experimental-nvidia-block}}    | {{ic|false}}    | `{{ic|/dev/nvidiactl}}`{=mediawiki}.          |
| ```                                 | ```                                 | ```             | Recommended on dual-GPU laptops with NVIDIA   |
|                                     |                                     |                 | cards to prevent sleep inhibitors.            |
+-------------------------------------+-------------------------------------+-----------------+-----------------------------------------------+
| ```{=mediawiki}                     | ```{=mediawiki}                     | ```{=mediawiki} | Automatically switches to                     |
| {{ic|battery_auto_switch}}          | {{ic|battery-auto-switch}}          | {{ic|false}}    | `{{ic|integrated}}`{=mediawiki} on battery,   |
| ```                                 | ```                                 | ```             | and to                                        |
|                                     |                                     |                 | `{{ic|battery_auto_switch_mode}}`{=mediawiki} |
|                                     |                                     |                 | on AC power.                                  |
+-------------------------------------+-------------------------------------+-----------------+-----------------------------------------------+
| ```{=mediawiki}                     | ```{=mediawiki}                     | ```{=mediawiki} | Target mode when connected to AC power:       |
| {{ic|battery_auto_switch_mode}}     | {{ic|battery-auto-switch-mode}}     | {{ic|hybrid}}   | `{{ic|integrated}}`{=mediawiki},              |
| ```                                 | ```                                 | ```             | `{{ic|hybrid}}`{=mediawiki},                  |
|                                     |                                     |                 | `{{ic|manual}}`{=mediawiki}, or               |
|                                     |                                     |                 | `{{ic|smart}}`{=mediawiki}.                   |
+-------------------------------------+-------------------------------------+-----------------+-----------------------------------------------+
| ```{=mediawiki}                     | ```{=mediawiki}                     | ```{=mediawiki} | Automatically switches from integrated or     |
| {{ic|external_display_auto_switch}} | {{ic|external-display-auto-switch}} | {{ic|false}}    | smart to hybrid mode when an external screen  |
| ```                                 | ```                                 | ```             | wired to the discrete GPU is attached.        |
+-------------------------------------+-------------------------------------+-----------------+-----------------------------------------------+

Settings can be viewed and modified with the command-line interface:

```{=mediawiki}
{{bc|
$ cardwire config battery-auto-switch true
$ cardwire config save
}}
```
## Tips and tricks {#tips_and_tricks}

### Desktop environment integration {#desktop_environment_integration}

The daemon implements the `{{ic|net.hadess.SwitcherooControl}}`{=mediawiki} D-Bus interface. This provides native
\"Launch using Discrete Graphics Card\" menu entries in desktop application launchers such as GNOME Shell and KDE Plasma
without requiring extra daemons.

The `{{AUR|cardwire}}`{=mediawiki} package also includes `{{ic|cardwire-gui}}`{=mediawiki}, a graphical tray icon and
profile switcher.

### Steam game launch options {#steam_game_launch_options}

To force a specific game to execute on the discrete GPU while in smart mode, configure the game\'s launch options in
Steam:

```{=mediawiki}
{{bc|1=
CARDWIRE_FORCE_DGPU=1 %command%
}}
```
## Troubleshooting

+--------------------------------------+----------------------------------------------------+------------------------------------------------------------------+
| Symptom                              | Cause                                              | Resolution                                                       |
+======================================+====================================================+==================================================================+
| ```{=mediawiki}                      | The daemon is not running.                         | [Start and enable](enable/start "Start and enable"){.wikilink}   |
| {{ic|Name is not activable}}         |                                                    | `{{ic|cardwired.service}}`{=mediawiki}, then reboot if the error |
| ```                                  |                                                    | persists.                                                        |
+--------------------------------------+----------------------------------------------------+------------------------------------------------------------------+
| The discrete GPU is detected as the  | The firmware MUX routes the internal display       | On ASUS laptops, change routing with                             |
| default one                          | through the discrete GPU.                          | `{{ic|asusctl armoury set gpu_mux_mode 1}}`{=mediawiki} and      |
|                                      |                                                    | reboot (see [ASUS Linux#MUX                                      |
|                                      |                                                    | modes](ASUS_Linux#MUX_modes "ASUS Linux#MUX modes"){.wikilink}). |
|                                      |                                                    | On other hardware, report upstream with the contents of          |
|                                      |                                                    | `{{ic|/sys/class/drm/*/status}}`{=mediawiki}.                    |
+--------------------------------------+----------------------------------------------------+------------------------------------------------------------------+
| ```{=mediawiki}                      | The service cannot communicate with the GPU while  | [Restart](restart "Restart"){.wikilink}                          |
| {{ic|nvidia-powerd}}                 | in D3cold.                                         | `{{ic|nvidia-powerd.service}}`{=mediawiki} if cardwire does not  |
| ```                                  |                                                    | automatically recover it.                                        |
| fails after a mode switch            |                                                    |                                                                  |
+--------------------------------------+----------------------------------------------------+------------------------------------------------------------------+
| The discrete GPU never powers down   | Open file descriptors hold device nodes, or        | Identify holding processes with                                  |
|                                      | runtime power management is disabled.              | `{{ic|cardwire gpu ''ID'' --lsof}}`{=mediawiki}. Wayland         |
|                                      |                                                    | compositors often hold shared nodes; enable                      |
|                                      |                                                    | `{{ic|experimental_nvidia_block}}`{=mediawiki} (see              |
|                                      |                                                    | [#Configuration](#Configuration "#Configuration"){.wikilink}).   |
|                                      |                                                    | Check Runtime D3 state in                                        |
|                                      |                                                    | `{{ic|/proc/driver/nvidia/gpus/*/power}}`{=mediawiki}.           |
+--------------------------------------+----------------------------------------------------+------------------------------------------------------------------+
| ```{=mediawiki}                      | The BPF LSM is not active in the running kernel.   | Add `{{ic|bpf}}`{=mediawiki} to the `{{ic|1=lsm=}}`{=mediawiki}  |
| {{ic|cardwired}}                     |                                                    | kernel parameter as described in                                 |
| ```                                  |                                                    | [#Requirements](#Requirements "#Requirements"){.wikilink}.       |
| exits with                           |                                                    |                                                                  |
| `{{ic|LSM not enabled}}`{=mediawiki} |                                                    |                                                                  |
+--------------------------------------+----------------------------------------------------+------------------------------------------------------------------+
| The \"Launch using Discrete Graphics | A conflicting service owns                         | Stop the conflicting service and                                 |
| Card\" entry is missing              | `{{ic|net.hadess.SwitcherooControl}}`{=mediawiki}. | [restart](restart "restart"){.wikilink}                          |
|                                      |                                                    | `{{ic|cardwired.service}}`{=mediawiki}.                          |
+--------------------------------------+----------------------------------------------------+------------------------------------------------------------------+
| ```{=mediawiki}                      | The RPC method is not supported by the daemon.     | Use `{{ic|cardwire list}}`{=mediawiki} and                       |
| {{ic|cardwire debug diagnostic-gpu}} |                                                    | `{{ic|cardwire gpu ''ID'' --power}}`{=mediawiki} as              |
| ```                                  |                                                    | alternatives.                                                    |
| fails with                           |                                                    |                                                                  |
| `{{ic|Unknown method}}`{=mediawiki}  |                                                    |                                                                  |
+--------------------------------------+----------------------------------------------------+------------------------------------------------------------------+

## See also {#see_also}

- [cardwire documentation](https://opengamingcollective.github.io/cardwire/)
- [cardwire repository](https://github.com/OpenGamingCollective/cardwire)
- [cardwire issue tracker](https://github.com/OpenGamingCollective/cardwire/issues)

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink}

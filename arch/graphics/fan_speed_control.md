[fr:Fan speed control](fr:Fan_speed_control "wikilink") [ja:ファンスピード制御](ja:ファンスピード制御 "wikilink")
[zh-hans:Fan speed control](zh-hans:Fan_speed_control "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|lm_sensors}}`{=mediawiki} `{{Related|Undervolting CPU}}`{=mediawiki}
`{{Related|CPU frequency scaling}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

Fan control can bring various benefits to your system, such as quieter working system and power saving by completely
stopping fans on low CPU load.

```{=mediawiki}
{{Note|Laptop users should be aware about how cooling system works in their hardware. Some laptops have single fan for both CPU and GPU and cools both at the same time. Some laptops have two fans for CPU and GPU, but the first fan cools down CPU and GPU at the same time, while the other one cools CPU only. In some cases, you will not be able to use the [[#Fancontrol (lm-sensors)|Fancontrol]] script due to incompatible cooling architecture (e.g. one fan for both GPU and CPU). See [https://github.com/daringer/asus-fan/issues/47#issue-232063547] for some more information about this topic.}}
```
```{=mediawiki}
{{Warning|Configuring or completely stopping fans on high system load might result in permanently damaged hardware, or thermal throttling at best.}}
```
## Fancontrol (lm-sensors) {#fancontrol_lm_sensors}

```{=mediawiki}
{{Style|This partially duplicates [[lm_sensors#Configuration]], it should link there instead.}}
```
```{=mediawiki}
{{ic|fancontrol}}
```
is a part of `{{Pkg|lm_sensors}}`{=mediawiki}, which can be used to control the speed of CPU/case fans. It is most
suitable for desktops and laptops, where fan controls are available via `{{man|5|sysfs}}`{=mediawiki}.

Support for newer motherboards may not yet be in the Linux kernel.

### lm-sensors {#lm_sensors}

```{=mediawiki}
{{Warning|The following command is safe by default (pressing {{ic|Enter}} at each prompt). Some advanced options may damage hardware: only modify the defaults if you understand the implications.}}
```
The first thing to do is to run

`# sensors-detect`

This will detect all of the sensors present and they will be used for *fancontrol*. After that, run the following to
check if it detected the sensors correctly:

```{=mediawiki}
{{hc|$ sensors|2=
coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +29.0°C  (high = +76.0°C, crit = +100.0°C)
...
it8718-isa-0290
Adapter: ISA adapter
Vcc:         +1.14 V  (min =  +0.00 V, max =  +4.08 V)
VTT:         +2.08 V  (min =  +0.00 V, max =  +4.08 V)
+3.3V:       +3.33 V  (min =  +0.00 V, max =  +4.08 V)
NB Vcore:    +0.03 V  (min =  +0.00 V, max =  +4.08 V)
VDRAM:       +2.13 V  (min =  +0.00 V, max =  +4.08 V)
fan1:        690 RPM  (min =   10 RPM)
temp1:       +37.5°C  (low  = +129.5°C, high = +129.5°C)  sensor = thermistor
temp2:       +25.0°C  (low  = +127.0°C, high = +127.0°C)  sensor = thermal diode
}}
```
```{=mediawiki}
{{Note|If the output does not display an RPM value for the CPU fan, one may need to [[#Increase the fan divisor for sensors]]. If the fan speed is shown and higher than 0, this is fine.}}
```
### Configuration

Once the sensors are properly configured, use `{{man|8|pwmconfig}}`{=mediawiki} to test and configure fan speed control.
Following the guide should create `{{ic|/etc/fancontrol}}`{=mediawiki}, a customized configuration file. In the guide,
the default answers are in parenthesis if you press enter without typing anything. Enter `{{ic|y}}`{=mediawiki} for yes,
`{{ic|n}}`{=mediawiki} for no.

`# pwmconfig`

```{=mediawiki}
{{Note|Some users may experience issues when using {{ic|/sys/class/hwmon/}} paths for their configuration file. ''hwmon'' class device symlinks point to the absolute paths, and are used to group all of the ''hwmon'' sensors together into one directory for easier access. Sometimes, the order of the ''hwmon'' devices change from a reboot, causing ''fancontrol'' to stop working. See [[#Device paths have changed in /etc/fancontrol]] for more information on how to fix this.}}
```
#### Tweaking

Some users may want to manually tweak the configuration file after running `{{ic|pwmconfig}}`{=mediawiki} with root
privileges, usually to fix something. For manually tweaking the `{{ic|/etc/fancontrol}}`{=mediawiki} configuration file,
see `{{man|8|fancontrol}}`{=mediawiki} for the variable definitions.

Users will probably encounter the *hwmon* path issues as noted above in [#Fancontrol
(lm-sensors)](#Fancontrol_(lm-sensors) "wikilink"). See [#Device paths have changed in
/etc/fancontrol](#Device_paths_have_changed_in_/etc/fancontrol "wikilink") for more information.

```{=mediawiki}
{{Tip|Use {{ic|MAXPWM}} and {{ic|MINPWM}} options that limit fan speed range. See {{man|8|fancontrol}} for details.}}
```
```{=mediawiki}
{{Note|Temperature and fan sensor paths could change as well (usually on a kernel update) (e.g. {{ic|hwmon0/device/temp1_input}} becomes {{ic|hwmon0/temp1_input}}). Check the {{ic|fancontrol.service}} [[unit status]] to find out which path is the troublemaker and correct your configuration file accordingly.}}
```
### Running Fancontrol {#running_fancontrol}

Try to run *fancontrol*:

`# fancontrol`

A properly configured setup will not output errors and will take control of the system fans. Users should hear system
fans starting shortly after executing this command. *fancontrol* can also be run by
[starting/enabling](starting/enabling "wikilink") `{{ic|fancontrol.service}}`{=mediawiki}.

For an unofficial GUI, [install](install "wikilink") `{{AUR|fancontrol-gui}}`{=mediawiki}.

### Fancontrol stops working after suspend--wake cycles {#fancontrol_stops_working_after_suspendwake_cycles}

Unfortunately, *fancontrol* does not work after suspending. As per the [filed
bug](https://github.com/lm-sensors/lm-sensors/issues/172), you will have to restart *fancontrol* after suspending. This
can be achieved automatically by a [systemd
hook](Power_management/Suspend_and_hibernate#Hooks_in_/usr/lib/systemd/system-sleep "wikilink").

## NBFC

```{=mediawiki}
{{Note|NBFC has been unmaintained since Mar 29, 2020. New user configs can still be created manually, however predefined configurations have not been added since that time. There are forks that exist to add new configs, such as [https://github.com/UraniumDonut/nbfc-revive nbfc-revive].}}
```
NBFC (NoteBook Fan Control) is a cross-platform fan control solution for notebooks, written in C# and works under
[Mono](Mono "wikilink") runtime. It comes with a powerful configuration system, which allows to adjust it to many
different notebook models, including some of the latest ones.

There is another lightweight implementation of NBFC, written in C, named
[NBFC-Linux](https://github.com/nbfc-linux/nbfc-linux). It does not depend on the Mono framework. It can be installed as
`{{AUR|nbfc-linux}}`{=mediawiki}.

### Installation

NBFC can be installed as `{{AUR|nbfc}}`{=mediawiki}. Also [start/enable](start/enable "wikilink")
`{{ic|nbfc.service}}`{=mediawiki}.

### Configuration {#configuration_1}

NBFC comes with pre-made profiles. You can find them in `{{ic|/opt/nbfc/Configs/}}`{=mediawiki} directory. When applying
them, use the exact profile name without a file extension (e.g. `{{ic|some profile.xml}}`{=mediawiki} becomes
`{{ic|"some profile"}}`{=mediawiki}).

Check if there is anything NBFC can recommend:

`$ nbfc config -r`

If there is at least one model, try to apply this profile and see how fan speeds are being handled. For example:

`$ nbfc config -a "Asus Zenbook UX430UA"`

```{=mediawiki}
{{Note|If you are getting {{ic|File Descriptor does not support writing}}, delete {{ic|StagWare.Plugins.ECSysLinux.dll}} [https://github.com/hirschmann/nbfc/issues/439] and [[restart]] {{ic|nbfc.service}}:
 # mv /opt/nbfc/Plugins/StagWare.Plugins.ECSysLinux.dll /opt/nbfc/Plugins/StagWare.Plugins.ECSysLinux.dll.old
If above solution did not help, try appending {{ic|1=ec_sys.write_support=1}} to [[kernel parameters]].
}}
```
If there are no recommended models, go to [NBFC git repository](https://github.com/hirschmann/nbfc/tree/master/Configs)
or `{{ic|/opt/nbfc/Configs/}}`{=mediawiki} and check if there are any similar models available from the same
manufacturer. For example, on **Asus Zenbook UX430UQ**, the configuration **Asus Zenbook UX430UA** did not work well
(fans completelly stopped all the time), but **Asus Zenbook UX410UQ** worked fantastically.

Run `{{ic|nbfc}}`{=mediawiki} to see all options. More information about configuration is available at [upstream
wiki](https://github.com/hirschmann/nbfc/wiki/).

## Dell laptops {#dell_laptops}

*i8kutils* is a daemon to configure fan speed according to CPU temperatures on some Dell Inspiron and Latitude laptops.
It uses the `{{ic|/proc/i8k}}`{=mediawiki} interface provided by the `{{ic|i8k}}`{=mediawiki} driver (an alias for
`{{ic|dell_smm_hwmon}}`{=mediawiki}). Results will vary depending on the exact model of laptop.

If fancontrol will not work on your system, use the `{{ic|1=ignore_dmi=1}}`{=mediawiki} [kernel module
parameter](kernel_module_parameter "wikilink") to load `{{ic|dell_smm_hwmon}}`{=mediawiki}.

```{=mediawiki}
{{Warning|1=''i8kutils'' BIOS system calls stop the kernel for a moment on some systems (confirmed on Dell 9560), this can lead to side effects like audio dropouts, see https://bugzilla.kernel.org/show_bug.cgi?id=201097}}
```
### Installation {#installation_1}

```{=mediawiki}
{{AUR|i8kutils}}
```
is the main package to control fan speed. Additionally, you might want to install these:

-   ```{=mediawiki}
    {{Pkg|acpi}}
    ```
    --- must be installed to use *i8kmon*.

-   ```{=mediawiki}
    {{Pkg|tcl}}
    ```
    --- must be installed in order to run *i8kmon* as a background service (using the `{{ic|--daemon}}`{=mediawiki}
    option).

-   ```{=mediawiki}
    {{Pkg|tk}}
    ```
    --- must be installed together with `{{Pkg|tcl}}`{=mediawiki} to run as X11 desktop applet.

-   ```{=mediawiki}
    {{AUR|dell-bios-fan-control-git}}
    ```
    --- recommended if your BIOS overrides fan control.

### Configuration {#configuration_2}

The temperature points at which the fan changes speed can be adjusted in the configuration file
`{{ic|/etc/i8kutils/i8kmon.conf}}`{=mediawiki}. Only three fans speeds are supported (high, low, and off). Look for a
section similar to the following:

`set config(0)  {{0 0}  -1  55  -1  55}`\
`set config(1)  {{1 1}  45  75  45  75}`\
`set config(2)  {{2 2}  65 128  65 128}`

This example starts the fan at low speed when the CPU temperature reaches 55 °C, switching to high speed at 75 °C. The
fan will switch back to low speed once the temperature drops to 65 °C, and turns off completely at 45 °C.

```{=mediawiki}
{{Tip|If when running {{ic|i8kmon}} with the verbose option you notice that the state changes (example of an output: {{ic|1=# (57>=55), state=1, low=45, high=75}}) but right and left fans report state 0, you might consider changing the speed value of the first state in the configuration file from default 1000 to 2000 or higher.}}
```
### Installation as a service {#installation_as_a_service}

*i8kmon* can be started automatically by [starting/enabling](starting/enabling "wikilink")
`{{ic|i8kmon.service}}`{=mediawiki}.

### BIOS overriding fan control {#bios_overriding_fan_control}

Some newer laptops have BIOS fan control in place which will override the OS level fan control. To test if this the
case, run `{{ic|i8kmon}}`{=mediawiki} with verbose mode in a command line, make sure the CPU is idle, then see if the
fan is turned off or turned down accordingly.

If the BIOS fan control is in place, you can try using `{{AUR|dell-bios-fan-control-git}}`{=mediawiki}:

```{=mediawiki}
{{Warning|Turning off BIOS fan control could result in damage to your hardware. Make sure you have ''i8kmon'' properly set up beforehand, or leave the CPU idle while you test this program.}}
```
To enable BIOS fan control:

`# dell-bios-fan-control 1`

To disable BIOS fan control:

`# dell-bios-fan-control 0`

BIOS fan control can be automatically disabled by [starting/enabling](starting/enabling "wikilink")
`{{ic|dell-bios-fan-control.service}}`{=mediawiki}.

## ThinkPad laptops {#thinkpad_laptops}

Some fan control daemons include `{{AUR|simpfand-git}}`{=mediawiki} and `{{AUR|thinkfan}}`{=mediawiki} (recommended).

### Installation {#installation_2}

Install `{{AUR|thinkfan}}`{=mediawiki}. Optionally, but recommended, install `{{Pkg|lm_sensors}}`{=mediawiki}. If
needed, a GUI is available with `{{AUR|thinkfan-ui}}`{=mediawiki}. Then have a look at the files:

`# pacman -Ql thinkfan`

Note that the *thinkfan* package installs `{{ic|/usr/lib/modprobe.d/thinkpad_acpi.conf}}`{=mediawiki}, which contains
the following [kernel module parameter](kernel_module_parameter "wikilink"):

`options thinkpad_acpi fan_control=1`

```{=mediawiki}
{{Note|New Thinkpad models may require an additional {{ic|1=experimental=1}} kernel module parameter. So, it is important to check fan functionality.}}
```
So fan control is enabled by default, but you may need you to manually [regenerate the
initramfs](regenerate_the_initramfs "wikilink").

Now, reload the module with fan control enabled:

`# modprobe -r thinkpad_acpi`\
`# modprobe thinkpad_acpi fan_control=1`\
`# cat /proc/acpi/ibm/fan`

You should see that the fan level is \"auto\" by default, but you can echo a level command to the same file to control
the fan speed manually:

`# echo level 1 > /proc/acpi/ibm/fan`

  Level                     Effect
  ------------------------- ---------------------------------------------------------------------------
  0                         off
  2                         low speed
  4                         medium speed
  7                         maximum speed
  auto                      default - automatic, the fan RPM is controlled by the BIOS
  full-speed / disengaged   the maximum fan speed; here the controller does not monitor the fan speed

  : Fan Levels

The *thinkfan* daemon will do this automatically.

\"7\" is not the same as \"disengaged\". \"7\" is the maximum regulated speed (corresponds to \"full-speed\").
disengaged is the maximum unregulated speed. See
[ThinkWiki](https://www.thinkwiki.org/wiki/How_to_control_fan_speed#Disengaged_.28full-speed.29_mode) for more details.

Finally, [enable](enable "wikilink") the `{{ic|thinkfan.service}}`{=mediawiki}.

To configure the temperature thresholds, you will need to copy the example configuration file
(`{{ic|/usr/share/doc/thinkfan/examples/thinkfan.yaml}}`{=mediawiki}) to `{{ic|/etc/thinkfan.conf}}`{=mediawiki}, and
modify to taste. This file specifies which sensors to read, and which interface to use to control the fan. Some systems
have `{{ic|/proc/acpi/ibm/fan}}`{=mediawiki} and `{{ic|/proc/acpi/ibm/thermal}}`{=mediawiki} available; on others, you
will need to specify something like:

`hwmon: /sys/devices/virtual/thermal/thermal_zone0/temp`

to use generic *hwmon* sensors instead of thinkpad-specific ones.

A configuration example can be found in [Gentoo:Fan speed
control/thinkfan#Configuration](Gentoo:Fan_speed_control/thinkfan#Configuration "wikilink").

### Running

You can test your configuration first by running thinkfan manually (as root):

`# thinkfan -n`

and see how it reacts to the load level of whatever other programs you have running.

When you have it configured correctly, [start/enable](start/enable "wikilink") `{{ic|thinkfan.service}}`{=mediawiki}.

## Lenovo Legions laptops {#lenovo_legions_laptops}

The tool [Lenovo Legion Linux](https://github.com/johnfanv2/LenovoLegionLinux) allows to change the fan curves that are
stored in the embedded controller. It consists of a kernel module that must be compiled and loaded. Currently, there is
no package, but it must be compiled and installed from source.

Then the fan curve can be set via the hwmon interface. This can be done with the provided script or the Python GUI.

## ASUS laptops {#asus_laptops}

This topic will cover drivers configuration on ASUS laptops for [Fancontrol
(lm-sensors)](#Fancontrol_(lm-sensors) "wikilink").

### Kernel modules {#kernel_modules}

In configuration files, we are going to use full paths to *sysfs* files (e.g.
`{{ic|/sys/devices/platform/asus-nb-wmi/hwmon/hwmon<nowiki>[[:print:]]*</nowiki>/pwm1}}`{=mediawiki}). This is because
`{{ic|hwmon'''1'''}}`{=mediawiki} might change to any other number after reboot. [Fancontrol
(lm-sensors)](#Fancontrol_(lm-sensors) "wikilink") is written in [Bash](Bash "wikilink"), so using these paths in
configuration file is completely acceptable. You can find complete `{{ic|/etc/fancontrol}}`{=mediawiki} configuration
file examples at [ASUS N550JV#Fan control](ASUS_N550JV#Fan_control "wikilink").

#### asus-nb-wmi {#asus_nb_wmi}

```{=mediawiki}
{{ic|asus-nb-wmi}}
```
is a kernel module, which is included in the Linux kernel and is loaded automatically on ASUS laptops. It will only
allow to control a single fan and if there is a second fan you will not have any controls over it. Note that
blacklisting this module will prevent keyboard backlight to work.

Below are the commands to control it. Check if you have any controls over your fan:

`# echo 255 > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon[[:print:]]*/pwm1           # Full fan speed (Value: 255)`\
`# echo 0 > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon[[:print:]]*/pwm1             # Fan is stopped (Value: 0)`\
`# echo 2 > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon[[:print:]]*/pwm1_enable      # Change fan mode to automatic`\
`# echo 1 > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon[[:print:]]*/pwm1_enable      # Change fan mode to manual`\
`# echo 0 > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon[[:print:]]*/pwm1_enable      # Change fan mode to full speed`

If you were able to modify fan speed with above commands, then continue with [#Generate configuration file with
pwmconfig](#Generate_configuration_file_with_pwmconfig "wikilink").

#### asus_fan

```{=mediawiki}
{{ic|asus_fan}}
```
is a kernel module, which allows to control both fans on some older ASUS laptops. It does not work with the most recent
models.

Install the [DKMS](DKMS "wikilink") `{{AUR|asus-fan-dkms-git}}`{=mediawiki} [kernel module](kernel_module "wikilink"),
providing `{{ic|asus_fan}}`{=mediawiki}:

`# modprobe asus_fan`

Check if you have any control over both fans:

`# echo 255 > /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/pwm1          # Full CPU fan speed (Value: 255)`\
`# echo 0 > /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/pwm1            # CPU fan is stopped (Value: 0)`\
`# echo 255 > /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/pwm2          # Full GFX fan speed (Value: 255)`\
`# echo 0 > /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/pwm2            # GFX fan is stopped (Value: 0)`\
`# echo 2 > /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/pwm1_enable     # Change CPU fan mode to automatic`\
`# echo 1 > /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/pwm1_enable     # Change CPU fan mode to manual`\
`# echo 2 > /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/pwm2_enable     # Change GFX fan mode to automatic`\
`# echo 1 > /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/pwm2_enable     # Change GFX fan mode to manual`\
`# cat /sys/devices/platform/asus_fan/hwmon/hwmon[[:print:]]*/temp1_input          # Display GFX temperature (will always be 0 when GFX is disabled/unused)`

If everything works, you can [load the module at boot](load_the_module_at_boot "wikilink") to automate this step.

### Generate configuration file with pwmconfig {#generate_configuration_file_with_pwmconfig}

If you get an error `{{ic|There are no working fan sensors, all readings are 0}}`{=mediawiki} while generating
configuration file with `{{ic|pwmconfig}}`{=mediawiki}, open first console and execute:

`# watch -n 1 "echo 2 > /sys/devices/platform/`***`kernel_module`***`/hwmon/hwmon[[:print:]]*/pwm`**`1`**`_enable"`

If you use `{{ic|asus_fan}}`{=mediawiki} kernel module and have 2nd fan, in second console:

`# watch -n 1 "echo 2 > /sys/devices/platform/`***`kernel_module`***`/hwmon/hwmon[[:print:]]*/pwm`**`2`**`_enable"`

And finally, in the third console:

`# pwmconfig`

Once you are done and the configuration file is generated, you should stop the first and second consoles. Continue with
[#Fancontrol (lm-sensors)](#Fancontrol_(lm-sensors) "wikilink"). After the configuration file is generated, you might
need to manually replace PWM values with full *sysfs* paths as they are used in these steps, because *hwmon* number
values might change after reboot.

### Alternative method using EC registers {#alternative_method_using_ec_registers}

If the above methods do not work for you, an alternative method is to directly write to certain registers in the
embedded controller (EC). Using the [EC-Probe tool](https://github.com/hirschmann/nbfc/wiki/EC-probing-tool), you can
set the fan mode to one of the three fan speed modes, provided your model offers such feature in Windows.

In ASUS FX504GD model setting the fan speed to one of the three modes uses these register values:

`# ec_probe write 0x5e 0x80 # silent mode`\
`# ec_probe write 0x5e 0x40 # balance mode`\
`# ec_probe write 0x5e 0xC0 # performance mode`

Here we write to register `{{ic|0x5e}}`{=mediawiki} that is responsible in setting the fan speed mode.

If these values do not work for you, run the *ec-probe* tool in monitor mode in Windows and try to identify which
register in the EC changes value when switching through fan speed modes.

### Setting thermal throttle policy {#setting_thermal_throttle_policy}

Instead of manually controlling fan speed using `{{ic|asus-nb-wmi}}`{=mediawiki}, it is also possible to set the
[thermal throttling
policy](https://patchwork.kernel.org/project/platform-driver-x86/patch/20191215142634.13888-1-leonmaxx@gmail.com/) to
have a more or less aggressive fan control policy. Possible values are `{{ic|0}}`{=mediawiki} (default),
`{{ic|1}}`{=mediawiki} (overboost), and `{{ic|2}}`{=mediawiki} (silent).

`# echo `*`number`*` > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon[[:print:]]*/throttle_thermal_policy`

### Fan control modes on certain TUF series laptops {#fan_control_modes_on_certain_tuf_series_laptops}

On certain ASUS TUF series laptops, performance and fan control modes can be changed using `{{ic|Fn+F5}}`{=mediawiki}.
The current mode can be viewed by running the following command:

`$ cat /sys/devices/platform/asus-nb-wmi/fan_boost_mode`

```{=mediawiki}
{{Note|On some laptops, this setting may instead be at {{ic|/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy}}.}}
```
You can view the value changing as you use press `{{ic|Fn+F5}}`{=mediawiki}. 0 is \"Normal Mode\", 1 is \"Performance
Mode\", 2 is most likely \"Silent
Mode\".[1](https://lore.kernel.org/lkml/72b3e0aa-d53a-8a82-1505-f4f00aa2bb46@gmail.com/) It is also possible to write
these values into the `{{ic|fan_boost_mode}}`{=mediawiki} file as root and have the desired effect.

This was tested on the ASUS TUF FX504GE and ASUS TUF FX504GD models and found to be working.

You can use `{{AUR|tuf-fan-boost-notification-git}}`{=mediawiki} to get notifications every time the FanSpeed mode gets
changed.

## AMDGPU sysfs fan control {#amdgpu_sysfs_fan_control}

[AMDGPU](AMDGPU "wikilink") kernel driver offers fan control for graphics cards via *hwmon* in *sysfs*.

### Manual fan control {#manual_fan_control}

To switch to manual fan control from automatic, run

`# echo "1" > /sys/class/drm/card0/device/hwmon/hwmon0/pwm1_enable`

Set up fan speed to e.g. 50% (100% are 255 PWM cycles, thus calculate desired fan speed percentage by multiplying its
value by 2.55):

`# echo "128" > /sys/class/drm/card0/device/hwmon/hwmon0/pwm1`

To reset to automatic fan control, run

`# echo "2" > /sys/class/drm/card0/device/hwmon/hwmon0/pwm1_enable`

```{=mediawiki}
{{Warning|Resetting fan speed to auto may not work due to a driver bug and instead a restart of the driver may be required as a workaround.}}
```
### Fan curves control {#fan_curves_control}

Newer AMD graphical cards such as RDNA3 graphical cards do not support manual fan control due to firmware limitations
[2](https://gitlab.freedesktop.org/drm/amd/-/issues/2764#note_2031564). For these cases AMD provides a *fan_curve* sysfs
api for controlling the fan curves, for more information on it see
[3](https://docs.kernel.org/gpu/amdgpu/thermal.html#fan-curve).

### amdgpu-fan {#amdgpu_fan}

The `{{AUR|amdgpu-fan}}`{=mediawiki} package is an automated fan controller for AMDGPU-enabled video cards written in
Python. It uses a \"speed-matrix\" to match the frequency of the fans with the temperature of the GPU, for example:

```{=mediawiki}
{{bc|
speed_matrix:  # -[temp(*C), speed(0-100%)]
- [0, 0]
- [40, 30]
- [60, 50]
- [80, 100]
}}
```
Launch the fan control service by [starting/enabling](starting/enabling "wikilink")
`{{ic|amdgpu-fan.service}}`{=mediawiki}.

### amdfand-bin {#amdfand_bin}

Then `{{AUR|amdfand-bin}}`{=mediawiki} package is a native alternative to `{{AUR|amdgpu-fan}}`{=mediawiki}. Launch the
fan control service by [starting/enabling](starting/enabling "wikilink") `{{ic|amdfand.service}}`{=mediawiki}.

For this tool there are also GUI clients available: `{{AUR|amdguid-glow-bin}}`{=mediawiki} (Xorg) and
`{{AUR|amdguid-wayland-bin}}`{=mediawiki} (Wayland). Before starting the client you need to
[enable/start](enable/start "wikilink") `{{ic|amdgui-helper.service}}`{=mediawiki}.

### fancurve script {#fancurve_script}

Not just fan controls are offered via *hwmon* in *sysfs*, but also GPU temperature reading:

`# cat /sys/class/drm/card0/device/hwmon/hwmon0/temp1_input`

This outputs GPU temperature in °C + three zeroes, e.g. `{{ic|33000}}`{=mediawiki} for 33°C.

The bash script [amdgpu-fancontrol](https://github.com/grmat/amdgpu-fancontrol) by grmat offers a fully automatic fan
control by using the described *sysfs hwmon* functionality. It also allows to comfortably adjust the fancurve\'s
temperature/PWM cycles assignments and a hysteresis by offering abstracted configuration fields at the top of the
script.

```{=mediawiki}
{{Tip|In order to function correctly, the script needs at least three defined temperature/PWM cycles assignments.}}
```
For safety reasons, the script sets fan control again to auto when shutting down. This may cause spinning up of fans,
which can be worked around at cost of security by setting `{{ic|set_fanmode 1}}`{=mediawiki} in the section
`{{ic|function reset_on_fail}}`{=mediawiki}.

#### Setting up fancurve script {#setting_up_fancurve_script}

To start the script, it is recommend to do so via [systemd](systemd "wikilink") init system. This way the script\'s
verbose output can be read via [journalctl](journalctl "wikilink")/systemctl status. For this purpose, a *.service* unit
file is already included in the GitHub repository.

It may also be required to restart the script via a
[root-resume.service](Power_management/Suspend_and_hibernate#Sleep_hooks "wikilink") after hibernation in order to make
it automatically function properly again:

```{=mediawiki}
{{hc|/etc/systemd/system/root-resume.service|2=
[Unit]
Description=Local system resume actions
After=suspend.target

[Service]
Type=simple
ExecStart=/usr/bin/systemctl restart amdgpu-fancontrol.service

[Install]
WantedBy=suspend.target
}}
```
## Others

-   ```{=mediawiki}
    {{AUR|fan2go-git}}
    ```
    --- An alternative to Fancontrol independent of device-paths.

-   ```{=mediawiki}
    {{AUR|mcontrolcenter-bin}}
    ```
    --- Fan control application for MSI laptops.

-   ```{=mediawiki}
    {{AUR|fw-ectool-git}}
    ```
    --- Fan configuration for [Framework Laptops](Framework_Laptop "wikilink").

-   ```{=mediawiki}
    {{AUR|CoolerControl}}
    ```
    --- A fan control daemon with GUI for *sysfs* and `{{Pkg|liquidctl}}`{=mediawiki} devices.

-   ```{=mediawiki}
    {{AUR|controlfans-git}}
    ```
    --- Simple GUI written in Qt to configure FAN PWM via HWMON interface. You could use it to setup the kernel auto
    point for every FAN who support it.

## Troubleshooting

### Increase the fan divisor for sensors {#increase_the_fan_divisor_for_sensors}

If *sensors* does not output the CPU fan RPM, it may be necessary to change the fan divisor.

The first line of the *sensors* output is the chipset used by the motherboard for readings of temperatures and voltages.

Create a file in `{{ic|/etc/sensors.d/}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/sensors.d/fan-speed-control.conf|
chip "''coretemp-isa-''*"
set fan''X''_div 4
}}
```
Replacing `{{ic|''coretemp-isa-''}}`{=mediawiki} with name of the chipset and `{{ic|''X''}}`{=mediawiki} with the number
of the CPU fan to change.

Save the file, and run as root:

`# sensors -s`

which will reload the configuration files.

Run `{{ic|sensors}}`{=mediawiki} again, and check if there is an RPM readout. If not, increase the divisor to 8, 16, or
32. Your mileage may vary.

### Device paths have changed in /etc/fancontrol {#device_paths_have_changed_in_etcfancontrol}

The enumerated *hwmon* symlinks located in `{{ic|/sys/class/hwmon/}}`{=mediawiki} might vary in order because the kernel
modules do not load in a consistent order per boot. Because of this, it may cause fancontrol to not function correctly.
The error is \"Configuration appears to be outdated, please run pwmconfig again\". [Upstream
bug](https://github.com/lm-sensors/lm-sensors/issues/227).

#### Solution

In `{{ic|/etc/conf.d/lm_sensors}}`{=mediawiki}, there are 2 arrays that list all of the modules detected when you
execute `{{ic|sensors-detect}}`{=mediawiki}. These get loaded in by fancontrol. If the file does not exist, run
`{{ic|sensors-detect}}`{=mediawiki} as root, accepting the defaults. Open (or create)
`{{ic|/etc/modules-load.d/modules.conf}}`{=mediawiki}. Get all of the modules listed from the 2 variables in
`{{ic|/etc/conf.d/lm_sensors}}`{=mediawiki} and place them into the
`{{ic|/etc/modules-load.d/modules.conf}}`{=mediawiki} file, one module per line. Specifying them like this should make a
defined order for the modules to load in, which should make the *hwmon* paths stay where they are and not change orders
for every boot. If this does not work, I highly recommend finding another program to control your fans. If you cannot
find any, then you could try using the alternative solution below.

#### Alternative solution: absolute paths {#alternative_solution_absolute_paths}

Using absolute file paths in fancontrol does not work by default, as its helper script `{{ic|pwmconfig}}`{=mediawiki} is
programmed to only use the *hwmon* paths to get the files. The way it does this is that it detects whether the *hwmon*
path that is provided in its configuration file `{{ic|/etc/fancontrol}}`{=mediawiki} did not change, and uses the
variables `{{ic|DEVNAME}}`{=mediawiki} and `{{ic|DEVPATH}}`{=mediawiki} to determine such change. If your *hwmon* paths
keep changing, this will prevent fancontrol from running no matter what you do. However, one can circumvent this
problem. Open `{{ic|/usr/bin/fancontrol}}`{=mediawiki}, and comment out this part of the script:

`if [ "$DIR" = "/" -a -n "$DEVPATH" ]`\
`then`\
`   echo "Unneeded DEVPATH with absolute device paths" >&2`\
`   exit 1`\
`fi`\
`if ! ValidateDevices "$DEVPATH" "$DEVNAME"`\
` then`\
`     echo "Configuration appears to be outdated, please run pwmconfig again" >&2`\
`     exit 1`\
` fi`

```{=mediawiki}
{{Note|
* Doing this may make ''fancontrol'' write into files you gave it in the configuration file, no matter what the file is. This can corrupt files if you provide the wrong path. Be sure that you are using the correct path for your files.
* Another thing to note is that while doing this workaround, using ''pwmconfig'' to create your script again will overwrite all of your absolute paths that you have configured. Therefore, it is better to manually change the old paths to the new paths if it is needed instead of using ''pwmconfig''.
}}
```
Commenting this out should effectively ignore the *hwmon* validation checks. You can also ignore the variables
`{{ic|DEVNAME}}`{=mediawiki} and `{{ic|DEVPATH}}`{=mediawiki} in the configuration file as well. After this, replace all
of the *hwmon* paths in the other variables with its absolute path. To make it easier, rerun
`{{ic|pwmconfig}}`{=mediawiki} with root privileges to refresh the *hwmon* devices. The *hwmon* paths in the
configuration file should now point to the correct absolute paths. For each *hwmon* path, run the following command
(where `{{ic|''N''}}`{=mediawiki} is the enumeration of the *hwmon* path):

`$ readlink -f /sys/class/hwmon/hwmon`*`N`*`/device`

This will give you the absolute path of the device.

For example, an `{{ic|/etc/fancontrol}}`{=mediawiki} file lists `{{ic|FCTEMPS}}`{=mediawiki} as this:

`FCTEMPS=hwmon2/pwm1=hwmon3/temp1_input`

Executing `{{ic|readlink -f /sys/class/hwmon/hwmon3/device}}`{=mediawiki} can, for example, output
`{{ic|/sys/devices/platform/coretemp.0/}}`{=mediawiki}. `{{ic|cd}}`{=mediawiki} into this directory. If you see a
`{{ic|/hwmon/hwmon''N''/}}`{=mediawiki} directory, you have to do this in your *fancontrol* configuration file to
replace the `{{ic|hwmon''N''}}`{=mediawiki} path. From the previous example:

`# BEFORE`\
`FCTEMPS=hwmon2/pwm1=hwmon3/temp1_input`\
`# AFTER`\
`FCTEMPS=hwmon2/pwm1=/sys/devices/platform/coretemp.0/hwmon/[[:print:]]*/temp1_input`

Essentially, you must replace the *hwmon* path with the absolute path, concatenated with
`{{ic|/hwmon/<nowiki>[[:print:]]*</nowiki>/}}`{=mediawiki} so that bash can catch the random enumerated *hwmon* name.

If you do not see the `{{ic|/hwmon/hwmon''N''/}}`{=mediawiki} directory, then you do not have to worry about this. This
means that the temperature files are in the root of the device directory. Just replace `{{ic|hwmon''N''/}}`{=mediawiki}
with the absolute file path. For example:

`# BEFORE`\
`FCTEMPS=hwmon2/pwm1=hwmon3/temp1_input`\
`# AFTER`\
`FCTEMPS=hwmon2/pwm1=/sys/devices/platform/coretemp.0/temp1_input`

After replacing all of paths, *fancontrol* should work fine.

[Category:CPU](Category:CPU "wikilink") [Category:Graphics](Category:Graphics "wikilink")

[hu:Gamepad](hu:Gamepad "wikilink") [ja:ゲームパッド](ja:ゲームパッド "wikilink")
[zh-hans:游戏手柄](zh-hans:游戏手柄 "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|List of games}}`{=mediawiki} `{{Related|Video game platform emulators}}`{=mediawiki}
`{{Related|Gaming}}`{=mediawiki} `{{Related articles end}}`{=mediawiki} Many gamepads are working out-of-the-box
nowadays, but there are still many potential problems and sources for errors since gamepad support in applications
varies by a lot.

```{=mediawiki}
{{Expansion|Need info about differences between API, how to switch between them.|section=Joystick API vibration support}}
```
Linux has two different input systems for gamepads -- the original Joystick interface and the newer evdev-based
interface.

```{=mediawiki}
{{ic|1=/dev/input/jsX}}
```
maps to the Joystick API interface and `{{ic|/dev/input/event*}}`{=mediawiki} maps to the evdev ones (this also includes
other input devices such as mice and keyboards). Symbolic links to those devices are also available in
`{{ic|/dev/input/by-id/}}`{=mediawiki} and `{{ic|/dev/input/by-path/}}`{=mediawiki} where the legacy Joystick API has
names ending with `{{ic|-joystick}}`{=mediawiki} while the evdev have names ending with
`{{ic|-event-joystick}}`{=mediawiki}.

Most new games will default to the evdev interface as it gives more detailed information about the buttons and axes
available and also adds support for force feedback.

Many applications use SDL to access gamepads.

-   SDL1 defaults to the evdev interface, but it can be forced to use Joystick by setting the environment variable
    `{{ic|1=SDL_JOYSTICK_DEVICE=/dev/input/js0}}`{=mediawiki}.
-   SDL2 and SDL3 default to using hidapi on the most popular controllers in order to get raw access. On other
    controllers, or if hidapi is disabled, they use evdev instead.

SDL itself offers different APIs, the selection of which depends on the application. Their usage is not mutually
exclusive.

-   ```{=mediawiki}
    {{ic|SDL_Joystick}}
    ```
    is supported in all versions and maps the evdev (or Joystick) events 1:1 with SDL\'s own.

-   ```{=mediawiki}
    {{ic|SDL_GameController}}
    ```
    , supported on SDL2, offers standardardized mapping between devices. For a controller to be supported, it needs an
    evdev:SDL mapping in a database, `{{ic|gamecontrollerdb.txt}}`{=mediawiki}. This API is replaced with
    `{{ic|SDL_Gamepad}}`{=mediawiki} in SDL3.

## Installation

Unless you are using very old joystick that uses [Gameport](Wikipedia:Game_port "wikilink") or a proprietary USB
protocol, you will need just the generic USB Human Interface Device (HID) modules.

For an extensive overview of all joystick related modules in Linux, you will need access to the Linux kernel sources ---
specifically the Documentation section. Unfortunately, official kernel packages do not include what we need. If you have
the kernel sources downloaded, have a look at `{{ic|Documentation/input/joydev/}}`{=mediawiki}. You can browse the
kernel source tree at [kernel.org](https://kernel.org/) by clicking the \"browse\" (cgit - the git frontend) link for
the kernel that you are using, then clicking the \"tree\" link near the top. Alternatively, see [documentation from the
latest kernel](https://docs.kernel.org/input/joydev/joystick.html).

Some joysticks need specific modules, such as the Microsoft Sidewinder controllers (`{{ic|sidewinder}}`{=mediawiki}), or
the Logitech digital controllers (`{{ic|adi}}`{=mediawiki}). Many older joysticks will work with the simple
`{{ic|analog}}`{=mediawiki} module. If your joystick is plugging in to a gameport provided by your soundcard, you will
need your soundcard drivers loaded --- however, some cards, like the Soundblaster Live, have a specific gameport driver
(`{{ic|emu10k1-gp}}`{=mediawiki}). Older ISA soundcards may need the `{{ic|ns558}}`{=mediawiki} module, which is a
standard gameport module.

As you can see, there are many different modules related to getting your joystick working in Linux, so everything is not
covered here. Please have a look at the documentation mentioned above for details.

### Loading the modules for analogue devices {#loading_the_modules_for_analogue_devices}

You need to load a module for your gameport (`{{ic|ns558}}`{=mediawiki}, `{{ic|emu10k1-gp}}`{=mediawiki},
`{{ic|cs461x}}`{=mediawiki}, etc\...), a module for your joystick (`{{ic|analog}}`{=mediawiki},
`{{ic|sidewinder}}`{=mediawiki}, `{{ic|adi}}`{=mediawiki}, etc\...), and finally the kernel joystick device driver
(`{{ic|joydev}}`{=mediawiki}). You can [load the module at boot](load_the_module_at_boot "wikilink"), or simply
[modprobe](modprobe "wikilink") it. The `{{ic|gameport}}`{=mediawiki} module should load automatically, as this is a
dependency of the other modules.

### USB gamepads {#usb_gamepads}

You need to get USB working, and then modprobe your gamepad driver, which is `{{ic|usbhid}}`{=mediawiki}, as well as
`{{ic|joydev}}`{=mediawiki}. If you use a usb mouse or keyboard, `{{ic|usbhid}}`{=mediawiki} will be loaded already and
you just have to load the `{{ic|joydev}}`{=mediawiki} module.

```{=mediawiki}
{{Note|If your Xbox 360 gamepad is connected with the Play&Charge USB cable it will show up in {{ic|lsusb}} but it will not show up as an input device in {{ic|/dev/input/js*}}, see [[#Xbox 360 controller]].}}
```
## Configuration

### Testing

Once the modules are loaded, you should be able to find a new device: `{{ic|/dev/input/js0}}`{=mediawiki} and a file
ending with `{{ic|-event-joystick}}`{=mediawiki} in `{{ic|/dev/input/by-id}}`{=mediawiki} directory. You can simply
`{{ic|cat}}`{=mediawiki} those devices to see if the joystick works --- move the stick around, press all the buttons -
you should see mojibake printed when you move the sticks or press buttons.

If you get a permission error, see [#Device permissions](#Device_permissions "wikilink").

[Wine](Wine "wikilink") uses SDL for both DirectInput and XInput emulation, with evdev as a fallback. You can test them
with `{{ic|wine control joy.cpl}}`{=mediawiki}. For PlayStation 4 and 5 controllers, see [#Using with
Wine](#Using_with_Wine "wikilink").

#### Joystick API {#joystick_api}

There are a lot of applications that can test this old API, `{{ic|jstest}}`{=mediawiki} from the
`{{Pkg|joyutils}}`{=mediawiki} package is the simplest one. If the output is unreadable because the line printed is too
long you can also use graphical tools. KDE Plasma has a built in one in *System Settings \> Input Devices \> Game
Controller*. There is `{{AUR|jstest-gtk-git}}`{=mediawiki} as an alternative.

Use of `{{ic|jstest}}`{=mediawiki} is fairly simple, you just run `{{ic|jstest /dev/input/js0}}`{=mediawiki} and it will
print a line with state of all the axes (normalised to `{{ic|{-32767,32767}<nowiki/>}}`{=mediawiki}) and buttons.

After you start `{{ic|jstest-gtk}}`{=mediawiki}, it will just show you a list of joysticks available, you just need to
select one and press Properties.

#### evdev API {#evdev_api}

The \'evdev\' API can be tested using `{{ic|evtest}}`{=mediawiki} from `{{Pkg|evtest}}`{=mediawiki} or
`{{ic|evtest-qt}}`{=mediawiki} from `{{AUR|evtest-qt-git}}`{=mediawiki}.

To test force feedback on the device, use `{{ic|fftest}}`{=mediawiki} from `{{Pkg|linuxconsole}}`{=mediawiki}:

`$ fftest /dev/input/by-id/usb-*event-joystick`

#### SDL APIs {#sdl_apis}

Install `{{AUR|sdl-jstest-git}}`{=mediawiki}. If more than one controller is connected, use
`{{ic|sdl2-jstest --list}}`{=mediawiki} to get their ID.

To test the `{{ic|SDL_Joystick}}`{=mediawiki} API on device index 0:

`$ sdl2-jstest --test 0`

To test the `{{ic|SDL_GameController}}`{=mediawiki} API instead:

`$ sdl2-jstest --gamecontroller 0`

#### HTML5 Gamepad API {#html5_gamepad_api}

Go to <https://gamepad-tester.com/>. Currently, testing vibration and producing a visual of the gamepad is supported in
[Chromium](Chromium "wikilink") but not [Firefox](Firefox "wikilink"). Additionally, as of version 107.0.5304.121-1,
Chromium can read Joystick devices but not evdev.

### Setting up deadzones and calibration {#setting_up_deadzones_and_calibration}

```{=mediawiki}
{{Expansion|Describe calibration instructions for evdev|section=Unclear instructions on how to calibrate}}
```
If you want to set up the deadzones (or remove them completely) of your analog input you have to do it separately for
the xorg (for mouse and keyboard emulation), Joystick API and evdev API.

#### Wine deadzones {#wine_deadzones}

Add the following registry entry and set it to a string from `{{ic|0}}`{=mediawiki} to `{{ic|10000}}`{=mediawiki}
(affects all axes):

`HKEY_CURRENT_USER\Software\Wine\DirectInput\DefaultDeadZone`

Source: [Useful Registry Keys](https://gitlab.winehq.org/wine/wine/-/wikis/Useful-Registry-Keys)

#### Xorg deadzones {#xorg_deadzones}

Add a similar line to `{{ic|/etc/X11/xorg.conf.d/51-joystick.conf}}`{=mediawiki} (create if it does not exist):

```{=mediawiki}
{{hc|1=/etc/X11/xorg.conf.d/51-joystick.conf|2=
Section "InputClass"
    Option "MapAxis1" "deadzone=1000"
EndSection
}}
```
```{=mediawiki}
{{ic|1000}}
```
is the default value, but you can set anything between `{{ic|0}}`{=mediawiki} and `{{ic|30000}}`{=mediawiki}. To get the
axis number see the \"Testing Your Configuration\" section of this article. If you already have an option with a
specific axis just type in the `{{ic|1=deadzone=value}}`{=mediawiki} at the end of the parameter separated by a space.

#### Joystick API deadzones and calibration {#joystick_api_deadzones_and_calibration}

The easiest way is using *jstest-gtk* from `{{AUR|jstest-gtk-git}}`{=mediawiki}. Select the joystick you want to edit,
click the *Properties* button. On this new window, click the *Calibration* button (**do not** click *Start Calibration*
after that). You can then set the `{{ic|CenterMin}}`{=mediawiki} and `{{ic|CenterMax}}`{=mediawiki} values, which
control the center deadzone, and `{{ic|RangeMin}}`{=mediawiki} and `{{ic|RangeMax}}`{=mediawiki}, which control the end
of throw deadzones. Note that the calibration settings are applied when the application opens the device, so you need to
restart your game or test application to see updated calibration settings.

After you set the deadzones, you also can create an [udev](udev "wikilink") rule to make all changes permanent:

First, grab the vendor id of your joystick (replace `{{ic|''X''}}`{=mediawiki} with your joystick\'s number, it is
usually `{{ic|0}}`{=mediawiki}):

`$ udevadm info -q property --property ID_VENDOR_ID --value /dev/input/js`*`X`*

Also grab the model id:

`$ udevadm info -q property --property ID_MODEL_ID --value /dev/input/js`*`X`*

If the commands above give you an empty output, it could be because your controller is connected via Bluetooth, making
these unique attributes only visible on the parent device(s). To mitigate this, you could try finding other unique
attributes by running:

`$ udevadm info -a /dev/input/js`*`X`*

This will list all available attributes from your device (and parent devices). So, for example, if the parent device of
your joystick has the attribute `{{ic|1=ATTRS{uniq}=="a0:b1:c2:d3:e4:f5"}}`{=mediawiki}, or maybe both
`{{ic|1=ATTRS{idVendor}=="054c"}}`{=mediawiki} and `{{ic|1=ATTRS{idProduct}=="09cc"}}`{=mediawiki}, then you can use
these instead of `{{ic|ENV{ID_VENDOR_ID} }}`{=mediawiki} and `{{ic|ENV{ID_MODEL_ID} }}`{=mediawiki} in the *udev* rule
below.

You can also have both rules at the same time, just separate them with a new line.

Anyway, now use *jscal* to dump the new calibration settings of your joystick:

`$ jscal -p /dev/input/js`*`X`*

Now, modify this *udev* rule with the values you got:

```{=mediawiki}
{{hc|1=/etc/udev/rules.d/85-jscal-custom-calibration.rules|2=
ACTION=="add", KERNEL=="js[0-9]*", ENV{ID_VENDOR_ID}=="054c", ENV{ID_MODEL_ID}=="09cc", RUN+="/usr/bin/jscal -s 1,1,1,1 /dev/input/js%n"
}}
```
This rule will automatically run `{{ic|/usr/bin/jscal -s 1,1,1,1 /dev/input/js%n}}`{=mediawiki} whenever you connect a
joystick with vendor id `{{ic|054c}}`{=mediawiki} and model id `{{ic|09cc}}`{=mediawiki}. The
`{{ic|/dev/input/js%n}}`{=mediawiki} part is required to automatically determine the correct joystick, so **do not**
remove it.

Finally, [load](Udev#Loading_new_rules "wikilink") this new *udev* rule.

#### evdev API deadzones and calibration {#evdev_api_deadzones_and_calibration}

The *evdev-joystick* tool from the `{{Pkg|linuxconsole}}`{=mediawiki} package can be used to view and change deadzones
and calibration for `{{ic|evdev}}`{=mediawiki} API devices.

To view your device configuration:

`$ evdev-joystick --showcal /dev/input/by-id/usb-*-event-joystick`

To change the deadzone for a particular axis, use a command like:

`$ evdev-joystick --evdev /dev/input/by-id/usb-*-event-joystick --axis 0 --deadzone 0`

To set the same deadzone for all axes at once, omit the `{{ic|--axis 0}}`{=mediawiki} option.

Use udev rules file to set them automatically when the controller is connected.

Note that inside the kernel, the value is called `{{ic|flatness}}`{=mediawiki} and is set using the
`{{ic|EVIOCSABS}}`{=mediawiki} `{{ic|ioctl}}`{=mediawiki}.

Default configuration will look like similar to this:

```{=mediawiki}
{{hc|$ evdev-joystick --showcal /dev/input/by-id/usb-Madcatz_Saitek_Pro_Flight_X-55_Rhino_Stick_G0000090-event-joystick|2= Supported Absolute axes:
   Absolute axis 0x00 (0) (X Axis) (min: 0, max: 65535, flatness: 4095 (=6.25%), fuzz: 255)
   Absolute axis 0x01 (1) (Y Axis) (min: 0, max: 65535, flatness: 4095 (=6.25%), fuzz: 255)
   Absolute axis 0x05 (5) (Z Rate Axis) (min: 0, max: 4095, flatness: 255 (=6.23%), fuzz: 15)
   Absolute axis 0x10 (16) (Hat zero, x axis) (min: -1, max: 1, flatness: 0 (=0.00%), fuzz: 0)
   Absolute axis 0x11 (17) (Hat zero, y axis) (min: -1, max: 1, flatness: 0 (=0.00%), fuzz: 0)
}}
```
While a more reasonable setting would be achieved with something like this (repeat for other axes):

```{=mediawiki}
{{hc|$ evdev-joystick --evdev /dev/input/by-id/usb-Madcatz_Saitek_Pro_Flight_X-55_Rhino_Stick_G0000090-event-joystick --axis 0 --deadzone 512|2= Event device file: /dev/input/by-id/usb-Madcatz_Saitek_Pro_Flight_X-55_Rhino_Stick_G0000090-event-joystick
 Axis index to deal with: 0
 New dead zone value: 512
 Trying to set axis 0 deadzone to: 512
   Absolute axis 0x00 (0) (X Axis) Setting deadzone value to : 512
 (min: 0, max: 65535, flatness: 512 (=0.78%), fuzz: 255)
}}
```
#### xboxdrv deadzones and calibration {#xboxdrv_deadzones_and_calibration}

Example command for creating a virtual Xbox 360 controller, with the `{{ic|Y1}}`{=mediawiki} axis set with deadzone
`{{ic|4000}}`{=mediawiki}, minimum readable value `{{ic|-32768}}`{=mediawiki}, center `{{ic|128}}`{=mediawiki}, and
maximum `{{ic|29000}}`{=mediawiki}.

`# xboxdrv --deadzone 4000 --calibration Y1=-32768:128:29000`

See `{{man|1|xboxdrv|AXIS FILTER|url=https://manned.org/man/xboxdrv#head6}}`{=mediawiki} for more options.

### Disable joystick from controlling mouse {#disable_joystick_from_controlling_mouse}

If you want to play games with your gamepad, you might want to disable its joystick control over mouse cursor.

The simplest way is to disable the mouse device in the [desktop environment](desktop_environment "wikilink") settings.
Otherwise, edit `{{ic|/etc/X11/xorg.conf.d/51-joystick.conf}}`{=mediawiki} (create if it does not exists) so that it
looks like this:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/51-joystick.conf |
Section "InputClass"
        Identifier "joystick catchall"
        MatchIsJoystick "on"
        MatchDevicePath "/dev/input/event*"
        Driver "joystick"
        '''Option "StartKeysEnabled" "False"'''
        '''Option "StartMouseEnabled" "False"'''
EndSection}}
```
### Using gamepad to send keystrokes {#using_gamepad_to_send_keystrokes}

Some of the generic [input remap utilities](input_remap_utilities "wikilink"), such as Input Remapper, work for mapping
gamepad buttons to keyboard keys. Gamepad-specific tools for this include:

-   ```{=mediawiki}
    {{AUR|qjoypad}}
    ```

-   ```{=mediawiki}
    {{Pkg|antimicrox}}
    ```

-   ```{=mediawiki}
    {{Pkg|sc-controller}}
    ```

-   ```{=mediawiki}
    {{Pkg|steam}}
    ```
    \- see [Steam#Steam Input](Steam#Steam_Input "wikilink")

All work well without the need for additional X.org configuration.

#### Xorg configuration example {#xorg_configuration_example}

This is a good solution for systems where restarting Xorg is a rare event because it is a static configuration loaded
only on X startup. The example runs on a [Kodi](Kodi "wikilink") media PC, controlled with a Logitech Cordless RumblePad
2. Due to a problem with the d-pad (a.k.a. \"hat\") being recognized as another axis, [Joy2key](Joy2key "wikilink") was
used as a workaround. Since `{{Pkg|kodi}}`{=mediawiki} version 11.0 and `{{AUR|joy2key}}`{=mediawiki} 1.6.3-1, this
setup no longer worked and the following was created for letting Xorg handle joystick events.

First, [install](install "wikilink") the `{{AUR|xf86-input-joystick}}`{=mediawiki} package. Then, create an X
configuration file:

```{=mediawiki}
{{hc|/etc/X11/xorg.conf.d/51-joystick.conf|2=
 Section "InputClass"
  Identifier "Joystick hat mapping"
  Option "StartKeysEnabled" "True"
  #MatchIsJoystick "on"
  Option "MapAxis5" "keylow=113 keyhigh=114"
  Option "MapAxis6" "keylow=111 keyhigh=116"
 EndSection
}}
```
```{=mediawiki}
{{Note|The {{ic|MatchIsJoystick "on"}} line does not seem to be required for the setup to work, but you may want to uncomment it.}}
```
### Remapping of gamepad buttons and more {#remapping_of_gamepad_buttons_and_more}

With some programs you can also configure your gamepad further, including the following potential features:

-   Remapping buttons and axes.
    -   Assigning mapping profiles to different games.
-   Emulating a different type of gamepad. Some software can often behave better when given an Xbox 360 Controller, as
    this is a very common controller that many games have been tested with.
-   Additional functionality such as Macros, On-Screen-Displays etc.

List of software:

-   ```{=mediawiki}
    {{App|SC Controller|Open-source software supporting button remapping and Xbox 360 Controller emulation.|https://github.com/Ryochan7/sc-controller|{{Pkg|sc-controller}}}}
    ```

-   ```{=mediawiki}
    {{App|[[Steam]]|Proprietary storefront whose client supports rebinding gamepad inputs via [https://partner.steamgames.com/doc/features/steam_controller Steam Input]. When enabled, Steam exposes a Steam Controller to games that opt into the Steam Input API, as well as an emulated Xbox 360 Controller to games using traditional gamepad APIs. See [[Steam#Steam Input]] for further details.|https://store.steampowered.com/about/|{{Pkg|steam}}}}
    ```

-   ```{=mediawiki}
    {{App|xboxdrv|Xbox 360 controller driver which supports emulating the controller from a different input controller. See [[#Mimic Xbox 360 controller]]. It is also a flexible option for remapping and calibration.|https://github.com/xiota/xboxdrv|{{AUR|xboxdrv}}}}
    ```

#### Remapping of gamepad on SDL2 applications {#remapping_of_gamepad_on_sdl2_applications}

Gamepads can be remapped for SDL2 applications using the `{{ic|SDL_GAMECONTROLLERCONFIG}}`{=mediawiki} environment
variable. For each line, it includes the gamepad\'s GUID, a name, button / axis mappings and a platform. The
controller\'s GUID can be retrieved by installing `{{AUR|sdl-jstest-git}}`{=mediawiki} and then running
`{{ic|sdl2-jstest --list}}`{=mediawiki}.

For example, to map Microsoft Xbox 360 controllers with different GUIDs:

```{=mediawiki}
{{hc|~/.bashrc|2=export SDL_GAMECONTROLLERCONFIG="
030000005e0400008e02000001000000,Microsoft Xbox 360,a:b0,b:b1,back:b6,dpdown:h0.1,dpleft:h0.2,dpright:h0.8,dpup:h0.4,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,platform:Linux,
030000005e0400008e02000004010000,Microsoft Xbox 360,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b8,leftshoulder:b4,leftstick:b9,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b10,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,platform:Linux,
"}}
```
Some apps extract mapping information from a `{{ic|gamecontrollerdb.txt}}`{=mediawiki} file. It can be edited
graphically with `{{AUR|controllermap}}`{=mediawiki}. An up to date database can be found on
[1](https://github.com/gabomdq/SDL_GameControllerDB).

#### Mimic Xbox 360 controller {#mimic_xbox_360_controller}

[#xboxdrv](#xboxdrv "wikilink") can be used to make any controller register as an Xbox 360 controller with the
`{{ic|--mimic-xpad}}`{=mediawiki} switch. This may be desirable for games that support Xbox 360 controllers out of the
box, but have trouble detecting or working with other gamepads.

You can mimic an Xbox 360 controller with the following command:

`$ xboxdrv --evdev /dev/input/event* --evdev-absmap ABS_RX=X2 --evdev-keymap BTN_THUMB2=a,BTN_THUMB=b,BTN_PINKIE=rt --mimic-xpad`

The above example is incomplete. It only maps one axis and 3 buttons for demonstration purposes. Use
`{{ic|xboxdrv --help-button}}`{=mediawiki} to see the names of the Xbox controller buttons and axes and bind them
accordingly by expanding the command above. Axes mappings should go after `{{ic|--evdev-absmap}}`{=mediawiki} and button
mappings follow `{{ic|--evdev-keymap}}`{=mediawiki} (comma separated list; no spaces).

By default, `{{ic|xboxdrv}}`{=mediawiki} outputs all events to the terminal. You can use this to test that the mappings
are correct. Append the `{{ic|--silent}}`{=mediawiki} option to keep it quiet.

## Specific devices {#specific_devices}

While most gamepads, especially USB based ones should just work, some may require (or give better results) if you use
alternative drivers.

### Dance pads {#dance_pads}

Most dance pads should work. However some pads, especially those used from a video game console via an adapter, have a
tendency to map the directional buttons as axis buttons. This prevents hitting left-right or up-down simultaneously.
This behavior can be fixed for devices recognized by xpad via a module option:

`# modprobe -r xpad`\
`# modprobe xpad dpad_to_buttons=1`

If that did not work, you can try `{{AUR|axisfix-git}}`{=mediawiki} or patching the `{{ic|joydev}}`{=mediawiki} kernel
module (https://github.com/adiel-mittmann/dancepad).

### Logitech Thunderpad Digital {#logitech_thunderpad_digital}

Logitech Thunderpad Digital will not show all the buttons if you use the `{{ic|analog}}`{=mediawiki} module. Use the
device specific `{{ic|adi}}`{=mediawiki} module for this controller.

### Nintendo Gamecube Controller {#nintendo_gamecube_controller}

Dolphin Emulator has a [page on their
wiki](https://wiki.dolphin-emu.org/index.php?title=How_to_use_the_Official_GameCube_Controller_Adapter_for_Wii_U_in_Dolphin)
that explains how to use the official Nintendo USB adapter with a GameCube controller. This configuration also works
with the Mayflash Controller Adapter if the switch is set to \"Wii U\".

For other applications, you can use `{{AUR|wii-u-gc-adapter}}`{=mediawiki}.

### Nintendo Switch Pro Controller and Joy-Cons {#nintendo_switch_pro_controller_and_joy_cons}

These controllers are supported since kernel version 5.16. The Switch Online NES, SNES and N64 controllers are also
supported since kernel version 6.12.

For earlier kernel versions, it is possible to install the [DKMS](DKMS "wikilink") module
`{{AUR|hid-nintendo-nso-dkms}}`{=mediawiki}.

#### Userspace Daemon {#userspace_daemon}

```{=mediawiki}
{{AUR|joycond-git}}
```
is a userspace daemon that provides better integration for Nintendo Switch Controllers. When the daemon is active,
Switch controllers placed in a pairing mode (LEDs flashing) can have both their triggers pressed to be paired, and then
ready to be used by apps. See [2](https://github.com/DanielOgorchock/joycond?tab=readme-ov-file#usage).

#### Use Joy-Cons as one device {#use_joy_cons_as_one_device}

The `{{ic|hid-nintendo}}`{=mediawiki} kernel driver handles two Joy-Cons as two separate devices.

To pair two Joy-Cons together, make sure `{{ic|joycond}}`{=mediawiki} is running and both Joy-Cons are in pairing mode.
Then, press one trigger on each Joy-Con at the same time.

#### Use positional layout on SDL2 applications {#use_positional_layout_on_sdl2_applications}

By default, SDL2 maps buttons on Nintendo controllers according to the gamepad\'s label instead of the button\'s
position. This causes the mapping of the buttons A/B and X/Y to be swapped compared to other controllers. If this is
undesirable, set the [environment variable](environment_variable "wikilink")
`{{ic|1=SDL_GAMECONTROLLER_USE_BUTTON_LABELS=0}}`{=mediawiki}.

Starting from SDL3, mapping is always positional.[3](https://github.com/slouken/SDL/blob/main/docs/README-migration.md)
Note that `{{Pkg|sdl2-compat}}`{=mediawiki} preserves the old
behavior.[4](https://github.com/libsdl-org/sdl2-compat/blob/ed7e8bd5b169f379d7b1ba57b242657bc3455ebb/src/sdl2_compat.c#L2020-L2024)

### Steam Controller {#steam_controller}

```{=mediawiki}
{{Note|Kernel 4.18 [https://lore.kernel.org/lkml/20180416122703.22306-1-rodrigorivascosta@gmail.com/ provides a kernel driver] for wired/wireless use of the steam controller as a controller input device without [[Steam]].}}
```
The [Steam](Steam "wikilink") client will recognize the controller and provide keyboard/mouse/gamepad emulation while
Steam is running. The in-game Steam overlay needs to be enabled and working in order for gamepad emulation to work. You
may need to run `{{ic|udevadm trigger}}`{=mediawiki} with root privileges or plug the dongle out and in again, if the
controller does not work immediately after installing and running Steam. If all else fails, try restarting the computer
while the dongle is plugged in.

If you are using the controller connected via Bluetooth LE, make sure the user is part of the `{{ic|input}}`{=mediawiki}
group.

If you cannot get the Steam Controller to work, see [#Steam Controller not pairing or recognized in games (including
USB)](#Steam_Controller_not_pairing_or_recognized_in_games_(including_USB) "wikilink").

```{=mediawiki}
{{Note|If you do not use the [[Steam runtime]], you might actually need to disable the overlay for the controller to work in certain games (Rocket Wars, Rocket League, Binding of Isaac, etc.). Right click on a game in your library, select "Properties", and uncheck "Enable Steam Overlay".}}
```
### Xbox 360 controller {#xbox_360_controller}

Both the wired and wireless (with the *Xbox 360 Wireless Receiver for Windows*) controllers are supported by the
`{{ic|xpad}}`{=mediawiki} kernel module and should work without additional packages. Note that using a wireless Xbox 360
controller with the Play&Charge USB cable will not work. The cable is for recharging only and does not transmit any
input data over the wire.

It has been reported that the default xpad driver has some issues with a few newer wired and wireless controllers, such
as:

-   incorrect button mapping. ([discussion in Steam
    bugtracker](https://github.com/ValveSoftware/steam-for-linux/issues/95#issuecomment-14009081))
-   not-working sync. ([discussion in Arch Forum](https://bbs.archlinux.org/viewtopic.php?id=156028))
-   all four LEDs keep blinking, but controller works. TLP\'s USB autosuspend is one sure cause of this issue with
    wireless controllers. See below for fix.

If you use the [TLP](TLP "wikilink") power management tool, you may experience connection issues with your Microsoft
wireless adapter (e.g. the indicator LED will go out after the adapter has been connected for a few seconds, and
controller connection attempts fail, four LEDs keep blinking but controller works). This is due to TLP\'s USB
autosuspend functionality, and the solution is to add the Microsoft wireless adapter\'s device ID to TLP blacklist (to
check device ID to blacklist, run `{{ic|tlp-stat -u}}`{=mediawiki}; for original MS wireless dongle just add
`{{ic|1=USB_DENYLIST="045e:0719"}}`{=mediawiki} to `{{ic|/etc/tlp.conf}}`{=mediawiki}), check [TLP
configuration](https://linrunner.de/en/tlp/docs/tlp-configuration.html#usb) for more details.

If you experience such issues, you can use [#xboxdrv](#xboxdrv "wikilink") as the default `{{ic|xpad}}`{=mediawiki}
driver instead.

In order to connect via Bluetooth, add the following [kernel parameter](kernel_parameter "wikilink")
`{{ic|1=bluetooth.disable_ertm=1}}`{=mediawiki}.

If you experience problems with the rumble feature not working in games, it may be necessary to set the environment
variable `{{ic|1=SDL_JOYSTICK_HIDAPI=0}}`{=mediawiki}.

#### xboxdrv

```{=mediawiki}
{{Remove|The driver portion of xboxdrv is deprecated.}}
```
[xboxdrv](https://github.com/xiota/xboxdrv) is an alternative to `{{ic|xpad}}`{=mediawiki} which provides more
functionality and might work better with certain controllers. It works in userspace and can be launched as system
service.

Install it with the `{{AUR|xboxdrv}}`{=mediawiki} package. Then [start](start "wikilink")/[enable](enable "wikilink")
`{{ic|xboxdrv.service}}`{=mediawiki}.

If you have issues with the controller being recognized but not working in steam games or working but with incorrect
mappings, it may be required to modify you configuration as such:

```{=mediawiki}
{{hc
|/etc/default/xboxdrv|2=
[xboxdrv]
silent = true
device-name = "Xbox 360 Wireless Receiver"
mimic-xpad = true
deadzone = 4000

[xboxdrv-daemon]
dbus = disabled
}}
```
Then [restart](restart "wikilink") `{{ic|xboxdrv.service}}`{=mediawiki}.

##### Multiple controllers {#multiple_controllers}

*xboxdrv* supports a multitude of controllers, but they need to be set up in `{{ic|/etc/default/xboxdrv}}`{=mediawiki}.
For each extra controller, add an `{{ic|1=next-controller = true}}`{=mediawiki} line. For example, when using 4
controllers, add it 3 times:

```{=mediawiki}
{{bc|1=
[xboxdrv]
silent = true
next-controller = true
next-controller = true
next-controller = true
[xboxdrv-daemon]
dbus = disabled
}}
```
Then [restart](restart "wikilink") `{{ic|xboxdrv.service}}`{=mediawiki}.

#### Using generic/clone controllers {#using_genericclone_controllers}

Some clone gamepads might require a specific initialization sequence in order to work ([Super User
answer](https://superuser.com/a/1380235)). For that you should run the following python script as the root user:

```{=mediawiki}
{{bc|1=
#!/usr/bin/env python3

import usb.core

dev = usb.core.find(idVendor=0x045e, idProduct=0x028e)

if dev is None:
    raise ValueError('Device not found')
else:
    dev.ctrl_transfer(0xc1, 0x01, 0x0100, 0x00, 0x14)
}}
```
### Xbox Wireless Controller / Xbox One Wireless Controller {#xbox_wireless_controller_xbox_one_wireless_controller}

#### Connect Xbox Wireless Controller with USB cable {#connect_xbox_wireless_controller_with_usb_cable}

This is supported by the kernel and works without any additional packages.

#### Connect Xbox Wireless Controller with Bluetooth {#connect_xbox_wireless_controller_with_bluetooth}

##### Update controller firmware via Windows 10 {#update_controller_firmware_via_windows_10}

The firmware of the Xbox Wireless Controller used to cause loops of connecting/disconnecting with Bluez. The best
workaround is to plug the controller (via a USB cord) to a Windows 10 computer, download the [Xbox
Accessories](https://apps.microsoft.com/store/detail/xbox-accessories/9NBLGGH30XJ3?hl=en-us&gl=us) application through
the Microsoft Store, and update the firmware of the controller.

##### xpadneo

A relatively new driver which does support the Xbox One S and Xbox Series X\|S controller via Bluetooth is called
[xpadneo](https://github.com/atar-axis/xpadneo/). In addition to these two models, it has also basic support for the
Xbox Elite Series 2 Wireless controller. In exchange for fully supporting just two controllers so far, it enables one to
read out the correct battery level, supports rumble (even the one on the trigger buttons - L2/R2), corrects the
(sometimes wrong) button mapping and more.

Installation is done using DKMS: `{{AUR|xpadneo-dkms}}`{=mediawiki}.

```{=mediawiki}
{{Note|Pairing a new Xbox One S controller for the first time may prove difficult, from not pairing at all to entering a connect/disconnect loop. These problems are described [https://github.com/atar-axis/xpadneo/issues/295 there]. The best way to reliably pair the controller is to first pair it in Windows 10. However, this needs be done using the same Bluetooth adapter. A solution is to install a free copy of Windows 10 Evaluation on a Virtual machine (using [[QEMU]] or [[VirtualBox]], taking care of the Bluetooth adapter passthrough requirements, ''e.g.'' as an USB device) using Arch Linux as your host, and pair in Windows 10 first, then do the same again under your Arch Linux system. Then pairing will succeed and there will be no need of further Windows 10 use.}}
```
#### Connect Xbox Wireless Controller with Microsoft Xbox Wireless Adapter {#connect_xbox_wireless_controller_with_microsoft_xbox_wireless_adapter}

[xone](https://github.com/medusalix/xone) is a Linux kernel driver for Xbox One and Xbox Series X\|S accessories. It
serves as a modern replacement for and supersedes xpad and xow. Currently working via wired or with the Microsoft Xbox
Wireless Adapter \"dongle\". Bugfixes for this driver are now being mainted by the [dlundqvist
fork](https://github.com/dlundqvist/xone) of the original driver.

Install `{{AUR|xone-dkms}}`{=mediawiki} and, if using the wireless dongle, `{{AUR|xone-dongle-firmware}}`{=mediawiki}.
Installation requires a reboot of your system.

```{=mediawiki}
{{Note|
* The headers corresponding to your kernel are required; see [[DKMS#Installation]].
* The adapter uses a mt76 based 802.11/15 chipset which can result in interference with other wireless adapters connected to the same system or close by.
}}
```
##### Controller performs poorly (low polling rate) after being paired {#controller_performs_poorly_low_polling_rate_after_being_paired}

You will need to [update the controller\'s
firmware](https://support.xbox.com/en-US/help/hardware-network/controller/update-xbox-wireless-controller) in Windows
using the \"Xbox Accessories\" app from the Microsoft Store. Theoretically this should be possible with USB passthrough
to a Windows virtual machine, but you may need to dual boot to an actual (baremetal) Windows installation for the Xbox
Accessories application to see the controller and do the firmware update.

##### Dual boot with Windows {#dual_boot_with_windows}

Pairing the controller & adapter in Windows may cause the pairing to be lost in Linux. You will need to re-pair the
controller & dongle when you reboot into Linux. This also happens in the other direction --- when the controller &
dongle are paired in Linux, they will need to be re-paired the next time you want to use them in Windows. This can be
avoided by following the instructions for [dual boot pairing](Bluetooth#Dual_boot_pairing "wikilink").

##### Failure to connect after Suspend and wake on gamepad use. {#failure_to_connect_after_suspend_and_wake_on_gamepad_use.}

On some platforms, supending can cause the device to enter a state where it does not respond properly. As the device is
recognised by Linux as a bluetooth adapter, it is automatically put into power-off state on suspend, which also disables
waking the system from the gamepad. This can be mitigated by use of `{{ic|btusb.enable_autosuspend{{=}}`{=mediawiki}n}}
on the kernel command line. Note: This will disable power suspend on all other USB Bluetooth adapters on the system.

### PlayStation 3 controller {#playstation_3_controller}

#### Pairing via USB {#pairing_via_usb}

If you own a PS3 controller and can connect with USB, plug it to your computer and press the PS button. The controller
will power up and one of the four LEDs should light up indicating the controller\'s number.

#### Pairing via Bluetooth {#pairing_via_bluetooth}

Install `{{Pkg|bluez}}`{=mediawiki} and `{{Pkg|bluez-utils}}`{=mediawiki}. Make sure bluetooth is working by following
the first five steps of [Bluetooth#Pairing](Bluetooth#Pairing "wikilink") and leave the bluetoothctl command running,
then turn on the controller by pressing the middle \'PS\' button(all 4 leds should be blinking quickly \~4 hz) and
connect to your computer using usb. Lastly, type yes in the bluetoothctl prompt when asked
\'`{{ic|Authorize service 00001124-0000-1000-8000-00805f9b34fb (yes/no)}}`{=mediawiki}\'.

```{=mediawiki}
{{Note|
In the latest version of {{Pkg|bluez}} (as of 2024/01/03), the default value for {{ic|ClassicBondedOnly}} was changed from {{ic|false}} to {{ic|true}} for security reasons [https://bugs.launchpad.net/ubuntu/+source/bluez/+bug/2045931/comments/6]. This change makes it impossible to pair a Dual Shock 3 controller, as {{ic|bluetoothctl}} asks for a PIN and cannot proceed. To work around this, set {{ic|ClassicBondedOnly}} to {{ic|false}} by adding the following lines in the newly created file at {{ic|/etc/bluetooth/input.conf}}.

As of 2024-03-09, the default value for {{ic|UserspaceHID}} has also changed to {{ic|true}}. While the connection succeeds, controllers can no longer be set into operational mode unless this value is changed to {{ic|false}}. See [https://github.com/bluez/bluez/issues/771 issue #771 on Github] for more information.

{{bc|<nowiki>
[General]
ClassicBondedOnly=false
UserspaceHID=false
</nowiki>}}

Note this solution regress on security. For the details, please refer to [https://github.com/bluez/bluez/issues/673#issuecomment-1858431729 GitHub]
}}
```
```{=mediawiki}
{{Tip|There are many complicated instructions on the internet on setting up a PS3 controller that require many steps such as compiling and installing qtsixa or sixpair and setting up the controller manually, or patching bluez with some specific patches. None of this is necessary on a modern Linux kernel and after installing bluez-utils.}}
```
### PlayStation 3/4 controller {#playstation_34_controller}

The DualShock 3, DualShock 4 and Sixaxis controllers work out of the box when plugged in via USB (the PS button will
need to be pushed to begin). They can also be used wirelessly via Bluetooth.

Steam properly recognizes it as a PS3 pad and Big Picture can be launched with the PS button. Big Picture and some games
may act as if it was a 360 controller. Gamepad control over mouse is on by default. You may want to turn it off before
playing games, see [#Disable joystick from controlling mouse](#Disable_joystick_from_controlling_mouse "wikilink").

#### Pairing via Bluetooth {#pairing_via_bluetooth_1}

Install the `{{Pkg|bluez}}`{=mediawiki} and `{{Pkg|bluez-utils}}`{=mediawiki} packages, which includes the *sixaxis*
plugin. Then [start](start "wikilink") the [bluetooth](bluetooth "wikilink") service and ensure bluetooth is powered on.
If using *bluetoothctl* start it in a terminal and then plug the controller in via USB. You should be prompted to trust
the controller in bluetoothctl. A graphical bluetooth front-end may program your PC\'s bluetooth address into the
controller automatically. Hit the PlayStation button and check that the controller works while plugged in.

You can now disconnect your controller. The next time you hit the PlayStation button it will connect without asking
anything else.

Alternatively, on a PS4 controller you can hold the share button and the PlayStation button simultaneously (for a few
seconds) to put the gamepad in pairing mode, and pair as you would normally.

GNOME\'s Settings also provides a graphical interface to pair sixaxis controllers when connected by wire.

Remember to disconnect the controller when you are done as the controller will stay on when connected and drain the
battery.

```{=mediawiki}
{{Note|If the controller does not connect, make sure the bluetooth interface is turned on and the controllers have been trusted. (See [[Bluetooth]])}}
```
#### Using generic/clone controllers {#using_genericclone_controllers_1}

Using generic/clone Dualshock controllers is possible, however there is an issue that may require to install a patched
package. The default Bluetooth protocol stack does not detect some of the clone controllers. The
`{{AUR|bluez-ps3}}`{=mediawiki} package is a version patched to be able to detect them.
`{{AUR|bluez-plugins-ps3}}`{=mediawiki} is another package that only patch the bluez-plugins may work for some
controllers.

### PlayStation 4/5 controller {#playstation_45_controller}

#### Pairing via USB {#pairing_via_usb_1}

Connect your controller via USB and press the `{{ic|PS}}`{=mediawiki} button.

#### Pairing via Bluetooth {#pairing_via_bluetooth_2}

If you want to use Bluetooth mode, hold down the `{{ic|PS}}`{=mediawiki} button and `{{ic|Share}}`{=mediawiki} button
together. The white LED of the controller should blink very quickly, and the wireless controller can be paired with your
Bluetooth manager.

#### Using with Wine {#using_with_wine}

On these controllers, Wine uses hidraw by default (since 8.0), so that Windows applications that support them can use
all of their features. Due to this Windows-like behavior, they are not exposed as XInput devices, which prevents them
from working in many applications.

To disable this behavior, import the following text file into the Wine registry with
[regedit](https://gitlab.winehq.org/wine/wine/-/wikis/FAQ#how-do-i-edit-the-wine-registry):

`Windows Registry Editor Version 5.00`\
`[HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\winebus]`\
`"DisableHidraw"=dword:1`

Since Wine 9.18, this setting can be controlled from `{{ic|wine control joy.cpl}}`{=mediawiki}.

#### Disable touchpad acting as mouse {#disable_touchpad_acting_as_mouse}

If using [libinput](libinput "wikilink") with [Xorg](Xorg "wikilink"), or if using [Wayland](Wayland "wikilink"), then
you can follow [Libinput#Using environment variable](Libinput#Using_environment_variable "wikilink") to disable the
touchpad device.

Note that, since the touchpad is just one part of the controller, selecting the input device by vendor and product IDs
will not suffice. Instead, consider selecting the device by name.

For a full set of attributes you can use, consult
`{{ic|1=udevadm info --attribute-walk --name=''device_path''}}`{=mediawiki}, where `{{ic|''device_path''}}`{=mediawiki}
is the path to the device, such as `{{ic|/dev/input/event''n''}}`{=mediawiki} or
`{{ic|/dev/input/by-id/''identifier''}}`{=mediawiki}.

To find the device path, you can use a tool such as [evtest](https://archlinux.org/packages/?name=evtest) by just
running `{{ic|evtest}}`{=mediawiki}. This command should also print out the name of the device.

Example snippet:

```{=mediawiki}
{{hc|/etc/udev/rules.d/72-ds4tm.rules|2=
# Disable DS4 touchpad acting as mouse
# USB
ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
# Bluetooth
ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
}}
```
With DualSense controllers, replace the names with
`{{ic|Sony Interactive Entertainment DualSense Wireless Controller Touchpad}}`{=mediawiki} and
`{{ic|DualSense Wireless Controller Touchpad}}`{=mediawiki}.

Then, [reload udev rules](Udev#Loading_new_rules "wikilink"). Reconnect the gamepad to apply changes.

#### dualsensectl

[dualsensectl](https://github.com/nowrep/dualsensectl) is a tool that can toggle the lightbar and microphone (and its
LED), monitor the battery status, and power off the controller. To use it, [install](install "wikilink")
`{{AUR|dualsensectl-git}}`{=mediawiki}.

## Tips and Tricks {#tips_and_tricks}

### Gamepad over network {#gamepad_over_network}

If you want to use your gamepad with another computer over a network, you can use [USB/IP](USB/IP "wikilink") or
`{{AUR|netstick-git}}`{=mediawiki} to do this.

### Measure controller polling rates and latencies via gamepadla-polling {#measure_controller_polling_rates_and_latencies_via_gamepadla_polling}

*See also: [Mouse polling rate](Mouse_polling_rate "wikilink")*

Gamepadla hosts a crowdsourced database for controller-specific latency, and polling data.[5](https://gamepadla.com) The
tool for making these reports reads evdev/hidraw events via pygame/SDL and it can be obtained from
`{{AUR|gamepadla-polling}}`{=mediawiki}.

## Troubleshooting

### Device permissions {#device_permissions}

Gamepad devices are affected by [udev rules](Udev#Allowing_regular_users_to_use_devices "wikilink"): unless they grant
access to the device, it simply will not be readable by users. This section investigates the possibility of you already
having a configuration file handling this.

Any gamepad device, regardless of whether it is over USB or Bluetooth, is handled by the [\"input\" subsystem of the
kernel](https://docs.kernel.org/input/input_uapi.html), corresponding with `{{ic|/dev/input}}`{=mediawiki}. It is also
common for udev rules to target the [\"hidraw\" kernel module](https://docs.kernel.org/hid/hidraw.html). Combining
these, we can understand udev\'s handling of these devices by inspecting the configuration shipped by packages:

`$ grep --extended-regexp 'SUBSYSTEM=="input"|KERNEL=="hidraw' --recursive /usr/lib/udev/rules.d`

Some examples of applications which ship noteworthy rules:

-   [systemd](systemd "wikilink")\'s default rules set the group of all `{{ic|input}}`{=mediawiki} devices to
    `{{ic|input}}`{=mediawiki}, and the mode of joystick devices to `{{ic|664}}`{=mediawiki}
    [6](https://github.com/systemd/systemd/blob/edfb4a474e5cbef6578a70aae7f08a0f435c6c6a/rules.d/50-udev-default.rules.in#L33).
-   [Steam](Steam "wikilink") ships udev rules allowing access to a variety of controllers. See [this Steam
    discussion](https://steamcommunity.com/app/353370/discussions/2/1735465524711324558/) for further info about the
    contents of the rules.
-   [Dolphin emulator](Dolphin_emulator "wikilink") ships udev rules allowing access to controllers it supports.

If your system does not already happen to have a udev rule for the device you want to use, you can either write one
yourself or install the `{{AUR|game-devices-udev}}`{=mediawiki} package and restart your computer.

```{=mediawiki}
{{Note|It is possible to add a user to the {{ic|input}} group in order to give them access to all devices. However, this is not recommended [https://github.com/systemd/systemd/issues/4288].}}
```
### Gamepad is not recognized by all programs {#gamepad_is_not_recognized_by_all_programs}

Some software, Steam for example, will only recognize the first gamepad it encounters. Due to a bug in the driver for
Microsoft wireless periphery devices this can in fact be the bluetooth dongle. If you find you have a
`{{ic|/dev/input/js*}}`{=mediawiki} and `{{ic|/dev/input/event*}}`{=mediawiki} belonging to you keyboard\'s bluetooth
transceiver you can get automatically get rid of it by creating according udev rules:

```{=mediawiki}
{{hc|/etc/udev/rules.d/99-btcleanup.rules|2=
ACTION=="add", KERNEL=="js[0-9]*", SUBSYSTEM=="input", KERNELS=="...", ATTRS{bInterfaceSubClass}=="00", ATTRS{bInterfaceProtocol}=="00", ATTRS{bInterfaceNumber}=="02", RUN+="/usr/bin/rm /dev/input/js%n"
ACTION=="add", KERNEL=="event*", SUBSYSTEM=="input", KERNELS=="...", ATTRS{bInterfaceSubClass}=="00", ATTRS{bInterfaceProtocol}=="00", ATTRS{bInterfaceNumber}=="02", RUN+="/usr/bin/rm /dev/input/event%n"
}}
```
Correct the `{{ic|1=KERNELS=="..."}}`{=mediawiki} to match your device. The correct value can be found by running

`# udevadm info -an /dev/input/js0`

Assuming the device in question is `{{ic|/dev/input/js0}}`{=mediawiki}. After you placed the rule reload the rules with

`# udevadm control --reload`

Then replug the device making you trouble. The joystick and event devices should be gone, although their number will
still be reserved. But the files are out of the way.

### Application only supports Xbox 360 controllers {#application_only_supports_xbox_360_controllers}

Some Windows games look for an Xbox 360 controller in particular, missing functionality (like vibration) or not working
at all otherwise.

For a workaround, see [#Mimic Xbox 360 controller](#Mimic_Xbox_360_controller "wikilink").

### Nintendo Switch Pro Controller disconnects when using Bluetooth {#nintendo_switch_pro_controller_disconnects_when_using_bluetooth}

The Nintendo Switch Pro Controller and variants may disconnect when receiving rumble inputs.

This can be worked around by changing the name of the Bluetooth adapter to
\"Nintendo\".[7](https://github.com/DanielOgorchock/linux/issues/33#issuecomment-2790843365)

### Steam Controller {#steam_controller_1}

#### Steam Controller not pairing or recognized in games (including USB) {#steam_controller_not_pairing_or_recognized_in_games_including_usb}

There are some unknown cases where the packaged udev rule for the Steam controller does not work
(`{{bug|47330}}`{=mediawiki}). This can result in many issues, such as the Steam Controller behaving functionally in the
desktop and in Steam, but failing to have any effect in games (including over USB controller connections). The most
reliable workaround is to make the controller world readable. Copy the rule
`{{ic|/usr/lib/udev/rules.d/70-steam-controller.rules}}`{=mediawiki} to `{{ic|/etc/udev/rules.d}}`{=mediawiki} with a
later priority and change anything that says `{{ic|1=MODE="0660"}}`{=mediawiki} to
`{{ic|1=MODE="066'''6'''"}}`{=mediawiki} e.g.

```{=mediawiki}
{{hc|/etc/udev/rules.d/99-steam-controller-perms.rules|2=
...
SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
...
}}
```
You may have to reboot in order for the change to take effect.

#### Steam Controller makes a game crash or not recognized {#steam_controller_makes_a_game_crash_or_not_recognized}

If your Steam Controller is working well in Steam Big Picture mode, but not recognized by a game or the game starts
crashing when you plug in the controller, this may be because of the native driver that has been added to the Linux
kernel 4.18. Try to unload it, restart Steam and replug the controller.

The module name of the driver is `{{ic|hid_steam}}`{=mediawiki}, so to unload it you may perform:

`# rmmod hid_steam`

If this module is not already loaded but the controller is still not recognized by games, refer to the previous
section\'s udev rule solution in [#Steam Controller not pairing or recognized in games (including
USB)](#Steam_Controller_not_pairing_or_recognized_in_games_(including_USB) "wikilink").

### Xbox One Wireless Gamepad detected but no inputs recognized {#xbox_one_wireless_gamepad_detected_but_no_inputs_recognized}

This can occur when using a third party Xbox One controller with the `{{ic|xpad}}`{=mediawiki} or
[#xboxdrv](#xboxdrv "wikilink") drivers. Try switching to [#xpadneo](#xpadneo "wikilink").

### PlayStation 4 Controllers {#playstation_4_controllers}

#### Controller not recognized when using Bluetooth {#controller_not_recognized_when_using_bluetooth}

[Install](Install "wikilink") the `{{AUR|ds4drv}}`{=mediawiki} package and run it with the hidraw
(`{{ic|ds4drv --hidraw}}`{=mediawiki}) backend parameter.

#### Motion controls taking over joypad controls and/or causing unintended input with joypad controls {#motion_controls_taking_over_joypad_controls_andor_causing_unintended_input_with_joypad_controls}

```{=mediawiki}
{{Style|Could likely use the same solution as [[Gamepad#Disable touchpad acting as mouse]], which is already refactored into other pages where appropriate.}}
```
With certain cloud gaming applications such as Parsec and Shadow, the Dualshock 4 V1 and V2 motion controls can conflict
with the joypad controls resulting in the joypad not working, and with certain input sensitive games, especially racing
games, the motion controls can cause unintentional drift during joypad control gameplay.

This can be worked around by disabling the motion controls and the touchpad by adding the following udev rules:

```{=mediawiki}
{{hc|1=/etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules|2=
SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
SUBSYSTEM=="input", ATTRS{name}=="*Controller Touchpad", RUN+="/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
}}
```
Then [reload the rules](udev#Loading_new_rules "wikilink") or reboot: these rules should work in both USB and Bluetooth
mode.

### Multi-mode wired gamepads {#multi_mode_wired_gamepads}

Some gamepads have 3 modes when wired: Switch, Xbox 360/Windows, Android.

And they also do not have hotkeys to switch between them when connected *wired*.

#### ZD O+ Excellence {#zd_o_excellence}

The gamepad defaults to Switch mode and falls back to XInput. The gamepad inputs are not handled properly in this mode.
The rest of the rebinds you can make, e.g. keyboard and mouse inputs all seem to work properly in XInput mode by
default.

##### DirectInput

This can be fixed by switching to DirectInput mode every time you use it, but that is annoying and does not work for
some HTML5 games.

##### udev

Add the following udev rule and it will be handled as an Xbox 360 controller using xpad:

```{=mediawiki}
{{hc|/etc/udev/rules.d/99-zdO-xinput.rules|2=
ACTION=="add", ATTRS{idVendor}=="11c0", ATTRS{idProduct}=="5505", RUN+="/sbin/modprobe xpad", RUN+="/bin/sh -c 'echo 11c0 5505 > /sys/bus/usb/drivers/xpad/new_id'"
}}
```
[Reload your udev rules](udev#Loading_new_rules "wikilink").

Then replug your gamepad.

#### ShanWan

```{=mediawiki}
{{Style|Multiple improvements to be made.}}
```
When you connect this gamepad to Windows, it is in Xbox 360 Controller mode.

But when you connect such gamepad to Linux, it enters the fallback mode (which happens to be the Android mode), which
has a worse polling rate (100 Hz), the Home button acting as `{{ic|XF86Home}}`{=mediawiki}; doesn\'t expose vibration,
gyroscope, and accelerometer; doesn\'t support *xboxdrv* without `{{ic|--evdev}}`{=mediawiki}; and identifies itself as
e.g. \"SHANWAN Android Gamepad\" which is not liked by some games (though for SDL2 apps you can set a name in
`{{ic|SDL_GAMECONTROLLERCONFIG}}`{=mediawiki}).

When you connect the gamepad, it first tries to be a \"Switch Pro Controller\", but for some reason the Linux kernel
considers the descriptors (sent by the gamepad) invalid, and therefore disconnects the gamepad. This causes the gamepad
to reconnect in the aforementioned fallback mode.

In `{{ic|dmesg}}`{=mediawiki} this looks like:

```{=mediawiki}
{{bc|1=
usb 1-5.3: new full-speed USB device number 37 using xhci_hcd
usb 1-5.3: unable to read config index 0 '''descriptor'''/start: -32
usb 1-5.3: chopping to 0 config(s)
usb 1-5.3: can't read configurations, error '''-32'''
usb 1-5.3: new full-speed USB device number 38 using xhci_hcd
usb 1-5.3: New USB device found, idVendor=0079, idProduct=181c, bcdDevice= 1.00
usb 1-5.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-5.3: Product: Android Gamepad
usb 1-5.3: Manufacturer: SHANWAN
}}
```
Notice that the \"USB Device number\" gets increased after the failure. For some USB hubs the error code is
`{{ic|1=-32}}`{=mediawiki} (EPIPE: broken pipe), for others it is `{{ic|1=-71}}`{=mediawiki} (EPROTO: protocol error).

This error can be fixed by setting a quirk in `{{ic|usbcore}}`{=mediawiki} module (not `{{ic|usbhid}}`{=mediawiki}) for
Switch controller\'s USB ID:

`# If you have already *manually* set quirks for other devices,`\
`# then do not forget to include them in the two commands below ↓`\
`echo -n "057e:2009:`**`ik`**`" | sudo tee /sys/module/usbcore/parameters/quirks`

`# Optionally constant polling mode:`\
`sudo modprobe -r usbhid ; sleep 4 ; sudo modprobe -v usbhid "quirks=0x057e:0x2009:0x400"`

```{=mediawiki}
{{ic|ik}}
```
are 2 flags ([List of all
flags](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/7.7_release_notes/kernel_parameters_changes)).

The flag `{{ic|i}}`{=mediawiki} means \"allow bad descriptors\".

And the flag `{{ic|k}}`{=mediawiki} means \"disable LPM\" (link power management). It is specified in the command
because it often helps devices of other types. This flag might do nothing because not all USB controllers even have LPM.
You can try without `{{ic|k}}`{=mediawiki} aftewards.

You could also try the flag `{{ic|g}}`{=mediawiki} (\"200 ms pause after reading the descriptors\") because it often
helps devices of other types, but at least in the case of iPEGA PG-SW038C (a \$10 gamepad) flag `{{ic|g}}`{=mediawiki}
causes it infinitely reconnect.

Note that once the gamepad downgrades to the fallback mode, it will never change its mode until you reconnect it. Even
`{{ic|echo 0 then 1 > %sysfsGamepadDir%/authorized}}`{=mediawiki} doesn\'t work. And that\'s why passing the gamepad to
a Windows VM would not help; `{{ic|usbcore}}`{=mediawiki} inits USB devices before passing them to a VM.

```{=html}
<hr/>
```
Now reconnect the gamepad, it should be finally listed now as
`{{ic|ID 057e:2009 Nintendo Co., Ltd Switch Pro Controller}}`{=mediawiki} when you run `{{ic|lsusb}}`{=mediawiki}. If
that\'s true, then you can make this quirk permanent by add this option to GRUB:

```{=mediawiki}
{{ic|1=usbcore.quirks="057e:2009:ik"}}
```
along with (optionally) `{{ic|1=usbhid.quirks="0x057e:0x2009:0x400"}}`{=mediawiki} which stops the pointless blinking of
LEDs when the gamepad is unused.

Now that your gamepad is in Switch mode, you will run into a problem of SDL2 deciding to become a user-space driver (for
this it uses `{{Pkg|libusb}}`{=mediawiki}, just like *xboxdrv*), which causes any SDL2 game to claim the whole gamepad
(that is: `{{ic|/dev/input/*}}`{=mediawiki} and `{{ic|/dev/hidraw*}}`{=mediawiki} disappear, yet it is still possible to
play this launched game with the gamepad), so you cannot use the gamepad in multiple apps anymore.

This can be fixed by adding

`SDL_HIDAPI_DISABLE_LIBUSB=1`

into `{{ic|/etc/environment}}`{=mediawiki}, and rebooting.

If you have `{{AUR|joycond-git}}`{=mediawiki}, then delete it, because it is useless for such Switch-like gamepads,
moreover `{{ic|joycond}}`{=mediawiki} has a `{{ic|udev}}`{=mediawiki} rule that disallows Steam to provide its own
user-space driver.

Unlike SDL2 (when it uses `{{ic|/dev/hidraw*}}`{=mediawiki} which is its preferred way in 2023),
`{{ic|xboxdrv}}`{=mediawiki} and `{{ic|/dev/input/*}}`{=mediawiki} provide incorrect values for the right stick\'s X
axis (it is always ≤0). Probably a bug in `{{ic|hid-nintendo}}`{=mediawiki} or something. For this reason
`{{ic|xboxdrv}}`{=mediawiki} is unusable in most games when in Switch mode.

You can test your gyroscope and accelerometer by launching `{{Pkg|antimicrox}}`{=mediawiki}. They are not available in
other gamepad modes when connected wired because their values are sent *mixed* with other event data (RX/RY/etc) in a
special format that is not fully compatible with `{{ic|xpad}}`{=mediawiki} and `{{ic|hid-generic}}`{=mediawiki}.

If you see in `{{ic|dmesg}}`{=mediawiki} that `{{ic|hid-generic}}`{=mediawiki} is used by your gamepad, then it is
probably because you have built Linux kernel with your own config without `{{ic|hid-nintendo}}`{=mediawiki}.
Unfortuately, Switch mode + `{{ic|hid-generic}}`{=mediawiki} is as useless as the fallback mode (even no vibration).

##### Xbox 360 Controller mode {#xbox_360_controller_mode}

After having completed everything above (i.e. 1-2 quirks, 1 envvar),

add

`blacklist hid_nintendo`

into `{{ic|1=/etc/modprobe.d/blacklist.conf}}`{=mediawiki}

then run `{{ic|1=sudo mkinitcpio -P}}`{=mediawiki} to rebuild `{{ic|/boot/initramfs*}}`{=mediawiki} (kernel reads
`{{ic|/etc/modprobe.d/}}`{=mediawiki} only from its own initramfs, not your rootfs)

Now create the following file:

```{=mediawiki}
{{hc|1=/etc/udev/rules.d/10-disallow-generic-driver-for-switch.rules|2=
# If
# 1. a gamepad is multi-mode (Switch, X360, PC) and defaults to USB ID 057e:2009
# AND at the same time
# 2. `hid-nintendo` module cannot be loaded (blacklisted or not compiled)
# AND at the same time
# 3. there is already a launched game that immediately grabs a gamepad,
#
# Then when you connect such gamepad, it will stay in "Switch Pro" mode,
# but using the fallback `hid-generic` module
# which would result in no vibration/etc
# despite still being listed as a "Switch Pro Controller".

# But by notifying the gamepad that we abandon to use it as an HID,
# it automatically downgrades to "Xbox 360 Controller" mode,
# which causes vibration and `xboxdrv` to work.
SUBSYSTEM=="hid", DRIVER=="hid-generic", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", RUN="/bin/sh -c 'echo $id:1.0 > /sys/bus/usb/drivers/usbhid/unbind'"
}}
```
then run `{{ic|sudo udevadm control --reload-rules && sudo udevadm trigger}}`{=mediawiki}

Since you probably do not want to reboot, run `{{ic|sudo modprobe -r hid_nintendo}}`{=mediawiki}

From now on, to switch (\"downgrade\") from Switch mode to Xbox 360 mode, just run
`{{ic|sudo modprobe -r hid_nintendo}}`{=mediawiki} (you do not even need to reconnect it). Within 2 seconds you will
have `{{ic|045e:028e Microsoft Corp. Xbox360 Controller}}`{=mediawiki} in `{{ic|lsusb}}`{=mediawiki}

And if you want to switch vice versa:

1.  ```{=mediawiki}
    {{ic|sudo modprobe hid_nintendo}}
    ```
    (even though it is blacklisted, this command still works because blacklisting just means \"do not load this module
    *automatically*\").

2.  Reconnect.

###### Alternative rootless solution {#alternative_rootless_solution}

If you do not have root access, then:

1.  Power off your PC (not just suspend)
2.  Reconnect your gamepad.
3.  Power the PC on.
4.  UEFI (just like non-virtualized Windows) automatically and successfully initializes the gamepad (even if it is
    connected through a USB hub in your monitor) despite the invalid descriptors.
5.  The gamepad receives info from UEFI (or maybe GRUB) that it is no longer needed as an HID, which causes it to switch
    (\"downgrade\") to Xbox 360 Controller mode. Switching between modes is done this way: the gamepad disconnects, then
    connects under a different USB ID.
6.  You can even suspend (without turning off the monitor if that\'s what it is connected to) and then wake-up the PC,
    and it will still be in Xbox 360 Controller mode. But if you reconnect the gamepad, it will be in the fallback mode,
    so you will have to follow the instruction again.

### USB debugging {#usb_debugging}

You will probably not need to know this, but this USB ID (057e:2009) was discovered by USB debugging:

`# Allow debugging of the kernel:`\
`sudo ls /sys/kernel/debug/usb >/dev/null 2>&1 || sudo mount -t debugfs none_debugfs /sys/kernel/debug`\
`# Load the module that allows sniffing of the traffic of USB buses:`\
`sudo modprobe usbmon`\
`# We need only connection events, and in these events`\
`# we need only a USB ID which is in the pre-pre-last column:`\
`sudo /bin/grep --line-buffered -Po '(?<=0 0 18 = .{18}).{8}' /sys/kernel/debug/usb/usbmon/`**`99999`**`u | /bin/sed -E 's/([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})/\2\1:\4\3/'`

where `{{ic|99999}}`{=mediawiki} must be replaced with the USB Bus number that your gamepad uses, e.g.
`{{ic|1}}`{=mediawiki} (without leading zeroes). It can be found by running `{{ic|lsusb}}`{=mediawiki}.

If nothing helped and your gamepad still works in full capacity only in Windows, you can catch USB messages while in
Windows, and then replay them while in Linux. See [usbrply](https://github.com/JohnDMcMaster/usbrply). For this, Windows
must not be in VM because Linux kernel\'s `{{ic|usbcore}}`{=mediawiki} initializes a USB device before passing it to a
VM. This could be avoided by buying a PCI-E USB controller and passing it through (External USB hubs cannot be passed
through). Or you can pass-through your motherboard\'s own USB controller if it is in a IOMMU group without devices
important for you:

+-------------------------------------------------------------------------------+
| `<strong>`{=html}Script which lists IOMMU groups`</strong>`{=html}            |
+-------------------------------------------------------------------------------+
| ```{=mediawiki}                                                               |
| {{hc|list-iommu-groups.sh|<nowiki>                                            |
| #!/bin/bash                                                                   |
| shopt -s nullglob                                                             |
| for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do |
|   echo "IOMMU Group ${g##*/}:"                                                |
|   for d in $g/devices/*; do                                                   |
|       echo -e "\t$(lspci -nns ${d##*/})"                                      |
|   done;                                                                       |
| done;</nowiki>}}                                                              |
| ```                                                                           |
+-------------------------------------------------------------------------------+

## Example xboxdrv configurations {#example_xboxdrv_configurations}

```{=mediawiki}
{{Remove|xboxdrv is very rarely needed, and this section takes up a lot of space for how specific it is.}}
```
To give these devices a persistent name, set an udev rule in this format.

```{=mediawiki}
{{hc|/etc/udev/rules.d/99-btjoy.rules|2=
#Create a symlink to appropriate /dev/input/eventX at /dev/btjoy
ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="Bluetooth Gamepad", ATTRS{uniq}=="00:17:02:01:ae:2a", SYMLINK+="btjoy"
}}
```
Replace \"Bluetooth Gamepad\" with your device name and \"00:17:02:01:ae:2a\" with your device\'s address.

When you have the configuration and your device is connected you can start `{{ic|xboxdrv}}`{=mediawiki} like so:

`# xboxdrv --evdev /dev/btjoy --config .config/xboxdrv/ipega.conf`

### iPEGA-9017s {#ipega_9017s}

```{=mediawiki}
{{hc|~/.config/xboxdrv/ipega.conf|2=
#iPEGA PG-9017S Config

[xboxdrv]
evdev-debug = true
evdev-grab = true
rumble = false
mimic-xpad = true

[evdev-absmap]
ABS_HAT0X = dpad_x
ABS_HAT0Y = dpad_y

ABS_X = X1
ABS_Y = Y1

ABS_Z  = X2
ABS_RZ = Y2

[axismap]
-Y1 = Y1
-Y2 = Y2

[evdev-keymap]
BTN_EAST=a
BTN_C=b
BTN_NORTH=y
BTN_SOUTH=x
BTN_TR2=start
BTN_TL2=back
BTN_Z=rt
BTN_WEST=lt

BTN_MODE = guide
}}
```
### iPEGA-9068 and 9087 {#ipega_9068_and_9087}

```{=mediawiki}
{{hc|~/.config/xboxdrv/ipega.conf|2=
#iPEGA PG-9068 and PG-9087 Config

[xboxdrv]
evdev-debug = true
evdev-grab = true
rumble = false
mimic-xpad = true

[evdev-absmap]
ABS_HAT0X = dpad_x
ABS_HAT0Y = dpad_y

ABS_X = X1
ABS_Y = Y1

ABS_Z  = X2
ABS_RZ = Y2

[axismap]
-Y1 = Y1
-Y2 = Y2

[evdev-keymap]
BTN_A=a
BTN_B=b
BTN_Y=y
BTN_X=x
BTN_TR=rb
BTN_TL=lb
BTN_TR2=rt
BTN_TL2=lt
BTN_THUMBL=tl
BTN_THUMBR=tr
BTN_START=start
BTN_SELECT=back

BTN_MODE = guide
}}
```
### Defender X7 {#defender_x7}

```{=mediawiki}
{{hc|~/.config/xboxdrv/defender.conf|2=
#Defender x7 xboxdrv config

[xboxdrv]
evdev-debug = true
evdev-grab = true
rumble = false
mimic-xpad = true

[evdev-absmap]
ABS_HAT0X = dpad_x
ABS_HAT0Y = dpad_y

ABS_X = X1
ABS_Y = Y1

ABS_Z  = X2
ABS_RZ = Y2

[axismap]
-Y1 = Y1
-Y2 = Y2

[evdev-keymap]
BTN_EAST=b
BTN_NORTH=x
BTN_SOUTH=a
BTN_WEST=y
BTN_TR2=rt
BTN_TL2=lt
BTN_TR=rb
BTN_TL=lb
BTN_THUMBL=tl
BTN_THUMBR=tr
BTN_START=start
BTN_SELECT=back

BTN_MODE = guide
}}
```
### Stadia Controller {#stadia_controller}

```{=mediawiki}
{{hc
|~/.config/xboxdrv/stadia.conf|2=
# Stadia xboxdrv config

[xboxdrv]
mimic-xpad=true
silent=true

[evdev-absmap]
ABS_X=x1
ABS_Y=y1
ABS_Z=x2
ABS_RZ=y2
ABS_GAS=rt
ABS_BRAKE=lt
ABS_HAT0X=dpad_x
ABS_HAT0Y=dpad_y

[axismap]
-y1=y1
-y2=y2

[evdev-keymap]
BTN_SOUTH=A
BTN_EAST=B
BTN_NORTH=X
BTN_WEST=Y

BTN_START=start
BTN_SELECT=back
BTN_MODE=guide

BTN_THUMBL=tl
BTN_THUMBR=tr
BTN_TR=rb
BTN_TL=lb
}}
```
### Logitech Dual Action {#logitech_dual_action}

`# xboxdrv --evdev /dev/input/event* \`\
`   --evdev-absmap ABS_X=x1,ABS_Y=y1,ABS_RZ=x2,ABS_Z=y2,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \`\
`   --axismap -Y1=Y1,-Y2=Y2 \`\
`   --evdev-keymap BTN_TRIGGER=x,BTN_TOP=y,BTN_THUMB=a,BTN_THUMB2=b,BTN_BASE3=back,BTN_BASE4=start,BTN_BASE=lt,BTN_BASE2=rt,BTN_TOP2=lb,BTN_PINKIE=rb,BTN_BASE5=tl,BTN_BASE6=tr \`\
`   --mimic-xpad --silent`

### PlayStation 2 controller {#playstation_2_controller}

`# xboxdrv --evdev /dev/input/event* \`\
`   --evdev-absmap ABS_X=x1,ABS_Y=y1,ABS_RZ=x2,ABS_Z=y2,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \`\
`   --axismap -Y1=Y1,-Y2=Y2 \`\
`   --evdev-keymap   BTN_TOP=x,BTN_TRIGGER=y,BTN_THUMB2=a,BTN_THUMB=b,BTN_BASE3=back,BTN_BASE4=start,BTN_BASE=lb,BTN_BASE2=rb,BTN_TOP2=lt,BTN_PINKIE=rt,BTN_BASE5=tl,BTN_BASE6=tr \`\
`   --mimic-xpad --silent`

### PlayStation 4 controller {#playstation_4_controller}

`# xboxdrv \`\
`   --evdev /dev/input/by-id/usb-Sony_Computer_Entertainment_Wireless_Controller-event-joystick\`\
`   --evdev-absmap ABS_X=x1,ABS_Y=y1                 \`\
`   --evdev-absmap ABS_Z=x2,ABS_RZ=y2                \`\
`   --evdev-absmap ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \`\
`   --evdev-keymap BTN_A=x,BTN_B=a                   \`\
`   --evdev-keymap BTN_C=b,BTN_X=y                   \`\
`   --evdev-keymap BTN_Y=lb,BTN_Z=rb                 \`\
`   --evdev-keymap BTN_TL=lt,BTN_TR=rt               \`\
`   --evdev-keymap BTN_SELECT=tl,BTN_START=tr        \`\
`   --evdev-keymap BTN_TL2=back,BTN_TR2=start        \`\
`   --evdev-keymap BTN_MODE=guide                    \`\
`   --axismap -y1=y1,-y2=y2                          \`\
`   --mimic-xpad                                     \`\
`   --silent`

### PlayStation 5 controller {#playstation_5_controller}

`# xboxdrv \`\
`  --evdev /dev/input/by-id/usb-Sony_Interactive_Entertainment_DualSense_Wireless_Controller-if03-event-joystick \`\
`  --evdev-absmap ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y,ABS_X=X1,ABS_Y=Y1,ABS_RX=X2,ABS_RY=Y2,ABS_Z=LT,ABS_RZ=RT \`\
`  --evdev-keymap BTN_SOUTH=A,BTN_EAST=B,BTN_NORTH=Y,BTN_WEST=X,BTN_START=start,BTN_MODE=guide,BTN_SELECT=back \`\
`  --evdev-keymap BTN_TL=LB,BTN_TR=RB,BTN_TL2=LT,BTN_TR2=RT,BTN_THUMBL=TL,BTN_THUMBR=TR \`\
`  --axismap -y1=y1,-y2=y2                          \`\
`  --mimic-xpad                                     \`\
`  --silent`

[Category:Input devices](Category:Input_devices "wikilink") [Category:Gaming](Category:Gaming "wikilink")

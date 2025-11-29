```{=mediawiki}
{{Lowercase title}}
```
[ja:nvidia-xrun](ja:nvidia-xrun "wikilink") [ru:Nvidia-xrun](ru:Nvidia-xrun "wikilink")
[zh-hans:Nvidia-xrun](zh-hans:Nvidia-xrun "wikilink") [nvidia-xrun](https://github.com/Witko/nvidia-xrun) is a utility
that allows NVIDIA Optimus-enabled laptops to run [X server](X_server "wikilink") with discrete NVIDIA graphics on
demand. This solution offers full GPU utilization, compatibility and better performance than
[Bumblebee](Bumblebee "wikilink").

X server can only be used with integrated graphics or discrete NVIDIA graphics, but not both, so the user might want to
switch to a separate [virtual console](Linux_console "wikilink") and start another X server using different graphics
from what was used for the first X server.

## Installation

[Install](Install "wikilink"):

-   ```{=mediawiki}
    {{Pkg|nvidia}}
    ```
    \- if using older drivers you have to edit nvidia-xrun\'s PKGBUILD and remove the NVIDIA depend

-   ```{=mediawiki}
    {{AUR|nvidia-xrun-git}}
    ```
    (recommended) or `{{AUR|nvidia-xrun}}`{=mediawiki} (old method, uses bumblebee to switch off the dedicated card)

-   Any [window manager](window_manager "wikilink"), since running application directly like with
    `{{ic|nvidia-xrun ''application''}}`{=mediawiki} is not recommended.

## Configuration

### Setting the right bus id {#setting_the_right_bus_id}

```{=mediawiki}
{{Note|If you installed package from [[AUR]], the bus id has been automatically set in {{ic|/etc/X11/nvidia-xorg.conf}}. Make sure the bus ID has been correctly set, otherwise change it (you can find correct bus ID using {{ic|lspci}} command). In some cases you need to convert the hex output from {{ic|lspci}} to decimal for {{ic|nvidia-xorg.conf}}, e.g. {{ic|3b:00.0}} becomes {{ic|"PCI:59:0:0"}}.}}
```
Find your display device bus id:

`$ lspci -d 10de::03xx | awk '{print $1}'`

It might return something similar to `{{ic|01:00.0}}`{=mediawiki}. Then create a file (for example
`{{ic|/etc/X11/nvidia-xorg.conf.d/30-nvidia.conf}}`{=mediawiki}) to set the proper bus id:

```{=mediawiki}
{{hc|/etc/X11/nvidia-xorg.conf.d/30-nvidia.conf|
Section "Device"
    Identifier "nvidia"
    Driver "nvidia"
    BusID "PCI:'''1:0:0'''"
    #  Option "DPI" "'''96 x 96'''"
EndSection}}
```
Also this way you can adjust some NVIDIA settings if you encounter issues:

```{=mediawiki}
{{hc|/etc/X11/nvidia-xorg.conf.d/30-nvidia.conf|
Section "Screen"
    Identifier "nvidia"
    Device "nvidia"
    #  Option "AllowEmptyInitialConfiguration" "Yes"
    #  Option "UseDisplayDevice" "none"
EndSection}}
```
### External GPU setup {#external_gpu_setup}

You can also use this in an external GPU setup. Make sure to load the *nvidia-modeset* and *nvidia-drm* modules and add
the option `{{ic|Option "AllowExternalGpus" "true"}}`{=mediawiki} to the *\"Device\"* section.

Change the auto-generated configuration to use the **internal display** on devices with multiple NVIDIA cards:

```{=mediawiki}
{{hc|/etc/X11/nvidia-xorg.conf.d/30-nvidia.conf|
Section "ServerLayout"
  Identifier "layout"
  Screen 0 "nvidia" 0 0
  Inactive "intel"
  Option  "AutoAddGPU" "false"
EndSection

Section "Device"
  Identifier "nvidia"
  Driver "nvidia"
  BusID "PCI:9:0:0"
  Option "AllowExternalGpus" "true"
  Option "ProbeAllGpus" "false"
  Option "HardDPMS" "false"
  Option "NoLogo" "true"
  Option "UseEDID" "false"
#    Option "UseDisplayDevice" "none"
EndSection

Section "Screen"
  Identifier "nvidia"
  Device "nvidia"
  Option "AllowEmptyInitialConfiguration" "Yes"
#  Option "UseDisplayDevice" "None"
EndSection}}
```
Remember to set the bus id to the correct graphics card.

### Automatically run window manager {#automatically_run_window_manager}

For convenience you can create an `{{ic|$XDG_CONFIG_HOME/X11/nvidia-xinitrc}}`{=mediawiki} file with your favorite
window manager. (if using *nvidia-xrun* \< v.0.3.79 create `{{ic|$HOME/.nvidia-xinitrc}}`{=mediawiki})

`if [ $# -gt 0 ]; then`\
`  $*`\
`else`\
`  `*`your-window-manager`*\
`fi`

With it you do not need to specify the app and can simply execute:

`$ nvidia-xrun`

Since this method starts an isolated X server, it is also a good idea to get a copy of all the other configurations
files that you have located at `{{ic|/etc/X11/xorg.conf.d/}}`{=mediawiki}, except for your prior standard integrated GPU
configurations.

### Use bbswitch to manage the NVIDIA card {#use_bbswitch_to_manage_the_nvidia_card}

```{=mediawiki}
{{Note|nvidia-xrun > 0.3.78 should disable the card automatically so this method is unneccessary}}
```
When the NVIDIA card is not needed, *bbswitch* can be used to turn it off. The *nvidia-xrun* script will automatically
take care of running a window manager and waking up the NVIDIA card. To achieve that, you need to:

Load the `{{ic|bbswitch}}`{=mediawiki} module on boot:

`# echo 'bbswitch' > /etc/modules-load.d/bbswitch.conf`

Disable the `{{ic|nvidia}}`{=mediawiki} module on boot:

`# echo 'options bbswitch load_state=0 unload_state=1' > /etc/modprobe.d/bbswitch.conf `

After a reboot, the NVIDIA card will be off. This can be seen by querying `{{ic|bbswitch}}`{=mediawiki}\'s status:

`$ cat /proc/acpi/bbswitch  `

To force the card to turn on/off respectively run:

`# echo OFF > /proc/acpi/bbswitch`\
`# echo ON > /proc/acpi/bbswitch`

For more about bbswitch see [Bumblebee-Project/bbswitch](https://github.com/Bumblebee-Project/bbswitch).

## Usage

### Start at boot {#start_at_boot}

[Enable](Enable "wikilink") `{{ic|nvidia-xrun-pm.service}}`{=mediawiki} - this shuts down the NVIDIA card during boot.

Once the system boots, from the virtual console, login to your user, and run
`{{ic|nvidia-xrun ''application''}}`{=mediawiki}.

If above does not work, [switch](Keyboard_shortcuts#Xorg_and_Wayland "wikilink") to unused virtual console and try
again.

As mentioned before, running applications directly with `{{ic|nvidia-xrun ''application''}}`{=mediawiki} **does not work
well**, so it is best to create an `{{ic|nvidia-xinitrc}}`{=mediawiki} file as outlined earlier, and use
`{{ic|nvidia-xrun}}`{=mediawiki} to launch your window manager.

## Troubleshooting

### NVIDIA GPU fails to switch off or is set to be default {#nvidia_gpu_fails_to_switch_off_or_is_set_to_be_default}

See [#Use bbswitch to manage the NVIDIA card](#Use_bbswitch_to_manage_the_NVIDIA_card "wikilink").

If NVIDIA GPU still fails to switch off, or is somehow set to be default whenever you use or not
`{{ic|nvidia-xrun}}`{=mediawiki}, then you might likely need to blacklist specific modules (which were previously
blacklisted by [Bumblebee](Bumblebee "wikilink")). Create this file and restart your system:

```{=mediawiki}
{{hc|/usr/lib/modprobe.d/nvidia-xrun.conf|
blacklist nvidia
blacklist nvidia-drm
blacklist nvidia-modeset
blacklist nvidia-uvm
blacklist nouveau
}}
```
There seems to be a race condition between `{{ic|nvidia-xrun-pm.service}}`{=mediawiki} and
`{{ic|systemd-modules-load.service}}`{=mediawiki} which loads the `{{ic|nvidia}}`{=mediawiki} modules. If the latter
runs first, `{{ic|nvidia-xrun-pm}}`{=mediawiki} will hang (actually the `{{ic|tee}}`{=mediawiki} command) during device
removal. If on the other hand `{{ic|nvidia-xrun-pm}}`{=mediawiki} runs first then it will succeed, and later the modules
will fail to load with an error (which is harmless but ugly). For this reason it might be better to always blacklist the
above modules.

DRM kernel mode setting should be enabled for PRIME synchronization to work (for example on muxless devices where only
the Intel GPU is connected to outputs). However, consider disabling it in case there is an issue. See [NVIDIA#DRM kernel
mode setting](NVIDIA#DRM_kernel_mode_setting "wikilink")

On certain hardware, the NVIDIA GPU exposes two devices on the PCI bus: a 3D controller and an audio device. In this
case, both devices need to be removed from the bus in order for the GPU to fully power down. This can be done by simply
adding a line for the audio device bus id in `{{ic|/etc/default/nvidia-xrun}}`{=mediawiki}, and the corresponding line
in the function `{{ic|turn_off_gpu}}`{=mediawiki} in `{{ic|/usr/bin/nvidia-xrun}}`{=mediawiki} to remove the second
device.

[Category:Graphics](Category:Graphics "wikilink")

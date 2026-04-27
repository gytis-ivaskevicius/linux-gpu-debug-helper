[ja:バーチャルリアリティ](ja:バーチャルリアリティ "wikilink") [zh-hans:Virtual
reality](zh-hans:Virtual_reality "wikilink")
`{{Expansion|Rewrite in progress: many things in this article are outdated}}`{=mediawiki}

[Virtual reality](Wikipedia:Virtual_reality "wikilink") is the process of simulating an environment for a user, using a
variety of peripherals, head mounted displays or [CAVEs](Wikipedia:Cave_automatic_virtual_environment "wikilink"), and
trackers. Instead of showing you a static viewpoint from a screen, it renders your viewpoint relative to where you are
standing, on a head-attached or projected surface, to give an effect identical to your own eyes.

A number of peripherals have been released or are about to be released recently which have brought affordable, extremely
immersive virtual reality to everyone. Most of these peripherals have full or partial Linux support, and many have
[AUR](AUR "wikilink") packages.

## Hardware compatibility {#hardware_compatibility}

The following is a non-exhaustive list of currently supported VR/XR devices, and what software supports them.

### PCVR HMDs {#pcvr_hmds}

+-------------------+-----------------------------------------------+-----------------------------------------------+
| Device            | SteamVR                                       | Monado                                        |
+===================+===============================================+===============================================+
| Valve Index       | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{Yes}}                                       | {{Yes}}                                       |
|                   | ```                                           | ```                                           |
+-------------------+-----------------------------------------------+-----------------------------------------------+
| HTC Vive/Vive Pro | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{Yes}}                                       | {{Yes}}                                       |
|                   | ```                                           | ```                                           |
+-------------------+-----------------------------------------------+-----------------------------------------------+
| HTC Vive Pro Eye  | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{Yes}}                                       | {{Yes}}                                       |
|                   | ```                                           | ```                                           |
|                   | (eye tracking WIP)                            | (eye tracking WIP)                            |
+-------------------+-----------------------------------------------+-----------------------------------------------+
| HTC Vive Pro 2    | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{Yes}}                                       | {{Yes}}                                       |
|                   | ```                                           | ```                                           |
|                   | ([custom driver and                           | (AMD GPUs only, 2 kernel patches required:    |
|                   | patches](https://                             | [1](https://github.com/CertainLach/VivePro2-  |
|                   | github.com/CertainLach/VivePro2-Linux-Driver) | Linux-Driver/blob/master/kernel-patches/0002- |
|                   | needed)                                       | drm-edid-parse-DRM-VESA-dsc-bpp-target.patch) |
|                   |                                               | [2](http                                      |
|                   |                                               | s://github.com/CertainLach/VivePro2-Linux-Dri |
|                   |                                               | ver/blob/master/kernel-patches/0003-drm-amd-u |
|                   |                                               | se-fixed-dsc-bits-per-pixel-from-edid.patch)) |
+-------------------+-----------------------------------------------+-----------------------------------------------+
| Bigscreen Beyond  | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{Yes}}                                       | {{Yes}}                                       |
|                   | ```                                           | ```                                           |
|                   | (AMD GPUs only, [kernel                       | (AMD GPUs only, [kernel                       |
|                   | patch](                                       | patch](                                       |
|                   | https://gist.github.com/galister/08cddf10ac18 | https://gist.github.com/galister/08cddf10ac18 |
|                   | 929647d5fb6308df3e4b/raw/0f6417b6cb069f19d6c2 | 929647d5fb6308df3e4b/raw/0f6417b6cb069f19d6c2 |
|                   | 8b730499c07de06ec413/combined-bsb-6-10.patch) | 8b730499c07de06ec413/combined-bsb-6-10.patch) |
|                   | required)                                     | required)                                     |
+-------------------+-----------------------------------------------+-----------------------------------------------+
| Pimax HMDs        | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{No}}                                        | {{Y|WIP}}                                     |
|                   | ```                                           | ```                                           |
|                   | (planned)                                     | (might work with [kernel                      |
|                   |                                               | patch]                                        |
|                   |                                               | (https://gist.githubusercontent.com/TayouVR/6 |
|                   |                                               | 0e3ee5f95375827a66a8898bea02bec/raw/c85135c8d |
|                   |                                               | 8821ebb2fa85629d837a41de57e12ef/pimax.patch)) |
+-------------------+-----------------------------------------------+-----------------------------------------------+
| WMR               | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{Yes}}                                       | {{Yes}}                                       |
|                   | ```                                           | ```                                           |
|                   | (common HMDs, Monado SteamVR plugin)          | (6DoF controllers experimental)               |
+-------------------+-----------------------------------------------+-----------------------------------------------+
| Oculus Rift CV1   | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{Yes}}                                       | {{Yes}}                                       |
|                   | ```                                           | ```                                           |
|                   | (OpenHMD recommended)                         | (OpenHMD recommended)                         |
+-------------------+-----------------------------------------------+-----------------------------------------------+
| Oculus Rift S     | ```{=mediawiki}                               | ```{=mediawiki}                               |
|                   | {{Yes}}                                       | {{Yes}}                                       |
|                   | ```                                           | ```                                           |
|                   | (Monado SteamVR plugin)                       | (6DoF controllers experimental)               |
+-------------------+-----------------------------------------------+-----------------------------------------------+
|                   |                                               |                                               |
+-------------------+-----------------------------------------------+-----------------------------------------------+

In addition, there\'s an experimental PC-PC stream client for WiVRn that might work with the above HMDs that are
supported by Monado.

### Standalone HMDs {#standalone_hmds}

Entries marked with \"Yes\" but without store links can be sideloaded from their corresponding project websites.

+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| Device                | WiVRn                       | SteamVR through ALVR        | SteamVR through Steam Link  |
+=======================+=============================+=============================+=============================+
| Meta Quest 2/3/3S/Pro | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{Yes}}                     | {{Yes}}                     | {{Yes}}                     |
|                       | ```                         | ```                         | ```                         |
|                       | ([Meta Quest                | ([Meta Quest                | ([Meta Quest                |
|                       | Store                       | Stor                        | Store](https:               |
|                       | ](https://www.meta.com/expe | e](https://www.meta.com/exp | //www.oculus.com/experience |
|                       | riences/7959676140827574/)) | eriences/7674846229245715)) | s/quest/5841245619310585/)) |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| Meta Quest 1          | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{Yes}}                     | {{Yes}}                     | {{No}}                      |
|                       | ```                         | ```                         | ```                         |
|                       |                             | ([Sidequest](https://s      |                             |
|                       |                             | idequestvr.com/app/9/alvr)) |                             |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| Pico 4/4 Ultra        | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{Yes}}                     | {{Yes}}                     | {{Yes}}                     |
|                       | ```                         | ```                         | ```                         |
|                       |                             |                             | ([Pico                      |
|                       |                             |                             | Store](https://store-g      |
|                       |                             |                             | lobal.picoxr.com/global/det |
|                       |                             |                             | ail/1/7494362493653958711)) |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| Pico Neo 3            | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{Yes}}                     | {{Yes}}                     | {{Yes}}                     |
|                       | ```                         | ```                         | ```                         |
|                       |                             |                             | ([Pico                      |
|                       |                             |                             | Store](https://store-g      |
|                       |                             |                             | lobal.picoxr.com/global/det |
|                       |                             |                             | ail/1/7494362493653958711)) |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| HTC Vive Focus 3      | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{Yes}}                     | {{Yes}}                     | {{Yes}}                     |
|                       | ```                         | ```                         | ```                         |
|                       |                             |                             | ([Viveport](https://www.vi  |
|                       |                             |                             | veport.com/apps/88fa627f-6c |
|                       |                             |                             | 4e-4dc2-a3f2-f593d14c3207)) |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| HTC Vive XR Elite     | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{Yes}}                     | {{Yes}}                     | {{Yes}}                     |
|                       | ```                         | ```                         | ```                         |
|                       |                             |                             | ([Viveport](https://www.vi  |
|                       |                             |                             | veport.com/apps/88fa627f-6c |
|                       |                             |                             | 4e-4dc2-a3f2-f593d14c3207)) |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| Lynx R1               | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{Yes}}                     | {{Yes}}                     | {{No}}                      |
|                       | ```                         | ```                         | ```                         |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| Apple Vision Pro      | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{No}}                      | {{Yes}}                     | {{No}}                      |
|                       | ```                         | ```                         | ```                         |
|                       |                             | ([Apple App                 |                             |
|                       |                             | Store](https://apps.apple.  |                             |
|                       |                             | com/app/alvr/id6479728026)) |                             |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+
| Samsung Galaxy XR     | ```{=mediawiki}             | ```{=mediawiki}             | ```{=mediawiki}             |
|                       | {{Yes}}                     | {{No}}                      | {{No}}                      |
|                       | ```                         | ```                         | ```                         |
|                       |                             | ([partially                 |                             |
|                       |                             | w                           |                             |
|                       |                             | orking](https://github.com/ |                             |
|                       |                             | alvr-org/ALVR/issues/3070)) |                             |
+-----------------------+-----------------------------+-----------------------------+-----------------------------+

### Tracking devices {#tracking_devices}

+-----------------------+----------------------+-----------------------+-----------------+
| Device                | SteamVR              | Monado                | WiVRn           |
+=======================+======================+=======================+=================+
| Vive/Tundra trackers  | ```{=mediawiki}      | ```{=mediawiki}       | ```{=mediawiki} |
|                       | {{Yes}}              | {{Yes}}               | {{Yes}}         |
|                       | ```                  | ```                   | ```             |
|                       | (native or spacecal) | (native or motoc)     | (motoc)         |
+-----------------------+----------------------+-----------------------+-----------------+
| SlimeVR trackers      | ```{=mediawiki}      | ```{=mediawiki}       | ```{=mediawiki} |
|                       | {{Yes}}              | {{Yes}}               | {{Yes}}         |
|                       | ```                  | ```                   | ```             |
+-----------------------+----------------------+-----------------------+-----------------+
| Project Babble        | ```{=mediawiki}      | ```{=mediawiki}       | ```{=mediawiki} |
|                       | {{Yes}}              | {{Yes}}               | {{Yes}}         |
|                       | ```                  | ```                   | ```             |
|                       | (oscavmgr)           | (oscavmgr)            | (oscavmgr)      |
+-----------------------+----------------------+-----------------------+-----------------+
| Eyetrack VR           | ```{=mediawiki}      | ```{=mediawiki}       | ```{=mediawiki} |
|                       | {{Yes}}              | {{Yes}}               | {{Yes}}         |
|                       | ```                  | ```                   | ```             |
|                       | (oscavmgr)           | (oscavmgr)            | (oscavmgr)      |
+-----------------------+----------------------+-----------------------+-----------------+
| Mercury hand tracking | ```{=mediawiki}      | ```{=mediawiki}       | ```{=mediawiki} |
|                       | {{No}}               | {{Yes}}               | {{No}}          |
|                       | ```                  | ```                   | ```             |
|                       |                      | (survive driver only) |                 |
+-----------------------+----------------------+-----------------------+-----------------+
| Lucid VR gloves       | ```{=mediawiki}      | ```{=mediawiki}       | ```{=mediawiki} |
|                       | {{C|?}}              | {{Yes}}               | {{No}}          |
|                       | ```                  | ```                   | ```             |
|                       |                      | (survive driver only) |                 |
+-----------------------+----------------------+-----------------------+-----------------+
| Kinect based FBT      | ```{=mediawiki}      | ```{=mediawiki}       | ```{=mediawiki} |
|                       | {{Yes}}              | {{Yes}}               | {{Y|WIP}}       |
|                       | ```                  | ```                   | ```             |
|                       |                      | (experimental)        |                 |
+-----------------------+----------------------+-----------------------+-----------------+
| Standable FBT         | ```{=mediawiki}      | ```{=mediawiki}       | ```{=mediawiki} |
|                       | {{No}}               | {{No}}                | {{No}}          |
|                       | ```                  | ```                   | ```             |
+-----------------------+----------------------+-----------------------+-----------------+

## Supported runtimes and toolkits {#supported_runtimes_and_toolkits}

### OpenXR

[OpenXR](https://www.khronos.org/openxr/) is an open, royalty-free standard for access to virtual reality and augmented
reality platforms and devices. It is maintained by the Khronos Group and adopted by most of the industry. Most runtimes
support OpenXR.

### Monado

[Monado](https://monado.dev/) is an open source OpenXR runtime developed by Collabora. It is under heavy development and
aims to provide a common runtime supporting most headsets. Current progress can be found here:
<https://monado.freedesktop.org/>

Install using `{{AUR|monado}}`{=mediawiki}.

#### Envision

[Envision](https://gitlab.com/gabmus/envision) is a graphical app that acts as an orchestrator to get a full
[Monado](https://lvra.gitlab.io/docs/fossvr/monado/) setup up and running with a few clicks. Envision attempts to
construct a working runtime with both a native OpenXR and an OpenVR API, provided by
[XRizer](https://github.com/Supreeeme/xrizer) or [OpenComposite](https://lvra.gitlab.io/docs/fossvr/opencomposite/), for
client applications to utilize.

#### WiVRn

[WiVRn](https://github.com/WiVRn/WiVRn/) is a runtime based on Monado, capable of streaming to standalone headsets. It
currently supports most available Android based HMDs, and also has experimental support for PC to PC streaming.

Upstream recommends to install `{{AUR|wivrn-server}}`{=mediawiki}, `{{AUR|xrizer}}`{=mediawiki} or
`{{AUR|xrizer-git}}`{=mediawiki} (for compatibility with Steam games and OpenVR applications), and optionally
`{{AUR|wivrn-dashboard}}`{=mediawiki} for the dashboard. It is also available [via
Flatpak](https://flathub.org/apps/io.github.wivrn.wivrn). You can install the Android client from your devices\' store,
download the prebuilt Android client from the [GitHub releases](https://github.com/WiVRn/WiVRn/releases) to sideload, or
compile it yourself according to the [build
documentation](https://github.com/WiVRn/WiVRn/blob/master/docs/building.md#client-headset).

### OpenVR / SteamVR {#openvr_steamvr}

OpenVR is an effort by Valve to create an open API for VR development. Unfortunately, while the API is open, the actual
default implementation (SteamVR) is not. SteamVR also provides an OpenXR runtime.

#### Setting up SteamVR {#setting_up_steamvr}

[Install](Install "wikilink") [Vulkan](Vulkan "wikilink") and [Steam](Steam "wikilink"). If using
[NVIDIA](NVIDIA "wikilink") drivers, you may need to set the
[VK_DRIVER_FILES](Vulkan#NVIDIA_-_vulkan_is_not_working_and_can_not_initialize "wikilink") environment variable.
Required dependencies for 32-bit packages are: `{{AUR|lib32-gtk2}}`{=mediawiki}, `{{Pkg|lib32-libva}}`{=mediawiki},
`{{Pkg|lib32-libvdpau}}`{=mediawiki}.

From Steam, install SteamVR from the tools menu.

#### ALVR

ALVR is a SteamVR driver which allows streaming to standalone headsets like the Meta/Oculus Quest. It is available in
the `{{AUR|alvr}}`{=mediawiki} package.

#### Steam Link {#steam_link}

Valve\'s closed-source Steam Link App allows streaming games from a PC running SteamVR to supported headsets without
relying on third-party software. It supports both a VR mode for proper VR games and a flat-screen mode for desktop
games. If the App finds your PC but fails to connect to SteamVR, you may have to open some ports in your firewall as
described [here](https://help.steampowered.com/faqs/view/3E3D-BE6B-787D-A5D2).

### OpenHMD

[OpenHMD](http://www.openhmd.net/) is currently not maintained, and should be treated as deprecated for all but older
HMD\'s. It aimed to provide a Free and Open Source API and drivers for immersive technology, such as head mounted
displays with built in head tracking. The aim was to implement support for as many devices as possible in a portable,
cross-platform package.

OpenHMD only supports older devices such as Oculus Rift, HTC Vive, Sony PSVR, Deepoon E2 and others, so it is not needed
for newer devices, and should not be considered. Most of the HMD driver efforts are now going towards Monado. There\'s a
[fork](https://github.com/thaytan/OpenHMD) focusing on Oculus Rift CV1 tracking, and it\'s still recommended for that
specific headset; use Monado otherwise.

#### SteamVR support {#steamvr_support}

It is possible to use OpenHMD with SteamVR. To do that, you need to install `{{AUR|steamvr-openhmd-git}}`{=mediawiki}
and create a symlink that points to the OpenHMD SteamVR driver inside your SteamVR drivers directory, for example:

`$ ln -s /usr/lib/steamvr/openhmd ~/.steam/steam/steamapps/common/SteamVR/drivers/openhmd`

## Other software {#other_software}

### vr-video-player {#vr_video_player}

A simple tool to view any [X11](X11 "wikilink") window inside your VR headset. vr-video-player supports
stereoscopic/180°/360° videos/games. vr-video-player also lets you view regular videos/games/windows inside VR as a flat
screen.

Available as `{{AUR|vr-video-player}}`{=mediawiki}.

#### xr-video-player {#xr_video_player}

A fork of vr-video-player for OpenXR and wayland that uses pipewire to capture a window or screen/s.

Available as `{{AUR|xr-video-player-git}}`{=mediawiki}.

### SideQuest

SideQuest can be used to install [APK files](Wikipedia:APK_file "wikilink") to your Oculus Quest. It is available as
`{{AUR|sidequest-bin}}`{=mediawiki}.

See <https://sidequestvr.com/setup-howto> for installation steps:

1.  Create an Oculus developer account.
2.  Turn on Quest in developer mode (e.g., with your phone) and connect your Quest via cable.
3.  Press *Allow USB debugging* inside Quest.

See the [SideQuest website](https://sidequestvr.com) for more information.

### WayVR

[WayVR](https://github.com/wlx-team/wayvr) is a lightweight OpenXR/OpenVR overlay that can mirror and control
X11/Wayland desktops. It can also act as a Wayland compositor.

Available as `{{AUR|wayvr}}`{=mediawiki} and `{{AUR|wayvr-git}}`{=mediawiki}.

### Stardust XR {#stardust_xr}

[Stardust XR](https://stardustxr.org/) ([GitHub](https://github.com/StardustXR)) is a modular XR display server. It can
act as an overlay (and can run side by side with wlx-overlay-s) or as a standalone application. It can provide a Wayland
compositor using `{{AUR|stardust-xr-flatland}}`{=mediawiki}, an application launcher with
`{{AUR|stardust-xr-protostar}}`{=mediawiki}, skyboxes/home environments with
`{{AUR|stardust-xr-atmosphere}}`{=mediawiki} and several other features using [other
packages](https://aur.archlinux.org/packages?K=stardust-xr). Install the server with
`{{AUR|stardust-xr-server}}`{=mediawiki}; you can also install `{{AUR|stardust-xr-telescope}}`{=mediawiki} for a premade
startup script.

## Troubleshooting

### SteamVR support {#steamvr_support_1}

#### Configuration or startup errors {#configuration_or_startup_errors}

SteamVR/OpenVR creates a directory `{{ic|~/.openvr}}`{=mediawiki} that can get misconfigured over the various versions.
Delete that directory and completely uninstall/reinstall SteamVR.

It can also apparently have trouble accessing different HMD\'s under some configurations. Please refer to the HMD
compatibilty chart to see if your headset is compatible.

### Games/Programs

Most XR applications run without major issues through [Proton](Proton "wikilink") or Proton GE.
[Proton-GE-RTSP](https://github.com/SpookySkeletons/proton-ge-rtsp), which provides targeted fixes for VRChat and other
social VR platforms, can be installed using `{{AUR|protonup-qt}}`{=mediawiki} or `{{AUR|protonup-rs}}`{=mediawiki}. If a
game has issues running through Proton, please refer to the game\'s Linux/Wine compatibility information,
[ProtonDB](https://www.protondb.com/) and documentation for the XR runtimes and compatibility layers in use for possible
fixes.

### Other Issues {#other_issues}

Because of the nature of VR on Linux it is very common for a wide variety of issues to pop up, and because of the sheer
amount of possible issues, it is not possible to write out everything here. Instead, please refer to either the
software\'s respective documentation, the [Linux VR Adventures Wiki](https://lvra.gitlab.io), or the [Linux VR
Adventures Discord](https://discord.gg/phCEHFyMZP) for help on any possible issue you are facing.

[Category:Graphics](Category:Graphics "wikilink")

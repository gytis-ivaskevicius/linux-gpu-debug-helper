```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## Monado

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
[Monado](https://monado.freedesktop.org/) is an open source OpenXR runtime. It offers support for a variety of hardware
using its built-in drivers and can be used to run any OpenXR and, with the help of OpenComposite, most OpenVR
applications.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Monado can be configured using its NixOS options `{{Nixos:option|services.monado.enable}}`{=mediawiki}:

```{=html}
</div>
```
```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=services.monado = {
  enable = true;
  defaultRuntime = true; # Register as default OpenXR runtime
};}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
In order to configure Monado, you might want to add additional environment variables:

```{=html}
</div>
```
```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=systemd.user.services.monado.environment = {
  STEAMVR_LH_ENABLE = "1";
  XRT_COMPOSITOR_COMPUTE = "1";
};}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Once configured, Monado can be started and stopped in a [systemd](systemd "wikilink") user session.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
For example, the following commands will start Monado and then follow its log output:

```{=html}
</div>
```
```{=mediawiki}
{{Commands|
$ systemctl --user start monado.service
$ journalctl --user --follow --unit monado.service
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
### Hand Tracking {#hand_tracking}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
You may notice that running `monado-services` will fail due to the lack of hand tracking data. There are 2 ways to
remedy this, either disable hand tracking altogether, or download the hand tracking data.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To disable hand tracking, modify the environment variable to include `WMR_HANDTRACKING = "0";`, so that it will look
like this.

```{=html}
</div>
```
```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=systemd.user.services.monado.environment = {
  STEAMVR_LH_ENABLE = "1";
  XRT_COMPOSITOR_COMPUTE = "1";
  WMR_HANDTRACKING = "0";
};}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To get hand tracking to work, you require `git-lfs` to be enabled. The standard way of enabling `git-lfs` is through the
configuration below

```{=html}
</div>
```
```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=programs.git = {
  enable = true;
  lfs.enable = true;
};}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
After making sure `git-lfs` is enabled, run these commands and restart `monado-service`

```{=html}
</div>
```
```{=mediawiki}
{{Commands|
$ mkdir -p ~/.local/share/monado
$ cd ~/.local/share/monado
$ git clone https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
For further information about available environment variables and tweaks, read the [Linux VR Adventures
wiki](https://lvra.gitlab.io/docs/fossvr/monado/) and the [Monado documentation about environment
variables](https://monado.freedesktop.org/getting-started.html#environment-variables)

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## OpenComposite

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
[OpenComposite](https://gitlab.com/znixian/OpenOVR) is a compatibility layer for running OpenVR applications on an
OpenXR runtime like Monado. It is comparable to tools like DXVK or vkd3d, but for translating OpenVR calls to OpenXR.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
In order to run OpenVR games on anything other than SteamVR, you need to configure the OpenVR runtime path defined in
`~/.config/openvr/openvrpaths.vrpath`. A reliable way to do this is to use [Home Manager](Home_Manager "wikilink") to
create this file.

```{=html}
</div>
```
```{=mediawiki}
{{Warning|<span lang="en" dir="ltr" class="mw-content-ltr">Older versions of Proton will always query the current OpenVR and OpenXR runtime. If you use OpenComposite, and it fails to initialize an OpenXR context, Proton will fail to launch. A workaround is to delete the ~/.config/openvr/openvrpaths.vrpath file and then retry launching the game.</span>}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
If this file is not set to read-only, SteamVR will add its runtime path back, hence the use for Home Manager.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
An example configuration for enabling OpenComposite may look like this:

```{=html}
</div>
```
```{=mediawiki}
{{file|~/.config/home-manager/home.nix|nix|3=# For Monado:
xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";

# For WiVRn v0.22 and below:
xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";

xdg.configFile."openvr/openvrpaths.vrpath".text = ''
  {
    "config" :
    [
      "${config.xdg.dataHome}/Steam/config"
    ],
    "external_drivers" : null,
    "jsonid" : "vrpathreg",
    "log" :
    [
      "${config.xdg.dataHome}/Steam/logs"
    ],
    "runtime" :
    [
      "${pkgs.opencomposite}/lib/opencomposite"
    ],
    "version" : 1
  }
'';}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
If you are planning to play any OpenVR game on Steam or OpenXR games through Proton, you will have to use OpenComposite
in this manner. In most cases you also have to allow access to the socket path of your OpenXR runtime to Steam\'s
runtime, by using the following launch options for XR applications on Steam:
`env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%`. This example is for Monado, while other
XR runtimes might differ.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## WiVRn

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
WiVRn is an OpenXR streaming application built around Monado. It wirelessly connects a standalone VR headset to a Linux
computer. If your headset is not wireless, look at [Monado](VR#Monado "wikilink") instead. Example usage of the WiVRn
module:

```{=html}
</div>
```
```{=mediawiki}
{{Warning|<span lang="en" dir="ltr" class="mw-content-ltr">As of WiVRn version 0.23, WiVRn now manages the opencomposite paths itself. Only use the above opencomposite configuration when using versions below v0.23.</span>}}
```
```{=mediawiki}
{{File|/etc/nixos/configuration.nix|nix|3=services.wivrn = {
  enable = true;
  openFirewall = true;

  # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
  # will automatically read this and work with WiVRn (Note: This does not currently
  # apply for games run in Valve's Proton)
    defaultRuntime = true;

  # Run WiVRn as a systemd service on startup
  autoStart = true;

  # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
  config = {
    enable = true;
    json = {
      # 1.0x foveation scaling
      scale = 1.0;
      # 100 Mb/s
      bitrate = 100000000;
      encoders = [
        {
          encoder = "vaapi";
          codec = "h265";
          # 1.0 x 1.0 scaling
          width = 1.0;
          height = 1.0;
          offset_x = 0.0;
          offset_y = 0.0;
        }
      ];
    };
  };
};}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Like Monado, you will also have to add the launch argument for WiVRn to allow access to the socket:
`PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/wivrn/comp_ipc %command%`

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## Envision

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Envision is an orchestrator for the FOSS VR stack. It handles the building and configuration of Monado, WiVRn,
OpenComposite, and other utilities of the FOSS VR stack such as the Lighthouse driver, OpenHMD, Survive, and WMR. You
can enable it with the Envision module:

```{=html}
</div>
```
```{=mediawiki}
{{File|/etc/nixos/configuration.nix|nix|3=programs.envision = {
  enable = true;
  openFirewall = true; # This is set true by default
};}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## SteamVR

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
[SteamVR](https://store.steampowered.com/app/250820/SteamVR/) is a proprietary OpenVR runtime with compatibility for
OpenXR. It is part of [Steam](Steam "wikilink") and doesn\'t need any additional setup on NixOS apart from enabling
Steam.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
After installing SteamVR through Steam and plugging in a SteamVR-compatible headset, SteamVR should work for the most
part.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
On initial setup, SteamVR will ask for elevated permissions, to set up a file capability for one of its binaries. This
is needed to allow asynchronous reprojection to work. Clients need the `CAP_SYS_NICE` capability to acquire a
high-priority context, which is a requirement for asynchronous reprojection.

```{=html}
</div>
```
```{=mediawiki}
{{Note|<span lang="en" dir="ltr" class="mw-content-ltr">Steam is run in a bubblewrap-based FHS environment. This environment runs Steam in a user namespace, which prevents it from using any capabilities or setuid binaries. This means that asynchronous reprojection can not be used on NixOS, without patching the kernel to remove these restrictions completely, or modifying the bubblewrap binary used for running Steam to remove these capability protections. Both of these workarounds come with their own security tradeoffs. See this [https://github.com/NixOS/nixpkgs/issues/217119 Nixpkgs issue]</span>}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
### Patching AMDGPU to allow high priority queues {#patching_amdgpu_to_allow_high_priority_queues}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
By applying [this
patch](https://github.com/Frogging-Family/community-patches/blob/a6a468420c0df18d51342ac6864ecd3f99f7011e/linux61-tkg/cap_sys_nice_begone.mypatch),
the AMDGPU kernel driver will ignore process privileges and allow any application to create high priority contexts.

```{=html}
</div>
```
```{=mediawiki}
{{Warning|<span lang="en" dir="ltr" class="mw-content-ltr">This removes intentional restrictions from the kernel, and it could cause scheduling issues. While it has not been reported that it does cause issues, this should be considered an unsupported configuration.</span>}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### Applying as a NixOS kernel patch {#applying_as_a_nixos_kernel_patch}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
To workaround the `CAP_SYS_NICE` requirement, we can apply a kernel patch using the following NixOS configuration
snippet:

```{=html}
</div>
```
```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=boot.kernelPatches = [
  {
    name = "amdgpu-ignore-ctx-privileges";
    patch = pkgs.fetchpatch {
      name = "cap_sys_nice_begone.patch";
      url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
      hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    };
  }
];
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
It is also possible to just patch amdgpu and build it as an out-of-tree module, as described in
[Linux_kernel#Patching_a_single_In-tree_kernel_module](Linux_kernel#Patching_a_single_In-tree_kernel_module "wikilink")

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
### Patching bubblewrap to allow capabilities {#patching_bubblewrap_to_allow_capabilities}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
By modifying the bubblewrap binary used for running Steam, you can allow processes in that FHS environment to acquire
capabilities. This removes the need for patching the kernel directly.

```{=html}
</div>
```
```{=mediawiki}
{{Warning|<span lang="en" dir="ltr" class="mw-content-ltr">This circumvents an intended security mechanism in bubblewrap, and allows all other software launched by steam, or running via steam-run to acquire these capabilities as well.</span>}}
```
```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|3=programs.steam = let
  patchedBwrap = pkgs.bubblewrap.overrideAttrs (o: {
    patches = (o.patches or []) ++ [
      ./bwrap.patch
    ];
  });
in {
  enable = true;
  package = pkgs.steam.override {
    buildFHSEnv = (args: ((pkgs.buildFHSEnv.override {
      bubblewrap = patchedBwrap;
    }) (args // {
      extraBwrapArgs = (args.extraBwrapArgs or []) ++ [ "--cap-add ALL" ];
    })));
  };
};
}}
```
```{=mediawiki}
{{file|/etc/nixos/bwrap.patch|diff|3=diff --git a/bubblewrap.c b/bubblewrap.c
index 8322ea0..4e20262 100644
--- a/bubblewrap.c
+++ b/bubblewrap.c
@@ -868,13 +868,6 @@ acquire_privs (void)
       /* Keep only the required capabilities for setup */
       set_required_caps ();
     }
-  else if (real_uid != 0 && has_caps ())
-    {
-      /* We have some capabilities in the non-setuid case, which should not happen.
-         Probably caused by the binary being setcap instead of setuid which we
-         don't support anymore */
-      die ("Unexpected capabilities but not setuid, old file caps config?");
-    }
   else if (real_uid == 0)
     {
       /* If our uid is 0, default to inheriting all caps; the caller
}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
as an additional change, you may also need to replace Steam\'s own bwrap binary with a symbolic link to this modified
bwrap binary, found at `~/.local/share/Steam/ubuntu12_32/steam-runtime/usr/libexec/steam-runtime-tools-0/srt-bwrap`.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
Steam will periodically replace this modification with its own binary when steam-runtime updates, so you may need to
re-apply this change if it breaks.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## wlx-overlay-s {#wlx_overlay_s}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
[wlx-overlay-s](https://github.com/galister/wlx-overlay-s) is a lightweight OpenXR/OpenVR overlay for Wayland and X11
desktops. It works with SteamVR as well as Monado/WiVRn natively.

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
#### SteamVR autostart {#steamvr_autostart}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
When launching wlx-overlay-s in SteamVR (or any OpenVR compositor) it will register an autostart manifest. Currently,
this manifest will reference a Nix store path of wlx-overlay-s, which might get garbage collected after rebuilds of your
NixOS/Nix profile. A workaround is to regularly run the following command to update the manifest\'s store path:

```{=html}
</div>
```
```{=mediawiki}
{{Commands|
# <span lang="en" dir="ltr" class="mw-content-ltr">Run wlx-overlay-s and replace any running instance</span>
$ wlx-overlay-s --replace}}
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
## See also {#see_also}

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
-   [Linux VR Adventures Wiki](https://lvra.gitlab.io)

```{=html}
</div>
```
```{=html}
<div lang="en" dir="ltr" class="mw-content-ltr">
```
```{=html}
</div>
```
[Category:Video](Category:Video "wikilink") [Category:Hardware](Category:Hardware "wikilink")
[Category:Desktop](Category:Desktop "wikilink") [Category:Gaming](Category:Gaming "wikilink")

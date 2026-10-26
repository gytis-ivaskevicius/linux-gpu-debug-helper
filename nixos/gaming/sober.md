**Sober** is an unofficial client of [Roblox](Roblox "wikilink") for Linux, which works by running the Android
application in a compatibility layer. [^1]

```{=mediawiki}
{{Infobox application
| name = Sober
| type = Roblox client
| image = Sober.svg
| website = https://sober.vinegarhq.org/
| documentation = https://vinegarhq.org/Sober/Configuration/index.html
| bugTracker = https://github.com/vinegarhq/sober/issues
| github = https://github.com/vinegarhq/sober
}}
```
## Installation.

There is no Nix package for Sober as for now, the only way to install it is through flatpak:

1.  Setup [Flatpak](Flatpak "wikilink") and Flathub, instructions for both can be found on the relevant pages.
2.  Install the Sober flatpak by running: `flatpak install flathub org.vinegarhq.Sober`

## Sober itself. {#sober_itself.}

If you wish to edit the FFLags, You can go to the sober fflags directory
`~/.var/app/org.vinegarhq.Sober/config/sober/config.json` and edit it via there, Using your preferred editor like nano
or vim edit the file.

If you have questions like \"How does Sober work? Is it official? Will it get blocked by Roblox?\", Click the link below
to go to their FAQs.

```{=html}
<references />
```
If you have other questions or issues with it, Click the link down below to go to their github.

## Running Sober in a NixOS container {#running_sober_in_a_nixos_container}

This runs Sober inside a [NixOS container](NixOS_Containers "wikilink"). Run `sober` to start it. When you close Sober,
the container stops. Your data stays there for the next launch.

The setup worked on NixOS 26.05 with Wayland, an AMD GPU, systemd 260.4 and Flatpak 1.18.4. This version uses an example
username and passes Nix evaluation. It has not been tested with NVIDIA or X11.

#### Setup

You need Wayland, a working GPU and PulseAudio or PipeWire with PulseAudio support. Your user must be able to use
`sudo`. The firewall rules use iptables and will not work with `networking.nftables.enable = true`.

The container uses IPv4 and public DNS. It cannot connect to the host or the private network addresses listed in the
code. Choose container addresses that are not already used on your network.

Save the code below as `sober-container.nix`. Change the settings at the top to match your machine. Check your UID with
`id -u` and your group with `id -gn`. If you already use NAT, keep the same external interface. Use paths without
spaces.

``` nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Host settings
  user = "alice"; # Host username
  uid = 1000; # id -u alice
  group = "users"; # id -gn alice
  homePath = "/home/${user}"; # Change if your home is elsewhere
  runPath = "/run/user/${toString uid}";
  containerName = "roblox"; # Up to 12 characters (interface: ve-<name>)
  waylandDisplay = "wayland-1"; # echo "$WAYLAND_DISPLAY" in the desktop session
  gpuNode = "/dev/dri/renderD128"; # Check ls -l /dev/dri
  externalInterface = "wlan0"; # Check ip -4 route show default
  hostAddress = "10.100.0.1";
  localAddress = "10.100.0.2";
  app = "org.vinegarhq.Sober";
  nameserver = "1.1.1.1"; # Must be reachable outside the LAN
  dataDir = "${homePath}/.local/share/sober-container";
  discordDir = "/run/sober-discord";
  # Also exposes keyboards and mice. Leave off unless you need a controller.
  enableControllers = false;
  blockedNetworks = [
    "0.0.0.0/8"
    "10.0.0.0/8"
    "100.64.0.0/10"
    "127.0.0.0/8"
    "169.254.0.0/16"
    "172.16.0.0/12"
    "192.168.0.0/16"
    "224.0.0.0/4"
    "240.0.0.0/4"
  ];
  egressRules = [ "-m addrtype --dst-type LOCAL" ] ++ map (net: "-d ${net}") blockedNetworks;
in
{
  assertions = [
    {
      assertion = !config.networking.nftables.enable && config.networking.firewall.enable;
      message = "The Sober container example requires the host iptables firewall backend.";
    }
    {
      assertion = builtins.match "[a-zA-Z0-9][a-zA-Z0-9-]{0,11}" containerName != null;
      message = "Choose an alphanumeric container name of at most 12 characters (hyphens allowed).";
    }
  ];

  networking.firewall.enable = lib.mkDefault true;
  networking.nat = {
    enable = true;
    inherit externalInterface;
    internalInterfaces = [ "ve-${containerName}" ];
  };

  # Block access to the host and private networks before NAT.
  networking.firewall.extraCommands =
    lib.concatMapStringsSep "\n" (rule: ''
      iptables -w -t raw -C PREROUTING -i ve-${containerName} ${rule} -j DROP 2>/dev/null || \
        iptables -w -t raw -A PREROUTING -i ve-${containerName} ${rule} -j DROP
    '') egressRules
    + lib.optionalString config.networking.enableIPv6 ''
      ip6tables -w -t raw -C PREROUTING -i ve-${containerName} -j DROP 2>/dev/null || \
        ip6tables -w -t raw -A PREROUTING -i ve-${containerName} -j DROP
    '';
  networking.firewall.extraStopCommands =
    lib.concatMapStringsSep "\n" (rule: ''
      iptables -w -t raw -D PREROUTING -i ve-${containerName} ${rule} -j DROP 2>/dev/null || true
    '') egressRules
    + lib.optionalString config.networking.enableIPv6 ''
      ip6tables -w -t raw -D PREROUTING -i ve-${containerName} -j DROP 2>/dev/null || true
    '';

  # Hide the host Nix socket; mounting a socket read-only still allows connections.
  systemd.services."container@${containerName}".serviceConfig.BindReadOnlyPaths = [
    "${pkgs.emptyDirectory}:/nix/var/nix/daemon-socket"
  ];

  # Flatpak runtimes stay in /var/lib/nixos-containers; app data goes in dataDir.
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0700 ${user} ${group} - -"
    "d ${discordDir} 0700 ${user} ${group} - -"
  ];

  # The proxy socket stays available when Discord is closed.
  systemd.user.sockets."${containerName}-discord-proxy" = {
    unitConfig.ConditionUser = user;
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = "${discordDir}/discord-ipc-0";
      SocketMode = "0600";
      RemoveOnStop = true;
    };
  };
  systemd.user.services."${containerName}-discord-proxy" = {
    unitConfig.ConditionUser = user;
    serviceConfig.ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd %t/discord-ipc-0";
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "sober" ''
      set -euo pipefail
      if [[ "$(${pkgs.coreutils}/bin/id -u)" != "${toString uid}" ]]; then
        echo "Run sober as ${user}, without sudo." >&2
        exit 1
      fi
      for socket in ${runPath}/${waylandDisplay} ${runPath}/pulse/native; do
        if [[ ! -S "$socket" ]]; then
          echo "Desktop socket missing: $socket. Start your Wayland/audio session first." >&2
          exit 1
        fi
      done
      exec 9>${runPath}/${containerName}.lock
      if ! ${pkgs.util-linux}/bin/flock -n 9; then
        echo "Sober is already running through this launcher." >&2
        exit 1
      fi
      ${pkgs.systemd}/bin/systemctl --user start ${containerName}-discord-proxy.socket
      # Run cleanup under the same sudo session, even after a long game.
      sudo ${pkgs.writeShellScript "${containerName}-session" ''
        set -euo pipefail
        trap '${pkgs.nixos-container}/bin/nixos-container stop ${containerName}' EXIT
        ${pkgs.nixos-container}/bin/nixos-container start ${containerName}
        # Wait for first-run installation and socket setup.
        ${pkgs.systemd}/bin/systemctl --machine=${containerName} start \
          sober-userns-proc.service sober-desktop-sockets.service sober-flatpak-permissions.service
        ${pkgs.systemd}/bin/machinectl shell ${user}@${containerName} \
          /bin/sh -lc 'export WAYLAND_DISPLAY=${waylandDisplay} PULSE_SERVER=unix:${runPath}/pulse/native; exec dbus-run-session -- flatpak run ${app}'
      ''}
    '')
  ];

  containers.${containerName} = {
    autoStart = false;
    ephemeral = false;

    # Desktop sockets need matching UIDs. This does not remap container root.
    privateUsers = "identity";

    privateNetwork = true;
    inherit hostAddress localAddress;

    # logind mounts over /run/user/<uid>, so bind sockets elsewhere first.
    bindMounts = {
      "${homePath}/.var/app/${app}" = {
        hostPath = dataDir;
        isReadOnly = false;
      };
      "/run/host-wayland" = {
        hostPath = "${runPath}/${waylandDisplay}";
        isReadOnly = false;
      };
      "/run/host-pulse" = {
        hostPath = "${runPath}/pulse/native";
        isReadOnly = false;
      };
      "/run/host-discord" = {
        hostPath = discordDir;
        isReadOnly = false;
      };
      "${gpuNode}".isReadOnly = false;
      "/dev/fuse".isReadOnly = false;
    }
    // lib.optionalAttrs enableControllers {
      "/dev/input".isReadOnly = false;
    };

    allowedDevices = [
      {
        node = gpuNode;
        modifier = "rw";
      }
      {
        node = "/dev/fuse";
        modifier = "rw";
      }
    ]
    ++ lib.optional enableControllers {
      node = "char-input";
      modifier = "rw";
    };

    config = { pkgs, ... }: {
      services.flatpak.enable = true;
      hardware.graphics.enable = true;
      nix.enable = false;
      security.sudo.enable = false;
      services.openssh.enable = false;

      # Workaround for nested bubblewrap failing to mount /proc.
      fileSystems."/proc2" = {
        device = "proc";
        fsType = "proc";
      };

      # Let bubblewrap set user namespace limits under /proc/sys/user.
      systemd.services.sober-userns-proc = {
        description = "Expose user namespace limits to Flatpak";
        wantedBy = [ "multi-user.target" ];
        requires = [ "proc2.mount" ];
        after = [ "proc2.mount" ];
        path = [ pkgs.util-linux ];
        script = ''
          mount --bind /proc2/sys/user /proc/sys/user
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      # Bind into the runtime directory after logind creates it.
      systemd.services.sober-desktop-sockets = {
        description = "Expose desktop sockets to Sober";
        wantedBy = [ "multi-user.target" ];
        requires = [ "user-runtime-dir@${toString uid}.service" ];
        after = [ "user-runtime-dir@${toString uid}.service" ];
        path = [
          pkgs.coreutils
          pkgs.util-linux
        ];
        script = ''
          install -d -m 700 -o ${user} -g ${group} \
            ${runPath}/pulse ${runPath}/app ${runPath}/app/com.discordapp.Discord
          touch ${runPath}/${waylandDisplay} ${runPath}/pulse/native
          mount --bind /run/host-wayland ${runPath}/${waylandDisplay}
          mount --bind /run/host-pulse ${runPath}/pulse/native
          # Remove the old socket mount if this container used the earlier setup.
          if mountpoint -q ${runPath}/discord-ipc-0; then
            umount ${runPath}/discord-ipc-0
          fi
          # Mount the directory so replacing the Discord socket does not break it.
          if ! mountpoint -q ${runPath}/app/com.discordapp.Discord; then
            mount --bind /run/host-discord ${runPath}/app/com.discordapp.Discord
          fi
          ln -sfn app/com.discordapp.Discord/discord-ipc-0 ${runPath}/discord-ipc-0
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      # Install once. Use flatpak update inside the container for later updates.
      systemd.services.sober-install = {
        description = "Install Sober from Flathub";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [
          "network-online.target"
          "systemd-resolved.service"
        ];
        path = [ pkgs.flatpak ];
        script = ''
          if ! flatpak info --system ${app} >/dev/null 2>&1; then
            flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            flatpak install --system --noninteractive --assumeyes flathub ${app}
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = "1min";
          TimeoutStartSec = "20min";
        };
      };

      # Sober may request input permission even without a controller attached.
      # Host devices are still blocked unless enableControllers is true.
      systemd.services.sober-flatpak-permissions = {
        description = "Apply Sober device and Discord permissions";
        wantedBy = [ "multi-user.target" ];
        requires = [ "sober-install.service" ];
        after = [ "sober-install.service" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak override --user \
            --nodevice=all --device=dri --device=input \
            --nosocket=x11 --nosocket=fallback-x11 \
            --nosocket=session-bus --nosocket=system-bus \
            --filesystem=xdg-run/app/com.discordapp.Discord:create \
            --filesystem=xdg-run/discord-ipc-0 \
            ${app}
        '';
        serviceConfig = {
          Type = "oneshot";
          User = user;
          Environment = "HOME=${homePath}";
          RemainAfterExit = true;
        };
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = [ "gtk" ];
      };

      users.groups.${group} = { };
      users.users.${user} = {
        isNormalUser = true;
        inherit uid group;
        home = homePath;
        extraGroups = [ "render" ];
        linger = true;
      };

      networking.useHostResolvConf = false;
      networking.enableIPv6 = false;
      services.resolved.enable = true;
      networking.nameservers = [ nameserver ];

      # Keep this at the version used when creating the container.
      system.stateVersion = "26.05";
    };
  };
}
```

Add the file to your NixOS imports.

``` nix
{
  imports = [ ./sober-container.nix ];
}
```

Rebuild with `sudo nixos-rebuild switch`. Add your usual `--flake` argument if you use a flake. If your config is in
Git, add the new file to Git first.

Then open a terminal in your desktop session and run this.

``` console
sober
```

It will ask for your sudo password. The first launch downloads Sober and its Flatpak runtime from Flathub, so it can
take a few minutes. Later launches use what is already installed. You do not need to start the container yourself.

#### Data and updates {#data_and_updates}

Roblox downloads and settings go in `dataDir`. The default is `/home/USER/.local/share/sober-container`. Sober itself
and its Flatpak runtimes stay in `/var/lib/nixos-containers/roblox`. Stopping the container or rebuilding NixOS does not
delete them. An existing Sober installation outside the container is not copied over.

Rebuilding NixOS does not update Sober. Close it and run these commands to update the Flatpaks. Replace `roblox` if you
changed the container name.

``` console
sudo nixos-container start roblox
sudo nixos-container run roblox -- flatpak update --system
sudo nixos-container stop roblox
```

These downloads come from Flathub and are not pinned by your Nix config.

If you restart your desktop or audio service while the container is running, stop the container before opening Sober
again. Do the same after changing its bind mounts.

#### What the container can access {#what_the_container_can_access}

The container shares your kernel. It also keeps the same UID and GID numbers as the host so the desktop sockets work.
Root inside the container still has UID 0. The host Nix daemon socket is hidden. See the [systemd-nspawn
documentation](https://www.freedesktop.org/software/systemd/man/latest/systemd-nspawn.html) for details.

Sober gets access to its data, a GPU render device, Wayland and audio. Audio access includes your microphone, as
explained in the [Flatpak documentation](https://docs.flatpak.org/en/latest/sandbox-permissions.html). Discord presence
uses a proxy socket. Discord or Vesktop needs to be running and providing `discord-ipc-0` for it to work.

Host input devices are blocked by default. Flatpak still gets the `input` permission because Sober can ask for it when
its controller setting is on. That permission alone does not give it access to the host devices.

Setting `enableControllers = true` shares all of `/dev/input`, including keyboards and mice. Access also depends on the
device\'s file permissions.

The extra `/proc` mounts let Flatpak run inside the container. They loosen some of the default restrictions and might
need changes after an update. This setup does not give the same separation as a virtual machine.

```{=html}
<references />
```
[Category:Gaming](Category:Gaming "wikilink") [Category:Applications](Category:Applications "wikilink")

[^1]: <https://github.com/vinegarhq/sober>

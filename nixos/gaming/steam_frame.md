**Steam Frame** is a standalone virtual reality headset from Valve, released on September 18, 2026. It runs SteamOS.
Games installed on the headset need no NixOS configuration. This page covers streaming PC VR from a NixOS host, which
uses [Steam](Steam "wikilink") and [SteamVR](VR#SteamVR "wikilink").

The headset reaches the PC through SteamVR\'s Steam Link driver (`vrlink`), either over the home network or over the
bundled 6 GHz wireless adapter. Home Wi-Fi streaming works on the NixOS default kernel. The adapter does
not.`{{Note|Wi-Fi streaming works on the NixOS default kernel. The bundled adapter does not; it needs Linux 7.2. See [[#Wireless adapter]].}}`{=mediawiki}

## Installation

Enable Steam. This also enables `{{Nixos:option|hardware.steam-hardware.enable}}`{=mediawiki}, which loads the `uinput`
module and installs udev rules for Valve USB and Bluetooth devices (vendor ID `28de`). No extra udev rules are required
for the headset, its controllers, or the wireless adapter.`{{file|/etc/nixos/configuration.nix|nix|3=programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
};}}`{=mediawiki}Then install SteamVR from the Steam library. It is not a Nixpkgs package.

`remotePlay.openFirewall` is required. Without it the headset cannot discover the PC. The option opens the ports Valve
documents for Remote Play and Steam Link:[^1]

-   UDP 27036, for discovery broadcasts
-   TCP 27036 and 27037
-   UDP 10400 and 10401, for the Steam Link video path (`vrlink` binds UDP 10400)
-   UDP 27031--27035

The option does nothing if `{{Nixos:option|networking.firewall.enable}}`{=mediawiki} is false. `vrlink` binds UDP 10400
on every local address, including VPN interfaces, so a hand-written ruleset has to allow that port on the interface the
headset actually uses.

## Pairing

Sign the headset and the PC into the same Steam account, and put them on the same LAN. The headset announces itself with
a UDP broadcast to port 27036; it does not cross a router.

1.  Rebuild and switch, then start Steam on the PC.
2.  On the headset, open the Steam menu. The PC should appear by name.
3.  Connect, and accept the authorization prompt on the PC.

A successful pair shows up in `~/.local/share/Steam/logs/remote_connections.txt` as a broadcast from a client named
`frame`, followed by `k_ERemoteDeviceAuthorizationSuccess`.

Flat games can be started from the headset. For VR games, start SteamVR on the PC first. See [#VR game opens as a flat
window](#VR_game_opens_as_a_flat_window "wikilink").

## Wireless adapter {#wireless_adapter}

The headset has two radios. One joins the home network. The other stands up a dedicated 6 GHz Wi-Fi 6E link. The USB
adapter in the box is what the PC uses to join that link. It is optional: streaming over home Wi-Fi does not need
it.[^2]

The adapter is a Realtek RTL8852CU (also called RTL8832CU) with USB ID `28de:2432`. Linux drives it with the in-tree
module `rtw89_8852cu`. Valve\'s USB ID was added in Linux 7.0.[^3] Linux 7.2 additionally exposes the adapter\'s serial
number and UUID under sysfs, which Steam asked for so it can identify the device without debugfs. Reports show the link
itself working on kernel 7.0, so that sysfs interface is not a hard requirement.[^4]

NixOS 26.05 defaults to Linux 6.18, which does not have this driver. Linux 7.0 and 7.1 have been removed from Nixpkgs
after reaching end of life upstream. As of September 2026, the kernel to use is
`{{Nixos:option|boot.kernelPackages}}`{=mediawiki} `pkgs.linuxPackages_latest`, which is Linux
7.2:`{{file|/etc/nixos/configuration.nix|nix|3=boot.kernelPackages = pkgs.linuxPackages_latest;}}`{=mediawiki}A stock
NixOS kernel builds drivers that are not pinned in the common config as modules, so `rtw89_8852cu` should be present.
The driver loads `rtw89/rtw8852c_fw-2.bin` from `linux-firmware`.
`{{Nixos:option|hardware.enableRedistributableFirmware}}`{=mediawiki} installs that firmware and is enabled by a
generated `hardware-configuration.nix`.

The driver installer the Steam client offers for this adapter is the Windows driver. It does not apply on Linux.

6 GHz is disabled under the world regulatory domain (country `00`).
`{{Nixos:option|hardware.wirelessRegulatoryDatabase}}`{=mediawiki} only installs `regulatory.db`; it does not select a
country. Without one, the phy does not list 5945--6425 MHz. `cfg80211` is a module, so a kernel command-line parameter
is applied too early. Set the country in modprobe config (replace
`DE`):`{{file|/etc/nixos/configuration.nix|nix|3=boot.extraModprobeConfig = ''
  options cfg80211 ieee80211_regdom=DE
'';}}`{=mediawiki}After rebooting into the new kernel, plug the adapter into a USB 3 port and confirm the driver
bound:`{{Commands|$ lsusb -d 28de:2432
$ modinfo rtw89_8852cu
$ journalctl -k -g rtw89}}`{=mediawiki}`lsusb -d 28de:2432` should show a Realtek \"802.11ax WLAN Adapter\", and the
kernel log should show `rtw89_8852cu` loading `rtw89/rtw8852c_fw-2.bin`. A line about 2.4 GHz preferring a USB 2 port is
a stock hint about USB 3 interference on that band. It does not mean the 6 GHz link failed. With a country code set, the
phy lists 6 GHz and the interface can scan.

Users must also be added to the `networkmanager` group for Steam to manage the wireless adapter.
`{{file|/etc/nixos/configuration.nix|nix|3=users.users.<name>.extraGroups = [ "networkmanager" ];}}`{=mediawiki}

## Troubleshooting

### Headset does not see the PC {#headset_does_not_see_the_pc}

-   Confirm `{{Nixos:option|programs.steam.remotePlay.openFirewall}}`{=mediawiki} is `true` and the firewall service is
    enabled. Discovery is a broadcast to UDP 27036. A host firewall that drops broadcasts, or a headset on another
    subnet, looks the same: the PC never appears.
-   Steam must be running on the PC, on the same account as the headset.
-   In `~/.local/share/Steam/logs/remote_connections.txt`, a line `Received broadcast message from client … (frame)`
    means the packet arrived and the problem is later (authorization, SteamVR, or the stream). No such line means the
    broadcast never reached Steam.

### Asynchronous reprojection {#asynchronous_reprojection}

On first launch, SteamVR asks for elevated permissions so it can set `CAP_SYS_NICE` on `vrcompositor-launcher`. That
capability is what asynchronous reprojection needs. Streaming works without it.

On NixOS the usual `setcap` command has no effect. Steam runs in a bubblewrap user namespace, which cannot hold file
capabilities. The workarounds and their security tradeoffs are documented in [VR#SteamVR](VR#SteamVR "wikilink"). Do not
copy the one-line `setcap` from the [Steam](Steam "wikilink") page and expect it to stick.

### VR game opens as a flat window {#vr_game_opens_as_a_flat_window}

On a Linux host, launching a VR game from the headset does not start SteamVR. The game comes up as a flat window, the
headset sits on \"opening game\", and Steam logs
`CRemoteClientJobStartStream timed out k_ERemoteClientWaitVRConnectionReady`. Valve confirmed the bug on September 25,
2026, and the workaround is to start SteamVR on the PC before selecting the game in the headset.[^5]

The underlying gap is that SteamVR ships `driver_vrlink.so` only as a 64-bit library, so Steam\'s 32-bit watchdog cannot
load it and never calls StartSteamVR. Proton will not start `vrserver` either. Flat streaming over the same link is
unaffected. The report was filed on Arch Linux; the missing 32-bit driver is not specific to NixOS.

## See also {#see_also}

-   [VR](VR "wikilink")
-   [Steam](Steam "wikilink")
-   [Linux VR Adventures Wiki](https://lvra.gitlab.io)
-   [Steam Frame feature and troubleshooting guide](https://help.steampowered.com/en/faqs/view/2668-0B6E-79E0-A85B)

## References

```{=html}
<references />
```
[Category:Hardware](Category:Hardware "wikilink") [Category:Gaming](Category:Gaming "wikilink")

[^1]: Valve, [Required Ports for Steam](https://help.steampowered.com/en/faqs/view/2EA8-4D75-DA21-31EB) and [SteamVR
    ports](https://help.steampowered.com/en/faqs/view/3E3D-BE6B-787D-A5D2). The NixOS option follows those lists in
    [`nixos/modules/programs/steam.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/steam.nix).

[^2]: Valve, [Steam Frame - Feature and Troubleshooting
    Guide](https://help.steampowered.com/en/faqs/view/2668-0B6E-79E0-A85B).

[^3]: Shin-Yi Lin, [wifi: rtw89: Add default ID 28de:2432 for
    RTL8832CU](https://github.com/torvalds/linux/commit/5f65ebf9aaf00c7443252136066138435ec03958), commit `5f65ebf`,
    merged for Linux 7.0 (January 2026). The ID is not present in Linux 6.19 or earlier, and `rtw8852cu.c` itself is
    absent from Linux 6.18.

[^4]: [ValveSoftware/SteamVR-for-Linux issue 962](https://github.com/ValveSoftware/SteamVR-for-Linux/issues/962)

[^5]: danwillm, [comment on SteamVR-for-Linux issue
    962](https://github.com/ValveSoftware/SteamVR-for-Linux/issues/962#issuecomment-5833677943), September 25, 2026. The
    issue was closed on September 27, 2026 with the fix still unreleased.

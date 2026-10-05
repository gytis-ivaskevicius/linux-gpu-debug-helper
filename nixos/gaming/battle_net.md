The [Battle.net launcher](https://www.blizzard.com/apps/battle.net/desktop) is Blizzard\'s launcher for games including
*World of Warcraft*, *Diablo*, *Overwatch*, and *StarCraft*. On NixOS, Battle.net runs smoothly using Wine or Proton,
with [Lutris](Lutris "wikilink") or [Steam](Steam "wikilink") being the most common runners.

## System Prerequisites {#system_prerequisites}

Battle.net requires 32-bit graphics driver libraries. Ensure 32-bit graphics support is enabled in your
`configuration.nix`:

``` nix
# configuration.nix
hardware.graphics.enable32Bit = true;

# Optional, but recommended for gaming performance:
programs.gamemode.enable = true;
```

## Installation Methods {#installation_methods}

### Method 1: Lutris (Recommended) {#method_1_lutris_recommended}

The easiest and most reliable way to manage Battle.net is through [Lutris](Lutris "wikilink") using a Wine-GE or
Proton-GE runner.

1\. Add Lutris and Wine tools to your configuration:

``` nix
environment.systemPackages = with pkgs; [
  lutris
  wineWow64Packages.staging
  winetricks
];
```

2\. Open Lutris, search for **Battle.net**, and run the community install script. 3. Once installation completes, log in
and install your games.

### Method 2: Steam (Proton) {#method_2_steam_proton}

You can also run Battle.net through Steam:

1\. Download `Battle.net-Setup.exe` from the official website. 2. In Steam, click **Add a Game** \> **Add a Non-Steam
Game\...** and select the installer. 3. Open the game properties in Steam, go to **Compatibility**, check **Force the
use of a specific Steam Play compatibility tool**, and select a recent **GE-Proton** version. 4. Run the installer to
set up Battle.net inside Steam\'s `compatdata` prefix. 5. After installation, update the shortcut target to point to the
installed `Battle.net Launcher.exe` inside
`~/.local/share/Steam/steamapps/compatdata/<appid>/pfx/drive_c/Program Files (x86)/Battle.net/`.

### Method 3: Standalone Wine {#method_3_standalone_wine}

To run Battle.net using standalone Wine-staging without external managers:

``` nix
environment.systemPackages = with pkgs; [
  wineWow64Packages.staging
  winetricks
];
```

Create a 64-bit Wine prefix and launch the installer:

``` bash
export WINEARCH=win64
export WINEPREFIX=$HOME/.wine-battlenet
wine64 Battle.net-Setup.exe
```

## Troubleshooting & Known Issues {#troubleshooting_known_issues}

### Blank or Missing Login Buttons (WINE_SIMULATE_WRITECOPY) {#blank_or_missing_login_buttons_wine_simulate_writecopy}

If the Battle.net login window opens but shows a blank, black, or unresponsive dialog where login fields/buttons are
missing, launch with the `WINE_SIMULATE_WRITECOPY=1` environment variable:

``` bash
WINE_SIMULATE_WRITECOPY=1 wine64 "Battle.net Launcher.exe"
```

(In Lutris or Steam, add `WINE_SIMULATE_WRITECOPY=1` under the game\'s Environment Variables).

### Repairing Client After System / Wine Updates {#repairing_client_after_system_wine_updates}

If a Wine or system update causes Battle.net or its Agent update helper to throw DLL or startup errors, you do not need
to delete your prefix or re-download games. Simply download a fresh `Battle.net-Setup.exe` and run it inside your
existing prefix to repair the launcher files and registry in-place.

## World of Warcraft Companion Tools {#world_of_warcraft_companion_tools}

For players running *World of Warcraft*, several companion applications have dedicated NixOS packages and configuration
guides:

-   [Raider.IO](Raider.IO "wikilink") --- Mythic+ and raid progression tracking and addon synchronization.
-   [Archon](Archon "wikilink") --- Official Warcraft Logs companion for combat log recording and uploading.

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

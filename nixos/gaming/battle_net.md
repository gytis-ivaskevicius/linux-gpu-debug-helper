The Battle.net launcher is an application to start Blizzard games. It can be installed and launched via wine, which
works pretty well. To play most of its games a recent wine-staging version is recommended.

## Setup

Tested on nixos-unstable with wine-staging 5.22 and found to be working with World of Warcraft 9.0.2:

` users.users.youruser.packages = with pkgs; [`\
`   (wineWowPackages.full.override {`\
`     wineRelease = "staging";`\
`     mingwSupport = true;`\
`   })`\
`   winetricks`\
` ];`

Create a 64-bit wine prefix and enable DXVK support.

` export WINEARCH=win64`\
` export WINEPREFIX=$HOME/.wine-battlenet`\
` winetricks dxvk`

Download the `Battle.net-Setup.exe` from <https://www.blizzard.com/apps/battle.net/desktop> and install it by executing

` wine64 Battle.net-Setup.exe`

Follow the installation and upon completion login in with your Battle.net Id or create one.

The Launcher should now start up and allow you to install and launch games.

## Updating NixOS and the Battle.net Client {#updating_nixos_and_the_battle.net_client}

After updating any wine related packages the Battle.net client may throw an error on launch.

Re-run the \`wine64 Battle.net-Setup.exe\` inside the previous wine prefix you used to update the application and avoid
this error.

## Steam

Alternatively, you can install Steam and then add the Battle.net installer there via **\"Add Game -\> Add a Non-Steam
Game\...\"**. You must also go to the Properties of the added game in *Steam* and set *Compatibility* to `GE-Proton8-25`
(or later version).

If you get stuck on the login screen where there are no login buttons, you must launch the Steam app with
`"WINE_SIMULATE_WRITECOPY=1"` env variable. This might be just a temporary glitch. You can also add Battle.net client or
even the game directly to Steam. Look for installed binaries (.exe) in `"~/.local/share/Steam/steamapps/compatdata/"`.

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

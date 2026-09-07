## Emulating and launchers {#emulating_and_launchers}

Games can be run by different applications. Some are able to include libraries from different platforms.

  Application                                                                                         Platform                                                                        Description                                                                                           nixpkgs
  --------------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------- --------------------------------------------------------------------------------------
  [Steam](Steam "wikilink")                                                                           Steam                                                                           Stable support for Windows games. Linux games often incompatible due to interoperating differences.   `steam` `steam-run` `steam-runtime` `steam-original` `steam-unwrapped` `steam-small`
  [Lutris](Lutris "wikilink")                                                                         Epic Games, EA App, Flatpak, GOG, Humble Bundle, Steam, Ubisoft Connect, Wine                                                                                                         `lutris` `lutris-free` `lutris-unwrapped`
  [Legendary](https://github.com/legendary-gl/legendary) & [Rare](https://github.com/RareDevs/Rare)   Epic Games                                                                      Rare is a GUI for Legendary.                                                                          `legendary-gl` `rare`
  [Heroic](Heroic_Games_Launcher "wikilink")                                                          Epic Games, GOG, Prime Gaming, Wine                                             Supports gamepad navigation. Uses Legendary unlike Lutris.                                            `heroic` `heroic-unwrapped`
  Itch.io                                                                                             Itch.io                                                                                                                                                                               `itch`
  PPSSPP                                                                                              PSP emulation                                                                                                                                                                         `ppsspp`
  [PCSX2](Playstation2 "wikilink")                                                                    PS2 emulation                                                                                                                                                                         
  RPCS3                                                                                               PS3 emulation                                                                   Contains unfree blobs (PS3 firmware).                                                                 `rpcs3`
  [RetroArch](RetroArch "wikilink")                                                                   Retro games emulation                                                                                                                                                                 
  [Wine](Wine "wikilink") & [Bottles](Bottles "wikilink")                                             Windows emulation and software management                                                                                                                                             `wineWow64Packages` `winetricks` `bottles`
  Dosbox                                                                                              DOS emulation                                                                                                                                                                         `dosbox`
                                                                                                                                                                                                                                                                                            

## List of games in Nixpkgs {#list_of_games_in_nixpkgs}

  Name                                                                                                  Category                                      Description                                                                                                                        nixpkgs
  ----------------------------------------------------------------------------------------------------- --------------------------------------------- ---------------------------------------------------------------------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------------
  [0 A.D.](https://play0ad.com/)                                                                        Strategy, Historical                          Historical real-time strategy game.                                                                                                [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/0ad/default.nix)
  [Armagetron Advanced](https://www.armagetronad.org/)                                                  Arcade, Racing                                A multiplayer Tron-like lightcycle racing game.                                                                                    [available](https://github.com/NixOS/nixpkgs/pull/263675)
  [Battle for Wesnoth](https://www.wesnoth.org/)                                                        Strategy, Turn-based                          Turn-based strategy game with fantasy themes.                                                                                      [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/wesnoth/default.nix)
  [Cataclysm: Dark Days Ahead](https://cataclysmdda.org/)                                               Survival, Rogue-like                          Post-apocalyptic survival game.                                                                                                    [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/cataclysm-dda/default.nix)
  [Chromium B.S.U.](https://chromium-bsu.sourceforge.io/)                                               Arcade, Space Shooter                         Fast paced, arcade-style, top-scrolling space shooter.                                                                             available
  [Dungeon Crawl](https://crawl.develz.org/)                                                            Rogue-like, Adventure, Turn-based             Open-source, single-player, role-playing roguelike game.                                                                           available
  [Dwarf Fortress](https://www.bay12games.com/dwarves/)                                                 Simulation, Management, Rogue-like, Sandbox   Single-player fantasy game with a randomly generated adventure world.                                                              available
  [Endless Sky](https://endless-sky.github.io/)                                                         Space simulation, RPG                         Explore a universe with different factions and ships.                                                                              [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/endless-sky/default.nix)
  [FreeCiv](https://freeciv.org/)                                                                       Strategy, Turn-based                          Civilization-building strategy game.                                                                                               [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/freeciv/default.nix)
  [FreeDink](https://www.gnu.org/software/freedink/)                                                    Adventure, RPG                                Free, portable and enhanced version of the Dink Smallwood game engine.                                                             available
  [FreeDoom](https://freedoom.github.io/)                                                               FPS                                           Free alternative to the Doom series.                                                                                               ***unavailable***
  [GZDoom](https://github.com/ZDoom/gzdoom)                                                             FPS                                           A feature-centric port for all Doom engine games, based on ZDoom, adding an OpenGL renderer and powerful scripting capabilities.   [available](https://github.com/NixOS/nixpkgs/tree/nixos-24.05/pkgs/games/doom-ports/gzdoom)
  [LinCity](https://sourceforge.net/projects/lincity/)                                                  Simulation, Management                        City simulation game.                                                                                                              available
  [LinCity-NG](https://github.com/lincity-ng/lincity-ng)                                                Simulation, Management                        City simulation game.                                                                                                              available
  [Luanti](https://luanti.org)                                                                          Sandbox                                       An open source voxel game engine.                                                                                                  available
  [Mindustry](https://mindustrygame.github.io/)                                                         Strategy, Sandbox                             Sandbox tower defense game.                                                                                                        [available](https://github.com/NixOS/nixpkgs/tree/master/pkgs/games/mindustry)
  [NetHack](https://nethack.org/)                                                                       Rogue-like, RPG                               Rogue-like game.                                                                                                                   available
  [OpenMW](https://openmw.org/)                                                                         RPG, Open world, Action-adventure             Unofficial open source engine reimplementation of the game Morrowind.                                                              available
  [OpenRA](https://www.openra.net/)                                                                     Strategy, RTS                                 Open-source implementation of Command & Conquer.                                                                                   [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/openra/default.nix)
  [OpenTTD](https://www.openttd.org/)                                                                   Simulation, Management                        Business simulation game based on Transport Tycoon Deluxe.                                                                         [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/openttd/default.nix)
  [Shattered Pixel Dungeon](https://shatteredpixel.com/)                                                Rogue-like, RPG                               Rogue-like dungeon crawler with pixel graphics.                                                                                    [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/shattered-pixel-dungeon/default.nix)
  [Simon Tatham\'s Portable Puzzle Collection](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/)   Puzzle                                        Simon Tatham\'s portable puzzle collection.                                                                                        available
  [Super Tux](https://www.supertux.org/)                                                                Platformer, Side-scroller                     Classic 2D jump\'n run side-scroller game.                                                                                         available
  [SuperTuxKart](https://supertuxkart.net/de/Main_Page)                                                 Arcade, Racing                                Kart racing game (like Super Mario Kart) featuring Tux and friends.                                                                [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/super-tux-kart/default.nix)
  [Tales of Maj\'Eyal (ToME 4)](https://te4.org/)                                                       Rogue-like, RPG, Turn-based                   Rogue-like focused on exploration of procedurally generated dungeons.                                                              available
  [The Dark Mod](https://www.thedarkmod.com/main/)                                                      Stealth, FPS                                  Stealth game inspired by the Thief series.                                                                                         [pending pull request](https://github.com/NixOS/nixpkgs/pull/356578)
  [The Powder Toy](https://powdertoy.co.uk/)                                                            Sandbox                                       Classic \'falling sand\' physics sandbox game.Classic 2D jump\'n run sidescroller game.                                            available
  [Veloren](https://www.veloren.net/)                                                                   RPG, Sandbox                                  Multiplayer voxel RPG set in a procedurally generated world.                                                                       [available](https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ve/veloren/package.nix)
  [Xonotic](https://xonotic.org/)                                                                       FPS, Arena shooter                            Fast-paced multiplayer shooter.                                                                                                    [available](https://github.com/NixOS/nixpkgs/tree/master/pkgs/games/xonotic)
                                                                                                                                                                                                                                                                                         

## Installing games {#installing_games}

### Workarounds

Games that aren\'t yet available in nixpkgs can be played by other means, including but not limited to:

-   `steam-run` as described in [Steam](Steam "wikilink") or by installing it then running `steam-run $GAME` or
    `steam-run ./$GAME`.
-   `programs.nix-ld = { enable = true; libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs; };` to run nearly any
    binary by including all of the libraries used by Steam.
    [(Source)](https://old.reddit.com/r/NixOS/comments/1d1nd9l/walking_through_why_precompiled_hello_world/)
-   `appimage-run` as described in [Appimage](Appimage "wikilink").
-   [Distrobox](Distrobox "wikilink") to virtualize an OS that has a package for your game.

### Renowned Explorers: International Society {#renowned_explorers_international_society}

Tested with version `renowned_explorers_international_society_522_26056.sh` from gog.com. It can be played with
`steam-run`, but it needs some libraries that are not normally included in Steam\'s FHS environment. One way to solve
this is to add an overlay:

``` nix
  nixpkgs.overlays = [
    (self: super: {
      steam-run = (super.steam.override {
        extraLibraries = pkgs: with pkgs;
          [
            libxkbcommon
            mesa
            wayland
            (sndio.overrideAttrs (old: {
              postFixup = old.postFixup + ''
                ln -s $out/lib/libsndio.so $out/lib/libsndio.so.6.1
              '';
            }))
          ];
      }).run;
    })
  ];
```

Adding `libxkbcommon`, `mesa`, and `wayland` is straightforward. The game expects the shared library `sdnio.so.6.1` to
exist, so we need to create a symbolic link after the installation of `sndio`.

## See also {#see_also}

-   [Games in Nixpkgs](https://github.com/NixOS/nixpkgs/tree/master/pkgs/games)
-   [Gaming on Nix (by fufexan)](https://github.com/fufexan/nix-gaming)
-   [Search in nixpkgs by \"game\"
    keyword](https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=game)
-   [Linux Gaming Reddit wiki](https://www.reddit.com/r/linux_gaming/wiki/freegames/)
-   [List of open-source video games (en.wikipedia)](wikipedia:List_of_open-source_video_games "wikilink")
-   [List of top rated open-source games](https://trilarion.github.io/opensourcegames/games/top.html)
-   [List of open-source games (by bobeff)](https://github.com/bobeff/open-source-games)
-   [List of libre games](https://libregamewiki.org/List_of_games)
-   [LGames website](https://lgames.sourceforge.io/about.php)
-   [Porting (en.wikipedia)](wikipedia:Porting "wikilink")
-   [Open-Source Game Clones website](https://osgameclones.com/)
-   [NixOS Wiki GameMode page](GameMode "wikilink")
-   [NixOS Wiki Chess page](Chess "wikilink")

[Category:Gaming](Category:Gaming "wikilink") [Category:Applications](Category:Applications "wikilink")
[Category:Lists](Category:Lists "wikilink")

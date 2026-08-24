## Game launchers {#game_launchers}

Games can be run by different applications. Some are able to include libraries from different platforms.

  Application                                  Platform                                                                        Description                                                                                           nixpkgs
  -------------------------------------------- ------------------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------- --------------------------------------------------------------------------------------
  [Steam](Steam "wikilink")                    Steam                                                                           Stable support for Windows games. Linux games often incompatible due to interoperating differences.   `steam` `steam-run` `steam-runtime` `steam-original` `steam-unwrapped` `steam-small`
  [Lutris](Lutris "wikilink")                  Epic Games, EA App, Flatpak, GOG, Humble Bundle, Steam, Ubisoft Connect, Wine                                                                                                         `lutris` `lutris-free` `lutris-unwrapped`
  [Heroic](Heroic_Games_Launcher "wikilink")   Epic Games, GOG, Prime Gaming, Wine                                             Supports gamepad navigation. Unlike Lutris, uses open-source Legendary for Epic Games.                `heroic` `heroic-unwrapped`
  Itch.io                                      Itch.io                                                                                                                                                                               `itch`
  PPSSPP                                       PSP emulation                                                                                                                                                                         `ppsspp`
  [PCSX2](Playstation2 "wikilink")             PS2 emulation                                                                                                                                                                         
  RPCS3                                        PS3 emulation                                                                   Contains unfree blobs (PS3 firmware).                                                                 `rpcs3`
  [RetroArch](RetroArch "wikilink")            Retro games emulation                                                                                                                                                                 
  [Wine](Wine "wikilink")                      Windows emulation                                                                                                                                                                     `wineWow64Packages` `winetricks`
  Dosbox                                       DOS emulation                                                                                                                                                                         `dosbox`
  [Nixpkgs](Nixpkgs "wikilink")                Linux games                                                                                                                                                                           
                                                                                                                                                                                                                                     

## List of NixOS supported games {#list_of_nixos_supported_games}

  Name                                                                                                  Category                                      Description                                                                               nixpkgs
  ----------------------------------------------------------------------------------------------------- --------------------------------------------- ----------------------------------------------------------------------------------------- ----------------------------------------------------------------------
  [The Dark Mod](https://www.thedarkmod.com/main/)                                                      Stealth, FPS                                  Stealth game inspired by the Thief series.                                                [pending pull request](https://github.com/NixOS/nixpkgs/pull/356578)
  [Endless Sky](https://endless-sky.github.io/)                                                         Space simulation, RPG                         Explore a universe with different factions and ships.                                     available
  [Veloren](https://www.veloren.net/)                                                                   RPG, Sandbox                                  Multiplayer voxel RPG set in a procedurally generated world.                              available
  [Armagetron Advanced](https://www.armagetronad.org/)                                                  Arcade, Racing                                A multiplayer Tron-like lightcycle racing game.                                           available
  [0 A.D.](https://play0ad.com/)                                                                        Strategy, Historical                          Historical real-time strategy game.                                                       available
  [SuperTuxKart](https://supertuxkart.net/de/Main_Page)                                                 Arcade, Racing                                Kart racing game (like Super Mario Kart) featuring Tux and friends.                       available
  [OpenRA](https://www.openra.net/)                                                                     Strategy, RTS                                 Open-source implementation of Command & Conquer.                                          available
  [FreeCiv](https://freeciv.org/)                                                                       Strategy, Turn-based                          Civilization-building strategy game.                                                      available
  [FreeDink](https://www.gnu.org/software/freedink/)                                                    Adventure, RPG                                Free, portable and enhanced version of the Dink Smallwood game engine                     available
  [OpenTTD](https://www.openttd.org/)                                                                   Simulation, Management                        Business simulation game based on Transport Tycoon Deluxe.                                available
  [Battle for Wesnoth](https://www.wesnoth.org/)                                                        Strategy, Turn-based                          Turn-based strategy game with fantasy themes.                                             available
  [FreeDoom](https://freedoom.github.io/)                                                               FPS                                           Free alternative to the Doom series.                                                      ***unavailable***
  [Xonotic](https://xonotic.org/)                                                                       FPS, Arena shooter                            Fast-paced multiplayer shooter.                                                           available
  [LinCity](https://sourceforge.net/projects/lincity/)                                                  Simulation, Management                        City simulation game.                                                                     available
  [LinCity-NG](https://github.com/lincity-ng/lincity-ng)                                                Simulation, Management                        City simulation game.                                                                     
  [Mindustry](https://mindustrygame.github.io/)                                                         Strategy, Sandbox                             Sandbox tower defense game.                                                               available
  [NetHack](https://nethack.org/)                                                                       Rogue-like, RPG                               Rogue-like game.                                                                          available
  [Cataclysm: Dark Days Ahead](https://cataclysmdda.org/)                                               Survival, Rogue-like                          Post-apocalyptic survival game.                                                           available
  [Shattered Pixel Dungeon](https://shatteredpixel.com/)                                                Rogue-like, RPG                               Rogue-like dungeon crawler with pixel graphics.                                           available
  [Simon Tatham\'s Portable Puzzle Collection](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/)   Puzzle                                        Simon Tatham\'s portable puzzle collection.                                               available
  [Luanti](https://luanti.org)                                                                          Sandbox                                       An open source voxel game engine.                                                         available
  [Tales of Maj\'Eyal (ToME 4)](https://te4.org/)                                                       Rogue-like, RPG, Turn-based                   Rogue-like focused on exploration of procedurally generated dungeons.                     available
  [OpenMW](https://openmw.org/)                                                                         RPG, Open world, Action-adventure             Unofficial open source engine reimplementation of the game Morrowind.                     available
  [The Powder Toy](https://powdertoy.co.uk/)                                                            Sandbox                                       Classic \'falling sand\' physics sandbox game.Classic 2D jump\'n run sidescroller game.   available
  [Super Tux](https://www.supertux.org/)                                                                Platformer, Side-scroller                     Classic 2D jump\'n run side-scroller game.                                                available
  [Chromium B.S.U.](https://chromium-bsu.sourceforge.io/)                                               Arcade, Space Shooter                         Fast paced, arcade-style, top-scrolling space shooter.                                    available
  [Dwarf Fortress](https://www.bay12games.com/dwarves/)                                                 Simulation, Management, Rogue-like, Sandbox   Single-player fantasy game with a randomly generated adventure world.                     available
  [Dungeon Crawl](https://crawl.develz.org/)                                                            Rogue-like, Adventure, Turn-based             Open-source, single-player, role-playing roguelike game.                                  available

## Example of games installation {#example_of_games_installation}

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

-   [List of existing games in nixpkgs](https://github.com/NixOS/nixpkgs/tree/master/pkgs/games)
-   [Open Source Game Clones](https://osgameclones.com/)
-   [open-source-games list on Github by bobeff](https://github.com/bobeff/open-source-games)
-   [100 highest rated (by stars on Github) playable open source
    games](https://trilarion.github.io/opensourcegames/games/top.html)
-   [List of open-source video games (en.wikipedia)](wikipedia:List_of_open-source_video_games "wikilink")
-   [Topic \"open-source-game\" on github](https://github.com/topics/open-source-game)
-   [NixOS Wiki Chess page](Chess "wikilink")

[Category:Gaming](Category:Gaming "wikilink") [Category:Applications](Category:Applications "wikilink")
[Category:Lists](Category:Lists "wikilink")

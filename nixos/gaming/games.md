## Open source games and their status on NixOS {#open_source_games_and_their_status_on_nixos}

  Name                                                                                                  Category                 nixpkg status                                                          Short Description
  ----------------------------------------------------------------------------------------------------- ------------------------ ---------------------------------------------------------------------- -----------------------------------------------------------------------
  [The Dark Mod](https://www.thedarkmod.com/main/)                                                      Stealth, FPS             [pending pull request](https://github.com/NixOS/nixpkgs/pull/356578)   Stealth game inspired by the Thief series.
  [Endless Sky](https://endless-sky.github.io/)                                                         Space simulation, RPG    In nixpkgs                                                             Explore a universe with different factions and ships.
  [Veloren](https://www.veloren.net/)                                                                   RPG, Sandbox             In nixpkgs                                                             Multiplayer voxel RPG set in a procedurally generated world.
  [Armagetron Advanced](https://www.armagetronad.org/)                                                  Arcade, Racing           In nixpkgs                                                             A multiplayer Tron-like lightcycle racing game.
  [0 A.D.](https://play0ad.com/)                                                                        Strategy, Historical     In nixpkgs                                                             Historical real-time strategy game.
  [SuperTuxKart](https://supertuxkart.net/de/Main_Page)                                                 Arcade, Racing           In nixpkgs                                                             Kart racing game (like Super Mario Kart) featuring Tux and friends.
  [OpenRA](https://www.openra.net/)                                                                     Strategy, RTS            In nixpkgs                                                             Open-source implementation of Command & Conquer.
  [FreeCiv](https://freeciv.org/)                                                                       Strategy, Turn-based     In Nixpkgs                                                             Civilization-building strategy game.
  [FreeDink](https://www.gnu.org/software/freedink/)                                                    Adventure, RPG           In Nixpkgs                                                             Free, portable and enhanced version of the Dink Smallwood game engine
  [OpenTTD](https://www.openttd.org/)                                                                   Simulation, Management   In nixpkgs                                                             Business simulation game based on Transport Tycoon Deluxe.
  [Battle for Wesnoth](https://www.wesnoth.org/)                                                        Strategy, Turn-based     In nixpkgs                                                             Turn-based strategy game with fantasy themes.
  [FreeDoom](https://freedoom.github.io/)                                                               FPS                      ***Not in nixpkgs***                                                   Free alternative to the Doom series.
  [Xonotic](https://xonotic.org/)                                                                       FPS, Arena shooter       In nixpkgs                                                             Fast-paced multiplayer shooter.
  [LinCity](https://sourceforge.net/projects/lincity/)                                                  Simulation, Management   In nixpkgs                                                             City simulation game
  [LinCity-NG](https://github.com/lincity-ng/lincity-ng)                                                Simulation, Management   In nixpkgs                                                             City simulation game
  [Mindustry](https://mindustrygame.github.io/)                                                         Strategy, Sandbox        In nixpkgs                                                             Sandbox tower defense game.
  [NetHack](https://nethack.org/)                                                                       Rogue-like, RPG          In nixpkgs                                                             Rogue-like game
  [Cataclysm: Dark Days Ahead](https://cataclysmdda.org/)                                               Survival, Rogue-like     In nixpkgs                                                             Post-apocalyptic survival game.
  [Shattered Pixel Dungeon](https://shatteredpixel.com/)                                                Rogue-like, RPG          In nixpkgs                                                             Rogue-like dungeon crawler with pixel graphics.
  [Simon Tatham\'s Portable Puzzle Collection](https://www.chiark.greenend.org.uk/~sgtatham/puzzles/)   Puzzle                   In nixpkgs                                                             Simon Tatham\'s portable puzzle collection

## Other resources {#other_resources}

- [List of existing games in nixpkgs](https://github.com/NixOS/nixpkgs/tree/master/pkgs/games)
- [Open Source Game Clones](https://osgameclones.com/)
- [open-source-games list on Github by bobeff](https://github.com/bobeff/open-source-games)
- [100 highest rated (by stars on Github) playable open source
  games](https://trilarion.github.io/opensourcegames/games/top.html)
- [List of open-source video games
  (en.wikipedia)](wikipedia:List_of_open-source_video_games "List of open-source video games (en.wikipedia)"){.wikilink}
- [Topic \"open-source-game\" on github](https://github.com/topics/open-source-game)

## Game starters {#game_starters}

Games can be run by different applications. Some are able to include libraries from different plattforms.

  Application                                           Platform                                                                  Remarks
  ----------------------------------------------------- ------------------------------------------------------------------------- ------------------------------------------------------------------------------------------------------------------------
  [Steam](Steam "Steam"){.wikilink}                     Steam                                                                     Windows games work fine. Linux games are often incompatible due to how NixOS works.
  [Lutris](Lutris "Lutris"){.wikilink}                  GOG, Humble Bundle, Epic, EA App, Ubisoft Connect, Steam, Flatpak, Wine   
  [Heroic](Heroic_Games_Launcher "Heroic"){.wikilink}   Epic, GOG, Prime Gaming, Wine                                             
  [Wine](Wine "Wine"){.wikilink}                        Windows applications/games                                                often easier to use Lutris install scripts for wine applications/games
  nixpgs                                                Linux games                                                               There are several games in nixpgs. You can install them directly, e.g. vintagestory, flightgear, lots of racing games.
  [Dosbox](Dosbox "Dosbox"){.wikilink}                  DOS applications/games                                                    

## List of games {#list_of_games}

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

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}
[Category:Applications](Category:Applications "Category:Applications"){.wikilink}

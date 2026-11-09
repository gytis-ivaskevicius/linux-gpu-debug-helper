Ambermoon is a role-playing game developed and published by Thalion Software, released in 1993 for the Amiga. It was the
second part of an unfinished trilogy (Amberstar, released in 1992, being the first). It is considered to be one of the
best RPGs for this platform.

Its possible to run the original Ambermoon with an emulator for the Amiga computers (possible via Amiga Emulator Core in
[RetroArch](RetroArch "RetroArch"){.wikilink}).

## Ambermoon.net

Ambermoon.net is an open source rewrite for Windows, Linux and Mac. Its available with two flavours:

- Ambermoon.net: with modern enhancement but almost the same gameplay
- Ambermoon.net Advanced: With some improvements and changes to gameplay and content.

Ambermoon.net is stable, but also still in active development.

You do not need the orginal Ambermoon game files to run Ambermoon.net.

## Install and run game {#install_and_run_game}

There is no nixpkgs yet, manually running the linux files or running the Lutris version will not work on NixOS due to
the needed libraries. A very easy way to run it is via steam-run.

- Install the steam-run commandline tool: just add the package to your NixOS configuration and rebuild:

environment.systemPackages = with pkgs; \[ steam-run \];

</syntaxhighlight>

- Download the latest release from: <https://github.com/Pyrdacor/Ambermoon.net>
- Extract it in some directory
- use a terminal and execute in this directory

steam-run ./Ambermoon.net

</syntaxhighlight>

## Install modifications {#install_modifications}

The game itself has an optional auto-updater and you can choose, whether you want to run Ambermoon.net or Ambermoon.net
Advance.

## Troubleshooting

(nothing yet)

## References

- Ambermoon.net (Source and description): <https://github.com/Pyrdacor/Ambermoon.net>
- Wikipedia about Ambermoon: <https://en.wikipedia.org/wiki/Ambermoon>

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

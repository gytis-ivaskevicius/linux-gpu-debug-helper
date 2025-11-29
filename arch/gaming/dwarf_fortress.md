[ja:Dwarf Fortress](ja:Dwarf_Fortress "ja:Dwarf Fortress"){.wikilink} [Dwarf
Fortress](https://www.bay12games.com/dwarves/) is a single-player fantasy game. You can control a dwarven outpost or a
party of adventurers in a randomly generated, persistent world. It is renowned for its highly customizable, complex
in-depth game play.

The game is played mostly with mouse and the version of the game installed by the package is displayed in a
terminal-like window with images of ASCII characters ([screenshots](https://www.bay12games.com/dwarves/screens.html)).
There is also a graphical version available on [Steam](https://store.steampowered.com/app/975370/Dwarf_Fortress/) or
[itch.io](https://kitfoxgames.itch.io/dwarf-fortress).

## Installation

[Install](Install "Install"){.wikilink} the `{{Pkg|dwarffortress}}`{=mediawiki} package.

Alternatively, the [AUR](AUR "AUR"){.wikilink} has [packages](https://aur.archlinux.org/packages/?O=0&K=dwarffortress)
of old versions that bundle or add graphics tilesets and/or utilities.

Other bundles, starter packs, tilesets, and mods can be found at the [Dwarf Fortress File
Depot](https://dffd.bay12games.com/index.php).

See also the [Installation](https://dwarffortresswiki.org/index.php/Installation#Arch_Linux) page on the *Dwarf
Fortress* wiki.

## Configuration Files {#configuration_files}

When first run, *Dwarf Fortress* that was installed via Pacman creates a folder in the user\'s home tree, at
`{{ic|~/.local/share/dwarffortress/}}`{=mediawiki}, to store configuration files, save files, etc.

Some of the directories in `{{ic|~/.local/share/dwarffortress/}}`{=mediawiki} are
[symlinks](Wikipedia:Symbolic_link "symlinks"){.wikilink} to directories in `{{ic|/opt/dwarffortress/}}`{=mediawiki}, so
changes in `{{ic|/opt/dwarffortress/}}`{=mediawiki} - either directly or through the link - will affect games for all
users.

To make changes to *Dwarf Fortress* files that only affect one user, either delete the links and copy the linked
directories from `{{ic|/opt/dwarffortress/}}`{=mediawiki} to `{{ic|~/.local/share/dwarffortress/}}`{=mediawiki}, or
manually install a copy of *Dwarf Fortress* to a directory in the user\'s home directory and make the changes - and run
the game from - there (see [Manual or multiple
installations](https://dwarffortresswiki.org/index.php/Installation#Manual_or_multiple_installations) on the *Dwarf
Fortress* wiki).

## Tools

```{=mediawiki}
{{Out of date|The information in this section has not been updated for the current version which brought many changes.}}
```
### DFHack

[DFHack](https://docs.dfhack.org/en/0.47.05-r8/) is a *Dwarf Fortress* memory access utility, with many useful scripts
and plugins.

There are multiple [dfhack packages](https://aur.archlinux.org/packages/?K=dfhack) available in the
[AUR](AUR "AUR"){.wikilink}.

To start *Dwarf Fortress* with DFHack, execute `{{ic|dfhack}}`{=mediawiki} instead of
`{{ic|dwarffortress}}`{=mediawiki}, or create a custom [desktop entry](desktop_entry "desktop entry"){.wikilink}.

Similarly to the *Dwarf Fortress* packages, the *DFHack* packages add files and symlinks to
`{{ic|~/.dwarffortress/}}`{=mediawiki}, including `{{ic|dfhack-config/}}`{=mediawiki} which contains files that can be
edited to configure *DFHack*.

#### Manipulator

[Manipulator](https://docs.dfhack.org/en/0.47.05-r8/docs/tools/manipulator.html) is an in-game alternative to Dwarf
Therapist with much of the same functionality, but does not require extra permissions. This plugin is enabled by default
in the DFHack, accessible from the units screen.

#### quickfort

[Quickfort](https://docs.dfhack.org/en/stable/docs/tools/quickfort.html) is a DFHack plugin that helps you build
fortresses from \"blueprint\" .CSV, .XLS, and .XLSX files.

#### StoneSense

[StoneSense](https://dwarffortresswiki.org/index.php/Utility:Stonesense) is an isometric *Dwarf Fortress* visualizer, as
a [plugin](https://docs.dfhack.org/en/stable/docs/tools/stonesense.html) included with DFHack.

### Dwarf Therapist {#dwarf_therapist}

[Dwarf Therapist](https://dwarffortresswiki.org/index.php/DF2014:Utilities#Dwarf_Therapist)
(`{{AUR|dwarftherapist}}`{=mediawiki} or `{{AUR|dwarftherapist-git}}`{=mediawiki}) is a utility to tune dwarvish
behavior (makes micro-management a lot easier). For it to work on current kernels you will need to disable a kernel
security feature, since it directly accesses and modifies the memory of a running *Dwarf Fortress* instance. This
setting is called `{{ic|kernel.yama.ptrace_scope}}`{=mediawiki} and is active by default.

Permission to use `{{ic|ptrace}}`{=mediawiki} can be given to the `{{ic|dwarftherapist}}`{=mediawiki} executable with:

`# setcap cap_sys_ptrace=eip /usr/bin/dwarftherapist`

```{=mediawiki}
{{Note|The permissions will reset after an update to Dwarf Therapist. Consider using [[pacman hooks]] to automatically configure the permissions after an update.}}
```
```{=mediawiki}
{{Warning|You '''should not''' disable {{ic|ptrace_scope}} globally in {{ic|/etc/sysctl.d/}} by default, or using [[sysctl]], since it is an '''important security feature''' in the kernel!}}
```
### SoundSense

[SoundSense](https://dwarffortresswiki.org/index.php/DF2014:Utilities#SoundSense) (`{{AUR|soundsense}}`{=mediawiki})
adds various sound effects and music by monitoring the gamelog.txt (which for v50+ versions of *Dwarf Fortress* does not
currently contain the information SoundSense needs).

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

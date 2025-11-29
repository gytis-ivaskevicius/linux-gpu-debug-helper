With 155 million sold, the PS2 was the best-selling gaming console ever. Home-brew development is still going on, and
many games recover online gaming capability since developers are rewriting the game server. A list of PlayStation 2
Online Games is available [here](https://docs.google.com/spreadsheets/d/1bbxOGm4dPxZ4Vbzyu3XxBnZmuPx3Ue-cPqBeTxtnvkQ).

# Emulation

This section explains how to run Playstation 2 games on NixOS.

## PCSX2

You need a legal copy of your ps2 bios. There are many ways to do it, so I will just describe an easy but slow one using
uLaunchELF:

`1/ get latest ps2ident from `[`https://github.com/ps2homebrew/PS2Ident/releases/tag/stable`](https://github.com/ps2homebrew/PS2Ident/releases/tag/stable)` `\
`2/ extract somewhere on an USB mass storage`\
`3/ launch it from uLaunchELF (mass:) , then select USB as save device`\
`4/ waiiiiiiiiiiiit. ( slow USB 1, notice progress bars )`\
`5/ copy files in the right pcsx2 directory ( by default /home/``<username>`{=html}`/.config/PCSX2/bios )`

You can also explore the bios file using romdirfs.

# Development

If you want to develop for the PlayStation 2 on NixOS you\'ll probably want to use the Open Source PS2SDK . The section
below explains how to bootstrap the toolchain in order to have a working development environment.

## Building the open source PS2SDK on NixOS {#building_the_open_source_ps2sdk_on_nixos}

You can use the following nix-shell script to build the open source PS2SDK through
[ps2dev](https://github.com/ps2dev/ps2dev).

``` nix
{ pkgs ? import <nixpkgs> {} }:
let fhs = pkgs.buildFHSUserEnv {
  name = "ps2dev";
  targetPkgs = pkgs: (with pkgs; [
    autoconf
    automake
    libtool
    gnumake
    clang
    clang-tools
    gcc
    wget
    git
    patch
    texinfo
    bash
    file
    bison
    flex
    gettext
    gsl
    gnum4
    gmp.dev
    gmp.out
    mpfr.out
    mpfr.dev
    libmpc
    cmake
    zlib.dev
    zlib.out
  ]);
  runScript = "bash";
};
in pkgs.stdenv.mkDerivation {
  name = "ps2dev-shell";
  nativeBuildInputs = [ fhs ];
  hardeningDisable = [ "format" ];
  shellHook = ''
    # or whatever you want
    export PS2DEV=$HOME/ps2
    mkdir -p $PS2DEV
    chown -R $USER: $PS2DEV

    # setup login env
    export PS2SDK=$PS2DEV/ps2sdk
    export PATH=$PATH:$PS2DEV/bin:$PS2DEV/ee/bin:$PS2DEV/iop/bin:$PS2DEV/dvp/bin:$PS2SDK/bin
    export CMAKE_INSTALL_PREFIX=$PS2DEV
    exec ps2dev
    '';
}
```

You will have to run this shell each time you want to enter in an environment with the SDK tools available or,
alternatively, re-export those environment variables in the shell of your liking:

``` bash
# or whatever you want
export PS2DEV=$HOME/ps2
export PS2SDK=$PS2DEV/ps2sdk
export PATH=$PATH:$PS2DEV/bin:$PS2DEV/ee/bin:$PS2DEV/iop/bin:$PS2DEV/dvp/bin:$PS2SDK/bin
```

# PlayStation 2 Expansion Bay {#playstation_2_expansion_bay}

Read more about it: <https://en.wikipedia.org/wiki/PlayStation_2_Expansion_Bay> Only genuine Sony adapter offers network
capability, you can upgrade them to sata thanks to a SATA mod kit from bitfunx or maxdiypower. On slim model, you can
find kit too, but you will need to solder on the motherboard.

## HDD Partitioning {#hdd_partitioning}

Playstation 2 use PFS filesystem and APA partitions see [libHdd Reference
Manual](https://master.dl.sourceforge.net/project/kernelloader/Sony%20Linux%20Toolkit/Package%20Update%20Files/apa/libhdd_ref.pdf?viasf=1)
for more information. You could use pfsshell on PC to create APA partition and format to PFS. pfsshell\'s author advises
you to not use it as root.

``` bash
# chown myuser /dev/sdb

$ pfsshell 
pfsshell for POSIX systems
https://github.com/uyjulian/pfsshell

This program uses pfs, apa, iomanX, 
code from ps2sdk (https://github.com/ps2dev/ps2sdk)

Type "help" for a list of commands.

> device /dev/sdb
hdd: PS2 APA Driver v2.5 (c) 2003 Vector
hdd: max open = 1, 3 buffers
hdd: 07:13:40 02/03/2020
hdd: disk0: 0x06fccf2f sectors, max 0x00200000
hdd: checking log...
hdd: drive status 0, format version 00000002
hdd: version 0000 driver start.
pfs Playstation Filesystem Driver v2.2
ps2fs: (c) 2003 Sjeep, Vector and Florin Sasu
pfs Max mount: 1, Max open: 1, Number of buffers: 10
pfs version 0000 driver start.
# initialize yes
# ls
0x0001   128MB __mbr
0x0100   128MB __net
0x0100   256MB __system
0x0100   512MB __sysconf
0x0100  1024MB __common
```

### install wLauncher {#install_wlauncher}

In order to be able to launch unofficial software, you can:

-   launch a dvd with [FreeDVDBoot](https://cturt.github.io/freedvdboot.html)
-   have a modchip
-   boot with a FMCB installed memory card
-   boot on HDD with an elf launcher like wLauncher or [SoftDev2](https://github.com/parrado/SoftDev2)

Extract [this
archive](https://web.archive.org/web/20221210004709/https://www.ps2-home.com/forum/download/file.php?id=15758&sid=f956d2accefb993288a6791c7c85a5c0)
(wLE_kHn_20200810.7z md5:430af5615895736d96b4f7156e92b2b0 [dl
source](https://www.ps2-home.com/forum/viewtopic.php?t=5128)) then call hdl_dump:

`$ hdl_dump initialize /dev/sdb MBR.KELF`

### install FHDB (Free HDBoot) {#install_fhdb_free_hdboot}

Get FMCB installer from official website: <https://sites.google.com/view/ysai187/home/projects/fmcbfhdb>

You should be able to launch it following the instruction there.

### Install games {#install_games}

Games doesn\'t use PFS but HDLoader partition so we can\'t rely on pfsshell to install them. Use hdl_dump (see hdl_dump
help):

` $ hdl_dump install /dev/sdb Final\ Fantasy\ X\ `$France$`.iso`

## Network

### Samba

Works fine - example soon.

### FTP transfer {#ftp_transfer}

A very slow solution ( \~ 500KB/s ).

-   PC side (client):

PS2 doesn\'t support TLS, use plain FTP. (tested with filezilla)

-   PS2 side (server):

Launch ps2net. You need to activate hdd (exploring it in uLaunchELF for example) before ps2net to share it.

[Category:Gaming](Category:Gaming "wikilink") [Category:Applications](Category:Applications "wikilink")
[Category:Hardware](Category:Hardware "wikilink")

[ja:Humble Bundle](ja:Humble_Bundle "ja:Humble Bundle"){.wikilink} [Humble Bundle](https://humblebundle.com) is a
digital distributor of commercial video games, that stocks many titles with Linux support. It gained popularity with the
sale of the \"Humble Indie Bundle\", raising funds for charities while selling games at a price set by the buyer.

## Purchase

There are two purchasing methods:

- *Humble Indie Bundles* --- time-limited promotions where a collection of games can be bought at a price determined by
  the purchaser, with a low minimum.
- *Humble Store* --- traditional (fixed-price, single-game) purchases, usually via a widget on the game developer\'s
  website.

Both give you the exact same versions of the games, and in both cases the game ends up in your personal game library on
the Humble Bundle website, from where you can download it. Some games have keys that can be used on an other platform,
e.g. [Steam](Steam "Steam"){.wikilink}.

## Installation

Many of the games offered on the platform have Linux versions, often provided in the form of a `{{ic|.deb}}`{=mediawiki}
package for Debian/Ubuntu, and a `{{ic|.tar.gz}}`{=mediawiki} archive or `{{ic|.sh}}`{=mediawiki} self-extracting
archive for \"generic\" Linux distributions.

In some cases, you can just extract the `{{ic|.tar.gz}}`{=mediawiki} or `{{ic|.sh}}`{=mediawiki} somewhere on your
system and run the game executable in the extracted folder. But in many other cases, additional installation steps are
required to make the game run error-free and help tracking the installed files.

### Using AUR packages {#using_aur_packages}

[AUR](AUR "AUR"){.wikilink} packages for Humble Bundle games take care of all the steps required to make each game run.

These AUR package typically include the suffix `{{ic|-hib}}`{=mediawiki} in their name.

#### Providing the game archive {#providing_the_game_archive}

You have to provide your purchased game archive to the AUR package so that it can install it. There are a few ways to
achieve this:

##### Manually copy/symlink the archive {#manually_copysymlink_the_archive}

Manually download the game archive from your Humble Bundle library. Then copy or symlink the game archive to the
[PKGBUILD](PKGBUILD "PKGBUILD"){.wikilink} folder. (You can look at the `{{ic|source}}`{=mediawiki} array in the
PKGBUILD to see which exact archive file it expects.

##### Register a download agent {#register_a_download_agent}

Most AUR packages for Humble Bundle games helpfully mark the game archive using the custom `{{ic|hib://}}`{=mediawiki}
URI protocol. You can specify a handler for this protocol in the configuration file
`{{ic|/etc/makepkg.conf}}`{=mediawiki}, by adding a line to the `{{ic|DLAGENTS}}`{=mediawiki} array right at the top of
the file. You only need to do this once. The process for placing game archives into PKGBUILD directories will then be
automated.

An example of DLAGENT that simply expects your Humble Bundle archives to somewhere in your
`{{ic|~/Downloads}}`{=mediawiki}, and AUR packages will automatically find and symlink it:

`'hib::/usr/bin/sh -c find\ \$HOME/Downloads\ -name\ \$(basename\ %u)\ -exec\ ln\ -s\ \\\{\\\}\ %o\ \\\;\ -quit'`

### Manual installation {#manual_installation}

Manually getting a Humble Bundle game to run after extracting it typically involves two steps.

#### Installing dependencies {#installing_dependencies}

The games tend to assume that all dependencies which are part of a standard Ubuntu system, are installed. Remember that
if the game only has a 32bit binary, you have to install the `{{ic|lib32-}}`{=mediawiki} versions of all dependencies on
a 64bit system.

#### Removing bundled libraries that cause problems {#removing_bundled_libraries_that_cause_problems}

Some dependencies *are* bundled with the games, usually in a subfolder called `{{ic|lib}}`{=mediawiki} or
`{{ic|lib32}}`{=mediawiki} or `{{ic|lib64}}`{=mediawiki}. Unfortunately, some of these cause problems on Arch Linux, in
which case you will have to delete them from that subfolder, so that the game will use the version of the library from
`{{ic|/usr/lib*}}`{=mediawiki}) instead and install the packages which provide said libraries.

If you are unsure, ask on the [forum](https://bbs.archlinux.org/viewforum.php?id=32) for help.

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

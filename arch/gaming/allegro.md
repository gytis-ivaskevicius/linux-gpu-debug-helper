[ja:Allegro](ja:Allegro "ja:Allegro"){.wikilink} [ru:Allegro](ru:Allegro "ru:Allegro"){.wikilink}
[Allegro](https://liballeg.org/) is, as their website states,

:   a cross-platform library mainly aimed at video game and multimedia programming. It handles common, low-level tasks
    such as creating windows, accepting user input, loading data, drawing images, playing sounds, etc. and generally
    abstracting away the underlying platform. However, Allegro is not a game engine: you are free to design and
    structure your program as you like.

## Installation

[Install](Install "Install"){.wikilink} the `{{Pkg|allegro}}`{=mediawiki} package.

There is also a package for the legacy version of Allegro, `{{Pkg|allegro4}}`{=mediawiki}, which you can use for source
which requires it.

```{=mediawiki}
{{Note|Allegro 5 is not backwards compatible with Allegro 4. Developing new applications using Allegro 4 is discouraged.}}
```
## Use

Once installed, include the necessary base header into necessary source files:

```{=mediawiki}
{{hc|main.c|#include <allegro5/allegro5.h>}}
```
If your main function is inside a C++ file, then it must have this signature:
`{{ic|int main(int argc, char **argv)}}`{=mediawiki}

## Troubleshooting

- A common first mistake is to forget to link against the Allegro libraries. For an overview, use
  `{{ic|pkg-config --list-all | grep allegro}}`{=mediawiki}.

<!-- -->

- Another trap for young players is to forget to include and initialise the necessary modules. Each module is a header,
  which needs to be included in the source file. Make sure you initialised it with the correct command and linked
  against the module, see above. For the exact details, refer to the manual.

## See also {#see_also}

- [Allegro documentation](https://liballeg.org/api.html) files and reference manual
- [Allegro Wiki](https://github.com/liballeg/allegro_wiki/wiki)
- [Allegro community network](https://www.allegro.cc/about)

[Category:Development](Category:Development "Category:Development"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

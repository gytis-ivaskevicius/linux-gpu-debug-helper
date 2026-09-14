[NetHack](https://www.nethack.org/) is a single-player dungeon exploration game.

## Installation

[Install](Install "wikilink") the `{{Pkg|nethack}}`{=mediawiki} package.

## Configuration

Create the file `{{ic|~/.nethackrc}}`{=mediawiki}.

Options can either be put one on each line, or on one line separated by commas. For a full list of available options,
refer to the guidebook located at `{{ic|/usr/share/doc/nethack/Guidebook.txt}}`{=mediawiki} or the [NetHack
Wiki](https://nethackwiki.com/wiki/Options).

### Directional keys {#directional_keys}

By default, NetHack uses the `{{ic|yuhjklbn}}`{=mediawiki} movement keys. You can change this to use a numerical pad by
enabling it in the options.

```{=mediawiki}
{{hc|head=~/.nethackrc|output=OPTIONS=number_pad}}
```
A `{{ic|number_pad{{=}}`{=mediawiki}-1}} setting enables letter keys with compatibility for `{{ic|qwertz}}`{=mediawiki}
keyboards.

### Graphics

NetHack uses broken dashes and pipes to draw the walls, but can be configured to use continuous lines which often looks
better.

```{=mediawiki}
{{hc|head=~/.nethackrc|output=OPTIONS=symset:DECgraphics}}
```
### Pickup types {#pickup_types}

By default, you will automatically pick up any item you walk over which can get annoying since too many items will
weight you down. You can either disable auto pickup all together, or specify which items to always pick up and ignore
the rest.

To never auto pickup anything, add the following. `{{hc|head=~/.nethackrc|output=OPTIONS=!autopickup}}`{=mediawiki}

To only auto pickup gold but ignore anything else, add the following instead.
`{{hc|head=~/.nethackrc|output=OPTIONS=pickup_types:$}}`{=mediawiki}

### Boulder visibility {#boulder_visibility}

By default boulders are hard to see since they use a grave ``{{ic|`}}``{=mediawiki} symbol. The following option changes
boulders to be easier to see by changing them to `{{ic|0}}`{=mediawiki}.
`{{hc|head=~/.nethackrc|output=SYMBOLS=S_boulder:0}}`{=mediawiki}

## See also {#see_also}

-   [NetHack Wiki](https://nethackwiki.com)
-   [Guidebook for NetHack 5.0](https://www.nethack.org/v500/Guidebook.html)
-   [NetHack on Strategy Wiki](https://strategywiki.org/wiki/NetHack)
-   [Dr. Kildeer\'s Guide to
    NetHack](https://www.alt.org/nethack/mirror/www.geocities.com/TimesSquare/Portal/2416/index.html)

[Category:Gaming](Category:Gaming "wikilink")

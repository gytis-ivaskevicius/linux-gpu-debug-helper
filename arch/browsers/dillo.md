[ja:Dillo](ja:Dillo "wikilink") [zh-hans:Dillo](zh-hans:Dillo "wikilink") [Dillo](https://dillo-browser.org/) is a
multi-platform graphical web browser known for its speed and small footprint.

-   Dillo is written in C and C++.
-   Dillo is based on FLTK1.3, the Fast Light Toolkit.
-   Dillo is free software made available under the terms of the GNU General Public License (GPLv3).
-   Dillo strives to be friendly both to users and developers.
-   Dillo helps web authors to comply with web standards by using the bug meter.

```{=mediawiki}
{{Note|The '''dillo.org''' website has not been under Dillo developers' control since [https://git.dillo-browser.org/dillo/commit/?id{{=}}
```
58a950376b3c09098da3b286bb71b7b6eb4777d2 2023-12\] and is being filled with spam (e.g. a \"Top 7 Most Secure Laptops\"
page). The project was moved to [GitHub](https://github.com/dillo-browser/dillo) at first, and then to its own
[independent site](https://dillo-browser.org/news/migration-from-github/).}}

## Installation

[Install](Install "wikilink") `{{Pkg|dillo}}`{=mediawiki}.

## Configuration

### Enabling cookies in Dillo by default {#enabling_cookies_in_dillo_by_default}

Cookies are disabled by default for privacy reasons. If you want to enable them, read [FAQ
entry](https://dillo-browser.org/old/FAQ.html#q8)

### Removing cookies {#removing_cookies}

First, stop your plugins (dpis) with the following command:

`$ dpidc stop`

The cookies dpi will write any permanent (`{{ic|ACCEPT}}`{=mediawiki}) cookies to disk, and temporary
(`{{ic|ACCEPT_SESSION}}`{=mediawiki}) cookies will be lost as the dpi exits.

Second, get rid of the permanent cookies by removing or editing your `{{ic|~/.dillo/cookies.txt}}`{=mediawiki}
file[1](https://dillo-browser.org/old/FAQ.html#q8).

## See also {#see_also}

-   [Dillo Home Page](https://dillo-browser.org/)

[Category:Web browser](Category:Web_browser "wikilink")

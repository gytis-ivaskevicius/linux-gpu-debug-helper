[ja:ブラウザ拡張機能](ja:ブラウザ拡張機能 "wikilink") [ru:Browser extensions](ru:Browser_extensions "wikilink")
[zh-hans:浏览器扩展](zh-hans:浏览器扩展 "wikilink")

This article lists some [browser extensions](Wikipedia:Browser_extension "wikilink") available for
[Firefox](Firefox "wikilink") and/or [Chromium](Chromium "wikilink").

## Installation

Firefox extensions can be installed from [addons.mozilla.org](https://addons.mozilla.org/firefox/) and managed at
`{{ic|about:addons}}`{=mediawiki}.

Chrome extensions can be installed from the [Chrome Web Store](https://chrome.google.com/webstore/category/extensions)
and managed at `{{ic|chrome://extensions/}}`{=mediawiki}.

Additionally, a few Firefox extensions can be found in the [official
repositories](https://archlinux.org/packages/?q=firefox%20extension) and some more in the
[AUR](https://aur.archlinux.org/packages/?K=firefox-extension).

To simplify maintenance, this article does not link store pages or [AUR](AUR "wikilink") packages of extensions. Readers
are advised to obtain extensions through the linked official websites if no package is available.

## Privacy

See also [Firefox/Privacy](Firefox/Privacy "wikilink") and [Chromium/Tips and
tricks#Security](Chromium/Tips_and_tricks#Security "wikilink").

```{=mediawiki}
{{Tip|It is not recommended to install all the privacy extensions. It can be counterproductive as they conflict with each other, and neither does it increase security whatsoever.}}
```
### Content blockers {#content_blockers}

-   ```{=mediawiki}
    {{App|[[Wikipedia:uBlock Origin|uBlock Origin]]|A lightweight, efficient blocker which is easy on [https://github.com/gorhill/uBlock#performance memory and CPU]. It comes with several filter lists ready to use out-of-the-box (including EasyList, Peter Lowe's, several malware filter lists). The lead developer of uBlock forked the project and created uBlock Origin. As of July 2015, most of the development is being done on uBlock Origin and the codebases are deviating substantially.|https://github.com/gorhill/uBlock/|{{Pkg|firefox-ublock-origin}}, [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|[[Wikipedia:Adblock Plus|Adblock Plus]]|Was a popular extension to block ads. Now that it is not blocking some ads on purpose [https://adblockplus.org/acceptable-ads], it may be a better idea to use a different blocker like uBlock Origin.|https://adblockplus.org/|{{Pkg|firefox-adblock-plus}}, [[Chromium]]}}
    ```

### Advanced control {#advanced_control}

-   ```{=mediawiki}
    {{App|uMatrix|Now abandoned fork of HTTP Switchboard. Lets you selectively block Javascript, plugins or other resources and control third-party resources. It also features extensive privacy features like user-agent masquerading, referring blocking and so on. It effectively replaces NoScript and RequestPolicy. See the [https://github.com/gorhill/httpswitchboard/wiki/How-to-use-HTTP-Switchboard:-Two-opposing-views old HTTP Switchboard wiki] for different ways how to use it.|https://github.com/gorhill/uMatrix|{{AUR|firefox-umatrix}}, [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|ScriptSafe|Gives users control of the web and more secure browsing while emphasizing simplicity and intuitiveness. Due to the nature of this extension, this will break most sites! It is designed to learn over time with sites that you allow.|https://github.com/andryou/scriptsafe|[[Firefox]], [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|[[Wikipedia:NoScript|NoScript]]|Disables JavaScript and Flash on any website not specifically whitelisted by the user. This extension will protect you from exploitation of security vulnerabilities by not letting anything but trusted sites (e.g: your bank, webmail) serve you executable content. Once installed, you can configure settings for NoScript by either clicking its icon on the toolbar or right clicking a page and navigating to NoScript. You will then have the option to enable/disable scripts for the current page, as well as any third party scripts that the page is linking to. Alternatively, you can choose to enable scripts temporarily for that session only. Be aware that a lot of modern websites use scripts for layout purposes, hence content may look different. For example, failed rendering due to missing fonts might occur on websites that load fonts at runtime via scripts, which were blocked by NoScript. {{Warning|By default, NoScript allows JavaScript from some corporations you might not like. '''It will affect your privacy'''. To change this, in NoScript, click {{ic|Options}} > {{ic|Per-site Permissions}} and set to {{ic|UNTRUSTED}} all the sites that you do not trust. Tor Browser, when using in the safer modes (where NoScript is used), already protects you.}}|https://noscript.net/|{{Pkg|firefox-noscript}}}}
    ```

-   ```{=mediawiki}
    {{App|ScriptBlock|Similar to NoScript, which is a Firefox add-on. Both extensions stop a website from executing any kind of JavaScript. However, ScriptBlock is a much simpler design thus it is easier to use. It blocks JavaScript by default. You can allow and temporary allow JavaScripts. Once you allow them to run, it lets all the JavaScripts run on that page so you might want ScriptBlock to work in conjunction with [[#Automatic tracker blockers|Privacy Badger]]. It is also worth checking its default whitelist, which might be permissive to you.|https://github.com/compvid30/scriptblock|[[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|Cookie AutoDelete|Deletes cookies as soon as the tab closes. Supports automatic and manual cookie cleaning modes. (Support for clearing LocalStorage was added in version 2.1, but only for Firefox versions 58+. The same release added support for first party isolation, but only for Firefox versions 59+).|https://github.com/Cookie-AutoDelete/Cookie-AutoDelete|[[Firefox]], [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|Vanilla Cookie Manager|A cookie whitelist manager that automatically removes unwanted cookies. Cookies can be used for authentication, storing your site preferences or anything else that can be saved as text data. Unfortunately, they can also be used to track you. You could turn off cookies completely or just shut off third-party cookies. But that would also keep out useful cookies that many web apps rely upon to work (like Google Mail or Calendar). With Vanilla, you can select which cookies you want to keep on a whitelist. All unwanted cookies are deleted automatically (or manually if you prefer).|https://github.com/laktak/vanilla-chrome|[[Chromium]]}}
    ```

### Automatic tracker blockers {#automatic_tracker_blockers}

-   ```{=mediawiki}
    {{App|Privacy Badger|Monitors third-party trackers loaded with web content. It blocks trackers once they appear on different sites. It does not block advertisements in the first place, but since a lot of ads are served based on tracking information, these are blocked as well. For more information on the mechanism, see its [https://privacybadger.org/#How-is-Privacy-Badger-different-from-Disconnect%2c-Adblock-Plus%2c-Ghostery%2c-and-other-blocking-extensions FAQ].|https://privacybadger.org/|{{AUR|firefox-extension-privacybadger}}, [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|Disconnect|Aims to stop 2,000 third-party sites from tracking the user. It encrypts data sent to popular sites and claims to loads web pages 27 percent faster. Disconnect shows its users, in real time, how many tracking attempts from Google, Twitter, Facebook, and more are stopped. It categorizes tracking attempts into advertising, analytical, social, and content, which makes it easy to monitor how one is being tracked. Disconnect can also stop side-jacking, which utilizes stolen cookies to steal personal data. It is easy to use and well supported. Firefox gained a feature based on the Disconnect list; see [[Firefox/Privacy#Tracking protection]].|https://disconnect.me/|[[Firefox]], [[Chromium]]}}
    ```

### Noise generators {#noise_generators}

-   ```{=mediawiki}
    {{App|AdNauseam|A lightweight browser extension that blends software tool and artware intervention to fight back against tracking by advertising networks. AdNauseam works like an ad-blocker (it is built atop uBlock-Origin) to silently simulate clicks on each blocked ad, confusing trackers as to one's real interests.|https://adnauseam.io/|[[Firefox]], [[Chromium]]}}
    ```

### Redirection

-   ```{=mediawiki}
    {{App|LibRedirect| A browser extension that redirects popular sites to alternative privacy friendly frontends | https://github.com/libredirect/browser_extension |[[Firefox]], [[Chromium]]}}
    ```

### Miscellaneous

-   ```{=mediawiki}
    {{App|Decentraleyes|Protects you against tracking through "free", centralized content delivery. It prevents a lot of requests from reaching networks like Google Hosted Libraries, and serves local files to keep sites from breaking. Complements regular content blockers.|https://decentraleyes.org/|{{Pkg|firefox-decentraleyes}}, [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|LocalCDN|Decentraleyes fork with support for more libraries and features|https://localcdn.org/|[[Firefox]]}}
    ```

-   ```{=mediawiki}
    {{App|CanvasBlocker|Blocks or fakes the JS-API for modifying &lt;canvas> to prevent Canvas-Fingerprinting. Firefox has a built-in anti-fingerprinting feature that can be enabled by setting {{ic|privacy.resistFingerprinting}} to {{ic|true}} in {{ic|about:config}}.|https://github.com/kkapsner/CanvasBlocker/|[[Firefox]]}}
    ```

-   ```{=mediawiki}
    {{App|Privacy Settings|Provides a toolbar panel for easily altering the browser's built-in privacy settings.|https://add0n.com/privacy-settings.html|[[Firefox]], [[Chromium]]}}
    ```

## Website customization {#website_customization}

Websites can be augmented using user style sheets and JavaScript [userscripts](Wikipedia:userscript "wikilink").

-   ```{=mediawiki}
    {{App|Stylus|User style sheets manager, fork of defunct Stylish.|https://add0n.com/stylus.html|{{AUR|firefox-stylus}}, [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|Violentmonkey|Open source userscript manager.|https://violentmonkey.github.io/|[[Firefox]], [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|Tampermonkey|Proprietary userscript manager.|https://tampermonkey.net/|[[Firefox]], [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|Dark Reader|Inverts brightness of web pages and aims to reduce eyestrain while browsing the web.|https://darkreader.org/|{{Pkg|firefox-dark-reader}}, [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|Toggle Website Colors|Replaces colors with user selected ones.|https://github.com/M-Reimer/togglewebsitecolors|[[Firefox]]}}
    ```

## Keyboard shortcuts {#keyboard_shortcuts}

There are various extensions providing [vi](vi "wikilink")-style keyboard shortcuts.

-   ```{=mediawiki}
    {{App|Vimium|Allows mouse-less browsing, has an experimental Firefox version.|https://github.com/philc/vimium|[[Firefox]], [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|Vim-Vixen|Vim-based browsing experience for Firefox.|https://github.com/ueokande/vim-vixen|[[Firefox]]}}
    ```

-   ```{=mediawiki}
    {{App|Krabby|Allows mouse-less browsing, inspired by [[Kakoune]].|https://krabby.netlify.app|[[Chromium]], [[Firefox]]}}
    ```

-   ```{=mediawiki}
    {{App|Tridactyl|Replace Firefox's control mechanism with one modelled on Vim.|https://github.com/cmcaine/tridactyl|{{Pkg|firefox-tridactyl}}}}
    ```

-   ```{=mediawiki}
    {{App|wasavi|Can transform textareas into Vi editors.|https://github.com/akahuku/wasavi|[[Firefox]], [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|VimFx|Vim keyboard shortcuts for Firefox. Requires the LegacyFox shim. VimFx is a ''bootstrapped extension'' and thus works in contexts that WebExtensions can't (about: pages)|https://github.com/akhodakivskiy/VimFx|{{AUR|legacyfox}}, [[Firefox]]}}
    ```

## Edit text with external text editor {#edit_text_with_external_text_editor}

Extensions to edit `{{ic|<textarea>}}`{=mediawiki}s with native [text editors](text_editor "wikilink"):

-   ```{=mediawiki}
    {{App|Textern|Add-on for editing text in your favorite external editor, requires [[Python]] script, available as {{AUR|firefox-extension-textern-native-git}}.|https://github.com/jlebon/textern|[[Firefox]]}}
    ```

-   ```{=mediawiki}
    {{App|withExEditor|View source, selection, and edit text with the external editor, requires [[Node.js]].|https://github.com/asamuzaK/withExEditor|[[Firefox]], [[Chromium]]}}
    ```

-   ```{=mediawiki}
    {{App|GhostText|Use your text editor to write in your browser. Everything you type in the editor will be instantly updated in the browser (and vice versa). Has plugins for [[Vim]], [[Emacs]], [[Neovim]] and [[Visual Studio Code]].|https://github.com/GhostText/GhostText|[[Firefox]], [[Chromium]]}}
    ```

## Flash

Adobe Flash Player support ended on 31 December 2020. Most browsers also have stopped supporting plugins, relegating
alternatives like `{{AUR|lightspark}}`{=mediawiki} to only work standalone.

On modern browsers, [Ruffle](https://ruffle.rs/) is a Flash Player emulator written in [Rust](Rust "wikilink"),
available through the use of [WebAssembly](Wikipedia:WebAssembly "wikilink"). Unlike the defunct Flash Player plugin and
Lightspark, Ruffle is only available in browsers as an extension (e.g. for
[Firefox](https://addons.mozilla.org/firefox/addon/ruffle_rs/) or
[Chromium](https://chromewebstore.google.com/detail/ruffle-flash-emulator/)).

To run natively, Ruffle can be [installed](install "wikilink") with one of the `{{AUR|ruffle-git}}`{=mediawiki} or
`{{AUR|ruffle-nightly-bin}}`{=mediawiki} packages.

## See also {#see_also}

-   [Firefox add-ons sorted by user counts](https://addons.mozilla.org/firefox/search/?sort=users)
-   [List of Firefox extensions at Wikipedia](Wikipedia:List_of_Firefox_extensions "wikilink")

[Category:Web browser](Category:Web_browser "wikilink") [Category:Lists of
software](Category:Lists_of_software "wikilink")

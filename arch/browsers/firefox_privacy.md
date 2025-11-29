[ja:Firefox/プライバシー](ja:Firefox/プライバシー "ja:Firefox/プライバシー"){.wikilink}
[zh-hans:Firefox/隐私](zh-hans:Firefox/隐私 "zh-hans:Firefox/隐私"){.wikilink} `{{Related articles start}}`{=mediawiki}
`{{Related|Firefox}}`{=mediawiki} `{{Related|Tor}}`{=mediawiki} `{{Related|Browser extensions}}`{=mediawiki}
`{{Related|Firefox/Tweaks}}`{=mediawiki} `{{Related|Firefox/Profile on RAM}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

This article overviews how to configure Firefox to enhance security and privacy.

## Configuration

The following are privacy-focused tweaks to prevent [browser fingerprinting](https://www.amiunique.org/faq) and
tracking.

### Tracking protection {#tracking_protection}

Firefox gained an option for [Enhanced Tracking
Protection](https://support.mozilla.org/en-US/kb/enhanced-tracking-protection-firefox-desktop). It can be enabled in
different levels via the GUI *Settings \> Privacy & Security*, or by setting `{{ic|about:config}}`{=mediawiki}:

- ```{=mediawiki}
  {{ic|privacy.trackingprotection.enabled}}
  ```
  `{{ic|true}}`{=mediawiki}

Apart from privacy benefits, enabling [tracking
protection](https://venturebeat.com/2015/05/24/firefoxs-optional-tracking-protection-reduces-load-time-for-top-news-sites-by-44/)`{{Dead link|2025|11|16|status=404}}`{=mediawiki}
may also reduce load time by 44%.

Note that this is not a replacement for ad blocking extensions such as [uBlock
Origin](Browser_extensions#Content_blockers "uBlock Origin"){.wikilink} and it may or may not work with [Firefox
forks](List_of_applications/Internet#Firefox_spin-offs "Firefox forks"){.wikilink}. If you are already running such an
ad blocker with the correct lists, tracking protection might be redundant.

### Anti-fingerprinting {#anti_fingerprinting}

The Firefox [tracking protection](#Tracking_protection "tracking protection"){.wikilink} blocks a list of known
\"fingerprinters\" when your privacy settings are set to *Standard* (the default) or *Strict*. Fingerprinting Protection
is a different, experimental feature under heavy development in Firefox.

Mozilla has started an [anti-fingerprinting project in
Firefox](MozillaWiki:Security/Fingerprinting "anti-fingerprinting project in Firefox"){.wikilink}, as part of a project
to upstream features from [Tor Browser](Tor_Browser "Tor Browser"){.wikilink}. Many of these anti-fingerprinting
features are enabled by this setting in the `{{ic|about:config}}`{=mediawiki}:

- ```{=mediawiki}
  {{ic|privacy.resistFingerprinting}}
  ```
  `{{ic|true}}`{=mediawiki}

```{=mediawiki}
{{Warning|1=<nowiki/>This is an experimental feature and can cause some website breakage, timezone is UTC0, and websites will prefer light theme. Please note that text-to-speech engine will be disabled ([https://bugzilla.mozilla.org/show_bug.cgi?id=1636707 bug #1636707]) and some favicons will be broken ([https://bugzilla.mozilla.org/show_bug.cgi?id=1452391#c5 bug #1452391]).}}
```
For more information see: [Firefox\'s protection against
fingerprinting](https://support.mozilla.org/en-US/kb/firefox-protection-against-fingerprinting).

### Change browser time zone {#change_browser_time_zone}

The time zone of your system can be used in browser fingerprinting. To set Firefox\'s time zone to UTC launch it as:

`$ TZ=UTC firefox`

Or, set a script to launch the above (for example, at `{{ic|/usr/local/bin/firefox}}`{=mediawiki}).

### Change user agent and platform {#change_user_agent_and_platform}

You can override Firefox\'s user agent with the `{{ic|general.useragent.override}}`{=mediawiki} preference in
`{{ic|about:config}}`{=mediawiki}.

The value for the key is your browser\'s user agent. Select a known common one.

```{=mediawiki}
{{Tip|
* The value {{ic|Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0}} is used as the user agent for the Tor browser, thus being very common.
* The [[#Anti-fingerprinting]] option also enables the Tor browser user agent and changes your browser platform automatically.
}}
```
```{=mediawiki}
{{Warning|Changing the user agent without changing to a corresponding platform will make your browser nearly unique.}}
```
To change the platform for firefox, add the following `{{ic|string}}`{=mediawiki} key in
`{{ic|about:config}}`{=mediawiki}:

`general.platform.override`

Select a known common platform that corresponds with your user agent.

```{=mediawiki}
{{Tip|The value {{ic|Win32}} is used as the platform for the Tor browser, corresponding with the user agent provided above.}}
```
### WebRTC exposes LAN IP address {#webrtc_exposes_lan_ip_address}

To prevent websites from getting your local IP address via [WebRTC](wikipedia:WebRTC "WebRTC"){.wikilink}\'s
peer-to-peer (and JavaScript), open `{{ic|about:config}}`{=mediawiki} and set:

- ```{=mediawiki}
  {{ic|media.peerconnection.ice.default_address_only}}
  ```
  to `{{ic|true}}`{=mediawiki}

- ```{=mediawiki}
  {{ic|media.peerconnection.enabled}}
  ```
  to `{{ic|false}}`{=mediawiki}. (only if you want to completely disable WebRTC)

You can use this [WebRTC test page](https://net.ipcalf.com/) and [WebRTC IP Leak VPN / Tor IP Test](https://ipleak.net/)
to confirm that your internal/external IP address is no longer leaked.

### Disable HTTP referer {#disable_http_referer}

[HTTP referer](Wikipedia:HTTP_referer "HTTP referer"){.wikilink} is an optional HTTP header field that identifies the
address of the previous webpage from which a link to the currently requested page was followed.

Set `{{ic|network.http.sendRefererHeader}}`{=mediawiki} to `{{ic|0}}`{=mediawiki} or `{{ic|1}}`{=mediawiki}, depending
on your [preferences](MozillaWiki:Security/Referrer "preferences"){.wikilink}.

```{=mediawiki}
{{Note|Some sites use the referer header to control origin conditions. Disabling this header completely may cause site breaking. In this case adjusting {{ic|network.http.referer.XOriginPolicy}} may provide a better solution.}}
```
### Disable connection tests {#disable_connection_tests}

By default Firefox attempts to connect to Amazon and/or Akamai servers at
[regular](https://bugzilla.mozilla.org/show_bug.cgi?id=1363651)
[intervals](https://bugzilla.mozilla.org/show_bug.cgi?id=1359697#c3), to test your connection. For example a hotel,
restaurant or other business might require you to enter a password to access the internet. If such a [Captive
portal](wikipedia:Captive_portal "Captive portal"){.wikilink} exists and is blocking traffic this feature blocks all
other connection attempts. This may leak your usage habits.

To disable Captive Portal testing, in `{{ic|about:config}}`{=mediawiki} set:

- ```{=mediawiki}
  {{ic|network.captive-portal-service.enabled}}
  ```
  to `{{ic|false}}`{=mediawiki}

```{=mediawiki}
{{Note|A [https://www.ghacks.net/2020/02/19/why-is-firefox-establishing-connections-to-detectportal-firefox-com-on-start/ report states that] the [https://vpn.mozilla.org/ Mozilla VPN] is unable to connect when this is disabled.}}
```
### Disable telemetry {#disable_telemetry}

Set `{{ic|toolkit.telemetry.enabled}}`{=mediawiki} to `{{ic|false}}`{=mediawiki} and/or disable it under *Preferences \>
Privacy & Security \> Firefox Data Collection and Use*.

### Enable \"Do Not Track\" header {#enable_do_not_track_header}

Set `{{ic|privacy.donottrackheader.enabled}}`{=mediawiki} to `{{ic|true}}`{=mediawiki} or toggle it in *Preferences \>
Privacy & Security \> Tracking Protection*

```{=mediawiki}
{{Note|The remote server may choose to not honour the "Do Not Track" request.}}
```
```{=mediawiki}
{{Warning|The "Do Not Track" header (DNT) may actually be used to fingerprint your browser, since most users leave the option disabled.}}
```
### Disable/enforce \'Trusted Recursive Resolver\' {#disableenforce_trusted_recursive_resolver}

Firefox 60 introduced a feature called [Trusted Recursive
Resolver](mozillawiki:Trusted_Recursive_Resolver "Trusted Recursive Resolver"){.wikilink} (TRR). It circumvents DNS
servers configured in your system, instead sending all DNS requests over HTTPS to Cloudflare servers. While this is
significantly more secure (as \"classic\" DNS requests are sent in plain text over the network, and everyone along the
way can snoop on these), this also makes all your DNS requests readable by Cloudflare, providing TRR servers.

- If you trust DNS servers you have configured yourself more than Cloudflare\'s, you can disable TRR in
  `{{ic|about:config}}`{=mediawiki} by setting `{{ic|network.trr.mode}}`{=mediawiki} (integer, create it if it does not
  exist) to `{{ic|5}}`{=mediawiki}. (A value of 0 means disabled by default, and might be overridden by future updates -
  a value of 5 is disabled by choice and will not be overridden.)
- If you trust Cloudflare DNS servers and would prefer extra privacy (thanks to encrypted DNS requests), you can enforce
  TRR by setting `{{ic|network.trr.mode}}`{=mediawiki} to `{{ic|3}}`{=mediawiki} (which completely disables classic DNS
  requests) or `{{ic|2}}`{=mediawiki} (uses TRR by default, falls back to classic DNS requests if that fails). Keep in
  mind that if you are using any intranet websites or trying to access computers in your local networks by their
  hostnames, enabling TRR may break name resolving in such cases.
- If you want to encrypt your DNS requests but not use Cloudflare servers, you can point to a new DNS over HTTPS server
  by setting `{{ic|network.trr.uri}}`{=mediawiki} to your resolver URL. A list of currently available resolvers can be
  found in the [curl wiki](https://github.com/curl/curl/wiki/DNS-over-HTTPS#publicly-available-servers), along with
  other configuration options for TRR.

### Encrypted Client Hello {#encrypted_client_hello}

To enable [Encrypted Client Hello
(ECH)](https://blog.mozilla.org/security/2021/01/07/encrypted-client-hello-the-future-of-esni-in-firefox/) (formerly
encrypted Server Name Indicator (eSNI)), so that nobody listening on the wire can see the server name you made a TLS
connection to, set:

- ```{=mediawiki}
  {{ic|network.dns.echconfig.enabled}}
  ```
  to `{{ic|true}}`{=mediawiki}

- ```{=mediawiki}
  {{ic|network.dns.http3_echconfig.enabled}}
  ```
  to `{{ic|true}}`{=mediawiki}

You may also need to set `{{ic|network.trr.mode}}`{=mediawiki} to `{{ic|2}}`{=mediawiki} or `{{ic|3}}`{=mediawiki}.

### Disable geolocation {#disable_geolocation}

Set `{{ic|geo.enabled}}`{=mediawiki} to `{{ic|false}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki}.

```{=mediawiki}
{{Note|This may break websites that needs access to your location. One may want to simply allow location-access per site, instead of disabling this feature completely.}}
```
### Disable \'Safe Browsing\' service {#disable_safe_browsing_service}

Safe Browsing offers phishing protection and malware checks, however it may send user information (e.g. URL, file
hashes, etc.) to third parties like Google.

To disable the Safe Browsing service, in `{{ic|about:config}}`{=mediawiki} set:

- ```{=mediawiki}
  {{ic|browser.safebrowsing.malware.enabled}}
  ```
  to `{{ic|false}}`{=mediawiki}

- ```{=mediawiki}
  {{ic|browser.safebrowsing.phishing.enabled}}
  ```
  to `{{ic|false}}`{=mediawiki}

In addition disable download checking, by setting `{{ic|browser.safebrowsing.downloads.enabled}}`{=mediawiki} to
`{{ic|false}}`{=mediawiki}.

### Disable WebGL {#disable_webgl}

WebGL is a potential security risk.[1](https://security.stackexchange.com/questions/13799/is-webgl-a-security-concern)
Set `{{ic|webgl.disabled}}`{=mediawiki} to `{{ic|true}}`{=mediawiki} in `{{ic|about:config}}`{=mediawiki} if you want to
disable it.

## Extensions

See [Browser extensions#Privacy](Browser_extensions#Privacy "Browser extensions#Privacy"){.wikilink}.

### Disable WebAssembly (and JavaScript) {#disable_webassembly_and_javascript}

[WebAssembly](wikipedia:Webassembly "WebAssembly"){.wikilink}, also known as Wasm, is a relatively new language. Unlike
JavaScript, Wasm executes *pre-compiled code* natively in browsers for high-performance simulations and applications. It
has been criticized for hiding pathways for malware and [as with JavaScript, can be used to track
users](https://trac.torproject.org/projects/tor/ticket/21549). Tor Browser blocks both JavaScript and Wasm.

See *NoScript* in [Browser extensions#Privacy](Browser_extensions#Privacy "Browser extensions#Privacy"){.wikilink} to
block JavaScript the way Tor Browser does, which enables quick access when needed. To disable Wasm, in
`{{ic|about:config}}`{=mediawiki} set:

- ```{=mediawiki}
  {{ic|javascript.options.wasm}}
  ```
  to `{{ic|false}}`{=mediawiki}

- ```{=mediawiki}
  {{ic|javascript.options.wasm_baselinejit}}
  ```
  to `{{ic|false}}`{=mediawiki}

- ```{=mediawiki}
  {{ic|javascript.options.wasm_ionjit}}
  ```
  to `{{ic|false}}`{=mediawiki}

### Remove system-wide hidden extensions {#remove_system_wide_hidden_extensions}

Some extensions are hidden and installed by default in `{{ic|/usr/lib/firefox/browser/features}}`{=mediawiki}. Many can
be safely removed via `{{ic|rm ''extension-name''.xpi}}`{=mediawiki}. They might not be enabled by default and may have
a menu option for enabling or disabling. Note that any files removed will return upon update of the
`{{Pkg|firefox}}`{=mediawiki} package. To keep these extensions removed, add the directories to
[NoExtract](NoExtract "NoExtract"){.wikilink} in `{{ic|/etc/pacman.conf}}`{=mediawiki}. Some extensions include:

- ```{=mediawiki}
  {{ic|doh-rollout@mozilla.org.xpi}}
  ```
  \- DoH Roll-Out (do not remove if you chose to use [#Disable/enforce \'Trusted Recursive
  Resolver\'](#Disable/enforce_'Trusted_Recursive_Resolver' "#Disable/enforce 'Trusted Recursive Resolver'"){.wikilink}
  above).

- ```{=mediawiki}
  {{ic|screenshots@mozilla.org.xpi}}
  ```
  \- Firefox Screenshots.

- ```{=mediawiki}
  {{ic|webcompat-reporter@mozilla.org.xpi}}
  ```
  \- For reporting sites that are compromised in Firefox, so Mozilla can improve Firefox or patch the site dynamically
  using the `{{ic|webcompat@mozilla.org.xpi}}`{=mediawiki} extension.

- All combined user and system extensions are listed in `{{ic|about:support}}`{=mediawiki}. See
  [2](https://dxr.mozilla.org/mozilla-release/source/browser/extensions/) for a full list of system extensions including
  README files describing their functions.

Firefox installations to paths such as the default release installed to `{{ic|/opt}}`{=mediawiki} have system extensions
installed at `{{ic|/firefox/firefox/browser/features}}`{=mediawiki}.

## Web search over Searx {#web_search_over_searx}

```{=mediawiki}
{{Out of date|SearX is no longer maintained since September 2023. The active fork is [https://docs.searxng.org/ SearxNG].}}
```
Privacy can be boosted by reducing the amount of information you give to a single entity. For example, sending each new
web search via a different, randomly selected proxy makes it near impossible for a single search engine to build a
profile of you. We can do this using public instances (or sites) of [Searx](https://searx.me/). Searx is an
[AGPL-3.0](https://github.com/searx/searx/blob/master/LICENSE), [open-source](https://github.com/searx/searx)
site-builder, that produces site, known as an \'instances\'. Each public \'instance\' can act as a middle-man between
you and a myriad of different search engines.

From [this list of public instances](https://searx.space/) and [others](https://searx.neocities.org/nojs.html), bookmark
as many Searx sites as you wish (if JavaScript is disabled you will need to enable it temporarily to load the list). For
fast access to these bookmarks, consider adding `{{ic|SX1}}`{=mediawiki}, `{{ic|SX2}}`{=mediawiki} \...
`{{ic|SX(n)}}`{=mediawiki} to the bookmark\'s *Name* field, with `{{ic|(n)}}`{=mediawiki} being the number of searx
instances you bookmark.

After this bookmarking, simply typing `{{ic|sx}}`{=mediawiki}, a number and `{{ic|Enter}}`{=mediawiki} in the URL bar
will load an instance.

```{=mediawiki}
{{Note|Update the above bookmarks from time to time or as instances become unreliable to reduce your online fingerprint.}}
```
```{=mediawiki}
{{Tip|
* If you have a web server and available bandwidth, consider running a public Searx instance to help others improve their privacy ([https://searx.github.io/searx/ more info]).
* For increased privacy, use Searx instances with [[Tor Browser]], which uses onion-routing to provide a degree of anonymity.
* You can improve your privacy further by running a private instance of Searx locally. [[Install]] the {{AUR|searxng-git}} package.
}}
```
See <https://www.privacyguides.org/en/search-engines/> for other options.

## Watch videos over Invidious {#watch_videos_over_invidious}

Invidious instances act as an alternative front-end to YouTube. They are websites built from [open-source
code](https://github.com/iv-org/invidious). It has typically been difficult to limit the amount of information a user
sent to YouTube (Google) in order to access content.

Benefits of using Invidious include:

- Videos are accessible without running scripts. YouTube forces users to run scripts.
- Videos can be saved for future viewing, or for viewing by others, including when offline. This reduces feedback sent
  to Google about when content is viewed or re-viewed.
- An optional audio-only mode that reduces bandwidth usage. When combined with a browser like
  [Tor](Tor "Tor"){.wikilink}, using fewer data packets on a more lightweight website is likely to improve your
  anonymity.
- Invidious is a free and open-source interface that makes setting up an independent, private, video-hosting service
  easier. As such there are website that exist that are using Invidious to serve their own content or content removed
  from YouTube. Therefore it may help limit the profile-building capabilities of YouTube into the future (see note).

Bookmark as many *functioning* invidious instances from the following lists as possible
([here](https://github.com/iv-org/documentation/blob/master/docs/instances.md), [here](https://invidio.us/),
[here](https://solmu.org/pub/misc/invidio.html)`{{Dead link|2024|01|13|status=404}}`{=mediawiki}). Note that some of
these instances may be hosted by Cloudflare.

You can change any YouTube video URL to an Invidious one by simply replacing the `{{ic|youtube.com}}`{=mediawiki} part
with the domain of the instance you want to use.

```{=mediawiki}
{{Note|Invidious does not index videos from Facebook or Cloudflare servers. Additionally, content is generally still sent to users from Google servers. For added privacy, see [[Tor Browser]].}}
```
## Enterprise policies {#enterprise_policies}

Network and system-wide policies may be established through the use of [enterprise
policies](https://support.mozilla.org/en-US/kb/managing-policies-linux-desktops) which both supplements and overrides
user configuration preferences. For example, there is no documented user preference to disable the checking of updates
for beta channel releases. However, there exists an enterprise policy which can be effectively deployed as a workaround.
Single and/or multiple policies may be administered through `{{ic|policies.json}}`{=mediawiki} as follows:

- Disable application updates
- Force-enable hardware acceleration

`{`\
` "policies": {`\
`  "DisableAppUpdate": true,`\
`  "HardwareAcceleration": true`\
` }`\
`}`

Verify that `{{ic|Enterprise Policies}}`{=mediawiki} is set to `{{ic|Active}}`{=mediawiki} in
`{{ic|about:support}}`{=mediawiki} and review release-specific policies in `{{ic|about:policies}}`{=mediawiki}.

## Sanitized profiles {#sanitized_profiles}

### prefs.js

Files which constitute a Firefox profile can be stripped of certain metadata. For example, a typical
`{{ic|prefs.js}}`{=mediawiki} contains strings which identify the client and/or the user.

`user_pref("app.normandy.user_id", "6f469186-12b8-50fb-bdf2-209ebc482c263");`\
`user_pref("security.sandbox.content.tempDirSuffix", "2a02902b-f25c-a9df-17bb-501350287f27");`\
`user_pref("toolkit.telemetry.cachedClientID", "22e251b4-0791-44f5-91ec-a44d77255f4a");`

There are multiple approaches by which these strings can be reset with the caveat that a master
`{{ic|prefs.js}}`{=mediawiki} must first be created without such identifiers and synced into a working profile. The
simplest solution is close Firefox before copying its `{{ic|prefs.js}}`{=mediawiki} to a separate location:

`$ cp ~/.mozilla/firefox/example.default-release/prefs.js ~/prefs.sanitized.js`

Strip out any and all identfier strings and date codes by either setting them to 0 or removing the entries outright from
the copied `{{ic|prefs.js}}`{=mediawiki}. Sync the now sanitized `{{ic|prefs.js}}`{=mediawiki} to the working profile as
required:

`$ rsync -v ~/.prefs.sanitized.js ~/.mozilla/firefox/example.default-release/prefs.js`

```{=mediawiki}
{{Note|Required identifier and date code entries and/or strings will automatically be repopulated and reset to new values during the next launch of Firefox}}
```
A secondary privacy effect is also incurred which can be witnessed by examining the string results between a sanitized
`{{ic|prefs.js}}`{=mediawiki} versus a working `{{ic|prefs.js}}`{=mediawiki} at [Fingerprint JS API
Demo](https://fingerprintjs.com/demo).

### extensions.json

Assuming that extensions are installed, the `{{ic|extensions.json}}`{=mediawiki} file lists all profile extensions and
their settings. Of note is the location of the user home directory where the `{{ic|.mozilla}}`{=mediawiki} and
`{{ic|extensions}}`{=mediawiki} folder exist by default. Unwanted background updates may be disabled by setting
`{{ic|applyBackgroundUpdates}}`{=mediawiki} to the appropriate `{{ic|0}}`{=mediawiki} value. Of minor note are
`{{ic|installDate}}`{=mediawiki} and `{{ic|updateDate}}`{=mediawiki}.
[Bubblewrap](Bubblewrap/Examples#Firefox "Bubblewrap"){.wikilink} can effectively mask the username and location of the
home directory at which time the `{{ic|extensions.json}}`{=mediawiki} file may be sanitized and modified to point to the
sandboxed `{{ic|HOME}}`{=mediawiki} location.

`{"schemaVersion":31,"addons":[{"id":"uBlock0@raymondhill.net","syncGUID":"{0}","version":"0","type":"extension","optionsURL":"dashboard.html","optionsType":3,"optionsBrowserStyle":true,"visible":true,"active":true,"userDisabled":false,"appDisabled":false,"embedderDisabled":false,"installDate":0,"updateDate":0,"applyBackgroundUpdates":0,"path":"/home/r/.mozilla/firefox/example.default-release/extensions/uBlock0@raymondhill.net.xpi","skinnable":false,"softDisabled":false,"foreignInstall":true,"strictCompatibility":true}}`

Removal of similar metadata from `{{ic|addonStartup.json.lz4}}`{=mediawiki} and `{{ic|search.json.mozlz4}}`{=mediawiki}
can also be accomplished. [mozlz4](https://github.com/jusw85/mozlz4) is a command-line tool which provides
compression/decompression support for Mozilla (non-standard) LZ4 files.

## Removal of subsystems {#removal_of_subsystems}

Telemetry related to [crash
reporting](https://firefox-source-docs.mozilla.org/toolkit/crashreporter/crashreporter/index.html) may be disabled by
removing the following:

`/usr/lib/firefox/crashreporter`\
`/usr/lib/firefox/minidump-analyzer`\
`/usr/lib/firefox/pingsender`

Those deleted files will be back after upgrading the package, add them to [NoExtract](NoExtract "NoExtract"){.wikilink}
for persistence.

For those who have opted to install Firefox manually from official Mozilla sources, the updater system may be disabled
by removing `{{ic|updater}}`{=mediawiki} in the `{{ic|firefox}}`{=mediawiki} directory.

## Editing the contents of omni.ja {#editing_the_contents_of_omni.ja}

```{=mediawiki}
{{Note|Certain features may be inhibited or lost as a result of modifying the contents of {{ic|omni.ja}}. Additionally, it is updated/overwritten with each Firefox release. It is up to the user to determine whether the gain in privacy is worth the loss of expected usability.}}
```
The file `{{ic|/usr/lib/firefox/omni.ja}}`{=mediawiki} contains most of the default configuration settings used by
Firefox. As an example, starting from Firefox 73, network calls to
`{{ic|firefox.settings.services.mozilla.com}}`{=mediawiki} and/or
`{{ic|content-signature-2.cdn.mozilla.net}}`{=mediawiki} cannot be blocked by extensions or by setting preference URLs
to `{{ic|"");}}`{=mediawiki}. Aside from using a DNS sinkhole or firewalling resolved IP blocks, one solution is to
`{{man|1|grep}}`{=mediawiki} through the extracted contents of `{{ic|omni.ja}}`{=mediawiki} before removing all
references to `{{ic|firefox.settings.services.mozilla.com}}`{=mediawiki} and/or `{{ic|cdn.mozilla.net}}`{=mediawiki}.
Extraneous modules such as unused dictionaries and hyphenation files can also be removed in order to reduce the size of
`{{ic|omni.ja}}`{=mediawiki} for both security and performance reasons.

To repack/rezip, use the command `{{ic|zip -0DXqr omni.ja *}}`{=mediawiki} and make sure that your working directory is
the root directory of the files from the `{{ic|omni.ja}}`{=mediawiki} file.

## Hardened user.js templates {#hardened_user.js_templates}

Several active projects maintain comprehensive hardened Firefox configurations in the form of a
`{{ic|user.js}}`{=mediawiki} config that can be dropped to Firefox profile directory:

- [arkenfox/user.js](https://github.com/arkenfox/user.js) (`{{AUR|arkenfox-user.js}}`{=mediawiki})
- [pyllyukko/user.js](https://github.com/pyllyukko/user.js)
- [ffprofile.com](https://ffprofile.com/) ([github](https://github.com/allo-/firefox-profilemaker)) - online user.js
  generator. You select which features you want to enable and disable and in the end you get a download link for a
  zip-file with your profile template. You can for example disable some functions, which send data to Mozilla and
  Google, or disable several annoying Firefox functions like Mozilla Hello or the Pocket integration.

## See also {#see_also}

- [Brainfucksec\'s firefox hardening guide](https://brainfucksec.github.io/firefox-hardening-guide) - A well maintained
  firefox guide to harden your firefox.
- [Privacy Guides](https://www.privacyguides.org/) - A community-maintained resource for keeping online privacy.
- [privacytools.io Firefox Privacy Add-ons](https://www.privacytools.io/#addons)
- [prism-break.org Web Browser Addons](https://prism-break.org/en/categories/gnu-linux/#web-browser-addons)
- [MozillaWiki:Privacy/Privacy Task Force/firefox about config privacy
  tweeks](MozillaWiki:Privacy/Privacy_Task_Force/firefox_about_config_privacy_tweeks "MozillaWiki:Privacy/Privacy Task Force/firefox about config privacy tweeks"){.wikilink} -
  a wiki page maintained by Mozilla with descriptions of privacy specific settings.
- [How to stop Firefox from making automatic
  connections](https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections) - Is an annotated
  list of corresponding Firefox functionality and settings to disable it case-by-case.
- [Search Engine Comparison](https://searchengine.party/) - Web page for comparing popular search engines across some
  privacy-centric data points.

[Category:Web browser](Category:Web_browser "Category:Web browser"){.wikilink}

`{{Related articles start}}`{=mediawiki} [ja:GeForce Now](ja:GeForce_Now "ja:GeForce Now"){.wikilink}
`{{Related|Gaming#Remote gaming}}`{=mediawiki} `{{Related|Chromium}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}
[GeForce Now](Wikipedia:GeForce_Now "GeForce Now"){.wikilink} is a [cloud
gaming](Gaming#Remote_gaming "cloud gaming"){.wikilink} services that lets users play video games in the browser
(including on Arch Linux) and on dedicated apps available on other platforms.

Unlike other cloud gaming platforms, GeForce Now connects to video game digital distribution services such as
[Steam](Steam "Steam"){.wikilink} and the Epic game store, where games have to be bought separately from the GeForce Now
subscription. Given the nature of Cloud Gaming, you will not need to install the client from these services on your
computer.

## Usage

GeForce Now [supports](https://www.nvidia.com/en-us/geforce-now/system-reqs/) Chromium-based browsers out of the box, it
should work for most people on [Chromium](Chromium "Chromium"){.wikilink}.

```{=mediawiki}
{{Note|While it is possible to change the User-Agent string to have your favorite [[browser]] appear as Chromium, it may not work correctly (some user have reported that the mouse cursor would not appear in games when running Firefox).}}
```
## Non-qwerty keyboard layout {#non_qwerty_keyboard_layout}

As of October 2021, the setting to change keyboard layout may not be visible when accessing GeForce Now on Linux.

In some cases, the following steps allow to access this setting by making Chromium appear to run on Windows.

### Edit indexDB {#edit_indexdb}

The values for the keyboard layout are saved in the indexDB, in the database \"gfnclient\" in the objectstore
\"sharedStore\". You can use a webextension like
<https://chrome.google.com/webstore/detail/indexeddbedit/npjecebdjnmlolggnoajngnlodhgpfac>, to edit this values. Simply
install the extension, reload play.geforcenow.com. Now open Dev-Tools (F12) and find the database with the objcetstore.
Here you can add a key for \"keyboardLayout\" with the proper value for your language. German example:

`{`\
`   "key": "keyboardLayout",`\
`   "value": {`\
`     "name": "Deutsch",`\
`     "code": "de-DE"`\
`   }`\
` },`

After saving, reload the page and you are done.

As an alternative, a [user-proivded extension](https://codeberg.org/Offerel/GFN_Keyboard_Layout) exists, with all the
currently pre-defined layouts from the GFN page. Since this extension is not in the Chrome Webstore, you must sideload
it as unpacked extension.

### Launch Chromium with disabled User-Agent Client Hint {#launch_chromium_with_disabled_user_agent_client_hint}

[User-Agent Client Hint](https://www.chromium.org/updates/ua-ch) is a new feature on Chromium-based browser designed to
improve over User-Agent strings. Unfortunately, because it is new, there is not yet an extension that let users change
it. To disable this feature, launch Chrome or Chromium this way :

`$ chromium --disable-features=UserAgentClientHint `

```{=mediawiki}
{{Note|Using this command, the website can only rely on a User-Agent string to determine your OS, which will be dealt with in the next step.}}
```
### Change your User-Agent string to make your OS appears as Windows {#change_your_user_agent_string_to_make_your_os_appears_as_windows}

```{=mediawiki}
{{Warning|Web extensions can access your browsing data, please check extension permissions before installing them. On Chromium, always use the Chrome Webstore, but be aware that not all extensions in the Chrome Webstore are reviewed by Google.}}
```
Multiple extensions exist to switch the User-Agent string, they can be installed using the Chrome Webstore. While Google
provides one of these, it seems to not reliably alter the User-Agent string, notably on GeForce Now. [User-Agent
Switcher and
Manager](https://chrome.google.com/webstore/detail/user-agent-switcher-and-m/bhchdcejhohfmigjafbampogmaanbfkg) is
another extension with this feature. The Firefox version being recommended by Mozilla, it seems trustworthy enough.

This later extension provides a list of common User-Agent strings to choose from. Selecting the first \"Chrome on
Windows\" one will work. If you are using another extension, a User-Agent string such as this one will work :

`Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.7113.93 Safari/537.36`

```{=mediawiki}
{{Tip|User-Agent strings contain the version of the web browser. If you read this article in the future, you may have to find a newer one to have your browser appear up to date.}}
```
### Access the keyboard layout setting {#access_the_keyboard_layout_setting}

With these steps applied, the keyboard layout settings will be available in the main settings panel, below the Network
settings.

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink} [Category:Web
applications](Category:Web_applications "Category:Web applications"){.wikilink}

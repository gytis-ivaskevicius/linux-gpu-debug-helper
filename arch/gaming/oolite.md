[ja:Oolite](ja:Oolite "ja:Oolite"){.wikilink} [Oolite](http://www.oolite.space/) is a space trading / simulation game
based on the well-known Elite game from the 80\'s.

## Installation

[Install](Install "Install"){.wikilink} the `{{AUR|oolite}}`{=mediawiki} package.

## Troubleshooting

Oolite uses shaders extensively which may not work well with all drivers, especially the gallium OSS drivers.

By default Oolite starts with full shaders, if it hangs on the title screen follow these 3 steps:

### Testing for shader problem {#testing_for_shader_problem}

Run Oolite from terminal with this command:

`$ LIBGL_ALWAYS_INDIRECT=1 oolite`

If Oolite works, the problem is with the shaders. In case this does not help, you have a different problem. Post about
this on the Arch Linux forums or register a bug.

### Verify which setting works {#verify_which_setting_works}

[Edit](textedit "Edit"){.wikilink} `{{ic|~/GNUstep/Defaults/.GNUstepDefaults}}`{=mediawiki} and look for these lines at
the bottom:

`<key>`{=html}`shader-mode``</key>`{=html}\
`   ``<integer>`{=html}`3``</integer>`{=html}

Try changing the value of this key to 2 and 1 and test if Oolite runs normally (**whithout** setting
`{{ic|LIBGL_ALWAYS_INDIRECT}}`{=mediawiki}).

```{=mediawiki}
{{Note|The lines with shader-mode key are not always present, but it is safe to add them.}}
```
### Feedback

For the value of shader-mode that works, please post `{{ic|~/.Oolite/Logs/Latest.log}}`{=mediawiki} on the [Oolite
forum](http://aegidian.org/bb/index.php)`{{Dead link|2024|03|03|status=404}}`{=mediawiki}, along with the highest
shader-mode value that works for you.

This info will be used to determine the correct default shader setting for Oolite for your card/driver combination. This
will then become part of the Oolite graphics configuration data in a later version.

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

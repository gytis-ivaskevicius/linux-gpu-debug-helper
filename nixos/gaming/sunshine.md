This page is intended to explain how to use Sunshine, an open-source implementation of NVIDIA's GameStream protocol.

## Install

To install Sunshine and enable it you can use the following snippet:

```{=mediawiki}
{{file|/etc/nixos/configuration.nix|nix|<nowiki>
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };
</nowiki>}}
```
## Connecting to the host {#connecting_to_the_host}

When installed via the NixOS module, Sunshine is configured as a Systemd user unit, and will start automatically on
login to a graphical session. Note that a logout/login or restart may be required for Sunshine to start after initially
adding it to your configuration due to limitations of NixOS\' handling of user units with `nixos-rebuild`.

If `services.sunshine.autoStart` is set to `false`, Sunshine needs to be started with the `sunshine` command.

You may have to manually add the host running Sunshine to your Moonlight client. This, thankfully, is not hard to do.

Simply press the button that says `Add Host Manually`, from there you will need to input the following (replace
`<Host IP>`{=html} with your Host's IP address):

`<Host IP>`{=html}`:47989`

If this doesn't work you should double check the port in the Sunshine's WebGUI. You can access this from the Host PC in
a web browser [`https://localhost:47990`](https://localhost:47990)

## Limitations

At the time of writing Sunshine is unable to wake sleeping display[^1] (e.g. when screen is locked), which makes
impossible to connect to the main session of your host PC. Can be somehow avoided by creating a virtual display and
running Sunshine through it.

## Troubleshooting

### Running Steam Big Picture on Wayland {#running_steam_big_picture_on_wayland}

While using Wayland on non-wlroots compositors, [you need to
have](https://docs.lizardbyte.dev/projects/sunshine/latest/md_docs_2getting__started.html) `capSysAdmin = true;` in
Sunshine config for KMS to capture screen properly. But this parameter breaks any custom applications that should be
started from your main user, not super-user. To avoid such issues, you need to prepend all needed commands with
`sudo -u ``<username>`{=html} [^2]:

Before:

``` json
    {
      "name": "Steam Big Picture",
      "detached": [
        "setsid steam steam://open/bigpicture"
      ],
      "prep-cmd": [
        {
          "do": "",
          "undo": "setsid steam steam://close/bigpicture"
        }
      ],
      "image-path": "steam.png"
    }
```

After:

``` json
    {
      "name": "Steam Big Picture",
      "detached": [
        "sudo -u venya setsid steam steam://open/bigpicture"
      ],
      "prep-cmd": [
        {
          "do": "",
          "undo": "sudo -u venya setsid steam steam://close/bigpicture"
        }
      ],
      "image-path": "steam.png"
    }
```

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

[^1]: <https://github.com/orgs/LizardByte/discussions/439>

[^2]: <https://discourse.nixos.org/t/give-user-cap-sys-admin-p-capabillity/62611/3?u=dmchmk>

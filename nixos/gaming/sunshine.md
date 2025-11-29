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

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

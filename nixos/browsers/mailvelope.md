[Mailvelope](https://mailvelope.com/de) is a browser extension for using PGP-based end-to-end encryption with webmail
clients.

## Installation

Mailvelope can be installed manually from [Firefox Add-ons](https://addons.mozilla.org/en-US/firefox/addon/mailvelope/)
or the [Chrome Web
Store](https://chromewebstore.google.com/detail/mailvelope-secure-your-em/kajibbejlbohfaggdiogboambcijhkke).

### Via Home-Manager {#via_home_manager}

Many Firefox add-ons are packaged in the [Nix User Repository](Nix_User_Repository "wikilink"), in [rycee\'s
repo](https://nur.nix-community.org/repos/rycee/).

This allows you to install them declaratively:

``` nix
{ pkgs, ... }: {
  # Change to your browser
  programs.librewolf = {
    profiles.<profile-name> = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        mailvelope
      ];
    };
  };
}
```

## Usage

### Using with GnuPG {#using_with_gnupg}

Mailvelope supports using your system\'s [GnuPG](GnuPG "wikilink") rather than the built-in \`OpenPGP.js\`.

To allow communication between mailvelope and GnuPG, it must be allowed via native messaging hosts.

To allow it for Firefox-based browsers, add this to your Home Manager configuration:

``` nix
{ pkgs, lib, ... }: {
  # Change to your browser
  programs.librewolf = {
    nativeMessagingHosts = with pkgs; [
      # for mailvelope
      (writeTextDir "lib/mozilla/native-messaging-hosts/gpgmejson.json" ''
        {
          "name": "gpgmejson",
          "description": "JavaScript binding for GnuPG",
          "path": "${lib.getExe' pkgs.gpgme.dev "gpgme-json"}",
          "type": "stdio",
          "allowed_extensions": ["jid1-AQqSMBYb0a8ADg@jetpack"]
        }
      '')
    ];
  };
}
```

Or to your NixOS configuration via `{{nixos:option|programs.firefox.nativeMessagingHosts.packages}}`{=mediawiki}.

The json is based on the [upstream
recommendation](https://github.com/mailvelope/mailvelope/wiki/Creating-the-app-manifest-file-on-macOS-and-Linux#firefox)

[Category: Web Browser](Category:_Web_Browser "wikilink")

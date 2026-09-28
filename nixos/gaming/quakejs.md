```{=mediawiki}
{{Note|This package is currently a draft (see [https://github.com/NixOS/nixpkgs/pull/338177 pull request]) and is not available yet}}
```
[QuakeJS](http://www.quakejs.com/) is a browser-based port of **Quake III Arena**, enabling players to enjoy the classic
shooter directly in their web browsers. It uses WebAssembly and WebGL to deliver the original gameplay experience
without additional software.

## Run the game {#run_the_game}

The game can be ran by opening it in a web browser and accepting persistent storage of the game files.

## Setup of a dedicated server {#setup_of_a_dedicated_server}

Following example configuration will enable QuakeJS for the domain`http://quakejs.example.org`:

``` nix
services.quakejs = {
  enable = true;
  hostname = "quakejs.example.org";
  eula = true;
  openFirewall = true;
  dedicated-server.enable = true;
};
```

Join your own dedicated server using the URL `http://quakejs.example.org/play?connect%20192.0.2.0:27960`, where
`192.0.2.0` is the public IP of your dedicated server.

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")
[Category:Server](Category:Server "wikilink")

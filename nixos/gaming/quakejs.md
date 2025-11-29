[QuakeJS](http://www.quakejs.com/) is a browser-based port of **Quake III Arena**, enabling players to enjoy the classic
shooter directly in their web browsers. It uses WebAssembly and WebGL to deliver the original gameplay experience
without additional software.

## Run the game {#run_the_game}

The game can be run by opening it in a web browser and accepting persistent storage of the game files.

## Setup of a dedicated server {#setup_of_a_dedicated_server}

Following example configuration will enable QuakeJS for the
domain`http://quakejs.example.org`:`{{Note|Parts of this module are not yet stable will be available with the upcoming NixOS release 25.05.}}`{=mediawiki}

``` nix
services.quakejs = {
  enable = true;
  hostname = "quakejs.example.org";
  eula = true;
  openFirewall = true;
  dedicated-server.enable = true;
};
```

Join your own dedicated server using the url: `http://quakejs.example.org/play?connect%20192.0.2.0:27960, where`
192.0.2.0 `is the public IP of your dedicated server.`

[Category:Applications](Category:Applications "Category:Applications"){.wikilink}
[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}
[Category:Server](Category:Server "Category:Server"){.wikilink}

[es:FoundryVTT](es:FoundryVTT "es:FoundryVTT"){.wikilink} [Foundry VTT](https://foundryvtt.com) is a standalone
application built for experiencing multiplayer tabletop RPGs using a feature-rich and modern self-hosted application
where your players connect directly through the browser.

**Foundry VTT** is [proprietary software](Wikipedia:Proprietary_software "proprietary software"){.wikilink}. A paid
license must be acquired before using the software.

These instructions show one of the possible ways to install Foundry VTT in an Arch Linux system. At the end of the
process, the service should be accessible from a browser using [a secure
connection](SSL "a secure connection"){.wikilink}.

```{=mediawiki}
{{Note|This guide covers the Node.js version of Foundry VTT, which allows for greater customization. There is also a Linux/Electron version, which is what the {{AUR|foundryvtt}} package utilizes.}}
```
## Installation

### Requirements

Before installing Foundry VTT, you should have a working installation of [nginx](nginx "nginx"){.wikilink} and
[Node.js](Node.js "Node.js"){.wikilink}.

### Creating directories {#creating_directories}

First of all, create these directories to install the software and its data. You can create these directories under
/home, for example:

`# mkdir -p /home/foundry/{foundryvtt,foundrydata}`

### Creating a system user {#creating_a_system_user}

Foundry VTT will be run by a system user. First, [create a system
user](Users_and_groups#Example_adding_a_system_user "create a system user"){.wikilink} with the name **foundry** or any
other name.

`# useradd -r -s /usr/bin/nologin `*`foundry`*

### Downloading

Once you have registered in [foundryvtt.com](https://foundryvtt.com) and have purchased a license, you need to go to the
\"Purchased Software Licenses\" section of your profile page. There you will see different packages for the software.

```{=mediawiki}
{{Note|You need to download the Node.js version for this guide. If using the {{AUR|foundryvtt}} package, then the Linux/Electron version is needed instead.}}
```
You may notice a small \'chain\' link icon next to the download links on the download page. Clicking this chain icon
generates a temporary link which can be used to download Foundry VTT via a terminal or shell interface using wget.

When downloading the link using a command line utility such as wget it is important to wrap the link in double-quotes.
This ensures that the link is read correctly by the command. For example:

`# wget -O foundryvtt.zip "https://your-download-link-from-foundry-vtt.com-here/"`

The downloaded file must be uncompressed to the *foundryvtt* directory that you created before. Once this directory is
populated, you need to set the proper permissions:

`# unzip foundryvtt.zip -d /home/foundry/foundryvtt`\
`# chown -R foundry:foundry /home/foundry/foundryvtt`\
`# chown -R foundry:foundry /home/foundry/foundrydata`

## Usage

### Running the software without a proxy {#running_the_software_without_a_proxy}

Now you can test if the software works. Run the server as the user *foundry*:

`[foundry]$ node /home/foundry/foundryvtt/main.js --dataPath=/home/foundry/foundrydata`

While it is running, you should be able to connect to the server from a browser, using port 30000. If you wish, you can
now set your admin password and save your license key.

Now stop the server using `{{ic|Ctrl+c}}`{=mediawiki}.

### Creating a service {#creating_a_service}

One of the ways to run the software is using [systemd#Writing unit
files](systemd#Writing_unit_files "systemd#Writing unit files"){.wikilink}. You can create a simple service for Foundry
VTT:

`[Unit]`\
`Description=Foundry VTT`\
\
`[Service]`\
`Type=simple`\
`ExecStart=node /home/foundry/foundryvtt/main.js --dataPath=/home/foundry/foundrydata`\
`Restart=on-failure`\
`User=foundry`\
\
`[Install]`\
`WantedBy=multi-user.target`

As suggested in the [installation instructions](https://foundryvtt.com/article/nginx/), edit the software options to
prepare it to be accessed through a proxy server:

Set the following options, keeping the other ones, where *hostname* is e.g `{{ic|a.domain.tld}}`{=mediawiki}:

```{=mediawiki}
{{hc|/home/foundry/foundrydata/Config/options.json|
"hostname": "''hostname''",
"routePrefix": null,
"sslCert": null,
"sslKey": null,
"port": 30000,
"proxyPort": 443,
"proxySSL": true
}}
```
```{=mediawiki}
{{tip|FoundryVTT also supports some configuration options as command line flags in your service {{ic|ExecStart}} line. See the [https://foundryvtt.com/article/configuration/#command-line configuration instructions] for details. This can be useful if you were wanting to create a separate service that enables {{ic|--hotReload}} for module/system development.}}
```
### Configuring nginx {#configuring_nginx}

To configure a nginx proxy server for Foundry VTT you can use this example from the official documentation:

`# This goes in a file within /etc/nginx/sites-available/. By convention,`\
`# the filename would be either "your.domain.com" or "foundryvtt", but it`\
`# really does not matter as long as it's unique and descriptive for you.`\
\
`# Define Server`\
`server {`\
\
`    # Enter your fully qualified domain name or leave blank`\
`    server_name             your.hostname.com;`\
\
`    # Listen on port 443 using SSL certificates`\
`    listen                  443 ssl;`\
`    listen                  [::]:443 ssl;`\
`    ssl_certificate         "/etc/letsencrypt/live/your.hostname.com/fullchain.pem";`\
`    ssl_certificate_key     "/etc/letsencrypt/live/your.hostname.com/privkey.pem";`\
\
`    # Sets the Max Upload size to 300 MB`\
`    client_max_body_size 300M;`\
\
`    # Proxy Requests to Foundry VTT`\
`    location / {`\
\
`        # Set proxy headers`\
`        proxy_set_header Host $host;`\
`        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;`\
`        proxy_set_header X-Forwarded-Proto $scheme;`\
\
`        # These are important to support WebSockets`\
`        proxy_set_header Upgrade $http_upgrade;`\
`        proxy_set_header Connection "Upgrade";`\
\
`        # Make sure to set your Foundry VTT port number`\
`        proxy_pass http://localhost:30000;`\
`    }`\
`}`\
\
`# Optional, but recommend. Redirects all HTTP requests to HTTPS for you`\
`server {`\
`    if ($host = your.hostname.com) {`\
`        return 301 https://$host$request_uri;`\
`    }`\
\
`    listen 80;`\
`    listen [::]:80;`\
\
`    server_name your.hostname.com;`\
`    return 404;`\
`}`

You can get your certificates using [certbot](certbot "certbot"){.wikilink}.

### Running the service {#running_the_service}

Now [start/enable](start/enable "start/enable"){.wikilink} both `{{ic|foundryvtt.service}}`{=mediawiki} and
`{{ic|nginx.service}}`{=mediawiki}.

At this point you should be able to access the service from a [browser](browser "browser"){.wikilink} by pointing it at
the *hostname* set earlier.

## Updating

Minor updates can be performed within FoundryVTT, however, major updates require manual installation.

Stop the `{{ic|foundryvtt.service}}`{=mediawiki} (if running).

```{=mediawiki}
{{Tip|Back up user/game data in {{ic|/home/foundry/foundrydata}} before major updates in case you need to revert the Foundry version.}}
```
Remove the old installation in `{{ic|/home/foundry/foundryvtt}}`{=mediawiki}. This does NOT affect your user/game data
which should be in `{{ic|/home/foundry/foundrydata}}`{=mediawiki} if following this guide.

`# rm -rf /home/foundry/foundryvtt/*`

Download the new Node.js version using the timed URL from your account (see
[#Downloading](#Downloading "#Downloading"){.wikilink}):

`# wget -O foundryvtt.zip "https://your-download-link-from-foundry-vtt.com-here/"`

Extract and set permissions:

`# unzip foundryvtt.zip -d /home/foundry/foundryvtt`\
`# chown -R foundry:foundry /home/foundry/foundryvtt`

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

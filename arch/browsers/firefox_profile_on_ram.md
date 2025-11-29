[de:Firefox-Profile in Ramdisk
auslagern](de:Firefox-Profile_in_Ramdisk_auslagern "de:Firefox-Profile in Ramdisk auslagern"){.wikilink}
[ja:Firefox/プロファイルを RAM
に置く](ja:Firefox/プロファイルを_RAM_に置く "ja:Firefox/プロファイルを RAM に置く"){.wikilink} [ru:Firefox
(Русский)/Profile on RAM](ru:Firefox_(Русский)/Profile_on_RAM "ru:Firefox (Русский)/Profile on RAM"){.wikilink}
[zh-hans:Firefox/在内存中存储配置](zh-hans:Firefox/在内存中存储配置 "zh-hans:Firefox/在内存中存储配置"){.wikilink}
Assuming that there is memory to spare, placing [Firefox](Firefox "Firefox"){.wikilink}\'s cache or complete profile to
RAM offers significant advantages. Even though opting for the partial route is an improvement by itself, the latter can
make Firefox even more responsive compared to its stock configuration. Benefits include, among others:

- reduced drive read/writes;
- heightened responsive feel;
- many operations within Firefox, such as quick search and history queries, are nearly instantaneous.

To do so we can make use of a [tmpfs](tmpfs "tmpfs"){.wikilink}.

Because data placed therein cannot survive a shutdown, a script responsible for syncing back to drive prior to system
shutdown is necessary if persistence is desired (which is likely in the case of profile relocation). On the other hand,
only relocating the cache is a quick, less inclusive solution that will slightly speed up user experience while emptying
Firefox cache on every reboot.

```{=mediawiki}
{{Note|Cache is stored '''separately''' from Firefox default profiles' folder ({{ic|/home/$USER/.mozilla/firefox/}}): it is found by default in {{ic|/home/$USER/.cache/mozilla/firefox/<profile>}}. This is similar to what Chromium and other browsers do. Therefore, sections [[#Place profile in RAM using tools]] and [[#Place profile in RAM manually]] '''do not deal''' with cache relocating and syncing but only with profile adjustments. See the first note of [[Profile-sync-daemon]] for more details. [[Anything-sync-daemon]] may be used to achieve the same thing as Option 2 for cache folders.}}
```
## Relocate cache to RAM only {#relocate_cache_to_ram_only}

See [Firefox/Tweaks#Turn off the disk
cache](Firefox/Tweaks#Turn_off_the_disk_cache "Firefox/Tweaks#Turn off the disk cache"){.wikilink}.

## Place profile in RAM using tools {#place_profile_in_ram_using_tools}

Relocate the browser profile to [tmpfs](tmpfs "tmpfs"){.wikilink} so as to globally improve browser\'s responsiveness.
Another benefit is a reduction in drive I/O operations, of which [SSDs benefit the
most](Improving_performance#Show_disk_writes "SSDs benefit the most"){.wikilink}.

Use an active management script for maximal reliability and ease of use. Several are available from the AUR.

### Profile-sync-daemon {#profile_sync_daemon}

See the [Profile-sync-daemon](Profile-sync-daemon "Profile-sync-daemon"){.wikilink} page for additional info on it.

### firefox-sync {#firefox_sync}

```{=mediawiki}
{{AUR|firefox-sync}}
```
is sufficient for a user with a single profile; uses a script and systemd service similar to [#The
script](#The_script "#The script"){.wikilink}.

Identify and backup your current Firefox profile as [#Before you
start](#Before_you_start "#Before you start"){.wikilink} suggests.

Use a [drop-in snippet](drop-in_snippet "drop-in snippet"){.wikilink} to pass the profile as an argument with
`{{ic|-p ''profile_id''.default}}`{=mediawiki}.

```{=mediawiki}
{{Warning|This will possibly delete the profile, be ready to restore from a backup as soon as you start the service.}}
```
Then [start/enable](start/enable "start/enable"){.wikilink} the `{{ic|firefox-sync.service}}`{=mediawiki} [user
unit](user_unit "user unit"){.wikilink}.

## Place profile in RAM manually {#place_profile_in_ram_manually}

### Before you start {#before_you_start}

Before potentially compromising Firefox\'s profile, be sure to make a backup for quick restoration. First, find out the
active profile name by visiting `{{ic|about:profiles}}`{=mediawiki} and checking which profile is in use. Replace
**`{{ic|xyz.default}}`{=mediawiki}** as appropriate and use `{{ic|tar}}`{=mediawiki} to make a backup:

`$ tar zcvfp ~/firefox_profile_backup.tar.gz ~/.mozilla/firefox/`**`xyz.default`**

### The script {#the_script}

The script is adapted from [verot.net\'s Speed up Firefox with tmpfs](https://www.verot.net/firefox_tmpfs.htm).

The script will first move Firefox\'s profile to a new static location, make a sub-directory in
`{{ic|/dev/shm}}`{=mediawiki}, softlink to it and later populate it with the contents of the profile. As before, and
until the end of this article, replace the bold **`{{ic|xyz.default}}`{=mediawiki}** strings with the name of your
Firefox profile folder. The only value that absolutely needs to be altered is, again,
**`{{ic|xyz.default}}`{=mediawiki}**.

Be sure that [rsync](rsync "rsync"){.wikilink} is installed, [create](create "create"){.wikilink}:

```{=mediawiki}
{{hc|~/.local/bin/firefox-sync.sh|2=
#!/bin/sh

static=''static-$1''
link=''$1''
volatile=''/dev/shm/firefox-$1-$USER''

IFS=
set -efu

cd ~/.mozilla/firefox

if [ ! -r $volatile ]; then
    mkdir -m0700 $volatile
fi

if [ "$(readlink $link)" != "$volatile" ]; then
    mv $link $static
    ln -s $volatile $link
fi

if [ -e $link/.unpacked ]; then
    rsync -av --delete --exclude .unpacked ./$link/ ./$static/
else
    rsync -av ./$static/ ./$link/
    touch $link/.unpacked
fi
}}
```
Make the script [executable](executable "executable"){.wikilink}, then run the following to close Firefox and test it:

`$ killall firefox firefox-bin`\
`$ ls ~/.mozilla/firefox/`\
`$ ~/.local/bin/firefox-sync.sh `**`xyz.default`**

Run Firefox again to gauge the results. The second time the script runs, it will then preserve the RAM profile by
copying it back to disk.

### Automation

Seeing that forgetting to sync the profile can lead to disastrous results, automating the process seems like a logical
course of action.

#### systemd

[Create](Create "Create"){.wikilink} the following script:

```{=mediawiki}
{{hc|~/.config/systemd/user/firefox-profile@.service|2=
[Unit]
Description=Firefox profile memory cache

[Install]
WantedBy=default.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=%h/.local/bin/firefox-sync.sh %i
ExecStop=%h/.local/bin/firefox-sync.sh %i
}}
```
then, do a [daemon-reload](daemon-reload "daemon-reload"){.wikilink} and
[enable/start](enable/start "enable/start"){.wikilink} the
`{{ic|firefox-profile@'''xyz.default'''.service}}`{=mediawiki} [user unit](user_unit "user unit"){.wikilink}.

#### cron job {#cron_job}

Manipulate the user\'s [cron](cron "cron"){.wikilink} table using `{{ic|crontab}}`{=mediawiki}:

`$ crontab -e`

Add a line to start the script every 30 minutes,

`*/30 * * * * ~/.local/bin/firefox-sync.sh `**`xyz.default`**

or add the following to do so every 2 hours:

`0 */2 * * * ~/.local/bin/firefox-sync.sh `**`xyz.default`**

#### Sync at login/logout {#sync_at_loginlogout}

Assuming [bash](bash "bash"){.wikilink} is being used, add the script to the login/logout files:

`$ echo 'bash -c "~/.local/bin/firefox-sync.sh `**`xyz.default`**` > /dev/null &"' | tee -a ~/.bash_logout ~/.bash_login`

```{=mediawiki}
{{Note|You may wish to use {{ic|~/.bash_profile}} instead of {{ic|~/.bash_login}} as bash will only read the former if both exist and are readable.}}
```
For [zsh](zsh "zsh"){.wikilink}, use `{{ic|~/.zlogin}}`{=mediawiki} and `{{ic|~/.zlogout}}`{=mediawiki} instead:

`$ echo 'bash -c "~/.local/bin/firefox-sync.sh `**`xyz.default`**` > /dev/null &"' | tee -a ~/.zlog{in,out}`

## See also {#see_also}

- [tmpfs](tmpfs "tmpfs"){.wikilink}

[Category:Web browser](Category:Web_browser "Category:Web browser"){.wikilink}

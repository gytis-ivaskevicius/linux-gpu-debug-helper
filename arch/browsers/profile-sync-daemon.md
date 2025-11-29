[ja:Profile-sync-daemon](ja:Profile-sync-daemon "wikilink") [ru:Profile-sync-daemon](ru:Profile-sync-daemon "wikilink")
[zh-hans:Profile-sync-daemon](zh-hans:Profile-sync-daemon "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|Anything-sync-daemon}}`{=mediawiki} `{{Related|Firefox}}`{=mediawiki} `{{Related|Chromium}}`{=mediawiki}
`{{Related|Pdnsd}}`{=mediawiki} `{{Related|SSD}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

```{=mediawiki}
{{pkg|profile-sync-daemon}}
```
(psd) is a tiny pseudo-daemon designed to manage browser profile(s) in tmpfs and to periodically sync back to the
physical disc (HDD/SSD). This is accomplished by an innovative use of [rsync](rsync "wikilink") to maintain
synchronization between a tmpfs copy and media-bound backup of the browser profile(s). Additionally, psd provides
several crash recovery features.

The design goals and benefits of psd are:

1.  Transparent user experience
2.  Reduced wear to physical drives
3.  Speed

Since the profile(s), browser cache, etc. are relocated into [tmpfs](tmpfs "wikilink") (RAM disk), the corresponding I/O
associated with using the browser is also redirected from the physical drive to RAM, thus reducing wear to the physical
drive and also greatly improving browser speed and responsiveness.

```{=mediawiki}
{{Note|
* Some browsers such as Chrome/Chromium or Firefox (since v21) actually keep their cache directories '''separately''' from their profile directory. It is not within the scope of profile-sync-daemon to modify this behavior; users are encouraged to refer to the [[Chromium tweaks#Cache in tmpfs]] section for Chromium and to the [[Firefox on RAM]] article for several workarounds.
* Occasionally, updates/changes are made to the default configuration file {{ic|/usr/share/psd/psd.conf}} upstream. The user copy {{ic|$XDG_CONFIG_HOME/psd/psd.conf}} will need to be diffed against it. On Arch Linux, pacman should notify the user to do this.
* psd can slow down [https://www.reddit.com/r/archlinux/comments/4l7gvm/very_slow_when_login/d3lrx9y/ login], as that is when it copies your browser cache to RAM.}}
```
## Installation

[Install](Install "wikilink") the `{{pkg|profile-sync-daemon}}`{=mediawiki} package.

## Configuration

When you run psd for the first time, it will create `{{ic|$XDG_CONFIG_HOME/psd/psd.conf}}`{=mediawiki} (referred to
hereafter as the configuration file) which contains all settings. You can run the `{{ic|psd}}`{=mediawiki} command
before using `{{ic|psd.service}}`{=mediawiki} to create this file without starting synchronization.

```{=mediawiki}
{{Note|Any edits made to this file while psd is active will be applied only after {{ic|psd.service}} has been [[restart]]ed.}}
```
-   Optionally enable the use of overlayfs to improve sync speed and to use a smaller memory footprint. Do this in the
    `{{ic|USE_OVERLAYFS}}`{=mediawiki} variable. The user will require sudo rights to
    `{{ic|/usr/bin/psd-overlay-helper}}`{=mediawiki} to use this option and the kernel must support overlayfs version 22
    or higher. See [#Overlayfs mode](#Overlayfs_mode "wikilink") for additional details.
-   Optionally define which browsers are to be managed in the `{{ic|BROWSERS}}`{=mediawiki} array. If none are defined,
    the default is all detected browsers.
-   Optionally disable the use of crash-recovery snapshots (not recommended). Do this in the
    `{{ic|USE_BACKUPS}}`{=mediawiki} variable.
-   Optionally define the number of crash-recovery snapshots to keep. Do this in the `{{ic|BACKUP_LIMIT}}`{=mediawiki}
    variable.

Example: Let us say that Chromium, Opera and Firefox are installed but only Chromium and Opera are to be sync\'ed to
tmpfs since the user keeps Firefox as a backup browser and it is seldom used:

`BROWSERS=(chromium opera)`

Beginning with version 5.54 of psd, native support for [overlayfs](#Overlayfs_mode "wikilink") is included. This feature
requires at least a Linux kernel version of 3.18.0 or greater.

### Supported browsers {#supported_browsers}

Currently, the following browsers are auto-detected and managed:

-   [Chromium](Chromium "wikilink")

-   ```{=mediawiki}
    {{AUR|conkeror-git}}
    ```

-   [Epiphany](Epiphany "wikilink")

-   ```{=mediawiki}
    {{Pkg|falkon}}
    ```

-   [Firefox](Firefox "wikilink") (all flavors including stable, beta, and nightly)

-   ```{=mediawiki}
    {{AUR|google-chrome}}
    ```

-   ```{=mediawiki}
    {{AUR|google-chrome-beta}}
    ```

-   ```{=mediawiki}
    {{AUR|google-chrome-dev}}
    ```

-   ```{=mediawiki}
    {{AUR|icecat}}
    ```

-   [Luakit](Luakit "wikilink")

-   [Opera](Opera "wikilink")

-   [Otter Browser](Otter_Browser "wikilink")

-   ```{=mediawiki}
    {{AUR|palemoon}}
    ```

-   [Qutebrowser](Qutebrowser "wikilink")

-   ```{=mediawiki}
    {{AUR|seamonkey}}
    ```

-   ```{=mediawiki}
    {{AUR|surf}}
    ```

-   ```{=mediawiki}
    {{Pkg|vivaldi}}
    ```

-   ```{=mediawiki}
    {{AUR|zen-browser}}
    ```

## Usage

[Start/enable](Start/enable "wikilink") the `{{ic|psd.service}}`{=mediawiki} [user unit](user_unit "wikilink").
Additionally, a provided resync-timer will run an hourly resync from tmpfs back to the disk. The resync-timer is started
automatically with `{{ic|psd.service}}`{=mediawiki} so there is no need to manually start the timer.

### Preview (parse) mode {#preview_parse_mode}

Run `{{ic|psd parse}}`{=mediawiki} to view what psd will do/is doing based on
`{{ic|$XDG_CONFIG_HOME/psd/psd.conf}}`{=mediawiki}. It will also provide useful information such as profile size, paths,
and if any recovery snapshots have been created.

## Tips and tricks {#tips_and_tricks}

### Sync at more frequent intervals {#sync_at_more_frequent_intervals}

The package provided re-sync timer triggers once per hour. Users may optionally redefine this behavior simply by
[extending the systemd unit](Systemd#Editing_provided_units "wikilink"). The example below changes the timer to sync
once every ten minutes (note that `{{ic|OnUnitActiveSec}}`{=mediawiki} needs to be cleared before being re-assigned
[1](https://bugzilla.redhat.com/show_bug.cgi?id=756787#c9)):

```{=mediawiki}
{{hc|~/.config/systemd/user/psd-resync.timer.d/frequency.conf|2=
[Unit]
Description=Timer for Profile-sync-daemon - 10min

[Timer]
OnUnitActiveSec=
OnUnitActiveSec=10min
}}
```
See `{{man|5|systemd.timer}}`{=mediawiki} for additional options.

### Overlayfs mode {#overlayfs_mode}

```{=mediawiki}
{{Note|There are several versions of overlayfs available to the Linux kernel in production in various distributions. Versions 22 and lower have a module called 'overlayfs' while newer versions (23 and higher) have a module called 'overlay' -- note the lack of the 'fs' in the newer version. Psd will automatically detect the overlayfs available to your kernel if it is configured to use one of them.}}
```
Overlayfs is a simple union file-system mainlined in the Linux kernel version 3.18.0. Starting with psd version 5.54,
overlayfs can be used to reduce the memory footprint of psd\'s tmpfs space and to speed up sync and unsync operations.
The magic is in how the overlay mount only writes out data that has changed rather than the entire profile. The same
recovery features psd uses in its default mode are also active when running in overlayfs mode. Overlayfs mode is enabled
by uncommenting the `{{ic|1=USE_OVERLAYFS="yes"}}`{=mediawiki} line in
`{{ic|$XDG_CONFIG_HOME/psd/psd.conf}}`{=mediawiki} followed by a [restart](restart "wikilink") of the daemon.

Since version 6.05 of psd, users wanting to take advantage of this mode MUST have [sudo](sudo "wikilink") rights
(without password prompt) to `{{ic|/usr/bin/psd-overlay-helper}}`{=mediawiki} or global sudo rights. The following line
in `{{ic|/etc/sudoers}}`{=mediawiki} will supply a [user](user "wikilink") with these rights. Add it using
[visudo](visudo "wikilink"):

*`username`*` ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper`

See the example in the PREVIEW MODE section above which shows a system using overlayfs to illustrate the memory savings
that can be achieved. Note the \"overlayfs size\" report compared to the total \"profile size\" report for each profile.
Be aware that these numbers will change depending on how much data is written to the profile, but in common use cases
the overlayfs size will always be less than the profile size.

```{=mediawiki}
{{Warning|Usage of psd in overlayfs mode (in particular, ''psd-overlay-helper'') may lead to privilege escalation. [https://github.com/graysky2/profile-sync-daemon/issues/235][https://github.com/graysky2/profile-sync-daemon/issues/286]}}
```
The way overlayfs works is to mount a read-only base copy (browser-back-ovfs) of the profile, and manage the new data on
top of that. In order to avoid resyncing to the read-only file system, a copy is used instead. So using overlayfs is a
trade off: faster initial sync times and less memory usage vs. disk space in the home dir.

### Allocate more memory to accommodate profiles in /run/user/xxxx {#allocate_more_memory_to_accommodate_profiles_in_runuserxxxx}

The standard way of controlling the size of `{{ic|/run/user}}`{=mediawiki} is the RuntimeDirectorySize directive in
`{{ic|/etc/systemd/logind.conf}}`{=mediawiki} (see `{{man|5|logind.conf}}`{=mediawiki} for more). By default, 10% of
physical memory is used but one can increase it safely. Remember that tmpfs only consumes what is actually used; the
number specified here is just a maximum allowed.

### Snapshots

Odds are the \"last good\" backup of your browser profiles is just fine still sitting happily on your filesystem. Upon
restarting psd (on a reboot for example), a check is performed to see if the symlink to the tmpfs copy of your profile
is valid. If it is invalid, psd will snapshot the \"last good\" backup before it rotates it back into place. This is
more for a sanity check that psd did no harm and that any data loss was a function of something else.

```{=mediawiki}
{{Note|Users can disable the snapshot/backup feature entirely by uncommenting and setting the {{ic|USE_BACKUPS}} variable to {{ic|"no"}} in {{ic|$XDG_CONFIG_HOME/psd/psd.conf}} if desired.}}
```
You will find the snapshot in the same directory as the browser profile and it will contain a date-time-stamp that
corresponds to the time at which the recovery took place. For example, chromium will be
`{{ic|~/.config/chromium-backup-crashrecovery-20130912_153310}}`{=mediawiki} \-- of course, the date_time suffix will be
different for you.

To restore your snapshots:

-   [Stop](Stop "wikilink") the `{{ic|psd.service}}`{=mediawiki} [user unit](user_unit "wikilink").
-   Confirm that there is no symlink to the tmpfs browser profile directory. If there is, psd did not stop correctly for
    other reasons.
-   Move the \"bad\" copy of the profile to a backup (do not blindly delete anything).
-   Copy the snapshot directory to the name that browser expects.

Example using Chromium:

`$ mv ~/.config/chromium ~/.config/chromium-bad`\
`$ cp -a ~/.config/chromium-backup-crashrecovery-20130912_153310 ~/.config/chromium`

At this point you can launch chromium which will use the backup snapshot you just copied into place. If all is well,
close the browser and restart psd. You may safely delete
`{{ic|~/.config/chromium-backup-crashrecovery-20130912_153310}}`{=mediawiki} at this point.

#### Clean all the snapshot with the clean mode {#clean_all_the_snapshot_with_the_clean_mode}

Running `{{ic|psd clean}}`{=mediawiki} will delete ALL recovery snapshots that have accumulated. Run this only if you
are sure that you want to delete them.

## Support

Post in the [discussion thread](https://bbs.archlinux.org/viewtopic.php?pid=1026974) with comments or concerns.

## See also {#see_also}

-   [Web Upd8 - Keep Your Browser Profiles In tmpfs (RAM) For Reduced Disk Writes And Increased Performance With Profile
    Sync Daemon](http://www.webupd8.org/2013/02/keep-your-browser-profiles-in-tmpfs-ram.html)
-   [Nicolas Bernaerts - Tweaks for SSD
    drive](https://web.archive.org/web/20220516124034/http://www.bernaerts-nicolas.fr/linux/74-ubuntu/250-ubuntu-tweaks-ssd)

[Category:Web browser](Category:Web_browser "wikilink")

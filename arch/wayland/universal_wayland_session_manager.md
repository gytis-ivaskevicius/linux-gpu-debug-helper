[es:Universal Wayland Session Manager](es:Universal_Wayland_Session_Manager "wikilink") [ja:Universal Wayland Session
Manager](ja:Universal_Wayland_Session_Manager "wikilink")
[zh-hans:通用Wayland会话管理器](zh-hans:通用Wayland会话管理器 "wikilink") The [Universal Wayland Session
Manager](https://github.com/Vladimir-csp/uwsm) (**uwsm**) wraps standalone [Wayland
compositors](Wayland#Compositors "wikilink") into a set of [systemd](systemd "wikilink") units on the fly. This provides
robust session management including environment, [XDG Autostart](XDG_Autostart "wikilink") support, bi-directional
binding with login session, and clean shutdown.

```{=mediawiki}
{{Note|It is highly recommended to use [[dbus-broker]] as the D-Bus daemon implementation. Among other benefits, it reuses the systemd activation environment instead of having a separate one. This simplifies environment management and allows proper cleanup. The [[D-Bus#Reference implementation|reference implementation]]
 is also supported, but it does not allow unsetting vars, so a best effort cleanup is performed by setting them to an empty string instead. The only way to properly clean up the separate environment of the reference D-Bus daemon is to run {{ic|loginctl terminate-user ""}}.}}
```
## Installation

[Install](Install "wikilink") the `{{Pkg|uwsm}}`{=mediawiki} package.

## Configuration

### Service startup notification and vars set by compositor {#service_startup_notification_and_vars_set_by_compositor}

```{=mediawiki}
{{Note|If managed compositors already set {{ic|WAYLAND_DISPLAY}} (and other useful environment variables) into the systemd activation environment, then you can skip this section and you do not need to use {{ic|uwsm finalize}}.}}
```
In order to find the current compositor, a Wayland application run as a systemd service needs the
`{{ic|WAYLAND_DISPLAY}}`{=mediawiki} environment variable (or `{{ic|DISPLAY}}`{=mediawiki} if they are intended to run
through [Xwayland](Xwayland "wikilink")). Therefore this and other useful environment variables should be put into the
systemd/dbus activation environment once the compositor has set their values.

The command `{{ic|uwsm finalize}}`{=mediawiki} puts `{{ic|WAYLAND_DISPLAY}}`{=mediawiki}, `{{ic|DISPLAY}}`{=mediawiki}
and other environment variables listed via the white-space separated `{{ic|UWSM_FINALIZE_VARNAMES}}`{=mediawiki} list
into the activation environment. It is recommended to execute this command after the compositor is ready.

If other variables set by the compositors are needed in the activation environment, they can be passed as arguments to
`{{ic|uwsm finalize}}`{=mediawiki} or put into a white-space separated list in
`{{ic|UWSM_FINALIZE_VARNAMES}}`{=mediawiki}. See the examples below:

`exec uwsm finalize `*`VAR1 VAR2 ...`*\
`export UWSM_FINALIZE_VARNAMES=`*`VAR1 VAR2 ...`*

### Environment variables {#environment_variables}

All environment variables set in `{{ic|${XDG_CONFIG_HOME}/uwsm/env}}`{=mediawiki} are sourced by *uwsm* and available to
all managed compositors and graphical applications run inside such a session.

If you need certain environment variables to be set only for a specific *compositor* (and graphical applications in that
graphical session), then put them in `{{ic|${XDG_CONFIG_HOME}/uwsm/env-''compositor''}}`{=mediawiki} instead.

An example of such a file can be seen below: `{{hc|~/.config/uwsm/env|
export ''KEY1''{{=}}`{=mediawiki}*VAR1* export *KEY2*{{=}}*VAR2* export *KEY3*{{=}}*VAR3* *\...*}}

## Usage

### Startup

```{=mediawiki}
{{Note|Environment preloader no longer sources POSIX shell profile if environment from the context of {{ic|uwsm start}} was successfully used.}}
```
*uwsm* can be started both by TTY and by a [display manager](display_manager "wikilink").

#### TTY

Add in your `{{ic|~/.profile}}`{=mediawiki} file:

```{=mediawiki}
{{bc|if uwsm check may-start && uwsm select; then
  exec uwsm start default
fi}}
```
If you want to always start the same *compositor*, then you can use instead in your `{{ic|~/.profile}}`{=mediawiki}
file:

```{=mediawiki}
{{bc|if uwsm check may-start; then
  exec uwsm start ''compositor''.desktop
fi}}
```
#### Display manager {#display_manager}

You can create a custom session desktop entry which starts your compositor through *uwsm*:

```{=mediawiki}
{{hc|/usr/share/wayland-sessions/my-compositor-uwsm.desktop|[Desktop Entry]
Name{{=}}
```
My compositor (with UWSM) Comment{{=}}My cool compositor, UWSM session

1.  either full command line with metadata and executable

Exec{{=}}uwsm start -N \"My compositor\" -D mycompositor:mylib -C \"My cool compositor\" \-- my-compositor

1.  or a reference to another entry

Exec{{=}}uwsm start \-- my-compositor.desktop

DesktopNames{{=}}mycompositor;mylib Type{{=}}Application}}

### Session termination {#session_termination}

If you want to terminate the current uwsm session, then you should use either
`{{ic|loginctl terminate-user ""}}`{=mediawiki} (terminates the entire user session) or `{{ic|uwsm stop}}`{=mediawiki}
(executes code after `{{ic|uwsm start}}`{=mediawiki} or terminates user session, if it replaced the [login
shell](login_shell "wikilink")).

```{=mediawiki}
{{Note|Do not use a compositor's native exit mechanism or kill its process directly. This will yank the compositor from under all the clients and interfere with ordered unit deactivation sequence.}}
```
## Tips and tricks {#tips_and_tricks}

### Applications and autostart {#applications_and_autostart}

By default uwsm launches compositors through a custom systemd service in `{{ic|session.slice}}`{=mediawiki}. Many
Wayland compositors allow you to start other applications that would then be launched inside the compositor service,
which would uselessly consume compositor resources or even interfere with notification sockets.

To start applications as separate systemd scope units you can use `{{ic|uwsm app}}`{=mediawiki}, which can launch both
executables

`uwsm app -- `*`/my/program/path`*

and [desktop entries](desktop_entries "wikilink")

`uwsm app -- `*`myprogram`*`.desktop`

By default uwsm puts launched scope units in `{{ic|app-graphical.slice}}`{=mediawiki} slice. If you want to put them in
`{{ic|background-graphical.slice}}`{=mediawiki} or `{{ic|session-graphical.slice}}`{=mediawiki}, then you should
respectively use options `{{ic|-s b}}`{=mediawiki}, `{{ic|-s s}}`{=mediawiki}:

`uwsm app -s b -- `*`background-app`*`.desktop`

#### Alternatives

Instead of `{{ic|uwsm app}}`{=mediawiki} (which runs as a Python script), you can use a faster alternative:

-   uwsm\'s `{{ic|uwsm-app}}`{=mediawiki} script which communicates with uwsm\'s app daemon.

-   ```{=mediawiki}
    {{AUR|app2unit-git}}
    ```
    , which is a shell script. You can use it as a drop-in replacement of `{{ic|uwsm app}}`{=mediawiki} by setting the
    `{{ic|APP2UNIT_SLICES}}`{=mediawiki} environment variable as follows:
    `{{bc|1=APP2UNIT_SLICES='a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice'}}`{=mediawiki}

-   ```{=mediawiki}
    {{AUR|runapp}}
    ```
    , which is written in C++, but missing some features.

## See also {#see_also}

-   ```{=mediawiki}
    {{man|1|uwsm}}
    ```

[Category:Wayland](Category:Wayland "wikilink")

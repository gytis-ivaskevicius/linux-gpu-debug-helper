[ja:VirtualGL](ja:VirtualGL "wikilink")
`{{Style|Page is very difficult to read, and that is before going into the edit tab and trying to make sense of the raw text.}}`{=mediawiki}

VirtualGL redirects an application\'s *OpenGL/GLX commands* to a separate X server (that has access to a 3D graphics
card), captures the rendered images, and then streams them to the X server that actually handles the application.

The main use-case is to enable server-side hardware-accelerated 3D rendering for *remote desktop* set-ups where the X
server that handles the application is either on the other side of the network *(in the case of X11 forwarding)*, or a
\"virtual\" X server that cannot access the graphics hardware *(in the case of VNC)*.

## Installation and setup {#installation_and_setup}

```{=mediawiki}
{{Expansion|section=Move to Main namespace and expand}}
```
[Install](Install "wikilink") the `{{Pkg|virtualgl}}`{=mediawiki} package, then follow [Configuring a Linux or Unix
Machine as a VirtualGL Server](https://rawcdn.githack.com/VirtualGL/virtualgl/3.0/doc/index.html#hd006) to configure it.
On arch, `{{ic|/opt/VirtualGL/bin/vglserver_config}}`{=mediawiki} is just `{{ic|vglserver_config}}`{=mediawiki} and
`{{ic|/opt/VirtualGL/bin/glxinfo}}`{=mediawiki} is `{{ic|vglxinfo}}`{=mediawiki}.

## Usage

### With X11 forwarding {#with_x11_forwarding}

```{=mediawiki}
{{Expansion}}
```
```{=mediawiki}
{{Text art|<nowiki>
  server:                                              client:
 ······································               ·················
 : ┌───────────┐ X11 commands         :               : ┌───────────┐ :
 : │application│━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━▶│X server 2)│ :
 : │           │        ┌───────────┐ :               : │           │ :
 : │           │        │X server 1)│ :               : ├┈┈┈┈┈┈┈┈┈╮ │ :
 : │ ╭┈┈┈┈┈┈┈┈┈┤ OpenGL │ ╭┈┈┈┈┈┈┈┈┈┤ : image stream  : │VirtualGL┊ │ :
 : │ ┊VirtualGL│━━━━━━━▶│ ┊VirtualGL│━━━━━━━━━━━━━━━━━━▶│client   ┊ │ :
 : └─┴─────────┘        └─┴─────────┘ :               : └─────────┴─┘ :
 ······································               ·················
</nowiki>}}
```
1.  \"3D\" rendering happens here
2.  \"2D\" rendering happens here

*Advantages of this set-up, compared to using [VirtualGL with VNC](#With_VNC "wikilink"):*

-   seamless windows
-   uses a little less CPU resources on the server side
-   supports stereo rendering (for viewing with \"3D glasses\")

#### Instructions

##### Preparation

In addition to setting up VirtualGL on the remote server [as described above](#Installation_and_setup "wikilink"), this
usage scenario requires you to:

-   install the `{{Pkg|virtualgl}}`{=mediawiki} package on the client side as well *(but no need to set it up like on
    the server side, we just need the `{{ic|vglconnect}}`{=mediawiki} and `{{ic|vglclient}}`{=mediawiki} binaries on
    this end)*.
-   set up [SSH with X11 forwarding](X11_forwarding "wikilink") *(confirm that connecting from the client to the server
    via `{{ic|ssh -X user@server}}`{=mediawiki} and running GUI applications in the resulting shell works)*

##### Connecting

Now you can use `{{ic|vglconnect}}`{=mediawiki} on the client computer whenever you want to connect to the server:

`$ vglconnect user@server     `*`# X11 traffic encrypted, VGL image stream unencrypted`*\
`$ vglconnect -s user@server  `*`# both X11 traffic and VGL image stream encrypted`*

This opens an SSH session with X11 forwarding just like `{{ic|ssh -X}}`{=mediawiki} would, and also automatically starts
the VirtualGL Client (`{{ic|vglclient}}`{=mediawiki}) with the right parameters as a background daemon. This daemon will
handle incoming VirtualGL image streams from the server, and will keep running in the background even after you close
the SSH shell - you can stop it with `{{ic|vglclient -kill}}`{=mediawiki}.

##### Running applications {#running_applications}

Once connected, you can run remote applications with VirtualGL rendering enabled for their OpenGL parts, by starting
them inside the SSH shell with `{{ic|vglrun}}`{=mediawiki} as described in [Running
Applications](#Running_applications "wikilink") below.

You do not need to restrict yourself to the shell that `{{ic|vglconnect}}`{=mediawiki} opened for you; any
`{{ic|ssh -X}}`{=mediawiki} or `{{ic|ssh -Y}}`{=mediawiki} shell you open from the same X session on the client to the
same *user*@*server* should work. `{{ic|vglrun}}`{=mediawiki} will detect that you are in an SSH shell, and make sure
that the VGL image stream is sent over the network to the IP/hostname belonging to the SSH client (where the running
`{{ic|vglclient}}`{=mediawiki} instance will intercept and process it).

### With VNC {#with_vnc}

```{=mediawiki}
{{Expansion}}
```
```{=mediawiki}
{{Text art|<nowiki>
  server:                                                              client:
 ······················································               ················
 : ┌───────────┐ X11 commands         ┌─────────────┐ : image stream  : ┌──────────┐ :
 : │application│━━━━━━━━━━━━━━━━━━━━━▶│VNC server 2)│━━━━━━━━━━━━━━━━━━▶│VNC viewer│ :
 : │           │        ┌───────────┐ └─────────────┘ :               : └──────────┘ :
 : │           │        │X server 1)│        ▲        :               :              :
 : │ ╭┈┈┈┈┈┈┈┈┈┤ OpenGL │ ╭┈┈┈┈┈┈┈┈┈┤ images ┃        :               :              :
 : │ ┊VirtualGL│━━━━━━━▶│ ┊VirtualGL│━━━━━━━━┛        :               :              :
 : └─┴─────────┘        └─┴─────────┘                 :               :              :
 ······················································               ················
</nowiki>}}
```
1.  \"3D\" rendering happens here
2.  \"2D\" rendering happens here

*Advantages of this set-up, compared to using [VirtualGL with X11 Forwarding](#With_X11_forwarding "wikilink"):*

-   can maintain better performance in case of low-bandwidth/high-latency networks
-   can send the same image stream to multiple clients (\"desktop sharing\")
-   the remote application can continue running even when the network connection drops
-   better support for non-Linux clients, as the architecture does not depend on a client-side X server

#### Instructions {#instructions_1}

After setting up VirtualGL on the remote server [as described above](#Installation_and_setup "wikilink"), and
establishing a working remote desktop connection using the [VNC client/server](Vncserver "wikilink") implementation of
your choice, no further configuration should be needed.

Inside the VNC session (e.g. in a terminal emulator within the VNC desktop or even directly in
`{{ic|~/.vnc/xstartup}}`{=mediawiki}), simply run selected applications with `{{ic|vglrun}}`{=mediawiki} as described in
[Running Applications](#Running_applications "wikilink") below.

You can also run your entire session with `{{ic|vglrun}}`{=mediawiki}, so that all opengl applications work by default.
For example, if you use xfce, you can run `{{ic|vglrun startxfce4}}`{=mediawiki} instead of
`{{ic|startxfce4}}`{=mediawiki} in your X startup scripts (`{{ic|~/.vnc/xstartup}}`{=mediawiki},
`{{ic|.xinitrc}}`{=mediawiki} or equivalent), or copy and edit a .desktop file in /usr/share/xsessions if you are using
a display manager.

#### Choosing an appropriate VNC package {#choosing_an_appropriate_vnc_package}

VirtualGL can provide 3D rendering for *any* general-purpose [vncserver](vncserver "wikilink") implementation (e.g.
TightVNC, RealVNC, \...).

However, if you want to really get good performance out of it *(e.g. to make it viable to watch videos or play OpenGL
games over VNC)*, you might want to use one of the VNC implementations that are specifically optimized for this
use-case:

-   ```{=mediawiki}
    {{AUR|turbovnc}}
    ```
    : Developed by the same team as VirtualGL, with the explicit goal of providing the best performance in combination
    with it. However, its vncserver implementation does not support all features a normal Xorg server provides, thus
    *some* applications will run unusually slow or not at all in it.

-   [TigerVNC](TigerVNC "wikilink"): Also developed with VirtualGL in mind and achieves good performance with it, while
    providing better Xorg compatibility than TurboVNC.

### With Xpra {#with_xpra}

#### On your host {#on_your_host}

-   Setup Xpra and run it [manually](Xpra#Run_applications_in_a_persistent_xpra_server_on_the_remote_host "wikilink") or
    [automatically by a systemd unit](Xpra#Server "wikilink"). Remember the specified Xorg display, e.g.
    `{{ic|:7}}`{=mediawiki}.

```{=html}
<!-- -->
```
-   Prepare a minimal xinit resource file that just locks your Xorg server\'s display:

```{=mediawiki}
{{hc|~/.xinitrc-vgl|
/usr/bin/xrdb ~/.Xresources
exec slock
}}
```
-   Start an Xorg server using the prepared resource file `{{ic|startx ~/.xinitrc-vgl}}`{=mediawiki}. Now,
    `{{ic|pgrep xorg}}`{=mediawiki} should return two Xorg instances.

```{=html}
<!-- -->
```
-   Run an application via vglrun command specifying the Xorg display used by your Xpra, e.g.
    `{{ic|1=DISPLAY=:7 vglrun glxspheres64}}`{=mediawiki}. The application will not be visible yet.

#### On your client {#on_your_client}

-   Setup Xpra at the client and [attach to
    it](Xpra#Run_applications_in_a_persistent_xpra_server_on_the_remote_host "wikilink"). Now you should see the
    glxspheres64 application started above.

```{=mediawiki}
{{Note|
* Use a ssh connection when attaching via network. X-forwarding not necessary. Also, set up a [[SSH keys#Generating an SSH key pair|ssh-keypair]] on client and [[SSH keys#Copying the public key to the remote server|copy it to the remote host]].
* ssh-keypair without password favorable for convenience. Also {{ic|xpra attach}} will not ask for password when run in background.
}}
```
## Running applications {#running_applications_1}

Once you have set up your remote desktop connection with VirtualGL support, you can use `{{ic|vglrun}}`{=mediawiki} to
run selected applications with VirtualGL-accelerated rendering of their OpenGL parts:

`$ vglrun glxgears`

This has to be executed on the remote computer of course (where the application will run), i.e. inside your SSH or VNC
session. The X servers that will be used, are determined from the following two environment variables:

`{{ic|DISPLAY}}`{=mediawiki}: *The X server \"2)\" that will handle the application, and render its non-OpenGL parts.* If using VNC, this refers to the VNC server. In the case of SSH forwarding, it is a virtual X server number on the remote computer that SSH internally maps to the real X server on the client. There is nothing VirtualGL-specific about this variable, and it will already be set to the correct value within your SSH or VNC session.\
`{{ic|VGL_DISPLAY}}`{=mediawiki}: *The X server \"1)\" to which VirtualGL should redirect OpenGL rendering.* See [Installation and setup](#Installation_and_setup "wikilink") above. If not set, the value `{{ic|:0.0}}`{=mediawiki} is assumed. Note that the number after the dot can be used to select the graphics card.

Many more environment variables and command-line parameters are available to fine-tune `{{ic|vglrun}}`{=mediawiki} -
refer to the user manual and `{{ic|vglrun -help}}`{=mediawiki} for reference. VirtualGL\'s behavior furthermore depends
on which of its two main modes of operation is active (which `{{ic|vglrun}}`{=mediawiki} will choose automatically,
based on the environment in which it is executed):

-   *\"**VGL Transport**\" - default when [using X11 forwarding](#With_X11_forwarding "wikilink")*

:   In this mode, a compressed image stream of the rendered OpenGL scenes is sent through a custom network protocol to a
    `{{ic|vglclient}}`{=mediawiki} instance. By default it uses JPEG compression at 90% quality, but this can be fully
    customized, e.g.:

```{=html}
<!-- -->
```

:   ```{=mediawiki}
    {{bc|$ vglrun -q 30 -samp 4x glxgears              ''# use aggressive compression (to reduce bandwidth demand)''}}
    ```

:   ```{=mediawiki}
    {{bc|1=$ VGL_QUAL=30 VGL_SUBSAMP=4x vglrun glxgears  ''# same as above, using environment variables''}}
    ```

```{=html}
<!-- -->
```

:   There is also a GUI dialog that lets you change the most common VirtualGL rendering/compression options for an
    application on the fly, after you have already started it with `{{ic|vglrun}}`{=mediawiki} - simply press
    `{{ic|Ctrl+Shift+F9}}`{=mediawiki} while the application has keyboard focus, to open this dialog.

-   *\"**X11 Transport**\" - default when [using VNC](#With_VNC "wikilink")*

:   In this mode, VirtualGL feeds raw (uncompressed) images through the normal X11 protocol directly to the X server
    that handles the application - e.g. a VNC server running on the same machine. Many of `{{ic|vglrun}}`{=mediawiki}\'s
    command-line options (e.g. those relating to image stream compression or stereo rendering) are not applicable here,
    because there is no `{{ic|vglclient}}`{=mediawiki} running on the other end. It is now the VNC server that handles
    all the image stream optimization/compression, so it is there that you should turn to for fine-tuning.

```{=mediawiki}
{{Tip|{{ic|vglrun}} is actually just a shell script that (temporarily) sets some environment variables before running the requested application - most importantly it adds the libraries that provide all the VirtualGL functionality to {{ic|LD_PRELOAD}}. If it better suits your workflow, you could just set those variables yourself instead. The following command lists all environment variables that vglrun would set for your particular set-up:

{{bc|comm -1 -3 <(env {{!}} sort) <(vglrun env {{!}}
```
grep -v \'\^\\\[\' {{!}} sort)}} }}

### Confirming that VirtualGL rendering is active {#confirming_that_virtualgl_rendering_is_active}

If you set the `{{ic|VGL_LOGO}}`{=mediawiki} environment variable before starting an application, a small logo reading
\"VGL\" will be shown in the bottom-right corner of any OpenGL scene that is rendered through VirtualGL in that
application:

`$ VGL_LOGO=1 vglrun glxgears`

If the application runs but the logo does not appear, it means VirtualGL has failed to take effect (see
[#Troubleshooting](#Troubleshooting "wikilink") below) and the application has probably fallen back to software
rendering.

### Measuring performance {#measuring_performance}

Many OpenGL programs or games can display an embedded FPS (\"frames per second\") counter - however when using VirtualGL
these values will not be very useful, as they merely measure the rate at which frames are rendered on the server side
(through the 3D-capable X server), not the rate at which frames actually end up being rendered on the client side.

The \"Performance Measurement\" chapter of the user manual describes how to get a measurement of the throughput at
various stages of the VirtualGL image pipeline, and how to identify bottlenecks (especially when using VirtualGL with
X11 forwarding). When using VNC, the VNC client should be able to tell you its rendering frame-rate as well.

## Troubleshooting

```{=mediawiki}
{{Tip|Running {{ic|vglrun}} with the {{ic|+v}} command-line switch (or environment variable {{ic|1=VGL_VERBOSE=1}}) makes VirtualGL print out some details about its attempt to initialize rendering for the application in question. The {{ic|+tr}} switch (or variable {{ic|1=VGL_TRACE=1}}) will make it print out lots of live info on intercepted OpenGL function calls during the actual rendering.

By default VirtualGL prints all its debug output to the shell - if you want to separate it from the application's own STDERR output you can set {{ic|1=VGL_LOG=/tmp/virtualgl-$USER.log}}.}}
```
### vglrun aborts with \"Could not open display\" {#vglrun_aborts_with_could_not_open_display}

If `{{ic|vglrun}}`{=mediawiki} exits with an error messages like\...

`[VGL] ERROR: Could not open display :0.`

\...in the shell output, then this means that the 3D-capable X server on the server side (that is supposed to handle the
OpenGL rendering) is either not running, or not properly set up for use with VirtualGL (see [Installation and
setup](#Installation_and_setup "wikilink")), or `{{ic|VGL_DISPLAY}}`{=mediawiki} is not set correctly (see [Running
Applications](#Running_applications "wikilink")). If it used to work but not anymore, a package upgrade may have
overwritten files modified by `{{ic|vglserver_config}}`{=mediawiki}, so run that script again and then restart the
server-side X server.

### vglrun seems to have no effect at all {#vglrun_seems_to_have_no_effect_at_all}

Symptoms:

-   no VirtualGL-accelerated 3D rendering - the program either aborts, or falls back to software rendering ([how to
    check](#Confirming_that_VirtualGL_rendering_is_active "wikilink"))
-   at the same time, *no* VirtualGL related error messages or info is printed to the shell

This may happen when something blocks VirtualGL from getting preloaded into the application\'s executable(s). The way
pre-loading works, is that `{{ic|vglrun}}`{=mediawiki} adds the names of some VirtualGL libraries to the
`{{ic|LD_PRELOAD}}`{=mediawiki} environment variable before running the command that starts the application. Now when an
application binary is executed as part of this command, the Linux kernel loads the dynamic linker which in turn detects
the `{{ic|LD_PRELOAD}}`{=mediawiki} variable and links the specified libraries into the in-memory copy of the
application binary before anything else. This will obviously not work if the environment variable is not propagated to
the dynamic linker, e.g. in the following cases:

-   **The application is started through a script that explicitly unsets/overrides LD_PRELOAD**

:   *Solution:* Edit the script to comment out or fix the offending line. (You can put the modified script in
    `{{ic|/usr/local/bin/}}`{=mediawiki} to prevent it from being reverted on the next package upgrade.)

-   **The application is started through multiple layers of scripts, and environment variables get lost along the way**

:   *Solution:* Modify the final script that actually runs the application, to make it run the application with
    `{{ic|vglrun}}`{=mediawiki}.

-   **The application is started through a loader binary *(possibly itself!)*, in a way that fails to propagate
    LD_PRELOAD**

:   *Solution:* If possible, bypass the loader binary and start the actual OpenGL application directly with
    `{{ic|vglrun}}`{=mediawiki} - an example is VirtualBox where you need to start your virtual machine session directly
    with `{{ic|vglrun VBoxManage startvm "Name of the VM"}}`{=mediawiki} rather then through the VirtualBox main program
    GUI. If it is a matter of LD_PRELOAD being explicitly unset within the binary, running `{{ic|vglrun}}`{=mediawiki}
    with the `{{ic|-ge}}`{=mediawiki} command-line switch can prevent that in some cases.

See the \"Application Recipes\" section in the user manual for a list of some applications that are known to require
such work-arounds.

### vglrun fails with ld.so errors {#vglrun_fails_with_ld.so_errors}

If VirtualGL-accelerated 3D rendering does not work (like with the previous section), but in addition you see error
messages like\...

`ERROR: ld.so: object 'libdlfaker.so' from LD_PRELOAD cannot be preloaded: ignored.`\
`ERROR: ld.so: object 'librrfaker.so' from LD_PRELOAD cannot be preloaded: ignored.`

\...in the shell output, then the dynamic linker is correctly receiving instructions to preload the VirtualGL libraries
into the application, but something prevents it from successfully performing this task. Three possible causes are:

-   **The VirtualGL libraries for the correct architecture are not installed**

:   To run a 32-bit application (like [Wine](Wine "wikilink")) with VirtualGL, you need to install
    `{{Pkg|lib32-virtualgl}}`{=mediawiki} from the [multilib](multilib "wikilink") repository.

-   **The application executable has the setuid/setgid flag set**

:   You can confirm whether this is the case by inspecting the executable\'s file permissions using
    `{{ic|ls -l}}`{=mediawiki}: It will show the letter `{{ic|s}}`{=mediawiki} in place of the *user executable* bit if
    setuid is set (for example `{{ic|-rw'''s'''r-xr-x}}`{=mediawiki}), and in place of the *group executable* bit if
    setgid is set. For such an application any preloading attempts will fail, unless the libraries to be preloaded have
    the setuid flag set as well. You can set this flag for the VirtualGL libraries in question by executing the
    following as root:

```{=html}
<div style="margin-left:1em;">
```
```{=mediawiki}
{{bc|
$ chmod u+s /usr/lib/lib{rr,dl}faker.so    # for the native-architecture versions provided by {{Pkg|virtualgl}}
$ chmod u+s /usr/lib32/lib{rr,dl}faker.so  # for the multilib versions provided by {{Pkg|lib32-virtualgl}}
}}
```
```{=html}
</div>
```

:   However, make sure you fully understand the security implications of [setuid](Wikipedia:Setuid "wikilink") before
    deciding to do this in a server environment where security is critical.

-   **You might need to specify the full path of the VirtualGL libraries**

:   Open /usr/bin/vglrun and specify the libraries\' full path in the LD_PRELOAD variable. Example:

```{=html}
<div style="margin-left:1em;">
```
```{=mediawiki}
{{bc|
libvglfaker$SUFFIX.so  ->  /usr/lib/libvglfaker$SUFFIX.so
}}
```
```{=html}
</div>
```
### vglrun fails with ERROR: Could not connect to VGL client. {#vglrun_fails_with_error_could_not_connect_to_vgl_client.}

If your \'client\' program is running on the same server as virtualGL (e.g. if you are using virtualGL for VNC), try
using `{{ic|vglrun -c proxy}}`{=mediawiki}.

### Error messages about /etc/opt/VirtualGL/vgl_xauth_key not existing {#error_messages_about_etcoptvirtualglvgl_xauth_key_not_existing}

This means that `{{ic|vglgenkey}}`{=mediawiki} is either not being run at all for your virtualGL X server, or that it is
being run again by another X server. For me, lightdm was running `{{ic|vglgenkey}}`{=mediawiki} on the wrong (vnc
remote) X servers, because `{{ic|vglserver_config}}`{=mediawiki} adds the following:

```{=mediawiki}
{{hc|/etc/lightdm/lightdm.conf|2=
...
[Seat:*]
display-setup-script=/usr/bin/vglgenkey
}}
```
Changing it to

```{=mediawiki}
{{hc|/etc/lightdm/lightdm.conf|2=
...
[Seat:seat0]
display-setup-script=/usr/bin/vglgenkey
}}
```
so it only runs on the first X server fixed my problem.

### vglrun fails with ERROR: VirtualGL attempted to load the real glXCreatePbuffer function and got the fake one instead. {#vglrun_fails_with_error_virtualgl_attempted_to_load_the_real_glxcreatepbuffer_function_and_got_the_fake_one_instead.}

This means that VirtualGL is trying to load a function from the wrong library. You can specify which OpenGL library to
use by setting `{{ic|LD_PRELOAD}}`{=mediawiki} to the path of the library. `{{ic|/usr/lib/libGL.so}}`{=mediawiki}
appears to work for 64-bit applications. Keep in mind that 32-bit applications (like Steam or Wine) will require 32-bit
OpenGL. If you need to use both 32-bit and 64-bit libraries, you can load them both with
`{{ic|1=LD_PRELOAD="/path/to/libGL.so /path/to/lib32/libGL.so"}}`{=mediawiki}.

### All applications run with 1 frame per second {#all_applications_run_with_1_frame_per_second}

If you use newer NVIDIA drivers (e.g., version 440) you might be affected by a screen locking problem, which will reduce
the framerate to approx. 1 frame per second according to the [VirtualGL mailing
list](https://groups.google.com/d/msg/virtualgl-users/d8k1ujwKJXo/2faAa9yNAQAJ). Instead of downgrading the NVIDIA
driver one workaround is to set `{{ic|HardDPMS}}`{=mediawiki} to `{{ic|false}}`{=mediawiki} in your X server
configuration (see [NVIDIA/Troubleshooting#HardDPMS](NVIDIA/Troubleshooting#HardDPMS "wikilink") for details).

### rendering glitches, unusually poor performance, or application errors {#rendering_glitches_unusually_poor_performance_or_application_errors}

OpenGL has a really low-level and flexible API, which means that different OpenGL applications may come up with very
different rendering techniques. VirtualGL\'s default strategy for how to redirect rendering and how/when to capture a
new frame works well with most interactive 3D programs, but may prove inefficient or even problematic for *some*
applications. If you suspect that this may be the case, you can tweak VirtualGL\'s mode of operation by setting certain
environment variables before starting your application with `{{ic|vglrun}}`{=mediawiki}. For example you could try
setting some of the following [environment variables](environment_variables "wikilink") *(try them one at a time, and be
aware that each of them could also make things worse!)*:

`VGL_ALLOWINDIRECT=1`\
`VGL_FORCEALPHA=1`\
`VGL_GLFLUSHTRIGGER=0`\
`VGL_READBACK=pbo`\
`VGL_SPOILLAST=0`\
`VGL_SYNC=1  # use VNC with this one, it is very slow with X11 forwarding`

A few OpenGL applications also make strong assumptions about their X server environment or loaded libraries, that may
not be fulfilled by a VirtualGL set-up - thus causing those applications to fail. The environment variables
`{{ic|VGL_DEFAULTFBCONFIG}}`{=mediawiki}, `{{ic|VGL_GLLIB}}`{=mediawiki}, `{{ic|VGL_TRAPX11}}`{=mediawiki},
`{{ic|VGL_X11LIB}}`{=mediawiki}, `{{ic|VGL_XVENDOR}}`{=mediawiki} can be used to fix this in some cases.

See the \"Advanced Configuration\" section in the user manual for a proper explanation of all supported environment
variables, and the \"Application Recipes\" section for info on some specific applications that are known to require
tweaking to work well with VirtualGL.

### Xpra: vglrun uses rendering device llvmpipe only {#xpra_vglrun_uses_rendering_device_llvmpipe_only}

You need two Xorg servers running: One that Xpra attaches to, e.g. at display :10. And a second one to do the actual
rendering using you graphics card, e.g. your default Xorg server that is run using startx at display :0.

## See also {#see_also}

-   [VirtualGL Online Documentation](https://www.virtualgl.org/Documentation/Documentation) (you can also find it at
    `{{ic|/usr/share/doc/virtualgl/index.html}}`{=mediawiki} if you have `{{Pkg|virtualgl}}`{=mediawiki} installed)

[Category:Graphics](Category:Graphics "wikilink") [Category:Remote desktop](Category:Remote_desktop "wikilink")

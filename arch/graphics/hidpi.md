[hu:HiDPI](hu:HiDPI "hu:HiDPI"){.wikilink} [ja:HiDPI](ja:HiDPI "ja:HiDPI"){.wikilink}
[ru:HiDPI](ru:HiDPI "ru:HiDPI"){.wikilink} [zh-hans:HiDPI](zh-hans:HiDPI "zh-hans:HiDPI"){.wikilink}
`{{Related articles start}}`{=mediawiki} `{{Related|Font configuration}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

HiDPI (High Dots Per Inch) displays, also known by Apple\'s \"[Retina
display](wikipedia:Retina_display "Retina display"){.wikilink}\" marketing name, are screens with a high resolution in a
relatively small format. They are mostly found in high-end laptops and monitors.

Not all software behaves well in high-resolution mode yet. Here are listed most common tweaks which make work on a HiDPI
screen more pleasant.

## Background

The terminology in this space can be misleading. Prior to HiDPI, the terms were:

- [Dots per inch](Wikipedia:Dots_per_inch "Dots per inch"){.wikilink} (DPI)---specifies the output density of ink
  droplets when printing a paper.
  [1](https://www.adobe.com/uk/creativecloud/photography/discover/dots-per-inch-dpi-resolution.html) Higher
  dots-per-inch correspond to a more dense output.
- [Pixel density](Wikipedia:Pixel_density "Pixel density"){.wikilink}, *pixels per inch* (PPI)---specifies the input
  density of a digital image.
  [2](https://www.adobe.com/uk/creativecloud/photography/discover/pixels-per-inch-ppi-resolution.html) Computed as
  `{{ic|(number of pixels in image) / (physical size of the photo)}}`{=mediawiki}.

Every display has an intrinsic PPI as the ratio of native screen resolution to physical screen size.
[3](https://web.archive.org/web/20191117040931/https://blogs.msdn.microsoft.com/fontblog/2005/11/08/where-does-96-dpi-come-from-in-windows/)
Although some technical sources use the term \"PPI\",
[4](https://github.com/hyprwm/Hyprland/blob/5ca48231287d67e75a3f21dbdbc47d6dc65752c4/src/helpers/Monitor.cpp#L563-L579)
it is much more common to (inaccurately) refer to this ratio as DPI. 96 DPI screens are regarded as comfortable for most
people to read \~12pt font on, and is about where most \"low-DPI\" monitors fall. HiDPI screens are around 192 DPI and
greater, with some screens falling in the middle (\"medium PPI\").

When using a HiDPI screen on a DPI-unaware system which assumes a DPI of \~96, small fonts will be uncomfortable to
read. Since font rendering is relatively easy to adjust, even \"DPI-unaware\" systems (such as [#Wine
applications](#Wine_applications "#Wine applications"){.wikilink}) often provide a knob for adjusting the font DPI.
Whenever a DPI setting is exposed as a number (as opposed to a multiplier or a percentage), it is likely referring to
the text rendering alone.

Most modern GUI toolkits are capable of \"integer scaling\", rendering the UI at least 2x size. This is achieved by
applying a different font DPI as well as providing HiDPI versions of assets. Some toolkits also support fractional
scaling, with GTK [#Fractional scaling](#Fractional_scaling "#Fractional scaling"){.wikilink} using a combination of
applying arbitrary font DPI and downscaling graphical resources.

On a desktop which is otherwise using UI scaling, applications that lack [resolution
independence](Wikipedia:Resolution_independence "resolution independence"){.wikilink} (such as
[#Xwayland](#Xwayland_2 "#Xwayland"){.wikilink}) may render at 1x scale and then be scaled up by the display server.

## Desktop environments {#desktop_environments}

### GNOME

To enable HiDPI, navigate to *Settings \> Devices \> Displays \> Scale* and choose an appropriate value. Or, use
gsettings:

`$ gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <2>}]"`\
`$ gsettings set org.gnome.desktop.interface scaling-factor 2`

```{=mediawiki}
{{Note|1=By default, GNOME only allows integer scaling numbers to be set. {{ic|1}} = 100%, {{ic|2}} = 200%, etc. See [[#Fractional scaling]] below.}}
```
#### Fractional scaling {#fractional_scaling}

A setting of `{{ic|2}}`{=mediawiki}, `{{ic|3}}`{=mediawiki}, etc, which is all you can do with
`{{ic|scaling-factor}}`{=mediawiki}, may not be ideal for certain HiDPI displays and smaller screens (e.g. small
tablets). Fractional scaling is possible on both Wayland and Xorg, though the process differs.

Implementation was mainly discussed and decided in GNOME fractional scaling hackfest 2017, check
[5](https://hackmd.io/WspOFZpRTo2qlWc8fh_zPQ) for more technical details.

```{=mediawiki}
{{Note|{{Accuracy|The information below is subject to change. For more, please see [https://www.reddit.com/r/gnome/comments/11ekj8o/comment/jah8i0b/ this online discussion].}}

Currently, GTK only supports fractional scaling for fonts. On the other hand, widgets, like buttons or labels, [https://discourse.gnome.org/t/fractional-scale-factor-in-gtk-again/10803 may only use integer (DPI) scaling].  As such, fractional scaling for most native GNOME applications requires first rendering at a higher resolution, then downscaling to the requested resolution. GTK utilizes this technique in both Wayland and Xorg sessions.

For some setups [https://www.gtk.org/docs/architecture/index running GTK 3 applications], this can increase CPU and GPU usage and power usage, resulting in a less responsive experience - particularly in Xorg. If these issues are considerable in your use case, please consider using another desktop environment or deactivating fractional scaling.
}}
```
##### Wayland

Enable the experimental fractional scaling feature:

`$ gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"`

then open *Settings \> Devices \> Displays* (the new options may only appear after a restart).

To enable the option for all users, create the following three files with the corresponding content

```{=mediawiki}
{{hc|/etc/dconf/profile/user|
user-db:user
system-db:local
}}
```
```{=mediawiki}
{{hc|/etc/dconf/db/local.d/00-hidpi|2=
[org/gnome/mutter]
experimental-features=['scale-monitor-framebuffer']
}}
```
```{=mediawiki}
{{hc|/etc/dconf/db/locks/hidpi|
/org/gnome/mutter/experimental-features
}}
```
Then run `{{ic|dconf update}}`{=mediawiki} and restart the machine. This will permanently lock the option.

###### Xwayland

[As of Mutter 47.0](https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3567) it is possible to enable native
fractional scaling as an experimental feature.

Enable it by issuing:

`$ gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer', 'xwayland-native-scaling']"`

#### Text Scaling {#text_scaling}

Alternatively, or in addition to changing the display scaling, you can separately scale text. This can be done by
navigating to *Fonts \> Scaling Factor* in Gnome Tweaks, or using gsettings. Note that the text scaling factor need not
be limited to whole integers, for example:

`$ gsettings set org.gnome.desktop.interface text-scaling-factor 1.5`

##### GTK+ vs Gnome Shell elements on Xorg {#gtk_vs_gnome_shell_elements_on_xorg}

```{=mediawiki}
{{Out of date|Needs a partial rewrite regarding the Gnome Shell Toolkit, since it looks unmaintained since [https://gitlab.gnome.org/GNOME/gnome-shell/-/tree/shell-toolkit 2009].}}
```
Adjusting the text scaling as per the above only affects GTK+ elements of the GNOME desktop. This should cover
everything on Wayland. However, those on an Xorg session may find that they need to make further adjustments on HiDPI
environments, since the GNOME Shell UI (including the top bar, dock, application menus, etc.) relies separately on the
[St](https://developer.gnome.org/st/stable/)`{{Dead link|2021|11|11|status=404}}`{=mediawiki} toolkit. Note that this is
a long-standing issue to which a [patch](https://gitlab.gnome.org/GNOME/gnome-shell/merge_requests/486) has been merged
and available for Gnome Shell 3.35 onward. For older releases, Xorg users can resolve most of the Gnome shell scaling
problems by manually editing the shell theme that they are currently using. The relevant CSS files are normally located
at `{{ic|/usr/share/themes/YOUR-THEME/gnome-shell/gnome-shell.css}}`{=mediawiki}. Users should increase all
\"font-size\" elements in this file in proportion to their display scaling (doubling font sizes for 200% scaling, etc.)
For example, the top of an edited CSS file for the [Adapta](https://github.com/adapta-project/adapta-gtk-theme) shell
theme might look like:

```{=mediawiki}
{{hc|usr/share/themes/Adapta/gnome-shell/gnome-shell.css|2=
stage { font-size: 20pt; font-family: Roboto, Noto Sans, Sans-Serif; color: #263238; }
}}
```
Once these changes have been saved, activate them by switching to another theme (for example, using
`{{Pkg|gnome-tweaks}}`{=mediawiki}) and then reverting back again. The top bar, application menus, calendar, and other
shell elements should now be correctly scaled.

In addition to editing the relevant shell theme\'s CSS file, users on Xorg may also wish to increase the title bar font
at the top of open applications. This can be done through the dconf editor
(`{{ic|org > gnome > desktop > wm > preferences :: titlebar-font}}`{=mediawiki}). Note that the
`{{ic|title-bar-uses-system-fonts}}`{=mediawiki} option should also be turned off. Alternatively, use gsettings:

`$ gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 22' ## Change as needed`\
`$ gsettings set org.gnome.desktop.wm.preferences titlebar-uses-system-font false`

### KDE Plasma {#kde_plasma}

You can use Plasma\'s settings to fine tune font, icon, and widget scaling. This solution affects both Qt and GTK
applications.

```{=mediawiki}
{{Note|Plasma 5.27 [https://invent.kde.org/plasma/plasma-workspace/-/merge_requests/2544 dropped] use of {{ic|GDK_SCALE}}/{{ic|GDK_DPI_SCALE}} variables and [https://invent.kde.org/plasma/kde-gtk-config/-/merge_requests/49 switched] to [[Xsettingsd]]. It should be installed to make scaling work for GTK apps. Or you can set this variables manually as described in [[#GDK 3 (GTK 3)]].}}
```
To adjust font, widget, and icon scaling together:

1.  *System Settings \> Display and Monitor \> Display Configuration \> Global Scale*
2.  Drag the slider to the desired size
3.  Restart for the settings to take effect

```{=mediawiki}
{{Note|If you are using xorg, and global scaling is set but not applied to Qt applications after reboot, please check if {{ic|xft.dpi}} is set in {{ic|~/.Xresources}} . If so, removing the variable and adjusting global scaling again may take effect.}}
```
However, using [X11](X11 "X11"){.wikilink} session, Plasma ignores the Qt scaling settings by default, which affects
panels and other desktop elements. To make Plasma respect the Qt settings, [set](Environment_variables "set"){.wikilink}
`{{ic|1=PLASMA_USE_QT_SCALING=1}}`{=mediawiki}.

#### Cursor size {#cursor_size}

To adjust cursor size:

1.  *System Settings \> Appearance \> Cursors \> Size*

#### Font scaling {#font_scaling}

To adjust only font scaling:

1.  *System Settings \> Appearance \> Fonts*
2.  Check \"Force fonts DPI\" and adjust the DPI level to the desired value. This setting should take effect immediately
    for newly started applications. You will have to logout and login for it to take effect on Plasma desktop.

#### Icon scaling {#icon_scaling}

To adjust only icon scaling:

1.  *System Settings \> Appearance \> Icons \> Advanced*
2.  Choose the desired icon size for each category listed. This should take effect immediately.

#### Panel scaling {#panel_scaling}

To adjust only panel scaling:

1.  Right click the panel, select *Enter Edit Mode*, and manually adjust *Panel height*.

#### Xwayland {#xwayland_1}

As of Plasma 5.26, the Xwayland scale method can be chosen at the bottom of the *System Settings \> Display and Monitor
\> Display Configuration* page.

In \"Scaled by the system\" mode, the X application will be rendered at 1x and then magnified (scaled) by KDE. This
works for all applications, but causes blurriness due to the magnification.

In \"Apply scaling themselves\" mode, the X application will have to render itself at the appropriate size. This will
avoid blurriness, but applications which aren\'t HiDPI-aware will render themselves at 1x scale and therefore will
appear small.

See this [blog post](https://pointieststick.com/2022/06/17/this-week-in-kde-non-blurry-xwayland-apps/) for details.

### Xfce

Xfce supports HiDPI scaling which can be enabled using the settings manager:

1.  Go to *Settings Manager \> Appearance \> Settings \> Window Scaling* and select 2 as the scaling factor.
2.  Go to *Settings Manager \> Window Manager \> Style* and select `{{ic|Default-xhdpi}}`{=mediawiki} theme.

Alternatively, it is possible to do the same from command line using *xfconf-query*:

`$ xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 2`\
`$ xfconf-query -c xfwm4 -p /general/theme -s Default-xhdpi`

After either of the above changes, fonts in some GTK applications may still not be scaled; you may additionally do the
following (see [#GDK 3 (GTK 3)](#GDK_3_(GTK_3) "#GDK 3 (GTK 3)"){.wikilink}):

1.  Go to *Settings Manager \> Appearance \> Fonts \> Custom DPI setting* and change from 96 to 192
2.  Set the [environment variable](environment_variable "environment variable"){.wikilink}
    `{{ic|1=GDK_DPI_SCALE=0.5}}`{=mediawiki} to un-scale some fonts that would be scaled twice.

The steps above would set 2x scaled resolution for Xfce and other GTK 3 applications.

Scaling for Qt 5 applications should be set manually, see [#Qt 5](#Qt_5 "#Qt 5"){.wikilink}. Note that if you set a
Custom DPI for fonts above, you likely need to set `{{ic|1=QT_FONT_DPI=96}}`{=mediawiki} to avoid double-scaling of
fonts in Qt applications.

### Cinnamon

Has good support out of the box.

### Enlightenment

For E18, go to the E Setting panel. In *Look \> Scaling*, you can control the UI scaling ratios. A ratio of 1.2 seems to
work well for the native resolution of the MacBook Pro 15\" screen.

## Window managers {#window_managers}

### Sway

See [Sway#HiDPI](Sway#HiDPI "Sway#HiDPI"){.wikilink}.

### Hyprland

See [Hyprland#Setting screen
resolution](Hyprland#Setting_screen_resolution "Hyprland#Setting screen resolution"){.wikilink}.

## X Resources {#x_resources}

```{=mediawiki}
{{Accuracy|{{Pkg|libxft}} is a ''font rendering interface library'', the {{ic|Xft.dpi}} setting was not intended to be abused by other applications. On the other hand, the {{ic|xorg.conf}} value should affect everything.}}
```
If you are not using a desktop environment such as KDE, Xfce, or other that manipulates the X settings for you, you can
set the desired DPI setting manually via the `{{ic|Xft.dpi}}`{=mediawiki} variable in
[Xresources](Xresources "Xresources"){.wikilink}:

```{=mediawiki}
{{hc|~/.Xresources|2=
Xft.dpi: 192

! These might also be useful depending on your monitor and personal preference:
Xft.autohint: 0
Xft.lcdfilter:  lcddefault
Xft.hintstyle:  hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
}}
```
For `{{ic|Xft.dpi}}`{=mediawiki}, using integer multiples of 96 usually works best, e.g. 192 for 200% scaling.

Make sure the settings are loaded properly when X starts, for instance in your `{{ic|~/.xinitrc}}`{=mediawiki} with
`{{ic|xrdb -merge ~/.Xresources}}`{=mediawiki} (see [Xresources](Xresources "Xresources"){.wikilink} for more
information).

This will make the font render properly in most toolkits and applications, it will however not affect things such as
icon size! Setting `{{ic|Xft.dpi}}`{=mediawiki} at the same time as toolkit scale (e.g. `{{ic|GDK_SCALE}}`{=mediawiki})
may cause interface elements to be much larger than intended in some programs like firefox.

## X Server {#x_server}

Some programs may still interpret the DPI given by the X server (most interpret X Resources, though, directly or
indirectly). Older versions of i3 (before 2017) and Chromium (before 2017) used to do this.

To verify that the X Server has properly detected the physical dimensions of your monitor, use the *xdpyinfo* utility
from the `{{Pkg|xorg-xdpyinfo}}`{=mediawiki} package:

```{=mediawiki}
{{hc|$ xdpyinfo {{!}}
```
grep -B 2 resolution\| screen #0:

` dimensions:    3200x1800 pixels (423x238 millimeters)`\
` resolution:    192x192 dots per inch`

}}

This example uses inaccurate dimensions (423mm x 238mm, even though the Dell XPS 9530 has 346mm x 194mm) to have a clean
multiple of 96 dpi, in this case 192 dpi. This tends to work better than using the correct DPI --- Pango renders fonts
crisper in i3 for example.

If the DPI displayed by xdpyinfo is not correct, see [Xorg#Display size and
DPI](Xorg#Display_size_and_DPI "Xorg#Display size and DPI"){.wikilink} for how to fix it.

## GUI toolkits {#gui_toolkits}

### Qt 5 {#qt_5}

Since Qt 5.6, Qt 5 applications can be instructed to honor screen DPI by setting the
`{{ic|QT_AUTO_SCREEN_SCALE_FACTOR}}`{=mediawiki} [environment
variable](environment_variable "environment variable"){.wikilink}. Qt 5.14 introduced a new environment variable
`{{ic|QT_ENABLE_HIGHDPI_SCALING}}`{=mediawiki} which
[replaces](https://doc.qt.io/qt-5/highdpi.html#high-dpi-support-in-qt) the
`{{ic|QT_AUTO_SCREEN_SCALE_FACTOR}}`{=mediawiki} variable. It is recommended to set both [environment
variables](environment_variable "environment variable"){.wikilink} for maximum compatibility:

`$ export QT_AUTO_SCREEN_SCALE_FACTOR=1`\
`$ export QT_ENABLE_HIGHDPI_SCALING=1`

If automatic detection of DPI does not produce the desired effect, scaling can be set manually per-screen
(`{{ic|QT_SCREEN_SCALE_FACTORS}}`{=mediawiki}/`{{ic|QT_ENABLE_HIGHDPI_SCALING}}`{=mediawiki}) or globally
(`{{ic|QT_SCALE_FACTOR}}`{=mediawiki}). For more details see the [Qt blog
post](https://blog.qt.io/blog/2016/01/26/high-dpi-support-in-qt-5-6/) or [Qt developer
documentation](https://doc.qt.io/qt-5/highdpi.html).

```{=mediawiki}
{{Note|
* If you manually set the screen factor, it is important to set {{ic|1=QT_AUTO_SCREEN_SCALE_FACTOR=0}} and {{ic|1=QT_ENABLE_HIGHDPI_SCALING=0}} otherwise some applications which explicitly force high DPI enabling get scaled twice.
* {{ic|QT_SCALE_FACTOR}} scales fonts, but {{ic|QT_SCREEN_SCALE_FACTORS}} may not scale fonts, depending on the application.
* If you also set the font DPI manually in ''xrdb'' to support other toolkits, {{ic|QT_SCALE_FACTORS}} will give you huge fonts.
* If you have multiple screens of differing DPI ie: [[#Side display]] you may need to do {{ic|1=QT_SCREEN_SCALE_FACTORS="2;2"}}
}}
```
An [alternative](https://bugreports.qt.io/browse/QTBUG-53022) is e.g.:

`$ QT_FONT_DPI=96 clementine`

### GDK 3 (GTK 3) {#gdk_3_gtk_3}

```{=mediawiki}
{{Note|As stated in the [[#X Resources]] section, if you have xft.dpi set to a larger dpi, it will make other scales larger than usual, including GDK.}}
```
Setting the GDK scale (in X11, not Wayland) will scale the UI; however, it will not scale icons. If you are using a
minimal window manager where you are setting the dpi via Xft.dpi, GDK should scale perfectly fine with it. In other
cases, [do the following](https://docs.gtk.org/gtk3/x11.html):

To scale UI elements by an integer only factor:

`$ export GDK_SCALE=2`

GTK3 does not support fractional scaling currently, so fractional factors will be ignored. This environment variable is
also ignored in mutter wayland sessions.

GTK4 supports fractional scaling since 4.14 under Wayland.

```{=mediawiki}
{{ic|GDK_DPI_SCALE}}
```
can be used to scale text only. To undo scaling of text, fractional scale can be used:

`$ export GDK_DPI_SCALE=0.5`

Under GTK3/4 it not currently possible to scale icon sizes, unless the application explicitly implements a way to do so.
See bug report [#4528](https://gitlab.gnome.org/GNOME/gtk/-/issues/4528). If you need this feature, use Qt when
possible.

### GTK 2 {#gtk_2}

Scaling of UI elements is not supported by the toolkit itself, however it is possible to generate a theme with elements
pre-scaled for HiDPI display using `{{AUR|themix-full-git}}`{=mediawiki}.

### Electron

[Electron](Electron "Electron"){.wikilink} applications (e.g. `{{AUR|slack-desktop}}`{=mediawiki},
`{{Pkg|signal-desktop}}`{=mediawiki}, etc.) can be configured to always use a custom scaling value by adding a
`{{ic|1=--force-device-scale-factor}}`{=mediawiki} flag to the *.desktop* file. Electron packages in the official
repositories and packages that use them, can be configured with a [configuration
file](Electron#Configuration_files "configuration file"){.wikilink}.

Desktop files are normally located at `{{ic|/usr/share/applications/}}`{=mediawiki}, and can normally be overridden on a
per-user basis by copying it to `{{ic|~/.local/share/applications/}}`{=mediawiki}. The flag should be added to the line
beginning with \"Exec=\". For example:

```{=mediawiki}
{{hc|~/.local/share/applications/slack.desktop|2=
Exec=env LD_PRELOAD=/usr/lib/libcurl.so.3 /usr/bin/slack --force-device-scale-factor=1.5 %U
}}
```
### Elementary (EFL) {#elementary_efl}

To scale UI elements by a factor of 1.5:

`export ELM_SCALE=1.5`

For more details see
<https://phab.enlightenment.org/w/elementary/>`{{Dead link|2024|10|12|status=domain name not resolved}}`{=mediawiki}

### GNUstep

GNUstep applications that use its gui (AppKit) library accept a `{{ic|GSScaleFactor}}`{=mediawiki} property in their
defaults (STEP preferences). To define a scaling factor of 1.5 for all applications:

`defaults write NSGlobalDomain GSScaleFactor 1.5`

Note that you must also disable font hinting by setting the value of `{{ic|GSFontHinting}}`{=mediawiki} to 17, else text
rendering will look broken when rendering long lines.

`defaults write NSGlobalDomain GSFontHinting 17`

Some automatic detection was possible back in 2011, but the code responsible for the X11 backend was [commented
out](https://github.com/gnustep/libs-back/commit/337ce46bba304732d9a7c7495a3dd245a3219660) thereafter.

### FLTK

FLTK 1.3, the default FLTK version available in Arch Linux, does not support resolution scaling. Support will arrive
when applications start using FLTK 1.4.

### AvaloniaUI (C# / .NET) {#avaloniaui_c_.net}

```{=mediawiki}
{{ic|AVALONIA_GLOBAL_SCALE_FACTOR}}
```
can be used to scale. To undo scaling, fractional scale can be used:

`$ export AVALONIA_GLOBAL_SCALE_FACTOR=0.5`

For per monitor configuring see [avalonia
wiki](https://github.com/AvaloniaUI/Avalonia/wiki/Configuring-X11-per-monitor-DPI)\].

## Boot managers {#boot_managers}

### GRUB

#### Lower the framebuffer resolution {#lower_the_framebuffer_resolution}

Set a lower resolution for the framebuffer as explained in [GRUB/Tips and tricks#Setting the framebuffer
resolution](GRUB/Tips_and_tricks#Setting_the_framebuffer_resolution "GRUB/Tips and tricks#Setting the framebuffer resolution"){.wikilink}.

#### Change GRUB font size {#change_grub_font_size}

Find a ttf font that you like in `{{ic|/usr/share/fonts/}}`{=mediawiki}.

Convert the font to a format that GRUB can utilize:

`# grub-mkfont -s 30 -o /boot/grubfont.pf2 /usr/share/fonts/FontFamily/FontName.ttf`

```{=mediawiki}
{{Note|Change the {{ic|-s 30}} parameter to modify the font size}}
```
Edit `{{ic|/etc/default/grub}}`{=mediawiki} to set the new font as shown in [GRUB/Tips and tricks#Background image and
bitmap
fonts](GRUB/Tips_and_tricks#Background_image_and_bitmap_fonts "GRUB/Tips and tricks#Background image and bitmap fonts"){.wikilink}:

`GRUB_FONT="/boot/grubfont.pf2"`

```{=mediawiki}
{{Note|{{ic|GRUB_THEME}} overrides {{ic|GRUB_FONT}} if it is used.}}
```
Finally [regenerate the main configuration
file](GRUB#Generate_the_main_configuration_file "regenerate the main configuration file"){.wikilink}.

```{=mediawiki}
{{Tip|The font size can also be changed with the GUI tool {{AUR|grub-customizer}}.}}
```
### systemd-boot {#systemd_boot}

Set a lower resolution for the console through `{{ic|console-mode}}`{=mediawiki} as explained in [systemd-boot#Loader
configuration](systemd-boot#Loader_configuration "systemd-boot#Loader configuration"){.wikilink} and
`{{man|5|loader.conf|OPTIONS}}`{=mediawiki}.

## Applications

If you are running a Wayland session, but application is running via Xwayland (either because it does not support
Wayland natively or because it uses X11 by default), you could still get blurry fonts and interface, even if the
application supports HiDPI. See [this bug report](https://bugs.kde.org/show_bug.cgi?id=389191). See also [Wayland#Detect
Xwayland applications](Wayland#Detect_Xwayland_applications "Wayland#Detect Xwayland applications"){.wikilink}.

### Browsers

#### Firefox

Firefox should use the [#GDK 3 (GTK 3)](#GDK_3_(GTK_3) "#GDK 3 (GTK 3)"){.wikilink} settings. However, the suggested
`{{ic|GDK_SCALE}}`{=mediawiki} suggestion does not consistently scale the entirety of Firefox, and does not work for
fractional values (e.g., a factor of 158DPI/96DPI = 1.65 for a 1080p 14\" laptop). You may want to use
`{{ic|GDK_DPI_SCALE}}`{=mediawiki} instead. Another option, which will avoid Firefox-specific settings in many setups is
to use the settings in [#X Resources](#X_Resources "#X Resources"){.wikilink} as Firefox should respect the
`{{ic|Xft.dpi}}`{=mediawiki} value defined there.

To view the internal UI scaling settings of Firefox, open the advanced preferences page
(`{{ic|about:config}}`{=mediawiki}) and check those parameters:

- ```{=mediawiki}
  {{ic|widget.wayland.fractional-scale.enabled}}
  ```

  :   Set it to true to enable fractional scaling on wayland. Otherwise, on some desktop environments (e.g., KDE on
      wayland), Firefox may be double scaled. For example, if you set the screen scale to 150% in plasma system
      settings, Firefox will enlarge to 200% first and then be down-scaled to 150%, so all fonts look blurry.

- ```{=mediawiki}
  {{ic|layout.css.devPixelsPerPx}}
  ```

  :   The actual parameter that controls UI scaling. `{{ic|1.25}}`{=mediawiki} for 125% scaling,
      `{{ic|1.50}}`{=mediawiki} for 150%, and so on. Default is `{{ic|-1.0}}`{=mediawiki} (follow the system\'s HiDPI
      setting).

If you use a HiDPI monitor such as Retina display together with another monitor, you can use the
[ffreszoom](https://addons.mozilla.org/firefox/addon/ffreszoom/) add-on, which will adjust the page zoom if it detects
you are using a large monitor (zoom level and threshold are configurable). Modifying the internal CSS DPI setting from
an extension is currently unsupported [6](https://bugzilla.mozilla.org/show_bug.cgi?id=1373607).

#### Chromium / Google Chrome {#chromium_google_chrome}

Chromium should use the [#GDK 3 (GTK 3)](#GDK_3_(GTK_3) "#GDK 3 (GTK 3)"){.wikilink} settings.

To override those, use the `{{ic|1=--force-device-scale-factor}}`{=mediawiki} flag with a scaling value. This will scale
all content and ui, including tab and font size. For example
`{{ic|1=chromium --force-device-scale-factor=2}}`{=mediawiki}.

Using this option, a scaling factor of 1 would be normal scaling. Floating point values can be used. To make the change
permanent, for Chromium, you can add it to `{{ic|~/.config/chromium-flags.conf}}`{=mediawiki}:

```{=mediawiki}
{{hc|~/.config/chromium-flags.conf|2=
--force-device-scale-factor=2
}}
```
To make this work for Chrome, add the same option to `{{ic|~/.config/chrome-flags.conf}}`{=mediawiki} instead.

If you are using Wayland and the setting the above flag doesn\'t seem to work on Chrome (not Chromium), you might need
to explicitly set the following \'experimental\' settings via accessing the url from the address bar:
`{{ic|1=chrome://flags/}}`{=mediawiki} ([What are Chrome
flags?](https://developer.chrome.com/docs/web-platform/chrome-flags)):

- \"Preferred Ozone platform\": \"Wayland\"
- \"Wayland per-window scaling\": \"Enabled\"
- \"Wayland UI scaling\": \"Enabled\"

If you use a HiDPI monitor such as Retina display together with another monitor, you can use the
[reszoom](https://chrome.google.com/webstore/detail/resolution-zoom/enjjhajnmggdgofagbokhmifgnaophmh) extension in order
to automatically adjust the zoom level for the active screen.

If using Wayland session, you should [enable](Chromium#Native_Wayland_support "enable"){.wikilink} native wayland
support to avoid blurriness. See also [Chromium#Incorrect HiDPI
rendering](Chromium#Incorrect_HiDPI_rendering "Chromium#Incorrect HiDPI rendering"){.wikilink}.

#### Opera

Opera should use the [#GDK 3 (GTK 3)](#GDK_3_(GTK_3) "#GDK 3 (GTK 3)"){.wikilink} settings.

To override those, use the `{{ic|1=--alt-high-dpi-setting=''X''}}`{=mediawiki} command line option, where X is the
desired DPI. For example, with `{{ic|1=--alt-high-dpi-setting=144}}`{=mediawiki} Opera will assume that DPI is 144.
Newer versions of opera will auto detect the DPI using the font DPI setting (in KDE: the force font DPI setting.)

### Inkscape

To scale the icons to a \"usable\" size go to *Preferences \> Interface* and set the icon size to Large or
Larger[7](https://web.archive.org/web/20171118050743/http://www.inkscapeforum.com/viewtopic.php?t=18684)[8](https://wiki.inkscape.org/wiki/index.php/HiDPI).

### Java applications {#java_applications}

#### AWT/Swing

Java applications using the *AWT/Swing* framework can be scaled by defining the `{{ic|sun.java2d.uiScale}}`{=mediawiki}
VM property when invoking `{{ic|java}}`{=mediawiki}. The value can be an integer percentage value, or a float value. For
example,

`java -Dsun.java2d.uiScale=2 -jar `*`some_swing_application`*`.jar`\
`java -Dsun.java2d.uiScale=300% -jar `*`some_swing_application`*`.jar`

Since Java 9 the `{{ic|GDK_SCALE}}`{=mediawiki} environment variable is used to scale Swing applications accordingly.

Note that at this point, Java *AWT/Swing* (up to including OpenJDK 13) only effectively supports integer values. A
setting of `{{ic|1=-Dsun.java2d.uiScale=250%}}`{=mediawiki} or `{{ic|1=GDK_SCALE=2.5}}`{=mediawiki} will be treated as
if it were set to `{{ic|1=-Dsun.java2d.uiScale=2}}`{=mediawiki} resp. `{{ic|1=GDK_SCALE=2}}`{=mediawiki}.

#### JavaFX

Java applications using *JavaFX* can be scaled by defining the `{{ic|glass.gtk.uiScale}}`{=mediawiki} VM property when
invoking `{{ic|java}}`{=mediawiki}. The value can be an integer percentage value, an integer DPI value (where
`{{ic|96dpi}}`{=mediawiki} represents a scale factor of `{{ic|100%}}`{=mediawiki}, and for example
`{{ic|192dpi}}`{=mediawiki} represents a scale factor of `{{ic|200%}}`{=mediawiki}), or a float value. For example,

`java -Dglass.gtk.uiScale=200% -jar `*`some_jfx_application`*`.jar`\
`java -Dglass.gtk.uiScale=192dpi -jar `*`some_jfx_application`*`.jar`\
`java -Dglass.gtk.uiScale=2.0 -jar `*`some_jfx_application`*`.jar`

*JavaFX* perfectly well supports fractions. Using values like `{{ic|1=-Dglass.gtk.uiScale=250%}}`{=mediawiki} or
`{{ic|1=-Dglass.gtk.uiScale=2.5}}`{=mediawiki} will deliver the expected result.

#### Mixed AWT/Swing and JavaFX {#mixed_awtswing_and_javafx}

Some Java applications mix *JavaFX* and *AWT/Swing* (via `{{ic|javafx.embed.swing.JFXPanel}}`{=mediawiki}). In that
case, the settings for *AWT/Swing* will also affect *JavaFX*, and setting `{{ic|-Dglass.gtk.uiScale}}`{=mediawiki} will
have no effect.

#### JetBrains IDEs {#jetbrains_ides}

On Wayland, HiDPI with fractional scaling is experimentally supported since version 2024.2. The [Wayland support
preview](https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/) can be enabled, by adding
`{{ic|-Dawt.toolkit.name{{=}}`{=mediawiki}WLToolkit}} to the VM options (*Help \> Edit custom VM options*).

JetBrains products (IntelliJ IDEA and other IDEs) support two HiDPI modes (JRE-managed and IDE-managed). The sequence
for determining system scale factor is well documented at
[9](https://intellij-support.jetbrains.com/hc/en-us/articles/360007994999-HiDPI-configuration):

1.  Java property -- `{{ic|-Dsun.java2d.uiScale}}`{=mediawiki}

2.  ```{=mediawiki}
    {{man|1|gsettings}}
    ```
    -- `{{ic|ubuntu.user-interface/scale-factor}}`{=mediawiki} or
    `{{ic|org.gnome.desktop.interface/scaling-factor}}`{=mediawiki}

3.  ```{=mediawiki}
    {{ic|GDK_SCALE}}
    ```
    and `{{ic|GDK_DPI_SCALE}}`{=mediawiki}

4.  [Xresources](Xresources "Xresources"){.wikilink} -- `{{ic|Xft.dpi}}`{=mediawiki}

5.  1.0

For troubleshooting, consult the \"Show HiDPI Info\" dialog via [search everywhere \"Shift
Shift\"](https://www.jetbrains.com/help/idea/searching-everywhere.html).

When using per-monitor scaling, an issue might occur where IntelliJ fails to recognize the real, original monitor
resolution. To remediate this problem some people have success by adding the
`{{ic|1=-Dsun.java2d.uiScale.enabled=true}}`{=mediawiki} option to the `{{ic|''ide_name''.vmoptions}}`{=mediawiki} file
(*Help \> Edit custom VM options*).

If this does not work, the experimental GTK option `{{ic|scale-monitor-framebuffer}}`{=mediawiki} might be enabled on
Wayland ([see above](#Wayland "see above"){.wikilink}) and the Wayland support preview might be disabled ([see
above](#JetBrains_IDEs "see above"){.wikilink}). Currently JetBrains products run on Xwayland and thus [have no full
native Wayland support yet](https://youtrack.jetbrains.com/issue/IDEA-228070). This makes the rendering in JetBrains
products incompatible with the monitor scaling framebuffer. Disabling the framebuffer thus might solve blurry
font/rendering issues for JB products, but alas results in disabled fractional scaling. Another options is to enable the
Wayland support preview.

#### Maple

Maple can be scaled for HiDPI monitors using the AWT/Swing solution. But it has to be added inside your Maple
installation directory to `{{ic|''maple-directory''/bin/maple}}`{=mediawiki} to the `{{ic|JVM_OPTIONS}}`{=mediawiki}:

```{=mediawiki}
{{hc|''maple-directory''/bin/maple|2=
...
JVM_OPTIONS="-Dsun.java2d.uiScale=2 ..."
...
}}
```
Alternatively, the `{{ic|GDK_SCALE}}`{=mediawiki} environment variable can be used to start the application scaled:

`$ GDK_SCALE=2 `*`maple-directory`*`/bin/xmaple %f`

### MATLAB

Recent versions (since R2017b) of [MATLAB](MATLAB "MATLAB"){.wikilink} allow to set the scale
factor[10](https://www.mathworks.com/matlabcentral/answers/406956-does-matlab-support-high-dpi-screens-on-linux):

#### Version R2024b and earlier {#version_r2024b_and_earlier}

To adjust the scale factor, execute the following instructions in a MATLAB command window:

`>> s = settings;`\
`>> s.matlab.desktop.DisplayScaleFactor %Get current value`\
`>> s.matlab.desktop.DisplayScaleFactor.PersonalValue = 2 %Set personal value`

The settings take effect after MATLAB is restarted.

This can become tedious if you need to change the scaling frequently. To simplify this, consider using the following
script:

```{=mediawiki}
{{hc|~/bin/matlab-scale|2=
#!/bin/sh
exec matlab -r "s = settings;s.matlab.desktop.DisplayScaleFactor.PersonalValue=$1;quit" -nodesktop -nosplash
}}
```
To change the display scaling to 3:

`$ matlab-scale 3`

#### Version R2025a and later {#version_r2025a_and_later}

In the latest MATLAB versions, changing the DisplayScaleFactor property often has no effect. However, a newly introduced
parameter enables varying the scale factor in real-time, with no need for restarting MATLAB:

`>> s = settings;`\
`>> s.matlab.desktop.Zoom %Get current value`\
`>> s.matlab.desktop.Zoom.PersonalValue=150 %Set personal value`

### Mono applications {#mono_applications}

According to
[11](https://bugzilla.xamarin.com/35/35870/bug.html)`{{Dead link|2023|04|23|status=domain name not resolved}}`{=mediawiki},
Mono applications should be scalable like [GTK 3](#GDK_3_(GTK_3) "GTK 3"){.wikilink} applications. The precise method
depends on the GUI library: GtkSharp obviouslys points back to Gtk, while the usual Windows Forms (libgdiplus) simply
detects Xft settings.

### NetBeans

NetBeans allows the font size of its interface to be controlled using the `{{ic|1=--fontsize}}`{=mediawiki} parameter
during startup. To make this change permanent edit the `{{ic|1=/usr/share/netbeans/etc/netbeans.conf}}`{=mediawiki} file
and append the `{{ic|1=--fontsize}}`{=mediawiki} parameter to the `{{ic|1=netbeans_default_options}}`{=mediawiki}
property.[12](https://web.archive.org/web/20210117211145/http://wiki.netbeans.org/FaqFontSize)

The editor fontsize can be controlled from *Tools \> Option \> Fonts & Colors*.

The output window fontsize can be controlled from *Tools \> Options \> Miscellaneous \> Output*

### OBS Studio {#obs_studio}

OBS 29 supports HiDPI setups without any extra configuration.

For older versions of OBS, the recommendation was to set the environment variable
`{{ic|1=QT_AUTO_SCREEN_SCALE_FACTOR=0}}`{=mediawiki} to disable [Qt's hi-dpi migration
mode](https://doc.qt.io/qt-5/highdpi.html#migrate-existing-applications) and install the Yami theme. Do not use the Yami
theme with OBS 29 or newer, as it is not necessary anymore and will cause buggy behavior.

### Rofi

Rofi defaults to 96 DPI and relies on its own configuration only

```{=mediawiki}
{{hc|~/.config/rofi/config.rasi|2=
configuration {
    …
    dpi: 150;
    …
}
}}
```
### Spotify

```{=mediawiki}
{{Note|See [[Spotify#HiDPI Mode]] for more details and when using other clients.}}
```
You can change scale factor by simple `{{ic|Ctrl++}}`{=mediawiki} for zoom in, `{{ic|Ctrl+-}}`{=mediawiki} for zoom out
and `{{ic|Ctrl+0}}`{=mediawiki} for default scale. Scaling setting will be saved in
`{{ic|~/.config/spotify/Users/YOUR-SPOTIFY-USER-NAME/prefs}}`{=mediawiki}, you may have to create this file by yourself:

```{=mediawiki}
{{hc|~/.config/spotify/Users/YOUR-SPOTIFY-USER-NAME/prefs|2=
app.browser.zoom-level=100
}}
```
Also Spotify can be launched with a custom scaling factor which will be multiplied with setting specified in
`{{ic|~/.config/spotify/Users/YOUR-SPOTIFY-USER-NAME/prefs}}`{=mediawiki}, for example

`$ spotify --force-device-scale-factor=1.5`

### Steam

#### Official HiDPI support {#official_hidpi_support}

- Starting on 25 of January 2018 in the beta program there is actual support for HiDPI and it should be automatically
  detected.
- *Steam \> Settings \> Interface*, check *Enlarge text and icons based on monitor size* (restart required)
- If it is not automatically detected, use `{{ic|1=GDK_SCALE=2}}`{=mediawiki} to set the desired scale factor.
- If the above fails, use `{{ic|1=steam -forcedesktopscaling 2}}`{=mediawiki} or set
  `{{ic|1=STEAM_FORCE_DESKTOPUI_SCALING=2.0}}`{=mediawiki}.
  [13](https://github.com/ValveSoftware/steam-for-linux/issues/9209#issuecomment-1594505259) As of the June 2023 UI
  overhaul, this parameter also supports non-integer scale factors, such as `{{ic|1.25}}`{=mediawiki}.
- You can also adjust the interface scale in *Steam \> Settings \> Accessibility*, though the slider does not display a
  number value.

#### Unofficial

The [HiDPI-Steam-Skin](https://github.com/MoriTanosuke/HiDPI-Steam-Skin) can be installed to increase the font size of
the interface. While not perfect, it does improve usability.

```{=mediawiki}
{{Note|The README for the HiDPI skin lists several possible locations for where to place the skin. The correct folder out of these can be identified by the presence of a file named {{ic|1=skins_readme.txt}}.}}
```
[MetroSkin Unofficial Patch](https://steamcommunity.com/groups/metroskin/discussions/0/517142253861033946/) also helps
with HiDPI on Steam with Linux.

### Sublime Text 3 {#sublime_text_3}

Sublime Text 3 has full support for display scaling. Go to *Preferences \> Settings \> User Settings* and add
`{{ic|"ui_scale": 2.0}}`{=mediawiki} to your settings.

### Thunderbird

See [#Firefox](#Firefox "#Firefox"){.wikilink}. To access `{{ic|about:config}}`{=mediawiki}, go to *Edit \> Preferences
\> Advanced \>Config editor*.

### VirtualBox

```{=mediawiki}
{{Note|This only applies to KDE with scaling enabled.}}
```
VirtualBox also applies the system-wide scaling to the virtual monitor, which reduces the maximum resolution inside VMs
by your scaling factor (see [14](https://www.virtualbox.org/ticket/16604)).

This can be worked around by calculating the inverse of your scaling factor and manually setting this new scaling factor
for the VirtualBox execution, e.g.

`$ QT_SCALE_FACTOR=0.5 VirtualBoxVM --startvm `*`vm-name`*

### VMware

Text in the VMware application is rendered at an appropriate size following the system configuration, but icons are
small and UI elements have little padding between them.

As described in [#GDK 3 (GTK 3)](#GDK_3_(GTK_3) "#GDK 3 (GTK 3)"){.wikilink}, you can use `{{ic|GDK_SCALE}}`{=mediawiki}
to further scale up the entire UI (including icons & padding) and then use `{{ic|GDK_DPI_SCALE}}`{=mediawiki} to scale
only the text back down to a reasonable size.

For example, to get a final 2x scale factor:

`$ GDK_SCALE=2 GDK_DPI_SCALE=0.5 vmware`

### Wine applications {#wine_applications}

Run

`$ winecfg`

and change the \"dpi\" setting found in the \"Graphics\" tab. This only affects the font size.

### Zathura document viewer {#zathura_document_viewer}

No modifications required for document viewing.

UI text scaling is specified via [configuration file](https://pwmt.org/projects/zathura/documentation/) (note that
\"font\" is a [girara option](https://pwmt.org/projects/girara/options/)):

`set font "monospace normal 20"`

### Zoom

Set the `{{ic|scaleFactor}}`{=mediawiki} variable in `{{ic|~/.config/zoomus.conf}}`{=mediawiki}.

For the Flatpak version, set the environment variable `{{ic|QT_SCALE_FACTOR}}`{=mediawiki} (e.g. to 0.5
[15](https://old.reddit.com/r/Zoom/comments/hat5af/linux_client_ui_elements_too_large_after_update/)). This can be
easily done with [Flatseal](https://flathub.org/apps/details/com.github.tchx84.Flatseal), if using a GUI tool is
preferred.

### Gazebo

Gazebo only renders an upper left of a view instead of the whole view. To fix this a Qt environment variable must be
set.

To run Gazebo:

`$ QT_SCREEN_SCALE_FACTORS=[1.0] gazebo`

To run a ROS simulation:

`$ TURTLEBOT3_MODEL=burger QT_SCREEN_SCALE_FACTORS=[1.0] roslaunch turtlebot3_gazebo turtlebot3_world.launch`

Making an alias such as `{{ic|1=gazebo="QT_SCREEN_SCALE_FACTORS=[1.0] gazebo"}}`{=mediawiki} works for the first case
but not for the second.

### Fcitx

Fcitx preedit `{{ic|FontSize}}`{=mediawiki} can be changed in
`{{ic|~/.config/fcitx/conf/fcitx-classic-ui.config}}`{=mediawiki}.

For Fcitx5, set `{{ic|Font}}`{=mediawiki} with a size inside double quotes in
`{{ic|~/.config/fcitx5/conf/classicui.conf}}`{=mediawiki}.

### Synthesizer V Studio Pro {#synthesizer_v_studio_pro}

Synthesizer V Studio Pro has support for UI scaling. It can setup the scaling automatically, but if it fails the scale
can be adjusted with option \--with-scaling:

`$ synthv-studio --with-scaling 2.0`

### V2RayN, SourceGit and other AvaloniaUi C# / .NET applications {#v2rayn_sourcegit_and_other_avaloniaui_c_.net_applications}

As described in [#AvaloniaUI (C# / .NET)](#AvaloniaUI_(C#_/_.NET) "#AvaloniaUI (C# / .NET)"){.wikilink}, you can use
`{{ic|AVALONIA_GLOBAL_SCALE_FACTOR}}`{=mediawiki}.

### Unsupported applications, via a network layer {#unsupported_applications_via_a_network_layer}

```{=mediawiki}
{{Pkg|xpra}}
```
includes a
[run_scaled](https://github.com/Xpra-org/xpra/blob/4d73c3644d6692bd51376296ed913f18a809f1a9/docs/CHANGELOG.md#41-2021-02-26)
script which can be used to scale applications.

Another approach is to run the application full screen and without decoration in its own VNC desktop. Then scale the
viewer. With `{{AUR|vncdesk-git}}`{=mediawiki} you can set up a desktop per application, then start server and client
with a simple command such as `{{ic|vncdesk 2}}`{=mediawiki}.

[x11vnc](x11vnc "x11vnc"){.wikilink} has an experimental option `{{ic|-appshare}}`{=mediawiki}, which opens one viewer
per application window. Perhaps something could be hacked up with that.

### Unsupported applications, via Weston {#unsupported_applications_via_weston}

There is a no-network, potentially GPU-accelerated solution to scale old/unsupported applications via Weston. The basic
example goes as:

`$ weston --xwayland --socket=testscale --scale=2`\
`$ DISPLAY=:1 WAYLAND_DISPLAY=testscale `*`your_app`*

Note 1: You can make it look nicer. Create a dedicated `{{ic|weston.ini}}`{=mediawiki} and use it with
`{{ic|weston --config}}`{=mediawiki}:

`[core]`\
`idle-time=0`\
`[shell]`\
`panel-position=none`\
`locking=false`

Note 2: Adjust your `{{ic|DISPLAY}}`{=mediawiki} according to your system, `{{ic|:1}}`{=mediawiki} is simply the default
that comes after the main `{{ic|:0}}`{=mediawiki}. Check files created in `{{ic|/tmp/.X11-unix}}`{=mediawiki} to do
that.

Note 3: If you want a separate window per each scaled app, adjust the `{{ic|--socket}}`{=mediawiki} parameter to weston
and `{{ic|WAYLAND_DISPLAY}}`{=mediawiki} + `{{ic|DISPLAY}}`{=mediawiki} for each started app. Scripting that is not easy
because Xorg display has to be a small-ish integer, but you can create a semi-safe script to infer it.

Note 4: It is not fully tested yet whether weston and xwayland truly off-board the heavy parts to the GPU. At least
`{{ic|weston}}`{=mediawiki} advertises to do so, but no tests on that were done yet. Please edit if you make the GPU
usage tests.

## Multiple displays {#multiple_displays}

The HiDPI setting applies to the whole desktop, so non-HiDPI external displays show everything too large. However, note
that setting different scaling factors for different monitors is already supported in
[Wayland](Wayland "Wayland"){.wikilink}.

### Side display {#side_display}

One workaround is to use [xrandr](xrandr "xrandr"){.wikilink}\'s `{{ic|scale}}`{=mediawiki} option. To have a non-HiDPI
monitor (on DP1) right of an internal HiDPI display (eDP1), one could run:

`$ xrandr --output eDP-1 --auto --output DP-1 --auto --scale 2x2 --right-of eDP-1`

When extending above the internal display, you may see part of the internal display on the external monitor. In that
case, specify the position manually.

You may adjust the `{{ic|sharpness}}`{=mediawiki} parameter on your monitor settings to adjust the blur level introduced
with scaling.

```{=mediawiki}
{{Note|1=<nowiki/>
* Above solution with {{ic|--scale 2x2}} does not work on some [[NVIDIA]] cards. No solution is currently available. [https://bbs.archlinux.org/viewtopic.php?pid=1670840] A potential workaround exists with configuring {{ic|1=ForceFullCompositionPipeline=On}} on the {{ic|CurrentMetaMode}} via {{ic|nvidia-settings}}. For more info see [https://askubuntu.com/a/979551].
* If you are using the {{ic|modesetting}} driver you will get mouse flickering. This can be solved by scaling your non-scaled screen by 0.9999x0.9999.
}}
```
### Multiple external monitors {#multiple_external_monitors}

There might be some problems in scaling more than one external monitors which have lower dpi than the built-in HiDPI
display. In that case, you may want to try downscaling the HiDPI display instead, with e.g.

`$ xrandr --output eDP1 --scale 0.5x0.5 --output DP2 --right-of eDP1 --output HDMI1 --right-of DP2`

In addition, when you downscale the HiDPI display, the font on the HiDPI display will be slightly blurry, but it is a
different kind of blurriness compared with the one introduced by upscaling the external displays. You may compare and
see which kind of blurriness is less problematic for you.

### Mirroring

If all you want is to mirror (\"unify\") displays, this is easy as well:

With AxB your native HiDPI resolution (for ex 3200x1800) and CxD your external screen resolution (e.g. 1920x1200)

`$ xrandr --output HDMI --scale [A/C]x[B/D]`

In this example which is QHD (3200/1920 = 1.66 and 1800/1200 = 1.5)

`$ xrandr --output HDMI --scale 1.66x1.5`

For UHD to 1080p (3840/1920=2 2160/1080=2)

`$ xrandr --output HDMI --scale 2x2`

You may adjust the `{{ic|sharpness}}`{=mediawiki} parameter on your monitor settings to adjust the blur level introduced
with scaling.

### Tools

There are several tools which automate the commands described above.

- [This script](https://gist.github.com/wvengen/178642bbc8236c1bdb67) extend a non-HiDPI external display above a HiDPI
  internal display.

- [xrandr-extend](https://github.com/ashwinvis/xrandr-extend).

- ```{=mediawiki}
  {{AUR|xlayoutdisplay}}
  ```
  is a CLI front end for xrandr which detects and sets correct DPI:
  [README](https://github.com/alex-courtis/xlayoutdisplay)

## Linux console (tty) {#linux_console_tty}

### In-kernel fonts {#in_kernel_fonts}

The [Linux console](Linux_console "Linux console"){.wikilink} changes the font to `{{ic|TER16x32}}`{=mediawiki} (based
on `{{ic|ter-i32b}}`{=mediawiki} from
`{{Pkg|terminus-font}}`{=mediawiki}[16](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ac8b6f148fc97e9e10b48bd337ef571b1d1136aa))
based on the vertical and horizontal pixel count of the
display[17](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=dfd19a5004eff03755967086aa04254c3d91b8ec)
regardless of its physical size. If your monitor is not recognised as HiDPI, the default font can be changed. In that
case, specify `{{ic|1=fbcon=font:TER16x32}}`{=mediawiki} in the [kernel command
line](kernel_command_line "kernel command line"){.wikilink}.

### Fonts outside the kernel (tty) {#fonts_outside_the_kernel_tty}

The largest fonts present in the `{{Pkg|kbd}}`{=mediawiki} package are `{{ic|latarcyrheb-sun32}}`{=mediawiki} and
`{{ic|solar24x32}}`{=mediawiki}. Other packages like `{{Pkg|terminus-font}}`{=mediawiki} contain further alternatives,
such as `{{ic|ter-132n}}`{=mediawiki} (normal) and `{{ic|ter-132b}}`{=mediawiki} (bold). See [Linux
console#Fonts](Linux_console#Fonts "Linux console#Fonts"){.wikilink} for configuration details and [Linux
console#Persistent
configuration](Linux_console#Persistent_configuration "Linux console#Persistent configuration"){.wikilink} in particular
for applying the font setting during the early userspace boot sequence.

After changing the font, it is often garbled and unreadable when changing to other virtual consoles
(`{{ic|tty2}}`{=mediawiki}--`{{ic|6}}`{=mediawiki}). To fix this you can [force specific
mode](Kernel_mode_setting#Forcing_modes_and_EDID "force specific mode"){.wikilink} for KMS, such as
`{{ic|1=video=2560x1600@60}}`{=mediawiki} (substitute in the native resolution of your HiDPI display), and reboot. Using
small resolutions will make the text look bigger, but also pixelated.

Users booting through [UEFI](UEFI "UEFI"){.wikilink} may experience the console and [boot
loader](boot_loader "boot loader"){.wikilink} being constrained to a low resolution despite correct
[KMS](KMS "KMS"){.wikilink} settings being set. This can be caused by legacy/BIOS boot being enabled in UEFI settings.
Disabling legacy boot to bypass the compatibility layer should allow the system to boot at the correct resolution.

### Modern HiDPI support (kmscon) {#modern_hidpi_support_kmscon}

For real HiDPI support, see [KMSCON](KMSCON "KMSCON"){.wikilink} instead of changing the font size in the tty.

## See also {#see_also}

- [Ultra HD 4K Linux Graphics Card Testing](https://www.phoronix.com/scan.php?page=article&item=linux_uhd4k_gpus) (Nov
  2013)
- [Understanding pixel density](https://www.eizo.com/library/basics/pixel_density_4k/)
- [Mixed DPI and the X Window System](https://wok.oblomov.eu/tecnologia/mixed-dpi-x11/)

[Category:Graphics](Category:Graphics "Category:Graphics"){.wikilink}

[ja:VOGL](ja:VOGL "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|Step-by-step debugging guide}}`{=mediawiki} `{{Related|Debugging/Getting traces}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

[VOGL](https://github.com/ValveSoftware/vogl) is a tool created by Valve Software and RAD Game Tools for OpenGL
debugging. It is able to capture, replay and inspect OpenGL call tracefiles.

## Installation

The development version is available as `{{AUR|vogl-git}}`{=mediawiki}.

## Capturing a tracefile {#capturing_a_tracefile}

To obtain a tracefile, run the following command.

`$ VOGL_CMD_LINE="--vogl_debug --vogl_dump_stats --vogl_tracefile /tmp/vogltrace.bin" LD_PRELOAD=/usr/lib/libvogltrace64.so `*`command`*

Where `{{ic|''command''}}`{=mediawiki} is the command to launch your OpenGL application. Your tracefile will be created
in your `{{ic|/tmp}}`{=mediawiki} directory.

```{=mediawiki}
{{Warning|These files get big '''very fast'''. 1–2 minutes result in about 1GB of captured calls.}}
```
VOGL ships with various OpenGL samples that can be used for testing in its sources. These are not part of the package
but they can be built manually. You can also grab the latest OpenGL samples from the [OpenGL Samples
Pack](http://ogl-samples.g-truc.net/) or from [OpenGL SuperBible](https://www.openglsuperbible.com/).

## Trimming the tracefile {#trimming_the_tracefile}

If you want to create a smaller tracefile from your captured trace containing X amount of frames starting at frame Y,
use

`$ voglreplay64 original_trace.bin --trim_file trimmed_trace.bin --trim_len X --trim_frame Y`

## Replaying the tracefile {#replaying_the_tracefile}

To replay your trace, launch the voglreplayer from within your vogl directory:

`$ voglreplay64 /tmp/vogltrace.bin`

To get verbose debugging output for your trace:

`$ voglreplay64 --debug --verbose vogltrace.bin`

To get GL call and extension statistics:

`$ voglreplay64 --info vogltrace.bin`

## Inspecting the tracefile {#inspecting_the_tracefile}

Launch the vogleditor binary and open the `{{ic|tracefile.bin}}`{=mediawiki} with the *File - Open Trace* menu.

`$ vogleditor64`

## Limitations

See <https://richg42.blogspot.it/2014/03/current-vogl-limitations.html>.

[Category:Development](Category:Development "wikilink") [Category:Graphics](Category:Graphics "wikilink")

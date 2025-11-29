[GStreamer](https://gstreamer.freedesktop.org/) is a popular multimedia framework to handle a variety of video and audio
formats on different platforms in a uniform way through a powerful and convenient API in order to build multimedia apps,
video/audio editors and streaming services. It consists of a huge amount low-level plugins like \"videotestsrc\",
\"videoconvert\" and \"autovideosink\" as well as a few higher level test-and-combine framework tools like
\"gst-inspect\", \"gst-launch\" etc.

## Installing via nixpkgs {#installing_via_nixpkgs}

In Nix as in other Linux distributions those tools and plugins are split into separate packages, which you can bring
together with a custom Nix shell environment:

```{=mediawiki}
{{File|3={
  description = "A GStreamer development flake";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
          gst_all_1.gstreamer
          # Common plugins like "filesrc" to combine within e.g. gst-launch
          gst_all_1.gst-plugins-base
          # Specialized plugins separated by quality
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          # Plugins to reuse ffmpeg to play almost every video format
          gst_all_1.gst-libav
          # Support the Video Audio (Hardware) Acceleration API
          gst_all_1.gst-vaapi
          #...
        ];
      };
    };
}|name=/etc/nixos/flake.nix|lang=nix}}
```
To activate this environment in your terminal run

``` nix
$ nix develop 
```

You can find all available Nix package names through the \[<https://search.nixos.org/packages?query=gst_all_1>. Nix
search page\].

## Test the installation {#test_the_installation}

You can test that the `gst_all_1.gstreamer` tools are available by running a dummy pipeline

``` nix
$ gst-launch-1.0 videotestsrc ! videoconvert ! autovideosink
```

which should open a colored video window.

You can test that the plugins like from `gst_all_1.gst-plugins-base` are available to the higher level tools by
inspecting such a base plugin like `filesrc` with

``` nix
$ gst-inspect-1.0 filesrc
Factory Details:
  ...
  Long-name                File Source
  Description              Read from arbitrary point in a file
  ...
Plugin Details:
  Name                     coreelements
  Description              GStreamer core elements
  Filename                 /nix/store/p39g1.../libgstcoreelements.so
  ...
```

or by using it in a pipeline. Here, we could play a video from the local machine with

``` nix
$ gst-launch-1.0 filesrc location=my_video.mp4 ! videoconvert ! autovideosink
```

If the plugins are not correctly made available to the higher level tools, you\'ll get an error

``` nix
$ gst-inspect-1.0 filesrc
No such element or plugin 'filesrc'
```

## Troubleshooting

#### erroneous pipeline: no element \"filesrc\" {#erroneous_pipeline_no_element_filesrc}

In some cases while creating a shell using \"mkShell\" or \"writeShellApplication\" just setting the \"runtimeInputs\"
is not enough. It\'s necessary to manually set the \"GST_PLUGIN_SYSTEM_PATH_1_0\" environment variable.[^1]

Adding the following export to your script, sets \"gstreamer\" and \"gst-plugins-base\" and \"gst-plugins-good\" paths.
Similarly you can add any other \"gst-plugins\" package as well.

``` shell
export GST_PLUGIN_SYSTEM_PATH_1_0="${gst_all_1.gstreamer.out}/lib/gstreamer-1.0:${gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${gst_all_1.gst-plugins-good}/lib/gstreamer-1.0"
```

Note: \"gstreamer.out\" is the derivative that contains \"/lib\" directory for that package.

<references />

#### nautilus: \"Your GStreamer installation is missing a plug-in.\" {#nautilus_your_gstreamer_installation_is_missing_a_plug_in.}

![nautilus: \"Your GStreamer installation is missing a
plug-in.\"](Screenshot_From_2025-03-28_09-58-50.png "nautilus: "Your GStreamer installation is missing a plug-in."") To
fix the issue I found the following solutions:

- Using `nix-shell`:

nix-shell -p gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
gst_all_1.gst-plugins-ugly gst_all_1.gst-libav gst_all_1.gst-vaapi \--run \"nautilus\"

</syntaxhighlight>

- Using the environment variable \"`GST_PLUGIN_PATH`\":![\"Audio and Video Properties\" of \"Properties\" window of
  nautilus after
  fix](Screenshot_From_2025-03-28_12-51-31.png ""Audio and Video Properties" of "Properties" window of nautilus after fix")`{{File|3={ config, pkgs, ... }:

  {
    environment.systemPackages = with pkgs; [
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
    ];

    environment.variables = {
      GST_PLUGIN_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
    };
  }|name=/etc/nixos/configuration.nix|lang=nix}}`{=mediawiki} `{{Evaluate|boot}}`{=mediawiki}

[Category:Video](Category:Video "Category:Video"){.wikilink}
[Category:Audio](Category:Audio "Category:Audio"){.wikilink}

[^1]: <https://discourse.nixos.org/t/how-to-use-gst-plugins/6345>

[zh-hans:Ollama](zh-hans:Ollama "wikilink") [Ollama](https://ollama.com) is an application which lets you run offline
large language models locally.

## Installation

-   [Install](Install "wikilink") `{{Pkg|ollama}}`{=mediawiki} to run models on CPU
-   To run models on GPU:
    -   [Install](Install "wikilink") `{{Pkg|ollama-cuda}}`{=mediawiki} for [NVIDIA](NVIDIA "wikilink")
    -   [Install](Install "wikilink") `{{Pkg|ollama-rocm}}`{=mediawiki} for [AMD](AMD "wikilink").

Next, [enable/start](enable/start "wikilink") `{{ic|ollama.service}}`{=mediawiki}. Then, verify Ollama\'s status:

`$ ollama --version`

If it says `{{ic|Warning: could not connect to a running Ollama instance}}`{=mediawiki}, then the Ollama service has not
been run; otherwise, the Ollama service is running and is ready to accept user requests.

Next, verify that you can run models. The following command downloads the latest [270M parameter model of Gemma
3](https://ollama.com/library/gemma3:270m) and returns an Ollama prompt that allows you to talk to the model:

```{=mediawiki}
{{hc|$ ollama run gemma3:270m|
>>> Send a message (/? for help)
}}
```
## Usage

The Ollama executable does not provide a search interface. There is no such command as
`{{ic|ollama search}}`{=mediawiki}. To search for a model, you need to visit their [search
page](https://ollama.com/search).

To run a model:

`$ ollama run `*`model`*

To stop a model:

`$ ollama stop `*`model`*

To update a model:

`$ ollama pull `*`model`*

To remove a model:

`$ ollama rm `*`model`*

To view locally available models:

`$ ollama list`

## Troubleshooting

### ROCm is not utilizing my AMD integrated GPU {#rocm_is_not_utilizing_my_amd_integrated_gpu}

You may have used utilities like `{{Pkg|amdgpu_top}}`{=mediawiki} to monitor the utilization of your integrated GPU
during an Ollama session, but only to notice that your integrated GPU has not been used at all.

That is expected: without configuration, [ROCm](ROCm "wikilink") simply ignores your integrated GPU, causing everything
to be computed on CPU.

The required configuration is, however, very simple because all you need is to create a [drop-in
file](drop-in_file "wikilink") for `{{ic|ollama.service}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/systemd/system/ollama.service.d/override_gfx_version.conf|2=
[Service]
Environment="HSA_OVERRIDE_GFX_VERSION=X.Y.Z"
}}
```
Where `{{ic|X.Y.Z}}`{=mediawiki} is dependent to the GFX version that is shipped with your system.

To determine which GFX version to use, first make sure `{{Pkg|rocminfo}}`{=mediawiki} has already been installed. It
should be pulled in to your system as a dependency of `{{Pkg|rocblas}}`{=mediawiki}, which is itself a dependency of
`{{Pkg|ollama-rocm}}`{=mediawiki}.

Next, query the actual GFX version of your system:

`$ /opt/rocm/bin/rocminfo | grep amdhsa`

You need to remember the digits printed after the word `{{ic|gfx}}`{=mediawiki}, because this is the actual GFX version
of your system. The digits are interpreted as follows:

-   If the digits are 4-digit, they are interpreted as `{{ic|XX.Y.Z}}`{=mediawiki}, where the first two digits are
    interpreted as the `{{ic|X}}`{=mediawiki} part.
-   If the digits are 3-digit, they are interpreted as `{{ic|X.Y.Z}}`{=mediawiki}.

Then, find all installed `{{Pkg|rocblas}}`{=mediawiki} kernels:

`$ find /opt/rocm/lib/rocblas/library -name 'Kernels.so-*'`

You need to set `{{ic|X.Y.Z}}`{=mediawiki} to one of the available versions listed there. The rules are summarized as
follows:

1.  For the `{{ic|X}}`{=mediawiki} part, it must be strictly equal to the actual version.
2.  For the `{{ic|Y}}`{=mediawiki} part, mismatch is allowed, but it must be no greater than the actual version.
3.  For the `{{ic|Z}}`{=mediawiki} part, mismatch is allowed, but it must be no greater than the actual version.

After setting the correct `{{ic|X.Y.Z}}`{=mediawiki}, perform a [daemon-reload](daemon-reload "wikilink") and
[restart](restart "wikilink") `{{ic|ollama.service}}`{=mediawiki}.

Then, run your model as usual. You may wish to monitor GPU utilization with `{{Pkg|amdgpu_top}}`{=mediawiki} again.

### Models are not removed after uninstalling Ollama {#models_are_not_removed_after_uninstalling_ollama}

You can easily remove the model files manually. They are stored in `{{ic|/var/lib/ollama/blobs}}`{=mediawiki}.

## See also {#see_also}

-   [Ollama Blog](https://ollama.com/blog)
-   [Ollama Docs](https://github.com/ollama/ollama/tree/main/docs)
-   [What is rocBLAS](https://rocm.docs.amd.com/projects/rocBLAS/en/latest/how-to/what-is-rocblas.html)

[Category:Development](Category:Development "wikilink") [Category:Graphics](Category:Graphics "wikilink")

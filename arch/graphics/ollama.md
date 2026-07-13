[zh-hans:Ollama](zh-hans:Ollama "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|General-purpose computing on graphics processing units}}`{=mediawiki} `{{Related|llama.cpp}}`{=mediawiki}
`{{Related|Vulkan}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

[Ollama](https://ollama.com) is an application which lets you run offline large language models locally.

## Installation

[Install](Install "wikilink") the `{{Pkg|ollama}}`{=mediawiki} package, which provides a daemon, command line tool, and
CPU inference.

For GPU inference:

-   Install `{{Pkg|ollama-vulkan}}`{=mediawiki} for inference with [Vulkan](Vulkan "wikilink").
-   Install `{{Pkg|ollama-cuda}}`{=mediawiki} for inference with [CUDA](CUDA "wikilink").
-   Install `{{Pkg|ollama-rocm}}`{=mediawiki} for inference with [ROCm](ROCm "wikilink").

```{=mediawiki}
{{Tip|On AMD GPUs from RDNA 3 onward, {{Pkg|ollama-vulkan}} is usually faster and uses less power than {{Pkg|ollama-rocm}} and avoids ROCm's unsupported-GPU issues (see [[#ROCm is not utilizing my AMD GPU]]). Integrated GPUs are skipped automatically; set {{ic|1=OLLAMA_IGPU_ENABLE=1}} to allow them.}}
```
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

## Configuration

Ollama is configured through environment variables. Set them for the service in a [drop-in
file](drop-in_file "wikilink"), then [restart](restart "wikilink") `{{ic|ollama.service}}`{=mediawiki}:

```{=mediawiki}
{{hc|/etc/systemd/system/ollama.service.d/environment.conf|2=
[Service]
Environment="VARIABLE=value"
}}
```
Commonly tuned variables:

-   ```{=mediawiki}
    {{ic|1=OLLAMA_FLASH_ATTENTION=1}}
    ```
    \- faster prompt processing and smaller KV cache; prerequisite for KV-cache quantization.

-   ```{=mediawiki}
    {{ic|OLLAMA_KV_CACHE_TYPE}}
    ```
    \- KV-cache quantization: `{{ic|f16}}`{=mediawiki} (default), `{{ic|q8_0}}`{=mediawiki} (half the VRAM of f16,
    negligible quality loss) or `{{ic|q4_0}}`{=mediawiki}. Requires flash attention.

-   ```{=mediawiki}
    {{ic|OLLAMA_CONTEXT_LENGTH}}
    ```
    \- default context length per request, e.g. `{{ic|8192}}`{=mediawiki}; unset, it scales with available VRAM
    (4k/32k/256k). Models can override it (see below).

-   ```{=mediawiki}
    {{ic|OLLAMA_NUM_PARALLEL}}
    ```
    \- concurrent requests per model; each slot multiplies the KV-cache allocation.

-   ```{=mediawiki}
    {{ic|OLLAMA_MAX_LOADED_MODELS}}
    ```
    \- number of models kept loaded per GPU.

-   ```{=mediawiki}
    {{ic|OLLAMA_KEEP_ALIVE}}
    ```
    \- how long a model stays in memory after the last request (default `{{ic|5m}}`{=mediawiki}; `{{ic|0}}`{=mediawiki}
    unloads immediately, `{{ic|-1}}`{=mediawiki} keeps it loaded forever).

-   ```{=mediawiki}
    {{ic|1=GGML_VK_VISIBLE_DEVICES=0}}
    ```
    \- on systems with multiple GPUs (e.g. discrete + integrated), pin inference to one Vulkan device (0 = first in the
    startup log).

-   ```{=mediawiki}
    {{ic|1=OLLAMA_HOST=0.0.0.0:11434}}
    ```
    \- listen on all interfaces instead of loopback only; required for containers (e.g. podman/Docker reaching the host
    via `{{ic|host.containers.internal}}`{=mediawiki}) and other LAN hosts.

See `{{ic|ollama serve --help}}`{=mediawiki} and the [upstream FAQ](https://docs.ollama.com/faq) for the remaining
variables.

Vulkan support is enabled by default when `{{Pkg|ollama-vulkan}}`{=mediawiki} is installed;
`{{ic|1=OLLAMA_VULKAN=1}}`{=mediawiki} is not required.

```{=mediawiki}
{{Warning|The Ollama API has no authentication. With {{ic|1=OLLAMA_HOST=0.0.0.0}} anyone on the network can use the models - restrict access with a [[firewall]] if the network is not trusted.}}
```
### Per-model parameters {#per_model_parameters}

To run a model with custom settings, bake them into a new model with a Modelfile:

```{=mediawiki}
{{hc|Modelfile|2=
FROM gemma4:26b
PARAMETER num_gpu 29
PARAMETER num_ctx 32768
}}
```
`$ ollama create gemma4-tuned -f Modelfile`

-   ```{=mediawiki}
    {{ic|FROM}}
    ```
    \- an already pulled model, as listed by `{{ic|ollama list}}`{=mediawiki}.

-   ```{=mediawiki}
    {{ic|num_gpu}}
    ```
    \- number of model layers offloaded to the GPU. Speed rises with each extra layer until VRAM fills. One layer too
    many spills into GTT (system RAM over PCIe) and speed collapses, even though the model still reports \"100% GPU\".
    Benchmark a few values - the optimum is the most layers that fit just under *free* VRAM. For example, on a 16 GiB RX
    9070 XT running `{{ic|gemma4:26b}}`{=mediawiki} (Q4_K_M) at 32k context, 29 of 31 layers hit \~88 tok/s with most of
    the VRAM available; 30 layers dropped to \~75 tok/s (spill) and the auto-offload default gave \~37. With a browser
    holding \~5 GiB of VRAM the optimum fell to \~24 layers. On an 8 GiB GPU only \~13 layers of this model fit and
    generation is mostly CPU-bound - there, prefer a model that fits in VRAM entirely (a 7-9B model at Q4_K_M takes
    \~4-5 GiB) at 8-16k context.

-   ```{=mediawiki}
    {{ic|num_ctx}}
    ```
    \- context length: the maximum number of tokens the model sees at once (prompt + response). The KV cache shares VRAM
    with the layers: the larger the context, the fewer layers fit - retune `{{ic|num_gpu}}`{=mediawiki} after changing
    it.

```{=mediawiki}
{{ic|ollama create}}
```
does not copy weights - the store is content-addressed, so a tuned variant only adds a small manifest. The same
parameters can also be passed per request in the API `{{ic|options}}`{=mediawiki} field, which overrides Modelfile
values.

Ollama does not keep the source Modelfile; the parameters are stored as layers in the model store
(`{{ic|/var/lib/ollama}}`{=mediawiki}, manifest under
`{{ic|manifests/registry.ollama.ai/library/''name''/''tag''}}`{=mediawiki}). To change a created model, reconstruct its
Modelfile, edit it and run `{{ic|ollama create}}`{=mediawiki} again with the same name (only the small manifest is
rewritten):

`$ ollama show --modelfile gemma4-tuned > Modelfile`\
`$ ollama create gemma4-tuned -f Modelfile`

See the [Modelfile reference](https://docs.ollama.com/modelfile) for the remaining instructions and parameters.

## Troubleshooting

### ROCm is not utilizing my AMD GPU {#rocm_is_not_utilizing_my_amd_gpu}

You may have used utilities like `{{Pkg|amdgpu_top}}`{=mediawiki} to monitor the utilization of your GPU during an
Ollama session, but only to notice that your GPU has not been used at all.

Without configuration, [ROCm](ROCm "wikilink") simply ignores unsupported GPUs, causing everything to be computed on
CPU.

```{=mediawiki}
{{Note|Verify supported GPUs by consulting [https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html ROCm System Requirements].}}
```
To work this around, create a [drop-in file](drop-in_file "wikilink") for `{{ic|ollama.service}}`{=mediawiki}:

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

You can manually remove the model files. They are stored in `{{ic|/var/lib/ollama/blobs}}`{=mediawiki}.

## See also {#see_also}

-   [Ollama Blog](https://ollama.com/blog)
-   [Ollama Docs](https://docs.ollama.com)

[Category:Development](Category:Development "wikilink") [Category:Graphics](Category:Graphics "wikilink")

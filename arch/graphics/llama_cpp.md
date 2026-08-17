`{{Related articles start}}`{=mediawiki} `{{Related|Vulkan}}`{=mediawiki}
`{{Related|General-purpose computing on graphics processing units}}`{=mediawiki} `{{Related|Ollama}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

[Large language model](Wikipedia:Large_language_model "wikilink") (LLM) inference in C/C++.

## Installation

```{=mediawiki}
{{Expansion|If the user should install multiple backends, how are they to determine which one to use?}}
```
[Install](Install "wikilink") `{{Pkg|llama-cpp}}`{=mediawiki} and `{{Pkg|ggml-cpu}}`{=mediawiki}, plus one of the
following backends:

```{=mediawiki}
{{Warning|{{Pkg|ggml-cpu}} is required regardless whether you use GPU or not, otherwise you get {{ic|no CPU backend found}}.}}
```
-   ```{=mediawiki}
    {{Pkg|ggml-vulkan}}
    ```
    for inference with [Vulkan](Vulkan "wikilink").

-   ```{=mediawiki}
    {{Pkg|ggml-cuda}}
    ```
    for inference with [CUDA](CUDA "wikilink").

-   ```{=mediawiki}
    {{Pkg|ggml-hip}}
    ```
    for inference with [ROCm](ROCm "wikilink").

-   ```{=mediawiki}
    {{Pkg|ggml-sycl}}
    ```
    for inference with [SYCL](SYCL "wikilink").

-   ```{=mediawiki}
    {{Pkg|ggml-blas}}
    ```
    for inference with [OpenBLAS](Wikipedia:OpenBLAS "wikilink").

-   ```{=mediawiki}
    {{Pkg|ggml-openvino}}
    ```
    for inference with [OpenVINO](Wikipedia:OpenVINO "wikilink").

```{=mediawiki}
{{Note|For inference with [[Vulkan]], ensure you also have the appropriate Vulkan driver installed.}}
```
## Usage

Primary executables are `{{ic|llama-cli}}`{=mediawiki} and `{{ic|llama-server}}`{=mediawiki}.

### llama-cli {#llama_cli}

```{=mediawiki}
{{ic|llama-cli}}
```
returns an interactive prompt in command-line:

`$ llama-cli -m `*`model.gguf`*

### llama-server {#llama_server}

```{=mediawiki}
{{ic|llama-server}}
```
launches an API server with a built-in WebUI:

`$ llama-server --host `*`address`*` --port `*`port`*` -m `*`model.gguf`*

## Obtaining models {#obtaining_models}

llama.cpp uses models in the GGUF format.

### Download from Hugging Face {#download_from_hugging_face}

Download models from [Hugging Face](https://huggingface.co) using the `{{ic|-hf}}`{=mediawiki} flag:

`$ llama-cli -hf `*`org/model`*

```{=mediawiki}
{{Warning|This may overwrite an existing model file without prompting.}}
```
### Manual download {#manual_download}

Models can be downloaded manually using a full URL and a downloader such as `{{Pkg|wget}}`{=mediawiki} or
`{{Pkg|curl}}`{=mediawiki}.

## Tips and tricks {#tips_and_tricks}

### Model quantization {#model_quantization}

Quantization lowers model precision to reduce memory usage.

GGUF models use suffixes to indicate quantization level. Generally, lower numbers (e.g. **Q4**) use less memory but may
reduce quality compared to higher numbers (e.g. **Q8**).

### Knowledge distillation {#knowledge_distillation}

Knowledge distillation compresses a larger model into a smaller model by training the smaller model to follow the
behaviors of the larger model.

Typically, GGUF models indicate knowledge distillation using the `{{ic|student-teacher-distill}}`{=mediawiki}
denotation, where:

-   ```{=mediawiki}
    {{ic|student}}
    ```
    represents the smaller model.

-   ```{=mediawiki}
    {{ic|teacher}}
    ```
    represents the larger model.

### Specifying context size {#specifying_context_size}

llama.cpp loads the context size from the model by default, and it allocates memory for the whole context window.

Specify a lower context size in case you run out of memory.

`$ llama-cli -c `*`32000`*` -m `*`model.gguf`*

### Key-value cache quantization {#key_value_cache_quantization}

For further memory efficiency, you can quantize the key-value cache.

`$ llama-cli -ctk `*`q8_0`*` -ctv `*`q8_0`*` -m `*`model.gguf`*

This, combined with a lower context size, can significantly reduce memory usage.

```{=mediawiki}
{{Note|
* Aggressive quantization on '''keys''' reduces quality noticeably.
* Aggressive quantization on '''values''' is usually better tolerated, but still risks degradation.
}}
```
### Agent system {#agent_system}

While the API server runs a WebUI, the same endpoint also operates as an OpenAI-compatible server. It can be paired with
a coding agent like `{{Pkg|opencode}}`{=mediawiki}.

Alternatively, the WebUI has introduced built-in agent capabilities.

#### Built-in tools {#built_in_tools}

To enable built-in tools for filesystem operations and shell access, start llama-server with:

`$ llama-server --tools all -m `*`model.gguf`*

This, combined with a reasonably strong reasoning model, can be considered as a minimal coding agent running in web
browser.

```{=mediawiki}
{{Warning|
Be very aware, that all interactions are submitted to the operating system on the behalf of whoever is running the API server. '''At no time''' should the API server be exposed to the network and/or running as root with built-in tools enabled!
}}
```
#### Model Context Protocol servers {#model_context_protocol_servers}

Other tools (e.g. web_search, fetch) can be integrated to the WebUI, given that the tools are served as MCP endpoints.

### Monitoring GPU utilization {#monitoring_gpu_utilization}

See [Graphics processing unit#Monitoring](Graphics_processing_unit#Monitoring "wikilink").

## Troubleshooting

### MCP requests denied by CORS policy {#mcp_requests_denied_by_cors_policy}

To use the WebUI with an MCP endpoint hosted online, enable MCP CORS proxy:

`$ llama-server --ui-mcp-proxy -m `*`model.gguf`*

## See also {#see_also}

-   [Upstream GitHub repository](https://github.com/ggml-org/llama.cpp)
-   [Upstream guide: using the new WebUI of llama.cpp](https://github.com/ggml-org/llama.cpp/discussions/16938)
-   [Upstream guide: running gpt-oss with llama.cpp](https://github.com/ggml-org/llama.cpp/discussions/15396)

[Category:Development](Category:Development "wikilink") [Category:Graphics](Category:Graphics "wikilink")

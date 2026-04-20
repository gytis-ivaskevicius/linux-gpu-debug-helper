```{=mediawiki}
{{Related articles start}}
```
```{=mediawiki}
{{Related|Vulkan}}
```
```{=mediawiki}
{{Related|General-purpose computing on graphics processing units}}
```
```{=mediawiki}
{{Related|Ollama}}
```
```{=mediawiki}
{{Related articles end}}
```
LLM inference in C/C++.

## Installation

llama.cpp is available in the [AUR](AUR "wikilink"):

-   [Install](Install "wikilink") `{{AUR|llama.cpp}}`{=mediawiki} for CPU inference.
-   [Install](Install "wikilink") `{{AUR|llama.cpp-vulkan}}`{=mediawiki} for GPU Vulkan inference.
-   [Install](Install "wikilink") `{{AUR|llama.cpp-cuda}}`{=mediawiki} for GPU CUDA inference.
-   [Install](Install "wikilink") `{{AUR|llama.cpp-hip}}`{=mediawiki} for GPU HIP inference.

```{=mediawiki}
{{Note|Ensure you have the appropriate [[Vulkan]] driver installed.}}
```
## Usage

Primary executors are `{{ic|llama-cli}}`{=mediawiki} and `{{ic|llama-server}}`{=mediawiki}.

### llama-cli {#llama_cli}

```{=mediawiki}
{{ic|llama-cli}}
```
is the command-line executor:

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

Manually download models using `{{Pkg|wget}}`{=mediawiki} or `{{Pkg|curl}}`{=mediawiki}:

`$ wget -c `*`model.gguf`*

## Tips and tricks {#tips_and_tricks}

### Model quantization {#model_quantization}

Quantization lowers model precision to reduce memory usage.

GGUF models use suffixes to indicate quantization level. Generally, lower numbers (e.g. **Q4**) use less memory but may
reduce quality compared to higher numbers (e.g. **Q8**).

### Knowledge distillation {#knowledge_distillation}

Knowledge distillation compresses a larger model into a smaller model by training the smaller model to follow the
behaviors of the larger model.

GGUF models indicate knowledge distillation using the `{{ic|student-teacher-distill}}`{=mediawiki} denotation, where:

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
### Monitoring GPU utilization {#monitoring_gpu_utilization}

See [Graphics processing unit#Monitoring](Graphics_processing_unit#Monitoring "wikilink").

## Troubleshooting

### MCP requests denied by CORS policy {#mcp_requests_denied_by_cors_policy}

To use the WebUI with an MCP service hosted online, enable MCP CORS proxy:

`$ llama-server `*`--webui-mcp-proxy`*` -m `*`model.gguf`*

## See also {#see_also}

-   [Upstream GitHub repository](https://github.com/ggml-org/llama.cpp)
-   [Upstream guide: using the new WebUI of llama.cpp](https://github.com/ggml-org/llama.cpp/discussions/16938)
-   [Upstream guide: running gpt-oss with llama.cpp](https://github.com/ggml-org/llama.cpp/discussions/15396)

[Category:Development](Category:Development "wikilink") [Category:Graphics](Category:Graphics "wikilink")

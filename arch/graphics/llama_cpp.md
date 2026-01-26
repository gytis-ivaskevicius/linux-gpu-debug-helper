`{{Related articles start}}`{=mediawiki} `{{Related|Vulkan}}`{=mediawiki}
`{{Related|General-purpose computing on graphics processing units}}`{=mediawiki} `{{Related|Ollama}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

LLM inference in C/C++.

## Installation

llama.cpp is available in the [AUR](AUR "wikilink"):

-   Install `{{AUR|llama.cpp}}`{=mediawiki} for CPU inference.
-   Install `{{AUR|llama.cpp-vulkan}}`{=mediawiki} for GPU inference.

```{=mediawiki}
{{Note|Ensure you have the appropriate [[Vulkan]] driver installed.}}
```
## Usage

Primary executors are `{{ic|llama-cli}}`{=mediawiki} and `{{ic|llama-server}}`{=mediawiki}.

### llama-cli {#llama_cli}

```{=mediawiki}
{{ic|llama-cli}}
```
is the CLI executor:

`$ llama-cli --help`\
`$ llama-cli -m `*`model.gguf`*

### llama-server {#llama_server}

```{=mediawiki}
{{ic|llama-server}}
```
launches an HTTP server:

`$ llama-server --help`\
`$ llama-server -m `*`model.gguf`*

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

## Model quantization {#model_quantization}

Quantization lowers model precision to reduce memory usage.

GGUF models use suffixes to indicate quantization level. Generally, lower numbers (**Q4**) use less memory but may
reduce quality compared to higher numbers (**Q8**).

[Unsloth](https://huggingface.co/unsloth) provides a wide selection of quantized models on Hugging Face.

## Key-value cache quantization {#key_value_cache_quantization}

For further memory efficiency, you can quantize the key-value cache.

`$ llama-cli -ctk `*`q4_0`*` -ctv `*`q4_0`*` -m `*`model.gguf`*

This can significantly reduce memory usage.

## See also {#see_also}

-   [Upstream GitHub repository](https://github.com/ggml-org/llama.cpp)
-   [Upstream community discussions](https://github.com/ggml-org/llama.cpp/discussions)
-   [Unsloth documentation](https://docs.unsloth.ai)

[Category:Development](Category:Development "wikilink") [Category:Graphics](Category:Graphics "wikilink")

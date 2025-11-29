[Katago](https://github.com/lightvector/katago) is a very strong go engine. It has no GUI and has to be used with
[KaTrain](https://github.com/sanderland/katrain), [Lizzie](https://github.com/featurecat/lizzie),
[Ogatak](https://github.com/rooklift/ogatak), [q5Go](https://github.com/bernds/q5Go) or other tools like
[Sabaki](https://sabaki.yichuanshen.de/).

## Installation

There are several build options for Katago\'s derivation. Katago can use either Eigen, OpenCL, CUDA, or TensorRT. By
default, it uses OpenCL. To use a different backend override the \`backend\` attribute, allowed values are \"eigen\",
\"opencl\", \"cuda\", and \"tensorrt\".

For the eigen and cuda backends either version should be more or less functionally the same.

### Using CUDA {#using_cuda}

`   katago.override {`\
`     backend = "cuda";`\
`     cudnn = cudnn_cudatoolkit_10_2; # insert your favorite version of CUDA here (optional)`\
`     cudatoolkit = cudatoolkit_10_2; # I recommend at least CUDA 10, because older versions suffer major performance penalties`\
`     stdev = gcc8Stdev; # If you specify CUDA 10 or below you must also override the gcc version, this is due to NVidia compiler support.`\
`   }`

### Using Eigen {#using_eigen}

`   katago.override {`\
`     backend = "eigen";`\
`   }`

### Using TensorRT {#using_tensorrt}

First download the tensorrt redistributable installer from <https://developer.nvidia.com/tensorrt> and add it to your
nix-store.

Note that you need an NVidia account (free) to do this.

`   katago.override {`\
`     backend = "tensorrt";`\
`     enableTrtPlanCache = true; # Recommended to speed up booting, but uses additional disk space, so not recommended for contrib.`\
`   }`

## Configuration

If your processor support AVX2, you might want to enable it:

`   katago.override {`\
`     enableAVX2 = true;`\
`   }`

By default, katago uses the TCMalloc memory allocator. It is not recommended that you disable it due to severe
fragmentation issues after running katago for a few hours. However, if you cannot use TCMalloc, and you do not plan on
running katago for extended periods of time, you can disable it anyway.

`   katago.override {`\
`     enableTcmalloc = false;`\
`   }`

Katago also supports large boards (up to 29x29); however, there are no networks trained specifically on them, and
enabling them slows down even normal sized board play, so it is disabled by default. If you want to enable support:

`   katago.override {`\
`     enableBigBoards = true;`\
`   }`

### Contribute to the neural net {#contribute_to_the_neural_net}

Enabling [1](https://katagotraining.org/) contributions to the neural net:

`   katago.override {`\
`     enableContrib = true;`\
`   }`

[Category:Applications](Category:Applications "wikilink") [Category:Gaming](Category:Gaming "wikilink")

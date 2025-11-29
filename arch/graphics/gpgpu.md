[ja:GPGPU](ja:GPGPU "wikilink") [ru:GPGPU](ru:GPGPU "wikilink")
`{{Move|General-purpose computing on graphics processing units|Like with [[ALSA]], follow [[Help:Style#Title]].}}`{=mediawiki}
`{{Related articles start}}`{=mediawiki} `{{Related|Nvidia}}`{=mediawiki}
`{{Related|Hardware video acceleration}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

GPGPU stands for [General-purpose computing on graphics processing units](Wikipedia:GPGPU "wikilink"). Some GPGPU API
definitions include the vendor-independent OpenCL, SYCL, HIP, OpenMP, and Vulkan compute shader; and Nvidia\'s CUDA.
Each API can have multiple implementations on multiple types of hardware or software: GPUs, CPUs, NPUs, FPGAs, or just a
different GPGPU API (shim/transpiler).

## OpenCL

[OpenCL](Wikipedia:OpenCL "wikilink") (Open Computing Language) is an open, royalty-free parallel programming
specification developed by the Khronos Group, a non-profit consortium.

The OpenCL specifications describe a C-based programming language, a general environment that is required to be present,
and a C API to enable programmers to call into this environment. There are also bindings that let other languages to
call into this environment as well as alternative languages for writing the OpenCL computation kernel.

```{=mediawiki}
{{Tip|The {{pkg|clinfo}} utility can be used to list OpenCL platforms, devices present and ICD loader properties.}}
```
An OpenCL environment includes at least one of the following:

-   A copy of the *libOpenCL.so*, the ICD loader presenting a full OpenCL API interface.
-   Platform-dependent drivers that are loaded by the ICD loader.

### ICD loader (libOpenCL.so) {#icd_loader_libopencl.so}

It is very common for a system to have multiple OpenCL-capable hardware and hence multiple OpenCL runtime
implementations. A component called the \"OpenCL ICD loader\" is supposed to be a platform-agnostic library that
provides the means to load device-specific drivers through the OpenCL API. Most OpenCL vendors provide their own
implementation of an OpenCL ICD loader, and these should all work with the other vendors\' OpenCL implementations.
Unfortunately, most vendors do not provide completely up-to-date ICD loaders, and therefore Arch Linux has decided to
provide this library from a separate project (`{{Pkg|ocl-icd}}`{=mediawiki}) which provides a functioning implementation
of the current OpenCL API. As of 2025, the current OpenCL version is 3.0.

The other ICD loader libraries are installed as part of each vendor\'s SDK. If you want to ensure the ICD loader from
the `{{Pkg|ocl-icd}}`{=mediawiki} package is used, you can create a file in `{{ic|/etc/ld.so.conf.d}}`{=mediawiki} which
adds `{{ic|/usr/lib}}`{=mediawiki} to the dynamic program loader\'s search directories:

```{=mediawiki}
{{hc|/etc/ld.so.conf.d/00-usrlib.conf|
/usr/lib
}}
```
This is necessary because all the SDKs add their runtime\'s lib directories to the search path through
`{{ic|ld.so.conf.d}}`{=mediawiki} files.

The available packages containing various OpenCL ICDs are:

-   ```{=mediawiki}
    {{Pkg|ocl-icd}}
    ```
    : recommended, most up-to-date

-   ```{=mediawiki}
    {{AUR|intel-opencl}}
    ```
    by Intel. Provides OpenCL 2.0, deprecated in favour of `{{pkg|intel-compute-runtime}}`{=mediawiki}.

```{=mediawiki}
{{Note|An ICD Loader's vendor is functionally irrelevant: they should be vendor-agnostic and may be used interchangeably as long as they are implemented correctly. The vendor is only useful for the purpose to identify them from each other.}}
```
### Managing implementations {#managing_implementations}

To see which OpenCL implementations are currently active on your system, use the following command:

`$ ls /etc/OpenCL/vendors`

To find out all possible (known) properties of the OpenCL platform and devices available on the system,
[install](install "wikilink") `{{pkg|clinfo}}`{=mediawiki}.

```{=mediawiki}
{{Accuracy|It's questionable whether the bug of {{ic|OCL_ICD_VENDORS}} still exists. With {{Pkg|ocl-icd}} 2.3.3, setting the {{ic|OCL_ICD_VENDORS}} to a single file seems to work without an issue, and {{ic|clinfo -l}} produces correct result.}}
```
You can specify which implementations should your application see using `{{AUR|ocl-icd-choose}}`{=mediawiki}. For
example:

`$ ocl-icd-choose amdocl64.icd:mesa.icd davinci-resolve-checker`

```{=mediawiki}
{{ic|ocl-icd-choose}}
```
is a simple wrapper script that sets the `{{ic|OCL_ICD_FILENAMES}}`{=mediawiki} environment variable. It would not be
needed if `{{ic|OCL_ICD_VENDORS}}`{=mediawiki} could handle single icd files like the manual suggests; this is a known
bug being tracked as [OCL-dev/ocl-icd#7](https://github.com/OCL-dev/ocl-icd/issues/7#issuecomment-1522941979).

### Runtime

To **execute** programs that use OpenCL, a runtime that can be loaded by *libOpenCL.so* needs to be installed.

#### OpenCL on generic GPU {#opencl_on_generic_gpu}

For *any* GPU supported by [Mesa](Mesa "wikilink"), you can use rusticl by installing `{{Pkg|opencl-mesa}}`{=mediawiki}.
It can be enabled by using the [environment variable](environment_variable "wikilink")
`{{ic|RUSTICL_ENABLE{{=}}`{=mediawiki}*driver*}}, where `{{ic|''driver''}}`{=mediawiki} is a Gallium driver, such as
`{{ic|radeonsi}}`{=mediawiki} or `{{ic|iris}}`{=mediawiki}. It works on the broadest set of hardware but does not
necessarily provide the best performance. If you have trouble setting up other drivers, try using it: it takes a very
small amount of configuration to enable.

#### OpenCL on AMD/ATI GPU {#opencl_on_amdati_gpu}

-   ```{=mediawiki}
    {{Pkg|rocm-opencl-runtime}}
    ```
    : Part of AMD\'s ROCm GPU compute stack, officially supporting [a small range of GPU
    models](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html) (other
    cards may work with unofficial or partial support). To support cards older than Vega, you need to set the runtime
    variable `{{ic|1=ROC_ENABLE_PRE_VEGA=1}}`{=mediawiki}. This is similar, but not quite equivalent to
    [specifying](https://amdgpu-install.readthedocs.io/en/latest/install-script.html#specifying-an-opencl-implementation)
    `{{ic|1=opencl=rocr}}`{=mediawiki} in ubuntu\'s amdgpu-install, because this package\'s rocm version differs from
    ubuntu\'s installer version.

-   ```{=mediawiki}
    {{AUR|opencl-legacy-amdgpu-pro}}
    ```
    : Legacy Orca OpenCL repackaged from AMD\'s ubuntu releases. Equivalent to
    [specifying](https://amdgpu-install.readthedocs.io/en/latest/install-script.html#specifying-an-opencl-implementation)
    `{{ic|1=opencl=legacy}}`{=mediawiki} in ubuntu\'s amdgpu-install.

-   ```{=mediawiki}
    {{AUR|opencl-amd}}
    ```
    , `{{AUR|opencl-amd-dev}}`{=mediawiki}: ROCm components repackaged from AMD\'s Ubuntu releases. Equivalent to
    [specifying](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/amdgpu-install.html)
    `{{ic|1=opencl=rocr,legacy}}`{=mediawiki} in ubuntu\'s amdgpu-install.

##### OpenCL image support {#opencl_image_support}

The latest ROCm versions now includes OpenCL Image Support used by GPGPU accelerated software such as Darktable. ROCm
with the [AMDGPU](AMDGPU "wikilink") open source graphics driver are all that is required. AMDGPU PRO is not required.

```{=mediawiki}
{{hc|head=$ /opt/rocm/bin/clinfo {{!}}
```
grep -i \"image support\"\|output=

` Image support                                   Yes`

}}

#### OpenCL on NVIDIA GPU {#opencl_on_nvidia_gpu}

-   ```{=mediawiki}
    {{Pkg|opencl-nvidia}}
    ```
    : official [NVIDIA](NVIDIA "wikilink") runtime

#### OpenCL on Intel GPU {#opencl_on_intel_gpu}

-   ```{=mediawiki}
    {{pkg|intel-compute-runtime}}
    ```
    : a.k.a. the Neo OpenCL runtime, the open-source implementation for Intel HD Graphics GPU on Gen12 (Alder Lake) and
    beyond.

-   ```{=mediawiki}
    {{AUR|intel-compute-runtime-legacy}}
    ```
    : same as above only for Gen11(Rocket Lake) and lower

-   ```{=mediawiki}
    {{AUR|beignet}}
    ```
    : the open-source implementation for Intel HD Graphics GPU on Gen7 (Ivy Bridge) and beyond, deprecated by Intel in
    favour of NEO OpenCL driver, remains recommended solution for legacy hardware platforms (e.g. Ivy Bridge, Haswell).

-   ```{=mediawiki}
    {{AUR|intel-opencl}}
    ```
    : the proprietary implementation for Intel HD Graphics GPU on Gen7 (Ivy Bridge) and beyond, deprecated by Intel in
    favour of NEO OpenCL driver, remains recommended solution for legacy hardware platforms (e.g. Ivy Bridge, Haswell).

#### OpenCL on CPU {#opencl_on_cpu}

The following allow OpenCL to be run on a CPU:

-   ```{=mediawiki}
    {{AUR|intel-opencl-runtime}}
    ```
    : Intel\'s LLVM and oneAPI-based implementation for x86_64 processors. Officially intended for Intel Core and Xeon
    processors, it actually works on all x86_64 processors with SSE4.1. Even on AMD Zen processors it outperforms pocl.

-   ```{=mediawiki}
    {{Pkg|pocl}}
    ```
    : LLVM-based OpenCL implementation, works for all CPU architectures supported by LLVM and some GPUs (Nvidia through
    libCUDA, Intel through Level Zero) as well as OpenASIP. Despite this broad coverage, its performance leaves a lot to
    be desired.

-   ```{=mediawiki}
    {{AUR|amdapp-sdk}}
    ```
    : AMD CPU runtime, abandoned

#### OpenCL on Vulkan {#opencl_on_vulkan}

The following allow OpenCL to be run on top of a Vulkan runtime:

-   ```{=mediawiki}
    {{AUR|clspv-git}}
    ```
    : Clspv is a prototype compiler for a subset of OpenCL C to Vulkan compute shaders.

-   ```{=mediawiki}
    {{AUR|clvk-git}}
    ```
    : clvk is a prototype implementation of OpenCL 3.0 on top of Vulkan using clspv as the compiler.

#### OpenCL on FPGA {#opencl_on_fpga}

-   pocl for OpenASIP, see above.

-   ```{=mediawiki}
    {{AUR|xrt-bin}}
    ```
    : Xilinx Run Time for FPGA [xrt](https://github.com/Xilinx/XRT)

-   [fpga-runtime-for-opencl](https://github.com/intel/fpga-runtime-for-opencl): Intel FPGA Runtime

### 32-bit runtime {#bit_runtime}

To **execute** 32-bit programs that use OpenCL, a compatible hardware 32-bit runtime needs to be installed.

```{=mediawiki}
{{Tip|The {{pkg|clinfo}} utility can only be used to list 64-bit OpenCL platforms, devices present and ICD loader properties.
for 32-bit you need to compile clinfo for 32-bit or use the 32-bit [https://www.archlinux32.org/packages/i686/extra/clinfo/ clinfo] from the archlinux32 project.}}
```
#### OpenCL on generic GPU (32-bit) {#opencl_on_generic_gpu_32_bit}

-   ```{=mediawiki}
    {{Pkg|lib32-opencl-mesa}}
    ```
    : OpenCL support for Mesa drivers (32-bit)

#### OpenCL on NVIDIA GPU (32-bit) {#opencl_on_nvidia_gpu_32_bit}

-   ```{=mediawiki}
    {{Pkg|lib32-opencl-nvidia}}
    ```
    : OpenCL implemention for NVIDIA (32-bit)

### Development

For OpenCL **development**, the bare minimum additional packages required, are:

-   ```{=mediawiki}
    {{Pkg|ocl-icd}}
    ```
    : OpenCL ICD loader implementation, up to date with the latest OpenCL specification.

-   ```{=mediawiki}
    {{Pkg|opencl-headers}}
    ```
    : OpenCL C/C++ API headers.

The vendors\' SDKs provide a multitude of tools and support libraries:

-   ```{=mediawiki}
    {{AUR|intel-opencl-sdk}}
    ```
    : [Intel OpenCL SDK](https://software.intel.com/en-us/articles/opencl-sdk/) (old version, new OpenCL SDKs are
    included in the INDE and Intel Media Server Studio)

-   ```{=mediawiki}
    {{AUR|amdapp-sdk}}
    ```
    : This package is installed as `{{ic|/opt/AMDAPP}}`{=mediawiki} and apart from SDK files it also contains a number
    of code samples (`{{ic|/opt/AMDAPP/SDK/samples/}}`{=mediawiki}). It also provides the `{{ic|clinfo}}`{=mediawiki}
    utility which lists OpenCL platforms and devices present in the system and displays detailed information about them.
    As the SDK itself contains a CPU OpenCL driver, no extra driver is needed to execute OpenCL on CPU devices
    (regardless of its vendor).

-   ```{=mediawiki}
    {{Pkg|rocm-opencl-sdk}}
    ```
    : Develop OpenCL-based applications for AMD platforms.

-   ```{=mediawiki}
    {{Pkg|cuda}}
    ```
    : Nvidia\'s GPU SDK which includes support for OpenCL 3.0.

### Language bindings {#language_bindings}

These bindings allow other languages to call into the OpenCL environment. They generally do not alter the requirement to
write the kernel in OpenCL C.

-   **JavaScript/HTML5**: [WebCL](https://www.khronos.org/webcl/)
-   [Python](Python "wikilink"): `{{pkg|python-pyopencl}}`{=mediawiki}
-   [D](D "wikilink"): [cl4d](https://github.com/Trass3r/cl4d) or [DCompute](https://github.com/libmir/dcompute)
-   [Java](Java "wikilink"): [Aparapi](https://git.qoto.org/aparapi/aparapi) or [JOCL](https://jogamp.org/jocl/www/) (a
    part of [JogAmp](https://jogamp.org/))
-   [Mono/.NET](Mono "wikilink"): [Open Toolkit](https://sourceforge.net/projects/opentk/)
-   [Go](Go "wikilink"): [OpenCL bindings for Go](https://github.com/samuel/go-opencl)
-   **Racket**: Racket has a native interface [on
    PLaneT](http://planet.racket-lang.org/display.ss?owner=jaymccarthy&package=opencl.plt) that can be installed via
    raco.
-   [Rust](Rust "wikilink"): [ocl](https://github.com/cogciprocate/ocl)
-   [Julia](Julia "wikilink"): [OpenCL.jl](https://github.com/JuliaGPU/OpenCL.jl)

## SYCL

According to [Wikipedia:SYCL](Wikipedia:SYCL "wikilink"):

> SYCL is a higher-level programming model to improve programming productivity on various hardware accelerators. It is a
> single-source embedded domain-specific language (eDSL) based on pure C++17.
>
> SYCL is \[\...\] inspired by OpenCL that enables code for heterogeneous processors to be written in a "single-source"
> style using completely standard C++. SYCL enables single-source development where C++ template functions can contain
> both host and device code to construct complex algorithms that use hardware accelerators, and then re-use them
> throughout their source code on different types of data.
>
> While the SYCL standard started as the higher-level programming model sub-group of the OpenCL working group and was
> originally developed for use with OpenCL and SPIR, SYCL is a Khronos Group workgroup independent from the OpenCL
> working group \[\...\] starting with SYCL 2020, SYCL has been generalized as a more general heterogeneous framework
> able to target other systems. This is now possible with the concept of a generic backend to target any acceleration
> API while enabling full interoperability with the target API, like using existing native libraries to reach the
> maximum performance along with simplifying the programming effort. For example, the OpenSYCL implementation targets
> ROCm and CUDA via AMD\'s cross-vendor HIP.

In other words, the SYCL defines a programming environment based on C++17. This environment is intended to be combined
with compilers that produce code for both CPUs and GPGPUs. The language intended for the GPGPU side used to be SPIR, but
compilers that target other intermediate representations also exist.

### Implementations

-   ```{=mediawiki}
    {{AUR|trisycl-git}}
    ```
    : Open source implementation mainly driven by Xilinx.

-   ```{=mediawiki}
    {{AUR|adaptivecpp}}
    ```
    : Compiler for multiple programming models (SYCL, C++ standard parallelism, HIP/CUDA) for CPUs and GPUs from all
    vendors.

-   ```{=mediawiki}
    {{Pkg|intel-oneapi-dpcpp-cpp}}
    ```
    : Intel\'s Data Parallel C++: the LLVM/oneAPI Implementation of SYCL.

-   ```{=mediawiki}
    {{AUR|computecpp}}
    ```
    Codeplay\'s proprietary implementation of SYCL 1.2.1. Can target SPIR, SPIR-V and experimentally PTX (NVIDIA) as
    device targets (ends of support on 1st september 2023, will get merged into intel llvm implementation
    [Source](https://codeplay.com/portal/news/2023/07/07/the-future-of-computecpp)).

#### oneAPI

oneAPI is a marketing name used by many of Intel\'s high-performance computing libraries. The package
`{{Pkg|intel-oneapi-dpcpp-cpp}}`{=mediawiki} provides `{{ic|/opt/intel/oneapi/setvars.sh}}`{=mediawiki} that can be used
to set up the environment for compilation and linking of SYCL programs. Some parts of the components like the compiler
are open-sourced by Intel on GitHub while others are not.

Some packages can be installed for additional functionality. For example, `{{Pkg|intel-oneapi-mkl-sycl}}`{=mediawiki}
enables GPU offloading of the Math Kernel Library (MKL) to be supported.

#### Checking for SPIR support {#checking_for_spir_support}

SYCL was originally intended to be compiled to [SPIR or
SPIR-V](Wikipedia:Standard_Portable_Intermediate_Representation "wikilink"). Both are intermediate languages designed by
Khronos that can be consumed by an OpenCL driver. SPIR is included as a OpenCL 1.0 or 2.0 extension while SPIR-V is
included in OpenCL core from version 2.1 onwards (`{{ic|clCreateProgramWithIL}}`{=mediawiki}). To check whether SPIR or
SPIR-V are supported `{{pkg|clinfo}}`{=mediawiki} can be used:

```{=mediawiki}
{{hc|head=$ clinfo {{!}}
```
grep -i spir\|output= Platform Extensions cl_khr_icd cl_khr_global_int32_base_atomics
cl_khr_global_int32_extended_atomics cl_khr_local_int32_base_atomics cl_khr_local_int32_extended_atomics
cl_khr_byte_addressable_store cl_khr_depth_images cl_khr_3d_image_writes cl_intel_exec_by_local_thread cl_khr\_**spir**
cl_khr_fp64 cl_khr_image2d_from_buffer cl_intel_vec_len_hint

` IL version                                    `**`SPIR`**`-V_1.0`\
` `**`SPIR`**` versions                                 1.2`

}}

ComputeCpp additionally ships with a tool that summarizes the relevant system information:

```{=mediawiki}
{{hc|$ computecpp_info|
Device 0:

  Device is supported                     : UNTESTED - Untested OS
  CL_DEVICE_NAME                          : Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz
  CL_DEVICE_VENDOR                        : Intel(R) Corporation
  CL_DRIVER_VERSION                       : 18.1.0.0920
  CL_DEVICE_TYPE                          : CL_DEVICE_TYPE_CPU 

}}
```
```{=mediawiki}
{{Out of date|Is the driver for AMD {{AUR|opencl-legacy-amdgpu-pro}} or {{AUR|opencl-amd}}?}}
```
Drivers known to at least partially support SPIR or SPIR-V include `{{pkg|intel-compute-runtime}}`{=mediawiki},
`{{AUR|intel-opencl-runtime}}`{=mediawiki}, `{{Pkg|pocl}}`{=mediawiki} and
`{{AUR|amdgpu-pro-opencl}}`{=mediawiki}`{{Broken package link|package not found}}`{=mediawiki}.

##### Other uses of SPIR/SPIR-V {#other_uses_of_spirspir_v}

SPIR-V covers not only compute kernels, but also graphics shaders. It is able to serve as a shader intermediate language
for OpenGL and Vulkan as well as a compute intermediate language for OpenCL, Vulkan, and SYCL. It can also be decompiled
as a way to convert a kernel or shader from one language to another.

The C++ for OpenCL language (not to be confused with the short-lived \"OpenCL C++\") combines C++17 with OpenCL C. A
handful of OpenCL drivers support loading it directly with `{{ic|clBuildProgram()}}`{=mediawiki} like one would do with
OpenCL C, but the main expected usage is through `{{ic|clang}}`{=mediawiki} converting it to SPIR-V first. It can be an
option for programmers who want to use C++17 in writing OpenCL kernels but do not want to embrace the whole model of
SYCL.

### Development {#development_1}

SYCL requires a working C++11 environment to be set up.

There are a few open source libraries available for making use of the parallel capabilities in SYCL from its C++17
language:

-   [ComputeCpp SDK](https://github.com/codeplaysoftware/computecpp-sdk/): Collection of code examples,
    `{{Pkg|cmake}}`{=mediawiki} integration for ComputeCpp
-   [SYCL-DNN](https://github.com/codeplaysoftware/SYCL-DNN): Neural network performance primitives
-   [SYCL-BLAS](https://github.com/codeplaysoftware/SYCL-BLAS): Linear algebra performance primitives
-   [VisionCpp](https://github.com/codeplaysoftware/visioncpp): Computer Vision library
-   [SYCL Parallel STL](https://github.com/KhronosGroup/SyclParallelSTL): GPU implementation of the C++17 parallel
    algorithms

## CUDA

[CUDA](Wikipedia:CUDA "wikilink") (Compute Unified Device Architecture) is [NVIDIA](NVIDIA "wikilink")\'s proprietary,
closed-source parallel computing architecture and framework. It requires an NVIDIA GPU, and consists of several
components:

-   Required:
    -   Proprietary NVIDIA kernel module
    -   CUDA \"driver\" and \"runtime\" libraries
-   Optional:
    -   Additional libraries: CUBLAS, CUFFT, CUSPARSE, etc.
    -   CUDA toolkit, including the `{{ic|nvcc}}`{=mediawiki} compiler
    -   CUDA SDK, which contains many code samples and examples of CUDA and OpenCL programs

The kernel module and CUDA \"driver\" library are shipped in `{{Pkg|nvidia}}`{=mediawiki} and
`{{Pkg|opencl-nvidia}}`{=mediawiki}. The \"runtime\" library and the rest of the CUDA toolkit are available in
`{{Pkg|cuda}}`{=mediawiki}. `{{ic|cuda-gdb}}`{=mediawiki} needs `{{aur|ncurses5-compat-libs}}`{=mediawiki} to be
installed, see `{{Bug|46598}}`{=mediawiki}.

### Development {#development_2}

The `{{Pkg|cuda}}`{=mediawiki} package installs all components in the directory `{{ic|/opt/cuda}}`{=mediawiki}. The
script in `{{ic|/etc/profile.d/cuda.sh}}`{=mediawiki} sets the relevant environment variables so all build systems that
support CUDA can find it.

To find whether the installation was successful and whether CUDA is up and running, you can compile the [CUDA
samples](https://github.com/nvidia/cuda-samples). One way to check the installation is to run the
`{{ic|deviceQuery}}`{=mediawiki} sample.

### Language bindings {#language_bindings_1}

-   **Fortran**: [PGI CUDA Fortran Compiler](https://www.pgroup.com/resources/cudafortran.htm)
-   [Haskell](Haskell "wikilink"): The [accelerate package](https://hackage.haskell.org/package/accelerate) lists
    available CUDA backends
-   [Java](Java "wikilink"): [JCuda](http://www.jcuda.org/jcuda/JCuda.html)
-   [Mathematica](Mathematica "wikilink"):
    [CUDAlink](https://reference.wolfram.com/mathematica/CUDALink/tutorial/Overview.html)
-   [Mono/.NET](Mono "wikilink"): [CUDAfy.NET](https://github.com/rapiddev/CUDAfy.NET),
    [managedCuda](https://github.com/kunzmi/managedCuda)
-   [Perl](Perl "wikilink"): [KappaCUDA](https://metacpan.org/pod/KappaCUDA),
    [CUDA-Minimal](https://github.com/run4flat/perl-CUDA-Minimal)
-   [Python](Python "wikilink"): `{{pkg|python-pycuda}}`{=mediawiki}
-   [Ruby](Ruby "wikilink"): [rbcuda](https://github.com/SciRuby/rbcuda)
-   [Rust](Rust "wikilink"): [Rust-CUDA](https://github.com/Rust-GPU/Rust-CUDA). Unmaintained:
    [cuda-sys](https://github.com/rust-cuda/cuda-sys) (bindings), [RustaCUDA](https://github.com/bheisler/rustacuda)
    (high-level wrapper).

## ROCm

ROCm [ROCm](https://rocm.docs.amd.com/en/latest/) (Radeon Open Compute Platform) is AMD\'s answer to CUDA. It includes
many pieces of software from driver (AMDGPU) to compiler and runtime library, much like CUDA. Some parts are specific to
select AMD GPUs, other parts completely hardware-agnostic. See the [ROCm for Arch Linux
repository](https://github.com/rocm-arch/rocm-arch) for more information.

ROCm includes a singular software stack for implementing compute capabilities on the AMDGPU driver. On top of this
stack, it implements HIP, OpenMP, and OpenCL. It also includes some parts built on top of HIP as well as an
implementation of HIP using NVIDIA\'s CUDA stack.

### ROCm-enabled models {#rocm_enabled_models}

ROCm should suppport AMD GPUs from the Polaris architecture (RX 500 series) and above. The official [list of GPU
models](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html) is very short,
consisting of mostly profession models. However, consumer GPUs and APUs of the equivalent generations are known to work.
Other generations may work with unofficial or partial support. To support Polaris, you need to set the runtime variable
`{{ic|1=ROC_ENABLE_PRE_VEGA=1}}`{=mediawiki}.

It takes some time for newer AMD GPU architectures to be added to ROCm; see [Wikipedia:ROCm#Consumer-grade
GPUs](Wikipedia:ROCm#Consumer-grade_GPUs "wikilink") for an up-to-date support matrix. Also see [#OpenCL on AMD/ATI
GPU](#OpenCL_on_AMD/ATI_GPU "wikilink") from before.

### HIP

The [Heterogeneous Interface for Portability (HIP)](https://rocm.docs.amd.com/projects/HIP/en/latest/) is AMD\'s
dedicated GPU programming environment for designing high performance kernels on GPU hardware. HIP is a C++ runtime API
and programming language that allows developers to create portable applications on different platforms.

HIP\'s specification is managed in the [rocm-systems repository](https://github.com/ROCm/rocm-systems), but HIP itself
is hardware-agnostic.

HIP runtime library packages:

-   ```{=mediawiki}
    {{Pkg|rocm-hip-runtime}}
    ```
    : The high-level runtime library, analogous to the OpenCL ICD loader.

-   ```{=mediawiki}
    {{Pkg|hip-runtime-amd}}
    ```
    : Implementation of HIP for AMD GPUs.

-   ```{=mediawiki}
    {{Pkg|hip-runtime-nvidia}}
    ```
    : The Heterogeneous Interface for NVIDIA GPUs in ROCm. This is really just a bunch of header files for the CUDA C++
    compiler mostly consisting of `{{ic|#define}}`{=mediawiki} renames.

The `{{Pkg|rocm-hip-sdk}}`{=mediawiki} package includes the HIP SDK. All components are installed in the directory
`{{ic|/opt/rocm}}`{=mediawiki}. The script that sets the relevant environment variables is provided in
`{{ic|/etc/profile.d/rocm.sh}}`{=mediawiki}. Some software might also check for `{{ic|HIP_PATH}}`{=mediawiki}, which can
be manually set to the same value as `{{ic|ROCM_PATH}}`{=mediawiki}.

```{=mediawiki}
{{Pkg|miopen-hip}}
```
is the HIP backend for AMD\'s open source deep learning library.

### ROCm troubleshooting {#rocm_troubleshooting}

First check if your GPU shows up in `{{ic|/opt/rocm/bin/rocminfo}}`{=mediawiki}. If it does not, it might mean that ROCm
does not support your GPU or it is built without support for your GPU.

Also check the [ROCm HIP environment variables](https://rocm.docs.amd.com/en/latest/conceptual/gpu-isolation.html) for
debugging, GPU isolation, etc.

## OpenMP and OpenACC {#openmp_and_openacc}

OpenMP is better-known for its use in CPU multiprocessing, but it also supports some offloading for moving some work to
GPGPUs. OpenACC is in a similar position: both are based on inserting pragmas into ordinary C/C++/Fortran code and
having the compiler split out the marked part for offloading or multiprocessing.

-   AMD provides an implementation of OpenMP for ROCm-capable AMD GPUs. The `{{AUR|openmp-extras}}`{=mediawiki} package
    provides [AOMP](https://github.com/ROCm-Developer-Tools/aomp) - an open source Clang/LLVM based compiler with added
    support for the OpenMP API on AMD GPUs.
-   Nvidia\'s `{{Pkg|nvhpc}}`{=mediawiki} provides OpenMP implementation with GPU offloading on their GPUs.
    [1](https://docs.nvidia.com/hpc-sdk/compilers/hpc-compilers-user-guide/index.html#using-openmp)
-   GCC can generate Nvidia (nvptx) and AMD (gfx9, gfx10, gfx11) code for offloading OpenMP and OpenACC
    [2](https://gcc.gnu.org/wiki/Offloading).
-   Clang/LLVM can generate Nvidia (nvptx) and AMD (amdgpu) code for offloading OpenMP and OpenACC
    [3](https://clang.llvm.org/docs/OffloadingDesign.html) [4](https://clang.llvm.org/docs/ClangOffloadBundler.html).

## List of GPGPU accelerated software {#list_of_gpgpu_accelerated_software}

```{=mediawiki}
{{Expansion|More application may support GPGPU.}}
```
-   [Bitcoin](Bitcoin "wikilink")

-   [Blender](Blender "wikilink") -- CUDA support for Nvidia GPUs and HIP support for AMD GPUs. More information in
    [5](https://docs.blender.org/manual/en/latest/render/cycles/gpu_rendering.html).

-   [BOINC](BOINC "wikilink") -- some projects provide OpenCL and/or CUDA programs

-   ```{=mediawiki}
    {{AUR|cuda_memtest}}
    ```
    -- a GPU memtest. Despite its name, is supports both CUDA and OpenCL.

-   ```{=mediawiki}
    {{Pkg|darktable}}
    ```
    -- OpenCL feature requires at least 1 GB RAM on GPU and *Image support* (check output of clinfo command).

-   [DaVinci Resolve](DaVinci_Resolve "wikilink") - a non-linear video editor. Can use both OpenCL and CUDA.

-   [FFmpeg](FFmpeg "wikilink") -- more information in [6](https://trac.ffmpeg.org/wiki/HWAccelIntro#OpenCL).
    -   [HandBrake](HandBrake "wikilink")

-   [Folding@home](Folding@home "wikilink") -- uses OpenCL and CUDA versions of the molecular simulation software
    GROMACS

-   [GIMP](GIMP "wikilink") -- experimental -- more information in
    [7](https://www.h-online.com/open/news/item/GIMP-2-8-RC-1-arrives-with-GPU-acceleration-1518417.html).

-   [Hashcat](Hashcat "wikilink")

-   ```{=mediawiki}
    {{Pkg|imagemagick}}
    ```

-   [LibreOffice](LibreOffice "wikilink") Calc -- more information in
    [8](https://help.libreoffice.org/Calc/OpenCL_Options).

-   [mpv](mpv "wikilink") - See [mpv#Hardware video acceleration](mpv#Hardware_video_acceleration "wikilink").

-   ```{=mediawiki}
    {{AUR|lc0}}
    ```
    \- Used for searching the neural network (supports tensorflow, OpenCL, CUDA, and openblas)

-   [opencl-benchmark](https://github.com/ProjectPhysX/OpenCL-Benchmark) - simple FP64/FP32/FP16/INT64/INT32/INT16/INT8
    and memory/PCIe bandwidth benchmarking tool for OpenCL

-   ```{=mediawiki}
    {{Pkg|opencv}}
    ```

-   [ollama](ollama "wikilink") - LLM inference software

-   ```{=mediawiki}
    {{AUR|llama.cpp-cuda}}
    ```
    , `{{AUR|llama.cpp-hip}}`{=mediawiki} - Port of Facebook\'s LLaMA model in C/C++

-   ```{=mediawiki}
    {{AUR|pyrit}}
    ```

-   ```{=mediawiki}
    {{Pkg|python-pytorch-cuda}}
    ```
    , `{{Pkg|python-pytorch-rocm}}`{=mediawiki}

-   ```{=mediawiki}
    {{Pkg|tensorflow-cuda}}
    ```
    , `{{AUR|tensorflow-computecpp}}`{=mediawiki}

-   ```{=mediawiki}
    {{Pkg|xmrig}}
    ```
    \- High Perf CryptoNote CPU and GPU (OpenCL, CUDA) miner

### PyTorch on ROCm {#pytorch_on_rocm}

To use PyTorch with ROCm install `{{Pkg|python-pytorch-rocm}}`{=mediawiki}.

```{=mediawiki}
{{hc|$ python -c 'import torch; print(torch.cuda.is_available())'|True}}
```
ROCm pretends to be CUDA so this should return `{{ic|True}}`{=mediawiki}. If it does not, either it is not compiled with
your GPU support or you might have conflicting dependencies. You can verify those by looking at
`{{ic|ldd /usr/lib/libtorch.so}}`{=mediawiki} - there should not be any missing `{{ic|.so}}`{=mediawiki} files nor
multiple versions of same `{{ic|.so}}`{=mediawiki}.

## See also {#see_also}

-   [OpenCL official homepage](https://www.khronos.org/opencl/)
-   [SYCL official homepage](https://www.khronos.org/sycl/)
-   [SPIR official homepage](https://www.khronos.org/spir/)
-   [CUDA Toolkit homepage](https://developer.nvidia.com/cuda-toolkit)
-   [Intel SDK for OpenCL Applications homepage](https://software.intel.com/en-us/intel-opencl)
-   [ComputeCpp official
    homepage](https://developer.codeplay.com/home/)`{{Dead link|2025|11|17|status=404}}`{=mediawiki}
-   [List of OpenCL frameworks applicable for different GPUs](https://gitlab.com/illwieckz/i-love-compute)

[Category:Development](Category:Development "wikilink") [Category:Graphics](Category:Graphics "wikilink")

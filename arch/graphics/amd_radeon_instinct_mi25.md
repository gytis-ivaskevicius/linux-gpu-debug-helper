[ja:AMD Radeon Instinct MI25](ja:AMD_Radeon_Instinct_MI25 "wikilink") `{{Related articles start}}`{=mediawiki}
`{{Related|AMDGPU}}`{=mediawiki} `{{Related|General-purpose computing on graphics processing units}}`{=mediawiki}
`{{Related articles end}}`{=mediawiki}

This page describes the steps necessary to perform [general-purpose computing on graphics processing
units](Wikipedia:General-purpose_computing_on_graphics_processing_units "wikilink") (GPGPU) on the [AMD Radeon Instinct
MI25](Wikipedia:AMD_Instinct#MI25 "wikilink") and other gfx900 vega10 GPUs, such as the Radeon Vega Frontier Edition,
Radeon RX Vega 56/64, Radeon Pro Vega 48/56/64/64X, Radeon Pro WX 8200/9100, and the Radeon Pro V320/V340/SSG.

## BIOS and cooling {#bios_and_cooling}

The MI25 is an affordable, power hungry, passively cooled accelerator card with 16GB of HBM2 VRAM that often exhibits
incompatibility with consumer level hardware and has no video out by default. To remedy this, we can flash a WX9100 BIOS
to the MI25, which lowers the power limit from 220W to 170W, enables the Mini DisplayPort hidden behind the PCIe
bracket, enables the fan header to be used for active cooling, and allows consumer equipment to boot with the MI25
attached if it would not before.

Depending on your situation, you may be able to [flash the BIOS from within the operating
system](https://forum.level1techs.com/t/mi25-stable-diffusions-100-hidden-beast) using `{{AUR|amdvbflash}}`{=mediawiki}
if you can boot successfully and keep it cool. Alternatively, the BIOS can be flashed quite easily in hardware without
the risk of overheating.

The recommended and most widely tested WX9100 BIOS can be [downloaded
here](https://www.techpowerup.com/vgabios/218718/amd-wx9100-16384-171219).

### Hardware flashing with a Raspberry Pi {#hardware_flashing_with_a_raspberry_pi}

The BIOS chip is located under the backplate and can be flashed with a SOP8 test clip and a Raspberry Pi using
`{{Pkg|flashrom}}`{=mediawiki}.

```{=mediawiki}
{{Note|Keep in mind that using a test clip provides a less than ideal connection, so it is important to take multiple dumps and compare them before and after flashing, and although in theory we could use a faster spi speed such as 32768, in practice user reports success using 8192. Feel free to adjust this value as needed.}}
```
Firstly, we need to connect the MI25 BIOS chip and clip to the Raspberry Pi GPIO pins [according to this diagram
here](https://libreboot.org/docs/install/spi.html#gpio-pins-on-raspberry-pi-rpi-40-pin). Once we have carefully
connected everything and have the Raspberry Pi booted, use the following command to see if the flash is detected.

`# flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=8192`

Once the flash has been successfully detected, we must backup the original BIOS before we flash the new one. This serves
two purposes, it provides us with a backup to restore to, and confirms that we have a good connection to the BIOS flash
chip.

`# flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=8192 -r mi25-dump1.rom`\
`# flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=8192 -r mi25-dump2.rom`\
`$ sha1sum mi25-dump*.rom`

If the checksums match, then we are good to go. If not, try reseating the clip and try again until you get consistent
dumps.

You may have noticed that the WX9100 BIOS is 256KiB, while the MI25 BIOS is 1MiB. To remedy this, we create a 768KiB
file consisting of zero bytes and append it to the end of our WX9100 BIOS, `{{ic|1=218718.rom}}`{=mediawiki}.

`$ truncate -s +768KiB pad.bin`\
`$ cat 218718.rom pad.bin > 218718-padded.rom`

After that, we can flash the freshly padded BIOS to the MI25.

`# flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=8192 -w 218718-padded.rom -V`

Flashrom should verify a successful flash, but feel free to take another BIOS dump and compare checksums to
`{{ic|1=218718-padded.rom}}`{=mediawiki}.

### Cooling

The MI25 has a JST-PH 4-pin fan header that actually works under the WX9100 BIOS. Simply purchase a cheap KK254 4-pin
(regular 4 pin computer fan) to JST-PH 4-pin (MI25 fan header) adaptor cable. If you shop around, you can find a cheap
adapter that lets you power two 4 pin fans from the MI25 (try searching for \"Graphics Card Fan Adapter Cable\"). To
install the adapter cable, the shroud needs to be taken off, and the cable can be routed out through the gap next to the
power connector.

```{=mediawiki}
{{Note|While the cooling shroud is off, it is recommended to replace the thermal paste while you are there.}}
```
Since the MI25 comes passively cooled, some sort of ducting is required to redirect airflow through the heatsink. [3D
printing one of these cooling shrouds](https://www.thingiverse.com/thing:6636428), depending on which fan you decide to
use, is quite a nice option, although a homemade solution would also suffice.

```{=mediawiki}
{{Note|Since the MI25 is designed to be in a server rack with high airflow, point a second fan at the components on the back of the MI25 if airflow does not already exist there.}}
```
## ROCm

The MI25 and other gfx900 GPUs are deprecated and official support has ended. They were officially supported under ROCm
4, and unsupported under ROCm 5 and 6. However, the [ROCm
6](General-purpose_computing_on_graphics_processing_units#ROCm "wikilink") packages in the arch repos are compiled with
gfx900 support and now works out of the box.

## GPGPU accelerated software {#gpgpu_accelerated_software}

The purpose of this section is to list GPGPU accelerated software and how to run them on gfx900 GPUs.

### Ollama and Open WebUI {#ollama_and_open_webui}

[Ollama](Ollama "wikilink") (`{{pkg|ollama-rocm}}`{=mediawiki}) and `{{AUR|open-webui}}`{=mediawiki} are known to work
with gfx900 with little to no configuration. As of Open WebUI version `{{ic|0.6.15-1}}`{=mediawiki},
`{{ic|/opt/open-webui/backend/start.sh}}`{=mediawiki} needs to be made [executable](executable "wikilink").

### AUTOMATIC1111s Stable Diffusion web UI {#automatic1111s_stable_diffusion_web_ui}

A web interface for Stable Diffusion, implemented using Gradio library.

```{=mediawiki}
{{AUR|stable-diffusion-webui}}
```
can be used with a little manual configuration after installation.

Unfortunately it cannot be used with the latest python version, which means it cannot use the system ROCm or pytorch
packages. However, by modifying the pytorch installation command in `{{ic|webui-user.sh}}`{=mediawiki}, we may obtain a
working installation.

`export TORCH_COMMAND="pip --no-cache-dir install torch torchvision --index-url `[`https://download.pytorch.org/whl/rocm6.3`](https://download.pytorch.org/whl/rocm6.3)`"`

The nightly build for ROCm 6.4 is not built with gfx900 support, which is why we choose version 6.3, and the
`{{ic|--no-cache-dir}}`{=mediawiki} flag may be omitted in an environment with a suitable quantity of RAM.

`export COMMANDLINE_ARGS="--skip-torch-cuda-test"`

The `{{ic|--skip-torch-test}}`{=mediawiki} arguments bypasses the CUDA check since we are not using an Nvidia GPU. If
you are planning on accessing the stable diffusion webUI from another computer on the network, the
`{{ic|--listen}}`{=mediawiki} flag may also be used.

`export COMMANDLINE_ARGS="--listen --skip-torch-cuda-test"`

See [the github page](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Command-Line-Arguments-and-Settings)
for a complete list of command line arguments. Notable ones include `{{ic|--api}}`{=mediawiki},
`{{ic|api-auth username:password}}`{=mediawiki}, and `{{ic|--gradio-auth username:password}}`{=mediawiki} for securing
access and linking to ollama open webUI for example.

To change the torch and torchvision packages to ROCM 6.3 after the installer script has run, execute the following:

`$ sudo -u sdwebui -s`\
`$ cd`\
`$ source venv/bin/activate`\
`$ pip uninstall torch torchvision`\
`$ deactivate`\
`$ exit`

Restart `{{ic|stable-diffusion-webui.service}}`{=mediawiki} for changes to take effect and for the installation to
complete.

### Python ROCm Libraries {#python_rocm_libraries}

Python libraries `{{pkg|python-pytorch-rocm}}`{=mediawiki}, `{{AUR|python-torchvision-rocm}}`{=mediawiki} and
`{{AUR|tensorflow-rocm}}`{=mediawiki} are known to work with gfx900.

### BitCrack

A tool for brute-forcing Bitcoin private keys.

-   Clone repository.

`$ git clone `[`https://github.com/brichard19/BitCrack.git`](https://github.com/brichard19/BitCrack.git)

-   Change directory and build for OpenCL.

`$ cd BitCrack && make BUILD_OPENCL{{=}}1`

-   Run `{{ic|clBitCrack}}`{=mediawiki}.

`$ ./bin/clBitCrack 1FshYsUh3mqgsG29XpZ23eLjWV8Ur3VwH 15JhYXn6Mx3oF4Y7PcTAv2wVVAuCFFQNiP 19EEC52krRUK1RkUAEZmQdjTyHT7Gp1TYT`

[Category:Graphics](Category:Graphics "wikilink")

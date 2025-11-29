Applications in \`nixpkgs\` handle OpenGL in a certain way. Using these applications outside of NixOS requires the use
of a wrapper.

## Solutions

  Driver Support                                                                                  [NixGL](https://github.com/nix-community/nixGL)   [nix-gl-host](https://github.com/numtide/nix-gl-host/)   [nix-system-graphics](https://github.com/soupglasses/nix-system-graphics)
  ----------------------------------------------------------------------------------------------- ------------------------------------------------- -------------------------------------------------------- ---------------------------------------------------------------------------
  AMD (mesa)                                                                                      ✅                                                ❌                                                       ✅
  Intel (mesa)                                                                                    ✅                                                ❌                                                       ✅
  Nvidia (nouveau)                                                                                ✅                                                ❌                                                       ✅
  Nvidia (proprietary)                                                                            ✅                                                ✅                                                       ⚠️ Must be manually set to match OS driver version
  Functionality                                                                                                                                                                                              
  Graphical programs from nix                                                                     ⚠️ Must be manually wrapped                                                                                ✅
  Graphical programs from host (non-nix) (*e.g.* launch non-nix web browser from nixpkgs#kitty)   ❌ Broken                                                                                                  ✅
  License                                                                                         ❌ None                                           Apache-2.0                                               MIT

[Category:Video](Category:Video "wikilink")

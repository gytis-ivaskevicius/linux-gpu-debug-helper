[ja:Urban Terror](ja:Urban_Terror "ja:Urban Terror"){.wikilink} [Urban Terror™](https://www.urbanterror.info/) is a free
multiplayer first person shooter developed by FrozenSand, that will run on any Quake III Arena compatible engine. It is
available for Windows, Linux and Macintosh.

Urban Terror can be described as a Hollywood tactical shooter; somewhat realism based, but the motto is \"fun over
realism\". This results in a very unique, enjoyable and addictive game.

## Installation

### Client

Urban Terror has been dropped to AUR (see `{{Bug|54262#comment158955}}`{=mediawiki}) :
[install](install "install"){.wikilink} `{{aur|urbanterror}}`{=mediawiki}.

## Mapping

A quick introduction on how to create your own maps.

### Install a map editor {#install_a_map_editor}

[Install](Install "Install"){.wikilink} `{{AUR|gtkradiant-git}}`{=mediawiki}.

### Prepare the game files {#prepare_the_game_files}

There are **two ways** use the second one if you are low on disk space.

#### Extract your pk3s (recommended, \~1GB free disk space required) {#extract_your_pk3s_recommended_1gb_free_disk_space_required}

To get something to work with, you need to extract Urban Terror\'s pk3 files to a new folder:

`$ install -d ~/urtmapping/q3ut4`\
`$ cd ~/urtmapping/q3ut4`\
`$ bsdtar -x -f /opt/urbanterror/q3ut4/zpak000_assets.pk3 --exclude maps`\
`$ bsdtar -x -f /opt/urbanterror/q3ut4/zpak000.pk3`

#### Give GTKRadiant write access to the game folder (for single user machines) {#give_gtkradiant_write_access_to_the_game_folder_for_single_user_machines}

GTKradiant creates a few own files inside game directory on creating a game profile. This means that you can own to the
Urban Terror folder temporarily until these are created:

`# chown `*`yourusername`*` -R /opt/urbanterror`

Then start GTKRadiant and configure the game profile, just use `{{ic|/opt/urbanterror}}`{=mediawiki} as path). Close it
afterwards and restrict access again with:

`# chown root -R /opt/urbanterror`

Please note, that your user will own the newly created files until they get deleted (which is just what we want in this
case).

### Test your map {#test_your_map}

Copy your compiled .bsp mapfile to `{{ic|~/.urbanterror/q3ut4/maps}}`{=mediawiki} and run:

`$ urbanterror +set fs_game iourtmap +set sv_pure 0 +map `*`ut4_yourmap`*

## Tips and tricks {#tips_and_tricks}

### Running Urban Terror without a window manager {#running_urban_terror_without_a_window_manager}

See [xinit#Starting applications without a window
manager](xinit#Starting_applications_without_a_window_manager "xinit#Starting applications without a window manager"){.wikilink}.

## Troubleshooting

### Fix urbanterror_ui.shader {#fix_urbanterror_ui.shader}

Edit `{{ic|~/urtmapping/q3ut4/scripts/urbanterror_ui.shader}}`{=mediawiki} and delete lines 29-55 (from /\* to \*/),
because gtkradiant will not recognize this part as a comment and would try to parse it.

### Problems with libcurl {#problems_with_libcurl}

UrbanTerror may complain that it cannot autodownload missing files because the cURL library could not be loaded, even
though the cURL package is installed. UrbanTerror expects the shared library file to be called libcurl.so.3, but Arch
Linux currently uses libcurl.so.4.

To remedy this, start UrbanTerror with an additional parameter from a terminal emulator:

`$ urbanterror +cl_curllib libcurl.so.4`

## External links {#external_links}

- [Urban Terror homepage](https://www.urbanterror.info)
- [UT-Forums: Level Design Linklist](https://www.urbanterror.info/forums/topic/141-level-design-links/)
- [Debian + GTKRadiant + Urban Terror
  HOW-TO](https://web.archive.org/web/20130522091327/http://daffy.nerius.com/radiant/)
- [UT-Forums: Urban Terror GTKRadiant
  Tutorial](https://www.urbanterror.info/forums/topic/13539-complete-linux-gtkradiant-urt-mapping-how-to/page__hl__urtpack__fromsearch__1__s__0bed93b96b8f19a3707143f46acfb964)
  *Please note* that the example from this guide has no light and Urban Terror will just display black walls.

[Category:Gaming](Category:Gaming "Category:Gaming"){.wikilink}

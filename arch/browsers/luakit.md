[ja:Luakit](ja:Luakit "wikilink") [Luakit](https://luakit.github.io/) is an extremely fast, lightweight and flexible web
browser using the webkit engine. It is customizable through lua scripts and fully usable with keyboard shortcuts. It
uses GTK 3 and [WebKit2GTK](List_of_applications/Internet#WebKitGTK-based "wikilink").

## Installation

Install the `{{Pkg|luakit}}`{=mediawiki} package.

## Basic usage {#basic_usage}

```{=mediawiki}
{{Style|Do we really need to duplicate upstream or internal documentation?}}
```
```{=mediawiki}
{{Note|Shortcuts are listed in a special page accessible with the {{ic|:binds}} command.}}
```
Press `{{ic|:}}`{=mediawiki} to access the command prompt. You can do nearly everything from there. Use
`{{ic|Tab}}`{=mediawiki} to autocomplete commands.

Use the `{{ic|:help}}`{=mediawiki} command to get information on the available keyboard shortcuts and what they do. (To
see how the action for a particular keyboard shortcut is implemented in Lua, click anywhere in its help text.)

To quit, use the `{{ic|:quit}}`{=mediawiki} command, or press `{{ic|Shift+z}}`{=mediawiki} followed by
`{{ic|Shift+q}}`{=mediawiki}. You can also close the browser while remembering the session (i.e. restoring the tabs) by
using the `{{ic|:writequit}}`{=mediawiki} command instead, or pressing `{{ic|Shift+z}}`{=mediawiki} twice.

### Browsing

-   Press `{{ic|o}}`{=mediawiki} to open a prompt with the `{{ic|:open}}`{=mediawiki} command and enter the URI you
    want. Press `{{ic|Shift+o}}`{=mediawiki} to edit the current URI.
-   If it is not a recognized URI, Luakit will use the default search engine. See [#Custom search
    engines](#Custom_search_engines "wikilink").
-   Specify which search engine to use by prefixing the entry with the appropriate keywork (e.g.
    `{{ic|:open google foobar}}`{=mediawiki} will search *foobar* on Google).
-   Use common shortcuts to navigate. For [emacs](emacs "wikilink") and [vim](vim "wikilink") *aficionados*, some of
    their regular shortcuts are provided. You can use the mouse as well.
-   Use `{{ic|f}}`{=mediawiki} to display the index of all visible links. Enter the appropriate number or a part of the
    string to open the link.
-   Use `{{ic|Shift+f}}`{=mediawiki} instead to open link in a new tab.
-   Press `{{ic|Ctrl+t}}`{=mediawiki} to open a new tab, `{{ic|Ctrl+w}}`{=mediawiki} to close it. Press
    `{{ic|t}}`{=mediawiki} to prompt for an URI to be opened in a new tab, and `{{ic|Shift+t}}`{=mediawiki} to edit the
    current URI in a new tab.
-   Press `{{ic|w}}`{=mediawiki} to prompt for an URI to be opened in a new window, and `{{ic|Shift+w}}`{=mediawiki} to
    edit the current URI in a new window.
-   Switch from one tab to another by pressing `{{ic|g}}`{=mediawiki} followed by `{{ic|t}}`{=mediawiki} or
    `{{ic|Shift+t}}`{=mediawiki}, or use `{{ic|Ctrl+PageUp}}`{=mediawiki} and `{{ic|Ctrl+PageDown}}`{=mediawiki}.
-   You can switch to a specific tab with `{{ic|Alt+''number''}}`{=mediawiki}.
-   Use `{{ic|Shift+h}}`{=mediawiki} to go back in the browser history.
-   Use `{{ic|Shift+l}}`{=mediawiki} to go forward in the browser history.
-   Reorder the tabs with `{{ic|<}}`{=mediawiki} and `{{ic|>}}`{=mediawiki}.
-   Reload the page with `{{ic|r}}`{=mediawiki}, stop the loading with `{{ic|Ctrl+c}}`{=mediawiki}.
-   Re-open last closed tab with `{{ic|u}}`{=mediawiki}.
-   Open downloads page by pressing `{{ic|g}}`{=mediawiki} followed by `{{ic|d}}`{=mediawiki} (or
    `{{ic|Shift+d}}`{=mediawiki} for a new tab).
-   Copy URI to primary selection with `{{ic|y}}`{=mediawiki}.
-   View page source code with `{{ic|:viewsource}}`{=mediawiki}. Return to normal view with
    `{{ic|:viewsource!}}`{=mediawiki}.
-   View image source by pressing `{{ic|;}}`{=mediawiki} followed by `{{ic|i}}`{=mediawiki} (or
    `{{ic|Shift+i}}`{=mediawiki} for new tab).
-   Inspect elements with `{{ic|:inspect}}`{=mediawiki}. Repeat to open in a new window. Disable inspector with
    `{{ic|:inspect!}}`{=mediawiki}.

### Input fields {#input_fields}

Many webpages have editable elements like dropdown lists, checkboxes, text fields and so on. While they work perfectly
with the mouse, you may encounter some troubles using the *follow* commands. In such a case, pressing the arrow keys may
help. Alternatively, the `{{ic|g}}`{=mediawiki} `{{ic|i}}`{=mediawiki} shortcut can be used to focus input.

### Bookmarks

If enabled (default configuration), bookmarks can be used from within Luakit.

-   The `{{ic|:bookmarks}}`{=mediawiki} command opens the bookmarks page. (Shortcut: `{{ic|g}}`{=mediawiki} followed by
    `{{ic|b}}`{=mediawiki}, or `{{ic|Shift+b}}`{=mediawiki} for a new tab).
-   The `{{ic|:bookmark [''URI'' [''tags'']]}}`{=mediawiki} command adds the URI specified (or the current tab\'s URI,
    if omitted) to the bookmarks by specified tags. Starting from version 2012-09-13-r1, bookmarks page will be opened
    (new tab) in new bookmark editing mode before saving. (Shortcut: `{{ic|Shift+b}}`{=mediawiki}).

## Configuration

Configuration is done in `{{ic|~/.config/luakit/userconf.lua}}`{=mediawiki}. It is not necessary anymore to copy and
modify `{{ic|rc.lua}}`{=mediawiki}. Some settings can also be modified with the `{{ic|:settings}}`{=mediawiki} command,
unless you set them in `{{ic|userconf.lua}}`{=mediawiki} with:

```{=mediawiki}
{{hc|~/.config/luakit/userconf.lua|2=
local settings = require "settings"
settings.example = "some value"
}}
```
### Key bindings {#key_bindings}

Most bindings will require some knowledge of Luakit, but you can at least do simple things rebinding:

```{=mediawiki}
{{hc|~/.config/luakit/userconf.lua|2=
local modes = require "modes"

-- Creates new bindings from old ones.
modes.remap_binds("normal", -- This is the mode in which the bindings are active.
  {
  --  new     old     removes the old binding (defaults to false)
     {"O",    "t",    true},
  -- define as many as you wish
    {"Control-=", "zi"},
    ...
  })
}}
```
To bind keys to commands, you can use the following template:

```{=mediawiki}
{{hc|~/.config/luakit/userconf.lua|2=
modes.add_binds("normal", {
-- {"<key>",
--  "<description>",
--  function (w) w:enter_cmd("<command>") end}
  {"O", "Open URL in a new tab.",
   function (w) w:enter_cmd(":tabopen ") end},
   ...
})
}}
```
For inspiration, see `{{ic|/usr/share/luakit/lib/binds.lua}}`{=mediawiki}, where the default bindings are defined.

### Homepage

Set your homepage as follows:

```{=mediawiki}
{{hc|~/.config/luakit/userconf.lua|2=
settings.window.home_page = "www.example.com"
}}
```
### Custom search engines {#custom_search_engines}

To search with the default search engine, press `{{ic|o}}`{=mediawiki} and type the phrases. To search with a different
engine, type its name after `{{ic|o}}`{=mediawiki} and then the phrases.

You can virtually add any search engine you want. Make a search on the website you want and copy paste the URI to the
Luakit configuration by replacing the searched terms with an `{{ic|%s}}`{=mediawiki}. Example:

```{=mediawiki}
{{hc|~/.config/luakit/userconf.lua|2=<nowiki>
local engines = settings.window.search_engines
engines.aur          = "https://aur.archlinux.org/packages?K=%s"
engines.aw           = "https://wiki.archlinux.org/index.php/Special:Search?fulltext=Search&search=%s"
engines.googleseceng = "https://www.google.com/search?name=f&hl=en&q=%s"
</nowiki>}}
```
The variable is used as a keyword for the `{{ic|:open}}`{=mediawiki} command in Luakit.

Set the default search engine by using this same keyword:

```{=mediawiki}
{{hc|~/.config/luakit/userconf.lua|2=
engines.default = engines.aur
}}
```
Instead of strings, you can defined search engines as functions that return a string. For instance, here is a Wikipedia
search engine that lets you specify a language (defaulting to English):

```{=mediawiki}
{{hc|~/.config/luakit/userconf.lua|2=
engines.wikipedia = function (arg)
  local l, s = arg:match("^(%a%a):%s*(.+)")
  if l then
    return "https://" .. l .. ".wikipedia.org/wiki/Special:Search?search=" .. s
  else
    return "https://en.wikipedia.org/wiki/Special:Search?search=" .. arg
  end
end,
}}
```
If called as `{{ic|:open wikipedia arch linux}}`{=mediawiki}, this will open the Arch Linux page on the English
Wikipedia; with `{{ic|:open wikipedia fr: arch linux}}`{=mediawiki}, this will use the French Wikipedia instead.

### Download location {#download_location}

To specify download location:

```{=mediawiki}
{{hc|~/.config/luakit/userconf.lua|2=
require "downloads"
downloads.default_dir = os.getenv("HOME") .. "/mydir"
}}
```
Default location is `{{ic|$XDG_DOWNLOAD_DIR}}`{=mediawiki} if it exists, `{{ic|$HOME/downloads}}`{=mediawiki} otherwise.

### Adblock

Adblock is loaded by default, but you need to:

-   Fetch an adblock-compatible list, like [Easylist](https://easylist-downloads.adblockplus.org/easylist.txt), and save
    it to `{{ic|~/.local/share/luakit/adblock}}`{=mediawiki}.
-   Restart Luakit to load the extension.
-   Use `{{ic|:adblock-list-enable ''number''}}`{=mediawiki} command within Luakit to turn Adblock\'s list(s) you
    downloaded on Adblock itself becomes enabled on startup.

Full info on enabled lists and AdBlock state can be found using `{{ic|:adblock}}`{=mediawiki} or `{{ic|g}}`{=mediawiki}
`{{ic|Shift+a}}`{=mediawiki} at `{{ic|luakit://adblock/}}`{=mediawiki} internal page, if the
`{{ic|adblock_chrome}}`{=mediawiki} module is enabled, which is not a mandatory part.

```{=mediawiki}
{{Note|For Adblock to run in '''normal''' mode, {{ic|easylist.txt}} and any others must be placed in {{ic|~/.local/share/luakit/adblock}}}}
```
### Bookmarks management {#bookmarks_management}

#### Sync

Starting from version 2012.09.13, Luakit bookmarks are stored in an SQLite database:
`{{ic|~/.local/share/luakit/bookmarks.db}}`{=mediawiki}.

You can put a symbolic link in place of the default file to store your bookmarks anywhere on your machine. This way if
your are using a cloud sync application like Dropbox, you can keep your bookmarks synchronized between your different
computers.

#### Converting plain text bookmarks to SQLite format {#converting_plain_text_bookmarks_to_sqlite_format}

Bookmarks were stored in a simple plain text file: `{{ic|~/.local/share/luakit/bookmarks}}`{=mediawiki}. Each line is a
bookmark. It is composed of 2 fields, the *link* and the *group* which are separated by a *tab* character.

```{=mediawiki}
{{Warning|If spaces are inserted instead of tabulation character, the link will not be properly bookmarked.}}
```
```{=mediawiki}
{{Note|Groups and links are alphabetically sorted, so there is no need to do it manually.}}
```
To use bookmarks with the latest Luakit release, the file must be converted. A sample Lua script will do that:

```{=mediawiki}
{{hc|bookmarks_plain_to_sqlite.lua|<nowiki>
local usage = [[Usage: luakit -c bookmarks_plain_to_sqlite.lua [bookmark plaintext path] [bookmark db path]
]]

local old_db_path, new_db_path = unpack(uris)

if not old_db_path or not new_db_path then
   io.stdout:write(usage)
   luakit.quit(1)
end

-- One-pass file read into 'data' var.
old_db = assert(io.open(old_db_path, "r"))
local data = old_db:read("*all")
assert(old_db:close())

-- Init new_db, otherwise sqlite queries will fail.
new_db = sqlite3{ filename = new_db_path }
new_db:exec("CREATE TABLE IF NOT EXISTS bookmarks (id INTEGER PRIMARY KEY, uri TEXT NOT NULL, title TEXT NOT NULL, desc TEXT NOT NULL, tags TEXT NOT NULL, created INTEGER, modified INTEGER )")

-- Fill
local url,tag

for line in data:gmatch("[^\n]*\n?") do

   if string.len(line) > 1 then

      print ("["..line.."]")

      -- Get url and tag (if present) from first line.
      _, _, url, tag = string.find(line, "([^\n\t]+)\t*([^\n]*)\n?")

      -- Optional yet convenient output.
      io.write(url)
      io.write("\t")
      io.write(tag)
      io.write("\n")

      -- DB insertion. Nothing will be overwritten. If URL and/or tag already exists, then a double is created.
      new_db:exec("INSERT INTO bookmarks VALUES (NULL, ?, ?, ?, ?, ?, ?)",
                  {
                     url, "", "", tag or "",
                     os.time(), os.time()
                  })
      end
end

print("Import finished.")
print("\nVacuuming database...")
new_db:exec "VACUUM"
print("Vacuum done.")

luakit.quit(0)
</nowiki>}}
```
As stated at beginning of the script, it must be ran with Luakit:

`$ luakit -c bookmarks_plain_to_sqlite.lua `*`path/to/plaintext/bookmark`*` `*`path/to/db`*

The old plaintext bookmarks will be left unchanged. If the DB bookmarks do not exist, the file will be created. If it
exists, do not worry, none of the previous bookmarks will be touched. However, this behaviour implies that you might get
some doubles.

#### Import from Firefox {#import_from_firefox}

To import bookmarks from Firefox, first they must be exported to an HTML file using its bookmarks manager. After that
the XML file can be converted to a Luakit format.

The following one-line awk command will do that:

```{=mediawiki}
{{bc|<nowiki>
$ cat bookmarks.html | awk '
{gsub(/\"/," ")}
/<\/H3>/{FS=">";gsub(/</,">");og=g;g=$(NF-2);FS=" "}
/<DL>/{x++;if(x>= 3)gl[x-3]=g}
/<\/DL>/{x--;if(x==2)g=og"2"}
/HREF/{gsub(/</," ");gsub(/>/," ");if(g!=""){if(og!=g){printf "\n";og=g};printf "%s\t",$4;if(x>=3){for(i=0;i<=x-4;i++){printf "%s-",gl[i]}printf "%s\n",gl[x-3]}else{printf "\n"}}
```
}\' `</nowiki>`{=html}}}

The more readable version of the script:

```{=mediawiki}
{{hc|ff2lk.awk|<nowiki>
# Notes: 'folders' for Firefox bookmarks mean 'groups' for Luakit.

# Put spaces where it is needed to delimit words properly.
{gsub(/\"/," ")}

# Since the folder name may have spaces, delimiter must be ">" here.
/<\/H3>/ {
    FS=">"
    gsub(/</,">")
    oldgroup=group
    group=$(NF-2)
    FS=" "
}

# Each time a <DL> is encountered, it means we step into a subfolder.
# 'count' is the depth level.
# Base level starts at 2 (Firefox fault).
# 'groupline' is an array of all parent folders.
/<DL>/ {
    count++
    if ( count >= 3 )
        groupline[count-3]=group
}

# On </DL>, we step out.
# If if return to the base level (i.e. not in a folder), then we give 'group' a fake name different
# from 'oldgroup' to make sure a line will be skipped (see below).
/<\/DL>/ {
    count--
    if( count == 2 )
        group=oldgroup"ROOT"
}

# The bookmark name.
# If oldgroup is different than group, (i.e. folder changed) then we skip a line.
# If we are in a folder, then we print the group name, i.e. all parents plus the current folder
# separated by an hyphen.
/HREF/ {
    gsub(/</," ")
    gsub(/>/," ")
    if (group != "")
    {
        if(oldgroup != group)
        {
            printf "\n"
            oldgroup=group
        }
        printf "%s\t",$4
        if ( count >= 3 )
        {
            for ( i=0 ; i <= count-4 ; i++ )
            {printf "%s-" , groupline[i]}
            printf "%s" , groupline[count-3]
        }
        printf "\n"
    }
}</nowiki>
}}
```
Run it with

`$ awk -f ff2lk.awk bookmarks.html >> bookmarks`

Then convert the generated plain text bookmarks to the SQLite format as described at [#Converting plain text bookmarks
to SQLite format](#Converting_plain_text_bookmarks_to_SQLite_format "wikilink").

#### Export bookmarks {#export_bookmarks}

The following script let you export Luakit bookmarks from its SQLite format to a plain text file. The resulting file may
be suitable for other web browsers, or may be easily parsed by import scripts.

```{=mediawiki}
{{hc|bookmarks_sqlite_to_plain.lua|<nowiki>
-- USER CONFIG

local sep = " "

-- END OF USER CONFIG

local usage = [[Usage: luakit -c bookmarks_sqlite_to_plain.lua [bookmark db path] [bookmark plain path]

DB scheme is

    bookmarks (
        id INTEGER PRIMARY KEY,
        uri TEXT NOT NULL,
        title TEXT NOT NULL,
        desc TEXT NOT NULL,
        tags TEXT NOT NULL,
        created INTEGER,
        modified INTEGER
    );
]]

local old_db_path, new_db_path = unpack(uris)

if not old_db_path or not new_db_path then
   io.stdout:write(usage)
   luakit.quit(1)
end

-- One-pass file read into 'data' var.
new_db = assert(io.open(new_db_path, "w"))

-- Open old_db
old_db = sqlite3{ filename = old_db_path }

-- Load all db values to a string variable.
local rows = old_db:exec [[ SELECT * FROM bookmarks ]]

-- Iterate over all entries.
-- Note: it could be faster to use one single concatenation for all entries, but
-- it would be much more code and not so flexible. It is desirable to focus on
-- clarity. After all, only a few hundred lines are handled.
for _, b in ipairs(rows) do

   -- Change %q for %s to remove double quotes if needed.
   -- You can toggle the desired fields with comments.
   local outputstr =
      string.format("%q%s", b.uri or "", sep) ..
      string.format("%q%s", b.title or "", sep) ..
      string.format("%q%s", b.desc or "", sep) ..
      string.format("%q%s- ", b.tags or "", sep) ..
      ((b.created or "" ) .. sep) ..
      ((b.modified or "" ) .. sep) ..
      "\n"

   -- Write entry to file.
   new_db:write(outputstr)
end


print("Export done.")

assert(new_db:close())

luakit.quit(0)</nowiki>
}}
```
As stated at beginning of the script, it must be ran with Luakit:

`$ luakit -c bookmarks_plain_to_sqlite.lua `*`path/to/plaintext/bookmarks`*` `*`path/to/database`*

### Tor

Once [Tor](Tor "wikilink") has been setup, simply run:

`$ torsocks luakit --nounique`

```{=mediawiki}
{{Warning|To be sure of anonymity, you also need to change settings within Luakit, such as disabling Flash and changing the useragent string.}}
```
### Custom CSS {#custom_css}

Locate the `{{ic|styles}}`{=mediawiki} sub-directory within luakit\'s data storage directory. Normally, this is located
at `{{ic|~/.local/share/luakit/styles/}}`{=mediawiki}. Create the directory if it does not already exist. Move any CSS
rules to a new file within that directory. The filename must end in `{{ic|.css}}`{=mediawiki}. Make sure you specify
which sites your stylesheet should apply to. The way to do this is to use `{{ic|@-moz-document}}`{=mediawiki} rules. The
Stylish wiki page [Applying styles to specific
sites](https://github.com/stylish-userstyles/stylish/wiki/Applying-styles-to-specific-sites) may be helpful. Run
`{{ic|:styles-reload}}`{=mediawiki} to detect new stylesheet files and reload any changes to existing stylesheet files;
it is not necessary to restart luakit.

To open the styles menu, run the command `{{ic|:styles-list}}`{=mediawiki}. Here you can enable/disable stylesheets,
open stylesheets in your text editor, and view which stylesheets are active.

If a stylesheet is disabled for all pages, its state will be listed as \"Disabled\". If a stylesheet is enabled for all
pages, but does not apply to the current page, its state will be listed as \"Enabled\". If a stylesheet is enbaled for
all pages \_and\_ it applies to the current page, its state will be listed as \"Active\".

## See also {#see_also}

-   [Home page](https://luakit.github.io/)
-   [Cheatsheet](http://shariebeth.com/computers/luakitcheatsheet.txt)

[Category:Web browser](Category:Web_browser "wikilink")

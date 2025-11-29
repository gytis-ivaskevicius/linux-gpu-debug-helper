#!/usr/bin/env bash

wiki_page() {
    local url="$1"
    local output_file="$2"

    [[ ! "$url" =~ \?action=raw ]] && url="${url}?action=raw"

    local temp_file=$(mktemp)
    trap 'rm -f "$temp_file"' RETURN

    if ! curl -s "$url" -o "$temp_file"; then
        echo "✗ Failed to download $url"
        return 1
    fi

    if pandoc -f mediawiki -t markdown "$temp_file" --columns=120 -o "$output_file" 2>/dev/null; then
        echo "✓ Successfully exported $url to: $output_file"
    else
        echo "⚠ Pandoc conversion failed, using raw MediaWiki content instead..."
        mv "$temp_file" "$output_file"
        echo "✓ Successfully saved raw content from $url to: $output_file"
    fi
}

wiki_category() {
    local category_url="$1"
    local output_dir="$2"
    local category_name="${category_url##*/Category:}"
    
    # Detect wiki type and extract base URL accordingly
    local base_url url_path api_path
    if [[ "$category_url" =~ wiki\.nixos\.org ]]; then
        base_url="${category_url%%/wiki/*}"
        url_path="/wiki/"
        api_path="/w/api.php"
    else
        base_url="${category_url%%/title/*}"
        url_path="/title/"
        api_path="/api.php"
    fi
    
    echo "Fetching pages from category: $category_name"
    mkdir -p "$output_dir"
    
    # Fetch and parse category members
    curl -s "${base_url}${api_path}?action=query&list=categorymembers&cmtitle=Category:${category_name}&cmlimit=500&format=json" \
        | grep -o '"title":"[^"]*"' \
        | sed 's/"title":"//;s/"//' \
        | grep -v "^Category:" \
        | while IFS= read -r title; do
            [[ -z "$title" ]] && continue
            
            local file="${output_dir}/$(echo "$title" | tr '[:upper:] ' '[:lower:]_' | sed 's/[^a-z0-9_-]/_/g').md"
            local url="${base_url}${url_path}${title// /_}"
            
            echo "Downloading: $title"
            wiki_page "$url" "$file"
        done
    
    echo "✓ Downloaded pages from category '$category_name' to: $output_dir"
}


rm -rf arch nixos

wiki_category https://wiki.nixos.org/wiki/Category:Video nixos/graphics
wiki_category https://wiki.nixos.org/wiki/Category:Gaming nixos/gaming
wiki_category https://wiki.nixos.org/wiki/Category:Web_Browser  nixos/browsers

wiki_category https://wiki.archlinux.org/title/Category:Graphics arch/graphics
wiki_category https://wiki.archlinux.org/title/Category:Gaming arch/gaming
wiki_category https://wiki.archlinux.org/title/Category:Web_browser arch/browsers
wiki_page https://wiki.archlinux.org/title/Xorg arch/xorg.md
wiki_page https://wiki.archlinux.org/title/Multihead arch/multihead.md

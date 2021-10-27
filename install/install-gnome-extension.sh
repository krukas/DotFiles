#!/bin/bash

uuid="$1"
gnome_version=$(gnome-shell --version | cut -d' ' -f3)
base_url="https://extensions.gnome.org"

get_donwload_link () {
    # args: the uuid of the extension (eg removeaccesibility@lomegor)
    info_url="${base_url}/extension-info/?uuid=${1}&shell_version=${gnome_version}"
    echo "${base_url}$(curl "$info_url" | sed -e 's/.*"download_url": "\([^"]*\)".*/\1/')"
}

# Create temp dir
temp=$(mktemp -d)

# Download extension
url=$(get_donwload_link "$uuid")
curl -L "$url" > "$temp/e.zip"


# Install and enable extension
gnome-extensions install "$temp/e.zip" --force
gnome-extensions enable "$uuid"

# cleanup
rm -rfv "$temp"
#!/bin/zsh
# Strip query string from a URL and copy to clipboard.
# Usage: strip-url-params.sh <url>
#        echo <url> | strip-url-params.sh

if [[ $# -gt 0 ]]; then
    url="$1"
else
    url=$(cat)
fi

echo -n "${url%%\?*}" | pbcopy
echo "Copied: ${url%%\?*}"

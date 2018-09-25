#!/bin/sh

function chrome_compare {
    local url1=$1
    local url2=$2

    mkdir -p /tmp/chrome_compare
    case $(uname) in
        Darwin)
            open -na "Google Chrome" --args --user-data-dir="/tmp/chrome_compare" ${url1} ${url2}
        ;;
        *)
            echo "Unknown architecture: $(uname)"
    esac
}

alias my_chrome_compare=chrome_compare
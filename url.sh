#!/bin/bash

# Function to add "https://" prefix to the URL
addHTTPsPrefix() {
    local url="$1"
    if [[ ! $url == http* ]]; then
        url="https://$url"
    fi
    echo "$url"
}

# Function to check if the domain is alive
check_url() {
    local url="$1"
    local status_code=$(curl -Is "$url" -o /dev/null -w '%{http_code}')
    if [[ $status_code -ge 200 && $status_code -lt 400 ]]; then
        echo -e "\nThis domain is alive"
        echo "URL: $url Status code: $status_code"
        aliveDomain+=("$url")
    else
        echo -e "\nThis domain is not alive"
        echo "URL: $url Status code: $status_code"
    fi
}

# Array to store alive domains
aliveDomain=()

# Check for a valid URL argument
if [[ -z $1 ]]; then
    echo "Usage: $0 -u <URL>"
    exit 1
fi

# Parse command-line arguments
while getopts ":u:" opt; do
    case $opt in
        u)
            url="$OPTARG"
            url=$(addHTTPsPrefix "$url")
            check_url "$url"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Print the alive domains (if any)
if [[ ${#aliveDomain[@]} -gt 0 ]]; then
    echo -e "\nAlive domains:"
    printf '%s\n' "${aliveDomain[@]}"
fi

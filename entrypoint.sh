#!/bin/sh

set -e

# Check if incomming command contains flags
if [ "${1#-}" != "$1" ] || [ -z "$(command -v "$1")" ]; then
    set -- curl "$@"
fi

exec "$@"

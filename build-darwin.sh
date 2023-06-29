#!bin/sh
HOST=${1}

if [ -z "${HOST}" ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

nix build .#darwinConfigurations.${HOST}.system
./result/sw/bin/darwin-rebuild switch --flake .#${HOST}

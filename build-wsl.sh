#!bin/sh
HOST=${1}

if [ -z "${HOST}" ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

nix build ".#homeConfigurations.${HOST}.activationPackage" # product a result folder
./result/activate

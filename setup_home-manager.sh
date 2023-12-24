#!env bash
set -x

# home-manager isn't installed via OS config, and is on the user profile - if needed, install:
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
# For complicated reasons, may need to re-login here for the next command to work
nix-shell '<home-manager>' -A install

# Invoked off of current username
home-manager --flake github:jbgreer/Nixfiles switch

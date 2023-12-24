#!env bash
set -x

# By default the generated configuration.nix is practically empty so we can overwrite it - feel free to review it first or move it
curl -sSL https://raw.githubusercontent.com/jbgreer/Nixfiles/main/.config/nixos/systems/bootstrap.nix -o /mnt/etc/nixos/configuration.nix

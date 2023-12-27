#!env bash
set -x

# Create directories to be mounted
mkdir -p /persist/etc/NetworkManager/system-connections
mkdir -p /persist/etc/nixos
mkdir -p /persist/etc/secureboot
mkdir -p /persist/passwords
mkdir -p /persist/var/lib/bluetooth
mkdir -p /persist/var/lib/colord
mkdir -p /persist/var/lib/fprint
mkdir -p /persist/var/lib/NetworkManager
mkdir -p /persist/var/lib/power-profiles-daemon
mkdir -p /persist/var/lib/systemd,upower
mkdir -p /persist/var/lib/upower

# Copy any existing configuration items
cp -R /etc/NetworkManager/system-connections/* /persist/etc/NetworkManager/system-connections/
cp -R /etc/nixos/* /persist/etc/nixos/
cp -R /etc/secureboot/* /persist/etc/secureboot/

# Move system ID and state files
mv /etc/machine-id /persist/etc/machine-id
mv /var/lib/NetworkManager/secret_key /persist/var/lib/NetworkManager/secret_key
mv /var/lib/networkManager/seen-bssids /persist/var/lib/NetworkManager/seen-bssids
mv /var/lib/NetworkManager/timestampes /persist/var/lib/NetworkManager/timestamps

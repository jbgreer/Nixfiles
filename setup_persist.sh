#!env bash
set -x

# Create directories to be mounted
mkdir -p /persist/etc/{NetworkManager/system-connections,nixos,secureboot}
mkdir -p /persist/passwords
mkdir -p /persist/var/lib/{bluetooth,colord,docker,fprint,NetworkManager,power-profiles-daemon,systemd,tailscale,upower}

# Copy any existing configuration items
cp -R {,/persist}/etc/NetworkManager/system-connections
cp -R {,/persist}/etc/nixos
cp -R {,/persist}/etc/secureboot

# Move system ID and state files
mv {,/persist}/etc/machine-id
mv {,/persist}/var/lib/NetworkManager/secret_key
mv {,/persist}/var/lib/NetworkManager/seen-bssids
mv {,/persist}/var/lib/NetworkManager/timestamps
mv {,/persist}/var/lib/power-profiles-daemon/state.ini

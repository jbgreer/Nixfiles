set -x

# Create directories to be mounted
sudo mkdir -p /persist/etc/NetworkManager/system-connections
sudo mkdir -p /persist/etc/nixos
sudo mkdir -p /persist/passwords
sudo mkdir -p /persist/var/lib/bluetooth
sudo mkdir -p /persist/var/lib/fprint
sudo mkdir -p /persist/var/lib/NetworkManager
sudo mkdir -p /persist/var/lib/power-profiles-daemon
sudo mkdir -p /persist/var/lib/systemd
sudo mkdir -p /persist/var/lib/upower

# Copy any existing configuration items
sudo cp -R /etc/NetworkManager/system-connections/* /persist/etc/NetworkManager/system-connections/
sudo cp -R /etc/nixos/* /persist/etc/nixos/

# Move system ID and state files
sudo mv /etc/machine-id /persist/etc/machine-id
sudo mv /var/lib/NetworkManager/secret_key /persist/var/lib/NetworkManager/secret_key
sudo mv /var/lib/networkManager/seen-bssids /persist/var/lib/NetworkManager/seen-bssids
sudo mv /var/lib/NetworkManager/timestamps /persist/var/lib/NetworkManager/timestamps

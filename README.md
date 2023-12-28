# Encrypted persistent NixOS Setup using LUKS, LVM, btrfs, and Impermanence.

## Modified from https://github.com/kjhoerr/dotfile.git
## Work in progress.  Use at your own discretion.  You have been warned.

## Goals:
### Define all systems and user profiles under a common [flake.nix](./flake.nix). 
### Update all systems targetting this flake via

   ```bash
    # Invoked off of current hostname
    sudo nixos-rebuild --flake github:jbgreer/Nixfiles switch
   ```

### Update user home configurations against this flake as well:

   ```bash
    # Invoked off of current username
    home-manager --flake github:jbgreer/Nixfiles switch
   ```

Auto-upgrade and garbage collection is enabled using the default daily frequency and targets `github:jbgreer/dotfiles` as above. 
Note: This option does not exist yet for home-manager flake configurations.

## Installation Note: most of these steps require root

0. Download & burn installation media from ```https://nixos.org/download.html#nixos-iso```

1. Boot from NixOS install media.  I am using NixOS 23.11 minimal install.

2. If you need to setup WiFi, check the NixOS manual.  

   ```bash
   sudo systemctl start wpa_supplicant
   wpa_cli
       add_network
       set_network 0 ssid "SID"
       set_network 0 psk "PASSWORD"
       set_network 0 key_mgmt WPA-PSK
       enable_network 0 
       quit
   ```

3. Fetch partition setup script

   ```bash
    curl -sSL https://raw.githubusercontent.com/jbgreer/Nixfiles/main/setup_partitions.sh -o setup_partisions.sh
   ```

4. Set up partitions using ```sudo setup_partitions.sh```
   
5. Generate configuration using ```sudo nixos-generate-config --root /mnt```

6. Edit ```/mnt/etc/nixos/configuration.nix``` or use the bootstrap version.  Edit the hostname at least.

   ```bash
    curl -sSL https://raw.githubusercontent.com/jbgreer/Nixfiles/main/.config/nixos/systems/configuration_bootstrap.nix -o /mnt/etc/nixos/configuration.nix
   ```

7. Edit ```/mnt/etc/nixos/hardware-configuration.nix``` or insert boostrap_hardware.nix into it.

   ```bash
    curl -sSL https://raw.githubusercontent.com/jbgreer/Nixfiles/main/.config/nixos/systems/hardware_bootstrap.nix -o hardware_bootstrap.nix
   ```

8. Install OS using ````sudo nixos-install````

9. Reboot

10.  Reconnect to the network using NetworkManager

   ```bash
   nmcli device wifi connect SID password PASSWD
   ```

11. Pull Impermanenace setup script 

   ```bash
    curl -sSL https://raw.githubusercontent.com/jbgreer/Nixfiles/main/setup_persist.sh > setup_persist.sh
   ```

12. Setup Impermanence using ````setup_persist.sh````

13. Impermanence clears passwords stored in `/etc/shadow`, so recreate these in the persist subvolume for each user:

   ```bash
   mkpasswd --method=SHA-512 1>/persist/passwords/jbgreer
   ```

14. Modify system configuration flake. 

TODO

15. Copy `/etc/nixos/hardware-configuration.nix` into the systems folder to match the hostname.

16. Reboot again.

17. Install home-manager and use flake for initial generation

22. If at first you don't succeed, you're about average.


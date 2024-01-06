# Encrypted NixOS Setup using LUKS, LVM, btrfs

## Modified from https://github.com/kjhoerr/dotfile.git
## Work in progress.  Use at your own discretion.  You have been warned.

## Goals:
### Define all systems and user profiles under a common [flake.nix](./flake.nix). 
### Update all systems targetting this flake via

   ```bash
    # Invoked off of current hostname
    sudo nixos-rebuild --flake github:jbgreer/Nixfiles/basic switch
   ```

### Update user home configurations against this flake as well:

   ```bash
    # Invoked off of current username
    home-manager --flake github:jbgreer/Nixfiles/basic switch
   ```

Auto-upgrade and garbage collection is enabled using the default daily frequency and targets `github:jbgreer/Nixfiles/basic` as above. 
Note: This option does not exist yet for home-manager flake configurations.

## Installation Note: most of these steps require root

0. Download & burn installation media from ```https://nixos.org/download.html#nixos-iso```

1. Boot from NixOS install media.  I am using NixOS 23.11 minimal install.

2. Login as nixos

3. If you need to setup WiFi, check the NixOS manual.  

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

4. Setup partitions by fetching the partition setup script and running

   ```bash
    curl -sSL https://raw.githubusercontent.com/jbgreer/Nixfiles/basic/install.sh -o install.sh
    sh ./install
   ```

5. Edit ```/mnt/etc/nixos/hardware-configuration.nix``` or insert boostrap_hardware.nix into it.

   ```bash
    curl -sSL https://raw.githubusercontent.com/jbgreer/Nixfiles/basic/hardware_bootstrap.nix -o hardware_bootstrap.nix
   ```

6. Install OS using ````sudo nixos-install````

7. Reboot

8. Login as root

9. Set password for non-root user

   ```bash
    passwd USER
   ```

10. Logout and back in as USER

11.  Reconnect to the network using NetworkManager

   ```bash
   nmcli device wifi connect SID password PASSWD
   ```

TODO

12. Modify ```/etc/nixos/configuration.nix```.

13. Copy `/etc/nixos/hardware-configuration.nix` into the systems folder to match the hostname.

14. Reboot again.

15. Install Home Manager

   ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
   nix-channel --update
   # you will likely to to logout and back in
   nix-shell '<home-manager>' -A install
   ```

16. Use flake for initial generation

If at first you don't succeed, you're about average.


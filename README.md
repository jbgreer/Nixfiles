# Secure, persistent NixOS Setup using LVM, btrfs, and Impermanence.

## Modified from https://github.com/kjhoerr/dotfile.git
## Work in progress.  Use at your own discretion.  You have been warned.

## Goals:
### Define all systems and user profiles under a common [flake.nix](./flake.nix). 
### Update all systems targetting this flake via

   ```bash
    # Invoked off of current hostname
    sudo nixos-rebuild --flake github:jbgreer/dotfiles switch
   ```

### Update user home configurations against this flake as well:

   ```bash
    # Invoked off of current username
    home-manager --flake github:jbgreer/dotfiles switch
   ```

Auto-upgrade and garbage collection is enabled using the default daily frequency and targets `github:jbgreer/dotfiles` as above. 
Note: This option does not exist yet for home-manager flake configurations.

## Installation Note: most of these steps require root

0. Download & burn installation media from https://nixos.org/download.html#nixos-iso

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

3. Fetch partition setup and bootstrap configuration files

   ```bash
    curl -sSL https://githubusercontent.com/jbgreer/Nixfiles/main/setup_partitions.sh
    curl -sSL https://githubusercontent.com/jbgreer/Nixfiles/main/pull_bootstrap.sh
   ```

4. Set up partitions using ```sudo setup_partitions.sh```
   
5. Generate configuration using ```sudo nixos-generate-config --root /mnt```

6. Pull the bootstrap config using ````pull_bootstrap.sh````

7. Install OS using ````sudo nixos-install````

8. Reboot

9. Create secureboot keys. These keys do not need to be enrolled yet if secure boot is not enabled.

   ```bash
   sudo sbctl create-keys
   ```

10. Pull Impermanenace setup script 

   ```bash
    curl -sSL https://githubusercontent.com/jbgreer/Nixfiles/main/setup_persist.sh
   ```

11. Setup Impermanence using ````setup_persist.sh````

12. Impermanence clears passwords stored in `/etc/shadow`, so recreate these in the persist subvolume for each user:

   ```bash
   mkpasswd --method=SHA-512 1>/persist/passwords/jbgreer
   ```

13. Modify system configuration flake. 

14. Copy `/etc/nixos/hardware-configuration.nix` into the systems folder to match the hostname.

15. Reboot again.

16. Enroll secureboot keys.  This may require erasing UEFI secure boot settings.

   ```bash
   sudo sbctl enroll-keys -- --microsoft
   ```

17. Verify secure boot.  Sign files?

   ```bash
   sudo sbctl verify
   sudo sbctl sign -s /boot/vmlinuz-linux
   sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
   sudo sbctl status
   ```

18. Enable TPM unlocking using systemd-cryptenroll.

   ```bash
   sudo systemd-cryptenroll --tpm2-device=list
  # And added to a device's configuration:
  # boot.initrd.kernelModules = [ "tpm_tis" ];
  # Must be enabled by hand - e.g.
   sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2 --tpm2-device=auto --tpm2-pcrs=0+2+7
   ```

19. Install home-manager and use flake for initial generation

20. If at first you don't succeed, you're about average.


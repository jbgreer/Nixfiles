# Secure, persistent NixOS Setup using LVM, btrfs, and Impermanence.

## Modified from https://github.com/kjhoerr/dotfile.git
## Work in progress.  Use at your own discretion.  You have been warned.

### Note: most of these steps require root

1. Boot from NixOS install media.  I am using NixOS 23.11 minimal install.

   https://nixos.org/download.html#nixos-iso

2. Set up partitions using ```sudo setup_partitions.sh```
   
3. Generate configuration  using ```sudo nixos-generate-config --root /mnt```

4. Pull the bootstrap config from this repository using ````pull_bootstrap.sh````

5. Install OS using ````sudo nixos-install````

6. Reboot

7. Create secureboot keys. These keys do not need to be enrolled yet if secure boot is not enabled.

   ```bash
   sudo sbctl create-keys
   ```

7. Setup persistence using ````setup_persist.sh````

8. Impermanence clears passwords stored in `/etc/shadow`, so recreate these in the persist subvolume for each user:

   ```bash
   mkpasswd --method=SHA-512 1>/persist/passwords/jbgreer
   ```

9. Modify system configuration flake. 

10. Copy `/etc/nixos/hardware-configuration.nix` into the systems folder to match the hostname.

10. Reboot again.

11. Enroll secureboot keys.  This may require erasing UEFI secure boot settings.

   ```bash
   sudo sbctl enroll-keys -- --microsoft
   ```

13. Verify secure boot.  Sign files?

   ```bash
   sudo sbctl verify
   sudo sbctl sign -s /boot/vmlinuz-linux
   sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
   sudo sbctl status
   ```

14. Enable TPM unlocking using systemd-cryptenroll.

   ```bash
   sudo systemd-cryptenroll --tpm2-device=list
  # And added to a device's configuration:
  # boot.initrd.kernelModules = [ "tpm_tis" ];
  # Must be enabled by hand - e.g.
   sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p2 --tpm2-device=auto --tpm2-pcrs=0+2+7
   ```

15. Install home-manager and use flake for initial generation

16. If at first you don't succeed, you're about average.


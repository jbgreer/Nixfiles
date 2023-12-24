# NixOS Setup

Lifted from https://github.com/kjhoerr/dotfile.git

## Instructions for adding a new NixOS system [WIP]

1. Boot from NixOS install media. I always use the GNOME iso just in case I want to play around with something, but the minimal iso should be more than feasible.

   https://nixos.org/download.html#nixos-iso

2. Set up partitions using setup_partitions.sh, running as root
   
3. Generate configuration based on the hardware and pull the bootstrap config from this repository
   ```bash
   nixos-generate-config --root /mnt
   
   # By default the generated configuration.nix is practically empty so we can overwrite it - feel free to review it first or move it
   curl -sSL https://raw.githubusercontent.com/jbgreer/Nixfiles/main/.config/nixos/systems/bootstrap.nix -o /mnt/etc/nixos/configuration.nix
   ```

4. Edit the `hardware-configuration.nix`.   Correct UUIDs, etc.


5. Once edits are complete all that should be left to do is:

   ```bash
   nixos-install
   ```

6. After reboot, we need to create the secureboot keys. These keys do not need to be enrolled yet as long as secure boot is not enabled.

   ```bash
   # Create new keys and add to /etc/secureboot
   sbctl create-keys
   ```

7. setup persistence.


8. Impermanence also clears passwords stored in `/etc/shadow`, so these must be stored separately in the persist subvolume for each user:

   ```bash
   # Run for each user - change $user to username
   mkpasswd --method=SHA-512 1>/persist/passwords/jbgreer
   ```

-----

## TODO: expand final steps

9. Create or modify system configuration flake. Copy `/etc/nixos/hardware-configuration.nix` into the systems folder to match the hostname.

10. Reboot again.

11. Enroll sb keys.

12. Enable TPM unlocking using systemd-cryptenroll.

13. Install home-manager and use flake for initial generation


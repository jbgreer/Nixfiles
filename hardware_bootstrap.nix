# hardware_bootstrap.nix

  # encrypted root partition
  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-partlabel/ROOTPART";
    preLVM = true;
  };

  # btrfs subvolumes on rootfs
  fileSystems."/" =
    { device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/ROOTFS";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  # UEFI boot fs
  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOTFS";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/SWAPFS"; }
    ];


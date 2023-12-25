# hardware_bootstrap.nix

# snippet for devices 

  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-uuid/<ENC>";
    preLVM = true;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/<BTRFS>";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/<BTRFS>";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/<BTRFS>";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/<BTRFS>";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/<BTRFS>";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/<VFAT>";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/<SWAP>"; }
    ];

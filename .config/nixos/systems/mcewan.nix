# mcewan.nix
{ lib, pkgs, ... }: {

  networking.hostName = "mcewan";

  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ 
        "xhci_pci" 
        "ahci" 
        "nvme" 
        "usbhid"
        "usb_storage" 
        "sd_mod" 
      ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices."enc" = {
        device = "/dev/disk/by-partlabel/ROOTPART";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [
      "cpufreq.default_governor=powersave"
      "initcall_blacklist=cpufreq_gov_userspace_init"
    ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    supportedFilesystems = [ "btrfs" "ntfs" "fat32" ];
  };

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

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

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOTFS";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/SWAPFS"; }
    ];
  
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  # User accounts
  users.mutableUsers = true;

  users.users.jbgreer = {
    isNormalUser = true;
    description = "Jim Greer";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  # packages for root that would otherwise be in home-manager
  users.users.root.packages = with pkgs; [
    bind
    git
    neovim
  ];

  environment.systemPackages = with pkgs; [
    git
  ];

  networking.useDHCP = lib.mkDefault true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  system.stateVersion = "23.11";

  nix.settings.experimental-features = "nix-command flakes";
}


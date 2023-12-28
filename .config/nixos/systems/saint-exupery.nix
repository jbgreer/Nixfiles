# saint-exupery.nix
{ lib, pkgs, ... }: {

  networking.hostName = "saint-exupery";

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-partlabel/ROOTPART";
    preLVM = true;
  };

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
  hardware.cpu.amd.updateMicrocode = true;

  # Enable LVFS testing to get UEFI updates
  services.fwupd.extraRemotes = [ "lvfs-testing" ];

  boot.kernelParams = [
    "cpufreq.default_governor=powersave"
    "initcall_blacklist=cpufreq_gov_userspace_init"
  ];

  security.pam.services.login.fprintAuth = false;
  # similarly to how other distributions handle the fingerprinting login
  security.pam.services.gdm-fingerprint.text = ''
    auth       required                    pam_shells.so
    auth       requisite                   pam_nologin.so
    auth       requisite                   pam_faillock.so      preauth
    auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
    auth       optional                    pam_permit.so
    auth       required                    pam_env.so
    account    include                     login
    password   required                    pam_deny.so
    session    include                     login
  '';

  # User accounts
  users.mutableUsers = false;

  users.users.jbgreer = {
    isNormalUser = true;
    description = "Jim Greer";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPasswordFile = "/persist/passwords/jbgreer";
  };

  environment.systemPackages = with pkgs; [
    dmidecode
    git
    pciutils
  ];

  networking.useDHCP = lib.mkDefault true;
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "23.11";

  nix.settings.experimental-features = "nix-command flakes";
}


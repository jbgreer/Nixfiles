# bootstrap.nix
# Designed as first-boot configuration (bootstrap) for impermanence systems
# Run nixos-generate-config --root=/mnt for hardware scan then overwrite with this as configuration.nix
# Then you can reboot and get SecureBoot, TPM, /persist, and whatever else set up and use flakes to install
{ pkgs, lib, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.supportedFilesystems = [ "btrfs" "ntfs" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableAllFirmware = true;

  # Enable networking
  networking.hostName = "tmp";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jbgreer = {
    isNormalUser = true;
    description = "Jim Greer";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      bind
      git
      #starship
      pfetch
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    gcc
    gnupg
    sbctl
    tpm2-tss
    git
  ];

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  #services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "23.11";

  nix.settings.experimental-features = "nix-command flakes";
}
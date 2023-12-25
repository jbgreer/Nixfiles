{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      <nixos-hardware/framework/13-inch/7040-amd>
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "saint-exupery";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.jbgreer = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      curl      
      git
      neovim
      unzip
      wget
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # DANGER.  Do not edit without studying impact.
  system.stateVersion = "23.11";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}


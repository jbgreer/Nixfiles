# system.nix
# Common system configuration
{ lib, pkgs, ... }: {

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  environment.systemPackages = (with pkgs; [
    git
    gnupg
    neovim
  ]);

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';
}


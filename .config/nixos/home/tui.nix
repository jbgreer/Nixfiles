# tui.nix
{ lib, pkgs, ... }: {

  # Use lib.mkDefault where possible so user config can override without lib.mkForce
  # Install packages via programs.* where possible as may include extra config OOTB that the package does not
  programs.zsh.enable = lib.mkDefault true;
  programs.home-manager.enable = lib.mkDefault true;
  programs.starship.enable = lib.mkDefault true;

  home.packages = lib.mkBefore (with pkgs; [
    file
    ripgrep
    ag
  ]);
}


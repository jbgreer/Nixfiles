# home/jbgreer.nix
# Requires home-manager flake
{ pkgs, ... }: {

  home.username = "jbgreer";
  home.homeDirectory = "/home/jbgreer";

  home.packages = with pkgs; [
    # package list here
    neovim
  ];

  home.stateVersion = "23.11";
}


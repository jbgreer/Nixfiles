# home/jbgreer.nix
# Requires home-manager flake
{ pkgs, ... }: {

  home.username = "jbgreer";
  home.homeDirectory = "/home/jbgreer";

  home.packages = with pkgs; [
    neofetch
    openssh
  ];

  home.stateVersion = "23.11";
}


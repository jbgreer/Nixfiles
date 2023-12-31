# upgrade.nix
{ lib, ... }: {

  # Enable automatic upgrades through this flake repository
  system.autoUpgrade = {
    enable = lib.mkDefault true;
    flake = lib.mkDefault "github:jbreer/Nixfiles/basic";
  };

  # Since automatic updates are enabled, automatically gc older generations
  # this will gc home-manager user profiles as well
  nix.gc = {
    automatic = lib.mkDefault true;
    options = lib.mkDefault "--delete-older-than 14d";
  };

  # Enable nix-community public binary cache, for potential build skips on flakes
  nix.settings = {
    substituters = lib.mkDefault [ "https://nix-community.cachix.org" "https://cache.nixos.org/" ];
    trusted-public-keys = lib.mkDefault [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  # Disable network targets due to common upgrade issues
  systemd = {
    targets.network-online.wantedBy = lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # Normally ["network-online.target"]
  };
}


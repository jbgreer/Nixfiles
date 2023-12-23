{
  inputs = {
    nixos-pkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };

    # persistence
    impermanence.url = "github:nix-community/impermanence";

    # speccific module suport for hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
 
    # fw ectool for Framework 13-inch 7040 AMD - TODO check status
    fw-ectool = {
      url = "github:tlvince/ectool.nix";
      inputs.nixpkgs.follows = "nixos-pkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs: 
    let
      system = "x86_64-linux";
      lib= inputs.nixos-pkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      osOverlays = [
        (_: _: { fw-ectool = inputs.fw-ectool.packages.${system}.ectool; })
      ];

      homeModules = [
        ./.config/nixos/home/git.nix
        ./.config/nixos/home/gpg-agent.nix
        ./.config/nixos/home/neovim.nix
        ./.config/nixos/home/tui.nix
      ];

      guiModules = [
      ];
 
      serverHomeModules = [
      ];

      osModules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.impermanence.nixosModules.impermanence
        inputs.nixos-hardware.nixosModules.common-hidpi
	./.config/nixos/os/persist.nix
	./.config/nixos/os/secure-boot.nix
	./.config/nixos/os/system.nix
	./.config/nixos/os/upgrade.nix
	{
	  nixpkgs.overlays = osOverlays;
	}
      ];

      # fn for home config
      homeUser = (userModules: inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = homeModules ++ guiModules ++ userModules;
      });

      # fn for nixos config 
      nixosSystem = (systemModules: lib.nixosSystem {
        inherit system;
        modules = systemModules ++ osModules;
      });

    in {

      homeConfigurations = {

        jbgreer = homeUser [ ./.config/nixos/users/jbgreer.nix ];

      }; 

      nixosConfigurations = {

        saint-exupery = nixosSystem [
          inputs.nixos-hardware.nixosModules.framework-13-7040-amd
          ./.config/nixos/systems/saint-exupery.nix
        ];
      };
    };
}

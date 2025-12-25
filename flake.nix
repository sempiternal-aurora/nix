{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    isabelle-lsp-nvim = {
      url = "github:Treeniks/isabelle-lsp.nvim";
      flake = false;
    };

    isabelle-syn-nvim = {
      url = "github:Treeniks/isabelle-syn.nvim";
      flake = false;
    };

    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Deprecated and no longer maintained
    # chaotic-nyx = {
    #   url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };

    nix-doom-emacs = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur = {
    #   url = "github:nix-community/nur";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-parts.follows = "flake-parts";
    # };
    #
    # flake-parts = {
    #   url = "github:hercules-ci/flake-parts";
    #   inputs.nixpkgs-lib.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations.default = self.nixosConfigurations.coimpiutair;

      nixosConfigurations.myria-live-image = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          vars = {
            adminUser = "nixos";
            configuration = "myria-live-image";
          };
        };
        modules = [
          ./hosts/myria-live-image/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.coimpiutair = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          vars = {
            adminUser = "aurora";
            localUser = "myria";
            configuration = "coimpiutair";
          };
        };
        modules = [
          ./hosts/coimpiutair/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.bocsa = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          vars = {
            adminUser = "nyla";
            configuration = "bocsa";
          };
        };
        modules = [
          ./hosts/bocsa/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}

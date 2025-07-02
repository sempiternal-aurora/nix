{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

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
          };
        };
        modules = [
          ./hosts/myria-live-image/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.coimpiutair = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          vars = {
            adminUser = "aurora";
            localUser = "myria";
          };
        };
        modules = [
          ./hosts/coimpiutair/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.bocsa = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          vars = {
            adminUser = "nyla";
          };
        };
        modules = [
          ./hosts/bocsa/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}

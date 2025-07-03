{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-unstable-small = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    isabelle-lsp-nvim = {
      url = "github:Treeniks/isabelle-lsp.nvim";
      flake = false;
    };

    isabelle-syn-nvim = {
      url = "github:Treeniks/isabelle-syn.nvim";
      flake = false;
    };

    textfox-unstable = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    textfox-unstable-small = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs-unstable-small";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable-small,
      nixpkgs-unstable,
      ...
    }@inputs:
    {
      nixosConfigurations.default = self.nixosConfigurations.coimpiutair;

      nixosConfigurations.myria-live-image = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs // {
            textfox = inputs.textfox-unstable;
            home-manager = inputs.home-manager-unstable;
          };
          vars = {
            adminUser = "nixos";
            configuration = "myria-live-image";
          };
        };
        modules = [
          ./hosts/myria-live-image/configuration.nix
          inputs.home-manager-unstable.nixosModules.default
        ];
      };

      nixosConfigurations.coimpiutair = nixpkgs-unstable-small.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs // {
            textfox = inputs.textfox-unstable-small;
            home-manager = inputs.home-manager-unstable-small;
          };
          vars = {
            adminUser = "aurora";
            localUser = "myria";
            configuration = "coimpiutair";
          };
        };
        modules = [
          ./hosts/coimpiutair/configuration.nix
          inputs.home-manager-unstable-small.nixosModules.default
        ];
      };

      nixosConfigurations.bocsa = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs // {
            textfox = inputs.textfox-unstable;
            home-manager = inputs.home-manager-unstable;
          };
          vars = {
            adminUser = "nyla";
            configuration = "bocsa";
          };
        };
        modules = [
          ./hosts/bocsa/configuration.nix
          inputs.home-manager-unstable.nixosModules.default
        ];
      };
    };
}

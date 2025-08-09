{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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
      inputs.nur.follows = "nur-unstable";
    };

    nur-unstable = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-parts.follows = "flake-parts-unstable";
    };

    flake-parts-unstable = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
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

      nixosConfigurations.coimpiutair = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs // {
            textfox = inputs.textfox-unstable;
            home-manager = inputs.home-manager-unstable;
          };
          vars = {
            adminUser = "aurora";
            localUser = "myria";
            configuration = "coimpiutair";
          };
        };
        modules = [
          ./hosts/coimpiutair/configuration.nix
          inputs.home-manager-unstable.nixosModules.default
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

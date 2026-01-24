{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.cachyos-kernel.follows = "cachyos-kernel";
      inputs.cachyos-kernel-patches.follows = "cachyos-kernel-patches";
    };

    cachyos-kernel-patches = {
      url = "github:CachyOS/kernel-patches";
      flake = false;
    };

    cachyos-kernel = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };

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
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        default = self.nixosConfigurations.coimpiutair;

        myria-live-image = nixpkgs.lib.nixosSystem {
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

        coimpiutair = nixpkgs.lib.nixosSystem {
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

        bocsa = nixpkgs.lib.nixosSystem {
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

      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./hosts/macbook/configuration.nix ];
        specialArgs = {
          inherit inputs;
          vars = {
            adminUser = "myria";
            configuration = "macbook";
          };
        };
      };

      homeConfigurations.macbook =
        let
          system = "aarch64-linux";
          pkgs = import nixpkgs {
	    inherit system;
	  };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            userName = "myria";
            vars = {
              adminUser = "myria";
              configuration = "macbook";
            };
          };
          modules = [
            ./hosts/macbook/home.nix
          ];
        };
    };
}

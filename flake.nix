{
    description = "Nixos config flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # home-manager = {
        #   url = "github:nix-community/home-manager";
        #   inputs.nixpkgs.follows = "nixpkgs";
        # };
    };

    outputs = { self, nixpkgs, ... }@inputs: {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
            specialArgs = { 
                inherit inputs; 
                vars = { 
                    adminUser = "aurora"; 
                    localUser = "myria";
                };
            };
            modules = [
                ./configuration.nix
                # inputs.home-manager.nixosModules.default
            ];
        };
    };
}

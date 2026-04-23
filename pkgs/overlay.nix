final: prev: {
  afp = final.callPackage ./afp/package.nix { };
  petro_bot = final.callPackage ./petro_bot/package.nix { };
  stm32cubeide = final.callPackage ./stm32cubeide/package.nix { };
}

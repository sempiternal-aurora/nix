{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.mine.isabelle;
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  system = "x86_64-linux";
  isabelle-pkg = pkgs.callPackage ./isabelle-pkg.nix {
    inherit inputs;
    java = pkgs.jdk;
  };
in {
  options = {
    mine.isabelle.enable = lib.mkEnableOption "Install Isabelle";
    mine.isabelle.enableNeovimIntegration = lib.mkEnableOption "Setup Isabelle neovim extension";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = lib.mkIf cfg.enableNeovimIntegration {
      overlays = [
        (final: prev: {
          vimPlugins =
            prev.vimPlugins
            // {
              isabelle-lsp-nvim = prev.vimUtils.buildVimPlugin {
                name = "isabelle-lsp.nvim";
                src = inputs.isabelle-lsp-nvim;
                dependencies = [final.vimPlugins.nvim-lspconfig];
              };
              isabelle-syn-nvim = prev.vimUtils.buildVimPlugin {
                name = "isabelle-syn.nvim";
                src = inputs.isabelle-syn-nvim;
              };
            };
          isabelle = inputs.isabelle-nixpkgs.legacyPackages."${system}".isabelle.overrideAttrs (_: {
            isabelle-components = [inputs.isabelle-nixpkgs.legacyPackages."${system}".isabelle-components.isabelle-linter];
          });
        })
      ];
    };

    programs.neovim.plugins = lib.mkIf cfg.enableNeovimIntegration (with pkgs.vimPlugins; [
      {
        plugin = isabelle-lsp-nvim;
        config = toLua ''
          local isabellelsp = require("isabelle-lsp")

          isabellelsp.setup({
              isabelle_path = "${pkgs.isabelle}/bin/isabelle",
              unicode_symbols = true,
          })

          local lspconfig = require("lspconfig")

          lspconfig.isabelle.setup({})
        '';
      }
      isabelle-syn-nvim
    ]);

    home.packages = [pkgs.isabelle];

    # home.file.".isabelle/isabelle-lsp" = {
    #   enable = cfg.enableNeovimIntegration;
    #   recursive = true;
    #   source = inputs.isabelle;
    #   onChange = "pwd > ~/pwd.txt";
    # };
  };
}

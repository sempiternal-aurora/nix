{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.mine.isabelle;
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
    nixpkgs = {
      #lib.mkIf cfg.enableNeovimIntegration {
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
          isabelle = prev.isabelle.overrideAttrs {
            dontCheckForBrokenSymlinks = true;
          };
        })
      ];
    };

    programs.neovim.plugins = lib.mkIf cfg.enableNeovimIntegration (with pkgs.vimPlugins; [
      {
        plugin = isabelle-lsp-nvim;
        config = "lua << EOF\n${builtins.readFile ./source/isabelle.lua}\nEOF\n";
      }
      isabelle-syn-nvim
    ]);

    home.packages = [pkgs.isabelle];

    home.file.".isabelle/isabelle-lsp" = {
      enable = cfg.enableNeovimIntegration;
      recursive = true;
      source = inputs.isabelle;
      onChange = "pwd > ~/pwd.txt";
    };
  };
}

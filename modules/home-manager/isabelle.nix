{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.mine.isabelle;
in
{
  options = {
    mine.isabelle.enable = lib.mkEnableOption "Install Isabelle";
    mine.isabelle.enableNeovimIntegration = lib.mkEnableOption "Setup Isabelle neovim extension";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = lib.mkIf cfg.enableNeovimIntegration {
      overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins // {
            isabelle-lsp-nvim = prev.vimUtils.buildVimPlugin {
              name = "isabelle-lsp.nvim";
              src = inputs.isabelle-lsp-nvim;
              dependencies = [ final.vimPlugins.nvim-lspconfig ];
            };
            isabelle-syn-nvim = prev.vimUtils.buildVimPlugin {
              name = "isabelle-syn.nvim";
              src = inputs.isabelle-syn-nvim;
            };
          };
        })
      ];
    };

    programs.neovim.plugins = lib.mkIf cfg.enableNeovimIntegration (
      with pkgs.vimPlugins;
      [
        {
          plugin = isabelle-lsp-nvim;
          type = "lua";
          config = ''
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
      ]
    );

    home.packages = [
      (pkgs.isabelle.withComponents (p: [ p.isabelle-linter ]))
    ];

    # home.file.".isabelle/isabelle-lsp" = {
    #   enable = cfg.enableNeovimIntegration;
    #   recursive = true;
    #   source = inputs.isabelle;
    #   onChange = "pwd > ~/pwd.txt";
    # };
  };
}

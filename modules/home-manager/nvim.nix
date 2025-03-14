{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.mine.nvim;
in {
  options = {
    mine.nvim.enable = lib.mkEnableOption "enable neovim";
    mine.nvim.default = lib.mkEnableOption "set nvim as the default editor";
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/json" = ["nvim.desktop"];
        "text/*" = ["nvim.desktop"];
      };
    };

    programs.neovim = let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in {
      enable = true;
      defaultEditor = cfg.default;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [
        ripgrep
        fd

        # nix config
        nil
        alejandra

        # lua config
        lua-language-server
        stylua
      ];

      plugins = with pkgs.vimPlugins; [
        # colorscheme
        {
          plugin = dracula-nvim;
          config = toLua ''
            require("dracula").setup({ colors = { comment = "#B2A4D4", } })
            vim.cmd("colorscheme dracula")
          '';
        }
        # status line
        {
          plugin = lualine-nvim;
          config = toLua "require(\"lualine\").setup { options = { theme = \"dracula-nvim\" } }";
        }
        # git
        {
          plugin = vim-fugitive;
          config = toLuaFile ./source/fugitive.lua;
        }
        {
          plugin = gitsigns-nvim;
          config = toLua "require(\"gitsigns\").setup()";
        }
        # pretty finding tui
        {
          plugin = telescope-nvim;
          config = toLua "require('telescope').setup({})";
        }
        # undo handling
        undotree
        # easy multi-file switching
        {
          plugin = harpoon2;
          config = toLuaFile ./source/harpoon.lua;
        }
        # linting
        {
          plugin = nvim-lint;
          config = toLuaFile ./source/lint.lua;
        }
        # formatting
        {
          plugin = conform-nvim;
          config = toLuaFile ./source/conform.lua;
        }
        # completion support
        {
          plugin = nvim-cmp;
          config = toLuaFile ./source/cmp.lua;
        }
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline

        # Snippets
        luasnip
        cmp_luasnip

        # notifications bottom left
        {
          plugin = fidget-nvim;
          config = toLua "require('fidget').setup({})";
        }

        # cool icons
        lspkind-nvim
        nvim-web-devicons

        # comment selected lines
        {
          plugin = comment-nvim;
          config = toLua ''
            require("Comment").setup {
                toggler = {
                    line = ",cc",
                    block = ",Cc",
                },
                opleader = {
                    line = ",c",
                    block = ",C",
                },
                mappings = {
                    basic = true,
                    extra = false,
                },
            }
          '';
        }
        # language support
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./source/lsp.lua;
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          config = toLua ''
            require("nvim-treesitter.configs").setup({
                indent = { enable = true },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "markdown" },
                },
            })
          '';
        }
        haskell-tools-nvim
      ];

      extraLuaConfig = ''

        ${builtins.readFile ./source/set.lua}
        ${builtins.readFile ./source/remap.lua}
        local harpoon = require("harpoon")

        -- Plugin keybinds
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
      '';
    };
  };
}

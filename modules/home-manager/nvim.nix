{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mine.nvim;
in
{
  options = {
    mine.nvim.enable = lib.mkEnableOption "enable neovim";
    mine.nvim.default = lib.mkEnableOption "set nvim as the default editor";
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/json" = [ "nvim.desktop" ];
        "text/*" = [ "nvim.desktop" ];
      };
    };

    programs.neovim = {
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
        nixfmt-rfc-style

        # lua config
        lua-language-server
        stylua
      ];

      plugins = with pkgs.vimPlugins; [
        # colorscheme
        {
          plugin = dracula-nvim;
          type = "lua";
          config = ''
            require("dracula").setup { colors = { comment = "#B2A4D4" } }
            vim.cmd("colorscheme dracula")
          '';
        }
        # status line
        {
          plugin = lualine-nvim;
          type = "lua";
          config = "require('lualine').setup { options = { theme = 'dracula-nvim' } }";
        }
        # git
        {
          plugin = vim-fugitive;
          type = "lua";
          config = builtins.readFile ./source/fugitive.lua;
        }
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = "require('gitsigns').setup()";
        }
        # pretty finding tui
        {
          plugin = telescope-nvim;
          type = "lua";
          config = "require('telescope').setup {}";
        }
        # undo handling
        undotree
        # easy multi-file switching
        {
          plugin = harpoon2;
          type = "lua";
          config = builtins.readFile ./source/harpoon.lua;
        }
        # linting
        {
          plugin = nvim-lint;
          type = "lua";
          config = builtins.readFile ./source/lint.lua;
        }
        # formatting
        {
          plugin = conform-nvim;
          type = "lua";
          config = builtins.readFile ./source/conform.lua;
        }
        # completion support
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./source/cmp.lua;
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
          type = "lua";
          config = "require('fidget').setup({})";
        }

        # cool icons
        lspkind-nvim
        nvim-web-devicons

        # comment selected lines
        {
          plugin = comment-nvim;
          type = "lua";
          config = ''
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
          type = "lua";
          config = builtins.readFile ./source/lsp.lua;
        }
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = ''
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
        ${builtins.readFile ./source/langs.lua}
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

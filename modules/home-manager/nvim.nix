{
    lib,
    config,
    inputs,
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
                "application/json"  = [ "nvim.desktop" ];
                "text/*"            = [ "nvim.desktop" ];
            };
        };

        programs.neovim = let
            toLua = str: "lua << EOF\n${str}\nEOF\n";
            toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
        in
        {
            enable = true;
            defaultEditor = cfg.default;

            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;

            extraPackages = with pkgs; [
                ripgrep
                fd
                nil
                lua-language-server
            ];

            plugins = with pkgs.vimPlugins; [
                {
                    plugin = dracula-nvim;
                    config = toLua ''
                        require("dracula").setup({ colors = { comment = "#B2A4D4", } })
                        vim.cmd("colorscheme dracula")
                    '';
                }
                haskell-tools-nvim
                plenary-nvim
                nvim-web-devicons
                {
                    plugin = nvim-lint;
                    config = toLua "require(\"lint\").linters_by_ft = { python = { \"ruff\" } }";
                }
                {
                    plugin = vim-fugitive;
                    config = toLuaFile ./source/fugitive.lua;
                }
                {
                    plugin = lualine-nvim;
                    config = toLua "require(\"lualine\").setup { options = { theme = \"dracula-nvim\" } }";
                }
                {
                    plugin = telescope-nvim;
                    config = toLua "require('telescope').setup({})";
                }
                {
                    plugin = (nvim-treesitter.withPlugins (p: with p; [
                        c nix lua rust vimdoc haskell typescript javascript
                        rust latex php python vim bash java css desktop diff
                        git_config gitcommit gitignore ini json make markdown
                        markdown_inline perl query toml yaml zathurarc
                    ]));
                    config = toLua ''
                        require("nvim-treesitter.configs").setup({
                            indent = { enable = true },
                            highlight = { additional_vim_regex_highlighting = { "markdown" }, },
                        })
                    '';
                }
                undotree
                {
                    plugin = harpoon2;
                    config = toLuaFile ./source/harpoon.lua;
                }
                {
                    plugin = nvim-cmp;
                    config = toLuaFile ./source/cmp.lua;
                }
                cmp-nvim-lsp
                cmp-buffer
                cmp-path
                cmp-cmdline
                luasnip
                cmp_luasnip
                {
                    plugin = fidget-nvim;
                    config = toLua "require('fidget').setup({})";
                }
                lspkind-nvim
                {
                    plugin = nvim-lspconfig;
                    config = toLuaFile ./source/lsp.lua;
                }
            ];

            extraLuaConfig = ''

                ${builtins.readFile ./source/set.lua}
                ${builtins.readFile ./source/remap.lua}
                ${builtins.readFile ./source/autoformatter.lua}

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

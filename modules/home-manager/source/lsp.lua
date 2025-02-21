local configs = require("lspconfig.configs")

vim.filetype.add({
    extension = {
        par = "parol",
    },
})

if not configs.parol_ls then
    configs.parol_ls = {
        default_config = {
            cmd = { "parol-ls", "--stdio" },
            filetypes = { "parol" },
            root_dir = function(fname)
                return require("lspconfig").util.find_git_ancestor(fname)
            end,
        },
    }
end

local servers = {
    rust_analyzer = {},
    pyright = {},
    intelephense = {},
    clangd = {},
    --jdtls = {},
    volar = {},
    nil_ls = { settings = { nix = { flake = { autoArchive = true } } } },
    ts_ls = {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        init_options = {
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = vim.fn.stdpath("data")
                        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                    languages = { "vue" },
                },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
                diagnostics = {
                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                },
            },
        },
    },
    parol_ls = {},
}
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
    vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

local on_attach = function(_, bufnr)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, buffer = bufnr })
end

for server, server_opts in pairs(servers) do
    if server_opts then
        server_opts.capabilities = capabilities
        server_opts.on_attach = on_attach
        require("lspconfig")[server].setup(server_opts)
    end
end

require("conform").setup({
    formatters_by_ft = {
        nix = { "nixfmt" },
        lua = { "stylua" },
        python = { "isort", "ruff_format" },
        rust = { "rustfmt" },
    },
    formatters = {
        stylua = {
            args = {
                "--search-parent-directories",
                "--indent-type",
                "Spaces",
                "--respect-ignores",
                "--stdin-filepath",
                "$FILENAME",
                "-",
            },
        },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})

vim.api.nvim_create_augroup("AutoFormat", {})

vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.py",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !black --quiet %")
            vim.cmd("edit")
        end,
    }
)

vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.js,*.vue,*.mjs,*.cjs",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !npx prettier --write %")
            vim.cmd("edit")
        end,
    }
)

--vim.api.nvim_create_autocmd(
--    "BufWritePost",
--    {
--        pattern = "*.rs",
--        group = "AutoFormat",
--        callback = function()
--            vim.cmd("silent !cargo --quiet fmt")
--            vim.cmd("edit")
--        end,
--    }
--)


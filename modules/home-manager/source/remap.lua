vim.g.mapleader = ","
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("n", "<leader>p", [["+p]])
vim.keymap.set("n", "<leader>P", [["+P]])
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("x", "<leader>P", [["_d"+P]])

-- next  greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy)
vim.keymap.set("n", "<leader>w", function()
    local i = vim.opt.wrap:get()
    vim.opt.wrap = not i
    vim.opt.linebreak = not i
end)

vim.keymap.set("n", "<leader>t", "<cmd>split +term<CR>")
vim.keymap.set("n", "<leader>m", function()
    -- TODO man stuff
    vim.fn.Man(vim.fn.input("man "))
end)

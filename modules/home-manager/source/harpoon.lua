local harpoon = require("harpoon")
-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<C-e>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<C-h>", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-j>", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-k>", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-l>", function()
    harpoon:list():select(4)
end)
vim.keymap.set("n", "<C-;>", function()
    harpoon:list():select(5)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-D>", function()
    harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-R>", function()
    harpoon:list():next()
end)

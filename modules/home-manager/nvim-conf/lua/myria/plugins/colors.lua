return {
    "Mofiqul/dracula.nvim",
    config = function()
        local dracula = require("dracula")
        dracula.setup({
            colors = {
                comment = "#B2A4D4",
            }   
        })
	    vim.cmd("colorscheme dracula")
    end
}

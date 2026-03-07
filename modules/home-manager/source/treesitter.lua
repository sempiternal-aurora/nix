local parsers = {
    "asm",
    "awk",
    "bash",
    "bibtex",
    "c",
    "cmake",
    "comment",
    "cpp",
    "css",
    "csv",
    "desktop",
    "diff",
    "dockerfile",
    "fish",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "haskell",
    "html",
    "http",
    "idris",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "kconfig",
    "kitty",
    "latex",
    "llvm",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "matlab",
    "menhir",
    "meson",
    "nasm",
    "nginx",
    "nix",
    "ocaml",
    "ocaml_interface",
    "ocamllex",
    "php",
    "phpdoc",
    "python",
    "regex",
    "rst",
    "ruby",
    "rust",
    "scss",
    "ssh_config",
    "sql",
    "sway",
    "systemverilog",
    "typst",
    "toml",
    "tsx",
    "typescript",
    "vhdl",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zathurarc",
    "zig",
    "zsh",
}

-- Not every tree-sitter parser is the same as the file type detected
-- So the patterns need to be registered more cleverly
local patterns = {}
for _, parser in ipairs(parsers) do
    local parser_patterns = vim.treesitter.language.get_filetypes(parser)
    for _, pp in pairs(parser_patterns) do
        table.insert(patterns, pp)
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = patterns,
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.bo.syntax = "ON"
    end,
})

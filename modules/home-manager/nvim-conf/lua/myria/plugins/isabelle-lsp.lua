return {
    'Treeniks/isabelle-lsp.nvim',
    dependencies = {
        'neovim/nvim-lspconfig'
    },
    config = function()
        local isabellelsp = require('isabelle-lsp');

        isabellelsp.setup({
            isabelle_path = '/home/myria/.isabelle/isabelle-lsp/bin/isabelle',
            unicode_symbols = true,
        });

        local lspconfig = require('lspconfig');

        lspconfig.isabelle.setup({});
    end
}

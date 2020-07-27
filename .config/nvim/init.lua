local lsp = require('nvim_lsp')

local on_attach = function(_, bufnr)
    -- vim.api.nvim_command(
    -- 'autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()')

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    require'diagnostic'.on_attach()
    require'completion'.on_attach({
        sorter = 'alphabet',
        matcher = {'exact', 'fuzzy'}
    })

    -- Mappings.
    local opts = {noremap = true, silent = true}
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',
                                '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',
                                '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
                                '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',
                                '<cmd>lua vim.lsp.buf.implementation()<CR>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',
                                '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D',
                                '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr',
                                '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
                                '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',
                                '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>',
                                opts)
end

lsp.gopls.setup {
    on_attach = on_attach,
    init_options = {analyses = {composite = false, composites = false}},
    settings = {gopls = {usePlaceholders = true, completeUnimported = true}}
}

lsp.tsserver.setup {}

lsp.sumneko_lua.setup {
    cmd = {"/usr/bin/lua-language-server"},
    on_attach = on_attach,
    settings = {
        Lua = {
            completion = {keywordSnippet = "Disable"},
            runtime = {version = "LuaJIT"},
            diagnostics = {
                enable = true,
                globals = {
                    "vim", "Color", "c", "Group", "g", "s", "describe", "it",
                    "before_each", "after_each"
                }
            }
        }
    }
}

lsp.jsonls.setup {}

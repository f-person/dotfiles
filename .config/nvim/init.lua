local lsp = require('lspconfig')

local on_attach = function(_, bufnr)
    -- require'diagnostic'.on_attach()

    require'completion'.on_attach({
        sorter = 'none',
        matcher = {'substring', 'exact', 'fuzzy'}
    })

    -- Mappings
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
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',
                                '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>h',
                                '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    -- Telescope mappings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
                                "<cmd>lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_dropdown({}))<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rg',
                                "<cmd>lua require'telescope.builtin'.live_grep()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-p>',
                                "<cmd>lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({}))<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>pf',
                                "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ws',
                                "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols(require('telescope.themes').get_dropdown({}))<CR>",
                                opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false

lsp.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {analyses = {composite = false, composites = false}},
    settings = {gopls = {usePlaceholders = true, completeUnimported = true}}
}

lsp.tsserver.setup {on_attach = on_attach}

require'nlua.lsp.nvim'.setup(require 'lspconfig', {
    on_attach = on_attach,
    globals = {'love'},
    disabled_diagnostics = {'lowercase-global'}
})

lsp.jsonls.setup {on_attach = on_attach}

-- lsp.dartls.setup {
-- cmd = {
-- 'dart',
-- '/home/fperson/dev/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot',
-- '--lsp'
-- },
-- on_attach = on_attach,
-- settings = {
-- dart = {
-- allowAnalytics = false,
-- checkForSdkUpdates = false,
-- showTodos = true
-- }
-- }
-- }

require'lspconfig'.pyls.setup {on_attach = on_attach}

require'lspconfig'.vimls.setup {on_attach = on_attach}

require'lspconfig'.gdscript.setup {on_attach = on_attach}

require'lspconfig'.kotlin_language_server.setup {on_attach = on_attach}

vim.lsp.callbacks['textDocument/codeAction'] =
    require'lsputil.codeAction'.code_action_handler
vim.lsp.callbacks['textDocument/references'] =
    require'lsputil.locations'.references_handler
vim.lsp.callbacks['textDocument/definition'] =
    require'lsputil.locations'.definition_handler
vim.lsp.callbacks['textDocument/declaration'] =
    require'lsputil.locations'.declaration_handler
vim.lsp.callbacks['textDocument/typeDefinition'] =
    require'lsputil.locations'.typeDefinition_handler
vim.lsp.callbacks['textDocument/implementation'] =
    require'lsputil.locations'.implementation_handler
vim.lsp.callbacks['textDocument/documentSymbol'] =
    require'lsputil.symbols'.document_handler
vim.lsp.callbacks['workspace/symbol'] =
    require'lsputil.symbols'.workspace_handler

vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {virtual_text = false, signs = true, update_in_insert = false})

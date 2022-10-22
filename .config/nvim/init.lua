vim.api.nvim_command('source ~/.config/nvim/config.vim')

require('lualine').setup {
    options = {theme = 'gruvbox'}, --
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {'encoding', 'fileformat', 'filetype', '%{CodeStatsXp()}'},
        lualine_z = {'progress', 'location'}
    },
    extensions = {'quickfix'}
}

local lsp = require('lspconfig')
local cmp = require 'cmp'

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true),
                          mode, true)
end

cmp.setup({
    snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-y>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        }),
        ['<CR>'] = cmp.mapping.confirm({select = true}),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, {"i", "s"})
    },
    sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'vsnip'}},
                                 {{name = 'buffer'}})
})

cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())

require('lspconfig')['gopls'].setup {capabilities = capabilities}

local keymap_opts = {noremap = true, silent = true}

local on_attach = function(_, bufnr)
    -- Mappings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',
                                '<Cmd>lua vim.lsp.buf.declaration()<CR>',
                                keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',
                                '<Cmd>lua vim.lsp.buf.definition()<CR>',
                                keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
                                '<Cmd>lua vim.lsp.buf.hover()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',
                                '<cmd>lua vim.lsp.buf.implementation()<CR>',
                                keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',
                                '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                                keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D',
                                '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                                keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr',
                                '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',
                                '<cmd>lua vim.diagnostic.open_float()<CR>',
                                keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca',
                                '<cmd>lua vim.lsp.buf.code_action()<CR>',
                                keymap_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd',
                                '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
                                keymap_opts)

    -- LSP-based omnifunc.
    vim.cmd('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false

lsp.gopls.setup {
    cmd = {'gopls', '--remote=auto'},
    filetypes = {'go', 'gomod'},
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {analyses = {composite = false, composites = false}},
    settings = {gopls = {usePlaceholders = true, completeUnimported = true}}
}

lsp.tsserver.setup {on_attach = on_attach}

lsp.ccls.setup {on_attach = on_attach}

require'nlua.lsp.nvim'.setup(lsp, {
    cmd = {
        '/Users/fperson/Applications/lua-language-server/bin/lua-language-server',
        '-E', '/Users/fperson/Applications/lua-language-server/main.lua'
    },
    on_attach = on_attach,
    globals = {'love'},
    disabled_diagnostics = {'lowercase-global'}
})

-- lsp.sumneko_lua.setup {
-- cmd = {
-- '/Users/fperson/Applications/lua-language-server/bin/lua-language-server'
-- },
-- globals = {'vim', 'love'},
-- on_attach = on_attach
-- }

lsp.jsonls.setup {on_attach = on_attach}

-- local dart_capabilities = vim.lsp.protocol.make_client_capabilities()
-- dart_capabilities.textDocument.codeAction =
-- {
-- codeActionLiteralSupport = {
-- codeActionKind = {
-- valueSet = {
-- "", "quickfix", "refactor", "refactor.extract",
-- "refactor.inline", "refactor.rewrite", "source",
-- "source.organizeImports"
-- }
-- }
-- }
-- }
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
-- showTodos = true,
-- suggestFromUnimportedLibraries = true
-- }
-- }
-- }

lsp.dartls.setup {cmd = {'dart', 'language-server'}, on_attach = on_attach}

lsp.pylsp.setup {on_attach = on_attach}

lsp.vimls.setup {on_attach = on_attach}

lsp.gdscript.setup {on_attach = on_attach}

lsp.kotlin_language_server.setup {on_attach = on_attach}

lsp.vuels.setup {
    on_attach = on_attach,
    init_options = {
        config = {
            vetur = {experimental = {templateInterpolationService = true}}
        }
    }
}

vim.lsp.handlers['textDocument/codeAction'] =
    require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] =
    require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] =
    require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] =
    require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] =
    require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] =
    require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] =
    require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] =
    require'lsputil.symbols'.workspace_handler

vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {virtual_text = false, signs = true, update_in_insert = false})

-- Telescope mappings
vim.api.nvim_set_keymap('n', 'gr',
                        "<cmd>lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_dropdown({}))<CR>",
                        keymap_opts)
vim.api.nvim_set_keymap('n', '<leader>rg',
                        "<cmd>lua require'telescope.builtin'.live_grep()<CR>",
                        keymap_opts)
vim.api.nvim_set_keymap('n', '<C-p>',
                        "<cmd>lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({}))<CR>",
                        keymap_opts)
vim.api.nvim_set_keymap('n', '<leader>pf',
                        "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<CR>",
                        keymap_opts)
vim.api.nvim_set_keymap('n', '<leader>ws',
                        "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols(require('telescope.themes').get_dropdown({}))<CR>",
                        keymap_opts)

require'formatter'.setup({
    logging = false,
    filetype = {
        dart = {function() return {exe = 'dartfmt', stdin = true} end},
        cpp = {
            function()
                return {
                    exe = 'clang-format',
                    args = {
                        '--assume-filename', vim.api.nvim_buf_get_name(0),
                        '--style', 'Google'
                    },
                    stdin = true,
                    cwd = vim.fn.expand('%:p:h') -- Run clang-format in cwd of the file.
                }
            end
        }
    }
})

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        -- require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell
    }
})

lsp.tsserver.setup {
    on_attach = function(client, bufnr)
        -- disable tsserver formatting if you plan on formatting via null-ls
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        local ts_utils = require("nvim-lsp-ts-utils")

        -- defaults
        ts_utils.setup {
            debug = false,
            disable_commands = false,
            enable_import_on_completion = false,

            -- import all
            import_all_timeout = 5000, -- ms
            import_all_priorities = {
                buffers = 4, -- loaded buffer names
                buffer_content = 3, -- loaded buffer content
                local_files = 2, -- git files or files with relative path markers
                same_file = 1 -- add to existing import statement
            },
            import_all_scan_buffers = 100,
            import_all_select_source = false,

            -- eslint
            eslint_enable_code_actions = true,
            eslint_enable_disable_comments = true,
            eslint_bin = "eslint",
            eslint_enable_diagnostics = true,
            eslint_opts = {},

            -- formatting
            enable_formatting = true,
            formatter = "prettier",
            formatter_opts = {},

            -- update imports on file move
            update_imports_on_move = false,
            require_confirmation_on_move = false,
            watch_dir = nil,

            -- filter diagnostics
            filter_out_diagnostics_by_severity = {},
            filter_out_diagnostics_by_code = {}
        }

        -- required to fix code action ranges and filter diagnostics
        ts_utils.setup_client(client)

        -- no default maps, so you may want to define some here
        local opts = {silent = true}
        vim.api
            .nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>",
                                    opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>",
                                    opts)

        on_attach(client, bufnr)
    end
}

local auto_dark_mode = require('auto-dark-mode')

auto_dark_mode.setup({update_interval = 5000})
auto_dark_mode.init()

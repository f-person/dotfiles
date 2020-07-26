local lsp = require('nvim_lsp')

local on_attach = function(client)
    vim.api.nvim_command(
        'autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()')

    require'diagnostic'.on_attach()
    require'completion'.on_attach({
        -- sorter = 'alphabet',
        -- matcher = {'exact', 'fuzzy'}
    })
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

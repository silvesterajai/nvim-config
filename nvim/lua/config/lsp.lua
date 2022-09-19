local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp

local utils = require("utils")

local custom_attach = function(client, bufnr)
    -- Mappings.
    local opts = { silent = true, buffer = bufnr }
    keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
    keymap.set("n", "K", vim.lsp.buf.hover, opts)
    keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    keymap.set("n", "gr", vim.lsp.buf.references, opts)
    keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    keymap.set("n", "<space>q", function() vim.diagnostic.setqflist({ open = true }) end, opts)
    keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
    keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    keymap.set("n", "<space>wl", function() inspect(vim.lsp.buf.list_workspace_folders()) end, opts)

    -- Set some key bindings conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        keymap.set("n", "<space>f", vim.lsp.buf.format, opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        keymap.set("x", "<space>f", vim.lsp.buf.range_formatting, opts)
    end

    api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local float_opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always', -- show source in diagnostic popup window
                prefix = ' '
            }

            if not vim.b.diagnostics_pos then
                vim.b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = api.nvim_win_get_cursor(0)
            if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2]) and
                #vim.diagnostic.get() > 0
            then
                vim.diagnostic.open_float(nil, float_opts)
            end

            vim.b.diagnostics_pos = cursor_pos
        end
    })

    -- The blow command will highlight the current variable and its usages in the buffer.
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]   )
    end

    if vim.g.logging_level == 'debug' then
        local msg = string.format("Language server %s started!", client.name)
        vim.notify(msg, vim.log.levels.DEBUG, { title = 'Nvim-config' })
    end
end

local capabilities = lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

-- set up bash-language-server
if utils.executable('bash-language-server') then
    lspconfig.bashls.setup({
        on_attach = custom_attach,
        capabilities = capabilities,
    })
end

-- Change diagnostic signs.
fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
vim.diagnostic.config({
    underline = false,
    virtual_text = false,
    signs = true,
    severity_sort = true,
})

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

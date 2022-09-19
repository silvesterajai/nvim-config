require('lsp-setup').setup({
    -- Default mappings
    -- gD = 'lua vim.lsp.buf.declaration()',
    -- gd = 'lua vim.lsp.buf.definition()',
    -- gt = 'lua vim.lsp.buf.type_definition()',
    -- gi = 'lua vim.lsp.buf.implementation()',
    -- gr = 'lua vim.lsp.buf.references()',
    -- K = 'lua vim.lsp.buf.hover()',
    -- ['<C-k>'] = 'lua vim.lsp.buf.signature_help()',
    -- ['<space>rn'] = 'lua vim.lsp.buf.rename()',
    -- ['<space>ca'] = 'lua vim.lsp.buf.code_action()',
    -- ['<space>f'] = 'lua vim.lsp.buf.formatting()',
    -- ['<space>e'] = 'lua vim.diagnostic.open_float()',
    -- ['[d'] = 'lua vim.diagnostic.goto_prev()',
    -- [']d'] = 'lua vim.diagnostic.goto_next()',
    default_mappings = true,
    -- Custom mappings, will overwrite the default mappings for the same key
    -- Example mappings for telescope pickers:
    -- gd = 'lua require"telescope.builtin".lsp_definitions()',
    -- gi = 'lua require"telescope.builtin".lsp_implementations()',
    -- gr = 'lua require"telescope.builtin".lsp_references()',
    mappings = {},
    -- Global on_attach
    on_attach = function(client, bufnr)
        -- Support custom the on_attach function for global
        -- Formatting on save as default
        require('lsp-setup.utils').format_on_save(client)
    end,
    -- Global capabilities
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    -- Configuration of LSP servers
    servers = {
        -- Install LSP servers automatically
        -- LSP server configuration please see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        pylsp = {},
        sumneko_lua = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            }
        },
        rust_analyzer = {
            settings = {
                ['rust-analyzer'] = {
                    cargo = {
                        loadOutDirsFromCheck = true,
                    },
                    procMacro = {
                        enable = true,
                    },
                },
            },
        },
        cmake = {},
    }, -- servers
})

local lspconfig = require 'lspconfig'
local util = require("lspconfig.util")

local on_attach = function(client, bufnr)

    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- leaving only what I actually use...
    buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

    buf_set_keymap("n", "<C-j>", "<cmd>Telescope lsp_document_symbols<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>ca", "<cmd>Telescope lsp_code_actions<CR>", opts)
    vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 })
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 })

    client.server_capabilities.document_formatting = false
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
        vim.cmd([[
			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]]     )
    end
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
lspconfig.ccls.setup {
    cmd = { "ccls" },
    filetypes = { "c", "cc", "cpp", "c++", "objc", "objcpp" },
    init_options = {
        index = {
            threads = 0;
        };
        clang = {
            excludeArgs = { "-frounding-math" };
        };
    },
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = util.root_pattern("compile_commands.json", ".ccls", ".git", ".vim", ".hg"),
}
-- lspconfig.ccls.setup {}


require("lsp_lines").setup()

vim.diagnostic.config({
    virtual_text = false,
})

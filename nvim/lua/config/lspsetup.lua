local utils = require('lsp-setup.utils')
local mappings = {
    -- Example mappings for telescope pickers
    gD = 'lua require"telescope.builtin".lsp_declaration()',
    gd = 'lua require"telescope.builtin".lsp_definitions()',
    gi = 'lua require"telescope.builtin".lsp_implementations()',
    gr = 'lua require"telescope.builtin".lsp_references()',
    go = 'lua require"telescope.builtin".lsp_document_symbols()'
}

local servers = {
    bashls = {},
    yamlls = {
        filetypes = { 'yaml', 'yml' },
        settings = {
            yaml = {
                schemas = {
                    ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                    Kubernetes = { '/*k8s.yaml', '/*k8s.yml' },
                    --['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] = '/*.k8s.yaml',
                },
            },
        },
    },
    jsonls = {},
    -- clangd = {},
    gopls = {
        settings = {
            golsp = {
                gofumpt = true,
                staticcheck = true,
                useplaceholders = true,
                codelenses = {
                    gc_details = true,
                },
            },
        },
    },
    pylsp = {},
    rust_analyzer = {
        server = {
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
    },
    sumneko_lua = require('lua-dev').setup({
        lspconfig = {
            -- on_attach = function(client, _)
            --     utils.disable_formatting(client)
            -- end,
        },
    }),
    cmake = {},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.offsetEncoding = { "utf-16" }

local settings = {
    default_mappings = true,
    mappings = mappings,
    servers = servers,
    -- Global on_attach
    on_attach = function(client, bufnr)
        require("illuminate").on_attach(client)
        -- Formatting on save as default
        if client.name == "clangd" then
            utils.disable_formatting(client)
        end
        utils.format_on_save(client)
    end,
    -- Global capabilities
    capabilities = capabilities,
}

require('lsp-setup').setup(settings)


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
    ]]   )
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

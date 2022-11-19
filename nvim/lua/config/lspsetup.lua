require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})

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
    clangd = {},
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
    sumneko_lua = {},
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

require("lsp_lines").setup()

vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = false
})

local fn = vim.fn

-- The root dir to install all plugins. Plugins are under opt/ or start/ sub-directory.
vim.g.plugin_home = fn.stdpath("data") .. "/site/pack/packer"

-- Where to install packer.nvim -- the package manager (we make it opt)
local packer_dir = vim.g.plugin_home .. "/opt/packer.nvim"

-- Whether this is a fresh install, i.e., packer itself and plugins have not been installed.
local fresh_install = false

-- Auto-install packer in case it hasn't been installed.
if fn.glob(packer_dir) == "" then
    fresh_install = true

    -- Now we need to install packer.nvim first.
    local packer_repo = "https://github.com/wbthomason/packer.nvim"
    local install_cmd = string.format("!git clone --depth=1 %s %s", packer_repo, packer_dir)

    vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})
    vim.cmd(install_cmd)
end

-- Load packer.nvim
vim.cmd("packadd packer.nvim")

local packer = require("packer")
local packer_util = require('packer.util')

packer.startup({
    function(use)
        use { 'lewis6991/impatient.nvim', config = [[require('impatient')]] }

        use { "wbthomason/packer.nvim", opt = true }

        use { "navarasu/onedark.nvim", config = [[require('config.onedark')]] }

        use { "onsails/lspkind-nvim" }

        -- nvim-lsp configuration
        use { "neovim/nvim-lspconfig" }
        use { "williamboman/mason.nvim" }
        use { "williamboman/mason-lspconfig.nvim" }
        use {
            'junnplus/lsp-setup.nvim',
            requires = {
                'neovim/nvim-lspconfig',
                'williamboman/mason.nvim',
                'williamboman/mason-lspconfig.nvim',
            },
            config = [[require('config.lspsetup')]]
        }
        use {
            'ms-jpq/coq_nvim',
            branch = 'coq',
            event = 'InsertEnter',
            config = [[require('config.coq')]]
        }
        use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }

        -- Show match number and index for searching
        use {
            'kevinhwang91/nvim-hlslens',
            branch = 'main',
            keys = { { 'n', '*' }, { 'n', '#' }, { 'n', 'n' }, { 'n', 'N' } },
            config = [[require('config.hlslens')]]
        }

        -- File search, tag search and more
        use({ "Yggdroot/LeaderF", cmd = "Leaderf", run = ":LeaderfInstallCExtension" })

        use {
            'nvim-telescope/telescope.nvim', cmd = 'Telescope',
            requires = { { 'nvim-lua/plenary.nvim' } }
        }
        -- search emoji and other symbols
        use { 'nvim-telescope/telescope-symbols.nvim', after = 'telescope.nvim' }

        -- Smoothie motions
        use({
            "karb94/neoscroll.nvim",
            event = "VimEnter",
            config = function()
                vim.defer_fn(function() require('config.neoscroll') end, 2000)
            end
        })

        use { 'kyazdani42/nvim-web-devicons', event = 'VimEnter' }

        use {
            'nvim-lualine/lualine.nvim',
            event = 'VimEnter',
            config = [[require('config.statusline')]]
        }

        use({ "akinsho/bufferline.nvim", event = "VimEnter", config = [[require('config.bufferline')]] })
        use({ "nvim-zh/better-escape.vim", event = { "InsertEnter" } })
        -- showing keybindings
        use { "folke/which-key.nvim",
            event = "VimEnter",
            config = function()
                vim.defer_fn(function() require('config.which-key') end, 2000)
            end
        }

        -- show and trim trailing whitespaces
        use { 'jdhao/whitespace.nvim', event = 'VimEnter' }

        -- file explorer
        use {
            'kyazdani42/nvim-tree.lua',
            requires = { 'kyazdani42/nvim-web-devicons' },
            config = [[require('config.nvim-tree')]]
        }
        -- Show git change (change, delete, add) signs in vim sign column
        use({ 'lewis6991/gitsigns.nvim', config = [[require('config.gitsigns')]] })

        use({ 'vladdoster/remember.nvim', config = [[ require('remember') ]] })

    end,
    config = {
        max_jobs = 16,
        compile_path = packer_util.join_paths(fn.stdpath('data'), 'site', 'lua', 'packer_compiled.lua'),
    },
})


-- For fresh install, we need to install plugins. Otherwise, we just need to require `packer_compiled.lua`.
if fresh_install then
    -- We run packer.sync() here, because only after packer.startup, can we know which plugins to install.
    -- So plugin installation should be done after the startup process.
    packer.sync()
else
    local status, _ = pcall(require, 'packer_compiled')
    if not status then
        local msg = "File packer_compiled.lua not found: run PackerSync to fix!"
        vim.notify(msg, vim.log.levels.ERROR, { title = 'nvim-config' })
    end
end

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

        -- nvim-lsp configuration
        use { "onsails/lspkind-nvim" }
        use { "neovim/nvim-lspconfig" }
        use { "williamboman/mason.nvim" }
        use { "williamboman/mason-lspconfig.nvim" }
        use { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" }
        use { "ray-x/lsp_signature.nvim" }
        use { "folke/lsp-colors.nvim" }
        use { "folke/neodev.nvim" }
        use { "RRethy/vim-illuminate" }
        use {
            'junnplus/lsp-setup.nvim',
            requires = {
                'neovim/nvim-lspconfig',
                'williamboman/mason.nvim',
                'williamboman/mason-lspconfig.nvim',
                "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
                "ray-x/lsp_signature.nvim",
                "folke/lsp-colors.nvim",
                "folke/neodev.nvim",
                "RRethy/vim-illuminate",
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
        use {
            "Yggdroot/LeaderF",
            cmd = "Leaderf",
            run = ":LeaderfInstallCExtension",
            config = [[require('config.leaderf')]]
        }

        use {
            'nvim-telescope/telescope.nvim', cmd = 'Telescope',
            requires = { { 'nvim-lua/plenary.nvim' } },
            config = [[require('config.telescope')]]
        }
        -- search emoji and other symbols
        use { 'nvim-telescope/telescope-symbols.nvim', after = 'telescope.nvim' }

        -- Smoothie motions
        use {
            "karb94/neoscroll.nvim",
            event = "VimEnter",
            config = [[require('config.neoscroll')]]
        }

        use { 'kyazdani42/nvim-web-devicons', event = 'VimEnter' }

        use {
            'nvim-lualine/lualine.nvim',
            event = 'VimEnter',
            config = [[require('config.statusline')]]
        }

        use { 'ibhagwan/fzf-lua',
            requires = {
                'vijaymarupudi/nvim-fzf',
                'kyazdani42/nvim-web-devicons'
            }
        }

        use { "akinsho/bufferline.nvim", event = "VimEnter", config = [[require('config.bufferline')]] }
        use { "nvim-zh/better-escape.vim", event = { "InsertEnter" } }
        -- showing keybindings
        use { "folke/which-key.nvim", event = "VimEnter", config = [[require('config.which-key')]] }

        -- show and trim trailing whitespaces
        use { 'jdhao/whitespace.nvim', event = 'VimEnter' }

        -- file explorer
        use {
            'kyazdani42/nvim-tree.lua',
            requires = { 'kyazdani42/nvim-web-devicons' },
            config = [[require('config.nvim-tree')]]
        }
        -- Show git change (change, delete, add) signs in vim sign column
        use { 'lewis6991/gitsigns.nvim', config = [[require('config.gitsigns')]] }
        use { 'braxtons12/blame_line.nvim', config = [[require('config.blamer')]] }
        use { "tpope/vim-fugitive", config = [[require('config.fugitive')]] }

        use { 'ethanholz/nvim-lastplace', config = [[ require('config.lastplace') ]] }
        -- use { 'https://git.sr.ht/~jhn/remember.nvim', config = [[ require('config.remember')]] }
        use {
            'numToStr/Comment.nvim',
            requires = { 'nvim-treesitter/nvim-treesitter' },
            config = [[require('config.comment')]]
        }

        -- Auto format tools
        use { "sbdchd/neoformat", cmd = { "Neoformat" }, config = [[require('config.neoformat')]] }

        -- Auto pairs
        use { 'windwp/nvim-autopairs', config = [[require('config.autopairs')]] }

        -- markdown render
        use { 'ellisonleao/glow.nvim', config = [[require('config.glow')]] }

        -- Documentation generator
        use { 'kkoomen/vim-doge', run = ':call doge#install()' }

        -- terminal
        use { "akinsho/toggleterm.nvim", tag = '*', config = [[require('config.toggleterm')]] }

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

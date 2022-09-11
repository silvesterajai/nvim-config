local utils = require "utils"

local fn = vim.fn
local api = vim.api
local global = vim.g
local opt = vim.opt
local cmd = vim.cmd

global.logging_level = "info"

--Disable perl provider
global.loaded_perl_provider = 0

-- Disable ruby provider
global.loaded_ruby_provider = 0

-- Disable node provider
global.loaded_node_provider = 0

-- Path to python interpreter
if utils.executable('python3') then
    global.python3_host_prog = fn.exepath("python")
else
    api.nvim_err_writeln("Python 3 executable not found! You must install Python 3 and set its PATH correctly!")
end
global.python3_host_prog = "/usr/bin/python3"
-- Custom mapping <leader> (see `:h mapleader` for more info)
global.mapleader = ','

-- use filetype.lua instead of filetype.vim
global.do_filetype_lua = 1
global.did_load_filetypes = 0

-- Disable loading certain plugins
global.loaded_gzip = false
global.loaded_matchit = false
global.loaded_netrwPlugin = false
global.loaded_tarPlugin = false
global.loaded_zipPlugin = false
global.loaded_man = false
global.loaded_2html_plugin = false
global.loaded_remote_plugins = false
global.did_load_filetypes = false


opt.fileencoding = "utf-8" -- Set File Encoding
opt.spelllang = "en"
opt.splitbelow = true -- Force split below
opt.splitright = true -- Force split right
opt.timeoutlen = 250 -- Time for mapped sequence to complete (in ms)
opt.updatetime = 250 -- For CursorHold events
opt.inccommand = 'nosplit' -- Incremental live completion
opt.completeopt = "menuone,noselect" -- Autocompletion

-- Ignore certain files and folders when globing
opt.wildignore:append { '*.o', '*.obj', '*.dylib', '*.bin', '*.dll', '*.exe' }
opt.wildignore:append { '*/.git/*', '*/.svn/*', '*/__pycache__/*', '*/build/**' }
opt.wildignore:append { '*.jpg', '*.png', '*.jpeg', '*.bmp', '*.gif', '*.tiff', '*.svg', '*.ico' }
opt.wildignorecase = true

opt.tabstop        = 4 -- number of visual spaces per TAB
opt.softtabstop    = 4 -- number of spaces in tab when editing
opt.shiftwidth     = 4 --number of spaces to use for autoindent
opt.expandtab      = true -- expand tab to spaces so that tabs are spaces
opt.number         = true -- display line number
opt.relativenumber = false -- do not display relative line number
opt.ignorecase     = true -- Case insensitive searching
opt.smartcase      = true -- If Upper Case Char > case sensitive search
opt.smarttab       = true -- Smart Tabs
opt.smartindent    = true -- Smart Indenting
opt.showbreak      = '↪'
opt.wildmode       = 'list:longest' -- List all matches and complete till longest common string
opt.scrolloff      = 3 -- Minimum lines to keep above and below cursor when scrolling
opt.mouse          = 'a' -- Enable mouse mode
cmd "set noshowmode" -- Disable showing current mode on command line since statusline plugins can show it
cmd "set confirm" -- Ask for confirmation when handling unsaved or read-only files
cmd "set fileformats=unix,dos" -- Fileformats to use for new files
cmd "set visualbell noerrorbells" -- Do not use visual and errorbells
opt.history       = 500 -- The number of command and search history to keep
opt.undofile      = true -- Persistent undo even after you close a file and re-open it
opt.termguicolors = true -- Set Terminal Colors
opt.title         = true -- Display File Info on Title
opt.cmdheight     = 1 -- Better Error Messages
opt.showtabline   = 2 -- Always Show Tabline
opt.pumheight     = 10 -- Pop up Menu Height
opt.termguicolors = true -- Set Terminal Colors
opt.background    = "dark"
opt.title         = true -- Display File Info on Title
opt.showmode      = true -- Don't Show MODES
opt.signcolumn    = 'auto:1-2' -- Sign Column
opt.scrolloff     = 12 -- Vertical Scroll Offset
opt.sidescrolloff = 8 -- Horizontal Scroll Offset
opt.completeopt   = "menuone,noselect" -- Autocompletion
opt.shortmess:append { W = true, a = true }
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Highlight on yank
vim.api.nvim_exec(
    [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]   ,
    false
)

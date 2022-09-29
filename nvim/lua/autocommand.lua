local fn = vim.fn
local api = vim.api

local utils = require("utils")


-- Display a message when the current file is not in utf-8 format.
-- Note that we need to use `unsilent` command here because of this issue:
-- https://github.com/vim/vim/issues/4379
api.nvim_create_autocmd({ "BufRead" }, {
    pattern = "*",
    group = api.nvim_create_augroup("non_utf8_file", { clear = true }),
    callback = function()
        if vim.bo.fileencoding ~= 'utf-8' then
            vim.notify("File not in UTF-8 format!", vim.log.levels.WARN, { title = "nvim-config" })
        end
    end
})

-- Auto sync plugins on save of plugins.lua
api.nvim_create_autocmd("BufWritePost", { pattern = "plugins.lua", command = "source <afile> | PackerSync" })

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost",
    { callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end })

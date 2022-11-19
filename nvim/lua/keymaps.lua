local keymap = vim.keymap

-- Save key strokes (now we do not need to press shift to enter command mode).
keymap.set({ "n", "x" }, ";", ":")

-- Shortcut for faster save and quit
keymap.set("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer", })
keymap.set("n", "<leader>q", "<cmd>quit<cr>", { silent = true, desc = "quit buffer", })
-- Quit all opened buffers
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim", })

-- Navigation in the location and quickfix list
keymap.set("n", "[l", "<cmd>lprevious<cr>zv", { silent = true, desc = "previous location item", })
keymap.set("n", "]l", "<cmd>lnext<cr>zv", { silent = true, desc = "next location item", })

keymap.set("n", "[L", "<cmd>lfirst<cr>zv", { silent = true, desc = "first location item", })
keymap.set("n", "]L", "<cmd>llast<cr>zv", { silent = true, desc = "last location item", })

keymap.set("n", "[q", "<cmd>cprevious<cr>zv", { silent = true, desc = "previous qf item", })
keymap.set("n", "]q", "<cmd>cnext<cr>zv", { silent = true, desc = "next qf item", })

keymap.set("n", "[Q", "<cmd>cfirst<cr>zv", { silent = true, desc = "first qf item", })
keymap.set("n", "]Q", "<cmd>clast<cr>zv", { silent = true, desc = "last qf item", })

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
keymap.set("x", "$", "g_")

-- Go to start or end of line easier
keymap.set({ "n", "x" }, "H", "^")
keymap.set({ "n", "x" }, "L", "g_")

-- Edit and reload nvim config file quickly
keymap.set("n", "<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<cr>", {
    silent = true,
    desc = "open init.lua",
})

keymap.set("n", "<leader>sv", "", {
    silent = true,
    desc = "reload init.lua",
    callback = function()
        vim.cmd [[
      update $MYVIMRC
      source $MYVIMRC
    ]]
        vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
    end,
})

-- Remove trailing whitespace characters
keymap.set("n", "<leader><space>", "<cmd>StripTrailingWhitespace<cr>", { desc = "remove trailing space", })

-- Copy entire buffer.
keymap.set("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer", })

-- Go to the beginning and end of current line in insert mode quickly
keymap.set('i', '<C-A>', '<HOME>')
keymap.set('i', '<C-E>', '<END>')

-- Go to beginning of command in command-line mode
keymap.set('c', '<C-A>', '<HOME>')

-- Delete the character to the right of the cursor
keymap.set('i', '<C-D>', '<DEL>')

keymap.set('n', "<leader>fm", "<cmd>:Neoformat<cr>", { desc = "format file", })

-- LeaderF
keymap.set('n', "<leader>ff", ":<C-U>Leaderf file --popup<cr>", { desc = "Search files in popup window", })
keymap.set('n', '<leader>fg', ':<C-U>Leaderf rg --no-messages --popup<cr>',
    { desc = "Grep project files in popup window", })
keymap.set('n', '<leader>fr', ':<C-U>Leaderf mru --popup<cr>', { desc = "Search recent files", })

-- Telescope
keymap.set('n', '<leader>wt', ':Telescope <CR>', { desc = "Telescope" })

-- Fuzzy search
keymap.set('n', "<leader>fz", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "fzf search" })

-- Bufferline
keymap.set('n', "<leader>bp", ':BufferLinePick <CR>', { desc = "pick buffer", })

-- commentary
keymap.set('n', "<leader>cc", ':Commentary<CR>', { desc = "Comment line" })

--terminal
keymap.set("", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "toggleterm" })
keymap.set("", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "toggleterm (float)" })
keymap.set("", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "toggleterm (vertical)" })
keymap.set("", "<leader>tp", "<cmd>ToggleTerm direction=tab<cr>", { desc = "toggleterm (tab-persistent)" })

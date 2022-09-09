vim.g.coq_settings = { auto_start = 'shut-up', clients = { tabnine = { enabled = true } } }
local coq = require('coq')
vim.cmd('COQnow -s')

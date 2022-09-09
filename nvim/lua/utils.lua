local fn = vim.fn

local M = {}

function M.get_nvim_version()
    local actual_ver = vim.version()
    local nvim_ver_str = string.format("%d.%d.%d", actual_ver.major, actual_ver.minor, actual_ver.patch)
    return nvim_ver_str
end

function M.executable(name)
  if fn.executable(name) > 0 then
    return true
  end

  return false
end

-- :help map-modes
function M.map(mode, lhs, rhs)
	vim.api.nvim_set_keymap(mode, lhs, rhs, { silent = true })
end
function M.noremap(mode, lhs, rhs)
	vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

function M.exprnoremap(mode, lhs, rhs)
	vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true, expr = true })
end

return M


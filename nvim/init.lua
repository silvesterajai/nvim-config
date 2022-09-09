-- Author: Ajai Silvester

local api = vim.api
local utils = require "utils"

-- check if we have latest version of neovim
local expected_ver = "0.8.0"
local current_ver = utils.get_nvim_version()

if current_ver ~= expected_ver then
    local message = string.format("Unsupported nvim version. Expected: %s, but got %s\n", expected_ver, current_ver)
    api.nvim_err_writeln(message)
    return
end

local core_conf_files = {
    "settings", -- all the settings (including keymap, globals, options)
    "keymaps", -- keymaps
    "autocommand", -- autocommands
    "plugins", -- all the plugins installed and their configurations
}

-- source all the config files
for _, name in ipairs(core_conf_files) do
    require(name)
end

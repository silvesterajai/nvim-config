local fn = vim.fn

-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}

local function spell()
    if vim.o.spell then
        return string.format("[SPELL]")
    end

    return ""
end

local function ime_state()
    if vim.g.is_mac then
        -- ref: https://github.com/vim-airline/vim-airline/blob/master/autoload/airline/extensions/xkblayout.vim#L11
        local layout = fn.libcall(vim.g.XkbSwitchLib, 'Xkb_Switch_getXkbLayout', '')
        if layout == '0' then
            return '[CN]'
        end
    end

    return ""
end

local function trailing_space()
    if not vim.o.modifiable then
        return ""
    end

    local line_num = nil

    for i = 1, fn.line('$') do
        local linetext = fn.getline(i)
        -- To prevent invalid escape error, we wrap the regex string with `[[]]`.
        local idx = fn.match(linetext, [[\v\s+$]])

        if idx ~= -1 then
            line_num = i
            break
        end
    end

    local msg = ""
    if line_num ~= nil then
        msg = string.format("[%d]trailing", line_num)
    end

    return msg
end

local function lsp_server()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return msg
    end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
        end
    end
    return msg
end

local function mixed_indent()
    if not vim.o.modifiable then
        return ""
    end

    local space_pat = [[\v^ +]]
    local tab_pat = [[\v^\t+]]
    local space_indent = fn.search(space_pat, 'nwc')
    local tab_indent = fn.search(tab_pat, 'nwc')
    local mixed = (space_indent > 0 and tab_indent > 0)
    local mixed_same_line
    if not mixed then
        mixed_same_line = fn.search([[\v^(\t+ | +\t)]], 'nwc')
        mixed = mixed_same_line > 0
    end
    if not mixed then return '' end
    if mixed_same_line ~= nil and mixed_same_line > 0 then
        return 'MI:' .. mixed_same_line
    end
    local space_indent_cnt = fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
    local tab_indent_cnt = fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
    if space_indent_cnt > tab_indent_cnt then
        return 'MI:' .. tab_indent
    else
        return 'MI:' .. space_indent
    end
end

local function middle_section()
    return '%='
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        section_separators = "",
        component_separators = "",
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
            "filename",
            {
                ime_state,
                color = { fg = 'black', bg = '#f46868' }
            },
            {
                spell,
                color = { fg = 'black', bg = '#a7c080' }
            },
            {
                middle_section,
            },
            {
                'diagnostics',
                sources = { 'nvim_lsp' },
            },
            {
                lsp_server,
                icon = ' LSP:',
                color = { fg = colors.blue, gui = 'bold' },
            },
            "lsp_progress"
        },
        lualine_x = {
            "encoding",
            {
                "fileformat",
                symbols = {
                    unix = "unix",
                    dos = "win",
                    mac = "mac",
                },
            },
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = {
            "location",
            {
                trailing_space,
                color = "WarningMsg"
            },
            {
                mixed_indent,
                color = "WarningMsg"
            },
        },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = { 'quickfix', 'fugitive', 'nvim-tree' },
})

require('telescope').setup({
    defaults = {
        vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column',
            '--smart-case' },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
                preview_cutting = 120
            },
            vertical = {
                mirror = false
            },
            width = 0.8,
            height = 0.45,
        },
        file_sorter = require 'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = {
            ['COLORTERM'] = 'truecolor'
        }, -- default = nil,
        file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require 'telescope.previewers'.buffer_previewer_maker
    }
})

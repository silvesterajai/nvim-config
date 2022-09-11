local g = vim.g -- a table to access global variables

g.neoformat_only_msg_on_error = 1
-- open to debug
-- g.neoformat_verbose = 1

g.shfmt_opt = "-ci"

g.neoformat_lua_luafmt = {
    exe = vim.fn.stdpath("config") .. "/plugins/formatter/lua-fmt/node_modules/.bin/luafmt",
    args = { "-w replace" },
    replace = 1
}
g.neoformat_enabled_lua = { "luafmt" }

g.neoformat_markdown_prettier = {
    exe = vim.fn.stdpath("config") .. "/plugins/formatter/prettier/node_modules/.bin/prettier",
    args = { "--write" },
    replace = 1
}
g.neoformat_enabled_markdown = { "prettier" }

g.neoformat_cmake_cmakeformat = {
    exe = "cmake-format",
    args = { "-i" },
    replace = 1
}
g.neoformat_enabled_cmake = { "cmakeformat" }

-- auto format on save
vim.api.nvim_exec(
    [[
      augroup fmt
        autocmd!
        autocmd BufWritePre * | Neoformat
      augroup END
    ]],
    false
)

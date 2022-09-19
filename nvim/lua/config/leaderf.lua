-- aliases
local g = vim.g -- global for let options
local fn = vim.fn -- access vim functions

g.Lf_usecache = 0
g.Lf_UseMemoryCache = 0
g.Lf_WildIgnore = {
    dir = { ".git", "target", ".vscode", "node_modules" },
    file = {
        "*.exe", "*.dll", "*.so", "*.o", "*.d", "Cargo.lock",
        "package-lock.json"
    }
}
g.Lf_DefaultMode = "FullPath"
g.Lf_WindowPosition = 'popup'

local w = fn.float2nr(vim.o.columns * 0.8)
if w > 140 then
    g.Lf_PopupWidth = 140
else
    g.Lf_PopupWidth = w
end

g.Lf_PopupPosition = { 0, fn.float2nr((vim.o.columns - g.Lf_PopupWidth) / 2) }

g.Lf_UseVersionControlTool = 0
g.Lf_DefaultExternalTool = "rg"
g.Lf_ShowHidden = 1

g.Lf_ShortcutF = ""
g.Lf_ShortcutB = ""
g.Lf_CommandMap = { ["<C-J>"] = { "<C-N>" }, ["<C-K>"] = { "<C-P>" } }
g.Lf_WorkingDirectoryMode = 'a'

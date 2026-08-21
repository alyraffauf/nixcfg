_G.hoenn_linters_by_ft = _G.hoenn_linters_by_ft or {}
_G.hoenn_linters_by_ft.lua = { "selene" }

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = { Lua = { hint = { enable = true }, telemetry = { enable = false } } },
})
vim.lsp.enable("lua_ls")

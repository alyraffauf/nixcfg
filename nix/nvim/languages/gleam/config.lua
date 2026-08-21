_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }
table.insert(_G.hoenn_root_markers, "gleam.toml")

vim.lsp.config("gleam", {
	cmd = { "gleam", "lsp" },
	filetypes = { "gleam" },
	root_markers = { "gleam.toml", ".git" },
})
vim.lsp.enable("gleam")

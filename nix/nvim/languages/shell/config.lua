_G.hoenn_linters_by_ft = _G.hoenn_linters_by_ft or {}
_G.hoenn_linters_by_ft.sh = { "shellcheck" }
_G.hoenn_linters_by_ft.bash = { "shellcheck" }

vim.lsp.config("bashls", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
})
vim.lsp.config("fish_lsp", {
	cmd = { "fish-lsp", "start" },
	filetypes = { "fish" },
})
vim.lsp.enable({ "bashls", "fish_lsp" })

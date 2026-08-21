_G.hoenn_linters_by_ft = _G.hoenn_linters_by_ft or {}
_G.hoenn_linters_by_ft.markdown = { "markdownlint-cli2" }

vim.lsp.config("marksman", {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
})
vim.lsp.enable("marksman")

_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }
table.insert(_G.hoenn_root_markers, "pyproject.toml")

vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ty.toml", ".git" },
})
vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	on_attach = function(client)
		client.server_capabilities.hoverProvider = false
	end,
})
vim.lsp.enable({ "ty", "ruff" })

require("dap-python").setup(vim.g.hoenn_paths.debugpy_python)

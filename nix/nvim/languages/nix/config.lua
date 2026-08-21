_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }
table.insert(_G.hoenn_root_markers, "flake.nix")

_G.hoenn_linters_by_ft = _G.hoenn_linters_by_ft or {}
_G.hoenn_linters_by_ft.nix = { "statix", "deadnix" }

vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
})
vim.lsp.enable("nixd")

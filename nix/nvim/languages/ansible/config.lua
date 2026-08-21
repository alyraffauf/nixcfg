_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }
table.insert(_G.hoenn_root_markers, "ansible.cfg")

vim.filetype.add({
	pattern = {
		[".*/defaults/.*%.ya?ml"] = "yaml.ansible",
		[".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
		[".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
		[".*/playbooks?/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
	},
})

_G.hoenn_linters_by_ft = _G.hoenn_linters_by_ft or {}
_G.hoenn_linters_by_ft.ansible = { "ansible_lint" }
_G.hoenn_linters_by_ft["yaml.ansible"] = { "ansible_lint" }

vim.lsp.config("ansiblels", {
	cmd = { "ansible-language-server", "--stdio" },
	filetypes = { "ansible", "yaml.ansible" },
	root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
})
vim.lsp.enable("ansiblels")

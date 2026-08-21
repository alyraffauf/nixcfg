_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }
vim.list_extend(_G.hoenn_root_markers, { "Dockerfile", "docker-compose.yml", "compose.yml" })

local function find_docker_project_root(buffer_number, on_root_found)
	local project_root = vim.fs.root(vim.api.nvim_buf_get_name(buffer_number), {
		"Dockerfile",
		"docker-compose.yml",
		"compose.yml",
		".git",
	})
	if project_root then
		on_root_found(project_root)
	end
end

vim.lsp.config("dockerls", {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_dir = find_docker_project_root,
})
vim.lsp.enable("dockerls")

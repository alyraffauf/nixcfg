local WEB_FILETYPES = { "html", "css", "scss", "javascriptreact", "typescriptreact" }
local TAILWIND_ROOT_MARKERS = {
	"tailwind.config.js",
	"tailwind.config.cjs",
	"tailwind.config.mjs",
	"tailwind.config.ts",
}

local function package_uses_tailwind(package_root)
	local was_read, package_json_lines = pcall(vim.fn.readfile, package_root .. "/package.json")
	if not was_read then
		return false
	end
	local package_json = table.concat(package_json_lines, "\n")
	return package_json:find("tailwindcss", 1, true) ~= nil
end

local function find_tailwind_project_root(buffer_number, on_root_found)
	local file_path = vim.api.nvim_buf_get_name(buffer_number)
	local project_root = vim.fs.root(file_path, TAILWIND_ROOT_MARKERS)
	if project_root then
		on_root_found(project_root)
		return
	end

	local package_root = vim.fs.root(file_path, "package.json")
	if package_root and package_uses_tailwind(package_root) then
		on_root_found(package_root)
	end
end

vim.lsp.config("html", { cmd = { "vscode-html-language-server", "--stdio" }, filetypes = { "html" } })
vim.lsp.config("cssls", {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
})
vim.lsp.config("emmet", { cmd = { "emmet-language-server", "--stdio" }, filetypes = WEB_FILETYPES })
vim.lsp.config("tailwindcss", {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = WEB_FILETYPES,
	root_dir = find_tailwind_project_root,
})
vim.lsp.enable({ "html", "cssls", "emmet", "tailwindcss" })

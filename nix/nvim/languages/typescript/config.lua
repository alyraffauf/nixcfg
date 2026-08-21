local JAVASCRIPT_FILETYPES = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
local OXLINT_ROOT_MARKERS = { "oxlint.json", ".oxlintrc.json", "package.json", ".git" }
_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }
vim.list_extend(_G.hoenn_root_markers, { "package.json", "deno.json", "deno.jsonc" })
local ESLINT_ROOT_MARKERS = {
	"eslint.config.js",
	"eslint.config.cjs",
	"eslint.config.mjs",
	"eslint.config.ts",
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.json",
	".eslintrc.yaml",
	".eslintrc.yml",
}

local function find_eslint_project_root(buffer_number, on_root_found)
	local file_path = vim.api.nvim_buf_get_name(buffer_number)
	local project_root = vim.fs.root(file_path, ESLINT_ROOT_MARKERS)
	if project_root then
		on_root_found(project_root)
	end
end

local function find_oxlint_project_root(buffer_number, on_root_found)
	local file_path = vim.api.nvim_buf_get_name(buffer_number)
	if vim.fs.root(file_path, ESLINT_ROOT_MARKERS) then
		return
	end
	local project_root = vim.fs.root(file_path, OXLINT_ROOT_MARKERS)
	if project_root then
		on_root_found(project_root)
	end
end

vim.lsp.config("vtsls", {
	cmd = { "vtsls", "--stdio" },
	filetypes = JAVASCRIPT_FILETYPES,
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	settings = {
		typescript = { updateImportsOnFileMove = { enabled = "always" } },
		javascript = { updateImportsOnFileMove = { enabled = "always" } },
	},
})
vim.lsp.config("eslint", {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = JAVASCRIPT_FILETYPES,
	root_dir = find_eslint_project_root,
})
vim.lsp.config("oxlint", {
	cmd = { "oxlint", "--lsp" },
	filetypes = JAVASCRIPT_FILETYPES,
	root_dir = find_oxlint_project_root,
})
vim.lsp.enable({ "vtsls", "eslint", "oxlint" })

_G.hoenn_linters_by_ft = _G.hoenn_linters_by_ft or {}
local function select_javascript_linter(buffer_number)
	local file_path = vim.api.nvim_buf_get_name(buffer_number)
	return vim.fs.root(file_path, ESLINT_ROOT_MARKERS) and "eslint" or "oxlint"
end
for _, filetype in ipairs(JAVASCRIPT_FILETYPES) do
	_G.hoenn_linters_by_ft[filetype] = select_javascript_linter
end

local debug_adapter_protocol = require("dap")
debug_adapter_protocol.adapters["pwa-node"] = {
	type = "server",
	host = "127.0.0.1",
	port = "${port}",
	executable = { command = vim.g.hoenn_paths.js_debug, args = { "${port}", "127.0.0.1" } },
}
for _, language in ipairs(JAVASCRIPT_FILETYPES) do
	debug_adapter_protocol.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch current file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},
	}
end

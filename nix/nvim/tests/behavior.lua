local test_root = assert(vim.env.HOENN_NVIM_TEST_ROOT, "HOENN_NVIM_TEST_ROOT is unset")

local function write_file(path, lines)
	vim.fn.mkdir(vim.fs.dirname(path), "p")
	vim.fn.writefile(lines or {}, path)
end

write_file(test_root .. "/project/flake.nix", { "{}" })
write_file(test_root .. "/project/default.nix")
write_file(test_root .. "/project/init.lua")
write_file(test_root .. "/project/script.sh")
write_file(test_root .. "/project/main.go")
write_file(test_root .. "/project/main.rs")
write_file(test_root .. "/project/main.py")
write_file(test_root .. "/project/app.tsx")
write_file(test_root .. "/project/config.yaml")
write_file(test_root .. "/project/README.md")
write_file(test_root .. "/project/Dockerfile")
write_file(test_root .. "/project/src/main.gleam")
write_file(test_root .. "/project/roles/demo/tasks/main.yml")
write_file(test_root .. "/project/large.txt", { string.rep("x", 1024 * 1024 + 1) })
write_file(test_root .. "/eslint/eslint.config.js")
write_file(test_root .. "/eslint/src/app.ts")
write_file(test_root .. "/plain/package.json", { [[{"name":"plain"}]] })
write_file(test_root .. "/plain/src/app.ts")
write_file(test_root .. "/tailwind/package.json", { [[{"dependencies":{"tailwindcss":"latest"}}]] })
write_file(test_root .. "/tailwind/src/app.tsx")

local filetypes = {
	["default.nix"] = "nix",
	["init.lua"] = "lua",
	["script.sh"] = "sh",
	["main.go"] = "go",
	["main.rs"] = "rust",
	["main.py"] = "python",
	["app.tsx"] = "typescriptreact",
	["config.yaml"] = "yaml",
	["README.md"] = "markdown",
	Dockerfile = "dockerfile",
	["src/main.gleam"] = "gleam",
	["roles/demo/tasks/main.yml"] = "yaml.ansible",
}

for path, expected in pairs(filetypes) do
	vim.cmd.edit(vim.fn.fnameescape(test_root .. "/project/" .. path))
	assert(
		vim.bo.filetype == expected,
		string.format("%s detected as %s, expected %s", path, vim.bo.filetype, expected)
	)
	assert(vim.uv.cwd() == test_root .. "/project", "working directory did not follow the project root")
end

local autosave_path = test_root .. "/project/autosave.txt"
vim.cmd.edit(vim.fn.fnameescape(autosave_path))
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "saved by autocmd" })
vim.api.nvim_exec_autocmds("InsertLeave", { buffer = 0 })
assert(vim.fn.readfile(autosave_path)[1] == "saved by autocmd", "eligible buffer was not autosaved")

vim.cmd.enew()
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "unnamed" })
vim.api.nvim_exec_autocmds("InsertLeave", { buffer = 0 })
assert(vim.bo.modified, "autosave changed an unnamed buffer")

vim.cmd("FormatToggle")
assert(vim.g.hoenn_format_on_save == false, "global format toggle did not disable formatting")
vim.cmd("FormatToggle")
assert(vim.g.hoenn_format_on_save == true, "global format toggle did not enable formatting")
vim.cmd("FormatToggleBuffer")
assert(vim.b.hoenn_format_on_save == false, "buffer format toggle did not disable formatting")

vim.cmd.edit(vim.fn.fnameescape(test_root .. "/project/large.txt"))
assert(vim.b.hoenn_large_file == true, "large-file mode did not activate")
assert(vim.b.hoenn_format_on_save == false, "large-file mode did not disable formatting")

local function resolve_project_root(config, path)
	local project_root
	config.root_dir(vim.fn.bufadd(path), function(found_root)
		project_root = found_root
	end)
	return project_root
end

local eslint_file = test_root .. "/eslint/src/app.ts"
local plain_file = test_root .. "/plain/src/app.ts"
assert(
	resolve_project_root(vim.lsp.config.eslint, eslint_file) == test_root .. "/eslint",
	"ESLint project was not selected"
)
assert(resolve_project_root(vim.lsp.config.oxlint, eslint_file) == nil, "Oxlint was selected for an ESLint project")
assert(resolve_project_root(vim.lsp.config.eslint, plain_file) == nil, "ESLint was selected without a configuration")
assert(
	resolve_project_root(vim.lsp.config.oxlint, plain_file) == test_root .. "/plain",
	"Oxlint fallback was not selected"
)
assert(
	resolve_project_root(vim.lsp.config.tailwindcss, test_root .. "/tailwind/src/app.tsx") == test_root .. "/tailwind",
	"Tailwind project was not selected"
)
assert(resolve_project_root(vim.lsp.config.tailwindcss, plain_file) == nil, "Tailwind was selected for a plain project")

print("buffer behavior assertions passed")

local function assert_equal(actual, expected, label)
	assert(actual == expected, string.format("%s: expected %q, got %q", label, expected, actual))
end

assert_equal(vim.env.NVIM_APPNAME, "hoenn-nvim", "app name")
assert(vim.fn.stdpath("state"):match("/hoenn%-nvim$"), "state path is not isolated")
assert(Snacks.config.dashboard.enabled == false, "clean profile dashboard must stay disabled without lazy.nvim")
for _, marker in ipairs({ "flake.nix", "go.mod", "Cargo.toml", "pyproject.toml", "package.json", "gleam.toml" }) do
	assert(vim.tbl_contains(_G.hoenn_root_markers, marker), "missing project marker: " .. marker)
end
assert(vim.deep_equal(_G.hoenn_linters_by_ft.nix, { "statix", "deadnix" }), "Nix linters were not registered")
assert(type(_G.hoenn_linters_by_ft.typescript) == "function", "TypeScript linter selector was not registered")

for _, plugin_module_name in ipairs({
	"blink.cmp",
	"conform",
	"dap",
	"diffview",
	"flash",
	"grug-far",
	"guess-indent",
	"lint",
	"neo-tree",
	"noice",
	"resession",
	"trouble",
	"which-key",
}) do
	assert(pcall(require, plugin_module_name), "failed to load plugin: " .. plugin_module_name)
end

for _, command_name in ipairs({ "FormatToggle", "FormatToggleBuffer", "Neotree", "Trouble", "DiffviewOpen", "GrugFar" }) do
	assert_equal(vim.fn.exists(":" .. command_name), 2, "command " .. command_name)
end

for _, key_sequence in ipairs({
	"<C-P>",
	"<C-H>",
	"<C-J>",
	"<C-K>",
	"<C-L>",
	"<Space>ff",
	"<Space>cf",
	"<Space>pr",
	"<Space>qs",
	"<Space>vm",
	"<Space>vo",
}) do
	assert(vim.fn.maparg(key_sequence, "n") ~= "", "missing normal mapping: " .. key_sequence)
end

for _, key_sequence in ipairs({ "<Space>uf", "<Space>sr", "<Space>Ss", "<Space>um" }) do
	assert(vim.fn.maparg(key_sequence, "n") == "", "obsolete normal mapping remains: " .. key_sequence)
end

local lazygit_mapping = vim.fn.maparg("<Space>gg", "n", false, true)
assert(type(lazygit_mapping.callback) == "function", "lazygit mapping does not call the ToggleTerm integration")
assert(not (lazygit_mapping.rhs or ""):find("LazyGit", 1, true), "lazygit mapping calls a nonexistent command")

local formatting_engine = require("conform")
local EXPECTED_FORMATTERS = {
	nix = "alejandra",
	lua = "stylua",
	sh = "shfmt",
	go = "goimports",
	rust = "rustfmt",
	python = "ruff_fix",
	typescriptreact = "prettier",
	yaml = "prettier",
	markdown = "prettier",
	dockerfile = "dockerfmt",
	gleam = "gleam",
}
for filetype, formatter in pairs(EXPECTED_FORMATTERS) do
	vim.bo.filetype = filetype
	local selected_formatters = formatting_engine.list_formatters_to_run(0)
	assert(
		selected_formatters[1] and selected_formatters[1].name == formatter,
		"wrong first formatter for " .. filetype
	)
end

for _, language_server_name in ipairs({
	"nixd",
	"lua_ls",
	"bashls",
	"fish_lsp",
	"gopls",
	"ty",
	"ruff",
	"vtsls",
	"eslint",
	"oxlint",
	"tailwindcss",
	"jsonls",
	"yamlls",
	"marksman",
	"dockerls",
	"ansiblels",
	"gleam",
}) do
	assert(vim.lsp.config[language_server_name], "missing LSP config: " .. language_server_name)
end

assert(vim.g.rustaceanvim and vim.g.rustaceanvim.dap, "missing Rust DAP config")
local debug_adapter_protocol = require("dap")
assert(debug_adapter_protocol.adapters.go, "missing Go DAP adapter")
assert(debug_adapter_protocol.adapters.python, "missing Python DAP adapter")
assert(debug_adapter_protocol.adapters["pwa-node"], "missing JS/TS DAP adapter")

for _, executable in ipairs({
	"nixd",
	"alejandra",
	"lua-language-server",
	"stylua",
	"bash-language-server",
	"fish-lsp",
	"shellcheck",
	"shfmt",
	"gopls",
	"goimports",
	"dlv",
	"rust-analyzer",
	"rustfmt",
	"cargo-clippy",
	"ruff",
	"ty",
	"vtsls",
	"prettier",
	"oxlint",
	"marksman",
	"ansible-language-server",
	"gleam",
	"lazygit",
}) do
	assert(vim.fn.executable(executable) == 1, "missing executable: " .. executable)
end

print("headless assertions passed")

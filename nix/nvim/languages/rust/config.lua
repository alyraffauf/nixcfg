local debugger_paths = vim.g.hoenn_paths
_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }
table.insert(_G.hoenn_root_markers, "Cargo.toml")

vim.g.rustaceanvim = {
	server = {
		cmd = { debugger_paths.rust_analyzer },
		default_settings = {
			["rust-analyzer"] = {
				check = { command = "clippy" },
				files = { exclude = { ".direnv", ".git", "target" } },
			},
		},
	},
	dap = {
		adapter = {
			type = "server",
			host = "127.0.0.1",
			port = "${port}",
			executable = {
				command = debugger_paths.codelldb,
				args = { "--liblldb", debugger_paths.liblldb, "--port", "${port}" },
			},
		},
	},
}

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { statusline = { "snacks_dashboard" }, winbar = { "neo-tree", "aerial" } },
	},
	sections = {
		lualine_a = { { "mode", padding = { left = 1, right = 1 } } },
		lualine_b = { "branch", "diff" },
		lualine_c = { { "filename", path = 1, symbols = { modified = " ●", readonly = " " } } },
		lualine_x = { "diagnostics", "lsp_status", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	winbar = {
		lualine_c = {
			{ "filename", path = 1 },
			{ "navic", color_correction = "dynamic" },
		},
	},
	inactive_winbar = { lualine_c = { { "filename", path = 1 } } },
	extensions = { "neo-tree", "toggleterm", "trouble" },
})

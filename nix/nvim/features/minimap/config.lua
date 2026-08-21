local minimap = require("mini.map")
minimap.setup({
	integrations = {
		minimap.gen_integration.builtin_search(),
		minimap.gen_integration.diagnostic(),
		minimap.gen_integration.gitsigns(),
	},
	window = { focusable = true, side = "right", width = 10, winblend = 25 },
})

vim.keymap.set("n", "<leader>vm", minimap.toggle, { desc = "Toggle minimap" })
vim.keymap.set("n", "<leader>vM", minimap.toggle_focus, { desc = "Focus minimap" })

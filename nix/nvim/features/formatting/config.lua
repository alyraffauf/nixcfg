vim.g.hoenn_format_on_save = true

vim.api.nvim_create_user_command("FormatToggle", function()
	vim.g.hoenn_format_on_save = not vim.g.hoenn_format_on_save
	vim.notify("Format on save " .. (vim.g.hoenn_format_on_save and "enabled" or "disabled"))
end, { desc = "Toggle format on save globally" })

vim.api.nvim_create_user_command("FormatToggleBuffer", function()
	if vim.b.hoenn_format_on_save == nil then
		vim.b.hoenn_format_on_save = false
	else
		vim.b.hoenn_format_on_save = not vim.b.hoenn_format_on_save
	end
	vim.notify("Buffer format on save " .. (vim.b.hoenn_format_on_save and "enabled" or "disabled"))
end, { desc = "Toggle format on save for this buffer" })

vim.keymap.set("n", "<leader>cf", "<cmd>FormatToggle<cr>", { desc = "Toggle format on save" })
vim.keymap.set("n", "<leader>cF", "<cmd>FormatToggleBuffer<cr>", { desc = "Toggle format for this buffer" })

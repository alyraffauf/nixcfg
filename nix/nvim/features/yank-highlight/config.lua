vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("hoenn_yank_highlight", { clear = true }),
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

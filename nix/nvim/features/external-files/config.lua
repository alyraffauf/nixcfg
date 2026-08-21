vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("hoenn_external_files", { clear = true }),
	desc = "Check for changes made outside Neovim",
	callback = function()
		if vim.bo.buftype == "" then
			vim.cmd("checktime")
		end
	end,
})

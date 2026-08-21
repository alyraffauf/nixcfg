vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("hoenn_parent_directories", { clear = true }),
	desc = "Create missing parent directories",
	callback = function(event)
		if vim.bo[event.buf].buftype ~= "" or event.match:match("^%a[%w+.-]*://") then
			return
		end
		local parent_directory = vim.fs.dirname(vim.fs.abspath(event.match))
		vim.fn.mkdir(parent_directory, "p")
	end,
})

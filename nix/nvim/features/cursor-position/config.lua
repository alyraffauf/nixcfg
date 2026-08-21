vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("hoenn_cursor_position", { clear = true }),
	desc = "Restore the last cursor position",
	callback = function(event)
		local buffer_number = event.buf
		if vim.bo[buffer_number].filetype == "gitcommit" then
			return
		end
		local saved_position = vim.api.nvim_buf_get_mark(buffer_number, '"')
		if saved_position[1] > 0 and saved_position[1] <= vim.api.nvim_buf_line_count(buffer_number) then
			pcall(vim.api.nvim_win_set_cursor, 0, saved_position)
		end
	end,
})

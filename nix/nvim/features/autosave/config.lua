local function is_eligible_for_autosave(buffer_number)
	if not vim.api.nvim_buf_is_valid(buffer_number) then
		return false
	end
	if vim.bo[buffer_number].buftype ~= "" or vim.api.nvim_buf_get_name(buffer_number) == "" then
		return false
	end
	if vim.b[buffer_number].hoenn_large_file or vim.bo[buffer_number].readonly then
		return false
	end
	return vim.bo[buffer_number].modifiable and vim.bo[buffer_number].modified
end

vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold", "CursorHoldI", "BufLeave", "FocusLost" }, {
	group = vim.api.nvim_create_augroup("hoenn_autosave", { clear = true }),
	desc = "Save eligible modified file buffers",
	callback = function(event)
		if not is_eligible_for_autosave(event.buf) then
			return
		end
		vim.api.nvim_buf_call(event.buf, function()
			vim.cmd("silent! update")
		end)
	end,
})

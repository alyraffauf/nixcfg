local expected_file_path = assert(vim.env.HOENN_NVIM_SESSION_FILE, "HOENN_NVIM_SESSION_FILE is unset")

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("hoenn_session_test", { clear = true }),
	once = true,
	callback = function()
		vim.defer_fn(function()
			local was_session_file_restored = false
			for _, buffer_number in ipairs(vim.api.nvim_list_bufs()) do
				was_session_file_restored = was_session_file_restored
					or vim.api.nvim_buf_get_name(buffer_number) == expected_file_path
			end
			assert(was_session_file_restored, "session file was not restored")

			local is_file_explorer_visible = false
			for _, window_number in ipairs(vim.api.nvim_list_wins()) do
				local buffer_number = vim.api.nvim_win_get_buf(window_number)
				is_file_explorer_visible = is_file_explorer_visible or vim.bo[buffer_number].filetype == "neo-tree"
			end
			assert(is_file_explorer_visible, "Neo-tree is not visible")
			print("session and tree assertions passed")
			vim.cmd("qa")
		end, 500)
	end,
})

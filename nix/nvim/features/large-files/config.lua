local MAX_FILE_SIZE_BYTES = 1024 * 1024
local MAX_FILE_LINE_COUNT = 20000

local function is_large_file(buffer_number, file_path)
	local file_details = vim.uv.fs_stat(file_path)
	if not file_details then
		return false
	end
	local line_count = vim.api.nvim_buf_line_count(buffer_number)
	return file_details.size > MAX_FILE_SIZE_BYTES or line_count > MAX_FILE_LINE_COUNT
end

local function enable_large_file_mode(buffer_number)
	vim.b[buffer_number].hoenn_large_file = true
	vim.b[buffer_number].hoenn_format_on_save = false
	vim.bo[buffer_number].swapfile = false
	vim.bo[buffer_number].undofile = false
	vim.bo[buffer_number].syntax = ""
	vim.opt_local.foldmethod = "manual"
	-- Treesitter may not have attached to this buffer yet.
	pcall(vim.treesitter.stop, buffer_number)
	vim.notify("Large-file mode disabled syntax, folds, completion, autosave, and formatting", vim.log.levels.WARN)
end

vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("hoenn_large_files", { clear = true }),
	desc = "Disable expensive work for large files",
	callback = function(event)
		local buffer_number = event.buf
		local file_path = vim.api.nvim_buf_get_name(buffer_number)
		if vim.bo[buffer_number].buftype ~= "" or file_path == "" then
			return
		end
		if not is_large_file(buffer_number, file_path) then
			return
		end
		enable_large_file_mode(buffer_number)
	end,
})

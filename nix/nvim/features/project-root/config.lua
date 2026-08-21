_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }

local function find_project_root(path)
	local normalized_path = path ~= "" and vim.fs.normalize(path) or vim.uv.cwd()
	local file_details = vim.uv.fs_stat(normalized_path)
	local search_start = vim.fs.dirname(normalized_path)
	if file_details and file_details.type == "directory" then
		search_start = normalized_path
	end
	return vim.fs.root(search_start, _G.hoenn_root_markers) or search_start
end

_G.hoenn_project_root = find_project_root

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("hoenn_project_root", { clear = true }),
	desc = "Change to the current project root",
	callback = function(event)
		local buffer_number = event.buf
		local file_path = vim.api.nvim_buf_get_name(buffer_number)
		if vim.bo[buffer_number].buftype ~= "" or file_path == "" then
			return
		end
		local project_root = find_project_root(file_path)
		vim.b[buffer_number].hoenn_project_root = project_root
		if project_root and project_root ~= vim.uv.cwd() then
			vim.api.nvim_set_current_dir(project_root)
		end
	end,
})

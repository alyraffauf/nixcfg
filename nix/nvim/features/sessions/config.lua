local resession = require("resession")
local SESSION_DIRECTORY = "projects"

local function is_restorable_buffer(buffer_number)
	if not vim.api.nvim_buf_is_valid(buffer_number) or not vim.bo[buffer_number].buflisted then
		return false
	end
	if vim.bo[buffer_number].buftype ~= "" or vim.api.nvim_buf_get_name(buffer_number) == "" then
		return false
	end
	return not vim.tbl_contains({ "gitcommit", "gitrebase" }, vim.bo[buffer_number].filetype)
end

local function current_project_root()
	return _G.hoenn_project_root(vim.uv.cwd())
end

local function is_file_explorer_visible()
	for _, window_number in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buffer_number = vim.api.nvim_win_get_buf(window_number)
		if vim.bo[buffer_number].filetype == "neo-tree" then
			return true
		end
	end
	return false
end

local function show_file_explorer()
	if is_file_explorer_visible() then
		return
	end
	vim.cmd("Neotree show left")
end

local function save_current_project_session()
	for _, buffer_number in ipairs(vim.api.nvim_list_bufs()) do
		if is_restorable_buffer(buffer_number) then
			resession.save(current_project_root(), { dir = SESSION_DIRECTORY, notify = false })
			return
		end
	end
end

resession.setup({
	buf_filter = is_restorable_buffer,
	tab_buf_filter = function(_, buffer_number)
		return is_restorable_buffer(buffer_number)
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("hoenn_sessions", { clear = true }),
	nested = true,
	desc = "Restore the project session and file tree",
	callback = function()
		local should_restore_session = vim.fn.argc(-1) == 0
		vim.schedule(function()
			if should_restore_session then
				resession.load(current_project_root(), { dir = SESSION_DIRECTORY, silence_errors = true })
			end
			vim.schedule(show_file_explorer)
		end)
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = "hoenn_sessions",
	desc = "Save the current project session",
	callback = save_current_project_session,
})

vim.keymap.set("n", "<leader>ql", function()
	resession.load(current_project_root(), { dir = SESSION_DIRECTORY })
	vim.schedule(show_file_explorer)
end, { desc = "Load project session" })
vim.keymap.set("n", "<leader>qs", function()
	resession.save(current_project_root(), { dir = SESSION_DIRECTORY })
end, { desc = "Save project session" })
vim.keymap.set("n", "<leader>qd", function()
	resession.delete(current_project_root(), { dir = SESSION_DIRECTORY })
end, { desc = "Delete project session" })

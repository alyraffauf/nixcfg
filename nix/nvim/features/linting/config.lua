local lint_engine = require("lint")
_G.hoenn_linters_by_ft = _G.hoenn_linters_by_ft or {}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("hoenn_lint", { clear = true }),
	desc = "Lint the current buffer",
	callback = function(event)
		local buffer_number = event.buf
		if vim.b[buffer_number].hoenn_large_file then
			return
		end
		local selected_linters = _G.hoenn_linters_by_ft[vim.bo[buffer_number].filetype]
		if type(selected_linters) == "function" then
			selected_linters = selected_linters(buffer_number)
		end
		if selected_linters then
			lint_engine.try_lint(selected_linters)
		end
	end,
})

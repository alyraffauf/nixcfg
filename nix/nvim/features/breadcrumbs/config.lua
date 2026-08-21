local breadcrumbs = require("nvim-navic")

breadcrumbs.setup({ highlight = true, separator = " 󰅂 " })
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("hoenn_navic", { clear = true }),
	callback = function(event)
		local language_server = vim.lsp.get_client_by_id(event.data.client_id)
		if language_server and language_server.server_capabilities.documentSymbolProvider then
			breadcrumbs.attach(language_server, event.buf)
		end
	end,
})

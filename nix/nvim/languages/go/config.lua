_G.hoenn_root_markers = _G.hoenn_root_markers or { ".git", "Makefile" }
table.insert(_G.hoenn_root_markers, "go.mod")

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	settings = {
		gopls = {
			analyses = { nilness = true, shadow = true, unusedparams = true, unusedwrite = true, useany = true },
			completeUnimported = true,
			gofumpt = true,
			staticcheck = true,
			usePlaceholders = true,
		},
	},
})
vim.lsp.enable("gopls")

local DEBUG_ADAPTER_HOST = "127.0.0.1"
local DEBUG_ADAPTER_STARTUP_DELAY_MS = 100

local function find_available_port()
	local socket = assert(vim.uv.new_tcp(), "Could not create a socket for Delve")
	assert(socket:bind(DEBUG_ADAPTER_HOST, 0), "Could not reserve a port for Delve")
	local socket_address = assert(socket:getsockname(), "Could not read the reserved Delve port")
	socket:close()
	return socket_address.port
end

local function start_go_debug_adapter(on_adapter_ready)
	local port = find_available_port()
	local job_number = vim.fn.jobstart({ "dlv", "dap", "-l", DEBUG_ADAPTER_HOST .. ":" .. port }, { detach = true })
	assert(job_number > 0, "Could not start Delve")
	vim.defer_fn(function()
		on_adapter_ready({ type = "server", host = DEBUG_ADAPTER_HOST, port = port })
	end, DEBUG_ADAPTER_STARTUP_DELAY_MS)
end

local debug_adapter_protocol = require("dap")
debug_adapter_protocol.adapters.go = start_go_debug_adapter
debug_adapter_protocol.configurations.go = {
	{ type = "go", name = "Debug current file", request = "launch", program = "${file}" },
	{ type = "go", name = "Debug package", request = "launch", program = "${fileDirname}" },
}

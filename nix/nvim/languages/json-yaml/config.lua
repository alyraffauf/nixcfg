local schemastore = require("schemastore")

vim.lsp.config("jsonls", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	settings = { json = { schemas = schemastore.json.schemas(), validate = { enable = true } } },
})
vim.lsp.config("yamlls", {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.ansible" },
	settings = { yaml = { schemaStore = { enable = false, url = "" }, schemas = schemastore.yaml.schemas() } },
})
vim.lsp.enable({ "jsonls", "yamlls" })

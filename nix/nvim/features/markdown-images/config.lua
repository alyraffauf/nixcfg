local has_image_terminal = vim.env.KITTY_WINDOW_ID ~= nil
	or vim.env.WEZTERM_PANE ~= nil
	or (vim.env.TERM or ""):find("kitty", 1, true) ~= nil
if not has_image_terminal then
	return
end

local was_loaded, image = pcall(require, "image")
if not was_loaded then
	vim.notify("Markdown images are unavailable because image.nvim failed to load", vim.log.levels.ERROR)
	return
end

image.setup({
	backend = "kitty",
	processor = "magick_cli",
	integrations = {
		markdown = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = false,
			filetypes = { "markdown", "vimwiki" },
		},
	},
	max_height_window_percentage = 50,
	window_overlap_clear_enabled = false,
	hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
})

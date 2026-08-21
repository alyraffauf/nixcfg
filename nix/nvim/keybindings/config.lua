local set_keymap = vim.keymap.set

for key, direction in pairs({ h = "h", j = "j", k = "k", l = "l" }) do
	set_keymap("n", "<C-" .. key .. ">", "<C-w>" .. direction, { desc = "Move to " .. key .. " window" })
end

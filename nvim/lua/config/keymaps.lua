-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- I'm a noobie and can't use macros well 😬
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "q", "<nop>")

-- override LazyVim's <c-/> terminal keymap (Snacks.terminal.focus doesn't exist yet)
vim.keymap.set({ "n", "t" }, "<c-/>", function() Snacks.terminal.toggle(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<c-_>", function() Snacks.terminal.toggle(nil, { cwd = LazyVim.root() }) end, { desc = "which_key_ignore" })

-- hotkey to enable copilot
vim.keymap.set("n", "<leader>coe", "<cmd>Copilot enable<cr>")
-- hotkey to disable copilot
vim.keymap.set("n", "<leader>cod", "<cmd>Copilot disable<cr>")

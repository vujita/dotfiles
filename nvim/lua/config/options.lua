-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt_local.conceallevel = 0
-- line numbering
vim.opt.nu = true
vim.opt.rnu = false
vim.opt.number = true
-- vim.opt.relativenumber = true
-- vim.opt.statuscolumn = "%l%s%r %s"

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-q>", function()
  vim.cmd("q!")
end)

vim.keymap.set("v", "<C-q>", function()
  vim.cmd("q!")
end)
vim.cmd("filetype plugin indent on")
vim.cmd("set foldmethod=indent")
vim.cmd("set foldnestmax=10")
vim.cmd("set nofoldenable")
vim.cmd("set foldlevel=2")
vim.o.guifont = "JetBrainsMono Nerd Font"

-- allow transparent_background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.filetype.add({
  extension = {
    mdx = "markdown.mdx",
  },
})

vim.opt.conceallevel = 2
vim.opt.termguicolors = true
-- Undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.smartindent = true
vim.opt.autoindent = true
-- spaces not tabs
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Enable this option to avoid conflicts with Prettier.
vim.g.lazyvim_prettier_needs_config = true

vim.opt.autoread = true

vim.g.snacks_animate = false

-- copilot flag for extras
vim.g.ai_cmp = true

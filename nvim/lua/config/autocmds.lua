-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
-- vim.api.nvim_create_autocmd({
--   "BufNewFile",
--   "BufRead",
-- }, {
--   pattern = "*.hbs,*.handlebars",
--   callback = function()
--     if vim.fn.search("{{.\\+}}", "nw") ~= 0 then
--       local buf = vim.api.nvim_get_current_buf()
--       vim.api.nvim_buf_set_option(buf, "filetype", "html")
--     end
--   end,
-- })
--$HOME .'/.vim-bookmarks'
-- autocmd VimEnter * doautocmd FileType
-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})
-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5", "md" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- vim.api.nvim_create_autocmd({
--   "BufNewFile",
--   "BufRead",
--   "BufEnter",
--   -- "WinEnter",
-- }, {
--   pattern = "*.ts,*.tsx,*.css,*.scss",
--   callback = function()
--     require("tailwind-tools").setup({})
--
--     require("lspconfig").tailwindcss.setup({
--       settings = {
--         tailwindCSS = {
--           experimental = {
--             classRegex = {
--               { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
--               { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
--               { "classname\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
--               { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
--             },
--           },
--         },
--       },
--     })
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({
--   "WinEnter",
--   "BufEnter",
-- }, {
--   pattern = "*.ts,*.tsx,*.css,*.scss",
--   callback = function()
--     -- vim.cmd("LspStart")
--   })
-- end,

vim.api.nvim_create_autocmd({
  "BufWritePost",
}, {
  pattern = "*.ts,*.tsx,*.css,*.scss",
  callback = function()
    pcall(function()
      vim.cmd("BookmarkSave " .. os.getenv("HOME") .. "/.vim-bookmarks")
    end)
  end,
})
-- vim.api.nvim_create_autocmd({
--   "BufWritePost",
-- }, {
--   pattern = "*.ts,*.tsx,*.css,*.scss",
--   callback = function()
--     vim.cmd("TailwindColorEnable")
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })

-- local status, autotag = pcall(require, "nvim-ts-autotag")
-- if not status then
--   return
-- end
--
-- autotag.setup({})

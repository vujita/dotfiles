local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    },
    {
      "mason-org/mason.nvim",
      opts = function(_, opts)
        -- table.insert(opts.ensure_installed, "typescript-language-server")
        table.insert(opts.ensure_installed, "css-variables-language-server")
        table.insert(opts.ensure_installed, "css-lsp")
        table.insert(opts.ensure_installed, "some-sass-language-server")
        table.insert(opts.ensure_installed, "css-variables-language-server")
        table.insert(opts.ensure_installed, "some-sass-language-server")
        table.insert(opts.ensure_installed, "prettierd")
        -- table.insert(opts.ensure_installed, "biome") -- we don't use biome for formatting
      end,
    },
    {
      "stevearc/conform.nvim",
      optional = true,
      opts = {
        formatters_by_ft = {
          ["javascript"] = { "prettier" },
          ["javascriptreact"] = { "prettier" },
          ["typescript"] = { "prettier" },
          ["typescriptreact"] = { "prettier" },
          ["vue"] = { "prettier" },
          ["css"] = { "prettier" },
          ["scss"] = { "prettier" },
          ["less"] = { "prettier" },
          ["html"] = { "prettier" },
          ["json"] = { "prettier" },
          ["jsonc"] = { "prettier" },
          ["yaml"] = { "prettier" },
          ["markdown"] = { "prettier" },
          ["markdown.mdx"] = { "prettier" },
          ["graphql"] = { "prettier" },
          ["handlebars"] = { "prettier" },
        },
      },
    },
    -- {
    --   "mfussenegger/nvim-lint",
    --   depends = {
    --     {
    --       "williamboman/mason.nvim",
    --       "rshkarin/mason-nvim-lint",
    --     },
    --   },
    --   opts = {
    --     linters_by_ft = {
    --       ["javascript"] = { "biomejs" },
    --       ["javascriptreact"] = { "biomejs" },
    --       ["typescript"] = { "biomejs" },
    --       ["typescriptreact"] = { "biomejs" },
    --     },
    --   },
    -- },
    { import = "plugins" },
    -- {
    --   "nvimtools/none-ls.nvim",
    --   optional = true,
    --   opts = function(_, opts)
    --     local nls = require("null-ls")
    --     opts.sources = opts.sources or {}
    --     table.insert(opts.sources, nls.builtins.formatting.biome)
    --   end,
    -- },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    -- version = false, -- always use the latest git commit
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "ggandor/leap.nvim",
        "ggandor/flit.nvim",
        "AndrewRadev/tagalong.vim",
        "Jxstxs/conceal.nvim",
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

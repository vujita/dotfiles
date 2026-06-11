return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        javascript = { "oxlint" },
        javascriptreact = { "oxlint" },
        typescript = { "oxlint" },
        typescriptreact = { "oxlint" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        javascript = { "oxfmt", "oxlint" },
        javascriptreact = { "oxfmt", "oxlint" },
        typescript = { "oxfmt", "oxlint" },
        typescriptreact = { "oxfmt", "oxlint" },
      },
      formatters = {
        oxfmt = {
          command = "oxfmt",
          args = { "--write", "$FILENAME" },
          stdin = false,
        },
        oxlint = {
          command = "oxlint",
          args = { "--fix", "$FILENAME" },
          stdin = false,
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "oxlint", "oxfmt" } },
  },
}

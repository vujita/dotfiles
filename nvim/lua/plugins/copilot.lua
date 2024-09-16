return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  enabled = true,
  keys = {
    {
      "<leader>coe",
      "<cmd>Copilot enable<cr>",
      desc = "Copilot Enable",
    },
    {
      "<leader>cod",
      "<cmd>Copilot disable<cr>",
      desc = "Copilot disable",
    },
  },
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      javascript = true,
      javascriptreact = true,
      typescript = true,
      typescriptreact = true,
      markdown = true,
      help = true,
    },
  },
}

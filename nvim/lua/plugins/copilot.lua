return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  enabled = false,
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
      markdown = true,
      help = true,
    },
  },
}

return {
  "tpope/vim-fugitive",
  lazy = false,
  keys = {
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame file" },
  },
  config = function()
    require("gitsigns").setup()
  end,
}

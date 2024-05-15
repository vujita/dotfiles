return {
  {
    "FabijanZulj/blame.nvim",
    keys = {
      {
        "<leader>gb",
        "<cmd>BlameToggle<cr>",
        desc = "Blame toggle",
      },
    },
    config = function()
      require("blame").setup()
    end,
  },
}

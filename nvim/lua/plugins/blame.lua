return {
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({
        enabled = true,
      })
    end,
  },
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
      require("blame").setup({})
    end,
  },
}

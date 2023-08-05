return {
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "olimorris/neotest-rspec",
    },
    config = function()
      require("neotest-rspec")({
        root_files = function()
          return { "README.md" }
        end,
      })
      require("neotest").setup({
        adapters = {
          require("neotest-rspec"),
        },
      })
    end,
  },
}

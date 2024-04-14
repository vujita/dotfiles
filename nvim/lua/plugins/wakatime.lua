return {
  "wakatime/vim-wakatime",
  -- disable in CODESPACES, it is a bit of a pain to always enter api key
  enabled = os.getenv("CODESPACES") ~= "true",
  keys = {
    {
      "<leader>wt",
      "<cmd>WakaTimeToday<cr>",
      desc = "Wakatime Today",
    },
  },
}

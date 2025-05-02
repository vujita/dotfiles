return {
  "akinsho/git-conflict.nvim",
  version = "*",
  keys = {
    { "<Leader>gCo", ":GitConflictChooseOurs<CR>", { desc = "Choose Ours" } },
    { "<Leader>gCt", ":GitConflictChooseTheirs<CR>", { desc = "Choose Theirs" } },
    { "<Leader>gCb", ":GitConflictChooseBoth<CR>", { desc = "Choose Both" } },
    { "<Leader>gCn", ":GitConflictChooseNone<CR>", { desc = "Choose None" } },
    { "<Leader>gCN", ":GitConflictNextConflict<CR>", { desc = "Next Conflict" } },
    { "<Leader>gCp", ":GitConflictPrevConflict<CR>", { desc = "Previous Conflict" } },
    { "<Leader>gCl", ":GitConflictPrevConflict<CR>", { desc = "List Conflict" } },
  },
  config = true,
}

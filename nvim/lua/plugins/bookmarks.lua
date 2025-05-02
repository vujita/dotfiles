return {
  {
    -- nmap <Leader><Leader> <Plug>BookmarkToggle
    -- nmap <Leader>i <Plug>BookmarkAnnotate
    -- nmap <Leader>a <Plug>BookmarkShowAll
    -- nmap <Leader>j <Plug>BookmarkNext
    -- nmap <Leader>k <Plug>BookmarkPrev
    -- nmap <Leader>c <Plug>BookmarkClear
    -- nmap <Leader>x <Plug>BookmarkClearAll
    -- nmap <Leader>kk <Plug>BookmarkMoveUp
    -- nmap <Leader>jj <Plug>BookmarkMoveDown
    -- nmap <Leader>g <Plug>BookmarkMoveToLine
    -- https://github.com/MattesGroeger/vim-bookmarks
    "MattesGroeger/vim-bookmarks",
    enabled = true,
    config = function()
      vim.cmd("BookmarkLoad " .. os.getenv("HOME") .. "/.vim-bookmarks")
    end,
    keys = {
      {
        "<leader>mm",
        function()
          vim.cmd("BookmarkToggle")
          vim.cmd("BookmarkSave " .. os.getenv("HOME") .. "/.vim-bookmarks")
        end,
        desc = "Toggle Bookmark",
      },
      {
        "<leader>mi",
        function()
          vim.cmd("BookmarkAnnotate")
          vim.cmd("BookmarkSave " .. os.getenv("HOME") .. "/.vim-bookmarks")
        end,
        -- "<cmd>BookmarkAnnotate<cr>",
        desc = "Add/edit/remove annotation at current line",
      },
      {
        "<leader>mn",
        "<cmd>BookmarkNext<cr>",
        desc = "Jump to next bookmark in buffer",
      },
      {
        "<leader>mp",
        "<cmd>BookmarkPrev<cr>",
        desc = "Jump to previous bookmark in buffer	",
      },
      {
        "<leader>ma",
        "<cmd>BookmarkShowAll<cr>",
        desc = "Show all bookmarks (toggle)	",
      },
      {
        "<leader>mc",
        function()
          vim.cmd("BookmarkClear")
          vim.cmd("BookmarkSave " .. os.getenv("HOME") .. "/.vim-bookmarks")
        end,
        -- "<cmd>BookmarkClear<cr>",
        desc = "Clear bookmarks in current buffer only",
      },
      {
        "<leader>mx",
        function()
          vim.cmd("BookmarkClearAll")
          vim.cmd("BookmarkSave " .. os.getenv("HOME") .. "/.vim-bookmarks")
        end,
        -- "<cmd>>BookmarkClearAll<cr>",
        desc = "Clear bookmarks in all buffers	",
      },
    },
  },
}

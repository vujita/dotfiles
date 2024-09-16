return {
  {
    -- nmap <Leader>kk <Plug>BookmarkMoveUp
    -- nmap <Leader>jj <Plug>BookmarkMoveDown
    -- nmap <Leader>g <Plug>BookmarkMoveToLine
    -- https://github.com/MattesGroeger/vim-bookmarks
    "MattesGroeger/vim-bookmarks",
    enabled = true,
    keys = {
      {

        -- nmap <Leader><Leader> <Plug>BookmarkToggle
        "<leader>mm",
        "<cmd>BookmarkToggle<cr>",
        desc = "Toggle Bookmark",
      },
      {
        -- nmap <Leader>i <Plug>BookmarkAnnotate
        "<leader>mi",
        "<cmd>BookmarkAnnotate<cr>",
        desc = "Add/edit/remove annotation at current line",
      },
      {
        -- nmap <Leader>a <Plug>BookmarkShowAll
        "<leader>a",
        "<cmd>BookmarkShowAll<cr>",
        desc = "Show all bookmarks",
      },
      {

        -- nmap <Leader>j <Plug>BookmarkNext
        "<leader>mn",
        "<cmd>BookmarkNext<cr>",
        desc = "Jump to next bookmark in buffer",
      },
      {
        -- nmap <Leader>k <Plug>BookmarkPrev
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

        -- nmap <Leader>c <Plug>BookmarkClear
        "<leader>mc",
        "<cmd>BookmarkClear<cr>",
        desc = "Clear bookmarks in current buffer only",
      },

      -- nmap <Leader>x <Plug>BookmarkClearAll
      {
        "<leader>mx",
        "<cmd>BookmarkClearAll<cr>",
        desc = "Clear bookmarks in all buffers	",
      },
    },
  },
}

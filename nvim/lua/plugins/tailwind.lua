return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {

          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {
            "typescript",
            "typescriptreact",
            "css",
            "scss",
            "sass",
          },
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
      },
      setup = {

        tailwindcss = function(_, opts)
          opts.filetypes = opts.filetypes or {}

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Additional settings for Phoenix projects
          opts.settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "cva\\(((?:[^()]|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cx\\(((?:[^()]|\\([^()]*\\))*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                },
              },
              -- experimental = {
              --   classRegex = {
              --     { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              --     { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              --     { "classname\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              --     { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              --   },
              -- },
              includeLanguages = {
                typescript = "typescript",
                typescriptreact = "typescriptreact",
                javascript = "javascript",
                javascriptreact = "javascriptreact",
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          }

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    -- optionally, override the default options:
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = true, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■",
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = true,
        },
        { mode = "foreground" },
        -- all the sub-options of filetypes apply to buftypes
      })

      require("cmp").config.formatting = {
        format = require("tailwindcss-colorizer-cmp").formatter,
      }
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",

    keys = {
      {
        "<leader>tR",
        function()
          require("tailwind-tools").setup({})

          require("lspconfig").tailwindcss.setup({
            settings = {
              tailwindCSS = {
                experimental = {
                  classRegex = {
                    { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                    { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                    { "classname\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                    { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  },
                },
              },
            },
          })
        end,
        -- "<cmd>TailwindColorEnable<cr>",
        desc = "TailwindColorRefresh",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
      "neovim/nvim-lspconfig", -- optional
    },
    config = function()
      require("tailwind-tools").setup({})
      require("lspconfig").tailwindcss.setup({
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "classname\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              },
            },
          },
        },
      })
    end,
    opts = {}, -- your configuration
  },
}

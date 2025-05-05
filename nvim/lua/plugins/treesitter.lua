return {

  {
    "neovim/nvim-lspconfig",
    keys = {

      {
        "<leader>cL",
        function()
          vim.print("Restart LSP(🤷)")
          vim.cmd("LspRestart")
        end,
        desc = "Restart LSP(🤷)",
      },
      {
        "<leader>cx",
        function()
          vim.print("Start LSP(🚀)")
          vim.cmd("LspStart")
        end,
        desc = "LSP start(▶️ )",
      },

      {
        "<leader>Y",
        function()
          vim.api.nvim_call_function("setreg", { "+", vim.fn.fnamemodify(vim.fn.expand("%"), ":.") })
        end,
        desc = "Copy relative path",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        -- "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              web = {
                projectWideIntellisense = {
                  enabled = true,
                },
              },
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },

            experimental = {
              enableProjectDiagnostics = false,
            },
            -- enablePromptUseWorkspaceTsdk = true,
            maxTsServerMemory = 16096,
            nodePath = "$HOME/.nvm/versions/node/v18.12.1/bin/node",
            tsserver = {
              web = {
                projectWideIntellisense = {
                  enabled = true,
                },
              },
              experimental = {
                enableProjectDiagnostics = false,
              },
              -- enablePromptUseWorkspaceTsdk = true,
              maxTsServerMemory = 16096,
              nodePath = "$HOME/.nvm/versions/node/v18.12.1/bin/node",
            },
            typescript = {
              -- enablePromptUseWorkspaceTsdk = true,
              maxTsServerMemory = 16096,
              nodePath = "$HOME/.nvm/versions/node/v18.12.1/bin/node",
              tsserver = {
                experimental = {
                  enableProjectDiagnostics = false,
                },
                -- enablePromptUseWorkspaceTsdk = true,
                maxTsServerMemory = 16096,
                nodePath = "$HOME/.nvm/versions/node/v18.12.1/bin/node",
              },
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                LazyVim.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                LazyVim.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              LazyVim.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              LazyVim.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              LazyVim.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
          {
            "<leader>cL",
            function()
              vim.print("Restart LSP(🤷)")
              vim.cmd("LspRestart")
            end,
            desc = "Restart LSP(🤷)",
          },
          {
            "<leader>cx",
            function()
              vim.print("Start LSP(🚀)")
              vim.cmd("LspStart")
            end,
            desc = "LSP start(▶️ )",
          },

          {
            "<leader>Y",
            function()
              vim.api.nvim_call_function("setreg", { "+", vim.fn.fnamemodify(vim.fn.expand("%"), ":.") })
            end,
            desc = "Copy relative path",
          },
        },
      },
      setup = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable tsserver
          return true
        end,
        vtsls = function(_, opts)
          LazyVim.lsp.on_attach(function(client, buffer)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
              ---@type string, string, lsp.Range
              local action, uri, range = unpack(command.arguments)

              local function move(newf)
                client.request("workspace/executeCommand", {
                  command = command.command,
                  arguments = { action, uri, range, newf },
                })
              end

              local fname = vim.uri_to_fname(uri)
              client.request("workspace/executeCommand", {
                command = "typescript.tsserverRequest",
                arguments = {
                  "getMoveToRefactoringFileSuggestions",
                  {
                    file = fname,
                    startLine = range.start.line + 1,
                    startOffset = range.start.character + 1,
                    endLine = range["end"].line + 1,
                    endOffset = range["end"].character + 1,
                  },
                },
              }, function(_, result)
                ---@type string[]
                local files = result.body.files
                table.insert(files, 1, "Enter new path...")
                vim.ui.select(files, {
                  prompt = "Select move destination:",
                  format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                  end,
                }, function(f)
                  if f and f:find("^Enter new path") then
                    vim.ui.input({
                      prompt = "Enter move destination:",
                      default = vim.fn.fnamemodify(fname, ":h") .. "/",
                      completion = "file",
                    }, function(newf)
                      return newf and move(newf)
                    end)
                  elseif f then
                    move(f)
                  end
                end)
              end)
            end
          end, "vtsls")
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})

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
      },
    },
  },
}

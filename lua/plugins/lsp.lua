return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "SmiteshP/nvim-navic",
      }
    },
    config = function()
      vim.lsp.enable("ccls")
      vim.lsp.enable("gopls")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("templ")
      vim.lsp.enable("zls")
      vim.lsp.enable("rust_analyzer")

      vim.keymap.set("n", "<leader>e", vim.diagnostic.setqflist, {})

      vim.keymap.set("n", "<space>fs", function()
        vim.lsp.buf.document_symbol({
          on_list = function(options)
            local items = vim.tbl_filter(function(item)
              return item.kind == "Function"
                  or item.kind == "Method"
                  or item.kind == "Variable"
                  or item.kind == "Constant"
                  or item.kind == "Field"
                  or item.kind == "Property"
                  or item.kind == "Struct"
                  or item.kind == "Union"
                  or item.kind == "Enum"
            end, options.items)

            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            for i, line in ipairs(lines) do
              local name = line:match("^#define[[:space:]]+([A-Za-z_][A-Za-z0-9_]*)")
              if name then
                table.insert(items, {
                  text = name,
                  lnum = i,
                  col = 9, -- column after "#define "
                })
              end
            end

            vim.fn.setqflist({}, " ", {
              title = "Functions & Variables",
              items = items,
            })
            vim.cmd("copen")
          end,
        })
      end)

      vim.keymap.set("n", "<space>ff", function()
        vim.lsp.buf.document_symbol({
          on_list = function(options)
            vim.fn.setqflist({}, " ", {
              title = "Document Symbols",
              items = options.items,
            })
            vim.cmd("copen")
          end,
        })
      end)

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.go" },
        callback = function()
          local params = vim.lsp.util.make_range_params(nil, "utf-16")
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
              end
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, args.buf)
          end

          if client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  }
}

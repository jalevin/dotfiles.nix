-- TREESITTER - highlighting
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "comment",
    "dot",
    "html",
    "go",
    "graphql",
    "javascript",
    "json",
    "php",
    "python",
    "ruby",
    "tsx",
    "typescript",
    "jsonnet",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- MASON package manager
local masonlspconfig = require("mason-lspconfig")
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})
masonlspconfig.setup({
  ensure_installed = {
    "bashls",
    "cmake",
    "dockerls",
    --"golangci_lint_ls",
    "gopls",
    "html",
    "intelephense",
    "jsonls",
    "jsonnet_ls",
    "lua_ls",
    "sqlls",
    "tailwindcss",
    "terraformls",
    "tflint",
    "tsserver",
    "vimls",
  },
})

-- AUTOCOMPLETE get default capabilities for autocomplete
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
masonlspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim", "on_attach" } },
        },
      },
    })
  end,
})

-- LINTER/FORMATTING configure mason for linters
require("mason-null-ls").setup({
  ensure_installed = {
    "ansible-lint",
    "golangci_lint",
    --"goimports_reviser",
    "luacheck",
    "markdownlint",
    "misspell",
    "standardrb",
    "staticcheck",
    "tlint",
    "yamllint",
    "stylua",
    "jq",
    --"action-lint",
  },
  handlers = {},
})


require('lspconfig').solargraph.setup({
  cmd = { "bundle", "exec", "solargraph", "stdio" },
  settings = {
    solargraph = {
      diagnostics = true,
      completion = true
    }
  }
})

local async_formatting = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(
    bufnr,
    "textDocument/formatting",
    vim.lsp.util.make_formatting_params({}),
    function(err, res, ctx)
      if err then
        local err_msg = type(err) == "string" and err or err.message
        -- you can modify the log message / level (or ignore it completely)
        vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
        return
      end

      -- don't apply results if buffer is unloaded or has been modified
      if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
        return
      end

      if res then
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("silent noautocmd update")
        end)
      end
    end
  )
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          async_formatting(bufnr)
        end,
      })
    end
  end,
})

local callback = function()
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      return client.name == "null-ls"
    end,
  })
end

-- COPILOT
--  require("copilot").setup({
--    suggestion = { enabled = false },
--    panel = { enabled = false },
--  })
--  require("copilot_cmp").setup()

-- config for gopls to handle integration tests
--  lspconfig.gopls.setup {
--    capabilities = capabilities,
--    on_attach = on_attach,
--    settings = {
--      gopls =  {
--        -- add flags for integration tests and wire code gen in grafana
--        env = {
--          GOFLAGS="-tags=wireinject"
--          }
--        }
--      }
--    }

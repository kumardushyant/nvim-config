return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "jdtls", "pyright"},
      })

      require("mason-lspconfig").setup_handlers({
        -- Default handler for any installed LSP
        function (server)
          require("lspconfig")[server].setup({})
        end,
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "java-debug-adaptor", "java-test" },
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap", },
  },
}

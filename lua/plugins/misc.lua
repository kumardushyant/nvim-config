return {
  { 
    'github/copilot.vim',
  },
  { 'tpope/vim-sleuth', },
  { 
    'folke/todo-comments.nvim', 
    event = 'VimEnter', 
    dependencies = { 'nvim-lua/plenary.nvim' }, 
    opts = { 
      signs = false 
    }, 
  },
  { 
    'norcalli/nvim-colorizer.lua', 
    init = function()
      vim.o.termguicolors = true
    end,
    config = function()
      require('colorizer').setup()
    end,
  },
}

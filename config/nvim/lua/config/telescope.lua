-- See: https://github.com/nvim-telescope/telescope.nvim/issues/511
require('telescope').setup({
  defaults = {
    sorting_strategy = "ascending",

    layout_strategy = "bottom_pane",
    layout_config = {
      height = 25,
    },

    border = true,
    borderchars = {
      prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
      results = { " " },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },

    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close
      },
    }, 
  },

  pickers = {
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_ivy {
      }
    },
  }
})

require('telescope').load_extension('ghq')
require('telescope').load_extension('ui-select')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Space>', builtin.commands, { desc = "Telescope commands" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope commands" })

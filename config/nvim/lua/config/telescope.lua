-- See: https://github.com/nvim-telescope/telescope.nvim/issues/511
require('telescope').setup({
  defaults = {
    border = true,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    }
  }
})

require('telescope').load_extension('ghq')
require('telescope').load_extension('ui-select')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Space>', builtin.commands, {})

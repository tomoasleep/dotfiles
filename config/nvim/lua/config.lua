vim.o.backspace = "indent,eol,start"
vim.o.number = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.ambiwidth = "double"

vim.o.termguicolors = true

vim.fn["ddu#custom#patch_global"]({
  ui = "filer",
  sourceOptions = {
    _ = {
      matchers = {"matcher_substring"},
    },
  },
  filterParams = {
    matcher_substring = {
      highlightMatched = "Search",
    },
  },
  actionOptions = {
    narrow = {
      quit = false,
    },
  },
  kindOptions = {
    file = {
      defaultAction = "open",
    },
  },
})

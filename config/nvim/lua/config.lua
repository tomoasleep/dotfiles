vim.o.backspace = "indent,eol,start"
vim.o.number = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.ambiwidth = "double"

vim.o.termguicolors = true

-- ddu.vim
vim.fn["ddu#custom#patch_global"]({
  ui = "ff",
  sources = {"file"},
  sourceOptions = {
    _ = {
      matchers = {"matcher_substring"},
    },
  },
  uiParams = {
    ff = {
      split = "floating",
      floatingBorder = "rounded",
      displaySourceName = "long",
    },
    filer = {
      split = "floating"
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

vim.cmd[[
autocmd FileType ddu-ff call My_ddu_my_settings()
function! My_ddu_my_settings() abort
  nnoremap <buffer><silent> <CR> <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <Space> <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> <Tab> <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>
  nnoremap <buffer><silent> i <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-filer call My_ddu_my_filer_settings()
function! My_ddu_my_filer_settings() abort
  nnoremap <buffer><silent> <CR> <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <Space> <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> q <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call My_ddu_filter_my_settings()
autocmd FileType ddu-filer-filter call My_ddu_filter_my_settings()
function! My_ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR> <Esc><Cmd>close<CR>
  nnoremap <buffer><silent> <CR> <Cmd>close<CR>
  nnoremap <buffer><silent> q <Cmd>close<CR>
endfunction
]]

-- nnn.vim
local function copy_to_clipboard(lines)
	local joined_lines = table.concat(lines, "\n")
	vim.fn.setreg("+", joined_lines)
end

require("nnn").setup({
	command = "nnn -o -C",
  layout = {
    window = {
      width = 0.9,
      height = 0.6,
      border = "none",
    },
  },
	set_default_mappings = 0,
	replace_netrw = 1,
	action = {
		["<c-t>"] = "tab split",
		["<c-s>"] = "split",
		["<c-v>"] = "vsplit",
		["<c-o>"] = copy_to_clipboard,
	},
})

-- ddc.vim

vim.cmd [[
  call ddc#custom#patch_global('sourceOptions', {
        \ '_': {
        \   'matchers': ['matcher_head'],
        \   'sorters': ['sorter_rank']},
        \ })

  call ddc#custom#patch_global('sources', ['nvim-lsp'])
  call ddc#custom#patch_global('sourceOptions', {
        \ 'nvim-lsp': {
        \   'mark': 'lsp',
        \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
        \ })

  call ddc#enable()
]]


vim.cmd [[
  call signature_help#enable()
  call popup_preview#enable()
]]

-- vim-better-whitespace
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1
vim.g.strip_whitespace_confirm = 0



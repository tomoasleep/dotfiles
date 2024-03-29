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

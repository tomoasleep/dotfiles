if &compatible
  set nocompatible
endif

if has('nvim')
  let s:config_dir = expand('~/.config/nvim')
  lua <<EOF
  require('start')
EOF
else
  let s:config_dir = expand('~/.vim')
endif

if !has('nvim')
  let s:dein_dir = s:config_dir . '/dein'
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    let s:dein_install_command = '!' . s:dein_repo_dir . '/bin/installer.sh' . ' ' . s:dein_dir
    execute s:dein_install_command
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir

  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    call dein#add(s:dein_repo_dir)

    let s:toml = s:config_dir . '/dein.toml'
    call dein#load_toml(s:toml, {'lazy': 0})

    " let s:lazy_toml = s:config_dir . '/dein_lazy.toml'
    " call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
  endif

  if dein#check_install(['vimproc'])
    call dein#install(['vimproc'])
  endif
  if dein#check_install()
    call dein#install()
  endif
endif

filetype plugin indent on
syntax enable

set backspace=indent,eol,start
set number

set expandtab
set shiftwidth=2
set tabstop=2

set ambiwidth=double

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

let g:python3_host_prog = $PYENV_ROOT . '/shims/python3'
let g:deoplete#enable_at_startup = 1
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'

"" unite.vim
augroup unite_dw
  autocmd! unite_dw
  autocmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()
    " let current_unite = unite#get_current_unite()
    " if current_unite.profile_name =~# '^files'
    "   let context = unite#get_context()
    "   if context.input == ''
    "     let context.input = context.path
    "     " let context.path = ''
    "   endif
    " endif

    " 単語単位からパス単位で削除するように変更
    imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  endfunction
augroup END

let g:unite_enable_start_insert = 1
" call unite#custom#profile('default', 'context', {
"       \   'start_insert': 1,
"       \   'prompt': '> ',
"       \   'prompt-visible': 1
"       \ })
 
" File
command! -nargs=* Uf UniteWithBufferDir -profile-name=files -buffer-name=files file bookmark file/new
command! -nargs=* UF Uf
" Buffer
command! Ub Unite buffer
command! UB Ub
" Bookmark
command! Ubk Unite -buffer-name=files bookmark file/async file/new
command! UBK Ubk
" Bookmark Add
command! Uba UniteBookmarkAdd
command! UBA Uba
" Regeister
command! Ur Unite -buffer-name=register register
command! UR Ur
" outline
command! Uo Unite -buffer-name=outline outline
command! UO Uo
command! Uov Unite -no-quit -toggle -vertical -winwidth=45 -buffer-name=outline outline
command! Uovl Unite -no-quit -toggle -vertical -winwidth=80 -buffer-name=outline outline
command! UOV Uov
command! UOv Uov
" File mru
command! Um Unite file_mru
command! UM Um
" source
command! Uso Unite source
command! USO Uo
" line search
command! Ul Unite line
command! UL Ul
command! Ulc UniteWithCursorWord line
command! ULC Ulc
" find
command! Ufi Unite find
command! UFi Ufi
" grep
command! Ug Unite grep
command! UG Ug
" tag search
command! Ut Unite tag
command! UT Ut
command! Utf Unite tag/file
command! UTF Utf
command! Uti Unite tag/include
command! UTI Uti
" history
command! Uhc Unite history/command
command! UHC Uhc
command! Uhs Unite history/search
command! UHS Uhs
command! Uhy Unite history/yank
command! UHY Uhy
" window
command! Uw Unite window
command! UW Uw
" snipmate
command! Us Unite snippet
command! US Us
" snipmate
command! Utw Unite tweetvim
command! UTW Utw
" all
command! Ua UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file/async

if !has('nvim')
  "" Denite.nvim
  call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

  "" Neomake
  " When writing a buffer, and on normal mode changes (after 750ms).
  call neomake#configure#automake('nw', 750)
  let g:neomake_javascript_enabled_makers = ['jshint', 'jscs', 'eslint', 'flow']
  let g:neomake_error_sign = {
     \ 'text': 'x',
     \ 'texthl': 'NeomakeErrorSign',
     \ }
  let g:neomake_warning_sign = {
     \   'text': '!',
     \   'texthl': 'NeomakeWarningSign',
     \ }
  let g:neomake_message_sign = {
      \   'text': 'M',
      \   'texthl': 'NeomakeMessageSign',
      \ }
  let g:neomake_info_sign = {
      \ 'text': 'ℹ',
      \ 'texthl': 'NeomakeInfoSign'
      \ }

  " File
  command! -nargs=* Df DeniteBufferDir -buffer-name=files file_rec
  command! -nargs=* DF Df
  " Buffer
  command! Db Dnite buffer
  command! DB Db
endif

nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <C-c><C-c> :nohlsearch<CR><Esc>

nnoremap tt :<C-u>tabnew<CR>
nnoremap tn :<C-u>tabnext<CR>
nnoremap tp :<C-u>tabprevious<CR>

if !has('nvim')
  " javascript
  let g:javascript_plugin_flow = 1

  " Automatically start language servers.
  let g:LanguageClient_autoStart = 1
  let g:LanguageClient_diagnosticsDisplay = {
        \     1: {
        \         "name": "Error",
        \         "texthl": "ALEError",
        \         "signText": "x",
        \         "signTexthl": "ALEErrorSign",
        \         "virtualTexthl": "Error",
        \     },
        \     2: {
        \         "name": "Warning",
        \         "texthl": "ALEWarning",
        \         "signText": "!",
        \         "signTexthl": "ALEWarningSign",
        \         "virtualTexthl": "Todo",
        \     },
        \     3: {
        \         "name": "Information",
        \         "texthl": "ALEInfo",
        \         "signText": "ℹ",
        \         "signTexthl": "ALEInfoSign",
        \         "virtualTexthl": "Todo",
        \     },
        \     4: {
        \         "name": "Hint",
        \         "texthl": "ALEInfo",
        \         "signText": "H",
        \         "signTexthl": "ALEInfoSign",
        \         "virtualTexthl": "Todo",
        \     },
        \ }

  nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
  " nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
  nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

  let g:LanguageClient_loggingLevel = 'DEBUG'
  let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')

  " supertab
  let g:SuperTabDefaultCompletionType = "<c-n>"
endif


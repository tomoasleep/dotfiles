local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

function get_config(name)
  return string.format('require("config/%s")', name)
end

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup({ function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  use 'wbthomason/packer.nvim'
  use 'vim-denops/denops.vim'

  use { 'Shougo/ddu.vim', config = get_config("ddu") }
  use 'Shougo/ddu-ui-ff'
  use 'Shougo/ddu-ui-filer'

  use 'Shougo/ddu-kind-file'
  use 'Shougo/ddu-kind-word'

  use 'Shougo/ddu-filter-matcher_substring'

  use 'Shougo/ddu-source-file_rec'
  use 'Shougo/ddu-source-file'
  use 'matsui54/ddu-source-help'
  use 'matsui54/ddu-source-command_history'
  use 'Shougo/ddu-source-buffer'
  use 'Shougo/ddu-source-line'
  use 'Bakudankun/ddu-source-package'
  use '4513ECHO/ddu-source-colorscheme'
  use '4513ECHO/ddu-source-emoji'
  use 'Shougo/ddu-source-action'

  use 'Shougo/ddu-commands.vim'

  use { 'Shougo/ddc.vim', config = get_config("ddc") }
  use 'Shougo/ddc-nvim-lsp'
  use 'Shougo/ddc-matcher_head'
  use 'Shougo/ddc-sorter_rank'
  use { 'matsui54/denops-signature_help', config = get_config("denops-signature_help") }
  use { 'matsui54/denops-popup-preview.vim', config = get_config("denops-popup-preview") }

  use 'vim-scripts/endwise.vim'
  use 'vim-scripts/matchit.zip'
  use 'vim-scripts/neco-look'
  use 'vim-scripts/surround.vim'
  use { 'mcchrish/nnn.vim', config = get_config("nnn") }
  use { 'ntpeters/vim-better-whitespace', config = get_config("better-whitespace") }

  use 'sheerun/vim-polyglot'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'lifepillar/vim-solarized8'
  use 'nathanaelkane/vim-indent-guides'
  use 'mhinz/vim-startify'
  use { 'rcarriga/nvim-notify', config = get_config("notify") }

  use 'github/copilot.vim'

  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'

  use {'akinsho/bufferline.nvim', tag = "*", requires = 'kyazdani42/nvim-web-devicons'}
  use { 'Shougo/unite.vim', tag = 'ver.6.0'}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = require('packer.util').float,
  },
}})

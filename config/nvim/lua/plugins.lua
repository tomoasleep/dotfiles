local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  use 'wbthomason/packer.nvim'
  use 'vim-denops/denops.vim'

  use 'Shougo/ddu.vim'
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

  use 'vim-scripts/endwise.vim'
  use 'vim-scripts/matchit.zip'
  use 'vim-scripts/neco-look'
  use 'vim-scripts/surround.vim'

  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'lifepillar/vim-solarized8'
  use 'nathanaelkane/vim-indent-guides'
  use 'mhinz/vim-startify'
  use 'neovim/nvim-lspconfig'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

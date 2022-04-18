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
  use 'wbthomason/packer.nvim'
  use 'vim-denops/denops.vim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = get_config('telescope'),
  }

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  }

  use { "aserowy/tmux.nvim", config = get_config("tmux") }

  use 'vim-scripts/endwise.vim'
  use 'vim-scripts/matchit.zip'
  use 'vim-scripts/neco-look'
  use 'vim-scripts/surround.vim'
  use { 'mcchrish/nnn.vim', config = get_config("nnn") }
  use { 'ntpeters/vim-better-whitespace', config = get_config("better-whitespace") }

  use { 'nvim-treesitter/nvim-treesitter', config = get_config("treesitter") }
  -- use 'sheerun/vim-polyglot'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use { 'lifepillar/vim-solarized8', config = get_config("solarized8") }
  use 'morhetz/gruvbox'
  use { 'shaunsingh/solarized.nvim', config = get_config("solarized") }
  use 'nathanaelkane/vim-indent-guides'
  use 'mhinz/vim-startify'
  use { 'petertriho/nvim-scrollbar', config = get_config("scrollbar") }
  use { 'rcarriga/nvim-notify', config = get_config("notify") }

  use 'github/copilot.vim'

  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use { 'tamago324/nlsp-settings.nvim', config = get_config("nlsp-settings") }
  use { 'j-hui/fidget.nvim', config = get_config("fidget") }
  use { 'folke/lsp-colors.nvim', config = get_config("lsp-colors") }
  use { 'tami5/lspsaga.nvim', config = get_config("lspsaga") }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = get_config("trouble"),
  }

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

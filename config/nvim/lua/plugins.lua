function get_config(name)
  local config_path = string.format('config.%s', name)
  local function _require_config(...)
    require(config_path)
  end
  return _require_config
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerCompile  augroup end
-- ]])

return require('lazy').setup({
  spec = {
    'vim-denops/denops.vim',

    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ghq.nvim',
        'nvim-tree/nvim-web-devicons',
        'nvim-telescope/telescope-ui-select.nvim',
        'davvid/telescope-git-grep.nvim',
      },
      version = '*',
      config = get_config('telescope'),
    },

    {
      'hrsh7th/cmp-nvim-lsp',
      dependencies = {
        'neovim/nvim-lspconfig',
      },
    },

    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    {
      'hrsh7th/nvim-cmp',
      config = get_config('cmp')
    },

    {
    "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
    },

    {
      "ohakutsu/socks-copypath.nvim",
      config = function()
        require("socks-copypath").setup()
      end,
    },

    { "aserowy/tmux.nvim", config = get_config("tmux") },

    'vim-scripts/endwise.vim',
    'vim-scripts/matchit.zip',
    'vim-scripts/neco-look',
    'vim-scripts/surround.vim',
    { 'mcchrish/nnn.vim', config = get_config("nnn") },
    -- { 'ntpeters/vim-better-whitespace', config = get_config("better-whitespace") },

    { 'nvim-treesitter/nvim-treesitter', config = get_config("treesitter") },
    -- use 'sheerun/vim-polyglot'
    { 'vim-airline/vim-airline', config = get_config("airline") },
    'vim-airline/vim-airline-themes',
    { 'lifepillar/vim-solarized8', config = get_config("solarized8") },
    'morhetz/gruvbox',
    { 'shaunsingh/solarized.nvim', config = get_config("solarized") },
    'nathanaelkane/vim-indent-guides',
    'mhinz/vim-startify',
    { 'petertriho/nvim-scrollbar', config = get_config("scrollbar") },
    -- { 'rcarriga/nvim-notify', config = get_config("notify") },

    'github/copilot.vim',

    'neovim/nvim-lspconfig',
    'williamboman/nvim-lsp-installer',
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { 'tamago324/nlsp-settings.nvim', config = get_config("nlsp-settings") },
    { 'j-hui/fidget.nvim', config = get_config("fidget") },
    { 'folke/lsp-colors.nvim', config = get_config("lsp-colors") },
    -- { 'tami5/lspsaga.nvim', dependencies = { "nvim-lspconfig" }, config = get_config("lspsaga-vim") },

    {
      "folke/trouble.nvim",
      dependencies = "kyazdani42/nvim-web-devicons",
      config = get_config("trouble"),
    },

    {'akinsho/bufferline.nvim', version = "*", dependencies = 'kyazdani42/nvim-web-devicons'},
    { 'Shougo/unite.vim', tag = 'ver.6.0'},

    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
      opts = {
        -- For details, see: https://github.com/yetone/avante.nvim
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
  },
})

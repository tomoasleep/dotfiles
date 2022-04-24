local lspconfig = require('lspconfig')
local server = require "nvim-lsp-installer.server"
local installers = require "nvim-lsp-installer.installers"
local gem = require "nvim-lsp-installer.core.managers.gem"
local gitgem = require "git-gem"

local M = {}

function M.server(name)
  local root_dir = server.get_server_root_path(name)

  return server.Server:new {
    name = name,
    root_dir = root_dir,
    async = true,
    languages = { "ruby" },
    homepage = "https://github.com/tomoasleep/yoda",
    installer = gem.packages { "yoda-language-server" },
    default_options = {
      cmd_env = gem.env(root_dir),
    },
  }
end

function M.dev_server(name)
  local root_dir = server.get_server_root_path(name)

  return server.Server:new {
    name = name,
    root_dir = root_dir,
    async = true,
    languages = { "ruby" },
    homepage = "https://github.com/tomoasleep/yoda",
    installer = gitgem.package("https://github.com/tomoasleep/yoda"),
    default_options = {
      cmd_env = gitgem.env(root_dir),
    },
  }
end

function M.local_server(name)
  local root_dir = server.get_server_root_path(name)

  return server.Server:new {
    name = name,
    root_dir = root_dir,
    languages = { "ruby" },
    homepage = "https://github.com/tomoasleep/yoda",
    installer = installers.noop,
    default_options = {},
  }
end

function M.config()
  return {
    default_config = {
      cmd = { "yoda", "server" },
      filetypes = { "ruby" },
      root_dir = lspconfig.util.root_pattern('Gemfile', '.git'),
    },
  }
end

return M

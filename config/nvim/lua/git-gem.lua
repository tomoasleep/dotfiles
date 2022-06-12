local std = require "nvim-lsp-installer.core.managers.std"
local git = require "nvim-lsp-installer.core.managers.git"
local fs = require "nvim-lsp-installer.core.fs"
local path = require "nvim-lsp-installer.core.path"
local process = require "nvim-lsp-installer.core.process"
local result = require "nvim-lsp-installer.core.result"

local M = {}

function M.package(pkg)
  return function()
    local ctx = installer.context()

    std.ensure_executable("ruby", "ruby was not found in path")
    std.ensure_executable("git", "git was not found in path")
    std.ensure_executable("gem", "gem was not found in path")
    git.clone({ pkg, directory = "./repo" })

    local dir = fs.readdir(path.concat { ctx.install_dir, "repo" })
    local gemspec = findPath(dir, "gemspec$")
    local gem = findPath(dir, "gem$")

    if gemspec then
      ctx.spawn.gem({
          "build",
          gemspec,
          cwd = path.concat { ctx.cwd:get(), "repo" },
      })
    else
      error("Failed to find gemspec")
    end

    if gem then
      ctx.spawn.gem({
        "install",
        "--no-user-install",
        "--install-dir=.",
        "--bindir=bin",
        "--no-document",
        path.concat { "./repo", gem },
      })
    else
      error("Failed to find gem")
    end
  end
end

function M.env(root_dir)
  return {
    GEM_HOME = root_dir,
    GEM_PATH = root_dir,
    PATH = process.extend_path { path.concat { root_dir, "bin" } },
  }
end

function findPath(l, pattern)
  for _, v in ipairs(l) do
    if string.match(v.name, pattern) then
      return v.name
    end
  end
  return nil
end

return M

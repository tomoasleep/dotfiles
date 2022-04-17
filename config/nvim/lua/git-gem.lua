local process = require "nvim-lsp-installer.process"
local fs = require "nvim-lsp-installer.fs"
local path = require "nvim-lsp-installer.path"
local installers = require "nvim-lsp-installer.installers"
local std = require "nvim-lsp-installer.installers.std"

local M = {}

function M.package(pkg)
  return installers.pipe {
    std.ensure_executables {
      { "ruby", "ruby was not found in path" },
      { "git", "gem was not found in path" },
      { "gem", "gem was not found in path" },
    },
    std.git_clone(pkg, { directory = "./repo" }),
    function(_, callback, ctx)
      local dir = fs.readdir(path.concat { ctx.install_dir, "repo" })
      local gemspec = findPath(dir, "gemspec$")

      if gemspec then
        process.spawn("gem", {
            args = {
              "build",
              gemspec,
            },
            cwd = path.concat { ctx.install_dir, "repo" },
            stdio_sink = ctx.stdio_sink,
        }, callback)
      else
        ctx.stdio_sink.stderr("Failed to find gemspec")
        callback(false)
      end
    end,
    function(_, callback, ctx)
      local dir = fs.readdir(path.concat { ctx.install_dir, "repo" })
      local gem = findPath(dir, "gem$")

      if gem then
        process.spawn("gem", {
            args = {
              "install",
              "--no-user-install",
              "--install-dir=.",
              "--bindir=bin",
              "--no-document",
              path.concat { "./repo", gem },
            },
            cwd = ctx.install_dir,
            stdio_sink = ctx.stdio_sink,
        }, callback)
      else
        ctx.stdio_sink.stderr("Failed to find gem")
        callback(false)
      end
    end,
  }
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

# Zellij Bundler Configuration
# Define your Zellij plugins here

# Global settings
set :output_dir, "./config/zellij/plugins"
set :force, false

plugin "mostafaqanbaryan/zellij-switch"

# Plugins
# plugin "leakec/multitask"
# plugin "ndavd/zellij-cb"

# Example with version
# plugin "cunialino/zellij-sessionizer", tag: "v0.1.1"

# Example with custom output and filename
# plugin "owner/repo", to: "~/.zellij/plugins"
# plugin "owner/repo", as: "custom-name.wasm"

# Example with block syntax
# plugin "owner/repo" do
#   tag "v1.0.0"
#   to "./custom/path"
#   as "custom-name.wasm"
# end

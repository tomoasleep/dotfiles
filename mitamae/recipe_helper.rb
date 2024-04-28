MItamae::RecipeContext.class_eval do
  def include_cookbook(name)
    mitamae_dir = File.expand_path('..', __FILE__)
    include_recipe File.join(mitamae_dir, 'cookbooks', name, 'default')
  end

  def include_role(name)
    mitamae_dir = File.expand_path('..', __FILE__)
    include_recipe File.join(mitamae_dir, 'roles', name, 'default')
  end

  def has_package?(name)
    result = run_command("dpkg-query -f '${Status}' -W #{name.shellescape} | grep -E '^(install|hold) ok installed$'", error: false)
    result.exit_status == 0
  end

  def dotfiles_path(path)
    File.expand_path(path, dotfiles_dir)
  end

  def dotfiles_dir
    root_dir = File.expand_path('../..', __FILE__)
  end

  def from_home(path)
    File.expand_path(path, ENV['HOME'])
  end

  def devcontainer?
    # https://github.com/microsoft/vscode-remote-release/issues/3517
    (ENV['REMOTE_CONTAINERS'] || '').length > 0
  end
end

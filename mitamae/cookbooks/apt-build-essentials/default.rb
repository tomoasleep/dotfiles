include_cookbook 'apt'

apt 'software-properties-common'
apt 'automake'
apt 'autoconf'
apt 'build-essential'
apt 'gettext'
apt 'libreadline-dev'
apt 'zlib1g-dev'
apt 'zip'

unless devcontainer?
  apt 'gnome-keyring' # https://github.com/microsoft/vscode/issues/92972#issuecomment-625751232
  apt 'cmake'
  apt 'ssh'
  apt 'libncurses-dev'
  apt 'libmariadb-dev'
  apt 'libpq-dev'
  apt 'libssl-dev'
  apt 'libgdbm-dev'
  apt 'libyaml-dev'
  apt 'libxslt1-dev'
  apt 'libffi-dev'
  apt 'libtool'
  apt 'libgdbm-compat-dev'
  apt 'pkg-config'
  apt 'unixodbc-dev'
end

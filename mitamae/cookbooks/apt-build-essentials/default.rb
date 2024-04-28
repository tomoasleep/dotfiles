include_cookbook 'apt'

apt 'gnome-keyring' # https://github.com/microsoft/vscode/issues/92972#issuecomment-625751232
apt 'software-properties-common'
apt 'ssh'
apt 'automake'
apt 'autoconf'
apt 'build-essential'
apt 'gettext'
apt 'libreadline-dev'
apt 'libncurses-dev'
apt 'libssl-dev'
apt 'libgdbm-dev'
apt 'libyaml-dev'
apt 'libxslt1-dev'
apt 'libffi-dev'
apt 'libtool'
apt 'libgdbm-compat-dev'
apt 'pkg-config'
apt 'unixodbc-dev'
apt 'zlib1g-dev'
apt 'zip'

unless devcontainer?
  apt 'cmake'
  apt 'libmariadb-dev'
  apt 'libpq-dev'
end

#!/bin/sh

pypy_url='https://bitbucket.org/squeaky/portable-pypy/downloads/pypy-5.8-1-linux_x86_64-portable.tar.bz2'
git_repo='https://github.com/xianghuzhao/cepcenv.git'

download_http() {
  if which curl >/dev/null 2>&1; then
    curl -L $1
  elif which wget >/dev/null 2>&1; then
    wget -O - $1
  else
    echo >&2 "Please install curl or wget first"
    exit 1
  fi
}

main() {
  if [ $# -eq 0 ]; then
    echo >&2 "Please specify the installation directory"
    exit 2
  elif [ $# -gt 1 ]; then
    echo >&2 "Only one parameter allowed"
    exit 2
  fi

  install_dir=$1

  mkdir -p $install_dir

  cd $install_dir
  install_full_dir=$(pwd)

  rm -rf pypy*

  download_http $pypy_url | tar xj

  cd pypy*
  pypy_dir=$(pwd)
  cd ..

  ${pypy_dir}/bin/pypy -m ensurepip
  ${pypy_dir}/bin/pip install -U pip wheel

  ${pypy_dir}/bin/pip install git+${git_repo}

  echo "eval \"\$(${pypy_dir}/bin/cepcenv_cmd init)\"" > setup.sh
}

main "$@"

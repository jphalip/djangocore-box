#!/bin/bash

# Author: Julien Phalip
# Copyright (c) Django Software Foundation and individual contributors.
# All rights reserved.

# TODO: edit debian_defaults

# Run everything from vagrant's home
cd /home/vagrant

usage ()
{
   echo "Usage: $0 version1 [version2...] -d|--default <version>"
}

if [ $# -lt 1 ]; then
  usage
  exit 2
fi

VERSIONS=()
DEFAULT=$1

while test "$1" != "" ; do
    case $1 in
        --default)
            DEFAULT=$2
            shift
            shift
        ;;
        --help|-h)
            usage
            exit 0
        ;;
        -*)
            echo "Error: no such option $1"
            usage
            exit 1
        ;;
    esac
    VERSIONS+=( $1 )
    shift
done


if [ -e $HOME/.python-installed ]; then
  echo 'All versions of python already installed'
  exit 0
fi

ROOT_PATH="/djangocore-box"

# Install each specified version of Python
for VERSION in ${VERSIONS[@]}; do
  if [ ! -d "/opt/python${VERSION:0:3}/" ]; then
    echo "Dowloading Python ${VERSION}..."
    wget http://python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz &> /dev/null
    echo "Installing Python ${VERSION}. This will take a few minutes..."
    tar xvfz Python-${VERSION}.tgz
    cd Python-${VERSION}
    ./configure --prefix=/opt/python${VERSION:0:3}
    make
    sudo make install
    if [ ${VERSION[0]} = '3' ]; then
      sudo ln -fs /opt/python${VERSION:0:3}/bin/python3 /usr/bin/python${VERSION:0:3}
    else
      sudo ln -fs /opt/python${VERSION:0:3}/bin/python${VERSION:0:3} /usr/bin/python${VERSION:0:3}
    fi

    if [ $DEFAULT = $VERSION ]; then
      # Point the default 'python' command to the specified version
      sudo ln -fs /usr/bin/python${VERSION:0:3} /usr/bin/python

      # Install pip
      wget http://python-distribute.org/distribute_setup.py &> /dev/null
      sudo python${VERSION:0:3} distribute_setup.py
      rm distribute_setup.py
      wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py &> /dev/null
      sudo python${VERSION:0:3} get-pip.py
      rm get-pip.py

      echo "export PATH=\$PATH:/opt/python${VERSION:0:3}/bin/" >> $HOME/.profile
      export PATH=$PATH:/opt/python${VERSION:0:3}/bin/

      # Set up pip cache so we don't have to download the same packages multiple times
      echo "export PIP_DOWNLOAD_CACHE=\$HOME/.pip_download_cache" >> $HOME/.profile

      # Set up virtualenvwrapper
      sudo /opt/python${VERSION:0:3}/bin/pip install virtualenv virtualenvwrapper
      echo "export WORKON_HOME=\$HOME/.virtualenvs"  >> $HOME/.profile
      echo "source /opt/python${VERSION:0:3}/bin/virtualenvwrapper.sh" >> $HOME/.profile
      mkdir /home/vagrant/.virtualenvs
    fi

    # Cleanup
    cd ..
    sudo rm Python-${VERSION}.tgz
    sudo rm -rf Python-${VERSION}
  fi
done


# Remove the pre-installed version of Python
sudo rm /usr/bin/python2
sudo rm -rf /usr/local/lib/python2.6


# Create the virtualenvs
for VERSION in ${VERSIONS[@]}; do
  /opt/python${DEFAULT:0:3}/bin/virtualenv $HOME/.virtualenvs/py${VERSION:0:3} --system-site-packages --python=/usr/bin/python${VERSION:0:3}
  if [ -e "$ROOT_PATH/requirements/requirements-python${VERSION:0:3}.txt" ]; then
    REQUIREMENTS_TXT=requirements-python${VERSION:0:3}.txt
  else
    REQUIREMENTS_TXT=requirements.txt
  fi
  PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache $HOME/.virtualenvs/py${VERSION:0:3}/bin/pip install -r $ROOT_PATH/requirements/$REQUIREMENTS_TXT

  # Create symlinks and aliases for the various types of database settings
  DATABASES=( 'spatialite' 'mysql' 'postgresql' 'postgis' )
  for DATABASE in ${DATABASES[@]}; do
    ln -fs $ROOT_PATH/test_settings/djangocore_test_$DATABASE.py $HOME/.virtualenvs/py${VERSION:0:3}/lib/python${VERSION:0:3}/site-packages/djangocore_test_$DATABASE.py
    echo "alias runtests${VERSION:0:3}-$DATABASE='PYTHONPATH=/django $HOME/.virtualenvs/py${VERSION:0:3}/bin/python /django/tests/runtests.py --settings=djangocore_test_$DATABASE'"  >> $HOME/.profile
  done

  # Django already ships with test_sqlite.py, so we use that.
  echo "alias runtests${VERSION:0:3}-sqlite='PYTHONPATH=/django $HOME/.virtualenvs/py${VERSION:0:3}/bin/python /django/tests/runtests.py --settings=test_sqlite'"  >> $HOME/.profile
done


# Create a flag file to prevent this script from being run in subsequent vagrant-up's.
touch $HOME/.python-installed

#!/bin/bash

# Copyright (c) 2013 Julien Phalip and contributors.
# Licensed under the BSD license.

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

# Make old versions of Python accessible
sudo add-apt-repository -y ppa:fkrull/deadsnakes
sudo apt-get -y update

# Install each specified version of Python
for VERSION in ${VERSIONS[@]}; do
  if [ ! -d "/usr/bin/python${VERSION}/" ]; then
    sudo apt-get -y install python${VERSION} python${VERSION}-dev
  fi
done


# Install pip
wget http://python-distribute.org/distribute_setup.py &> /dev/null
sudo python2.7 distribute_setup.py
rm distribute_setup.py
rm distribute*.tar.gz
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py &> /dev/null
sudo python2.7 get-pip.py
rm get-pip.py

# Set up pip cache so we don't have to download the same packages multiple times
echo "export PIP_DOWNLOAD_CACHE=\$HOME/.pip_download_cache" >> $HOME/.profile

# Set up virtualenvwrapper
sudo /usr/local/bin/pip install virtualenv==1.7.2 virtualenvwrapper  # virtualenv > 1.7.2 doesn't support Python 2.4
echo "export WORKON_HOME=\$HOME/.virtualenvs"  >> $HOME/.profile
echo "source /usr/local/bin/virtualenvwrapper.sh" >> $HOME/.profile
mkdir /home/vagrant/.virtualenvs



# Create the virtualenvs
for VERSION in ${VERSIONS[@]}; do
  /usr/local/bin/virtualenv $HOME/.virtualenvs/py${VERSION} --system-site-packages --python=/usr/bin/python${VERSION}
  if [ -e "$ROOT_PATH/requirements/requirements-python${VERSION}.txt" ]; then
    REQUIREMENTS_TXT=requirements-python${VERSION}.txt
  else
    REQUIREMENTS_TXT=requirements.txt
  fi
  PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache $HOME/.virtualenvs/py${VERSION}/bin/pip install -r $ROOT_PATH/requirements/$REQUIREMENTS_TXT

  # Create symlinks and aliases for the various types of database settings
  DATABASES=( 'spatialite' 'mysql' 'postgresql' 'postgis' )
  for DATABASE in ${DATABASES[@]}; do
    ln -fs $ROOT_PATH/test_settings/djangocore_test_$DATABASE.py $HOME/.virtualenvs/py${VERSION}/lib/python${VERSION}/site-packages/djangocore_test_$DATABASE.py
    echo "alias runtests${VERSION}-$DATABASE='PYTHONPATH=/django $HOME/.virtualenvs/py${VERSION}/bin/python /django/tests/runtests.py --settings=djangocore_test_$DATABASE'"  >> $HOME/.profile
  done

  # Django already ships with test_sqlite.py, so we use that.
  echo "alias runtests${VERSION}-sqlite='PYTHONPATH=/django $HOME/.virtualenvs/py${VERSION}/bin/python /django/tests/runtests.py --settings=test_sqlite'"  >> $HOME/.profile
done

echo "alias enable-selenium='export DISPLAY=:99; Xvfb -ac :99 2>/dev/null &'"  >> $HOME/.profile


# Create a flag file to prevent this script from being run in subsequent vagrant-up's.
touch $HOME/.python-installed

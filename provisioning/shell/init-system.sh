#!/bin/bash

# Author: Julien Phalip
# Copyright (c) Django Software Foundation and individual contributors.
# All rights reserved.

# Update system's packages ---------------------------------------------------
if [ ! -e /home/vagrant/.system-updated ]; then
  echo "Updating the system's package references. This can take a few minutes..."
  sudo apt-get -y update
  sudo apt-get -y install make curl gettext
  sudo apt-get -y install g++  # Needed to install python
  sudo apt-get -y install libbz2-dev  # For bzip2 support in Python
  sudo apt-get -y install libsqlite3-dev  # For pysqlite
  sudo apt-get -y install libjpeg-dev  # For PIL
  sudo apt-get -y install postgresql-server-dev-8.4 libxml2-dev  # For postgis

  # Requirements for headless Selenium tests
  sudo apt-get install -y xvfb firefox xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

  # Make sure the system uses UTF-8 so that PostgreSQL does too.
  sudo locale-gen en_US.UTF-8
  sudo update-locale LANG=en_US.UTF-8

  touch /home/vagrant/.system-updated
fi

# Git configuration ----------------------------------------------------------
if [ -e /home/vagrant/.hosthome/.gitconfig ]; then
  ln -fs /home/vagrant/.hosthome/.gitconfig /home/vagrant/.gitconfig
fi

if [ -e /home/vagrant/.hosthome/.gitignore ]; then
  ln -fs /home/vagrant/.hosthome/.gitignore /home/vagrant/.gitignore
fi

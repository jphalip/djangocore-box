#!/bin/bash

# Copyright (c) 2013 Julien Phalip and contributors.
# Licensed under the BSD license.

# Update system's packages ---------------------------------------------------
if [ ! -e /home/vagrant/.system-updated ]; then
  echo "Updating the system's package references. This can take a few minutes..."
  sudo apt-get -y update
  sudo apt-get -y install make curl gettext
  sudo apt-get -y install g++  # Needed to install python
  sudo apt-get -y install libbz2-dev  # For bzip2 support in Python
  sudo apt-get -y install libsqlite3-dev  # For pysqlite
  sudo apt-get -y install libjpeg-dev  # For PIL
  sudo apt-get -y install postgresql-server-dev-9.1 libxml2-dev  # For postgis
  sudo apt-get -y install pkg-config  # For spatialite-tools

  # Requirements for headless Selenium tests
  sudo apt-get install -y xvfb firefox xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

  #set the system to use en_US.utf8 so that all python tests will pass correctly.
  echo 'LC_ALL="en_US.utf8"' > "etc/default/locale"

  # Make sure the system uses UTF-8 so that PostgreSQL does too.
  echo "LANG=en_US.UTF-8
  LANGUAGE=en_US.UTF-8
  LANGUAGE=en_US.UTF-8
  LC_CTYPE=en_US.UTF-8
  LC_NUMERIC=en_US.UTF-8
  LC_TIME=en_US.UTF-8
  LC_COLLATE=en_US.UTF-8
  LC_MONETARY=en_US.UTF-8
  LC_MESSAGES=en_US.UTF-8
  LC_PAPER=en_US.UTF-8
  LC_NAME=en_US.UTF-8
  LC_ADDRESS=en_US.UTF-8
  LC_TELEPHONE=en_US.UTF-8
  LC_MEASUREMENT=en_US.UTF-8
  LC_IDENTIFICATION=en_US.UTF-8
  LC_ALL=en_US.UTF-8" | sudo tee /etc/default/locale

  touch /home/vagrant/.system-updated
fi

# Git configuration ----------------------------------------------------------
if [ -e /home/vagrant/.hosthome/.gitconfig ]; then
  ln -fs /home/vagrant/.hosthome/.gitconfig /home/vagrant/.gitconfig
fi

if [ -e /home/vagrant/.hosthome/.gitignore ]; then
  ln -fs /home/vagrant/.hosthome/.gitignore /home/vagrant/.gitignore
fi

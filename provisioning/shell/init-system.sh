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
  sudo apt-get -y install libsqlite3-dev  # For pysqlite
  sudo apt-get -y install libjpeg-dev  # For PIL

  # Requirements for headless Selenium tests
  sudo apt-get install -y xvfb firefox xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

  touch /home/vagrant/.system-updated
fi

# Git configuration ----------------------------------------------------------
if [ -e /home/vagrant/.hosthome/.gitconfig ]; then
  ln -fs /home/vagrant/.hosthome/.gitconfig /home/vagrant/.gitconfig
fi

if [ -e /home/vagrant/.hosthome/.gitignore ]; then
  ln -fs /home/vagrant/.hosthome/.gitignore /home/vagrant/.gitignore
fi

# SSH configuration-----------------------------------------------------------
if [ -e /home/vagrant/.hosthome/.ssh/id_rsa.pub ]; then
  ln -fs /home/vagrant/.hosthome/.ssh/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
  ln -fs /home/vagrant/.hosthome/.ssh/id_rsa /home/vagrant/.ssh/id_rsa
fi
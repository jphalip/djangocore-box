#!/bin/bash

# Author: Julien Phalip
# Copyright (c) Django Software Foundation and individual contributors.
# All rights reserved.

if [ $# != 1 ]; then
  echo "Usage: $0 \<version\>"
  exit 2
fi

WANTED_VERSION=$1
CURRENT_VERSION=`chef-solo --version`
if [ "${CURRENT_VERSION}" != "Chef: ${WANTED_VERSION}" ]; then
  echo "Current version: ${CURRENT_VERSION}"
  echo "Uninstalling and then installing version: ${WANTED_VERSION}"
  yes | gem uninstall -a -q chef
  gem install --no-ri --no-rdoc chef -v=$WANTED_VERSION
else
  echo "Chef ${WANTED_VERSION} already installed. Moving on..."
fi
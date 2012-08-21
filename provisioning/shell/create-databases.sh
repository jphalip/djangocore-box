#!/bin/bash

# Author: Julien Phalip
# Copyright (c) Django Software Foundation and individual contributors.
# All rights reserved.

if [ -e $HOME/.databases-created ]; then
  echo 'Databases features already created'
  exit 0
fi

# Postgesql
echo 'CREATE DATABASE djangotests WITH OWNER postgres' | PGPASSWORD=secret psql -U postgres -h localhost
echo 'CREATE DATABASE djangotests_other WITH OWNER postgres' | PGPASSWORD=secret psql -U postgres -h localhost

# Mysql
echo 'CREATE DATABASE djangotests' | mysql --user=root --password=secret
echo 'CREATE DATABASE djangotests_other' | mysql --user=root --password=secret

# Create a flag file to prevent this script from being run in subsequent vagrant-up's.
touch $HOME/.databases-created
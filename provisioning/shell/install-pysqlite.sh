#!/bin/bash

# Copyright (c) 2013 Julien Phalip and contributors.
# Licensed under the BSD license.

if [ -e $HOME/.pysqlite-installed ]; then
  echo 'pysqlite features already installed'
  exit 0
fi

# Install pysqlite from source so that it can access all the GIS features.

wget http://pysqlite.googlecode.com/files/pysqlite-2.6.3.tar.gz &> /dev/null
tar xzf pysqlite-2.6.3.tar.gz
cd pysqlite-2.6.3
echo "[build_ext]" > setup.cfg
echo "#define=" >> setup.cfg
echo "include_dirs=/usr/local/include" >> setup.cfg
echo "library_dirs=/usr/local/lib" >> setup.cfg
echo "libraries=sqlite3" >> setup.cfg
echo "#define=SQLITE_OMIT_LOAD_EXTENSION" >> setup.cfg

# Install pysqlite for all specified versions of Python
for VERSION in $@; do
  $HOME/.virtualenvs/py${VERSION}/bin/python setup.py install
done

# Cleanup
cd ..
sudo rm -rf pysqlite-2.6.3
rm pysqlite-2.6.3.tar.gz


# Create a flag file to prevent this script from being run in subsequent vagrant-up's.
touch $HOME/.pysqlite-installed
#!/bin/bash

# Copyright (c) 2013 Julien Phalip and contributors.
# Licensed under the BSD license.

if [ -e $HOME/.databases-created ]; then
  echo 'Databases already created'
  exit 0
fi

# Update configuration for paths to shared libraries
echo "export LD_LIBRARY_PATH=/usr/local/lib" >> ~/.profile
export LD_LIBRARY_PATH=/usr/local/lib
sudo ldconfig

# Mysql ----------------------------------------------------------------------
echo 'CREATE DATABASE djangotests' | mysql --user=root --password=secret
echo 'CREATE DATABASE djangotests_other' | mysql --user=root --password=secret

# Postgesql ------------------------------------------------------------------

# Recreate the cluster so that it uses the UTF-8 encoding
sudo -u postgres pg_dropcluster --stop 9.1 main
sudo -u postgres pg_createcluster --start -e UTF-8 9.1 main

echo "CREATE USER django WITH SUPERUSER PASSWORD 'secret';" | sudo -u postgres psql
sudo -u postgres createdb -O django djangotests
sudo -u postgres createdb -O django djangotests_other


# PostGIS --------------------------------------------------------------------
sudo -u postgres createdb -U postgres -E UTF8 template_postgis
echo "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"  | sudo -u postgres psql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-2.0/postgis.sql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-2.0/spatial_ref_sys.sql
sudo -u postgres psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
sudo -u postgres psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
sudo -u postgres createdb -T template_postgis -O django djangotests_gis
sudo -u postgres createdb -T template_postgis -O django djangotests_gis_other

# Create a flag file to prevent this script from being run in subsequent vagrant-up's.
touch $HOME/.databases-created
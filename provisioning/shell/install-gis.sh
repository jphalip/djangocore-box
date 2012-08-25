#!/bin/bash

# Author: Julien Phalip
# Copyright (c) Django Software Foundation and individual contributors.
# All rights reserved.

# sudo apt-get install -y libxml2-dev binutils

if [ -e $HOME/.gis-installed ]; then
  echo 'GIS features already installed'
  exit 0
fi

# Install GEOS ---------------------------------------------------------------
wget http://download.osgeo.org/geos/geos-3.3.0.tar.bz2 &> /dev/null
tar xjf geos-3.3.0.tar.bz2
cd geos-3.3.0
./configure
make
sudo make install
cd ..
rm -rf geos-3.3.0
rm geos-3.3.0.tar.bz2

# Install PROJ.4 -------------------------------------------------------------
wget http://download.osgeo.org/proj/proj-4.7.0.tar.gz &> /dev/null
wget http://download.osgeo.org/proj/proj-datumgrid-1.5.zip &> /dev/null
tar xzf proj-4.7.0.tar.gz
cd proj-4.7.0/nad
unzip ../../proj-datumgrid-1.5.zip
cd ..
./configure
make
sudo make install
cd ..
rm -rf proj-4.7.0
rm proj-4.7.0.tar.gz
rm proj-datumgrid-1.5.zip

# Install PostGIS ------------------------------------------------------------
wget http://postgis.refractions.net/download/postgis-1.5.2.tar.gz &> /dev/null
tar xzf postgis-1.5.2.tar.gz
cd postgis-1.5.2
./configure --with-xml2config=/usr/bin/xml2-config
make
sudo make install
cd ..
rm -rf postgis-1.5.2
rm postgis-1.5.2.tar.gz

# Install GDAL ---------------------------------------------------------------
wget http://download.osgeo.org/gdal/gdal-1.9.1.tar.gz &> /dev/null
tar xzf gdal-1.9.1.tar.gz
cd gdal-1.9.1
./configure
make
sudo make install
cd ..
rm -rf gdal-1.9.1
rm gdal-1.9.1.tar.gz

# Install SQLite -------------------------------------------------------------
wget http://sqlite.org/sqlite-amalgamation-3.6.23.1.tar.gz &> /dev/null
tar xzf sqlite-amalgamation-3.6.23.1.tar.gz
cd sqlite-3.6.23.1
CFLAGS="-DSQLITE_ENABLE_RTREE=1" ./configure
make
sudo make install
cd ..
rm -rf sqlite-3.6.23.1/
rm sqlite-amalgamation-3.6.23.1.tar.gz

# Install Spacialite ---------------------------------------------------------
wget http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-amalgamation-2.3.1.tar.gz &> /dev/null
wget http://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-2.3.1.tar.gz &> /dev/null
tar xzf libspatialite-amalgamation-2.3.1.tar.gz
tar xzf spatialite-tools-2.3.1.tar.gz
cd libspatialite-amalgamation-2.3.1
./configure
make
sudo make install
cd ..
cd spatialite-tools-2.3.1
./configure
make
sudo make install
cd ..
rm -rf libspatialite-amalgamation-2.3.1
rm libspatialite-amalgamation-2.3.1.tar.gz
rm -rf spatialite-tools-2.3.1
rm spatialite-tools-2.3.1.tar.gz

# Download spatialite initialization file ------------------------------------
wget http://www.gaia-gis.it/spatialite-2.3.1/init_spatialite-2.3.sql.gz &> /dev/null
gunzip init_spatialite-2.3.sql.gz
rm init_spatialite-2.3.sql.gz


# Create a flag file to prevent this script from being run in subsequent vagrant-up's.
touch $HOME/.gis-installed

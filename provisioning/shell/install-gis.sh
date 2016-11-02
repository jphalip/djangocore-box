#!/bin/bash

# Copyright (c) 2013 Julien Phalip and contributors.
# Licensed under the BSD license.

if [ -e $HOME/.gis-installed ]; then
  echo 'GIS features already installed'
  exit 0
fi

# Install GEOS ---------------------------------------------------------------
wget http://download.osgeo.org/geos/geos-3.4.2.tar.bz2 &> /dev/null
tar xjf geos-3.4.2.tar.bz2
cd geos-3.4.2
./configure
make
sudo make install
cd ..
rm -rf geos-3.4.2*

# Install PROJ.4 -------------------------------------------------------------
wget http://download.osgeo.org/proj/proj-4.8.0.tar.gz &> /dev/null
wget http://download.osgeo.org/proj/proj-datumgrid-1.5.zip &> /dev/null
tar xzf proj-4.8.0.tar.gz
cd proj-4.8.0/nad
unzip ../../proj-datumgrid-1.5.zip
cd ..
./configure
make
sudo make install
cd ..
rm -rf proj-4.8.0*
rm proj-datumgrid-1.5.zip

# Install GDAL ---------------------------------------------------------------
wget http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz &> /dev/null
tar xzf gdal-1.9.2.tar.gz
cd gdal-1.9.2
./configure
make
sudo make install
cd ..
rm -rf gdal-1.9.2*

# Install PostGIS ------------------------------------------------------------
wget http://download.osgeo.org/postgis/source/postgis-2.1.5.tar.gz &> /dev/null
tar xzf postgis-2.1.5.tar.gz
cd postgis-2.1.5
./configure --with-xml2config=/usr/bin/xml2-config
make
sudo make install
cd ..
rm -rf postgis-2.1.5*

# Install SQLite -------------------------------------------------------------
wget http://www.sqlite.org/2015/sqlite-autoconf-3080801.tar.gz &> /dev/null
tar xzf sqlite-autoconf-3080801.tar.gz
cd sqlite-autoconf-3080801
CFLAGS="-DSQLITE_ENABLE_RTREE=1" ./configure
make
sudo make install
cd ..
rm -rf sqlite-autoconf-3080801*

# Install Spacialite ---------------------------------------------------------

wget http://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.0.tar.gz &> /dev/null
tar xzf freexl-1.0.0.tar.gz
cd freexl-1.0.0
./configure
make
sudo make install
cd ..

wget http://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.2.0.tar.gz &> /dev/null
tar xzf libspatialite-4.2.0.tar.gz
cd libspatialite-4.2.0
./configure
make
sudo make install
cd ..

wget http://sourceforge.net/projects/expat/files/expat/2.1.0/expat-2.1.0.tar.gz &> /dev/null
tar xzf expat-2.1.0.tar.gz
cd expat-2.1.0
./configure
make
sudo make install
cd ..

wget http://www.gaia-gis.it/gaia-sins/readosm-sources/readosm-1.0.0.tar.gz &> /dev/null
tar xzf readosm-1.0.0.tar.gz
cd readosm-1.0.0
./configure
make
sudo make install
cd ..

wget http://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-4.2.0.tar.gz &> /dev/null
tar xzf spatialite-tools-4.2.0.tar.gz
cd spatialite-tools-4.2.0
./configure
make
sudo make install
cd ..

rm -rf libspatialite-4.2.0*
rm -rf spatialite-tools-4.2.0*
rm -rf expat-2.1.0*
rm -rf freexl-1.0.0*
rm -rf readosm-1.0.0*


# Create a flag file to prevent this script from being run in subsequent vagrant-up's.
touch $HOME/.gis-installed

#!/bin/bash

# Smoke tests for the djangocore-box.
# To run this script inside the VM:
# $ source /djangocore-box/box-tests.sh

set -x  # To output the commands as they are run.

runtests2.6-spatialite gis
runtests2.6-postgis gis
runtests2.6-sqlite auth
runtests2.7-sqlite auth
runtests2.6-postgresql auth
runtests2.6-mysql auth
runtests3.3-sqlite auth
runtests3.3-postgresql auth
runtests2.6-sqlite admin_inlines.SeleniumFirefoxTests --selenium
runtests2.6-sqlite
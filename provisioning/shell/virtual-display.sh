#!/bin/bash

# Copyright (c) 2013 Julien Phalip and contributors.
# Licensed under the BSD license.

# Virtual display for the Selenium tests -------------------------------------

if ! grep -q "DISPLAY=:99" $HOME/.profile
then
    echo "export DISPLAY=:99" >> $HOME/.profile
fi

Xvfb -ac :99 2>/dev/null &
#!/bin/bash

# windows:
# cd content && mklink /d programming ..\..\..\..\programming

# linux:
ln -s ../../../programming ./content/programming

# get github.io repo
git clone https://github.com/brt2cv/brt2cv.github.io.git public

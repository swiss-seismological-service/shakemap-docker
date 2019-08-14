#!/usr/bin/env bash

# This dependency install script is based off of the official ShakeMap install
# script and will need to be updated if the dependencies installed there
# change.

# Package list:
package_list=(
      "amptools"
      "cartopy"
      "cython"
      "defusedxml"
      "descartes"
      "docutils"
      "configobj"
      "fiona"
      "gcc_linux-64"
      "gdal"
      "h5py"
      "impactutils=0.8.15"
      "libcomcat=1.2.13"
      "lockfile"
      "mapio=0.7.21"
      "matplotlib<=2.3"
      "numpy"
      "obspy"
      "pandas"
      "ps2ff"
      "psutil"
      "pyproj"
      "pytest"
      "pytest-cov"
      "python-daemon"
      "pytest-faulthandler"
      "scikit-image"
      "scipy"
      "shapely"
      "simplekml"
      "strec=2.1.4"
      "versioneer"
      "vcrpy"
)

conda install -c conda-forge \
      --channel-priority ${package_list[*]}

#!/usr/bin/env bash

echo "Using python version $py_ver"
echo "Installing shakemap dependencies using conda..."

# Package list:
package_list=(
      "python=$py_ver"
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
      "openquake.engine"
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

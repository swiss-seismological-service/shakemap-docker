# shakemap

This repository contains the image definitions for the ShakeMap docker
images at https://hub.docker.com/r/seddev/shakemap.

The repository is divided into two subdirectories:
    
  * **commit** - files for building an image using a specific commit of
  shakemap and oq-engine. 
  * **tag** - files for building an image using a specific tagged release of
  shakemap and oq-engine.
  
These images are built using some additional resources (data, patched source code,
etc.). Large files are stored using Git LFS.


## Data Files
To build this image, you need the data files which go in the vs30/, 
topo/, and mapping/ directories. These files are stored in the
repository using Git LFS 
(https://github.com/git-lfs/git-lfs/wiki/Tutorial).


## General Information

These images install ShakeMap to the **base** conda environment instead
of using virtual environments like in the standard ShakeMap install
script since a venv is not necessary in this container.

 This container is configured to run with the default configurations for
 ShakeMap:
  * VS30 Grid: "global_vs30.grd" from USGS
  * Topographic Grid: "topo_30sec.grd" 30 arcsecond DEM from the USGS
 
This image runs as user "shakemap" with a corresponding ShakeMap profile residing at:
  *  /home/shakemap/shakemap_profiles/shakemap/
 
## Links

Docker Hub: 

https://hub.docker.com/r/seddev/shakemap 

See the Official USGS ShakeMap page for more details on ShakeMap:

https://github.com/usgs/shakemap/


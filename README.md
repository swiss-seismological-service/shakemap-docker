# shakemap

This image provides a full install of the USGS's ShakeMap v4.x application using Miniconda.  Note that this image is not
officially supported and may lag behind the latest ShakeMap releases.

## Latest Version

The latest version of this image, v1.0.0, uses ShakeMap v4.0.1

## Getting Started

To run, you must mount your event data directory to /home/shakemap/shakemap_profiles/shakemap/data in the container.

You can then execute ShakeMap commands with:

    $ docker run seddev/shakemap:latest 
        -v /home/{user}/data:/home/shakemap/shakemap_profiles/shakemap/data shake {event_id} {command1} {command 2} {...}

## General Information

 This container is configured to run with the default configurations for ShakeMap:
  * VS30 Grid: "global_vs30.grd" from USGS
  * Topographic Grid: "topo_30sec.grd" 30 arcsecond DEM from the USGS
 
This image runs as user "shakemap" with a corresponding ShakeMap profile residing at:
  *  /home/shakemap/shakemap_profiles/shakemap/
 
For the "mapping" command, this image includes all required shapefiles under INSTALL_DIR/data/mapping 

## Customization
To configure ShakeMap to your own project, create a new Docker image using this image in the FROM clause and add your
own config files to the ShakeMap install directory under:

/home/shakemap/shakemap_profiles/shakemap/data

and

/home/shakemap/shakemap_profiles/shakemap/install

e.g.

    FROM seddev/shakemap
    COPY myvs30 /home/shakemap/shakemap_profiles/shakemap/install/data/vs30
    COPY mydem /home/shakemap/shakemap_profiles/shakemap/data
    COPY myconfigfiles /home/shakemap/shakemap_profiles/shakemap/install/config
    

## Links

See the Official USGS ShakeMap page for more details on ShakeMap: 

https://github.com/usgs/shakemap/
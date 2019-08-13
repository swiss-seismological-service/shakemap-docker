FROM continuumio/miniconda3

# Note: miniconda3 is based on Debian

# ------------------------ CONFIG PARAMETERS ---------------------------
ARG user=shakemap
ARG group=shakemap
ARG shakemapcommit=74609dbdb29fd3d74eda11e13051da0f7e1664d7
ARG openquakecommit=80d8a15f58f0f887f556bfb42085b1e55d8c2e36
# ----------------------------------------------------------------------

# Download/Install required packages
RUN apt-get update && apt-get install -y bash wget git gcc g++ sudo curl bzip2

# Create the user/group to run ShakeMap
RUN groupadd ${group}
RUN useradd -m -s /bin/bash -g ${group} ${user} && usermod -aG ${group} ${user}
RUN echo "${user} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Switch to our new user and move to their home directory
WORKDIR /home/${user}
RUN mkdir /home/${user}/data

# Download OQ release for install
RUN git clone https://github.com/gem/oq-engine
WORKDIR /home/${user}/oq-engine
RUN git checkout ${openquakecommit}
RUN pip install -r requirements-py37-linux64.txt -r requirements-extra-py37-linux64.txt
RUN pip install -e .
WORKDIR /home/${user}

# Download ShakeMap Release
RUN git clone https://github.com/usgs/shakemap && mv shakemap shakemap_src

# Checkout the desired commit
WORKDIR /home/${user}/shakemap_src
RUN git checkout ${shakemapcommit}
WORKDIR /home/${user}

# Run scipt to generate shakemaps venv (modified from official install.sh)
COPY install_shakemap_dependencies.sh /home/${user}/shakemap_src
RUN sudo chmod a+x /home/${user}/shakemap_src/install_shakemap_dependencies.sh
RUN /home/${user}/shakemap_src/install_shakemap_dependencies.sh

# Install ShakeMap
WORKDIR /home/${user}/shakemap_src

# Copy an updated setup.py since the provided one doesn't install package data properly...
# TODO - Try this with the built in setup.py
# COPY setup.py /home/${user}/shakemap_src
RUN /opt/conda/bin/pip install --no-deps --editable .

# TODO - REMOVE SINCE WE ARE IN EDITABLE MODE
# Cleanup src dir to avoid path conflicts
# WORKDIR /home/${user}
# RUN rm -r /home/${user}/shakemap_src

USER ${user}

# Configure matplotlib to use non-interactive backend to avoid warnings
RUN mkdir /home/${user}/.config; exit 0
RUN mkdir /home/${user}/.config/matplotlib
RUN echo "backend : Agg" > /home/${user}/.config/matplotlib/matplotlibrc


# Initialize profile
# This will create data dirs at:
#   /home/shakemap/shakemap_profiles/shakemap/data
#   /home/shakemap/shakemap_profiles/shakemap/install

RUN sm_profile -c shakemap --accept --nogrids

# Copy configuration and grid files into container
COPY config/model.conf /home/${user}/shakemap_profiles/shakemap/install/config
COPY config/products.conf /home/${user}/shakemap_profiles/shakemap/install/config

COPY vs30 /home/${user}/shakemap_profiles/shakemap/install/data/vs30
COPY topo /home/${user}/shakemap_profiles/shakemap/install/data/topo

WORKDIR /home/${user}/shakemap_profiles/shakemap

# Ensure that miniconda is in the $PATH for docker exec
ENV PATH=/opt/conda/bin:$PATH

# Patch ShakeMap GMPE/VirtualIPE bug, still exists as of 13/8/2019
#  Note: some versions of ShakeMap have an incompatibility with newer (>3.5)
#  versions of OpenQuake. OQ expects subclasses to define an iterable
#  DEFINED_FOR_STD_TYPES field in the class definition, but ShakeMap initializes
#  this field as None then sets it during a factory method.
COPY patch/multigmpe.py /home/${user}/shakemap_src/shakelib
COPY patch/virtualipe.py /home/${user}/shakemap_src/shakelib

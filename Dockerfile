FROM continuumio/miniconda3

# ------------------------ CONFIG PARAMETERS ---------------------------
ARG user=shakemap
ARG group=shakemap
ARG shakemaptag=4.0.1
# ----------------------------------------------------------------------

# Download/Install required packages
# apk update &&
RUN apt-get update && apt-get install -y bash wget git gcc g++ sudo curl bzip2

# Create the user/group to run ShakeMap
RUN groupadd ${group}
RUN useradd -m -s /bin/bash -g ${group} ${user} && usermod -aG ${group} ${user}
RUN echo "${user} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Switch to our new user and move to their home directory
WORKDIR /home/${user}
RUN mkdir /home/${user}/data

# Download ShakeMap Release
RUN wget -q https://github.com/usgs/shakemap/archive/${shakemaptag}.tar.gz -O - | tar -xz \
    && mv shakemap-${shakemaptag} shakemap_src

# Run scipt to generate shakemaps venv (modified from official install.sh)
COPY install_shakemap_dependencies.sh /home/${user}/shakemap_src
RUN sudo chmod a+x /home/${user}/shakemap_src/install_shakemap_dependencies.sh
RUN /home/${user}/shakemap_src/install_shakemap_dependencies.sh

# Install ShakeMap
WORKDIR /home/${user}/shakemap_src

# Copy an updated setup.py since the provided one doesn't install package data properly...
COPY setup.py /home/${user}/shakemap_src
RUN /opt/conda/bin/pip install --no-deps  .

RUN echo | find /opt/conda/lib/python3.7/site-packages/shakemap/

# Cleanup src dir to avoid path conflicts
WORKDIR /home/${user}
RUN rm -r /home/${user}/shakemap_src

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
COPY mapping /home/${user}/shakemap_profiles/shakemap/install/data/mapping
WORKDIR /home/${user}/shakemap_profiles/shakemap

# Ensure that miniconda is in the $PATH for docker exec
ENV PATH=/opt/conda/bin:$PATH

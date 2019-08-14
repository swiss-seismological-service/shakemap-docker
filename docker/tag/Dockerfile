FROM continuumio/miniconda3

# Note: miniconda3 is based on Debian

# ------------------------ CONFIG PARAMETERS ---------------------------
ARG user=shakemap
ARG group=shakemap
ARG shakemaptag=4.0.1
ARG openquaketag=3.6.0
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
RUN wget -q https://github.com/gem/oq-engine/archive/v${openquaketag}.tar.gz -O - | tar -xz \
    && mv oq-engine-${openquaketag} /home/${user}/oq-engine_src
WORKDIR /home/${user}/oq-engine_src
RUN pip install -r requirements-py37-linux64.txt -r requirements-extra-py37-linux64.txt
RUN pip install .
WORKDIR /home/${user}

# Download ShakeMap Release
RUN git clone https://github.com/usgs/shakemap && mv shakemap shakemap_src

# Checkout the desired commit
WORKDIR /home/${user}/shakemap_src
RUN git checkout tags/${shakemaptag}
WORKDIR /home/${user}

# Run scipt to install shakemap's dependencies
COPY install_shakemap_dependencies.sh /home/${user}/shakemap_src
RUN sudo chmod a+x /home/${user}/shakemap_src/install_shakemap_dependencies.sh
RUN /home/${user}/shakemap_src/install_shakemap_dependencies.sh

# Install ShakeMap (editable mode)
WORKDIR /home/${user}/shakemap_src
RUN /opt/conda/bin/pip install --no-deps --editable .

# Return to home directory and switch to default user
WORKDIR /home/${user}
USER ${user}

# Configure matplotlib to use non-interactive backend to avoid warnings
RUN mkdir /home/${user}/.config
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

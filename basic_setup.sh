#!/bin/bash

# @title (2) Install Packages and Data (~ 5min)
%%time

# Install Python packages by conda and pip
conda env update --name base --file colab_setup/basic_colab_env.yaml --prune

# Download Phenix Project geostd (restraint) Library
goestd_repo="https://github.com/phenix-project/geostd.git"
git clone ${goestd_repo}

# Download AutoDock Vina Executable from Git Repository

# Get the latest release version
latest_release=$(curl -s https://api.github.com/repos/ccsb-scripps/AutoDock-Vina/releases/latest | grep "tag_name" | cut -d '"' -f 4)
# Construct the download URL
wget https://github.com/ccsb-scripps/AutoDock-Vina/releases/download/$latest_release/vina_${latest_release#v}_linux_x86_64
# Rename and make it executable
mv vina_*_linux_x86_64 vina
chmod +x vina
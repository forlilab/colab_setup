#!/bin/bash

# Function to display messages
log() {
  echo -e "\n\033[1;32m[INFO]\033[0m $1\n"
}

error() {
  echo -e "\n\033[1;31m[ERROR]\033[0m $1\n" >&2
}

log "Step 1: Installing Python packages using Conda and Pip..."
yaml_file="colab_setup/basic_colab_env.yaml"
if conda env update --name base --file ${yaml_file} --prune; then
  log "Python packages installed successfully."
else
  error "Failed to install Python packages. Ensure Conda is installed and the YAML file exists."
  exit 1
fi

log "Step 2: Cloning data repositories..."
# Phenix Project geostd (restraint) library
goestd_repo="https://github.com/phenix-project/geostd.git"
if git clone ${goestd_repo}; then
  log "Phenix Project geostd repository cloned successfully."
else
  error "Failed to clone Phenix Project geostd repository. Check your network connection."
  exit 1
fi

log "Step 3: Downloading executables..."
# AutoDock Vina executable
pinned_release="1.2.5"
download_url="https://github.com/ccsb-scripps/AutoDock-Vina/releases/download/v$pinned_release/vina_${pinned_release}_linux_x86_64"
if wget -q --show-progress ${download_url}; then
  # Rename and make the executable ready
  mv vina_*_linux_x86_64 vina && chmod +x vina
  log "AutoDock Vina executable downloaded successfully."
else
  error "Failed to download AutoDock Vina executable. Verify the release version or URL."
  exit 1
fi

log "Colab environment setup completed successfully!"

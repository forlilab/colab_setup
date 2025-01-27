#!/bin/bash

# Function to display messages
log() {
  echo -e "\n\033[1;32m[INFO]\033[0m $1\n"
}

error() {
  echo -e "\n\033[1;31m[ERROR]\033[0m $1\n" >&2
}

# Step 1: Install Python packages with conda and pip
log "Step 1: Installing Python packages using Conda and Pip..."
if conda env update --name base --file colab_setup/basic_colab_env.yaml --prune; then
  log "Python packages installed successfully."
else
  error "Failed to install Python packages. Ensure Conda is installed and the YAML file exists."
  exit 1
fi

# Step 2: Clone the Phenix Project geostd (restraint) Library
log "Step 2: Cloning Phenix Project geostd (restraint) Library..."
goestd_repo="https://github.com/phenix-project/geostd.git"
if git clone ${goestd_repo}; then
  log "Phenix Project geostd repository cloned successfully."
else
  error "Failed to clone Phenix Project geostd repository. Check your network connection."
  exit 1
fi

# Step 3: Download AutoDock Vina Executable
log "Step 3: Downloading AutoDock Vina executable..."

# Get the latest release version
pinned_release="1.2.5"
download_url="https://github.com/ccsb-scripps/AutoDock-Vina/releases/download/$pinned_release/vina_${pinned_release}_linux_x86_64"

# Download the executable
if wget -q --show-progress ${download_url}; then
  log "AutoDock Vina executable downloaded successfully."
else
  error "Failed to download AutoDock Vina executable. Verify the release version or URL."
  exit 1
fi

# Rename and make the executable ready
log "Renaming and setting permissions for the executable..."
if mv vina_*_linux_x86_64 vina && chmod +x vina; then
  log "Executable renamed to 'vina' and made executable successfully."
else
  error "Failed to rename or set permissions for the Vina executable."
  exit 1
fi

# Final message
log "Colab environment setup completed successfully!"

#!/bin/bash

# Template function for downloading and setting up files
download_and_setup() {
  local name=$1            # Descriptive name of the tool (e.g., "AutoDock Vina")
  local url=$2             # Download URL
  local file_pattern=$3    # File pattern to rename (e.g., "vina_*_linux_x86_64")
  local executable_name=$4 # Final name for the executable (e.g., "vina")

  log "Downloading $name..."
  if wget -q --show-progress "$url"; then
    mv $file_pattern $executable_name && chmod +x $executable_name
    log "$name executable downloaded and set up successfully."
  else
    error "Failed to download $name. Verify the release version or URL."
    return 1
  fi
}

download_autodock_vina() {
  local pinned_release=$1
  local download_url="https://github.com/ccsb-scripps/AutoDock-Vina/releases/download/v$pinned_release/vina_${pinned_release}_linux_x86_64"
  download_and_setup "AutoDock Vina" "$download_url" "vina_*_linux_x86_64" "vina"
}

download_autodock_gpu() {
  local pinned_release=$1
  local download_url="https://github.com/ccsb-scripps/AutoDock-GPU/releases/download/v$pinned_release/adgpu-v${pinned_release}_linux_x64_cuda12_128wi"
  download_and_setup "AutoDock-GPU" "$download_url" "adgpu-v*_linux_x64_cuda12_128wi" "adgpu"
}

export -f download_and_setup
export -f download_autodock_vina
export -f download_autodock_gpu

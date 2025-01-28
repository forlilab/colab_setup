#!/bin/bash

# Template function to clone a repository
get_repo() {
  local repo_url=$1          # Repository URL
  local target_dir=$2        # Target directory

  log "Cloning repository: $repo_url"
  git clone "$repo_url" "$target_dir" || {
    error "Failed to clone repository: $repo_url"
    return 1
  }

  log "Successfully cloned $repo_url to $target_dir"
}

# Template function to clone a repository, sparse-checkout, and copy files
get_tool_from_repo() {
  local repo_url=$1          # Repository URL
  local sparse_dir=$2        # Directory to sparse-checkout
  local file_path=$3         # File to copy (relative to the sparse directory)
  local target_name=$4       # Target name for the copied file

  log "Cloning repository: $repo_url"
  git clone -n --depth=1 --filter=tree:0 "$repo_url" repo_temp || {
    error "Failed to clone repository: $repo_url"
    return 1
  }
  
  cd repo_temp || {
    error "Failed to navigate to cloned repository directory."
    return 1
  }

  log "Performing sparse-checkout for: $sparse_dir"
  git sparse-checkout init --no-cone
  git sparse-checkout set "$sparse_dir" || {
    error "Failed to perform sparse-checkout for: $sparse_dir"
    cd .. && rm -rf repo_temp
    return 1
  }

  git checkout || {
    error "Failed to checkout files."
    cd .. && rm -rf repo_temp
    return 1
  }

  log "Copying file: $file_path to $target_name"
  cp "$sparse_dir/$file_path" "../$target_name" && chmod +x "../$target_name" || {
    error "Failed to copy or set executable permissions for: $file_path"
    cd .. && rm -rf repo_temp
    return 1
  }

  cd .. && rm -rf repo_temp
  log "Successfully set up $target_name from $repo_url"
}

# Exporting functions for reuse
export -f get_tool_from_repo
export -f get_repo

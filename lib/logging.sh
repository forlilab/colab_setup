#!/bin/bash

log() {
  echo -e "\n\033[1;32m[INFO]\033[0m $1\n"
}

error() {
  echo -e "\n\033[1;31m[ERROR]\033[0m $1\n" >&2
}

export -f log
export -f error

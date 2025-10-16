#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-10-16 22:23:20 (ywatanabe)"
# File: ./scripts/mnist/main.sh

ORIG_DIR="$(pwd)"
THIS_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
LOG_PATH="$THIS_DIR/.$(basename $0).log"
echo > "$LOG_PATH"

BLACK='\033[0;30m'
LIGHT_GRAY='\033[0;37m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo_info() { echo -e "${LIGHT_GRAY}$1${NC}"; }
echo_success() { echo -e "${GREEN}$1${NC}"; }
echo_warning() { echo -e "${YELLOW}$1${NC}"; }
echo_error() { echo -e "${RED}$1${NC}"; }
# ---------------------------------------

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_PATH="$0.log"
touch "$LOG_PATH"

cleanup() {
    rm -rf ./data/*
    rm -rf ./scripts/mnist/*_out
}

main() {
    ./scripts/mnist/download.py
    ./scripts/mnist/plot_digits.py
    ./scripts/mnist/plot_umap_space.py
    ./scripts/mnist/clf_svm.py
    ./scripts/mnist/clf_svm_plot_conf_mat.py
}

cleanup
main "$@" 2>&1 | tee "$LOG_PATH"

# EOF
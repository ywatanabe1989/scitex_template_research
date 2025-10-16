#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-09-26 10:53:55 (ywatanabe)"
# File: ./paper/scripts/shell/modules/pptx2tif_single.sh

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

# Configurations
source ./config/load_config.sh $STXW_DOC_TYPE

# Logging
touch "$LOG_PATH" >/dev/null 2>&1
echo
echo "Running $0..."

usage() {
    echo "Usage: $0 [-i|--input INPUT_FILE] [-o|--output OUTPUT_FILE] [-h|--help]"
    echo
    echo "Options:"
    echo " -i, --input    Input PPTX file path (required)"
    echo " -o, --output   Output TIF file path (optional)"
    echo " -h, --help     Display this help message"
    echo
    echo "Example:"
    echo " $0 -i /path/to/input.pptx"
    echo " $0 -i /path/to/input.pptx -o /path/to/output.tif"
    exit 1
}

convert_pptx_to_tif() {
    local input_file="$1"
    local output_file="$2"

    local input_file_win=$(wslpath -w "$input_file")
    local output_file_win=$(wslpath -w "$output_file")
    local script_dir="$(dirname "$(realpath "$0")")"
    local ps_script="./scripts/powershell/pptx2tiff.ps1"
    local powershell=/home/ywatanabe/.win-bin/powershell.exe

    echo -e "\nConverting ${input_file}...\n"

    if [ ! -f "$powershell" ]; then
        echo "Error: PowerShell executable not found at $powershell"
        exit 1
    fi

    if [ ! -f "$ps_script" ]; then
        echo "Error: PowerShell script not found at $ps_script"
        exit 1
    fi

    if [ ! -f "$input_file" ]; then
        echo "Error: Input file does not exist."
        exit 1
    fi

    "$powershell" -ExecutionPolicy Bypass -File "$ps_script" -inputFilePath "$input_file_win" -outputFilePath "$output_file_win" 2>&1

    # "$powershell" -ExecutionPolicy Bypass -File "$(wslpath -w ./scripts/powershell/pptx2tiff.ps1)" -inputFilePath "$input_file_win" -outputFilePath "$output_file_win" 2>&1
    ps_exit_code=$?

    if [ $ps_exit_code -ne 0 ]; then
        echo -e "\nError: PowerShell script failed with exit code $ps_exit_code"
        return 1
    fi

    if [ -f "$output_file" ]; then
        echo -e "\nConverted: ${input_file} -> ${output_file}"
    else
        echo -e "\nError: Conversion failed. Output file not created."
        return 1
    fi
}

main() {
    local input_file
    local output_file

    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--input)
                input_file="$2"
                shift 2
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -h|--help)
                usage
                ;;
            *)
                echo "Unknown option: $1"
                usage
                ;;
        esac
    done

    if [ -z "$input_file" ]; then
        echo "Error: Input file is required."
        usage
    fi

    if [ -z "$output_file" ]; then
        output_file="${input_file%.pptx}.tif"
    fi

    convert_pptx_to_tif "$input_file" "$output_file"
}

{ main "$@" ; } 2>&1 | tee "$LOG_PATH"

# Usage:
# ./scripts/shell/modules/pptx2tif.sh -i /home/ywatanabe/proj/ripple-wm/paper/manuscript/contents/figures/contents/.10_vswr_jump.pptx

# EOF
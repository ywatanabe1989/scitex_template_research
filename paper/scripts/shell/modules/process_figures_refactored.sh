#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "$(date +"%Y-%m-%d %H:%M:%S") ($(whoami))"
# File: process_figures_refactored.sh
# Refactored modular version of process_figures.sh

# Get script directory
ORIG_DIR="$(pwd)"
THIS_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
MODULES_DIR="$THIS_DIR/process_figures_modules"

# Source configuration
source ./config/load_config.sh manuscript >/dev/null 2>&1

# Source all modules
source "$MODULES_DIR/00_common.src"
source "$MODULES_DIR/01_caption_management.src"
source "$MODULES_DIR/02_format_conversion.src"
source "$MODULES_DIR/03_panel_tiling.src"
source "$MODULES_DIR/04_compilation.src"

# Additional utility functions not yet modularized
ensure_lower_letter_id() {
    # Convert uppercase panel IDs to lowercase (01A_ -> 01a_)
    for file in "$STXW_FIGURE_CAPTION_MEDIA_DIR"/[0-9]*[A-Z]_*; do
        [ -e "$file" ] || continue
        local dir=$(dirname "$file")
        local basename=$(basename "$file")
        local new_basename=$(echo "$basename" | sed 's/\([0-9]*\)\([A-Z]\)_/\1\L\2_/')
        
        if [ "$basename" != "$new_basename" ]; then
            echo_info "Renaming: $basename -> $new_basename"
            mv "$file" "$dir/$new_basename"
        fi
    done
}

crop_image() {
    local input_file="$1"
    local output_file="${2:-$input_file}"
    
    if command -v mogrify >/dev/null 2>&1; then
        mogrify -trim +repage "$input_file"
    elif command -v convert >/dev/null 2>&1; then
        convert "$input_file" -trim +repage "$output_file"
    fi
}

crop_all_images() {
    echo_info "Cropping all images..."
    for jpg_file in "$STXW_FIGURE_JPG_DIR"/*.jpg; do
        [ -e "$jpg_file" ] || continue
        crop_image "$jpg_file"
    done
}

# Main function
main() {
    local no_figs="${1:-false}"
    local p2t="${2:-false}"  # Convert PPTX to TIF
    local verbose="${3:-false}"
    local do_crop="${4:-false}"  # Crop images
    
    if [ "$verbose" = true ]; then
        echo_info "Figure processing: Starting with parameters: "
        echo_info "no_figs=$no_figs, p2t=$p2t, crop=$do_crop"
    fi
    
    # Initialize environment
    init_figures
    ensure_lower_letter_id
    
    # Clean up panel captions that shouldn't exist
    cleanup_panel_captions
    
    # Ensure captions for main figures only
    ensure_caption
    
    if [ "$no_figs" = false ]; then
        # Run the figure conversion cascade
        convert_figure_formats_in_cascade "$p2t" "$do_crop"
        
        # Post-processing
        check_and_create_placeholders
        auto_tile_panels "$no_figs"
    fi
    
    # Final compilation steps
    compile_legends
    handle_figure_visibility "$no_figs"
    compile_figure_tex_files
    
    # Report results
    local compiled_count=$(find "$STXW_FIGURE_COMPILED_DIR" -name "[0-9]*.tex" 2>/dev/null | wc -l)
    if [ "$no_figs" = false ] && [ $compiled_count -gt 0 ]; then
        echo_success "$compiled_count figures compiled"
    fi
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi

# EOF
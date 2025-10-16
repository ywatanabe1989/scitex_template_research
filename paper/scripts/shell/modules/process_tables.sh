#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-09-28 19:49:15 (ywatanabe)"
# File: ./paper/scripts/shell/modules/process_tables.sh

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
echo_info "Running $0 ..."

function init_tables() {
    # Cleanup and prepare directories
    rm -f "$STXW_TABLE_COMPILED_DIR"/*.tex
    mkdir -p "$STXW_TABLE_DIR" >/dev/null
    mkdir -p "$STXW_TABLE_CAPTION_MEDIA_DIR" >/dev/null
    mkdir -p "$STXW_TABLE_COMPILED_DIR" >/dev/null
    echo > "$STXW_TABLE_COMPILED_FILE"
}

function xlsx2csv_convert() {
    # Convert Excel files to CSV if xlsx2csv is available
    if command -v xlsx2csv >/dev/null 2>&1; then
        for xlsx_file in "$STXW_TABLE_CAPTION_MEDIA_DIR"/[0-9]*.{xlsx,xls}; do
            [ -e "$xlsx_file" ] || continue

            base_name=$(basename "$xlsx_file" | sed 's/\.\(xlsx\|xls\)$//')
            csv_file="${STXW_TABLE_CAPTION_MEDIA_DIR}/${base_name}.csv"

            # Convert only if CSV doesn't exist or is older than Excel file
            if [ ! -f "$csv_file" ] || [ "$xlsx_file" -nt "$csv_file" ]; then
                echo_info "    Converting $xlsx_file to CSV..."
                xlsx2csv "$xlsx_file" "$csv_file"
                if [ $? -eq 0 ]; then
                    echo_success "    Created $csv_file from Excel"
                else
                    echo_warning "    Failed to convert $xlsx_file"
                fi
            fi
        done
    fi
}

function ensure_caption() {
    # Create default captions for any table without one
    for csv_file in "$STXW_TABLE_CAPTION_MEDIA_DIR"/[0-9]*.csv; do
        [ -e "$csv_file" ] || continue
        local base_name=$(basename "$csv_file" .csv)
        # Extract table number from filename like 01_seizure_count
        local table_number=""
        if [[ "$base_name" =~ ^([0-9]+)_ ]]; then
            table_number="${BASH_REMATCH[1]}"
        else
            table_number="$base_name"
        fi
        local caption_file="${STXW_TABLE_CAPTION_MEDIA_DIR}/${base_name}.tex"

        if [ ! -f "$caption_file" ] && [ ! -L "$caption_file" ]; then
            echo_info "    Creating default caption for table $base_name"
            mkdir -p $(dirname "$caption_file")
            cat > "$caption_file" << EOF
\\caption{\\textbf{
TABLE TITLE HERE
}
\\smallskip
\\
\\text{
TABLE CAPTION HERE.
}}
EOF
        fi
    done
}

# Function removed - no longer needed for new naming convention

function check_csv_for_special_chars() {
    # Check CSV file for potential problematic characters
    local csv_file="$1"
    local problem_chars="[&%$#_{}^~\\|<>]"
    local problems=$(grep -n "$problem_chars" "$csv_file" 2>/dev/null || echo "")
    if [ -n "$problems" ]; then
        echo_warn "    Potential LaTeX special characters found in $csv_file:"
        echo -e ${YELLOW}
        echo "$problems" | head -5
        echo "These may need proper LaTeX escaping."
        echo -e ${NC}
    fi
}

function csv2tex() {
    # Determine best method for CSV processing
    local use_method="fallback"

    # Check for csv2latex command (best option)
    if command -v csv2latex >/dev/null 2>&1; then
        use_method="csv2latex"
        echo_info "    Using csv2latex for table processing"
    # Check if Python and pandas are available (second best)
    elif command -v python3 >/dev/null 2>&1 && python3 -c "import pandas" 2>/dev/null; then
        use_method="python"
        echo_info "    Using Python with pandas for table processing"
    # Check if Python is available without pandas
    elif command -v python3 >/dev/null 2>&1; then
        use_method="python_basic"
        echo_info "    Using Python (basic) for table processing"
    else
        echo_warning "    Using fallback AWK processing for tables"
    fi

    # Process each CSV file
    for csv_file in "$STXW_TABLE_CAPTION_MEDIA_DIR"/[0-9]*.csv; do
        [ -e "$csv_file" ] || continue

        base_name=$(basename "$csv_file" .csv)
        caption_file="${STXW_TABLE_CAPTION_MEDIA_DIR}/${base_name}.tex"
        compiled_file="$STXW_TABLE_COMPILED_DIR/${base_name}.tex"

        case "$use_method" in
            csv2latex)
                # Use csv2latex command (most robust)
                csv2latex --separator comma --position htbp --caption-file "$caption_file" \
                          --label "tab:${base_name}" "$csv_file" > "$compiled_file" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo_success "    $compiled_file compiled (using csv2latex)"
                else
                    echo_warning "    csv2latex failed, trying fallback"
                    csv2tex_single_fallback "$csv_file" "$compiled_file" "$caption_file"
                fi
                ;;

            python|python_basic)
                # Use our Python script
                local caption_arg=""
                if [ -f "$caption_file" ] || [ -L "$caption_file" ]; then
                    temp_caption_file="/tmp/caption_${base_name}.txt"
                    cat "$caption_file" > "$temp_caption_file"
                    caption_arg="--caption-file $temp_caption_file"
                fi

                if [ -f "./scripts/python/csv_to_latex.py" ]; then
                    python3 ./scripts/python/csv_to_latex.py "$csv_file" "$compiled_file" $caption_arg
                    if [ $? -eq 0 ]; then
                        echo_success "    $compiled_file compiled (using Python)"
                    else
                        echo_warning "    Python processing failed, trying fallback"
                        csv2tex_single_fallback "$csv_file" "$compiled_file" "$caption_file"
                    fi
                    [ -f "$temp_caption_file" ] && rm -f "$temp_caption_file"
                else
                    csv2tex_single_fallback "$csv_file" "$compiled_file" "$caption_file"
                fi
                ;;

            *)
                # Use fallback AWK processing
                csv2tex_single_fallback "$csv_file" "$compiled_file" "$caption_file"
                ;;
        esac
    done
}

function csv2tex_single_fallback() {
    # Basic CSV processing for a single file (fallback method)
    local csv_file="$1"
    local compiled_file="$2"
    local caption_file="$3"

    base_name=$(basename "$csv_file" .csv)
    # Extract table number from filename like 01_seizure_count
    if [[ "$base_name" =~ ^([0-9]+)_ ]]; then
        table_number="${BASH_REMATCH[1]}"
        table_clean_name="${base_name#*_}"
    else
        table_number="$base_name"
        table_clean_name="$base_name"
    fi

    # Pre-check CSV for problematic characters
    check_csv_for_special_chars "$csv_file"

    # Basic AWK processing (existing code)
    num_columns=$(head -n 1 "$csv_file" | awk -F, '{print NF}')
    num_rows=$(wc -l < "$csv_file")
    max_rows=30

    # Use standard font size for tables
    # Standard academic paper convention: \footnotesize (8pt) for tables
    fontsize="\\footnotesize"

    # Check if truncation needed
    truncated=false
    if [ $num_rows -gt $((max_rows + 1)) ]; then  # +1 for header
        truncated=true
        rows_omitted=$((num_rows - max_rows - 1))
    fi

    {
        echo "\\pdfbookmark[2]{Table ${table_number#0}}{table_${base_name}}"
        echo "\\begin{table}[htbp]"
        echo "\\centering"
        echo "$fontsize"
        
        # Adjust tabcolsep based on number of columns to fit width
        if [ $num_columns -gt 8 ]; then
            echo "\\setlength{\\tabcolsep}{2pt}"  # Very tight for many columns
        elif [ $num_columns -gt 6 ]; then
            echo "\\setlength{\\tabcolsep}{3pt}"  # Tight spacing
        elif [ $num_columns -gt 4 ]; then
            echo "\\setlength{\\tabcolsep}{4pt}"  # Medium spacing
        else
            echo "\\setlength{\\tabcolsep}{6pt}"  # Normal spacing
        fi
        
        # Use resizebox to ensure table fits within text width
        echo "\\resizebox{\\textwidth}{!}{%"
        echo "\\begin{tabular}{*{$num_columns}{l}}"
        echo "\\toprule"

        # Simple header processing
        head -n 1 "$csv_file" | awk -F, '{
            for (ii=1; ii<=NF; ii++) {
                val = $ii
                gsub(/[_]/, "\\\\_", val)
                printf("\\textbf{%s}", val)
                if (ii < NF) printf(" & ")
            }
            print "\\\\"
        }'

        echo "\\midrule"

        # Process data with potential truncation
        if [ "$truncated" = true ]; then
            # Show first max_rows-2 rows
            tail -n +2 "$csv_file" | head -n $((max_rows - 2)) | awk -F, '{
                for (i=1; i<=NF; i++) {
                    val = $i
                    gsub(/[_]/, "\\\\_", val)
                    printf("%s", val)
                    if (i < NF) printf(" & ")
                }
                print "\\\\"
            }'

            # Add truncation indicator
            echo "\\midrule"
            echo "\\multicolumn{$num_columns}{c}{\\textit{... $rows_omitted rows omitted ...}} \\\\"
            echo "\\midrule"

            # Show last 2 rows
            tail -n 2 "$csv_file" | awk -F, '{
                for (i=1; i<=NF; i++) {
                    val = $i
                    gsub(/[_]/, "\\\\_", val)
                    printf("%s", val)
                    if (i < NF) printf(" & ")
                }
                print "\\\\"
            }'
        else
            # Simple data processing without truncation
            tail -n +2 "$csv_file" | awk -F, '{
                for (i=1; i<=NF; i++) {
                    val = $i
                    gsub(/[_]/, "\\\\_", val)
                    printf("%s", val)
                    if (i < NF) printf(" & ")
                }
                print "\\\\"
            }'
        fi

        echo "\\bottomrule"
        echo "\\end{tabular}"
        echo "}"  # Close resizebox
        
        if [ -f "$caption_file" ] || [ -L "$caption_file" ]; then
            if [ "$truncated" = true ]; then
                # Add truncation note to caption
                cat "$caption_file" | sed 's/}$//'
                echo "\\textit{Note: Table truncated to $max_rows rows from $num_rows total rows for display purposes.}}"
            else
                cat "$caption_file"
            fi
        else
            echo "\\caption{Table ${table_number#0}: ${table_clean_name//_/ }"
            if [ "$truncated" = true ]; then
                echo "\\textit{Note: Table truncated to $max_rows rows from $num_rows total rows for display purposes.}"
            fi
            echo "}"
        fi

        echo "\\label{tab:${base_name}}"
        echo "\\end{table}"
    } > "$compiled_file"

    echo_info "    $compiled_file compiled (using fallback)"
}

function csv2tex_fallback() {
    # Process all CSV files with fallback method
    for csv_file in "$STXW_TABLE_CAPTION_MEDIA_DIR"/[0-9]*.csv; do
        [ -e "$csv_file" ] || continue
        base_name=$(basename "$csv_file" .csv)
        caption_file="${STXW_TABLE_CAPTION_MEDIA_DIR}/${base_name}.tex"
        compiled_file="$STXW_TABLE_COMPILED_DIR/${base_name}.tex"
        csv2tex_single_fallback "$csv_file" "$compiled_file" "$caption_file"
    done
}

function create_table_header() {
    # Create a header/template table when no real tables exist
    local header_file="$STXW_TABLE_COMPILED_DIR/00_Tables_Header.tex"

    cat > "$header_file" << 'EOF'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% \clearpage
\section*{Tables}
\label{tables}
\pdfbookmark[1]{Tables}{tables}

% Template table when no actual tables are present
\begin{table}[htbp]
    \centering
    \caption{\textbf{Table 0: Placeholder}\\
    \smallskip
    To add tables to your manuscript:\\
    1. Place CSV files in \texttt{caption\_and\_media/} with format \texttt{XX\_description.csv}\\
    2. Create matching caption files \texttt{XX\_description.tex}\\
    3. Reference in text using \texttt{Table\textasciitilde\textbackslash ref\{tab:XX\_description\}}\\
    \smallskip
    Example: \texttt{01\_seizure\_count.csv} with \texttt{01\_seizure\_count.tex}
    }
    \label{tab:0_Tables_Header}
    \begin{tabular}{p{0.3\textwidth}p{0.6\textwidth}}
        \toprule
        \textbf{Step} & \textbf{Instructions} \\
        \midrule
        1. Add CSV & Place file like \texttt{01\_data.csv} in \texttt{caption\_and\_media/} \\
        2. Add Caption & Create \texttt{01\_data.tex} with table caption \\
        3. Compile & Run \texttt{./compile -m} to process tables \\
        4. Reference & Use \texttt{\textbackslash ref\{tab:01\_data\}} in manuscript \\
        \bottomrule
    \end{tabular}
\end{table}
EOF
    echo_info "    Created table header template with instructions"
}

function gather_table_tex_files() {
    # Gather all table tex files into the final compiled file
    output_file="${STXW_TABLE_COMPILED_FILE}"
    rm -f "$output_file" > /dev/null 2>&1
    echo "% Auto-generated file containing all table inputs" > "$output_file"
    echo "% Generated by gather_table_tex_files()" >> "$output_file"
    echo "" >> "$output_file"

    # First check if there are any real table files
    local table_files=($(find "$STXW_TABLE_COMPILED_DIR" -maxdepth 1 -name "[0-9]*.tex" 2>/dev/null | grep -v "00_Tables_Header.tex" | sort))
    local has_real_tables=false
    if [ ${#table_files[@]} -gt 0 ]; then
        has_real_tables=true
        # Don't add anything here - base.tex handles the section header and spacing
    fi

    # If no real tables, create the header/template
    if [ "$has_real_tables" = false ]; then
        create_table_header
    fi

    # Count available tables
    table_count=0
    for table_tex in $(find "$STXW_TABLE_COMPILED_DIR" -name "[0-9]*.tex" 2>/dev/null | sort); do
        if [ -f "$table_tex" ] || [ -L "$table_tex" ]; then
            # Skip header if we have real tables
            local basename=$(basename "$table_tex")
            if [[ "$basename" == "00_Tables_Header.tex" ]] && [ "$has_real_tables" = true ]; then
                continue
            fi

            # For header template when no real tables exist
            if [[ "$basename" == "00_Tables_Header.tex" ]] && [ "$has_real_tables" = false ]; then
                echo "\\input{$table_tex}" >> "$output_file"
            else
                # For real tables, input them directly
                echo "% Table from: $basename" >> "$output_file"
                echo "\\input{$table_tex}" >> "$output_file"
            fi
            echo "" >> "$output_file"
            table_count=$((table_count + 1))
        fi
    done

    if [ $table_count -eq 0 ]; then
        echo_warning "    No tables were found to compile."
    else
        echo_success "    $table_count tables compiled"
    fi
}

# Main execution
init_tables
xlsx2csv_convert  # Convert Excel files to CSV first
ensure_caption
csv2tex
gather_table_tex_files

# EOF
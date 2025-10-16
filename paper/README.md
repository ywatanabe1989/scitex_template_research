<!-- ---
!-- Timestamp: 2025-09-30 22:06:02
!-- Author: ywatanabe
!-- File: /ssh:sp:/home/ywatanabe/proj/neurovista/paper/README.md
!-- --- -->

# SciTeX Writer - Research Paper Template

LaTeX compilation system with predefined project structure

> **Note**: This directory contains a template for writing research manuscripts. All content files have been converted to templates with self-descriptive placeholder text and structure guides. Replace the bracketed placeholder text with your actual content.

## Quick Start

Before writing, update these key files with your information:

1. **Metadata** (in `shared/`):
   - `title.tex` - Your paper title
   - `authors.tex` - Author names and affiliations
   - `keywords.tex` - 3-6 keywords for your paper
   - `journal_name.tex` - Target journal name

2. **Content** (in `01_manuscript/contents/`):
   - `abstract.tex` - 150-300 word abstract
   - `introduction.tex` - Background, gaps, and objectives
   - `methods.tex` - Detailed methodology
   - `results.tex` - Findings with figures and tables
   - `discussion.tex` - Interpretation and implications
   - `highlights.tex` - 3-5 bullet points (85 chars max each)
   - `data_availability.tex` - Data and code availability statement

3. **Media**:
   - Add figures to `01_manuscript/contents/figures/caption_and_media/`
   - Add tables (`.xlsx` or `.csv`) to `01_manuscript/contents/tables/caption_and_media/`
   - Update `shared/bib_files/bibliography.bib` with your references

Each `.tex` file contains structure guides and examples to help you write effectively.

## Usage

### Main Files for Writing Your Manuscript

1. **Text**: Edit `.tex` files in `01_manuscript/contents/`
   - `abstract.tex`, `introduction.tex`, `methods.tex`, `results.tex`, `discussion.tex`
2. **Figures**: Place images in `01_manuscript/contents/figures/caption_and_media/`
   - Supports: `.jpg`, `.png`, `.tif`, `.mmd` (Mermaid diagrams)
   - Auto-converts to required formats during compilation
3. **Tables**: Place `.xlsx` or `.csv` files in `01_manuscript/contents/tables/caption_and_media/`
   - Auto-converts to LaTeX tables during compilation
4. **References**: Update `shared/bib_files/bibliography.bib` (shared across all documents)
5. **Metadata**: Edit `shared/title.tex`, `shared/authors.tex`, `shared/keywords.tex`

### Compilation

```bash
# Compile manuscript (default)
./compile

# Or explicitly specify document type
./compile -m                    # manuscript
./compile -s                    # supplementary materials
./compile -r                    # revision responses

# Watch mode (auto-recompile on file changes)
./compile -m -w

# Output:
# - 01_manuscript/manuscript.pdf (main document)
# - 01_manuscript/manuscript_diff.pdf (tracked changes)
```

## Installation

```bash
# Check requirements
$ ./scripts/installation/check_requirements.sh

# Optional: Download all containers upfront (~3.2GB total)
$ ./scripts/installation/download_containers.sh
```

## Project Structure

```
paper/
├── compile                         # Unified compilation interface
├── config/                         # YAML configurations
├── shared/                         # Common files (single source of truth)
│   ├── bib_files/                  # Bibliography files
│   │   └── bibliography.bib        # References
│   ├── authors.tex                 # Author list
│   ├── title.tex                   # Paper title
│   ├── journal_name.tex            # Target journal
│   ├── keywords.tex                # Keywords
│   └── latex_styles/               # LaTeX formatting
├── scripts/
│   ├── installation/               # Setup scripts
│   ├── python/                     # Python tools
│   │   └── explore_bibtex.py       # Bibliography analysis
│   └── shell/                      # Shell scripts
│       ├── compile_manuscript      # Manuscript compiler
│       ├── compile_supplementary   # Supplementary compiler
│       ├── compile_revision        # Revision compiler
│       └── modules/                # Compilation modules
├── 01_manuscript/
│   ├── contents/                   # Document-specific content
│   │   ├── abstract.tex            # Abstract
│   │   ├── introduction.tex        # Introduction
│   │   ├── methods.tex             # Methods
│   │   ├── results.tex             # Results
│   │   ├── discussion.tex          # Discussion
│   │   ├── figures/                # Figure files
│   │   ├── tables/                 # Table files
│   │   └── [symlinks to shared/]   # Metadata & styles
│   ├── manuscript.pdf              # Output PDF
│   ├── manuscript_diff.pdf         # Changes tracking
│   └── logs/                       # Compilation logs
├── 02_supplementary/               # Supplementary materials
└── .cache/containers/              # Auto-downloaded containers
```

## Features

- **Container-based**: Consistent compilation across systems
- **Auto-fallback**: Native → Container → Module system
- **Version tracking**: Automatic versioning with diff generation
- **Mermaid support**: `.mmd` files auto-convert to images
- **Image processing**: Automatic format conversion via ImageMagick
- **HPC-ready**: Project-local containers for compute clusters
- **Bibliography analysis**: Identify high-impact papers to cite with `explore_bibtex.py`

<details>
<summary>Reference Tips</summary>

### 1. Get BibTeX file from AI2
Access [AI2 Asta](https://asta.allen.ai/chat/) and download BibTeX file for your query by clicking `Export All Citations`.

### 2. Find related articles published by co-authors

``` bash
python ./scripts/python/generate_ai2_prompt.py --type coauthors

# This will generate a prompt based on your manuscript's title, keywords, authors, and abstract
# Copy the output and paste it into AI2 Asta to find related papers by your co-authors
# Then click 'Export All Citations' to download the BibTeX file
```


## Bibliography Analysis Tool

The `explore_bibtex.py` script helps analyze and filter BibTeX files enriched with citation counts and journal impact factors:

```bash
# Find high-impact uncited papers (score = citations + IF×10)
./scripts/python/explore_bibtex.py \
	shared/bib_files/bibliography.bib \
    --uncited --min-score 150 --limit 10

# Filter by keyword and metrics
./scripts/python/explore_bibtex.py \
	shared/bib_files/bibliography.bib \
    --keyword "seizure prediction" --min-citations 100 --year-min 2015

# Show statistics about your bibliography
./scripts/python/explore_bibtex.py \
	shared/bib_files/bibliography.bib --stats

# Find recent high-impact papers (2020+, IF > 5.0)
./scripts/python/explore_bibtex.py \
	shared/bib_files/bibliography.bib \
    --year-min 2020 --min-if 5.0 --limit 10

# Compare against cited papers in manuscript
./scripts/python/explore_bibtex.py \
	shared/bib_files/bibliography.bib \
    --cited --sort citation_count --reverse

# Export filtered subset to new .bib file
./scripts/python/explore_bibtex.py \
	shared/bib_files/bibliography.bib \
    --min-if 5.0 --min-citations 50 --output high_impact.bib
```

**Available filters:**
- `--min-citations N` / `--max-citations N` - Citation count range
- `--min-if X` / `--max-if X` - Journal impact factor range
- `--min-score X` - Minimum composite score (citations + IF×10)
- `--year-min Y` / `--year-max Y` - Publication year range
- `--keyword "text"` - Search in title/abstract/keywords
- `--journal "name"` - Filter by journal (partial match)
- `--author "name"` - Filter by author (partial match)
- `--cited` / `--uncited` - Compare with manuscript citations
- `--sort FIELD` - Sort by: citation_count, journal_impact_factor, year, title, score
- `--reverse` - Sort descending
- `--stats` - Show summary statistics
- `--limit N` - Maximum papers to display
- `--output FILE` - Export filtered results to .bib file

</details>

## Troubleshooting

| Issue                   | Solution                                |
|-------------------------|-----------------------------------------|
| "command not found"     | Containers will handle it automatically |
| Chrome/Puppeteer errors | Mermaid container includes Chromium     |
| First run slow          | Downloading containers (~3GB one-time)  |

## Configuration

The system uses YAML configuration files in `config/`:
- `config_manuscript.yaml` - Manuscript compilation settings
- `config_supplementary.yaml` - Supplementary materials settings
- `config_revision.yaml` - Revision response settings

## For AI Agents

See [AI_AGENT_GUIDE.md](./AI_AGENT_GUIDE.md) for automated manuscript generation from research projects.

## Contact

Yusuke Watanabe (ywatanabe@scitex.ai)

<!-- EOF -->
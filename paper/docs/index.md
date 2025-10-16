# SciTeX Writer Documentation

LaTeX compilation system with predefined project structure for scientific manuscripts.

## Overview

SciTeX Writer is a comprehensive LaTeX-based manuscript preparation system designed for researchers and scientists. It provides:

- **Container-based compilation** for consistent results across systems
- **Automated document management** with version tracking
- **Multi-document support** (manuscript, supplementary materials, revision letters)
- **Bibliography analysis tools** for finding high-impact references
- **Mermaid diagram support** with automatic conversion
- **Image processing** with automatic format conversion

## Quick Start

### Main Files for Writing

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

## Features

- **Container-based**: Consistent compilation across systems
- **Auto-fallback**: Native → Container → Module system
- **Version tracking**: Automatic versioning with diff generation
- **Mermaid support**: `.mmd` files auto-convert to images
- **Image processing**: Automatic format conversion via ImageMagick
- **HPC-ready**: Project-local containers for compute clusters
- **Bibliography analysis**: Identify high-impact papers to cite

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

## Additional Documentation

```{toctree}
:maxdepth: 2
:caption: Guides

QUICK_REFERENCE.md
AI_AGENT_GUIDE.md
FIGURE_TABLE_GUIDE.md
MULTIPANEL_FIGURE_GUIDE.md
CROSS_REFERENCING.md
USAGE_FOR_LLM.md
```

## Contact

Yusuke Watanabe (ywatanabe@scitex.ai)

## GitHub Repository

[SciTeX-Writer on GitHub](https://github.com/ywatanabe1989/SciTeX-Writer)

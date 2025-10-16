<!-- ---
!-- Timestamp: 2025-09-27 15:35:10
!-- Author: ywatanabe
!-- File: /ssh:sp:/home/ywatanabe/proj/neurovista/paper/01_manuscript/README.md
!-- --- -->

# Manuscript

This directory contains the main manuscript files and compilation outputs.

## Quick Start

From the paper root directory:
```bash
# Basic compilation (no figures)
./compile_manuscript

# Full compilation with figures
./compile_manuscript -f

# Quiet mode (minimal output)
./compile_manuscript -q

# All options
./compile_manuscript -f -p2t -c -q
```

## Directory Structure

```
01_manuscript/
├── base.tex                  # Main LaTeX document
├── contents/
│   ├── figures/
│   │   ├── caption_and_media/   # Place figure files here
│   │   └── captions/            # Figure captions (auto-generated)
│   ├── tables/
│   │   ├── caption_and_media/   # Place table files here
│   │   └── captions/            # Table captions (auto-generated)
│   ├── latex_styles/            # LaTeX packages and formatting
│   ├── abstract.tex
│   ├── introduction.tex
│   ├── methods.tex
│   ├── results.tex
│   ├── discussion.tex
│   └── conclusion.tex
├── archive/                    # Version history
├── logs/                       # Compilation logs
└── docs/                       # Documentation
```

## Output Files

After successful compilation:
- `manuscript.pdf` - Final compiled manuscript
- `manuscript.tex` - Processed LaTeX source
- `manuscript_diff.pdf` - PDF showing changes (when diff enabled)
- `manuscript_diff.tex` - LaTeX with change tracking

## Adding Figures

1. Place figure files in `contents/figures/caption_and_media/`
2. Use naming convention: `.NN_description.ext`
   - NN: Two-digit number (01, 02, ...)
   - description: Brief description (optional)
   - ext: png, jpg, tif, svg, mmd (Mermaid), pptx

Example: `.01_workflow.png`

Missing figures automatically generate placeholder images with instructions.

## Adding Tables

1. Place table files in `contents/tables/caption_and_media/`
2. Use naming convention: `.NN_description.tex`

## Compilation Options

- `-f, --figs` - Process and include figures
- `-p2t, --ppt2tif` - Convert PowerPoint slides to TIF format (WSL)
- `-c, --crop_tif` - Auto-crop TIF images to remove whitespace
- `-q, --quiet` - Suppress detailed LaTeX compilation output
- `-h, --help` - Show help message

## Troubleshooting

- Check `logs/global.log` for compilation errors
- Ensure all symlinks in `contents/` are properly set
- Verify LaTeX container is available (Apptainer/Singularity)

<!-- EOF -->
# Shared Resources

This directory contains files that are shared across all document types (manuscript, supplementary, revision) via symlinks.

## What's Shared

### Metadata (same across all documents)
- `authors.tex` - Author names and affiliations
- `title.tex` - Paper title
- `journal_name.tex` - Target journal
- `keywords.tex` - Keywords for indexing

### References
- `bibliography.bib` - All citations (single source of truth)

### Formatting
- `latex_styles/` - LaTeX packages and formatting rules
  - `packages.tex` - Package imports
  - `formatting.tex` - Document formatting
  - `columns.tex` - Column layout
  - `bibliography.tex` - Bibliography style
  - `linker.tex` - Cross-references setup

## What's NOT Shared (document-specific)

Each document type maintains its own:
- Abstract (may differ for supplementary)
- Main content sections (intro, methods, results, discussion)
- Figures and tables (though some may be symlinked)
- Word count requirements

## Benefits

1. **Consistency**: Metadata identical across documents
2. **Efficiency**: Update once, applies everywhere
3. **Maintainability**: Clear separation of shared vs specific
4. **Version control**: Single source reduces merge conflicts

## Usage

Files in this directory are automatically used by all documents through symlinks. 
Edit these files directly - changes will reflect in all documents on next compilation.

<!-- EOF -->
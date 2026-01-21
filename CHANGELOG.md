# Changelog

All notable changes to the SciTeX Research Template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive README with collapsible sections
- Documentation for `scitex.io` and `scitex.session` core modules
- Symlink architecture documentation (environment, AI prompts, writer, script outputs)
- Writer setup guidance with `make setup-writer`
- CHANGELOG.md for tracking changes

### Changed
- `scitex/writer/` is now cloned on-demand via `make setup-writer` (not included in template)
- Removed noisy directories: `scitex/vis/{metadata,panels,pinned,previews}`
- Updated project structure documentation
- Improved Makefile with cleaner target organization

### Removed
- Pre-included `scitex/writer/` content (now cloned independently)
- Unused `.gitkeep` files in cleaned directories

## [0.1.0] - 2024-11-18

### Added
- Initial template structure
- MNIST example pipeline (01_download through 05_plot_conf_mat)
- Script template (`scripts/template.py`) with `@stx.session` decorator
- Makefile with setup, run, test, and clean targets
- SciTeX directory structure (`scitex/{writer,scholar,vis,code,ai,uploads}`)
- Configuration files (`config/PATH.yaml`, `config/MNIST.yaml`)
- Test infrastructure (`tests/`)
- Management scripts (`management/scripts/`)

### Dependencies
- scitex >= 2.0.0
- Python >= 3.10

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 0.1.0 | 2024-11-18 | Initial release with MNIST example |

## Links

- [SciTeX Documentation](https://scitex.ai)
- [SciTeX GitHub](https://github.com/ywatanabe1989/scitex-python)
- [Template Repository](https://github.com/ywatanabe1989/scitex-research-template)

# Quick Start Guide for SciTeX Writer Template

## What is This?

This directory contains a complete template for writing scientific research manuscripts. All `.tex` files include:
- **Structure guides** explaining what to write in each section
- **Examples** showing effective formatting
- **Placeholders** (in `[brackets]`) that you should replace with your content

## Getting Started (5 Steps)

### Step 1: Update Metadata (5 minutes)

Navigate to `shared/` and edit these files:

```bash
# Your paper title
vim shared/title.tex

# Author names and affiliations
vim shared/authors.tex

# 3-6 keywords for your paper
vim shared/keywords.tex

# Target journal
vim shared/journal_name.tex
```

### Step 2: Write Your Abstract (30-60 minutes)

Edit `01_manuscript/contents/abstract.tex`:
- Follow the 7-part structure in the comments
- Keep it 150-300 words
- Include specific quantitative results
- Write as one continuous paragraph

### Step 3: Fill in Main Sections (varies)

Edit these files in `01_manuscript/contents/`:

```bash
# Background and objectives (1000-2000 words)
vim introduction.tex

# Reproducible procedures (1000-2000 words)
vim methods.tex

# Findings with figures/tables (varies)
vim results.tex

# Interpretation and implications (1000-2000 words)
vim discussion.tex
```

Each file contains:
- **Detailed instructions** at the top (in comments)
- **Section templates** showing what to write
- **Placeholder text** to replace

### Step 4: Add Supporting Content

```bash
# 3-5 bullet points (85 chars each)
vim 01_manuscript/contents/highlights.tex

# Data and code availability
vim 01_manuscript/contents/data_availability.tex
```

### Step 5: Add Figures, Tables, and References

```bash
# Add your figure files (.png, .jpg, .mmd)
cp your_figures/* 01_manuscript/contents/figures/caption_and_media/

# Add your table files (.xlsx, .csv)
cp your_tables/* 01_manuscript/contents/tables/caption_and_media/

# Update bibliography
vim shared/bib_files/bibliography.bib
```

## Compiling Your Manuscript

```bash
# Compile manuscript
./compile

# Compile in watch mode (auto-recompile on changes)
./compile -m -w

# Your PDF will be at:
# 01_manuscript/manuscript.pdf
```

## Understanding the Template Structure

### Abstract Structure (7 parts)
1. **Basic Introduction**: Introduce the field broadly
2. **Detailed Background**: Provide context for specialists
3. **General Problem**: State what's unknown/lacking
4. **Main Result**: "Here we show that..."
5. **Results with Comparisons**: Specific findings vs. prior work
6. **General Context**: Broader significance
7. **Broader Perspective**: Future impact (optional)

### Introduction Structure (6 paragraphs)
1. **Problem Statement**: Importance and impact
2. **Current Knowledge**: What's known, with citations
3. **Knowledge Gap**: What's missing or limited
4. **Your Approach**: Your method and its advantages
5. **Objectives**: Hypotheses and specific aims
6. **Preview** (optional): Brief summary of main results

### Methods Structure
- **Ethics**: IRB approval, consent
- **Dataset/Study Design**: Data source, sample size
- **Data Processing**: Preprocessing steps
- **Feature Extraction**: How you derived features
- **Statistical Analysis**: Tests and significance thresholds
- **ML Methods** (if applicable): Algorithms and validation
- **Software**: Tools used, reproducibility measures

### Results Structure
- **Dataset Characteristics**: Sample properties with stats
- **Main Findings**: Primary results organized by topic
- **Performance/Validation**: Model performance metrics
- **Additional Analyses**: Secondary findings

### Discussion Structure (8 paragraphs)
1. **Summary**: Restate key findings
2-3. **Interpretation**: Compare with literature, explain mechanisms
4. **Strengths**: What makes your study unique
5. **Limitations**: Honest acknowledgment
6. **Implications**: Practical and theoretical impact
7. **Future Directions**: Next steps and open questions
8. **Conclusion**: Strong closing statement

## Tips for Success

### Writing Style
- **Tense**:
  - Present tense for general facts (supported by multiple studies)
  - Past tense for specific prior studies
  - Past tense for your results
- **Specificity**: Always include numbers (e.g., "increased by 23%" not "increased")
- **Clarity**: Use technical terms but spell out acronyms on first use
- **Flow**: Use transition phrases between paragraphs

### Using the Templates
- **Read the guides first**: Understand the structure before writing
- **Replace placeholders**: Search for `[` to find all placeholders
- **Keep or remove guides**: Keep commented sections for reference or delete after reading
- **Follow examples**: The example structures show effective patterns

### Common Mistakes to Avoid
- ❌ Leaving placeholder text like `[Your Title]` in final version
- ❌ Ignoring the structure guides
- ❌ Writing in wrong tense (e.g., present tense for your specific results)
- ❌ Forgetting to add quantitative details
- ❌ Not citing prior work appropriately

## Getting Help

### Documentation
- `README.md` - Overview and compilation instructions
- `docs/TEMPLATE_CONVERSION_SUMMARY.md` - Detailed change log
- Each `.tex` file - Inline instructions and examples

### Troubleshooting
- **Compilation errors**: Check `01_manuscript/logs/` for error messages
- **Missing commands**: The compilation system uses containers, it will auto-download needed tools
- **Format questions**: Check the comments in each `.tex` file for guidance

### Resources
- AI2 Asta for finding related papers: https://asta.allen.ai/chat/
- Bibliography analysis: `./scripts/python/explore_bibtex.py --help`
- SciTeX documentation: (see project documentation)

## Example Workflow

1. **Day 1**: Update metadata, draft abstract structure
2. **Day 2-3**: Write introduction (background, gaps, objectives)
3. **Day 4-5**: Write methods (detailed procedures)
4. **Day 6-8**: Write results (findings with figures/tables)
5. **Day 9-10**: Write discussion (interpretation, implications)
6. **Day 11**: Polish abstract, write highlights, data availability
7. **Day 12**: Final review, compile, check PDF
8. **Day 13+**: Iterate based on co-author feedback

## Next Steps

1. ✅ Read this guide
2. ✅ Update metadata files
3. ✅ Start with abstract (it helps clarify your message)
4. ✅ Work through sections systematically
5. ✅ Compile frequently to check formatting
6. ✅ Get feedback from colleagues
7. ✅ Polish and submit!

---

**Remember**: Good scientific writing is iterative. Don't expect perfection on the first draft. Use this template as a scaffold to organize your thoughts, then refine through multiple passes.

Good luck with your manuscript! 🎓📝

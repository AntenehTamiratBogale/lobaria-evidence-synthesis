# Lobaria evidence synthesis

Reproducible R workflows for screening literature and extracting evidence on light and nitrogen responses in *Lobaria pulmonaria*.

## Purpose and relationship to existing research

This project extends the literature context of the experimental study represented in [lobaria-light-nitrogen](https://github.com/AntenehTamiratBogale/lobaria-light-nitrogen). It has its own protocol and data workflow. It does not change the experimental analyses or imply that this literature synthesis was part of the submitted manuscript.

Development started on 19 October 2026. Status: protocol and record-preparation workflow; no screened corpus, trained classifier, LLM evaluation or synthesis results yet. Code and documentation were developed with AI assistance; the researcher must review code, make screening decisions and verify findings.

## Research question

How do light availability and nitrogen enrichment affect the physiology, symbiotic partners and microbial communities of *Lobaria pulmonaria*?

See [the draft protocol](protocol.md) before collecting records.

## Start in RStudio

1. Download or clone this repository and open its folder as your RStudio working directory.
2. Export search results as a UTF-8 CSV with columns `title,abstract,doi,year,source,source_id`.
3. Save the file as `data/raw/records.csv`. Use one row per record; missing values may be blank.
4. Run `source("R/01_prepare_records.R")`.
5. Inspect `data/processed/duplicate_candidates.csv` before resolving duplicate records.
6. Screen titles and abstracts in `data/processed/screening.csv`. Keep the original export and never overwrite completed screening with a new run.

The first script uses base R and requires no additional packages. Raw records and generated files are ignored by Git to avoid inadvertently publishing licensed abstracts or reviewer data. Share bibliographic metadata only when source terms allow it.

## Planned stages

- Search documentation, import and duplicate review.
- Human title/abstract screening, followed by full-text eligibility assessment.
- TF-IDF baseline classifier after sufficient human labels exist.
- LLM-assisted screening and structured extraction.
- Held-out evaluation, error analysis and a reproducible report.

Machine learning and LLM stages are not implemented yet. Automated suggestions will be evaluated against human judgments; they will not silently exclude records.

## Current validation

The initial script has not yet been executed in R. Validate it with a small export before using it on the full corpus.
